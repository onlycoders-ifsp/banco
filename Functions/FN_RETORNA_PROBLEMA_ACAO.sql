CREATE OR REPLACE FUNCTION FN_RETORNA_PROBLEMA_ACAO(p_id_problema TEXT)
    RETURNS SETOF RECORD
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    return query

        select cast('D' as char(1))Perfil, cast(a.id_aluguel as text), cast(p.id_usuario as text),
               cast(rmp.id_pagamento_mercado_pago as text), prb.cod_tipo_problema,
               PRB.descricao, prb.valor_locador Valor, A.VALOR_DEBITO
        from problemas prb
                 inner join alugueis a
                            on prb.id_aluguel = a.id_aluguel
                 inner join produtos p
                            on a.id_produto = p.id_produto
                 inner join retorno_mercado_pago rmp
                            on a.id_aluguel = rmp.id_aluguel
        where prb.valor_locador <> 0
          and prb.id_problema = uuid(p_id_problema)

        union all

        select cast('L' as char(1))Perfil, cast(a.id_aluguel as text), cast(a.id_usuario as text),
               cast(rmp.id_pagamento_mercado_pago as text), prb.cod_tipo_problema,
               PRB.descricao, prb.valor_locatario Valor, A.VALOR_DEBITO
        from problemas prb
                 inner join alugueis a
                            on prb.id_aluguel = a.id_aluguel
                 inner join retorno_mercado_pago rmp
                            on a.id_aluguel = rmp.id_aluguel
        where prb.valor_locatario <> 0
          and prb.id_problema = uuid(p_id_problema);

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO RETORNAR PROBLEMA PAGAMENTO', SQLSTATE, SQLERRM, 'FN_RETORNA_PROBLEMA_ACAO', 'PROBLEMAS', CURRENT_QUERY(), '');
    RETURN;
END;
$$;
