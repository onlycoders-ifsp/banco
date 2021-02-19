create or replace function fn_salva_retorno_pagamento(p_id_aluguel text, p_id_pagamento_MERCADO_PAGO text, p_tipo_retorno text, P_STATUS TEXT, p_usuario text DEFAULT '')
    returns boolean
    language plpgsql
as
$$
DECLARE P_ID_PAGAMENTO UUID;
BEGIN

    INSERT INTO RETORNO_MERCADO_PAGO(
        ID_ALUGUEL,
        ID_PAGAMENTO_MERCADO_PAGO,
        TIPO_RETORNO,
        STATUS)
    SELECT
        UUID(p_id_aluguel),
        p_id_pagamento_MERCADO_PAGO,
        p_tipo_retorno,
        P_STATUS
		RETURNING (ID_PAGAMENTO) INTO P_ID_PAGAMENTO;

	INSERT INTO ALUGUEL_BAIXA(
		ID_PAGAMENTO)
		SELECT P_ID_PAGAMENTO;

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SALVAR RETORNO_MERCADO_PAGO', SQLSTATE, SQLERRM, 'fn_salva_retorno_pagamento', 'RETORNO_MERCADO_PAGO', CURRENT_QUERY(), P_USUARIO);
    RETURN FALSE;
END;
$$;
