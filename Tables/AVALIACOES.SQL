CREATE TABLE AVALIACOES(
	ID_AVALIACAO SERIAL,
	ID_ALUGUEL UUID REFERENCES ALUGUEIS(ID_ALUGUEL)
	COMENTARIO TEXT NULL,
	NOTA DECIMAL(2,1) CHECK(NOTA < 6),
	COD_TIPO_AVALIACAO INT REFERENCES TIPO_AVALIACAO(ID_TIPO_AVALIACAO),
	DATA_INCLUSAO TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP),
	DATA_MODIFICACAO TIMESTAMPTZ,
	PRIMARY KEY(ID_TIPO_AVALIACAO)
);
	
CREATE UNIQUE INDEX IX_TBL_AVALIACOES ON AVALIACOES (ID_ALUGUEL, COMENTARIO, NOTA, DATA_INCLUSAO);