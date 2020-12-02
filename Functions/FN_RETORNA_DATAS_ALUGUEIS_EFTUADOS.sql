CREATE OR REPLACE FUNCTION FN_RETORNA_DATAS_ALUGUEIS_EFTUADOS(P_ID_PRODUTO UUID)
RETURNS TEXT AS $$	
declare DIA_INICIO DATE;
		QTD_DIAS INT;
		v_alugueis text[];
		v_aluguel text;
		v text;
declare dt_aluguel_cursor cursor(data timestamp)
							for select to_date(to_char(DATA_INICIO,'YYYY-MM-DD'),'YYYY-MM-DD'), extract(day from (DATA_FIM - DATA_INICIO))
							from alugueis A
							where A.ID_PRODUTO = UUID(P_ID_PRODUTO)
							and to_date(to_char(DATA_FIM,'YYYY-MM-DD'),'YYYY-MM-DD') >= current_date;
begin 
	DROP TABLE IF EXISTS DIAS_ALUGUEL;
	CREATE TEMPORARY TABLE DIAS_ALUGUEL(
	DT_ALUGUEL DATE
	);
	
	open dt_aluguel_cursor(current_timestamp);
	loop
		fetch dt_aluguel_cursor into DIA_INICIO, QTD_DIAS;
		exit when not found;
		
		INSERT INTO DIAS_ALUGUEL(DT_ALUGUEL)
		VALUES(DIA_INICIO);
		LOOP			
			IF QTD_DIAS <= 0 THEN
				EXIT;
			END IF;
			DIA_INICIO = DIA_INICIO + 1;
			INSERT INTO DIAS_ALUGUEL(DT_ALUGUEL)
			VALUES(DIA_INICIO);
			QTD_DIAS = QTD_DIAS - 1;
			--DIA_INICIO = DIA_INICIO || ',' || DIA_INICIO + 1;
		END LOOP;
	END LOOP;
	
	close dt_aluguel_cursor;	
	
	v_alugueis = (SELECT ARRAY_AGG(DISTINCT DT_ALUGUEL)
					FROM DIAS_ALUGUEL);
					
	IF v_alugueis IS NULL THEN
		RETURN '';
	END IF;
	
	FOREACH v IN array v_alugueis
	LOOP
		IF v_aluguel IS NOT NULL THEN 
			v_aluguel = v_aluguel || ',' || v;
			
		ELSE
			v_aluguel = v;
		END IF;
		
	end loop;
	RETURN v_aluguel;
end;
$$ LANGUAGE PLPGSQL;