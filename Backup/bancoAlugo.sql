PGDMP     )    !                x            d4ihibvbhh46tq     12.3 (Ubuntu 12.3-1.pgdg16.04+1)    12.3 �    V           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            W           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            X           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Y           1262    23291679    d4ihibvbhh46tq    DATABASE     �   CREATE DATABASE d4ihibvbhh46tq WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE d4ihibvbhh46tq;
                iisvwvstwejsde    false            Z           0    0    DATABASE d4ihibvbhh46tq    ACL     A   REVOKE CONNECT,TEMPORARY ON DATABASE d4ihibvbhh46tq FROM PUBLIC;
                   iisvwvstwejsde    false    4185            [           0    0    LANGUAGE plpgsql    ACL     1   GRANT ALL ON LANGUAGE plpgsql TO iisvwvstwejsde;
                   postgres    false    779                        3079    23664910    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            \           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2                        3079    23664899 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                   false            ]           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                        false    3            �            1255    23665498    fc_on_updated()    FUNCTION     �   CREATE FUNCTION public.fc_on_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.DATA_MODIFICACAO = timezone('America/Sao_Paulo', CURRENT_TIMESTAMP);
	RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.fc_on_updated();
       public          iisvwvstwejsde    false            *           1255    23818967 @   fn_atualiza_produto(uuid, text, text, numeric, numeric, numeric)    FUNCTION     I  CREATE FUNCTION public.fn_atualiza_produto(p_id_produto uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE PRODUTOS
	SET NOME = P_NOME, DESCRICAO = P_DESCRICAO, VALOR_BASE_DIARIA = P_VALOR_BASE_DIARIA,
	VALOR_BASE_MENSAL = P_VALOR_BASE_MENSAL, VALOR_PRODUTO = P_VALOR_PRODUTO
	WHERE ID_PRODUTO = P_ID_PRODUTO;
	
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR PRODUTO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
 �   DROP FUNCTION public.fn_atualiza_produto(p_id_produto uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric);
       public          iisvwvstwejsde    false            &           1255    23818956 F   fn_atualiza_produto(uuid, uuid, text, text, numeric, numeric, numeric)    FUNCTION     ]  CREATE FUNCTION public.fn_atualiza_produto(p_id_usuario uuid, p_id_produto uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE PRODUTOS
	SET NOME = P_NOME, DESCRICAO = P_DESSCRICAO, VALOR_BASE_DIARIA = P_VALOR_BASE_DIARIA,
	VALOR_BASE_MENSAL = P_VALOR_BASE_MENSAL, VALOR_PRODUTO = P_VALOR_PRODUTO
	WHERE ID_PRODUTO = P_ID_PRODUTO;
	
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR PRODUTO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
 �   DROP FUNCTION public.fn_atualiza_produto(p_id_usuario uuid, p_id_produto uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric);
       public          iisvwvstwejsde    false            "           1255    23665517 �   fn_atualiza_usuario(uuid, text, text, character varying, character varying, character varying, integer, character varying, character varying, date)    FUNCTION       CREATE FUNCTION public.fn_atualiza_usuario(p_id_usuario uuid, p_nome text, p_logradouro text, p_numero character varying, p_cep character varying, p_email character varying, p_sexo integer, p_telefone character varying, p_celular character varying, p_data_nascimento date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	UPDATE USUARIOS
	SET NOME = P_NOME, LOGRADOURO = P_LOGRADOURO,
	NUMERO = P_NUMERO, CEP = P_CEP,
	EMAIL = P_EMAIL, DATA_NASCIMENTO = P_DATA_NASCIMENTO, 
	ID_SEXO = FN_GET_ID_SEXO(P_SEXO)
	WHERE ID_USUARIO = P_ID_USUARIO;
	
	UPDATE TELEFONES
	SET TELEFONE = P_TELEFONE, CELULAR = P_CELULAR
	WHERE ID_USUARIO = P_ID_USUARIO;
	
	RETURN TRUE;

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR USUARIO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
   DROP FUNCTION public.fn_atualiza_usuario(p_id_usuario uuid, p_nome text, p_logradouro text, p_numero character varying, p_cep character varying, p_email character varying, p_sexo integer, p_telefone character varying, p_celular character varying, p_data_nascimento date);
       public          iisvwvstwejsde    false            �            1255    23665515 G   fn_cadastrar_produto(uuid, text, text, numeric, numeric, numeric, date)    FUNCTION     �  CREATE FUNCTION public.fn_cadastrar_produto(p_id_usuario uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric, p_data_compra date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	 
	INSERT INTO PRODUTOS(
		ID_USUARIO, 
		NOME, 
		DESCRICAO, 
		VALOR_BASE_DIARIA, 
		VALOR_BASE_MENSAL,
		VALOR_PRODUTO, 
		DATA_COMPRA)
	VALUES(
		P_ID_USUARIO, 
		P_NOME, 
		P_DESCRICAO,
		P_VALOR_BASE_DIARIA,
		P_VALOR_BASE_MENSAL,
		P_VALOR_PRODUTO,
		P_DATA_COMPRA);
																				  
	RETURN TRUE;

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO CADASTRAR PRODUTO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
 �   DROP FUNCTION public.fn_cadastrar_produto(p_id_usuario uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric, p_data_compra date);
       public          iisvwvstwejsde    false            (           1255    23818987    fn_deleta_produto(uuid)    FUNCTION     ;  CREATE FUNCTION public.fn_deleta_produto(p_id_produto uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	delete from produtos
	where id_produto =  P_ID_PRODUTO;
	
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR PRODUTO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
 ;   DROP FUNCTION public.fn_deleta_produto(p_id_produto uuid);
       public          iisvwvstwejsde    false            �            1255    23665514    fn_deleta_usuario(uuid)    FUNCTION     5  CREATE FUNCTION public.fn_deleta_usuario(p_id_usuario uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM USUARIOS WHERE ID_USUARIO = P_ID_USUARIO;
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO DELETAR USUARIO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;
 ;   DROP FUNCTION public.fn_deleta_usuario(p_id_usuario uuid);
       public          iisvwvstwejsde    false            �            1255    23665516    fn_get_id_sexo(integer)    FUNCTION     �  CREATE FUNCTION public.fn_get_id_sexo(sexo integer) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE STATE TEXT;
DECLARE ERRO TEXT;
BEGIN
	RETURN(SELECT ID_SEXO
	FROM SEXO A
	WHERE A.COD_SEXO = SEXO);

	EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS STATE = RETURNED_SQLSTATE,
                          		ERRO = PG_EXCEPTION_DETAIL;
		PERFORM FN_REPORT_ERRO('ERRO AO PROCURAR O SEXO', STATE, ERRO);
		RETURN FALSE;
END;
$$;
 3   DROP FUNCTION public.fn_get_id_sexo(sexo integer);
       public          iisvwvstwejsde    false            )           1255    23665513    fn_inserir_login(uuid, text)    FUNCTION     �  CREATE FUNCTION public.fn_inserir_login(p_id_usuario uuid, p_senha text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE STATE TEXT;
DECLARE ERRO TEXT;
BEGIN
	INSERT INTO AUTENTIFICACAO(ID_USUARIO, PASSWORD)
	VALUES(P_ID_USUARIO, CRYPT(P_SENHA,CONCAT(gen_salt('bf',16),TO_CHAR(CURRENT_TIMESTAMP,'YYYYMMDDHHMMSSMSUS'))));
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO INSERIR LOGIN', sqlstate, sqlerrm);
		RETURN FALSE;
END;
$$;
 H   DROP FUNCTION public.fn_inserir_login(p_id_usuario uuid, p_senha text);
       public          iisvwvstwejsde    false            #           1255    23665541 @   fn_inserir_telefones(uuid, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.fn_inserir_telefones(p_id_usuario uuid, p_telefone character varying, p_celular character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE STATE TEXT;
DECLARE ERRO TEXT;
BEGIN
	INSERT INTO TELEFONES(ID_USUARIO, TELEFONE, CELULAR)
	VALUES(P_ID_USUARIO, P_TELEFONE, P_CELULAR);
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO INSERIR TELEFONES', sqlstate, sqlerrm);
		RETURN FALSE;
END;
$$;
 y   DROP FUNCTION public.fn_inserir_telefones(p_id_usuario uuid, p_telefone character varying, p_celular character varying);
       public          iisvwvstwejsde    false            %           1255    23665540 �   fn_inserir_usuario(text, character varying, text, character varying, character, character varying, integer, text, text, character varying, character varying)    FUNCTION     ^  CREATE FUNCTION public.fn_inserir_usuario(p_nome text, p_cpf character varying, p_logradouro text, p_numero character varying, p_cep character, p_email character varying, p_sexo integer, p_nascimento text, p_senha text, p_telefone character varying DEFAULT NULL::character varying, p_celular character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE P_ID_SEXO UUID := NULL;
DECLARE P_ID_USUARIO UUID;
DECLARE OK BOOLEAN = FALSE;
DECLARE P_DATA_NASCIMENTO DATE;
BEGIN
	
	P_DATA_NASCIMENTO := TO_DATE(P_NASCIMENTO, 'YYYY-MM-DD');
	
	SELECT FN_GET_ID_SEXO(P_SEXO) INTO P_ID_SEXO;
	
	IF P_ID_SEXO IS NULL THEN
		RAISE INFO 'NÃO FOI ENCONTRADO O SEXO';
		RETURN FALSE;
	END IF;
	
	BEGIN
		INSERT INTO USUARIOS(
		NOME,
		CPF,
		LOGRADOURO,
		NUMERO,
		CEP,
		EMAIL,
		ID_SEXO,
		DATA_NASCIMENTO)
		VALUES(
		P_NOME,
		P_CPF,
		P_LOGRADOURO,
		P_NUMERO,
		P_CEP,
		P_EMAIL,
		P_ID_SEXO,
		P_DATA_NASCIMENTO)
		RETURNING ID_USUARIO INTO P_ID_USUARIO;
	
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO INSERIR O USUARIO', sqlstate, sqlerrm);
			RETURN FALSE;
	END;
	
	SELECT FN_INSERIR_LOGIN(P_ID_USUARIO, P_SENHA) INTO OK;
	
	IF OK = FALSE THEN
		RETURN FALSE;
	END IF;
	
	SELECT FN_INSERIR_TELEFONES(P_ID_USUARIO, P_TELEFONE, P_CELULAR) INTO OK;
	
	IF OK THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END;
$$;
   DROP FUNCTION public.fn_inserir_usuario(p_nome text, p_cpf character varying, p_logradouro text, p_numero character varying, p_cep character, p_email character varying, p_sexo integer, p_nascimento text, p_senha text, p_telefone character varying, p_celular character varying);
       public          iisvwvstwejsde    false            �            1255    23665497     fn_report_erro(text, text, text)    FUNCTION        CREATE FUNCTION public.fn_report_erro(descricao text, state text, erro text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN						  
	RAISE INFO '%', DESCRICAO;
	RAISE NOTICE '% %', STATE, ERRO;
	
	EXCEPTION WHEN OTHERS THEN
		RAISE INFO 'ERRO NO ERRO % %', sqlstate, sqlerrm;
END;
$$;
 L   DROP FUNCTION public.fn_report_erro(descricao text, state text, erro text);
       public          iisvwvstwejsde    false            '           1255    23665669    fn_retorna_sexo()    FUNCTION     ,  CREATE FUNCTION public.fn_retorna_sexo() RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	RETURN QUERY 
		SELECT S.COD_SEXO, S.DESCRICAO
		FROM SEXO S
		ORDER BY 1;
				 
	EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR SEXOS', SQLSTATE, SQLERRM);
END;
$$;
 (   DROP FUNCTION public.fn_retorna_sexo();
       public          iisvwvstwejsde    false            $           1255    23665495    fn_retorna_usuario(uuid)    FUNCTION     �  CREATE FUNCTION public.fn_retorna_usuario(p_id_usuario uuid DEFAULT NULL::uuid) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
		RETURN QUERY SELECT U.NOME, U.CPF, U.LOGRADOURO, U.NUMERO, U.CEP, U.EMAIL, S.DESCRICAO, 
		(SELECT COUNT(1)FROM PRODUTOS PP WHERE U.ID_USUARIO = PP.ID_USUARIO) PRODUTOS_CADASTRADOS,
		T.TELEFONE, T.CELULAR, U.DATA_INCLUSAO
		FROM USUARIOS U
		INNER JOIN SEXO S 
		ON U.ID_SEXO = S.ID_SEXO
		INNER JOIN TELEFONES T
		ON T.ID_USUARIO = U.ID_USUARIO
		WHERE (U.ID_USUARIO = P_ID_USUARIO OR P_ID_USUARIO IS NULL);
		
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO SELECIONA USUARIO', SQLSTATE, SQLERRM);
	RETURN;
END;
$$;
 <   DROP FUNCTION public.fn_retorna_usuario(p_id_usuario uuid);
       public          iisvwvstwejsde    false            �            1255    23665494    fn_retornar_produto(uuid)    FUNCTION     	  CREATE FUNCTION public.fn_retornar_produto(p_id_usuario uuid DEFAULT NULL::uuid) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
BEGIN
	 
	RETURN QUERY 
		SELECT P.ID_PRODUTO, U.NOME, P.NOME, P.DESCRICAO, P.VALOR_BASE_DIARIA,
		P.VALOR_BASE_MENSAL, P.VALOR_PRODUTO
		FROM PRODUTOS P
		INNER JOIN USUARIOS U
		ON P.ID_USUARIO = U.ID_USUARIO
		WHERE (U.ID_USUARIO = P_ID_USUARIO OR P_ID_USUARIO IS NULL);

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR PRODUTO', SQLSTATE, SQLERRM);

END;
$$;
 =   DROP FUNCTION public.fn_retornar_produto(p_id_usuario uuid);
       public          iisvwvstwejsde    false            �            1255    23665492 *   fn_verifcar_login(character varying, text)    FUNCTION     v  CREATE FUNCTION public.fn_verifcar_login(p_email character varying, p_senha text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE IS_CORRECT BOOLEAN;
DECLARE USUARIO TEXT;
BEGIN
	SELECT (AUTENTIFICACAO.PASSWORD = CRYPT(P_SENHA,AUTENTIFICACAO.PASSWORD)), USUARIOS.ID_USUARIO 
	INTO IS_CORRECT, USUARIO
	FROM AUTENTIFICACAO
	INNER JOIN USUARIOS
	ON AUTENTIFICACAO.ID_USUARIO = USUARIOS.ID_USUARIO
	AND USUARIOS.EMAIL = P_EMAIL;
	
	IF IS_CORRECT THEN
		RETURN USUARIO;
	ELSE 
		RETURN NULL;
	END IF;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO VERIFICAR O LOGIN', sqlstate, sqlerrm);
		RETURN FALSE;
END;
$$;
 Q   DROP FUNCTION public.fn_verifcar_login(p_email character varying, p_senha text);
       public          iisvwvstwejsde    false            �            1255    23665493 @   fn_verifica_existe_usuario(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.fn_verifica_existe_usuario(p_email character varying, p_cpf character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE EXISTE BOOLEAN;
BEGIN
	SELECT (EMAIL = P_MAIL AND CPF = DOC) 
	INTO EXISTE 
	FROM USUARIOS
	WHERE (EMAIL = P_MAIL AND CPF = DOC);
	
	IF EXISTE IS NULL THEN
		EXISTE := FALSE;
	END IF;
	
	RETURN EXISTE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('VERIFICAR LOGIN', sqlstate, sqlerrm);
		RETURN FALSE;
	
END;
$$;
 e   DROP FUNCTION public.fn_verifica_existe_usuario(p_email character varying, p_cpf character varying);
       public          iisvwvstwejsde    false            �            1259    23665234    alugueis    TABLE     
  CREATE TABLE public.alugueis (
    id_aluguel uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    id_produto uuid,
    token_api text NOT NULL,
    data_inicio date NOT NULL,
    data_fim date NOT NULL,
    valor_aluguel numeric(16,2) NOT NULL,
    id_status_aluguel uuid,
    valor_debito numeric(16,2) NOT NULL,
    data_saque date NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.alugueis;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665165    autentificacao    TABLE     9  CREATE TABLE public.autentificacao (
    id_autentificacao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    password text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
 "   DROP TABLE public.autentificacao;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665260 
   avaliacoes    TABLE     �  CREATE TABLE public.avaliacoes (
    id_avaliacao uuid DEFAULT public.uuid_generate_v4(),
    id_aluguel uuid,
    id_usuario_avaliador uuid,
    comentario text,
    nota numeric(3,1),
    id_tipo_avaliacao uuid NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone,
    CONSTRAINT avaliacoes_nota_check CHECK ((nota < (11)::numeric))
);
    DROP TABLE public.avaliacoes;
       public         heap    iisvwvstwejsde    false    3            �            1259    23664977    bancos    TABLE     C  CREATE TABLE public.bancos (
    id_banco uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_banco character varying(10) NOT NULL,
    nome_banco text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.bancos;
       public         heap    iisvwvstwejsde    false    3            �            1259    23664962 
   gravidades    TABLE     e  CREATE TABLE public.gravidades (
    id_gravidade uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_gravidade integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP)),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.gravidades;
       public         heap    iisvwvstwejsde    false    3            �            1259    23664947    idiomas    TABLE     �  CREATE TABLE public.idiomas (
    id_idioma uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_idioma integer NOT NULL,
    abreviatura_idioma character varying(5) NOT NULL,
    nome character varying(50) NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.idiomas;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665466    meios_debito    TABLE     �  CREATE TABLE public.meios_debito (
    id_debito uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    agencia character varying(10) NOT NULL,
    conta character varying(15) NOT NULL,
    id_banco uuid,
    id_tipo_conta uuid,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
     DROP TABLE public.meios_debito;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665287 	   problemas    TABLE     �  CREATE TABLE public.problemas (
    id_problema uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_aluguel uuid,
    id_usuario uuid,
    id_tipo_problema uuid,
    id_gravidade uuid,
    valor_reembolso numeric(16,2) NOT NULL,
    id_status_problema uuid,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.problemas;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665209    produtos    TABLE     �  CREATE TABLE public.produtos (
    id_produto uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    nome text NOT NULL,
    descricao text NOT NULL,
    valor_base_diaria numeric(16,2) NOT NULL,
    valor_base_mensal numeric(16,2) NOT NULL,
    valor_produto numeric(16,2) NOT NULL,
    data_compra date NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.produtos;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665095    sexo    TABLE     0  CREATE TABLE public.sexo (
    id_sexo uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_sexo integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.sexo;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665080    status_aluguel    TABLE     N  CREATE TABLE public.status_aluguel (
    id_status_aluguel uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_status_aluguel integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
 "   DROP TABLE public.status_aluguel;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665065    status_problema    TABLE     Q  CREATE TABLE public.status_problema (
    id_status_problema uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_status_problema integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
 #   DROP TABLE public.status_problema;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665147 	   telefones    TABLE     �  CREATE TABLE public.telefones (
    id_telefone uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    telefone character varying(20),
    celular character varying(20),
    is_verificado boolean DEFAULT false NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NOT NULL,
    data_modificacao timestamp with time zone
);
    DROP TABLE public.telefones;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665050    tipo_avaliacao    TABLE     N  CREATE TABLE public.tipo_avaliacao (
    id_tipo_avaliacao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_tipo_avaliacao integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
 "   DROP TABLE public.tipo_avaliacao;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665451 
   tipo_conta    TABLE     H  CREATE TABLE public.tipo_conta (
    id_tipo_conta uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_tipo_conta integer NOT NULL,
    descricao_conta text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.tipo_conta;
       public         heap    iisvwvstwejsde    false    3            �            1259    23665006    tipo_problema    TABLE     K  CREATE TABLE public.tipo_problema (
    id_tipo_problema uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    cod_tipo_problema integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
 !   DROP TABLE public.tipo_problema;
       public         heap    iisvwvstwejsde    false    3            �            1259    24015638 	   traducoes    TABLE     �  CREATE TABLE public.traducoes (
    id_traducao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_traducao_nativo uuid,
    tabela_origem character varying(50) NOT NULL,
    campo character varying(50) NOT NULL,
    descricao text NOT NULL,
    id_idioma uuid,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.traducoes;
       public         heap    iisvwvstwejsde    false    3            �            1259    23799821    usuario    TABLE     7  CREATE TABLE public.usuario (
    id integer NOT NULL,
    cep character varying(255),
    cpf character varying(255),
    data_nascimento timestamp without time zone,
    email character varying(255),
    logradouro character varying(255),
    nome character varying(255),
    numero character varying(255)
);
    DROP TABLE public.usuario;
       public         heap    iisvwvstwejsde    false            �            1259    23799819    usuario_id_seq    SEQUENCE     �   ALTER TABLE public.usuario ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          iisvwvstwejsde    false    222            �            1259    23665110    usuarios    TABLE       CREATE TABLE public.usuarios (
    id_usuario uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nome text NOT NULL,
    cpf character varying(14) NOT NULL,
    logradouro text NOT NULL,
    numero character varying(10) NOT NULL,
    cep character varying(10) NOT NULL,
    email character varying(50) NOT NULL,
    id_sexo uuid,
    data_nascimento date NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);
    DROP TABLE public.usuarios;
       public         heap    iisvwvstwejsde    false    3            L          0    23665234    alugueis 
   TABLE DATA           �   COPY public.alugueis (id_aluguel, id_usuario, id_produto, token_api, data_inicio, data_fim, valor_aluguel, id_status_aluguel, valor_debito, data_saque, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    216   �      J          0    23665165    autentificacao 
   TABLE DATA           r   COPY public.autentificacao (id_autentificacao, id_usuario, password, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    214   �      M          0    23665260 
   avaliacoes 
   TABLE DATA           �   COPY public.avaliacoes (id_avaliacao, id_aluguel, id_usuario_avaliador, comentario, nota, id_tipo_avaliacao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    217   ]      B          0    23664977    bancos 
   TABLE DATA           b   COPY public.bancos (id_banco, cod_banco, nome_banco, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    206   z      A          0    23664962 
   gravidades 
   TABLE DATA           m   COPY public.gravidades (id_gravidade, cod_gravidade, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    205   �      @          0    23664947    idiomas 
   TABLE DATA           ~   COPY public.idiomas (id_idioma, cod_idioma, abreviatura_idioma, nome, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    204   �      P          0    23665466    meios_debito 
   TABLE DATA           �   COPY public.meios_debito (id_debito, id_usuario, agencia, conta, id_banco, id_tipo_conta, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    220   �      N          0    23665287 	   problemas 
   TABLE DATA           �   COPY public.problemas (id_problema, id_aluguel, id_usuario, id_tipo_problema, id_gravidade, valor_reembolso, id_status_problema, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    218   �      K          0    23665209    produtos 
   TABLE DATA           �   COPY public.produtos (id_produto, id_usuario, nome, descricao, valor_base_diaria, valor_base_mensal, valor_produto, data_compra, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    215         G          0    23665095    sexo 
   TABLE DATA           ]   COPY public.sexo (id_sexo, cod_sexo, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    211   P      F          0    23665080    status_aluguel 
   TABLE DATA           {   COPY public.status_aluguel (id_status_aluguel, cod_status_aluguel, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    210         E          0    23665065    status_problema 
   TABLE DATA           ~   COPY public.status_problema (id_status_problema, cod_status_problema, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    209   $      I          0    23665147 	   telefones 
   TABLE DATA              COPY public.telefones (id_telefone, id_usuario, telefone, celular, is_verificado, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    213   A      D          0    23665050    tipo_avaliacao 
   TABLE DATA           {   COPY public.tipo_avaliacao (id_tipo_avaliacao, cod_tipo_avaliacao, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    208   @      O          0    23665451 
   tipo_conta 
   TABLE DATA           u   COPY public.tipo_conta (id_tipo_conta, cod_tipo_conta, descricao_conta, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    219   ]      C          0    23665006    tipo_problema 
   TABLE DATA           x   COPY public.tipo_problema (id_tipo_problema, cod_tipo_problema, descricao, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    207   z      S          0    24015638 	   traducoes 
   TABLE DATA           �   COPY public.traducoes (id_traducao, id_traducao_nativo, tabela_origem, campo, descricao, id_idioma, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    223   �      R          0    23799821    usuario 
   TABLE DATA           a   COPY public.usuario (id, cep, cpf, data_nascimento, email, logradouro, nome, numero) FROM stdin;
    public          iisvwvstwejsde    false    222   �      H          0    23665110    usuarios 
   TABLE DATA           �   COPY public.usuarios (id_usuario, nome, cpf, logradouro, numero, cep, email, id_sexo, data_nascimento, data_inclusao, data_modificacao) FROM stdin;
    public          iisvwvstwejsde    false    212         ^           0    0    usuario_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.usuario_id_seq', 1, true);
          public          iisvwvstwejsde    false    221            �           2606    23665243    alugueis alugueis_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_pkey PRIMARY KEY (id_aluguel);
 @   ALTER TABLE ONLY public.alugueis DROP CONSTRAINT alugueis_pkey;
       public            iisvwvstwejsde    false    216            {           2606    23665176 5   autentificacao autentificacao_id_usuario_password_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_id_usuario_password_key UNIQUE (id_usuario, password);
 _   ALTER TABLE ONLY public.autentificacao DROP CONSTRAINT autentificacao_id_usuario_password_key;
       public            iisvwvstwejsde    false    214    214            }           2606    23665174 "   autentificacao autentificacao_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_pkey PRIMARY KEY (id_autentificacao);
 L   ALTER TABLE ONLY public.autentificacao DROP CONSTRAINT autentificacao_pkey;
       public            iisvwvstwejsde    false    214            �           2606    23665270    avaliacoes avaliacoes_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_pkey PRIMARY KEY (id_tipo_avaliacao);
 D   ALTER TABLE ONLY public.avaliacoes DROP CONSTRAINT avaliacoes_pkey;
       public            iisvwvstwejsde    false    217            E           2606    23664988 &   bancos bancos_cod_banco_nome_banco_key 
   CONSTRAINT     r   ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_cod_banco_nome_banco_key UNIQUE (cod_banco, nome_banco);
 P   ALTER TABLE ONLY public.bancos DROP CONSTRAINT bancos_cod_banco_nome_banco_key;
       public            iisvwvstwejsde    false    206    206            G           2606    23664986    bancos bancos_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (id_banco);
 <   ALTER TABLE ONLY public.bancos DROP CONSTRAINT bancos_pkey;
       public            iisvwvstwejsde    false    206            >           2606    23664973 '   gravidades gravidades_cod_gravidade_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT gravidades_cod_gravidade_key UNIQUE (cod_gravidade);
 Q   ALTER TABLE ONLY public.gravidades DROP CONSTRAINT gravidades_cod_gravidade_key;
       public            iisvwvstwejsde    false    205            @           2606    23664975 #   gravidades gravidades_descricao_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT gravidades_descricao_key UNIQUE (descricao);
 M   ALTER TABLE ONLY public.gravidades DROP CONSTRAINT gravidades_descricao_key;
       public            iisvwvstwejsde    false    205            B           2606    23664971    gravidades gravidades_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT gravidades_pkey PRIMARY KEY (id_gravidade);
 D   ALTER TABLE ONLY public.gravidades DROP CONSTRAINT gravidades_pkey;
       public            iisvwvstwejsde    false    205            7           2606    23664960 &   idiomas idiomas_abreviatura_idioma_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_abreviatura_idioma_key UNIQUE (abreviatura_idioma);
 P   ALTER TABLE ONLY public.idiomas DROP CONSTRAINT idiomas_abreviatura_idioma_key;
       public            iisvwvstwejsde    false    204            9           2606    23664958    idiomas idiomas_cod_idioma_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_cod_idioma_key UNIQUE (cod_idioma);
 H   ALTER TABLE ONLY public.idiomas DROP CONSTRAINT idiomas_cod_idioma_key;
       public            iisvwvstwejsde    false    204            ;           2606    23664956    idiomas idiomas_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_pkey PRIMARY KEY (id_idioma);
 >   ALTER TABLE ONLY public.idiomas DROP CONSTRAINT idiomas_pkey;
       public            iisvwvstwejsde    false    204            �           2606    23665474 9   meios_debito meios_debito_agencia_conta_id_tipo_conta_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_agencia_conta_id_tipo_conta_key UNIQUE (agencia, conta, id_tipo_conta);
 c   ALTER TABLE ONLY public.meios_debito DROP CONSTRAINT meios_debito_agencia_conta_id_tipo_conta_key;
       public            iisvwvstwejsde    false    220    220    220            �           2606    23665472    meios_debito meios_debito_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_pkey PRIMARY KEY (id_debito);
 H   ALTER TABLE ONLY public.meios_debito DROP CONSTRAINT meios_debito_pkey;
       public            iisvwvstwejsde    false    220            �           2606    23665293    problemas problemas_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_pkey PRIMARY KEY (id_problema);
 B   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_pkey;
       public            iisvwvstwejsde    false    218            �           2606    23665220 +   produtos produtos_id_produto_id_usuario_key 
   CONSTRAINT     x   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_id_produto_id_usuario_key UNIQUE (id_produto, id_usuario);
 U   ALTER TABLE ONLY public.produtos DROP CONSTRAINT produtos_id_produto_id_usuario_key;
       public            iisvwvstwejsde    false    215    215            �           2606    23665218    produtos produtos_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id_produto);
 @   ALTER TABLE ONLY public.produtos DROP CONSTRAINT produtos_pkey;
       public            iisvwvstwejsde    false    215            g           2606    23665106    sexo sexo_cod_sexo_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.sexo
    ADD CONSTRAINT sexo_cod_sexo_key UNIQUE (cod_sexo);
 @   ALTER TABLE ONLY public.sexo DROP CONSTRAINT sexo_cod_sexo_key;
       public            iisvwvstwejsde    false    211            i           2606    23665108    sexo sexo_descricao_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.sexo
    ADD CONSTRAINT sexo_descricao_key UNIQUE (descricao);
 A   ALTER TABLE ONLY public.sexo DROP CONSTRAINT sexo_descricao_key;
       public            iisvwvstwejsde    false    211            k           2606    23665104    sexo sexo_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.sexo
    ADD CONSTRAINT sexo_pkey PRIMARY KEY (id_sexo);
 8   ALTER TABLE ONLY public.sexo DROP CONSTRAINT sexo_pkey;
       public            iisvwvstwejsde    false    211            `           2606    23665091 4   status_aluguel status_aluguel_cod_status_aluguel_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.status_aluguel
    ADD CONSTRAINT status_aluguel_cod_status_aluguel_key UNIQUE (cod_status_aluguel);
 ^   ALTER TABLE ONLY public.status_aluguel DROP CONSTRAINT status_aluguel_cod_status_aluguel_key;
       public            iisvwvstwejsde    false    210            b           2606    23665093 +   status_aluguel status_aluguel_descricao_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.status_aluguel
    ADD CONSTRAINT status_aluguel_descricao_key UNIQUE (descricao);
 U   ALTER TABLE ONLY public.status_aluguel DROP CONSTRAINT status_aluguel_descricao_key;
       public            iisvwvstwejsde    false    210            d           2606    23665089 "   status_aluguel status_aluguel_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.status_aluguel
    ADD CONSTRAINT status_aluguel_pkey PRIMARY KEY (id_status_aluguel);
 L   ALTER TABLE ONLY public.status_aluguel DROP CONSTRAINT status_aluguel_pkey;
       public            iisvwvstwejsde    false    210            Y           2606    23665076 7   status_problema status_problema_cod_status_problema_key 
   CONSTRAINT     �   ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT status_problema_cod_status_problema_key UNIQUE (cod_status_problema);
 a   ALTER TABLE ONLY public.status_problema DROP CONSTRAINT status_problema_cod_status_problema_key;
       public            iisvwvstwejsde    false    209            [           2606    23665078 -   status_problema status_problema_descricao_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT status_problema_descricao_key UNIQUE (descricao);
 W   ALTER TABLE ONLY public.status_problema DROP CONSTRAINT status_problema_descricao_key;
       public            iisvwvstwejsde    false    209            ]           2606    23665074 $   status_problema status_problema_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT status_problema_pkey PRIMARY KEY (id_status_problema);
 N   ALTER TABLE ONLY public.status_problema DROP CONSTRAINT status_problema_pkey;
       public            iisvwvstwejsde    false    209            u           2606    23665158    telefones telefones_celular_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_celular_key UNIQUE (celular);
 I   ALTER TABLE ONLY public.telefones DROP CONSTRAINT telefones_celular_key;
       public            iisvwvstwejsde    false    213            w           2606    23665154    telefones telefones_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_pkey PRIMARY KEY (id_telefone);
 B   ALTER TABLE ONLY public.telefones DROP CONSTRAINT telefones_pkey;
       public            iisvwvstwejsde    false    213            y           2606    23665156     telefones telefones_telefone_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_telefone_key UNIQUE (telefone);
 J   ALTER TABLE ONLY public.telefones DROP CONSTRAINT telefones_telefone_key;
       public            iisvwvstwejsde    false    213            R           2606    23665061 4   tipo_avaliacao tipo_avaliacao_cod_tipo_avaliacao_key 
   CONSTRAINT     }   ALTER TABLE ONLY public.tipo_avaliacao
    ADD CONSTRAINT tipo_avaliacao_cod_tipo_avaliacao_key UNIQUE (cod_tipo_avaliacao);
 ^   ALTER TABLE ONLY public.tipo_avaliacao DROP CONSTRAINT tipo_avaliacao_cod_tipo_avaliacao_key;
       public            iisvwvstwejsde    false    208            T           2606    23665063 +   tipo_avaliacao tipo_avaliacao_descricao_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.tipo_avaliacao
    ADD CONSTRAINT tipo_avaliacao_descricao_key UNIQUE (descricao);
 U   ALTER TABLE ONLY public.tipo_avaliacao DROP CONSTRAINT tipo_avaliacao_descricao_key;
       public            iisvwvstwejsde    false    208            V           2606    23665059 "   tipo_avaliacao tipo_avaliacao_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.tipo_avaliacao
    ADD CONSTRAINT tipo_avaliacao_pkey PRIMARY KEY (id_tipo_avaliacao);
 L   ALTER TABLE ONLY public.tipo_avaliacao DROP CONSTRAINT tipo_avaliacao_pkey;
       public            iisvwvstwejsde    false    208            �           2606    23665462 (   tipo_conta tipo_conta_cod_tipo_conta_key 
   CONSTRAINT     m   ALTER TABLE ONLY public.tipo_conta
    ADD CONSTRAINT tipo_conta_cod_tipo_conta_key UNIQUE (cod_tipo_conta);
 R   ALTER TABLE ONLY public.tipo_conta DROP CONSTRAINT tipo_conta_cod_tipo_conta_key;
       public            iisvwvstwejsde    false    219            �           2606    23665464 )   tipo_conta tipo_conta_descricao_conta_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.tipo_conta
    ADD CONSTRAINT tipo_conta_descricao_conta_key UNIQUE (descricao_conta);
 S   ALTER TABLE ONLY public.tipo_conta DROP CONSTRAINT tipo_conta_descricao_conta_key;
       public            iisvwvstwejsde    false    219            �           2606    23665460    tipo_conta tipo_conta_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.tipo_conta
    ADD CONSTRAINT tipo_conta_pkey PRIMARY KEY (id_tipo_conta);
 D   ALTER TABLE ONLY public.tipo_conta DROP CONSTRAINT tipo_conta_pkey;
       public            iisvwvstwejsde    false    219            K           2606    23665017 1   tipo_problema tipo_problema_cod_tipo_problema_key 
   CONSTRAINT     y   ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT tipo_problema_cod_tipo_problema_key UNIQUE (cod_tipo_problema);
 [   ALTER TABLE ONLY public.tipo_problema DROP CONSTRAINT tipo_problema_cod_tipo_problema_key;
       public            iisvwvstwejsde    false    207            M           2606    23665019 )   tipo_problema tipo_problema_descricao_key 
   CONSTRAINT     i   ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT tipo_problema_descricao_key UNIQUE (descricao);
 S   ALTER TABLE ONLY public.tipo_problema DROP CONSTRAINT tipo_problema_descricao_key;
       public            iisvwvstwejsde    false    207            O           2606    23665015     tipo_problema tipo_problema_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT tipo_problema_pkey PRIMARY KEY (id_tipo_problema);
 J   ALTER TABLE ONLY public.tipo_problema DROP CONSTRAINT tipo_problema_pkey;
       public            iisvwvstwejsde    false    207            �           2606    24015647    traducoes traducoes_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.traducoes
    ADD CONSTRAINT traducoes_pkey PRIMARY KEY (id_traducao);
 B   ALTER TABLE ONLY public.traducoes DROP CONSTRAINT traducoes_pkey;
       public            iisvwvstwejsde    false    223            �           2606    23799828    usuario usuario_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            iisvwvstwejsde    false    222            n           2606    23665121    usuarios usuarios_cpf_key 
   CONSTRAINT     S   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_cpf_key UNIQUE (cpf);
 C   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_cpf_key;
       public            iisvwvstwejsde    false    212            p           2606    23665123    usuarios usuarios_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_email_key;
       public            iisvwvstwejsde    false    212            r           2606    23665119    usuarios usuarios_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);
 @   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_pkey;
       public            iisvwvstwejsde    false    212            �           1259    23665259    ix_tbl_alugueis    INDEX     k   CREATE UNIQUE INDEX ix_tbl_alugueis ON public.alugueis USING btree (data_inicio, data_fim, valor_aluguel);
 #   DROP INDEX public.ix_tbl_alugueis;
       public            iisvwvstwejsde    false    216    216    216            ~           1259    23665182    ix_tbl_autentificacao    INDEX     [   CREATE UNIQUE INDEX ix_tbl_autentificacao ON public.autentificacao USING btree (password);
 )   DROP INDEX public.ix_tbl_autentificacao;
       public            iisvwvstwejsde    false    214            �           1259    23665286    ix_tbl_avaliacoes    INDEX     [   CREATE UNIQUE INDEX ix_tbl_avaliacoes ON public.avaliacoes USING btree (comentario, nota);
 %   DROP INDEX public.ix_tbl_avaliacoes;
       public            iisvwvstwejsde    false    217    217            H           1259    23664989    ix_tbl_bancos    INDEX     X   CREATE UNIQUE INDEX ix_tbl_bancos ON public.bancos USING btree (cod_banco, nome_banco);
 !   DROP INDEX public.ix_tbl_bancos;
       public            iisvwvstwejsde    false    206    206            C           1259    23664976    ix_tbl_gravidades    INDEX     c   CREATE UNIQUE INDEX ix_tbl_gravidades ON public.gravidades USING btree (cod_gravidade, descricao);
 %   DROP INDEX public.ix_tbl_gravidades;
       public            iisvwvstwejsde    false    205    205            <           1259    23664961    ix_tbl_idiomas    INDEX     t   CREATE UNIQUE INDEX ix_tbl_idiomas ON public.idiomas USING btree (cod_idioma, abreviatura_idioma, nome, descricao);
 "   DROP INDEX public.ix_tbl_idiomas;
       public            iisvwvstwejsde    false    204    204    204    204            �           1259    23665490    ix_tbl_meios_debitos    INDEX     ^   CREATE UNIQUE INDEX ix_tbl_meios_debitos ON public.meios_debito USING btree (agencia, conta);
 (   DROP INDEX public.ix_tbl_meios_debitos;
       public            iisvwvstwejsde    false    220    220            �           1259    23665319    ix_tbl_problemas    INDEX     X   CREATE UNIQUE INDEX ix_tbl_problemas ON public.problemas USING btree (valor_reembolso);
 $   DROP INDEX public.ix_tbl_problemas;
       public            iisvwvstwejsde    false    218                       1259    23665226    ix_tbl_produtos    INDEX     V   CREATE UNIQUE INDEX ix_tbl_produtos ON public.produtos USING btree (nome, descricao);
 #   DROP INDEX public.ix_tbl_produtos;
       public            iisvwvstwejsde    false    215    215            e           1259    23665109    ix_tbl_sexo    INDEX     R   CREATE UNIQUE INDEX ix_tbl_sexo ON public.sexo USING btree (cod_sexo, descricao);
    DROP INDEX public.ix_tbl_sexo;
       public            iisvwvstwejsde    false    211    211            ^           1259    23665094    ix_tbl_status_aluguel    INDEX     \   CREATE UNIQUE INDEX ix_tbl_status_aluguel ON public.status_aluguel USING btree (descricao);
 )   DROP INDEX public.ix_tbl_status_aluguel;
       public            iisvwvstwejsde    false    210            W           1259    23665079    ix_tbl_status_problema    INDEX     ^   CREATE UNIQUE INDEX ix_tbl_status_problema ON public.status_problema USING btree (descricao);
 *   DROP INDEX public.ix_tbl_status_problema;
       public            iisvwvstwejsde    false    209            s           1259    23665164    ix_tbl_telefones    INDEX     i   CREATE UNIQUE INDEX ix_tbl_telefones ON public.telefones USING btree (telefone, celular, is_verificado);
 $   DROP INDEX public.ix_tbl_telefones;
       public            iisvwvstwejsde    false    213    213    213            P           1259    23665064    ix_tbl_tipo_avaliacao    INDEX     p   CREATE UNIQUE INDEX ix_tbl_tipo_avaliacao ON public.tipo_avaliacao USING btree (cod_tipo_avaliacao, descricao);
 )   DROP INDEX public.ix_tbl_tipo_avaliacao;
       public            iisvwvstwejsde    false    208    208            �           1259    23665465    ix_tbl_tipo_conta    INDEX     j   CREATE UNIQUE INDEX ix_tbl_tipo_conta ON public.tipo_conta USING btree (cod_tipo_conta, descricao_conta);
 %   DROP INDEX public.ix_tbl_tipo_conta;
       public            iisvwvstwejsde    false    219    219            I           1259    23665020    ix_tbl_tipo_problema    INDEX     m   CREATE UNIQUE INDEX ix_tbl_tipo_problema ON public.tipo_problema USING btree (cod_tipo_problema, descricao);
 (   DROP INDEX public.ix_tbl_tipo_problema;
       public            iisvwvstwejsde    false    207    207            �           1259    24015653    ix_tbl_traducoes    INDEX     h   CREATE UNIQUE INDEX ix_tbl_traducoes ON public.traducoes USING btree (tabela_origem, campo, descricao);
 $   DROP INDEX public.ix_tbl_traducoes;
       public            iisvwvstwejsde    false    223    223    223            l           1259    23665129    ix_tbl_usuarios    INDEX     h   CREATE UNIQUE INDEX ix_tbl_usuarios ON public.usuarios USING btree (nome, cpf, email, data_nascimento);
 #   DROP INDEX public.ix_tbl_usuarios;
       public            iisvwvstwejsde    false    212    212    212    212            �           2620    23665523    alugueis tg_on_updated_alugueis    TRIGGER     }   CREATE TRIGGER tg_on_updated_alugueis BEFORE UPDATE ON public.alugueis FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 8   DROP TRIGGER tg_on_updated_alugueis ON public.alugueis;
       public          iisvwvstwejsde    false    228    216            �           2620    23665522 +   autentificacao tg_on_updated_autentificacao    TRIGGER     �   CREATE TRIGGER tg_on_updated_autentificacao BEFORE UPDATE ON public.autentificacao FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 D   DROP TRIGGER tg_on_updated_autentificacao ON public.autentificacao;
       public          iisvwvstwejsde    false    228    214            �           2620    23665521 #   avaliacoes tg_on_updated_avaliacoes    TRIGGER     �   CREATE TRIGGER tg_on_updated_avaliacoes BEFORE UPDATE ON public.avaliacoes FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 <   DROP TRIGGER tg_on_updated_avaliacoes ON public.avaliacoes;
       public          iisvwvstwejsde    false    228    217            �           2620    23665520    bancos tg_on_updated_bancos    TRIGGER     y   CREATE TRIGGER tg_on_updated_bancos BEFORE UPDATE ON public.bancos FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 4   DROP TRIGGER tg_on_updated_bancos ON public.bancos;
       public          iisvwvstwejsde    false    206    228            �           2620    23665519 #   gravidades tg_on_updated_gravidades    TRIGGER     �   CREATE TRIGGER tg_on_updated_gravidades BEFORE UPDATE ON public.gravidades FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 <   DROP TRIGGER tg_on_updated_gravidades ON public.gravidades;
       public          iisvwvstwejsde    false    228    205            �           2620    23665518    idiomas tg_on_updated_idiomas    TRIGGER     {   CREATE TRIGGER tg_on_updated_idiomas BEFORE UPDATE ON public.idiomas FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 6   DROP TRIGGER tg_on_updated_idiomas ON public.idiomas;
       public          iisvwvstwejsde    false    204    228            �           2620    23665536 '   meios_debito tg_on_updated_meios_debito    TRIGGER     �   CREATE TRIGGER tg_on_updated_meios_debito BEFORE UPDATE ON public.meios_debito FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 @   DROP TRIGGER tg_on_updated_meios_debito ON public.meios_debito;
       public          iisvwvstwejsde    false    228    220            �           2620    23665535 !   problemas tg_on_updated_problemas    TRIGGER        CREATE TRIGGER tg_on_updated_problemas BEFORE UPDATE ON public.problemas FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 :   DROP TRIGGER tg_on_updated_problemas ON public.problemas;
       public          iisvwvstwejsde    false    228    218            �           2620    23665534    produtos tg_on_updated_produtos    TRIGGER     }   CREATE TRIGGER tg_on_updated_produtos BEFORE UPDATE ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 8   DROP TRIGGER tg_on_updated_produtos ON public.produtos;
       public          iisvwvstwejsde    false    215    228            �           2620    23665533    sexo tg_on_updated_sexo    TRIGGER     u   CREATE TRIGGER tg_on_updated_sexo BEFORE UPDATE ON public.sexo FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 0   DROP TRIGGER tg_on_updated_sexo ON public.sexo;
       public          iisvwvstwejsde    false    228    211            �           2620    23665532 +   status_aluguel tg_on_updated_status_aluguel    TRIGGER     �   CREATE TRIGGER tg_on_updated_status_aluguel BEFORE UPDATE ON public.status_aluguel FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 D   DROP TRIGGER tg_on_updated_status_aluguel ON public.status_aluguel;
       public          iisvwvstwejsde    false    228    210            �           2620    23665531 -   status_problema tg_on_updated_status_problema    TRIGGER     �   CREATE TRIGGER tg_on_updated_status_problema BEFORE UPDATE ON public.status_problema FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 F   DROP TRIGGER tg_on_updated_status_problema ON public.status_problema;
       public          iisvwvstwejsde    false    209    228            �           2620    23665530 !   telefones tg_on_updated_telefones    TRIGGER        CREATE TRIGGER tg_on_updated_telefones BEFORE UPDATE ON public.telefones FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 :   DROP TRIGGER tg_on_updated_telefones ON public.telefones;
       public          iisvwvstwejsde    false    213    228            �           2620    23665529 +   tipo_avaliacao tg_on_updated_tipo_avaliacao    TRIGGER     �   CREATE TRIGGER tg_on_updated_tipo_avaliacao BEFORE UPDATE ON public.tipo_avaliacao FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 D   DROP TRIGGER tg_on_updated_tipo_avaliacao ON public.tipo_avaliacao;
       public          iisvwvstwejsde    false    208    228            �           2620    23665528 #   tipo_conta tg_on_updated_tipo_conta    TRIGGER     �   CREATE TRIGGER tg_on_updated_tipo_conta BEFORE UPDATE ON public.tipo_conta FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 <   DROP TRIGGER tg_on_updated_tipo_conta ON public.tipo_conta;
       public          iisvwvstwejsde    false    219    228            �           2620    23665527 )   tipo_problema tg_on_updated_tipo_problema    TRIGGER     �   CREATE TRIGGER tg_on_updated_tipo_problema BEFORE UPDATE ON public.tipo_problema FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 B   DROP TRIGGER tg_on_updated_tipo_problema ON public.tipo_problema;
       public          iisvwvstwejsde    false    207    228            �           2620    23665525    usuarios tg_on_updated_usuarios    TRIGGER     }   CREATE TRIGGER tg_on_updated_usuarios BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();
 8   DROP TRIGGER tg_on_updated_usuarios ON public.usuarios;
       public          iisvwvstwejsde    false    212    228            �           2606    23818981 !   alugueis alugueis_id_produto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id_produto) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.alugueis DROP CONSTRAINT alugueis_id_produto_fkey;
       public          iisvwvstwejsde    false    3971    216    215            �           2606    23665254 (   alugueis alugueis_id_status_aluguel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_id_status_aluguel_fkey FOREIGN KEY (id_status_aluguel) REFERENCES public.status_aluguel(id_status_aluguel);
 R   ALTER TABLE ONLY public.alugueis DROP CONSTRAINT alugueis_id_status_aluguel_fkey;
       public          iisvwvstwejsde    false    210    3940    216            �           2606    23665244 !   alugueis alugueis_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.alugueis DROP CONSTRAINT alugueis_id_usuario_fkey;
       public          iisvwvstwejsde    false    3954    212    216            �           2606    23665177 -   autentificacao autentificacao_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.autentificacao DROP CONSTRAINT autentificacao_id_usuario_fkey;
       public          iisvwvstwejsde    false    214    3954    212            �           2606    23665271 %   avaliacoes avaliacoes_id_aluguel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_id_aluguel_fkey FOREIGN KEY (id_aluguel) REFERENCES public.alugueis(id_aluguel);
 O   ALTER TABLE ONLY public.avaliacoes DROP CONSTRAINT avaliacoes_id_aluguel_fkey;
       public          iisvwvstwejsde    false    3973    216    217            �           2606    23665281 ,   avaliacoes avaliacoes_id_tipo_avaliacao_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_id_tipo_avaliacao_fkey FOREIGN KEY (id_tipo_avaliacao) REFERENCES public.tipo_avaliacao(id_tipo_avaliacao);
 V   ALTER TABLE ONLY public.avaliacoes DROP CONSTRAINT avaliacoes_id_tipo_avaliacao_fkey;
       public          iisvwvstwejsde    false    3926    208    217            �           2606    23665276 /   avaliacoes avaliacoes_id_usuario_avaliador_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_id_usuario_avaliador_fkey FOREIGN KEY (id_usuario_avaliador) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.avaliacoes DROP CONSTRAINT avaliacoes_id_usuario_avaliador_fkey;
       public          iisvwvstwejsde    false    212    3954    217            �           2606    23665480 '   meios_debito meios_debito_id_banco_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_id_banco_fkey FOREIGN KEY (id_banco) REFERENCES public.bancos(id_banco);
 Q   ALTER TABLE ONLY public.meios_debito DROP CONSTRAINT meios_debito_id_banco_fkey;
       public          iisvwvstwejsde    false    220    3911    206            �           2606    23665485 ,   meios_debito meios_debito_id_tipo_conta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_id_tipo_conta_fkey FOREIGN KEY (id_tipo_conta) REFERENCES public.tipo_conta(id_tipo_conta);
 V   ALTER TABLE ONLY public.meios_debito DROP CONSTRAINT meios_debito_id_tipo_conta_fkey;
       public          iisvwvstwejsde    false    3987    219    220            �           2606    23665475 )   meios_debito meios_debito_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.meios_debito DROP CONSTRAINT meios_debito_id_usuario_fkey;
       public          iisvwvstwejsde    false    212    220    3954            �           2606    23665294 #   problemas problemas_id_aluguel_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_aluguel_fkey FOREIGN KEY (id_aluguel) REFERENCES public.alugueis(id_aluguel);
 M   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_id_aluguel_fkey;
       public          iisvwvstwejsde    false    218    3973    216            �           2606    23665309 %   problemas problemas_id_gravidade_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_gravidade_fkey FOREIGN KEY (id_gravidade) REFERENCES public.gravidades(id_gravidade);
 O   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_id_gravidade_fkey;
       public          iisvwvstwejsde    false    218    3906    205            �           2606    23665314 +   problemas problemas_id_status_problema_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_status_problema_fkey FOREIGN KEY (id_status_problema) REFERENCES public.status_problema(id_status_problema);
 U   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_id_status_problema_fkey;
       public          iisvwvstwejsde    false    218    209    3933            �           2606    23665304 )   problemas problemas_id_tipo_problema_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_tipo_problema_fkey FOREIGN KEY (id_tipo_problema) REFERENCES public.tipo_problema(id_tipo_problema);
 S   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_id_tipo_problema_fkey;
       public          iisvwvstwejsde    false    3919    218    207            �           2606    23665299 #   problemas problemas_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.problemas DROP CONSTRAINT problemas_id_usuario_fkey;
       public          iisvwvstwejsde    false    218    3954    212            �           2606    23665221 !   produtos produtos_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.produtos DROP CONSTRAINT produtos_id_usuario_fkey;
       public          iisvwvstwejsde    false    212    3954    215            �           2606    23665159 #   telefones telefones_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.telefones DROP CONSTRAINT telefones_id_usuario_fkey;
       public          iisvwvstwejsde    false    3954    212    213            �           2606    24015648 "   traducoes traducoes_id_idioma_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.traducoes
    ADD CONSTRAINT traducoes_id_idioma_fkey FOREIGN KEY (id_idioma) REFERENCES public.idiomas(id_idioma);
 L   ALTER TABLE ONLY public.traducoes DROP CONSTRAINT traducoes_id_idioma_fkey;
       public          iisvwvstwejsde    false    204    3899    223            �           2606    23665124    usuarios usuarios_id_sexo_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_sexo_fkey FOREIGN KEY (id_sexo) REFERENCES public.sexo(id_sexo);
 H   ALTER TABLE ONLY public.usuarios DROP CONSTRAINT usuarios_id_sexo_fkey;
       public          iisvwvstwejsde    false    211    3947    212            L      x������ � �      J   �  x���KSZA�5��,إ��ӷ����D�(P����SBA}��*+Y�>ݧ�gBL`�T�+�I�T�#����KlHp�-%Ţ�"cC}$I�tʕ	��ª����������y����������tCo��qeO��}q���n��4��f���n���֡�
�1�e���0�����&X'Uq�����u��hHh�l�,�b�	f�+U.�@�����r&�M%�ncg6O�4�ͺŷ��NW��v������nл/G�4�5$F�>'T"��3�}���5�c�	�i�u�؈(�.�*�h���r�uk��^@rx'�^g�O���/����p�����fqk7�:����绫��?쟦��?���}.�Q4�Ϳ�̔Y      M      x������ � �      B      x������ � �      A      x������ � �      @      x������ � �      P      x������ � �      N      x������ � �      K   5  x���Kk�@���_�s���}i}3yah��&��Boi���-�TJ.3���>g��G0�� �z���<Xq����,��9���4d%�1�V��K��%�Y����vY6]�X�̟�y�����a�X��n��h�{t�X#�D�6�1d1<�����e��4�	�q�aKV�*I�do&pB���e4�$�r�iP������7�~�_)qK�jX��+i%92G�`�v*_�C& �C6&����7��|�j?�_�z��j{�����N����)�&U�nM��&\�o�kQ�=}596UU}��@      G   �   x��ιB1E�ؿ
r4���c�!��E"&�*!��
(�Ơ�nttU�脂o�l�LI���q6�ٴ��v���A�Ę s�3@a��9퇢��v,Tzrd��ĕ���+ԅX�]z����57��)��ݪ)T��H��M51���0Y����q�:�TO�a>��;�      F      x������ � �      E      x������ � �      I   �   x�m��MAD�=QpGyk�=A�����C`���:�T���ۨ���uH$R1�=�)>Bw��D���������:z!��<�Qم�Ѐ��B�4N�L����vHʘ��i�[�m`͙}Y��S��6���d�݋{T뎾��0�@�?�W�'2[|���f��"�V��1M[���v��<�'�=+���Ѝ�R�Ҿ� �y�q���)�%tG���q����^�      D      x������ � �      O      x������ � �      C      x������ � �      S      x������ � �      R   W   x�3�4�CCCN3Ss3KsSsN##]3]CS+0�L��I��+I-.Iu �z����E��
)�
`N�Nc#C�=... 
�      H   h  x���ۊ1��=O1�E�$K>�j_�-�^�Ƈ��Ʉl��_'mJ�R��`�c��d���Gi���R/�Z7-��h/o�~����v�/��]��"��k{�کn��ߦh�)����V�j��}�'{ݿmKَ�D�$T��@L�qr��\##` ��K��� yI!f�����T9UIJPc� i�`9��a�ք��y�^����1������>��C
��d��E�cE��gi���� sȿ赫�������e��@E:f�w�6�6��j��}���u�x�$�R*��=�ӫ;��6׆�wXS5fH5�z���[��Q��l(,��	��>e:xZh�J֑N��4M? �C��     