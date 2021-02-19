create function fn_insere_aluguel_encontro(p_id_aluguel text, p_cep_entrega text, p_logradouro_entrega text, p_bairro_entrega text, 
p_descricao_entrega text, p_data_entrega text, p_cep_devolucao text, p_logradouro_devolucao text, p_bairro_devolucao text, p_descricao_devolucao text,
 p_data_devolucao text, p_aceite_locador boolean, p_observacao_recusa text, p_usuario text) returns boolean
    language plpgsql
as
$$
BEGIN

    INSERT INTO ALUGUEL_ENCONTRO(
        ID_ALUGUEL,
         CEP_ENTREGA,
         LOGRADOURO_ENTREGA,
         BAIRRO_ENTREGA,
         DESCRICAO_ENTREGA,
         DATA_ENTREGA,
         CEP_DEVOLUCAO,
         LOGRADOURO_DEVOLUCAO,
         BAIRRO_DEVOLUCAO,
         DESCRICAO_DEVOLUCAO,
         DATA_DEVOLUCAO,
         ACEITE_LOCADOR,
         OBSERVACAO_RECUSA)
         SELECT
             UUID(p_id_aluguel),
                 p_cep_entrega,
                 p_logradouro_entrega,
                 p_bairro_entrega,
                 p_descricao_entrega,
                 TO_TIMESTAMP(p_data_entrega,'YYYY-MM-DD HH24:MI:SS'),
                 p_cep_devolucao,
                 p_logradouro_devolucao,
                 p_bairro_devolucao,
                 p_descricao_devolucao,
                 TO_TIMESTAMP(p_data_devolucao,'YYYY-MM-DD HH24:MI:SS'),
                 null,
                 p_observacao_recusa;

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO INSERIR ENCONTRO NO ALUGUEL', SQLSTATE, SQLERRM, 'FN_INSERE_ALUGUEL_ENCONTRO', 'ALUGUEL_ENCONTRO', CURRENT_QUERY(), p_usuario);
    RETURN FALSE;
END;
$$;