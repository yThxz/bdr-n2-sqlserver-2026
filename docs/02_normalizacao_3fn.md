### Aplicação da 1ª Forma Normal (1FN) - Atomicidade
A 1FN diz que uma tabela não pode ter atributos multivalorados (listas). Em vez de colocar uma coluna Telefones separada por vírgulas na tabela Cliente, criamos a tabela TELEFONE_CLIENTE. Cada telefone é uma linha única.

### Aplicação da 2ª Forma Normal (2FN) - Dependência Funcional Total
A 2FN foca nas chaves compostas. Na tabela ITEM_OS, a chave é (Num_OS, Cod_Servico). Se colocássemos a "Descrição do Serviço" nessa tabela, ela dependeria apenas do Cod_Servico, ferindo a 2FN. Por isso, a descrição ficou isolada na tabela

### Aplicação da 3ª Forma Normal (3FN) - Sem Dependências Transitivas
A 3FN proíbe atributos calculados que dependem de outras colunas que não sejam a chave primária. Por exemplo, a tabela ORDEM_SERVICO não deve ter uma coluna Valor_Total. O valor total deve ser calculado no Passo 9 (Consultas DQL) usando SUM(Valor_Cobrado) da tabela