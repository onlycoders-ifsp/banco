CREATE OR REPLACE FUNCTION FN_RETORNA_ALUGUEL_DETALHE(P_ID_PRODUTO TEXT,P_USUARIO TEXT DEFAULT '')
RETURNS SETOF RECORD AS $$
BEGIN
	
	RETURN QUERY 
		SELECT 
		CAST(P.ID_PRODUTO AS TEXT),
		P.NOME,
		P.CAPA_FOTO,
		CAST(LOCATARIO.ID_USUARIO AS TEXT),
		LOCATARIO.NOME,
		LOCATARIO.CAPA_FOTO,
		TO_CHAR(A.DATA_INICIO,'DD/MM/YYYY'),
		TO_CHAR(A.DATA_FIM,'DD/MM/YYYY'),
		CAST(A.VALOR_ALUGUEL AS DOUBLE PRECISION),
		CAST(A.VALOR_DEBITO AS DOUBLE PRECISION),
		TO_CHAR(A.DATA_SAQUE,'DD/MM/YYYY'),
		CAST(A.COD_STATUS_ALUGUEL AS INT)
		FROM ALUGUEIS A
		INNER JOIN PRODUTOS P
		ON A.ID_PRODUTO = P.ID_PRODUTO
		INNER JOIN USUARIOS LOCATARIO
		ON LOCATARIO.ID_USUARIO = A.ID_USUARIO
		WHERE A.ID_PRODUTO = UUID(P_ID_PRODUTO);

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR ALUGUEL', SQLSTATE, SQLERRM, 'FN_RETORNA_ALUGUEL_DETALHE', 'ALUGUEIS/PRODUTOS/USUARIOS', CURRENT_QUERY(),P_USUARIO);

END;
$$ LANGUAGE PLPGSQL;