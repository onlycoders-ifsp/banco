CREATE OR REPLACE FUNCTION FN_RETORNA_PRODUTO(P_ID_USUARIO TEXT, P_ID_PRODUTO TEXT, OP INT, P_ID_CATEGORIA INT DEFAULT 0, P_USUARIO TEXT DEFAULT '')
    RETURNS SETOF RECORD AS $$
BEGIN

    IF P_ID_USUARIO = '0' THEN
        P_ID_USUARIO := NULL;
    END IF;

    IF P_ID_PRODUTO = '0' THEN
        P_ID_PRODUTO := NULL;
    END IF;

    IF P_ID_CATEGORIA = 0 THEN
        P_ID_CATEGORIA := NULL;
    END IF;

    RETURN QUERY
        SELECT
            CAST(U.ID_USUARIO AS TEXT),
            CAST(P.ID_PRODUTO AS TEXT),
            CAST(P.NOME AS TEXT),
            CAST(P.DESCRICAO_CURTA AS TEXT),
            CAST(P.DESCRICAO AS TEXT),
            CAST(P.VALOR_BASE_DIARIA AS DECIMAL(16,2)),
            CAST(P.VALOR_BASE_MENSAL AS DECIMAL(16,2)),
            CAST(P.VALOR_PRODUTO AS DECIMAL(16,2)),
            TO_CHAR(P.DATA_COMPRA,'YYYY-MM-DD'),
            CAST(CASE
                     WHEN AA.QtdAlugueis IS NULL THEN 0
                     ELSE AA.QtdAlugueis
                END AS NUMERIC(16)),
            CAST(CASE
                     WHEN AA.TotalGanhos IS NULL THEN 0
                     ELSE AA.TotalGanhos
                END AS DECIMAL(16,2)),
            CAST((SELECT FN_RETORNA_MEDIA_AVALIACAO(P.ID_PRODUTO,1)) AS DECIMAL(2,1)),
                 (SELECT FN_RETORNA_DATAS_ALUGUEIS_EFTUADOS(P.ID_PRODUTO)) DT_ALUGUEL,
                 (SELECT FN_RETORNA_CATEGORIAS(P.ID_PRODUTO)) CATEGORIAS,
                 P.CAPA_FOTO,
                 P.ATIVO,
                 P.PUBLICADO
                 FROM PRODUTOS P
                 INNER JOIN USUARIOS U
                 ON P.ID_USUARIO = U.ID_USUARIO
                 LEFT JOIN (SELECT A.ID_PRODUTO, COUNT(1) QtdAlugueis, SUM(A.VALOR_DEBITO) TotalGanhos
                            FROM ALUGUEIS A
                            GROUP BY A.ID_PRODUTO) AA
                 ON AA.ID_PRODUTO = P.ID_PRODUTO
                 WHERE (((P_ID_PRODUTO IS NULL AND U.ID_USUARIO = UUID(P_ID_USUARIO)) AND OP = 1) --Todos os produtos ativo do usuario
                OR (P.ATIVO AND NOT P.PUBLICADO AND (CASE WHEN P_ID_USUARIO IS NULL THEN '0' ELSE P_ID_USUARIO END <> CAST(P.ID_USUARIO AS TEXT)) AND OP = 2) --Produtos não publicados
                OR (P.ATIVO AND P.PUBLICADO AND (LOWER(P.NOME) LIKE CONCAT('%',LOWER(P_ID_PRODUTO),'%')) AND OP = 3) --Pesquisa de produto pelo id ou nome
                OR (P.ATIVO AND P.PUBLICADO AND (CASE WHEN P_ID_USUARIO IS NULL THEN '0' ELSE P_ID_USUARIO END <> CAST(P.ID_USUARIO AS TEXT)) AND OP = 4) --Retorna todos os produtos que estão ativo E PUBLICADOS
                OR (NOT P.ATIVO AND (P_ID_PRODUTO IS NULL AND U.ID_USUARIO = UUID(P_ID_USUARIO)) AND OP = 5)
                OR (CAST(P.ID_PRODUTO AS TEXT) = P_ID_PRODUTO AND OP = 6) --Retorna produtos para histórico(alugueis)
                     OR (CAST(P.ID_PRODUTO AS TEXT) = P_ID_PRODUTO AND OP = 7)) --Pesquisa de produto pelo id ou nome
                           AND EXISTS(SELECT 1 FROM CATEGORIA_PRODUTO CP
                                      WHERE CP.ID_PRODUTO = P.ID_PRODUTO
                                        AND (CP.ID_CATEGORIA = P_ID_CATEGORIA OR P_ID_CATEGORIA IS NULL));

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR PRODUTO', SQLSTATE, SQLERRM, 'FN_RETORNA_PRODUTO', 'PRODUTOS/USUARIOS', CURRENT_QUERY(),P_USUARIO);

END;
$$ LANGUAGE PLPGSQL;