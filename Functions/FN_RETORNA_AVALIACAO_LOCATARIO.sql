CREATE OR REPLACE FUNCTION
    FN_RETORNA_AVALIACAO_LOCATARIO(P_ID_USUARIO TEXT, P_USUARIO TEXT)
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
		ON P.id_usuario = U.id_usuario
	WHERE a.id_usuario = UUID(P_ID_USUARIO)
	AND cod_tipo_avaliacao = 2;


EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR AVALIAÇÕES', SQLSTATE, SQLERRM, 'FN_RETORNA_AVALIACAO_LOCATARIO', 'AVALIACOES', CURRENT_QUERY(), P_USUARIO);
    RETURN;
END;
$$ LANGUAGE PLPGSQL;
