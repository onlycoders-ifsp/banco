CREATE TRIGGER TG_ON_UPDATED_TIPO_PROBLEMA
	BEFORE UPDATE ON TIPO_PROBLEMA
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ON_UPDATED();