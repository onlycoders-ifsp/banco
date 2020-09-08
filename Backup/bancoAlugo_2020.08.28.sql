--
-- PostgreSQL database dump
--

-- Dumped from database version 12.3
-- Dumped by pg_dump version 12.3

-- Started on 2020-08-28 22:54:12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 17696)
-- Name: log; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA log;


--
-- TOC entry 3 (class 3079 OID 16836)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 2 (class 3079 OID 16873)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 290 (class 1255 OID 16884)
-- Name: fc_on_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fc_on_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.DATA_MODIFICACAO = timezone('America/Sao_Paulo', CURRENT_TIMESTAMP);
	RETURN NEW;
END;
$$;


--
-- TOC entry 319 (class 1255 OID 18051)
-- Name: fn_atualiza_usuario(uuid, text, text, uuid, character varying, character varying, character varying, character varying, character varying, character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_atualiza_usuario(p_id_usuario uuid, p_nome text, p_logradouro text, p_id_cidade uuid, p_numero character varying, p_cep character varying, p_email character varying, p_login character varying, p_sexo character varying, p_telefone character varying, p_celular character varying, p_data_nascimento date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	
	BEGIN
		UPDATE USUARIOS
		SET NOME = P_NOME, EMAIL = P_EMAIL,
		SEXO = P_SEXO, DATA_NASCIMENTO = P_DATA_NASCIMENTO
		WHERE ID_USUARIO = P_ID_USUARIO;
		
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA USUARIO', SQLSTATE, SQLERRM);
		RETURN FALSE;
	END;
	
	BEGIN		
		UPDATE TELEFONES
		SET TELEFONE = P_TELEFONE, CELULAR = P_CELULAR
		WHERE ID_USUARIO = P_ID_USUARIO;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA TELEFONES', SQLSTATE, SQLERRM);
		RETURN FALSE;
	END;
	
	BEGIN
		UPDATE ENDERECO
		SET LOGRADOURO = P_LOGRADOURO, NUMERO = P_NUMERO,
		CEP = P_CEP, ID_CIDADE = P_ID_CIDADE
		WHERE ID_USUARIO = P_ID_USUARIO;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA ENDERECO', SQLSTATE, SQLERRM);
		RETURN FALSE;
	END;
	
	BEGIN
		UPDATE AUTENTIFICACAO
		SET LOGIN = P_LOGIN
		WHERE ID_USUARIO = P_ID_USUARIO;
		
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR NA TABELA AUTENTIFICACAO', SQLSTATE, SQLERRM);
		RETURN FALSE;
	END;
		
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR USUARIO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;


--
-- TOC entry 317 (class 1255 OID 18048)
-- Name: fn_cadastrar_endereco(uuid, uuid, character varying, text, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_cadastrar_endereco(p_id_usuario uuid, p_id_cidade uuid, p_cep character varying, p_logradouro text, p_bairro character varying, p_numero character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	 
	INSERT INTO ENDERECO(
		ID_USUARIO, 
		ID_CIDADE, 
		CEP, 
		LOGRADOURO, 
		BAIRRO,
		NUMERO)
	VALUES(
		P_ID_USUARIO, 
		P_ID_CIDADE, 
		P_CEP,
		P_LOGRADOURO,
		P_BAIRRO,
		P_NUMERO);

	RETURN TRUE;

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO CADASTRAR ENDEREÇO', SQLSTATE, SQLERRM);
		RETURN FALSE;
END;
$$;


--
-- TOC entry 303 (class 1255 OID 16888)
-- Name: fn_cadastrar_produto(uuid, text, text, numeric, numeric, numeric, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_cadastrar_produto(p_id_usuario uuid, p_nome text, p_descricao text, p_valor_base_diaria numeric, p_valor_base_mensal numeric, p_valor_produto numeric, p_data_compra date) RETURNS boolean
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


--
-- TOC entry 304 (class 1255 OID 16889)
-- Name: fn_deleta_produto(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_deleta_produto(p_id_produto uuid) RETURNS boolean
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


--
-- TOC entry 305 (class 1255 OID 16890)
-- Name: fn_deleta_usuario(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_deleta_usuario(p_id_usuario uuid) RETURNS boolean
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


--
-- TOC entry 306 (class 1255 OID 16891)
-- Name: fn_get_id_sexo(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_get_id_sexo(sexo integer) RETURNS uuid
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


--
-- TOC entry 316 (class 1255 OID 17975)
-- Name: fn_grava_log(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_grava_log() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
       BEGIN
         IF TG_OP = 'INSERT'
         THEN INSERT INTO LOG.LOG (
                schemaname, tablename, operation, new_val
              ) VALUES (
                TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(NEW)
              );
           RETURN NEW;
         ELSEIF  TG_OP = 'UPDATE'
         THEN
           INSERT INTO log.log (
             schemaname, tablename, operation, new_val, old_val
           )
           VALUES (TG_TABLE_SCHEMA,TG_RELNAME , TG_OP, row_to_json(NEW), row_to_json(OLD));
           RETURN NEW;
         ELSIF TG_OP = 'DELETE'
         THEN
           INSERT INTO log.log
             (schemaname, tablename, operation, old_val)
             VALUES (
               TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(OLD)
             );
             RETURN OLD;
       END IF;
	END;
$$;


--
-- TOC entry 315 (class 1255 OID 17948)
-- Name: fn_inserir_login(uuid, text, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_inserir_login(p_id_usuario uuid, p_senha text, p_id_login character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO AUTENTIFICACAO(ID_USUARIO, PASSWORD, LOGIN)
	VALUES(P_ID_USUARIO, CRYPT(P_SENHA,CONCAT(gen_salt('bf',16),TO_CHAR(CURRENT_TIMESTAMP,'YYYYMMDDHHMMSSMSUS'))), P_ID_LOGIN);
	RETURN TRUE;
	
	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO INSERIR LOGIN', sqlstate, sqlerrm);
		RETURN FALSE;
END;
$$;


--
-- TOC entry 307 (class 1255 OID 16893)
-- Name: fn_inserir_telefones(uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_inserir_telefones(p_id_usuario uuid, p_telefone character varying, p_celular character varying) RETURNS boolean
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


--
-- TOC entry 318 (class 1255 OID 18049)
-- Name: fn_inserir_usuario(text, character varying, character varying, character varying, text, text, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_inserir_usuario(p_nome text, p_cpf character varying, p_email character varying, p_sexo character varying, p_nascimento text, p_senha text, p_login character varying DEFAULT NULL::character varying, p_telefone character varying DEFAULT NULL::character varying, p_celular character varying DEFAULT NULL::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE P_ID_USUARIO UUID;
DECLARE OK BOOLEAN = FALSE;
DECLARE P_DATA_NASCIMENTO DATE;
BEGIN
	
	P_DATA_NASCIMENTO := TO_DATE(P_NASCIMENTO, 'YYYY-MM-DD');
	
	/*
	SELECT FN_GET_ID_SEXO(P_SEXO) INTO P_ID_SEXO;
	
	IF P_ID_SEXO IS NULL THEN
		RAISE INFO 'NÃO FOI ENCONTRADO O SEXO';
		RETURN FALSE;
	END IF;
	*/
	
	BEGIN
		INSERT INTO USUARIOS(
		NOME,
		CPF,
		EMAIL,
		SEXO,
		DATA_NASCIMENTO)
		VALUES(
		P_NOME,
		P_CPF,
		P_EMAIL,
		P_SEXO,
		P_DATA_NASCIMENTO)
		RETURNING ID_USUARIO INTO P_ID_USUARIO;
	
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO INSERIR O USUARIO', sqlstate, sqlerrm);
			RETURN FALSE;
	END;
	
	IF P_LOGIN IS NULL THEN
		P_LOGIN := P_EMAIL;
	END IF;
		
	SELECT FN_INSERIR_LOGIN(P_ID_USUARIO, P_SENHA, P_LOGIN) INTO OK;
	
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


--
-- TOC entry 308 (class 1255 OID 16895)
-- Name: fn_report_erro(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_report_erro(descricao text, state text, erro text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN						  
	RAISE INFO '%', DESCRICAO;
	RAISE NOTICE '% %', STATE, ERRO;
	
	EXCEPTION WHEN OTHERS THEN
		RAISE INFO 'ERRO NO ERRO % %', sqlstate, sqlerrm;
END;
$$;


--
-- TOC entry 320 (class 1255 OID 18052)
-- Name: fn_retorna_produto(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_retorna_produto(p_id_usuario uuid DEFAULT NULL::uuid) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
BEGIN
	 
	RETURN QUERY 
		SELECT U.NOME, P.NOME, P.DESCRICAO, P.VALOR_BASE_DIARIA,
		P.VALOR_BASE_MENSAL, P.VALOR_PRODUTO
		FROM PRODUTOS P
		INNER JOIN USUARIOS U
		ON P.ID_USUARIO = U.ID_USUARIO
		WHERE (U.ID_USUARIO = P_ID_USUARIO OR P_ID_USUARIO IS NULL)
		AND P.ISDELETADO = FALSE ;

	EXCEPTION WHEN OTHERS THEN
		PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR PRODUTO', SQLSTATE, SQLERRM);

END;
$$;


--
-- TOC entry 309 (class 1255 OID 16896)
-- Name: fn_retorna_sexo(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_retorna_sexo() RETURNS SETOF record
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


--
-- TOC entry 321 (class 1255 OID 18056)
-- Name: fn_retorna_usuario(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_retorna_usuario(p_id_usuario uuid DEFAULT NULL::uuid) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
		RETURN QUERY SELECT U.NOME, U.CPF, U.EMAIL, U.SEXO, 
		(SELECT COUNT(1)FROM PRODUTOS PP WHERE U.ID_USUARIO = PP.ID_USUARIO AND PP.ISDELETADO = FALSE) PRODUTOS_CADASTRADOS,
		T.TELEFONE, T.CELULAR, U.DATA_INCLUSAO, P.NOME, ES.UF, C.NOME, 
		E.LOGRADOURO, E.NUMERO, E.BAIRRO
		FROM USUARIOS U
		LEFT JOIN TELEFONES T
		ON T.ID_USUARIO = U.ID_USUARIO
		LEFT JOIN ENDERECO E
		ON E.ID_USUARIO = U.ID_USUARIO
		LEFT JOIN CIDADE C 
		ON C.ID_CIDADE = E.ID_CIDADE
		LEFT JOIN ESTADO ES
		ON C.ID_ESTADO = ES.ID_ESTADO
		LEFT JOIN PAIS P
		ON P.ID_PAIS = ES.ID_PAIS
		WHERE (U.ID_USUARIO = P_ID_USUARIO OR P_ID_USUARIO IS NULL)
		AND U.ISDELETADO = FALSE;
		
		EXCEPTION WHEN OTHERS THEN
			PERFORM FN_REPORT_ERRO('ERRO AO SELECIONA USUARIO', SQLSTATE, SQLERRM);
	RETURN;
END;
$$;


--
-- TOC entry 310 (class 1255 OID 16898)
-- Name: fn_retornar_produto(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_retornar_produto(p_id_usuario uuid DEFAULT NULL::uuid) RETURNS SETOF record
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


--
-- TOC entry 311 (class 1255 OID 16899)
-- Name: fn_verifcar_login(character varying, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_verifcar_login(p_email character varying, p_senha text) RETURNS text
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


--
-- TOC entry 312 (class 1255 OID 16900)
-- Name: fn_verifica_existe_usuario(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_verifica_existe_usuario(p_email character varying, p_cpf character varying) RETURNS boolean
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


--
-- TOC entry 314 (class 1255 OID 17758)
-- Name: log_ddl(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.log_ddl() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

  audit_query TEXT;

  r RECORD;

BEGIN

  IF tg_tag not like 'DROP%'

  THEN

    --r := pg_event_trigger_ddl_commands();

    INSERT INTO log.log_ddl (operacao, object_name) 
	SELECT TG_TAG, object_identity
	FROM pg_event_trigger_ddl_commands(); --(tg_tag, r.object_identity);

  END IF;

END;

$$;


--
-- TOC entry 313 (class 1255 OID 17759)
-- Name: log_ddl_drop(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.log_ddl_drop() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

BEGIN

  IF tg_tag like 'DROP%' THEN
	  
	INSERT INTO log.log_ddl (operacao, object_name) 
	SELECT TG_TAG, object_identity
	FROM pg_event_trigger_dropped_objects() ;

  END IF;

END;

$$;


SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 17699)
-- Name: log; Type: TABLE; Schema: log; Owner: -
--

CREATE TABLE log.log (
    id integer NOT NULL,
    date timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    schemaname text,
    tablename text,
    operation text,
    who text DEFAULT CURRENT_USER,
    new_val json,
    old_val json,
    query text DEFAULT current_query()
);


--
-- TOC entry 229 (class 1259 OID 17791)
-- Name: log_ddl; Type: TABLE; Schema: log; Owner: -
--

CREATE TABLE log.log_ddl (
    id_ddl integer NOT NULL,
    operacao text,
    usuario text DEFAULT CURRENT_USER,
    object_name text,
    query text DEFAULT current_query(),
    data timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP)
);


--
-- TOC entry 228 (class 1259 OID 17789)
-- Name: log_ddl_id_ddl_seq; Type: SEQUENCE; Schema: log; Owner: -
--

CREATE SEQUENCE log.log_ddl_id_ddl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 228
-- Name: log_ddl_id_ddl_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: -
--

ALTER SEQUENCE log.log_ddl_id_ddl_seq OWNED BY log.log_ddl.id_ddl;


--
-- TOC entry 226 (class 1259 OID 17697)
-- Name: log_id_seq; Type: SEQUENCE; Schema: log; Owner: -
--

CREATE SEQUENCE log.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 226
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: log; Owner: -
--

ALTER SEQUENCE log.log_id_seq OWNED BY log.log.id;


--
-- TOC entry 207 (class 1259 OID 16901)
-- Name: alugueis; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alugueis (
    id_aluguel uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    id_produto uuid,
    data_inicio date NOT NULL,
    data_fim date NOT NULL,
    valor_aluguel numeric(16,2) NOT NULL,
    cod_status_aluguel integer,
    valor_debito numeric(16,2) NOT NULL,
    data_saque date NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 235 (class 1259 OID 18059)
-- Name: aluguel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aluguel (
    id integer NOT NULL,
    data_fim timestamp without time zone,
    data_inicio timestamp without time zone,
    data_saque timestamp without time zone,
    locatario_id integer,
    produto_id integer
);


--
-- TOC entry 234 (class 1259 OID 18057)
-- Name: aluguel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.aluguel ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.aluguel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 208 (class 1259 OID 16909)
-- Name: autentificacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autentificacao (
    id_autentificacao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    password text NOT NULL,
    login character varying(50),
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 209 (class 1259 OID 16917)
-- Name: avaliacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.avaliacoes (
    id_avaliacao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_aluguel uuid,
    comentario text,
    nota numeric(3,1),
    cod_tipo_avaliacao integer NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone,
    CONSTRAINT avaliacoes_nota_check CHECK ((nota < (11)::numeric))
);


--
-- TOC entry 210 (class 1259 OID 16926)
-- Name: bancos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bancos (
    id_banco uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    ispb character varying(10) NOT NULL,
    cod_compe character varying(5),
    compe boolean,
    nome text,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 232 (class 1259 OID 17899)
-- Name: cidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cidade (
    id_cidade uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_estado uuid,
    nome character varying(50) NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 233 (class 1259 OID 17922)
-- Name: endereco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.endereco (
    id_endereco uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    id_cidade uuid NOT NULL,
    cep character varying(20),
    logradouro text NOT NULL,
    bairro character varying(50),
    numero character varying(20),
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 231 (class 1259 OID 17883)
-- Name: estado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.estado (
    id_estado uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_pais uuid,
    uf character(2) NOT NULL,
    nome character varying(50) NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 211 (class 1259 OID 16934)
-- Name: gravidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gravidades (
    cod_gravidade integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP)),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 224 (class 1259 OID 17478)
-- Name: idiomas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.idiomas (
    id_idioma uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    codigo character(5) NOT NULL,
    descricao character varying(100),
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone,
    CONSTRAINT upper_constraint CHECK ((("substring"((codigo)::text, 1, 2) = lower("substring"((codigo)::text, 1, 2))) AND ("substring"((codigo)::text, 3, 1) = '-'::text) AND ("substring"((codigo)::text, 4) = upper("substring"((codigo)::text, 4)))))
);


--
-- TOC entry 212 (class 1259 OID 16950)
-- Name: meios_debito; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meios_debito (
    id_debito uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    agencia character varying(10) NOT NULL,
    conta character varying(15) NOT NULL,
    id_banco uuid,
    cod_tipo_conta integer,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 230 (class 1259 OID 17873)
-- Name: pais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pais (
    id_pais uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    sigla character(3) NOT NULL,
    nome character varying(50) NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone,
    CONSTRAINT upper_constraint CHECK ((((sigla)::text = upper((sigla)::text)) AND ("substring"((nome)::text, 1, 1) = upper("substring"((nome)::text, 1, 1)))))
);


--
-- TOC entry 213 (class 1259 OID 16955)
-- Name: problemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.problemas (
    id_problema uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_aluguel uuid,
    cod_tipo_problema integer,
    cod_gravidade integer,
    valor_reembolso numeric(16,2) NOT NULL,
    cod_status_problema integer,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 237 (class 1259 OID 18066)
-- Name: produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produto (
    id integer NOT NULL,
    ativo boolean,
    data_compra timestamp without time zone,
    nome character varying(255),
    valor_base_diaria double precision,
    valor_base_mensal double precision,
    valor_produto double precision,
    locatario_id integer
);


--
-- TOC entry 236 (class 1259 OID 18064)
-- Name: produto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.produto ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.produto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 214 (class 1259 OID 16960)
-- Name: produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produtos (
    id_produto uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    nome text NOT NULL,
    descricao text NOT NULL,
    valor_base_diaria numeric(16,2) NOT NULL,
    valor_base_mensal numeric(16,2) NOT NULL,
    valor_produto numeric(16,2) NOT NULL,
    data_compra date NOT NULL,
    isdeletado boolean DEFAULT false,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 240 (class 1259 OID 18522)
-- Name: sq_gravidades; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_gravidades
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4245 (class 0 OID 0)
-- Dependencies: 240
-- Name: sq_gravidades; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_gravidades OWNED BY public.gravidades.cod_gravidade;


--
-- TOC entry 215 (class 1259 OID 16976)
-- Name: status_aluguel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.status_aluguel (
    cod_status_aluguel integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 238 (class 1259 OID 18447)
-- Name: sq_status_aluguel; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_status_aluguel
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4246 (class 0 OID 0)
-- Dependencies: 238
-- Name: sq_status_aluguel; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_status_aluguel OWNED BY public.status_aluguel.cod_status_aluguel;


--
-- TOC entry 216 (class 1259 OID 16984)
-- Name: status_problema; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.status_problema (
    cod_status_problema integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 242 (class 1259 OID 18583)
-- Name: sq_status_problema; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_status_problema
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4247 (class 0 OID 0)
-- Dependencies: 242
-- Name: sq_status_problema; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_status_problema OWNED BY public.status_problema.cod_status_problema;


--
-- TOC entry 218 (class 1259 OID 16998)
-- Name: tipo_avaliacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_avaliacao (
    cod_tipo_avaliacao integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 239 (class 1259 OID 18500)
-- Name: sq_tipo_avaliacao; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_tipo_avaliacao
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4248 (class 0 OID 0)
-- Dependencies: 239
-- Name: sq_tipo_avaliacao; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_tipo_avaliacao OWNED BY public.tipo_avaliacao.cod_tipo_avaliacao;


--
-- TOC entry 219 (class 1259 OID 17006)
-- Name: tipo_conta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_conta (
    cod_tipo_conta integer NOT NULL,
    descricao_conta text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 241 (class 1259 OID 18563)
-- Name: sq_tipo_conta; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_tipo_conta
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4249 (class 0 OID 0)
-- Dependencies: 241
-- Name: sq_tipo_conta; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_tipo_conta OWNED BY public.tipo_conta.cod_tipo_conta;


--
-- TOC entry 220 (class 1259 OID 17014)
-- Name: tipo_problema; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tipo_problema (
    cod_tipo_problema integer NOT NULL,
    descricao text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 243 (class 1259 OID 18586)
-- Name: sq_tipo_problema; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sq_tipo_problema
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4250 (class 0 OID 0)
-- Dependencies: 243
-- Name: sq_tipo_problema; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sq_tipo_problema OWNED BY public.tipo_problema.cod_tipo_problema;


--
-- TOC entry 217 (class 1259 OID 16992)
-- Name: telefones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.telefones (
    id_telefone uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_usuario uuid,
    telefone character varying(20),
    celular character varying(20),
    is_verificado boolean DEFAULT false NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NOT NULL,
    data_modificacao timestamp with time zone
);


--
-- TOC entry 225 (class 1259 OID 17504)
-- Name: traducoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.traducoes (
    id_traducao uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    id_idioma uuid,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 221 (class 1259 OID 17030)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    cep character varying(255),
    cpf character varying(255),
    data_nascimento timestamp without time zone,
    email character varying(255),
    logradouro character varying(255),
    nome character varying(255),
    numero character varying(255),
    ativo boolean,
    login character varying(255),
    senha character varying(255),
    codigo character varying(255)
);


--
-- TOC entry 222 (class 1259 OID 17036)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.usuario ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 17038)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuarios (
    id_usuario uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nome text NOT NULL,
    cpf character varying(14) NOT NULL,
    email character varying(50) NOT NULL,
    sexo character varying(50),
    data_nascimento date NOT NULL,
    isdeletado boolean DEFAULT false,
    data_inclusao timestamp with time zone DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP),
    data_modificacao timestamp with time zone
);


--
-- TOC entry 3930 (class 2604 OID 17702)
-- Name: log id; Type: DEFAULT; Schema: log; Owner: -
--

ALTER TABLE ONLY log.log ALTER COLUMN id SET DEFAULT nextval('log.log_id_seq'::regclass);


--
-- TOC entry 3934 (class 2604 OID 17794)
-- Name: log_ddl id_ddl; Type: DEFAULT; Schema: log; Owner: -
--

ALTER TABLE ONLY log.log_ddl ALTER COLUMN id_ddl SET DEFAULT nextval('log.log_ddl_id_ddl_seq'::regclass);


--
-- TOC entry 3901 (class 2604 OID 18524)
-- Name: gravidades cod_gravidade; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gravidades ALTER COLUMN cod_gravidade SET DEFAULT nextval('public.sq_gravidades'::regclass);


--
-- TOC entry 3910 (class 2604 OID 18449)
-- Name: status_aluguel cod_status_aluguel; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_aluguel ALTER COLUMN cod_status_aluguel SET DEFAULT nextval('public.sq_status_aluguel'::regclass);


--
-- TOC entry 3912 (class 2604 OID 18585)
-- Name: status_problema cod_status_problema; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_problema ALTER COLUMN cod_status_problema SET DEFAULT nextval('public.sq_status_problema'::regclass);


--
-- TOC entry 3917 (class 2604 OID 18503)
-- Name: tipo_avaliacao cod_tipo_avaliacao; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_avaliacao ALTER COLUMN cod_tipo_avaliacao SET DEFAULT nextval('public.sq_tipo_avaliacao'::regclass);


--
-- TOC entry 3919 (class 2604 OID 18566)
-- Name: tipo_conta cod_tipo_conta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_conta ALTER COLUMN cod_tipo_conta SET DEFAULT nextval('public.sq_tipo_conta'::regclass);


--
-- TOC entry 3921 (class 2604 OID 18588)
-- Name: tipo_problema cod_tipo_problema; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_problema ALTER COLUMN cod_tipo_problema SET DEFAULT nextval('public.sq_tipo_problema'::regclass);


--
-- TOC entry 4028 (class 2606 OID 17802)
-- Name: log_ddl log_ddl_pkey; Type: CONSTRAINT; Schema: log; Owner: -
--

ALTER TABLE ONLY log.log_ddl
    ADD CONSTRAINT log_ddl_pkey PRIMARY KEY (id_ddl);


--
-- TOC entry 3948 (class 2606 OID 17048)
-- Name: alugueis alugueis_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_pkey PRIMARY KEY (id_aluguel);


--
-- TOC entry 4046 (class 2606 OID 18063)
-- Name: aluguel aluguel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aluguel
    ADD CONSTRAINT aluguel_pkey PRIMARY KEY (id);


--
-- TOC entry 3951 (class 2606 OID 17050)
-- Name: autentificacao autentificacao_id_usuario_password_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_id_usuario_password_key UNIQUE (id_usuario, password);


--
-- TOC entry 3953 (class 2606 OID 17052)
-- Name: autentificacao autentificacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_pkey PRIMARY KEY (id_autentificacao);


--
-- TOC entry 3958 (class 2606 OID 17058)
-- Name: bancos bancos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (id_banco);


--
-- TOC entry 4040 (class 2606 OID 17905)
-- Name: cidade cidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cidade
    ADD CONSTRAINT cidade_pkey PRIMARY KEY (id_cidade);


--
-- TOC entry 4043 (class 2606 OID 18012)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id_endereco);


--
-- TOC entry 4035 (class 2606 OID 17889)
-- Name: estado estado_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id_estado);


--
-- TOC entry 4037 (class 2606 OID 17891)
-- Name: estado estado_sigla_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_sigla_key UNIQUE (uf);


--
-- TOC entry 3960 (class 2606 OID 17060)
-- Name: gravidades gravidades_cod_gravidade_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT gravidades_cod_gravidade_key UNIQUE (cod_gravidade);


--
-- TOC entry 3962 (class 2606 OID 17062)
-- Name: gravidades gravidades_descricao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT gravidades_descricao_key UNIQUE (descricao);


--
-- TOC entry 4018 (class 2606 OID 17486)
-- Name: idiomas idiomas_codigo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_codigo_key UNIQUE (codigo);


--
-- TOC entry 4020 (class 2606 OID 17484)
-- Name: idiomas idiomas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.idiomas
    ADD CONSTRAINT idiomas_pkey PRIMARY KEY (id_idioma);


--
-- TOC entry 3967 (class 2606 OID 18541)
-- Name: meios_debito meios_debito_agencia_conta_id_tipo_conta_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_agencia_conta_id_tipo_conta_key UNIQUE (agencia, conta, cod_tipo_conta);


--
-- TOC entry 3969 (class 2606 OID 17074)
-- Name: meios_debito meios_debito_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_pkey PRIMARY KEY (id_debito);


--
-- TOC entry 4031 (class 2606 OID 17879)
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id_pais);


--
-- TOC entry 4033 (class 2606 OID 18019)
-- Name: pais pais_sigla_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_sigla_key UNIQUE (sigla);


--
-- TOC entry 3956 (class 2606 OID 18516)
-- Name: avaliacoes pk_avaliacao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT pk_avaliacao_key PRIMARY KEY (id_avaliacao);


--
-- TOC entry 3964 (class 2606 OID 18142)
-- Name: gravidades pk_gravidade; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gravidades
    ADD CONSTRAINT pk_gravidade PRIMARY KEY (cod_gravidade);


--
-- TOC entry 3978 (class 2606 OID 18446)
-- Name: status_aluguel pk_status_aluguel_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_aluguel
    ADD CONSTRAINT pk_status_aluguel_key PRIMARY KEY (cod_status_aluguel);


--
-- TOC entry 3982 (class 2606 OID 18150)
-- Name: status_problema pk_status_problema; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT pk_status_problema PRIMARY KEY (cod_status_problema);


--
-- TOC entry 4003 (class 2606 OID 18135)
-- Name: tipo_problema pk_tipo_problema; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT pk_tipo_problema PRIMARY KEY (cod_tipo_problema);


--
-- TOC entry 3971 (class 2606 OID 17076)
-- Name: problemas problemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_pkey PRIMARY KEY (id_problema);


--
-- TOC entry 4048 (class 2606 OID 18070)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3974 (class 2606 OID 17078)
-- Name: produtos produtos_id_produto_id_usuario_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_id_produto_id_usuario_key UNIQUE (id_produto, id_usuario);


--
-- TOC entry 3976 (class 2606 OID 17080)
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id_produto);


--
-- TOC entry 3980 (class 2606 OID 17090)
-- Name: status_aluguel status_aluguel_descricao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_aluguel
    ADD CONSTRAINT status_aluguel_descricao_key UNIQUE (descricao);


--
-- TOC entry 3984 (class 2606 OID 17094)
-- Name: status_problema status_problema_cod_status_problema_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT status_problema_cod_status_problema_key UNIQUE (cod_status_problema);


--
-- TOC entry 3986 (class 2606 OID 17096)
-- Name: status_problema status_problema_descricao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.status_problema
    ADD CONSTRAINT status_problema_descricao_key UNIQUE (descricao);


--
-- TOC entry 3989 (class 2606 OID 17100)
-- Name: telefones telefones_celular_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_celular_key UNIQUE (celular);


--
-- TOC entry 3991 (class 2606 OID 17102)
-- Name: telefones telefones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_pkey PRIMARY KEY (id_telefone);


--
-- TOC entry 3993 (class 2606 OID 17104)
-- Name: telefones telefones_telefone_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_telefone_key UNIQUE (telefone);


--
-- TOC entry 3995 (class 2606 OID 17108)
-- Name: tipo_avaliacao tipo_avaliacao_descricao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_avaliacao
    ADD CONSTRAINT tipo_avaliacao_descricao_key UNIQUE (descricao);


--
-- TOC entry 3997 (class 2606 OID 18505)
-- Name: tipo_avaliacao tipo_avaliacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_avaliacao
    ADD CONSTRAINT tipo_avaliacao_pkey PRIMARY KEY (cod_tipo_avaliacao);


--
-- TOC entry 3999 (class 2606 OID 17114)
-- Name: tipo_conta tipo_conta_descricao_conta_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_conta
    ADD CONSTRAINT tipo_conta_descricao_conta_key UNIQUE (descricao_conta);


--
-- TOC entry 4001 (class 2606 OID 18568)
-- Name: tipo_conta tipo_conta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_conta
    ADD CONSTRAINT tipo_conta_pkey PRIMARY KEY (cod_tipo_conta);


--
-- TOC entry 4005 (class 2606 OID 17118)
-- Name: tipo_problema tipo_problema_cod_tipo_problema_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT tipo_problema_cod_tipo_problema_key UNIQUE (cod_tipo_problema);


--
-- TOC entry 4007 (class 2606 OID 17120)
-- Name: tipo_problema tipo_problema_descricao_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tipo_problema
    ADD CONSTRAINT tipo_problema_descricao_key UNIQUE (descricao);


--
-- TOC entry 4024 (class 2606 OID 17513)
-- Name: traducoes traducoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traducoes
    ADD CONSTRAINT traducoes_pkey PRIMARY KEY (id_traducao);


--
-- TOC entry 4009 (class 2606 OID 17126)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4012 (class 2606 OID 17128)
-- Name: usuarios usuarios_cpf_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_cpf_key UNIQUE (cpf);


--
-- TOC entry 4014 (class 2606 OID 17130)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 4016 (class 2606 OID 17132)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 4025 (class 1259 OID 17824)
-- Name: ix_tbl_log; Type: INDEX; Schema: log; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_log ON log.log USING btree (id, date, schemaname, tablename, operation, who);


--
-- TOC entry 4026 (class 1259 OID 17826)
-- Name: ix_tbl_log_ddl; Type: INDEX; Schema: log; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_log_ddl ON log.log_ddl USING btree (id_ddl, operacao, usuario, object_name, query, data);


--
-- TOC entry 3949 (class 1259 OID 17827)
-- Name: ix_tbl_alugueis; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_alugueis ON public.alugueis USING btree (id_aluguel, id_usuario, id_produto, data_inicio, data_fim, valor_aluguel, data_inclusao);


--
-- TOC entry 3954 (class 1259 OID 17828)
-- Name: ix_tbl_autentificacao; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_autentificacao ON public.autentificacao USING btree (id_autentificacao, id_usuario, password, login, data_inclusao);


--
-- TOC entry 4041 (class 1259 OID 17911)
-- Name: ix_tbl_cidade; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_cidade ON public.cidade USING btree (id_cidade, id_estado, nome, data_inclusao);


--
-- TOC entry 4044 (class 1259 OID 17942)
-- Name: ix_tbl_endereco; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_endereco ON public.endereco USING btree (id_endereco, id_usuario, id_cidade, cep, logradouro, numero, data_inclusao);


--
-- TOC entry 4038 (class 1259 OID 17897)
-- Name: ix_tbl_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_estado ON public.estado USING btree (id_estado, id_pais, uf, nome, data_inclusao);


--
-- TOC entry 4021 (class 1259 OID 17832)
-- Name: ix_tbl_idiomas; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_idiomas ON public.idiomas USING btree (id_idioma, codigo, descricao, data_inclusao);


--
-- TOC entry 3965 (class 1259 OID 18542)
-- Name: ix_tbl_meios_debitos; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_meios_debitos ON public.meios_debito USING btree (id_debito, id_usuario, agencia, conta, id_banco, cod_tipo_conta, data_inclusao);


--
-- TOC entry 4029 (class 1259 OID 18020)
-- Name: ix_tbl_pais; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_pais ON public.pais USING btree (id_pais, sigla, nome, data_inclusao);


--
-- TOC entry 3972 (class 1259 OID 17835)
-- Name: ix_tbl_produtos; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_produtos ON public.produtos USING btree (id_produto, id_usuario, nome, descricao, valor_produto, data_compra, data_inclusao);


--
-- TOC entry 3987 (class 1259 OID 17838)
-- Name: ix_tbl_telefones; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_telefones ON public.telefones USING btree (id_telefone, id_usuario, telefone, celular, is_verificado, data_inclusao);


--
-- TOC entry 4022 (class 1259 OID 17842)
-- Name: ix_tbl_traducoes; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_traducoes ON public.traducoes USING btree (id_traducao, id_idioma, key, value, data_inclusao);


--
-- TOC entry 4010 (class 1259 OID 17843)
-- Name: ix_tbl_usuarios; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_tbl_usuarios ON public.usuarios USING btree (id_usuario, nome, cpf, email, data_nascimento, sexo, data_nascimento);


--
-- TOC entry 4078 (class 2620 OID 17998)
-- Name: bancos tg_i_u_d_bancos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_bancos BEFORE INSERT OR DELETE OR UPDATE ON public.bancos FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4080 (class 2620 OID 17999)
-- Name: gravidades tg_i_u_d_gravidades; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_gravidades BEFORE INSERT OR DELETE OR UPDATE ON public.gravidades FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4102 (class 2620 OID 18000)
-- Name: idiomas tg_i_u_d_idiomas; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_idiomas BEFORE INSERT OR DELETE OR UPDATE ON public.idiomas FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4088 (class 2620 OID 18004)
-- Name: status_aluguel tg_i_u_d_status_aluguel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_status_aluguel BEFORE INSERT OR DELETE OR UPDATE ON public.status_aluguel FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4090 (class 2620 OID 18005)
-- Name: status_problema tg_i_u_d_status_problema; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_status_problema BEFORE INSERT OR DELETE OR UPDATE ON public.status_problema FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4094 (class 2620 OID 18007)
-- Name: tipo_avaliacao tg_i_u_d_tipo_avaliacao; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_tipo_avaliacao BEFORE INSERT OR DELETE OR UPDATE ON public.tipo_avaliacao FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4096 (class 2620 OID 18008)
-- Name: tipo_conta tg_i_u_d_tipo_conta; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_tipo_conta BEFORE INSERT OR DELETE OR UPDATE ON public.tipo_conta FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4098 (class 2620 OID 18009)
-- Name: tipo_problema tg_i_u_d_tipo_problema; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_tipo_problema BEFORE INSERT OR DELETE OR UPDATE ON public.tipo_problema FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4104 (class 2620 OID 18010)
-- Name: traducoes tg_i_u_d_traducoes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_i_u_d_traducoes BEFORE INSERT OR DELETE OR UPDATE ON public.traducoes FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4073 (class 2620 OID 17962)
-- Name: alugueis tg_on_updated_alugueis; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_alugueis BEFORE UPDATE ON public.alugueis FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4075 (class 2620 OID 17955)
-- Name: autentificacao tg_on_updated_autentificacao; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_autentificacao BEFORE UPDATE ON public.autentificacao FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4077 (class 2620 OID 17952)
-- Name: avaliacoes tg_on_updated_avaliacoes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_avaliacoes BEFORE UPDATE ON public.avaliacoes FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4079 (class 2620 OID 17953)
-- Name: bancos tg_on_updated_bancos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_bancos BEFORE UPDATE ON public.bancos FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4108 (class 2620 OID 17970)
-- Name: cidade tg_on_updated_cidade; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_cidade BEFORE UPDATE ON public.cidade FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4109 (class 2620 OID 17971)
-- Name: endereco tg_on_updated_endereco; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_endereco BEFORE UPDATE ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4107 (class 2620 OID 17969)
-- Name: estado tg_on_updated_estado; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_estado BEFORE UPDATE ON public.estado FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4081 (class 2620 OID 17954)
-- Name: gravidades tg_on_updated_gravidades; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_gravidades BEFORE UPDATE ON public.gravidades FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4103 (class 2620 OID 17972)
-- Name: idiomas tg_on_updated_idiomas; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_idiomas BEFORE UPDATE ON public.idiomas FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4083 (class 2620 OID 17956)
-- Name: meios_debito tg_on_updated_meios_debito; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_meios_debito BEFORE UPDATE ON public.meios_debito FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4106 (class 2620 OID 17968)
-- Name: pais tg_on_updated_pais; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_pais BEFORE UPDATE ON public.pais FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4085 (class 2620 OID 17963)
-- Name: problemas tg_on_updated_problemas; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_problemas BEFORE UPDATE ON public.problemas FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4087 (class 2620 OID 17961)
-- Name: produtos tg_on_updated_produtos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_produtos BEFORE UPDATE ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4089 (class 2620 OID 17957)
-- Name: status_aluguel tg_on_updated_status_aluguel; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_status_aluguel BEFORE UPDATE ON public.status_aluguel FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4091 (class 2620 OID 17958)
-- Name: status_problema tg_on_updated_status_problema; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_status_problema BEFORE UPDATE ON public.status_problema FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4093 (class 2620 OID 17959)
-- Name: telefones tg_on_updated_telefones; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_telefones BEFORE UPDATE ON public.telefones FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4095 (class 2620 OID 17964)
-- Name: tipo_avaliacao tg_on_updated_tipo_avaliacao; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_tipo_avaliacao BEFORE UPDATE ON public.tipo_avaliacao FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4097 (class 2620 OID 17960)
-- Name: tipo_conta tg_on_updated_tipo_conta; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_tipo_conta BEFORE UPDATE ON public.tipo_conta FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4099 (class 2620 OID 17967)
-- Name: tipo_problema tg_on_updated_tipo_problema; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_tipo_problema BEFORE UPDATE ON public.tipo_problema FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4105 (class 2620 OID 17965)
-- Name: traducoes tg_on_updated_traducoes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_traducoes BEFORE UPDATE ON public.traducoes FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4101 (class 2620 OID 17966)
-- Name: usuarios tg_on_updated_usuarios; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_on_updated_usuarios BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.fc_on_updated();


--
-- TOC entry 4072 (class 2620 OID 17995)
-- Name: alugueis tg_u_d_alugueis; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_alugueis BEFORE DELETE OR UPDATE ON public.alugueis FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4074 (class 2620 OID 17996)
-- Name: autentificacao tg_u_d_autentificacao; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_autentificacao BEFORE DELETE OR UPDATE ON public.autentificacao FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4076 (class 2620 OID 17997)
-- Name: avaliacoes tg_u_d_avaliacoes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_avaliacoes BEFORE DELETE OR UPDATE ON public.avaliacoes FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4082 (class 2620 OID 18001)
-- Name: meios_debito tg_u_d_meios_debito; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_meios_debito BEFORE DELETE OR UPDATE ON public.meios_debito FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4084 (class 2620 OID 18002)
-- Name: problemas tg_u_d_problemas; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_problemas BEFORE DELETE OR UPDATE ON public.problemas FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4086 (class 2620 OID 18003)
-- Name: produtos tg_u_d_produtos; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_produtos BEFORE DELETE OR UPDATE ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4092 (class 2620 OID 18006)
-- Name: telefones tg_u_d_telefones; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_telefones BEFORE DELETE OR UPDATE ON public.telefones FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4100 (class 2620 OID 17994)
-- Name: usuarios tg_u_d_usuarios; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tg_u_d_usuarios BEFORE DELETE OR UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.fn_grava_log();


--
-- TOC entry 4049 (class 2606 OID 17168)
-- Name: alugueis alugueis_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id_produto) ON DELETE CASCADE;


--
-- TOC entry 4050 (class 2606 OID 17178)
-- Name: alugueis alugueis_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT alugueis_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4052 (class 2606 OID 17183)
-- Name: autentificacao autentificacao_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autentificacao
    ADD CONSTRAINT autentificacao_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4053 (class 2606 OID 17188)
-- Name: avaliacoes avaliacoes_id_aluguel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_id_aluguel_fkey FOREIGN KEY (id_aluguel) REFERENCES public.alugueis(id_aluguel);


--
-- TOC entry 4066 (class 2606 OID 17906)
-- Name: cidade cidade_id_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cidade
    ADD CONSTRAINT cidade_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estado(id_estado);


--
-- TOC entry 4068 (class 2606 OID 17937)
-- Name: endereco endereco_id_cidade_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_id_cidade_fkey FOREIGN KEY (id_cidade) REFERENCES public.cidade(id_cidade);


--
-- TOC entry 4067 (class 2606 OID 17932)
-- Name: endereco endereco_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 4065 (class 2606 OID 17892)
-- Name: estado estado_id_pais_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.estado
    ADD CONSTRAINT estado_id_pais_fkey FOREIGN KEY (id_pais) REFERENCES public.pais(id_pais);


--
-- TOC entry 4071 (class 2606 OID 18081)
-- Name: produto fk4riwk1y3xhoepjhk84r2v0k8l; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT fk4riwk1y3xhoepjhk84r2v0k8l FOREIGN KEY (locatario_id) REFERENCES public.usuario(id);


--
-- TOC entry 4060 (class 2606 OID 18143)
-- Name: problemas fk_gravidade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT fk_gravidade FOREIGN KEY (cod_gravidade) REFERENCES public.gravidades(cod_gravidade);


--
-- TOC entry 4051 (class 2606 OID 18464)
-- Name: alugueis fk_status_aluguel_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alugueis
    ADD CONSTRAINT fk_status_aluguel_key FOREIGN KEY (cod_status_aluguel) REFERENCES public.status_aluguel(cod_status_aluguel);


--
-- TOC entry 4061 (class 2606 OID 18151)
-- Name: problemas fk_status_problema; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT fk_status_problema FOREIGN KEY (cod_status_problema) REFERENCES public.status_problema(cod_status_problema);


--
-- TOC entry 4054 (class 2606 OID 18517)
-- Name: avaliacoes fk_tipo_avaliacao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT fk_tipo_avaliacao FOREIGN KEY (cod_tipo_avaliacao) REFERENCES public.tipo_avaliacao(cod_tipo_avaliacao);


--
-- TOC entry 4055 (class 2606 OID 18578)
-- Name: meios_debito fk_tipo_conta_key; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT fk_tipo_conta_key FOREIGN KEY (cod_tipo_conta) REFERENCES public.tipo_conta(cod_tipo_conta);


--
-- TOC entry 4059 (class 2606 OID 18136)
-- Name: problemas fk_tipo_problema; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT fk_tipo_problema FOREIGN KEY (cod_tipo_problema) REFERENCES public.tipo_problema(cod_tipo_problema);


--
-- TOC entry 4070 (class 2606 OID 18076)
-- Name: aluguel fkfjaf13catkr306y353gfjb94t; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aluguel
    ADD CONSTRAINT fkfjaf13catkr306y353gfjb94t FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 4069 (class 2606 OID 18071)
-- Name: aluguel fkhl2kpvv3vkpt6ar7wch30eivo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aluguel
    ADD CONSTRAINT fkhl2kpvv3vkpt6ar7wch30eivo FOREIGN KEY (locatario_id) REFERENCES public.usuario(id);


--
-- TOC entry 4056 (class 2606 OID 17203)
-- Name: meios_debito meios_debito_id_banco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_id_banco_fkey FOREIGN KEY (id_banco) REFERENCES public.bancos(id_banco);


--
-- TOC entry 4057 (class 2606 OID 17213)
-- Name: meios_debito meios_debito_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meios_debito
    ADD CONSTRAINT meios_debito_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4058 (class 2606 OID 17218)
-- Name: problemas problemas_id_aluguel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.problemas
    ADD CONSTRAINT problemas_id_aluguel_fkey FOREIGN KEY (id_aluguel) REFERENCES public.alugueis(id_aluguel);


--
-- TOC entry 4062 (class 2606 OID 17243)
-- Name: produtos produtos_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4063 (class 2606 OID 17248)
-- Name: telefones telefones_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.telefones
    ADD CONSTRAINT telefones_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id_usuario) ON DELETE CASCADE;


--
-- TOC entry 4064 (class 2606 OID 17514)
-- Name: traducoes traducoes_id_idioma_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traducoes
    ADD CONSTRAINT traducoes_id_idioma_fkey FOREIGN KEY (id_idioma) REFERENCES public.idiomas(id_idioma);


--
-- TOC entry 3890 (class 3466 OID 17804)
-- Name: log_ddl_drop_info; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER log_ddl_drop_info ON sql_drop
   EXECUTE FUNCTION public.log_ddl_drop();


--
-- TOC entry 3889 (class 3466 OID 17803)
-- Name: log_ddl_info; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER log_ddl_info ON ddl_command_end
   EXECUTE FUNCTION public.log_ddl();


-- Completed on 2020-08-28 22:55:30

--
-- PostgreSQL database dump complete
--

