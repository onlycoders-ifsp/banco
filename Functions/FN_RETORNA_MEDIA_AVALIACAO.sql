CREATE OR REPLACE FUNCTION FN_RETORNA_MEDIA_AVALIACAO(P_ID_PRODUTO_USUARIO UUID, P_TIPO_AVALICAO INT)
    RETURNS DECIMAL(2,1) AS $$
DECLARE V_NOTA DECIMAL(2,1) = 0;
BEGIN
    V_NOTA = (SELECT CAST ((SUM(NOTA)/(COUNT(1))) AS DECIMAL(2,1))
              FROM AVALIACOES
			  INNER JOIN ALUGUEIS A
				ON A.ID_ALUGUEL = AVALIACOES.ID_ALUGUEL
			  INNER JOIN PRODUTOS P
				ON P.ID_PRODUTO = A.ID_PRODUTO
              WHERE (COD_TIPO_AVALIACAO = P_TIPO_AVALICAO
				AND (A.ID_PRODUTO = P_ID_PRODUTO_USUARIO --Média do produto
                 OR  A.ID_USUARIO = P_ID_PRODUTO_USUARIO --Média de locatario
				 OR  P.ID_USUARIO = P_ID_PRODUTO_USUARIO) --Média de locador
                 OR (P.ID_USUARIO = P_ID_PRODUTO_USUARIO 
                  AND P_TIPO_AVALICAO = 4)); --Média geral dos produtos

    IF V_NOTA IS NULL THEN
        RETURN 0.0;
    ELSE
        RETURN V_NOTA;
    END IF;
end;
$$ LANGUAGE PLPGSQL;
