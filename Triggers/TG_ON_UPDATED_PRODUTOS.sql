CREATE TRIGGER TG_ON_UPDATED_PRODUTOS
	AFTER UPDATE ON PRODUTOS
	FOR EACH ROW
	EXECUTE PROCEDURE FC_ON_UPDATED();