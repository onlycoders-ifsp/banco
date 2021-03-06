CREATE OR REPLACE FUNCTION FN_SAQUE_LOCADOR(P_ID_USUARIO TEXT)
    RETURNS SETOF RECORD AS $$
DECLARE P_ID_SAQUE UUID;
BEGIN

    DROP TABLE IF EXISTS TEMP_SAQUE;
    CREATE TEMP TABLE TEMP_SAQUE AS
    SELECT
        CAST(U.ID_USUARIO AS TEXT) ID_USUARIO,
        CAST(A.VALOR_DEBITO AS DECIMAL (18,2)) VALOR,
        CAST(P.ID_PRODUTO AS TEXT) ID_PRODUTO,
        CAST(P.NOME AS TEXT) NOME_PRODUTO,
        CAST(P.DESCRICAO_CURTA AS TEXT) DESCRICAO,
        CAST(SS.ID_PAGAMENTO AS TEXT) ID_PAGAMENTO
    FROM SALDO_LOCADOR SS
             INNER JOIN RETORNO_MERCADO_PAGO RMP
                        ON SS.ID_PAGAMENTO = RMP.ID_PAGAMENTO
             INNER JOIN ALUGUEIS A
                        ON RMP.ID_ALUGUEL = A.ID_ALUGUEL
             INNER JOIN PRODUTOS P
                        ON A.ID_PRODUTO = P.ID_PRODUTO
             INNER JOIN USUARIOS U
                        ON P.ID_USUARIO = U.ID_USUARIO
    WHERE U.ID_USUARIO = UUID(P_ID_USUARIO)
      AND VALOR > 0
      AND NOT SACADO
      AND EXTRACT(DAY FROM TIMEZONE('AMERICA/SAO_PAULO',CURRENT_TIMESTAMP)) - EXTRACT(DAY FROM DATA_FIM) > 1;

    INSERT INTO AGUARDANDO_SAQUE(ID_PAGAMENTO)
    SELECT uuid(ID_PAGAMENTO)
    FROM TEMP_SAQUE
    RETURNING(ID_SAQUE) INTO P_ID_SAQUE;

    RETURN QUERY
        SELECT *,CAST(P_ID_SAQUE AS TEXT) FROM TEMP_SAQUE;

    DROP TABLE IF EXISTS TEMP_SAQUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR PRODUTOS PARA SAQUE', SQLSTATE, SQLERRM, 'FN_SAQUE_LOCADOR', 'PRODUTOS/USUARIOS', CURRENT_QUERY(),P_ID_USUARIO);
    RETURN;
END;
$$ LANGUAGE PLPGSQL;
