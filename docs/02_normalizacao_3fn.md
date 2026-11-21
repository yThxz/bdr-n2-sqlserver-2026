# Normalização do modelo relacional (até a 3FN)

Depois de passar o DER para o modelo relacional e aplicar as regras de normalização, o banco ESTETICA_AUTOMOTIVA fechou com 9 tabelas relacionadas: CLIENTE, PESSOA_FISICA, PESSOA_JURIDICA, TELEFONE_CLIENTE, VEICULO, FUNCIONARIO, SERVICO, O_S e ITEM_OS.

### 1ª forma normal (1FN)

A 1FN exige valores atômicos, sem listas ou campos repetidos na mesma célula. Como um cliente pode ter mais de um número de contato, em vez de jogar vários telefones separados por vírgula dentro de CLIENTE, criamos a tabela TELEFONE_CLIENTE, onde cada número vira uma linha própria. Os serviços de uma ordem de serviço seguem a mesma lógica e entram em linhas separadas na tabela ITEM_OS, sem ficar agrupados em O_S.

### 2ª forma normal (2FN)

Na 2FN, toda coluna fora da chave primária precisa depender da chave inteira, o que pesa principalmente nas tabelas com chave composta. Em ITEM_OS, a chave primária é (Num_OS, COD_Servico). Se colocássemos Descricao ou Valor_Atual ali dentro, esses dados dependeriam só de COD_Servico e não da OS, quebrando a 2FN. Por isso eles ficaram na tabela SERVICO, e ITEM_OS guarda apenas Valor_Cobrado, que depende tanto da OS quanto do serviço executado naquele dia. Em TELEFONE_CLIENTE, as duas colunas formam a chave composta (ID_Cliente, Numero), então não há dependência parcial.

### 3ª forma normal (3FN)

A 3FN elimina dependências transitivas (quando uma coluna comum depende de outra coluna comum, e não direto da chave primária) e evita redundância de dados derivados. Em O_S, não guardamos ID_Cliente diretamente porque a Placa aponta para VEICULO, onde já consta o dono do carro; repetir o cliente na OS só abriria margem para inconsistência. Pelo mesmo motivo, não criamos uma coluna Valor_Total em O_S, já que esse valor é calculado somando o Valor_Cobrado da ITEM_OS na hora da consulta, como na view vw_Historico_OS e nas consultas do Passo 9.