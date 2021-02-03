CREATE OR REPLACE FUNCTION FN_RETORNA_LOG_BACKEND_DETALHE(P_USUARIO TEXT DEFAULT '')
RETURNS SETOF RECORD AS $$
BEGIN

	RETURN QUERY
	SELECT
	CAST(CONTROLLER AS TEXT),
	CAST(METODO AS TEXT),
	CAST(ENDPOINT AS TEXT),
	CAST(USUARIO AS TEXT),
	CAST(MESSAGE AS TEXT),
	CASE
		WHEN STRPOS(STACK_TRACE,'	') = 0 THEN STACK_TRACE
		ELSE LEFT(STACK_TRACE,STRPOS(STACK_TRACE,'	')-2)
	END STACK_TRACE
	FROM LOG.LOG_ERROS_BACKEND;

	EXCEPTION WHEN OTHERS THEN
	PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR ERROS', SQLSTATE, SQLERRM, 'FN_RETORNA_LOG_BACKEND_DETALHE', 'LOG_ERROS_BACKEND', CURRENT_QUERY(),P_USUARIO);
	RETURN;
END;
$$ LANGUAGE PLPGSQL;