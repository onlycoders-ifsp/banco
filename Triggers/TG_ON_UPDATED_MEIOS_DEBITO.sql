CREATE TRIGGER TG_ON_UPDATED_MEIOS_DEBITO
	BEFORE UPDATE ON MEIOS_DEBITO
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ON_UPDATED();