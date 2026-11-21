# Justificativa técnica dos índices secundários (Passo 6)

  Por padrão, o SQL Server cria índices clusterizados apenas para chaves primárias (PRIMARY KEY), definindo a ordem física de armazenamento das tabelas. Chaves estrangeiras (FOREIGN KEY) e colunas usadas com frequência em filtros (WHERE) ou ordenações (ORDER BY) não recebem
  índices automaticamente. Sem índices não clusterizados nessas colunas, o banco precisa varrer a tabela inteira (Scan) a cada consulta. No banco ESTETICA_AUTOMOTIVA, foram criados cinco índices secundários para cobrir os acessos mais frequentes.

  ### 1. IX_O_S_Placa em O_S (Placa)

  Como O_S é ordenada pela chave primária Num_OS, filtrar por placa ou fazer JOIN com VEICULO (como na view vw_Historico_OS e nas consultas de histórico de serviços de um carro específico) exigiria ler a tabela inteira. Indexar a chave estrangeira Placa evita essa leitura
  completa e agiliza a validação de integridade referencial.

  ### 2. IX_O_S_Data_Abertura em O_S (Data_Abertura) INCLUDE (Status)

  Na rotina da estética automotiva, relatórios gerenciais e fechamentos de caixa filtram ordens de serviço por período (BETWEEN, mês ou dia atual) usando Data_Abertura, quase sempre agrupando ou filtrando também pelo Status do atendimento. Além de acelerar o filtro por data, a
  cláusula INCLUDE (Status) faz desse índice um índice de cobertura (Covering Index) para consultas de acompanhamento operacional: o SQL Server lê data e status direto nas páginas folha, sem voltar à tabela principal para buscar o restante da linha (Key Lookup).

  ### 3. IX_VEICULO_ID_Cliente em VEICULO (ID_Cliente)

  Os registros de VEICULO ficam ordenados pela chave primária Placa. Como a chave estrangeira ID_Cliente não tem índice automático, listar todos os carros de um cliente ou cruzar VEICULO com CLIENTE na vw_Historico_OS forçaria o banco a percorrer todos os veículos cadastrados.
  O índice transforma essas buscas e os JOINs entre CLIENTE e VEICULO em acessos diretos (Index Seek).

  ### 4. IX_ITEM_OS_COD_Servico em ITEM_OS (COD_Servico)

  ITEM_OS tem chave primária composta por (Num_OS, COD_Servico). Na árvore B-Tree do SQL Server, esse índice atende bem buscas por Num_OS, que é a primeira coluna da chave, mas não funciona de forma eficiente quando a consulta filtra ou agrupa apenas por COD_Servico (por
  exemplo, para contar quantas vezes um polimento foi vendido ou calcular o faturamento por tipo de serviço). Com o índice em COD_Servico, consultas e junções que partem de SERVICO para ITEM_OS deixam de varrer todos os itens de todas as ordens de serviço.

  ### 5. IX_PESSOA_FISICA_Nome em PESSOA_FISICA (Nome)

  No balcão, o atendente raramente sabe o ID_Cliente de cabeça e procura o cliente pelo nome (como LIKE 'Carlos%') ou usa listagens em ordem alfabética (ORDER BY Nome). Como a tabela é ordenada por ID_Cliente, essas consultas exigiriam varredura completa e ordenação em memória;
  indexar Nome acelera buscas por prefixo e reduz o custo de ordenação alfabética nos planos de execução.