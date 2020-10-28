CREATE OR REPLACE FUNCTION FN_VALIDA_ALUGUEL(P_ID_USUARIO TEXT, P_ID_PRODUTO TEXT, P_DATA_INICIO TEXT, P_DATA_FIM TEXT)
RETURNS TEXT AS $$
BEGIN

	IF EXISTS(
		SELECT
		1
		FROM ALUGUEIS
		WHERE ID_PRODUTO = UUID(P_ID_PRODUTO)
		AND (DATA_FIM BETWEEN TO_TIMESTAMP(P_DATA_INICIO,'YYYY-MM-DD HH24:MI:SS') 
		AND TO_TIMESTAMP(P_DATA_FIM,'YYYY-MM-DD HH24:MI:SS')
		OR DATA_INICIO BETWEEN TO_TIMESTAMP(P_DATA_INICIO,'YYYY-MM-DD HH24:MI:SS') 
		AND TO_TIMESTAMP(P_DATA_FIM,'YYYY-MM-DD HH24:MI:SS'))
	) THEN
		RETURN 'DATA INFORMADA EM CONFLITO COM OUTRO ALUGUEL';
	ELSEIF 
		EXISTS(
			SELECT 1 FROM PRODUTOS
			WHERE ID_USUARIO = UUID(P_ID_USUARIO)
			AND ID_PRODUTO = UUID(P_ID_PRODUTO)
		) THEN 
			RETURN 'NÃO É PERMITIDO O ALUGUEL DO PRÓPRIO PRODUTO';
		ELSE
			RETURN '0';
	END IF;
	
	EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO VALIDAR ALUGUEL', SQLSTATE, SQLERRM, 'FN_VALIDA_ALUGUEL', 'ALUGUEIS', CURRENT_QUERY());
END;
$$ LANGUAGE PLPGSQL;