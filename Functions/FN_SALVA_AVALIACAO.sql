CREATE OR REPLACE FUNCTION
    FN_SALVA_AVALIACAO(P_ID_ALUGUEL TEXT, P_COMENTARIO TEXT, P_NOTA DOUBLE PRECISION, P_TIPO INT,P_USUARIO TEXT)
RETURNS BOOLEAN AS $$
BEGIN

    INSERT INTO AVALIACOES(id_aluguel, comentario, nota, cod_tipo_avaliacao)
    VALUES(UUID(P_ID_ALUGUEL),P_COMENTARIO,CAST(P_NOTA AS DECIMAL(2,1)),P_TIPO);
    RETURN TRUE;

    EXCEPTION WHEN OTHERS THEN
        PERFORM FN_REPORT_ERRO('ERRO AO GRAVAR AVALIAÇÃO', SQLSTATE, SQLERRM, 'FN_SALVA_AVALIACAO', 'AVALIACOES', CURRENT_QUERY(), P_USUARIO);
        RETURN FALSE;
END;
$$ LANGUAGE PLPGSQL;
