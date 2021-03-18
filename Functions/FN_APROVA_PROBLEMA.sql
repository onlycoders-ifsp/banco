CREATE OR REPLACE FUNCTION FN_APROVA_PROBLEMA(P_ID_PROBLEMA TEXT, P_GRAVIDADE INTEGER DEFAULT NULL,P_USUARIO TEXT DEFAULT '')
    RETURNS BOOLEAN
    LANGUAGE PLPGSQL
AS
$$
DECLARE P_PERC_REEMBOLSO DECIMAL(5,4);
BEGIN

    IF P_GRAVIDADE = 0 THEN
        P_GRAVIDADE = NULL;
    end if;

    IF (SELECT cod_tipo_problema FROM problemas WHERE id_problema = UUID(P_ID_PROBLEMA)) = 2 THEN
        IF P_GRAVIDADE IS NULL THEN
            RETURN FALSE;
        end if;
        ELSE
            IF P_GRAVIDADE IS NOT NULL THEN
                RETURN FALSE;
            end if;
    end if;

    SELECT devolucao INTO P_PERC_REEMBOLSO FROM gravidades WHERE cod_gravidade = P_GRAVIDADE;

    IF P_PERC_REEMBOLSO IS NULL THEN
        P_PERC_REEMBOLSO = 1;
    end if;

    UPDATE PROBLEMAS
    SET COD_GRAVIDADE = P_GRAVIDADE,
        COD_STATUS_PROBLEMA = 3,
        valor_locatario = (CAST(valor_locatario * P_PERC_REEMBOLSO AS DECIMAL(18,2))),
        valor_locador = (CAST(valor_locador * P_PERC_REEMBOLSO AS DECIMAL(18,2))),
        USUARIO_OPERACAO = UUID(P_USUARIO)
    WHERE id_problema = UUID(P_ID_PROBLEMA);

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO DEFERIR PROBLEMA', SQLSTATE, SQLERRM, 'FN_APROVA_PROBLEMA', 'PROBLEMAS', CURRENT_QUERY(), P_USUARIO);
    RETURN FALSE;
END;
$$;
