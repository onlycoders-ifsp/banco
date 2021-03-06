CREATE OR REPLACE FUNCTION FN_APROVA_REPROVA_CHK_ENTREGA(P_ID_ALUGUEL TEXT, P_OK BOOLEAN, P_MOTIVO TEXT, P_USUARIO TEXT DEFAULT '')
    RETURNS BOOLEAN AS $$
BEGIN

    UPDATE ALUGUEL_CHK_ENTREGA
    SET ok_locador = P_OK, MOTIVO_RECUSA = P_MOTIVO
    WHERE ID_ALUGUEL = UUID(P_ID_ALUGUEL);

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO ATUALIZAR CHECKLIST ENTREGA', SQLSTATE, SQLERRM, 'FN_APROVA_REPROVA_CHK_ENTREGA', 'ALUGUEL_CHK_ENTREGA', CURRENT_QUERY(),P_USUARIO);
    RETURN FALSE;
END;
$$ LANGUAGE PLPGSQL;
