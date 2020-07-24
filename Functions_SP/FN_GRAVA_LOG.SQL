CREATE OR REPLACE FUNCTION saveLog() RETURNS trigger AS $$
       BEGIN
         IF TG_OP = 'INSERT'
         THEN INSERT INTO LOG.LOG (
                schemaname, tablename, operation, new_val
              ) VALUES (
                TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(NEW)
              );
           RETURN NEW;
         ELSEIF  TG_OP = 'UPDATE'
         THEN
           INSERT INTO log.log (
             schemaname, tablename, operation, new_val, old_val
           )
           VALUES (TG_TABLE_SCHEMA,TG_RELNAME , TG_OP, row_to_json(NEW), row_to_json(OLD));
           RETURN NEW;
         ELSIF TG_OP = 'DELETE'
         THEN
           INSERT INTO log.log
             (schemaname, tablename, operation, old_val)
             VALUES (
               TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, row_to_json(OLD)
             );
             RETURN OLD;
		 ELSE IF TAG IN ('ALTER TABLE')
         END IF;
       END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;