CREATE OR REPLACE FUNCTION log_ddl()

  RETURNS event_trigger AS $$

DECLARE
  
BEGIN

  IF tg_tag not like 'DROP%'

  THEN

    INSERT INTO log.log_ddl (operacao, object_name) 
	SELECT TG_TAG, object_identity
	FROM pg_event_trigger_ddl_commands(); --(tg_tag, r.object_identity);

  END IF;

END;

$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_ddl_drop()

  RETURNS event_trigger AS $$

DECLARE

BEGIN

  IF tg_tag like 'DROP%' THEN
	  
	INSERT INTO log.log_ddl (operacao, object_name) 
	SELECT TG_TAG, object_identity
	FROM pg_event_trigger_dropped_objects() ;

  END IF;

END;

$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER log_ddl_info ON ddl_command_end EXECUTE PROCEDURE log_ddl();

CREATE EVENT TRIGGER log_ddl_drop_info ON sql_drop EXECUTE PROCEDURE log_ddl_drop();