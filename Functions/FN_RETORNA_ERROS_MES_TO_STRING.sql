CREATE OR REPLACE FUNCTION FN_RETORNA_ERROS_MES_TO_STRING(P_NOME TEXT)
    RETURNS TEXT AS $$
DECLARE MES text;
BEGIN
    MES = (SELECT ARRAY_TO_STRING(ARRAY_AGG(m.mes_descricao),',') || ';' || ARRAY_TO_STRING(ARRAY_AGG(l.Qtd),',')
           FROM meses M
                    inner join
                (select date_part('month',TO_DATE(TO_CHAR(data_erro,'YYYY-MM-DD'),'YYYY-MM-DD')) Mes, count(1) Qtd, Procedure
                 from log.log_erros
                 group by date_part('month',TO_DATE(TO_CHAR(data_erro,'YYYY-MM-DD'),'YYYY-MM-DD')), Procedure) l
                on l.Mes = M.mes
                    and l.Procedure = p_nome);
    IF MES IS NULL THEN
        RETURN '';
    ELSE
        RETURN MES;
    END IF;
end;
$$ LANGUAGE PLPGSQL;
