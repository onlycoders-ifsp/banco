CREATE OR REPLACE FUNCTION FN_RETORNA_ALUGUEIS_EFTUADOS(P_ID_PRODUTO UUID)
RETURNS TEXT AS $$	
declare v_alugueis text[];
		v_aluguel text;
		v text;
begin 
	v_alugueis = (SELECT ARRAY_AGG(TO_CHAR(A.DATA_FIM,'YYYY-MM-DD'))
	--into 
		FROM ALUGUEIS A
		WHERE A.ID_PRODUTO = UUID(P_ID_PRODUTO)
		AND TO_CHAR(A.DATA_FIM,'YYYY-MM-DD') >= TO_CHAR(CURRENT_TIMESTAMP,'YYYY-MM-DD'));

	IF v_alugueis IS NULL THEN
		RETURN NULL;
	END IF;
		
	FOREACH v IN array v_alugueis
    LOOP
		IF v_aluguel IS NOT NULL THEN 
			v_aluguel = v_aluguel || ',' || v;
			
		ELSE
			v_aluguel = v;
		END IF;
		
		RAISE NOTICE 'Name: %', v_aluguel;
	end loop;
	
	RETURN v_aluguel;
end;
$$ LANGUAGE PLPGSQL;