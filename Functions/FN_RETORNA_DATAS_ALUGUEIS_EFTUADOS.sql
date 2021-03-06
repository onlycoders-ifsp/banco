CREATE OR REPLACE FUNCTION FN_RETORNA_DATAS_ALUGUEIS_EFTUADOS(P_ID_PRODUTO UUID)
    RETURNS TEXT AS $$
declare --DIA_INICIO DATE;
        --DIA_FIM DATE;
        --v_alugueis_INCIO text[];
        --v_alugueis_FIM text[];
        --v_aluguel_INICIO text;
        --v_aluguel_FIM text;
        --v text;
		v_alugueis text;
   /* declare dt_aluguel_cursor cursor(data timestamp)
            for select to_date(to_char(DATA_INICIO,'YYYY-MM-DD'),'YYYY-MM-DD'), to_date(to_char(DATA_FIM,'YYYY-MM-DD'),'YYYY-MM-DD')--, extract(day from (DATA_FIM - DATA_INICIO))
                from alugueis A
                where A.ID_PRODUTO = UUID(P_ID_PRODUTO)
                and to_date(to_char(DATA_FIM,'YYYY-MM-DD'),'YYYY-MM-DD') >= current_date
                order by id_aluguel;*/
begin
/*
    DROP TABLE IF EXISTS DT_INICIO;
    CREATE TEMPORARY TABLE DT_INICIO(
        DT_ALUGUEL DATE
    );
    DROP TABLE IF EXISTS DT_FIM;
    CREATE TEMPORARY TABLE DT_FIM(
        DT_ALUGUEL DATE
    );
*
    open dt_aluguel_cursor(current_timestamp);
    loop
        fetch dt_aluguel_cursor into DIA_INICIO, DIA_FIM;
        exit when not found;
            INSERT INTO DT_INICIO(DT_ALUGUEL)
            VALUES(DIA_INICIO);
            INSERT INTO DT_FIM(DT_ALUGUEL)
            VALUES(DIA_FIM);
			--RAISE INFO '%', DIA_FIM;
            --DIA_INICIO = DIA_INICIO || ',' || DIA_INICIO + 1;
    END LOOP;

    close dt_aluguel_cursor;

    v_alugueis_INCIO = (SELECT ARRAY_AGG(DISTINCT DT_ALUGUEL)
                        FROM DT_INICIO);
    v_alugueis_FIM = (SELECT ARRAY_AGG(DISTINCT DT_ALUGUEL)
                      FROM DT_FIM);

    IF v_alugueis_INCIO IS NULL THEN
        RETURN '';
    END IF;
	--RAISE INFO '%', v_alugueis_INCIO;
    FOREACH v IN array v_alugueis_INCIO
        LOOP
            IF v_aluguel_INICIO IS NOT NULL THEN
                v_aluguel_INICIO = v_aluguel_INICIO || ',' || v;
            ELSE
                v_aluguel_INICIO = v;
            END IF;

        end loop;
    v:=null;
           FOREACH v IN array v_alugueis_FIM
    LOOP
        IF v_aluguel_FIM IS NOT NULL THEN
            v_aluguel_FIM = v_aluguel_FIM || ',' || v;

        ELSE
            v_aluguel_FIM = v;
        END IF;

    end loop;
	*/
	
	v_alugueis = (select ARRAY_TO_STRING(ARRAY_AGG(to_char(DATA_INICIO,'YYYY-MM-DD')),',') || ';' ||
					ARRAY_TO_STRING(ARRAY_AGG(to_char(DATA_FIM,'YYYY-MM-DD')),',')
					from alugueis A
					where A.ID_PRODUTO = UUID(P_ID_PRODUTO)
					and to_date(to_char(DATA_FIM,'YYYY-MM-DD'),'YYYY-MM-DD') >= current_date
					and cod_status_aluguel not in (3,4,5,6,8,16,17,18,19));
					
	IF v_alugueis is null then
		return '';
	else 
		RETURN v_alugueis;
	end if;
end;
$$ LANGUAGE PLPGSQL;