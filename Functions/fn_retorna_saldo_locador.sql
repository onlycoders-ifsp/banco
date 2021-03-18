CREATE OR REPLACE FUNCTION FN_RETORNA_SALDO_LOCADOR(P_ID_USUARIO TEXT, P_USUARIO TEXT DEFAULT '')
    RETURNS SETOF RECORD
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    RETURN QUERY
        SELECT
            cast(s.id_pagamento as text), S.VALOR, S.DESCRICAO, S.SACADO, cast(rmp.id_aluguel as text), TO_CHAR(S.DATA_INCLUSAO,'YYYY-MM-DD HH:MI:DD')
        FROM SALDO_LOCADOR S
        inner join retorno_mercado_pago rmp
            on S.id_pagamento = rmp.id_pagamento
            --and rmp.status = 'approved'
        WHERE S.ID_LOCADOR = UUID(P_ID_USUARIO);
        --and not s.sacado;
EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO RETORNAR EXTRADO LOCADOR', SQLSTATE, SQLERRM, 'FN_RETORNA_SALDO_LOCADOR', 'SALDO_LOCADOR', CURRENT_QUERY(), P_USUARIO);
    RETURN;
END;
$$;
