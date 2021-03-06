CREATE TABLE SEXO(
	ID_SEXO UUID DEFAULT UUID_GENERATE_V4(),
	DESCRICAO TEXT NOT NULL UNIQUE,
	DATA_INCLUSAO TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP),
	DATA_MODIFICACAO TIMESTAMPTZ NULL,
	PRIMARY KEY(ID_SEXO)
);

CREATE UNIQUE INDEX IX_TBL_SEXO ON SEXO (COD_SEXO, DESCRICAO);