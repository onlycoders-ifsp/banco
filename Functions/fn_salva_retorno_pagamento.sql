create or replace function fn_salva_retorno_pagamento(p_id_aluguel text, p_id_pagamento_MERCADO_PAGO text, p_tipo_retorno text, P_STATUS TEXT, p_valor_pago double precision,p_valor_estorno double precision,p_usuario text DEFAULT '')
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

    /*INSERT INTO ALUGUEL_BAIXA(
        ID_PAGAMENTO)
        SELECT P_ID_PAGAMENTO;
    */

    IF P_STATUS = 'approved' then

        INSERT INTO saldo_locador(
            ID_LOCADOR,
            ID_PAGAMENTO,
            VALOR,
            DESCRICAO,
            SACADO
        )
        SELECT
            U.ID_USUARIO,
            P_ID_PAGAMENTO,
            CASE p_valor_pago
				when 0 then A.VALOR_DEBITO
				else p_valor_pago
			end,
            P.NOME,
            FALSE
        FROM ALUGUEIS A
                 INNER JOIN PRODUTOS P
                            ON P.ID_PRODUTO = A.ID_PRODUTO
                 INNER JOIN USUARIOS U
                            ON U.ID_USUARIO = P.ID_USUARIO
        WHERE ID_ALUGUEL = UUID(p_id_aluguel);

    ELSEIF P_STATUS = 'refunded' then

        INSERT INTO saldo_locador(
            ID_LOCADOR,
            ID_PAGAMENTO,
            VALOR,
            DESCRICAO,
            SACADO
        )
        SELECT
            U.ID_USUARIO,
            P_ID_PAGAMENTO,
            cast(p_valor_estorno as decimal(18,2)) * - 1,
            '[[ESTORNO]] - ' || P.NOME,
            null
        FROM ALUGUEIS A
                 INNER JOIN PRODUTOS P
                            ON P.ID_PRODUTO = A.ID_PRODUTO
                 INNER JOIN USUARIOS U
                            ON U.ID_USUARIO = P.ID_USUARIO
        WHERE ID_ALUGUEL = UUID(p_id_aluguel);
    END IF;

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SALVAR RETORNO_MERCADO_PAGO', SQLSTATE, SQLERRM, 'fn_salva_retorno_pagamento', 'RETORNO_MERCADO_PAGO', CURRENT_QUERY(), P_USUARIO);
    RETURN FALSE;
END;
$$;
