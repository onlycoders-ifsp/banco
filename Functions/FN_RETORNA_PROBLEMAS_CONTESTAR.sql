CREATE OR REPLACE FUNCTION FN_RETORNA_PROBLEMAS_CONTESTAR(p_id_usuario TEXT)
    RETURNS SETOF RECORD
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    return query

        select
            cast(pr.id_problema as text),
            cast(cod_tipo_problema as int),
            cast(cod_gravidade as int),
            cast(pr.descricao as text),
            cast(case
                    when (valor_locador < 0 or valor_locatario < 0) then 'Valor a receber'
                     when (valor_locatario > 0 or valor_locatario > 0) then 'Valor a pagar'
                     else 'Sem valor'
                end
            as text) Situacao,
            cast(abs(case
                         when (p.id_usuario = uuid(p_id_usuario)) then valor_locador
                         when (a.id_usuario = uuid(p_id_usuario)) then valor_locatario
                end) as decimal(18,2)) Valor,
               pr.foto
        from problemas pr
                 inner join alugueis a
                            on pr.id_aluguel = a.id_aluguel
                 inner join produtos p
                            on a.id_produto = p.id_produto
        where ((p.id_usuario = uuid(p_id_usuario) or a.id_usuario = uuid(p_id_usuario))
            and pr.id_solicitante <> uuid(p_id_usuario))
          and pr.contestado is null
          AND PR.cod_status_problema = 1 --ABERTO
		  and pr.cod_tipo_problema <> 2; --Furto

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO RETORNAR PROBLEMAS AO CONTESTAR', SQLSTATE, SQLERRM, 'FN_RETORNA_PROBLEMAS_CONTESTAR', 'PROBLEMAS', CURRENT_QUERY(), p_id_usuario);
    RETURN;
END;
$$;
