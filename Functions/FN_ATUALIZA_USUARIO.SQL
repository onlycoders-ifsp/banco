CREATE OR REPLACE FUNCTION
FN_ATUALIZA_USUARIO(P_ID TEXT, P_NOME TEXT, P_EMAIL VARCHAR(50), P_LOGIN VARCHAR(50),
					P_CPF VARCHAR(14), P_CELULAR VARCHAR(20), P_NASCIMENTO TEXT, P_CEP VARCHAR(20),
					P_LOGRADOURO TEXT, P_COMPLEMENTO VARCHAR(20), P_BAIRRO TEXT, P_NUMERO VARCHAR(10),
					P_USUARIO TEXT DEFAULT ''
					--P_TELEFONE VARCHAR(20) DEFAULT NULL,
					)
--RETURNS BOOLEAN AS $$
RETURNS SETOF RECORD AS 
$BODY$
DECLARE P_DATA_NASCIMENTO DATE;
DECLARE P_ID_USUARIO UUID;
DECLARE V_NOME TEXT;DECLARE V_EMAIL TEXT;DECLARE V_CPF VARCHAR(14);DECLARE V_NASCIMENTO DATE;DECLARE V_CELULAR VARCHAR(20);
DECLARE V_CEP VARCHAR(14);DECLARE V_LOGRADOURO TEXT;DECLARE V_COMPLEMENTO VARCHAR(20);DECLARE V_BAIRRO TEXT;DECLARE V_NUMERO VARCHAR(10);
DECLARE V_LOGIN VARCHAR(50);
DECLARE OK BOOLEAN;
--DECLARE DADOS JSON;
BEGIN
	--DADOS := (SELECT ROW_TO_JSON(a) FROM (SELECT P_ID, P_NOME, P_CPF, P_EMAIL, 
	--									  	P_SEXO,P_NASCIMENTO,P_SENHA,P_LOGIN,P_TELEFONE,P_CELULAR) A)
	
	P_ID_USUARIO := UUID(P_ID);
	P_DATA_NASCIMENTO := TO_DATE(P_NASCIMENTO, 'YYYY-MM-DD');

	BEGIN
		UPDATE USUARIOS
		SET NOME = P_NOME, EMAIL = P_EMAIL, CPF = P_CPF, 
		DATA_NASCIMENTO = P_DATA_NASCIMENTO, CELULAR = P_CELULAR,
		CEP = P_CEP, ENDERECO = P_LOGRADOURO, COMPLEMENTO = P_COMPLEMENTO, 
		BAIRRO = P_BAIRRO, NUMERO = P_NUMERO
		WHERE ID_USUARIO = P_ID_USUARIO;
		
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA USUARIO', SQLSTATE, SQLERRM, 'FN_ATUALIZA_USUARIO', 'USUARIOS', CURRENT_QUERY(),P_USUARIO);
		RETURN;
	END;

	BEGIN
		UPDATE AUTENTIFICACAO
		SET LOGIN = P_LOGIN
		WHERE ID_USUARIO = P_ID_USUARIO;
		
	EXCEPTION WHEN OTHERS THEN		
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA AUTENTIFICACAO', SQLSTATE, SQLERRM, 'FN_ATUALIZA_USUARIO', 'AUTENTIFICACAO',CURRENT_QUERY(),P_USUARIO);
		RETURN;
	END;
		
	RETURN QUERY SELECT *FROM FN_RETORNA_USUARIO(CAST(P_ID_USUARIO AS TEXT))
		AS T(ID_USUARIO TEXT, NOME TEXT, EMAIL TEXT, LOGIN TEXT, CPF TEXT,
			CELULAR TEXT, DATA_NASCIMENTO TEXT, CEP TEXT, LOGRADOURO TEXT, 
            COMPLEMENTO TEXT, BAIRRO TEXT, NUMERO TEXT, ATIVO BOOLEAN, CAPA_FOTO BYTEA,
			LocatarioAvalicao DECIMAL(2,1), LocadorAvalicao DECIMAL(2,1), ProdutoAvalicao DECIMAL(2,1),
			SALDO_LOCADOR DECIMAL(18,2));
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR USUARIO', SQLSTATE, SQLERRM, 'FN_ATUALIZA_USUARIO', NULL, CURRENT_QUERY(), P_USUARIO);
		RETURN;
END;
$BODY$ LANGUAGE PLPGSQL;

/*
SELECT FN_ATUALIZA_USUARIO(
'8c94f74e-6811-457c-8a8e-0434c1efa5cb', 'Mais um pra confirmar', 'Rua testando update',
'd93d6170-5ecf-4c2c-95ff-cc75a12aeebb', '145', '87654321','testefunçãoupdate@laugoapp.com', 
'tonho','Masculino', null, null, '2020-05-01')
*/