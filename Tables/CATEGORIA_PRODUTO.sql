CREATE TABLE CATEGORIA_PRODUTO(
	ID_CATEGORIA_PRODUTO SERIAL,
	ID_PRODUTO UUID REFERENCES PRODUTOS(ID_PRODUTO),
	ID_CATEGORIA INTEGER REFERENCES CATEGORIA(ID_CATEGORIA),
	DATA_INCLUSAO TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP),
	DATA_MODIFICACAO TIMESTAMPTZ,
	PRIMARY KEY(ID_CATEGORIA_PRODUTO)
);