CREATE OR REPLACE FUNCTION FN_INSERE_PROBLEMA(P_ID_ALUGUEL TEXT,P_ID_USUARIO TEXT, P_PROBLEMA INT, P_DESCRICAO TEXT)
    RETURNS BOOLEAN
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    INSERT INTO PROBLEMAS(ID_ALUGUEL, COD_TIPO_PROBLEMA, COD_STATUS_PROBLEMA, DESCRICAO, SOLICITANTE, valor_locador, valor_locatario, id_solicitante)
    SELECT
        UUID(P_ID_ALUGUEL),
        P_PROBLEMA, --TIPO
        --3, --GRAVIDADE
        --VALOR_ALUGUEL,
        1, --STATUS
        P_DESCRICAO,
        CASE
            WHEN UUID(P_ID_USUARIO) = A.ID_USUARIO
                THEN  'L' --LOCATÁRIO
            WHEN UUID(P_ID_USUARIO) = P.ID_USUARIO
                THEN 'D' --DONO(LOCADOR)
            END,
        --cast((case when abs(perc_locador) >= 1 then perc_locador else case when tp.perc_locador < 0 then -1 else 1 end - tp.perc_locador end) *
        cast((case when abs(perc_locador) >= 1 then perc_locador else tp.perc_locador end) *
        case tp.base_calculo
            when 1 then p.valor_produto
            when 2 then (a.valor_aluguel / DATE_PART('day', a.data_fim - a.data_inicio))
            --when 3 then ((100-case g.devolucao when null then 100 else g.devolucao end) * p.valor_produto)
            when 3 then p.valor_produto
            WHEN 4 THEN A.valor_aluguel
        end as decimal(18,2)) Valor_Locador,
        --cast((case when abs(perc_locatario) >= 1 then perc_locatario else case when tp.perc_locatario < 0 then -1 else 1 end - tp.perc_locatario end) *
        cast((case when abs(perc_locatario) >= 1 then perc_locatario else tp.perc_locatario end) *
        case tp.base_calculo
            when 1 then p.valor_produto
            when 2 then (a.valor_aluguel / DATE_PART('day', a.data_fim - a.data_inicio))
            --when 3 then ((100-case g.devolucao when null then 100 else g.devolucao end) * p.valor_produto)
            when 3 then p.valor_produto
            WHEN 4 THEN A.valor_aluguel
        end as decimal(18,2)) Valor_Locatario,
		UUID(P_ID_USUARIO)
    FROM ALUGUEIS A
    INNER JOIN PRODUTOS P
        ON P.ID_PRODUTO = A.ID_PRODUTO
    INNER JOIN tipo_problema TP
    ON TP.cod_tipo_problema = P_PROBLEMA
    WHERE A.id_aluguel = UUID(P_ID_ALUGUEL);

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO CADASTRAR PROBLEMA', SQLSTATE, SQLERRM, 'FN_INSERE_PROBLEMA', 'PROBLEMAS', CURRENT_QUERY(), P_ID_USUARIO);
    RETURN FALSE;
END;
$$;
