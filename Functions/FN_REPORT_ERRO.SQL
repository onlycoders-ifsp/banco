CREATE OR REPLACE FUNCTION FN_REPORT_ERRO(P_DESCRICAO TEXT, P_STATE TEXT, P_ERRO TEXT, P_PROCEDURE TEXT, P_TABELA TEXT, P_QUERY TEXT, P_USUARIO TEXT DEFAULT '')
RETURNS VOID AS $$
BEGIN

    RAISE EXCEPTION '%', P_ERRO;

	EXCEPTION WHEN OTHERS THEN
    INSERT INTO LOG.LOG_ERROS(PROCEDURE, TABELA, QUERY, ERRO, STATE, DESCRICAO, USUARIO)
    VALUES (P_PROCEDURE, P_TABELA, P_QUERY, P_ERRO, P_STATE, P_DESCRICAO, P_USUARIO);

    RAISE INFO 'ERRO EM FN_REPORT_ERRO % %', sqlstate, sqlerrm;
END;
$$ LANGUAGE plpgsql
