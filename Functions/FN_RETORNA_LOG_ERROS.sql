CREATE OR REPLACE FUNCTION FN_RETORNA_LOG_ERROS()
RETURNS SETOF RECORD AS $$
BEGIN
	
	RETURN QUERY
		SELECT 
		CAST(ID AS INTEGER),
		CAST(PROCEDURE AS TEXT),
		CAST(TABELA AS TEXT),
		CAST(ERRO AS TEXT),
		CAST(QUERY AS TEXT),
		TO_CHAR(DATA_ERRO,'DD/MM/YYYY HH:MM:SS')
		FROM LOG.LOG_ERROS
		ORDER BY DATA_ERRO DESC;

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR ERROS', SQLSTATE, SQLERRM, 'FN_RETORNA_LOG_ERROS', 'LOG_ERROS', CURRENT_QUERY());

END;
$$ LANGUAGE PLPGSQL;