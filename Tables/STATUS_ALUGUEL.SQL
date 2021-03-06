CREATE TABLE STATUS_ALUGUEL(
	ID_STATUS_ALUGUEL UUID DEFAULT UUID_GENERATE_V4(),
	COD_STATUS_ALUGUEL INT NOT NULL UNIQUE,
	DESCRICAO TEXT NOT NULL UNIQUE,
	DATA_INCLUSAO TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP),
	DATA_MODIFICACAO TIMESTAMPTZ,
	PRIMARY KEY(ID_STATUS_ALUGUEL)
);

CREATE UNIQUE INDEX IX_TBL_STATUS_ALUGUEL ON STATUS_ALUGUEL (ID_STATUS_ALUGUEL, COD_STATUS_ALUGUEL, DESCRICAO, DATA_INCLUSAO);