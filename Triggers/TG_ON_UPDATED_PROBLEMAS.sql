CREATE TRIGGER TG_ON_UPDATED_PROBLEMAS
	BEFORE UPDATE ON PROBLEMAS
	FOR EACH ROW
	EXECUTE PROCEDURE FC_ON_UPDATED();