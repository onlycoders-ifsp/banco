CREATE TABLE USUARIOS_ATIVO_INATIVO(
    ID SERIAL PRIMARY KEY,
    ID_USUARIO UUID NOT NULL,
    ATIVO BOOLEAN NOT NULL,
    MOTIVO TEXT,
    USUARIO_ALTERACAO TEXT NOT NULL,
    DATA_ALTERACAO TIMESTAMPTZ DEFAULT timezone('America/Sao_Paulo', CURRENT_TIMESTAMP)
);
