CREATE OR REPLACE FUNCTION FN_GRAVA_LOG() RETURNS TRIGGER AS $$
       BEGIN
         IF UPPER(TG_OP) = 'INSERT'
         THEN INSERT INTO LOG.LOG (
                SCHEMA, TABELA, OPERACAO, REGISTRO_NOVO
              ) VALUES (
                TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, ROW_TO_JSON(NEW)
              );
           RETURN NEW;
         ELSEIF UPPER(TG_OP) = 'UPDATE'
         THEN
           INSERT INTO LOG.LOG (
             SCHEMA, TABELA, OPERACAO, REGISTRO_NOVO, REGISTRO_ANTIGO
           )
           VALUES (TG_TABLE_SCHEMA,TG_RELNAME , TG_OP, ROW_TO_JSON(NEW), ROW_TO_JSON(OLD));
           RETURN NEW;
         ELSIF UPPER(TG_OP) = 'DELETE'
         THEN
           INSERT INTO LOG.LOG
             (SCHEMA, TABELA, OPERACAO, REGISTRO_ANTIGO)
             VALUES (
               TG_TABLE_SCHEMA, TG_RELNAME, TG_OP, ROW_TO_JSON(OLD)
             );
             RETURN OLD;
       END IF;
	END;
$$ LANGUAGE 'plpgsql'