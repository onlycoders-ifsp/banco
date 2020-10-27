CREATE OR REPLACE FUNCTION FN_ATUALIZA_SENHA(P_ID_USUARIO TEXT, P_SENHA TEXT)
RETURNS BOOLEAN AS $$
BEGIN
	UPDATE AUTENTIFICACAO
	SET PASSWORD = CRYPT(P_SENHA,CONCAT(gen_salt('bf',10),TO_CHAR(CURRENT_TIMESTAMP,'YYYYMMDDHHMMSSMSUS')))
	WHERE ID_USUARIO = UUID(P_ID_USUARIO);
	
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR SENHA', sqlstate, sqlerrm, 'FN_ATUALIZA_SENHA', 'AUTENTIFICACAO', CURRENT_QUERY());
		RETURN FALSE;
END;
$$  LANGUAGE plpgsql