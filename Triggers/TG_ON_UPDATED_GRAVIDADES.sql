CREATE TRIGGER TG_ON_UPDATED_GRAVIDADES
	BEFORE UPDATE ON GRAVIDADES
	FOR EACH ROW
	EXECUTE PROCEDURE FC_ON_UPDATED();