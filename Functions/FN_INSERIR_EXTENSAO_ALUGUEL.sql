create or replace function FN_INSERIR_EXTENSAO_ALUGUEL(P_ID_ALUGUEL text, P_DATA_FIM TEXT, P_USUARIO TEXT)
    returnS BOOLEAN
    language plpgsql
as
$$
BEGIN
    INSERT INTO extensao_aluguel(id_aluguel, data_fim_old, data_fim_new, aceito)
    SELECT id_aluguel,
           TO_DATE(TO_CHAR(data_fim,'YYYY-MM-DD'),'YYYY-MM-DD'),
           TO_DATE(P_DATA_FIM,'YYYY-MM-DD'),
           FALSE
    FROM alugueis
        WHERE id_aluguel = UUID(P_ID_ALUGUEL);

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO INSERIR EXTENSAO DE ALUGUEL', SQLSTATE, SQLERRM, 'FN_INSERIR_EXTENSAO_ALUGUEL', 'SALDO_LOCADOR', CURRENT_QUERY(), P_USUARIO);
    RETURN FALSE;
END;
$$;
