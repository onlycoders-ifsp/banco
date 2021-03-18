CREATE OR REPLACE FUNCTION FN_RETORNA_PROBLEMAS(P_TIPO_PROBLEMA INT DEFAULT 0, P_GRAVIDADE INT DEFAULT 0,
                                                P_STATUS INT DEFAULT 0, P_DATA_INICIO TEXT DEFAULT '', P_USUARIO TEXT DEFAULT '')
    RETURNS SETOF RECORD
    LANGUAGE PLPGSQL
AS
$$
DECLARE P_SQL TEXT = '';
        P_AND BOOLEAN = false;
BEGIN

    DROP TABLE IF EXISTS TEMP_PROBLEMAS;

    --RETURN QUERY
    --SELECT
    P_SQL =    'CREATE TEMP TABLE TEMP_PROBLEMAS AS
				SELECT
				CAST(p.DESCRICAO AS TEXT),
				CAST(p.valor_locador AS DECIMAL(18,2)),
				CAST(p.valor_locatario AS DECIMAL(18,2)),
				CAST(p.COD_TIPO_PROBLEMA AS INT),
				CAST(p.COD_GRAVIDADE AS INT),
				CAST(p.COD_STATUS_PROBLEMA AS INT),
				CAST(case p.SOLICITANTE
                        when ''D'' then p2.id_usuario
                        when ''L'' then a.id_usuario
                   end AS TEXT) id_solicitante,
               CAST(SOLICITANTE AS CHAR(1)),
               TO_CHAR(p.DATA_INCLUSAO,''YYYY-MM-DD HH:MI:SS''),
               CAST(p.USUARIO_OPERACAO AS TEXT)
        FROM PROBLEMAS p
                 inner join alugueis a
                            on p.id_aluguel = a.id_aluguel
                 inner join produtos
            p2 on a.id_produto = p2.id_produto
        where not contestado ';

/*
    if (((P_TIPO_PROBLEMA + P_GRAVIDADE + P_STATUS) <> 0) or P_DATA_INICIO <> '') THEN
        P_SQL = P_SQL || ' WHERE ';
    end if;
*/

    IF P_TIPO_PROBLEMA <> 0 THEN
        P_SQL = P_SQL || ' AND p.COD_TIPO_PROBLEMA = ' || CAST(P_TIPO_PROBLEMA AS TEXT);
        P_AND = TRUE;
    end if;
    IF P_GRAVIDADE <> 0 THEN
        P_SQL = P_SQL || ' AND p.COD_GRAVIDADE = ' || CAST(P_GRAVIDADE AS TEXT);
        P_AND = TRUE;
    end if;
    IF P_STATUS <> 0 THEN
        P_SQL = P_SQL || ' AND p.COD_STATUS_PROBLEMA = ' || CAST(P_STATUS AS TEXT);
        P_AND = TRUE;
    end if;
    IF P_DATA_INICIO <> '' THEN
        P_SQL = P_SQL || ' AND to_date(to_char(p.DATA_INCLUSAO,''YYYY-MM-DD''),''YYYY-MM-DD'') >= to_date(''' || P_DATA_INICIO || ''',''YYYY-MM-DD'') ';
        P_AND = TRUE;
    end if;

    P_SQL = P_SQL || ';';

    EXECUTE P_SQL;

    RETURN QUERY
        SELECT *FROM TEMP_PROBLEMAS;

    DROP TABLE IF EXISTS TEMP_PROBLEMAS;

EXCEPTION WHEN OTHERS THEN
    PERFORM FN_REPORT_ERRO('ERRO AO RETORNAR PROBLEMAS', SQLSTATE, SQLERRM, 'FN_RETORNA_PROBLEMAS', 'PROBLEMAS', CURRENT_QUERY(), P_USUARIO);
    RETURN;
END;
$$;