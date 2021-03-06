CREATE OR REPLACE DROP FUNCTION 
FN_INSERIR_USUARIO(P_NOME TEXT, P_EMAIL VARCHAR(50), P_LOGIN VARCHAR(50), P_SENHA TEXT, 
					P_CPF VARCHAR(14), P_CELULAR VARCHAR(20), P_NASCIMENTO TEXT, P_CEP VARCHAR(20), 
					P_LOGRADOURO TEXT,	P_COMPLEMENTO VARCHAR(20), P_BAIRRO TEXT, 
					P_NUMERO VARCHAR(10))
--RETURNS BOOLEAN AS $$
RETURNS SETOF RECORD AS $$
DECLARE P_ID_USUARIO UUID;
DECLARE OK BOOLEAN = FALSE;
DECLARE P_DATA_NASCIMENTO DATE;
--DECLARE DADOS JSON;
BEGIN
	--DADOS := (SELECT ROW_TO_JSON(a) FROM (SELECT P_NOME, P_CPF, P_EMAIL, 
	--									  	P_SEXO,P_NASCIMENTO,P_SENHA,P_LOGIN,P_TELEFONE,P_CELULAR) A)
	
	BEGIN
		P_DATA_NASCIMENTO := TO_DATE(P_NASCIMENTO, 'YYYY-MM-DD');
		
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO INSERIR O USUARIO', sqlstate, sqlerrm, 'FN_INSERIR_USUARIO', NULL, CURRENT_QUERY());
			RETURN;
	END;
	
	BEGIN
		INSERT INTO USUARIOS(
		NOME,
		CPF,
		EMAIL,
		--SEXO,
		CELULAR,
		DATA_NASCIMENTO,
		CEP,
		BAIRRO,
		ENDEREO,
		COMPLEMENTO,
		NUMERO)
		VALUES(
		P_NOME,
		P_CPF,
		P_EMAIL,
		--P_SEXO
		P_CELULAR,
		P_DATA_NASCIMENTO,
		P_CEP,
		P_BAIRRO,
		P_ENDERECO,
		P_COMPLEMENTO,
		P_NUMERO)
		RETURNING ID_USUARIO INTO P_ID_USUARIO;
	
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO INSERIR O USUARIO', sqlstate, sqlerrm, 'FN_INSERIR_USUARIO', 'USUARIOS', CURRENT_QUERY());
			RETURN;
	END;
		
	SELECT FN_INSERIR_LOGIN(CAST(P_ID_USUARIO AS TEXT), P_SENHA, P_LOGIN) INTO OK;
	
	IF NOT OK THEN
		DELETE FROM USUARIOS
		WHERE ID_USUARIO = P_ID_USUARIO;
		RETURN;
	END IF;
	
	IF OK THEN
		RETURN QUERY SELECT *FROM FN_RETORNA_USUARIO(CAST(P_ID_USUARIO AS TEXT))
		AS T(ID_USUARIO TEXT, NOME TEXT, EMAIL TEXT, LOGIN TEXT, CPF TEXT,
			CELULAR TEXT, DATA_NASCIMENTO TEXT, CEP TEXT, LOGRADOURO TEXT, 
            COMPLEMENTO TEXT, BAIRRO TEXT, NUMERO TEXT, ATIVO BOOLEAN);
	ELSE
	
		DELETE FROM AUTENTIFICACAO
		WHERE ID_USUARIO = P_ID_USUARIO;
		
		DELETE FROM USUARIOS
		WHERE ID_USUARIO = P_ID_USUARIO;
		
		RETURN;
	END IF;
	
END;
$$  LANGUAGE PLPGSQL