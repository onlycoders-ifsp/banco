CREATE TRIGGER TG_ON_UPDATED_ALUGUEL_STATUS
AFTER UPDATE ON ALUGUEIS
FOR EACH ROW EXECUTE PROCEDURE FN_GRAVA_HISTORICO_ALUGUEL();