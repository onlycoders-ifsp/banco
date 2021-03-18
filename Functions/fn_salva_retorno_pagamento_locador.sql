create or replace function fn_salva_retorno_pagamento_locador(p_id_saque text, p_id_pagamento_MERCADO_PAGO text, p_tipo_retorno text, P_STATUS TEXT, p_usuario text DEFAULT '')
    RETURNS BOOLEAN
AS $$
BEGIN

    INSERT INTO RETORNO_MERCADO_PAGO_LOCADOR(id_saque, id_pagamento_mercado_pago, tipo_retorno, status)
    values (uuid(p_id_saque), p_id_pagamento_MERCADO_PAGO, p_tipo_retorno, P_STATUS);

    if P_STATUS = 'approved' then
        update saldo_locador
        set sacado = true
        where id_saque = uuid(P_ID_SAQUE);

        update aguardando_saque
            set data_retorno = timezone('America/Sao_Paulo',current_timestamp)
        where id_saque = uuid(p_id_saque);
    end if;

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO EFETUAR BAIXA DE SAQUE', SQLSTATE, SQLERRM, 'fn_salva_retorno_pagamento_locador', 'saldo_locador', CURRENT_QUERY(), p_usuario);
    RETURN FALSE;
END;
$$ LANGUAGE PLPGSQL;
