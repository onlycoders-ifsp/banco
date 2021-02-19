CREATE TABLE RETORNO_MERCADO_PAGO(
      ID_PAGAMENTO UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
      ID_ALUGUEL UUID REFERENCES alugueis(id_aluguel),
      ID_PAGAMENTO_MERCADO_PAGO TEXT,
      TIPO_RETORNO TEXT,
      STATUS TEXT,
      DATA_INCLUSAO timestamptz DEFAULT timezone('America/Sao_Paulo',current_timestamp),
      DATA_MODIFICACAO timestamptz
);