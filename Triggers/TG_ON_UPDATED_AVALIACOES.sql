CREATE TRIGGER TG_ON_UPDATED_AVALIACOES
	BEFORE UPDATE ON AVALIACOES
	FOR EACH ROW
	EXECUTE PROCEDURE FN_ON_UPDATED();