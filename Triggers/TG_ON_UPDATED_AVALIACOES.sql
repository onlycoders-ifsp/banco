CREATE TRIGGER TG_ON_UPDATED_AVALIACOES
	AFTER UPDATE ON AVALIACOES
	FOR EACH ROW
	EXECUTE PROCEDURE FC_ON_UPDATED();