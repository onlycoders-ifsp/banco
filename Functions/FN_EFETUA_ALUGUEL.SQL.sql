create or replace function fn_efetua_aluguel(p_id_usuario text, p_id_produto text, p_data_inicio text, p_data_fim text, p_valor_aluguel double precision, p_usuario text DEFAULT ''::text) returns text
    language plpgsql
as
$$
DECLARE P_ID_ALUGUEL UUID;
    --DECLARE P_STATUS INT;
BEGIN

    INSERT INTO ALUGUEIS(
        ID_USUARIO,
        ID_PRODUTO,
        DATA_INICIO,
        DATA_FIM,
        VALOR_ALUGUEL,
        VALOR_DEBITO,
        cod_status_aluguel)
    SELECT
        UUID(P_ID_USUARIO),
        UUID(P_ID_PRODUTO),
        TO_TIMESTAMP(P_DATA_INICIO,'YYYY-MM-DD HH24:MI:SS'),
        TO_TIMESTAMP(P_DATA_FIM,'YYYY-MM-DD HH24:MI:SS'),
        P_VALOR_ALUGUEL,
        (P_VALOR_ALUGUEL - (P_VALOR_ALUGUEL * SUM(VLR_TAXA))),
        13
    FROM TAXAS
    where id_tipo_taxa = 1
    --RETURNING(ID_ALUGUEL, COD_STATUS_ALUGUEL) INTO P_ID_ALUGUEL,P_STATUS;
    RETURNING(ID_ALUGUEL) INTO P_ID_ALUGUEL;

    INSERT INTO ALUGUEL_HISTORICO(ID_ALUGUEL, COD_STATUS_ALUGUEL)
    VALUES (P_ID_ALUGUEL,13);

    RETURN '"' || CAST(P_ID_ALUGUEL AS TEXT) || '"';

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO EFETUAR ALUGUEIS', SQLSTATE, SQLERRM, 'FN_EFETUA_ALUGUEL', 'ALUGUEIS', CURRENT_QUERY(), P_USUARIO);
    RETURN '';
END;
$$;
