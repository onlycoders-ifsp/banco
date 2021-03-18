CREATE OR REPLACE FUNCTION
    FN_RETORNA_AVALIACAO_PRODUTO(P_ID_PRODUTO TEXT, P_USUARIO TEXT)
    RETURNS SETOF RECORD AS $$
BEGIN

    RETURN QUERY
        SELECT U.nome,av.COMENTARIO, av.NOTA, u.capa_foto, to_char(av.data_inclusao,'YYYY-MM-DD')
        FROM avaliacoes AV
        INNER JOIN alugueis A
            on AV.id_aluguel = A.id_aluguel
        INNER JOIN produtos P
            ON A.id_produto = P.id_produto
        INNER JOIN usuarios U
            ON A.id_usuario = U.id_usuario
        WHERE P.id_produto = UUID(P_ID_PRODUTO)
          AND COD_TIPO_AVALIACAO = 1;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR AVALIAÇÕES', SQLSTATE, SQLERRM, 'FN_RETORNA_AVALIACAO_PRODUTO', 'AVALIACOES', CURRENT_QUERY(), P_USUARIO);
    RETURN;
END;
$$ LANGUAGE PLPGSQL;
