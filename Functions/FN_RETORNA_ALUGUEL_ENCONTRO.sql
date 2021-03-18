create or replace function fn_retorna_aluguel_encontro(p_id_aluguel text, p_usuario text DEFAULT ''::text) returns SETOF record
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT CAST(ae.ID_ALUGUEL AS TEXT),
               cast(cep_entrega as text),
               cast(logradouro_entrega as text),
               cast(bairro_entrega as text),
               cast(descricao_entrega as text),
               to_char(data_entrega,'YYYY-MM-DD HH24:MI:SS'),
               cast(cep_devolucao as text),
               cast(logradouro_devolucao as text),
               cast(bairro_devolucao as text),
               cast(descricao_devolucao as text),
               to_char(data_devolucao,'YYYY-MM-DD HH24:MI:SS'),
               aceite_locador,
               cast(observacao_recusa as text),
			   to_char(data_inicio,'DD/MM/YYYY') || ' - ' || to_char(data_fim,'DD/MM/YYYY'),
				cast(replace(cast(valor_aluguel as text),',','.') as text)

        FROM ALUGUEIS AE
		left JOIN aluguel_encontro A
		ON AE.ID_ALUGUEL = A.ID_ALUGUEL
        WHERE ae.id_aluguel = UUID(P_ID_ALUGUEL)
		order by a.data_inclusao desc
		limit 1;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO SELECIONAR ENCONTRO', SQLSTATE, SQLERRM, 'FN_RETORNA_ALUGUEL_ENCONTRO', 'ALUGUEL_ENCONTRO', CURRENT_QUERY(),P_USUARIO);
END;
$$;
