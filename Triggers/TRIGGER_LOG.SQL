--CRIA TRIGGERS
DO $$ 
DECLARE
TABELA varchar(20);
BEGIN

	FOR TABELA IN 
		SELECT distinct table_name
		FROM information_schema.columns CO
		WHERE TABLE_SCHEMA = 'public'
		and not exists(select 1 from information_schema.triggers
			where trigger_name = LOWER('TG_I_U_D_') || quote_ident(table_name))
		
	LOOP
		EXECUTE 'CREATE TRIGGER TG_I_U_D_' || quote_ident(TABELA)
        || ' BEFORE INSERT OR UPDATE OR DELETE ON ' || quote_ident(TABELA) || ' 
		FOR EACH ROW EXECUTE PROCEDURE FN_GRAVA_LOG();';
	END LOOP;
END $$;

--DROPA TRIGGERS
DO $$
DECLARE
tg_name varchar(50);
tabela varchar(50);
BEGIN

	FOR tg_name, tabela IN 
		SELECT distinct trigger_name, event_object_table
		from information_schema.triggers
		WHERE TRIGGER_SCHEMA = 'public'
		and upper(trigger_name) like 'TG_I_U_D_%'
		
	LOOP
		RAISE NOTICE 'Trigger apagada: %', quote_ident(tg_name);
		EXECUTE 'DROP TRIGGER ' || quote_ident(tg_name)
        || ' ON ' || quote_ident(tabela) || ' ;';
	END LOOP;
END $$;