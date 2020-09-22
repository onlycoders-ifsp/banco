--CRIA OS TRIGGERS QUE ATUALIZA A COLUNA DATA_MODIFICACAO

DO $$ 
DECLARE
TABELA varchar(20);
BEGIN

	FOR TABELA IN 
		SELECT table_name
		FROM information_schema.columns CO
		WHERE TABLE_SCHEMA = 'public'
		and column_name = 'data_modificacao'
	and not exists(select 1 from information_schema.triggers
					where trigger_name = LOWER('TG_ON_UPDATED_') || quote_ident(table_name))
		
	LOOP
		EXECUTE 'CREATE TRIGGER TG_ON_UPDATED_' || quote_ident(TABELA)
        || ' BEFORE UPDATE ON ' || quote_ident(TABELA) || ' 
		FOR EACH ROW EXECUTE PROCEDURE FN_ON_UPDATED();';
	END LOOP;
END $$;

--DROPA OS TRIGGERS DA COLUNA DATA_MODIFICACAO
DO $$
DECLARE
tg_name varchar(50);
tabela varchar(50);
BEGIN

	FOR tg_name, tabela IN 
		SELECT trigger_name, event_object_table
		from information_schema.triggers
		WHERE TRIGGER_SCHEMA = 'public'
		and trigger_name like '%update%'
		
	LOOP
		EXECUTE 'DROP TRIGGER ' || quote_ident(tg_name)
        || ' ON ' || quote_ident(tabela) || ' ;';
	END LOOP;
END $$;