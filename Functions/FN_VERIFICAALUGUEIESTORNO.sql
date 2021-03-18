CREATE OR REPLACE FUNCTION FN_VERIFICAALUGUEIESTORNO(P_USUARIO TEXT)
    RETURNS SETOF RECORD
    LANGUAGE PLPGSQL
AS $$
BEGIN

    RETURN QUERY
        SELECT MAX(AH.ID),
               CAST(A.ID_ALUGUEL AS TEXT),
               CAST(ID_PAGAMENTO_MERCADO_PAGO AS TEXT),
               CAST(VALOR_DEBITO - (VALOR_DEBITO * RETENCAO) AS DECIMAL(18,2)),
               CAST(RETENCAO AS DECIMAL(3,2)),
			   a.COD_STATUS_ALUGUEL
        FROM ALUGUEIS A
        INNER JOIN RETORNO_MERCADO_PAGO
            ON A.ID_ALUGUEL = RETORNO_MERCADO_PAGO.ID_ALUGUEL
        INNER JOIN TIPO_ESTORNO TE
            ON A.COD_STATUS_ALUGUEL = TE.COD_STATUS_ALUGUEL
        INNER JOIN ALUGUEL_HISTORICO AH
            ON A.ID_ALUGUEL = AH.ID_ALUGUEL
            AND A.COD_STATUS_ALUGUEL = AH.COD_STATUS_ALUGUEL
        WHERE ((EXTRACT(DAY FROM AGE(TIMEZONE('UTC',CURRENT_TIMESTAMP),AH.DATA_INCLUSAO)) > 1)
        OR (EXTRACT(HOUR FROM AGE(TIMEZONE('UTC',CURRENT_TIMESTAMP),AH.DATA_INCLUSAO)) > HORA))
        GROUP BY A.ID_ALUGUEL, ID_PAGAMENTO_MERCADO_PAGO, CAST(VALOR_DEBITO - (VALOR_DEBITO * RETENCAO) AS DECIMAL(18,2)), RETENCAO;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO PROCURAR ALUGUEIS PARA ESTORNO', SQLSTATE, SQLERRM, 'FN_VERIFICAALUGUEIESTORNO', 'ALUGUEIS', CURRENT_QUERY(), P_USUARIO);
    RETURN;
END;
$$;