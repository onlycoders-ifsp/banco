CREATE TRIGGER TG_ON_UPDATED_TIPO_CONTA
	BEFORE UPDATE ON TIPO_CONTA
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ON_UPDATED();