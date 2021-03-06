CREATE OR REPLACE FUNCTION FN_REPROVA_PROBLEMA(P_ID_ALUGUEL TEXT, P_USUARIO TEXT DEFAULT '')
    RETURNS BOOLEAN
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    UPDATE PROBLEMAS
    SET COD_STATUS_PROBLEMA = 4,
        USUARIO_OPERACAO = UUID(P_USUARIO)
    WHERE ID_ALUGUEL = UUID(P_ID_ALUGUEL);

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO REJEITAR PROBLEMA', SQLSTATE, SQLERRM, 'FN_REPROVA_PROBLEMA', 'PROBLEMAS', CURRENT_QUERY(), P_USUARIO);
    RETURN FALSE;
END;
$$;
