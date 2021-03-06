CREATE OR REPLACE FUNCTION 
FN_FOTO_PRODUTO(P_ID_USUARIO TEXT, P_ID_PRODUTO TEXT, P_FOTO BYTEA, P_USUARIO TEXT DEFAULT '')
RETURNS BOOLEAN AS $$
BEGIN

	UPDATE PRODUTOS
	SET CAPA_FOTO = P_FOTO
	WHERE ID_PRODUTO = UUID(P_ID_PRODUTO)
	AND ID_USUARIO = UUID(P_ID_USUARIO);
	
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR FOTO DE PRODUTO', SQLSTATE, SQLERRM, 'FN_FOTO_PRODUTO', 'PRODUTOS', CURRENT_QUERY(),P_USUARIO);
		RETURN FALSE;
END;
$$ LANGUAGE PLPGSQL;