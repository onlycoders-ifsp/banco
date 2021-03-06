CREATE OR REPLACE  FUNCTION 
FN_CADASTRAR_PRODUTO(P_ID_USUARIO TEXT, P_NOME TEXT, P_DESCRICAO_CURTA TEXT, P_DESCRICAO TEXT, 
					P_CATEGORIAS TEXT, P_VALOR_BASE_DIARIA DOUBLE PRECISION, 
					P_VALOR_BASE_MENSAL DOUBLE PRECISION, P_VALOR_PRODUTO DOUBLE PRECISION, P_DATA_COMPRA TEXT, P_USUARIO TEXT DEFAULT '')
RETURNS TEXT AS $$
DECLARE P_ID_PRODUTO TEXT;
DECLARE OK BOOLEAN;
BEGIN	
	
	INSERT INTO PRODUTOS(
		ID_USUARIO, 
		NOME,
		DESCRICAO_CURTA,
		DESCRICAO, 
		VALOR_BASE_DIARIA, 
		VALOR_BASE_MENSAL,
		VALOR_PRODUTO,
		DATA_COMPRA,
		PUBLICADO)
	VALUES(
		UUID(P_ID_USUARIO), 
		P_NOME, 
		P_DESCRICAO_CURTA,
		P_DESCRICAO,
		P_VALOR_BASE_DIARIA,
		P_VALOR_BASE_MENSAL,
		P_VALOR_PRODUTO,
		TO_DATE(P_DATA_COMPRA,'YYYY-MM-DD'),
		TRUE)
		RETURNING CAST(ID_PRODUTO AS TEXT) INTO P_ID_PRODUTO;
		
	SELECT FN_CADASTRAR_ATUALIZA_CATEGORIA_PRODUTO(P_ID_PRODUTO,P_CATEGORIAS,P_USUARIO) INTO OK;
	
	-- RETURN QUERY
		-- SELECT *FROM FN_RETORNA_PRODUTO('0', P_ID_PRODUTO, 7, '0', P_USUARIO)
			-- as (ID_USUARIO TEXT, ID_PRODUTO TEXT, NOME TEXT, DESCRICAO_CURTA TEXT,
				-- DESCRICAO TEXT, VALOR_BASE_DIARIA DECIMAL(16,2), VALOR_BASE_MENSAL DECIMAL(16,2),
				-- VALOR_PRODUTO DECIMAL(16,2), DATA_COMPRA TEXT, QTD_ALUGUEIS NUMERIC(16),
				-- TOTAL_GANHOS DECIMAL(16,2), MEDIA_AVALIACAO DECIMAL(6,1), DT_ALUGADAS TEXT, 
				-- CATEGORIAS TEXT, CAPA_FOTO BYTEA, ATIVO BOOLEAN, PUBLICADO BOOLEAN);
	
	RETURN P_ID_PRODUTO;
	
	EXCEPTION WHEN OTHERS THEN
		DELETE FROM PRODUTOS
		WHERE ID_PRODUTO = UUID(P_ID_PRODUTO);
	
		PERFORM FN_REPORT_ERRO('ERRO AO CADASTRAR PRODUTO', SQLSTATE, SQLERRM, 'FN_CADASTRAR_PRODUTO', 'PRODUTOS', CURRENT_QUERY(),P_USUARIO);
		RETURN '';
END;
$$ LANGUAGE PLPGSQL;