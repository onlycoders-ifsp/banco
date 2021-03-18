create or replace function FN_RETORNA_RESUMO_EXTRATO(P_ID_USUARIO text)
    returnS SETOF RECORD
    language plpgsql
as
$$
declare p_Valor_Sacado decimal(18,2);
        p_Valor_A_Receber decimal(18,2);
        p_Total decimal(18,2);
BEGIN

    --RETURN QUERY
    select into STRICT  p_Valor_Sacado, p_Valor_A_Receber, p_Total
        cast(sum(case
                     when (sacado
                         or sacado is null) then valor
                     else 0
            end) as decimal(18,
            2)) Valor_Sacado,
        cast(sum(case sacado
                     when false then valor
                     else 0
            end) as decimal(18,
            2)) Valor_A_Receber,
        cast(sum(valor)as decimal(18,
            2)) Total
    from
        saldo_locador
    where
            id_locador = uuid(p_id_usuario)
    group by id_locador;

    return query
    select p_Valor_Sacado, p_Valor_A_Receber, p_Total;

EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN QUERY
        SELECT CAST(0 AS DECIMAL(18,2)),CAST(0 AS DECIMAL(18,2)),CAST(0 AS DECIMAL(18,2));
WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO RETORNAR RESUMO EXTRATO', SQLSTATE, SQLERRM, 'FN_RETORNA_RESUMO_EXTRATO', 'SALDO_LOCADOR', CURRENT_QUERY(), P_ID_USUARIO);
    RETURN;
END;
$$;
