Passo 1: especificação do cenário (estética automotiva)

  ## 1. Contexto e objetivo do sistema

  O banco de dados do sistema interno de um centro de estética automotiva organiza a rotina da loja: cadastra clientes particulares e empresas com frota,
  mantém o histórico dos veículos que passam pelo pátio, estrutura a equipe de trabalho e controla a abertura e o fechamento das Ordens de Serviço (O.S.).

  O modelo também preserva o histórico financeiro dos atendimentos. Mesmo que o preço de tabela de um serviço seja reajustado no futuro, o sistema
  continua sabendo exatamente quanto foi cobrado em cada ordem de serviço antiga.

  ## 2. Entidades e regras de negócio

  ### Clientes (CLIENTE, PESSOA_FISICA e PESSOA_JURIDICA)

  A estética atende pessoas físicas e empresas. Para não misturar campos incompatíveis na mesma tabela, CLIENTE é a entidade genérica (com código
  identificador, data de cadastro e tipo restrito a PF ou PJ) especializada em duas entidades exclusivas:

  • PESSOA_FISICA: nome completo, CPF e, como campos opcionais, RG e data de nascimento.
  • PESSOA_JURIDICA: razão social, CNPJ e, como campo opcional, inscrição estadual.

  Um cliente cadastrado como PF não pode existir ao mesmo tempo em PESSOA_JURIDICA, e vice-versa.

  ### Telefones de contato (TELEFONE_CLIENTE)

  Cada cliente pode informar mais de um número para contato (celular pessoal, telefone comercial etc.), mas nenhum número existe no sistema sem ligação
  com um cadastro. Por isso, TELEFONE_CLIENTE é uma entidade fraca dependente de CLIENTE. Para evitar duplicidade, o mesmo cliente não pode registrar o
  mesmo número duas vezes.

  ### Veículos (VEICULO)

  Os automóveis atendidos ficam na entidade forte VEICULO. A identificação é feita pela placa (7 caracteres sem traço, compatível com o padrão antigo e o
  Mercosul), junto com marca, modelo e os campos opcionais ano e cor.

  ### Funcionários (FUNCIONARIO)

  O controle da equipe fica na entidade forte FUNCIONARIO, que guarda matrícula, nome, cargo, salário (sempre maior que zero) e a matrícula do supervisor
  direto. Esse auto-relacionamento monta a hierarquia interna da loja; o cargo no topo da gestão não tem supervisor e fica com esse campo nulo.

  ### Serviços (SERVICO)

  O catálogo de serviços oferecidos pela loja (como lavagem completa, higienização interna, polimento técnico e vitrificação) forma a entidade forte
  SERVICO. Cada serviço tem um código numérico inteiro, descrição e valor atual de tabela.

  ### Ordem de serviço (O_S)

  Cada atendimento feito no pátio gera um registro na entidade forte O_S, com número identificador, data de abertura e status limitado a Aberta,
  Andamento, Concluída ou Cancelada. Toda O.S. aponta para o veículo atendido e para o funcionário responsável pela execução. A ligação com o cliente
  ocorre indiretamente pelo veículo, o que evita redundância e impede erros como associar um carro ao cliente errado.

  ### Itens da O.S. (ITEM_OS)

  Uma ordem de serviço pode reunir vários serviços, e o mesmo serviço aparece em várias ordens ao longo do tempo. Para resolver esse relacionamento
  muitos-para-muitos entre O_S e SERVICO, existe a entidade associativa ITEM_OS. Sua chave composta (Num_OS + COD_Servico) impede que um serviço seja
  lançado duas vezes na mesma O.S., e o campo Valor_Cobrado grava o preço fechado naquele atendimento para permitir descontos e manter o histórico.

  ## 3. Resumo dos relacionamentos e cardinalidades

  • Cliente e Pessoa Física / Pessoa Jurídica (generalização/especialização exclusiva, 1:1): cada registro em CLIENTE corresponde a exatamente um registro
  em PESSOA_FISICA ou em PESSOA_JURIDICA.
  • Cliente e Telefone (1:N): um cliente pode ter zero, um ou vários telefones; cada telefone pertence a um único cliente.
  • Cliente e Veículo (1:N): um cliente pode ter zero, um ou vários veículos cadastrados; cada veículo pertence a apenas um cliente.
  • Veículo e O.S. (1:N): um veículo pode ter várias ordens de serviço ao longo do tempo; cada O.S. é de um único veículo.
  • Funcionário e O.S. (1:N): um funcionário pode ser responsável por várias ordens de serviço; cada O.S. tem um único funcionário responsável.
  • Funcionário e Funcionário (auto-relacionamento, 1:N): um supervisor pode liderar vários funcionários; cada funcionário responde a no máximo um
  supervisor direto.
  • O.S. e Serviço (N:M via ITEM_OS): uma ordem de serviço tem um ou mais serviços, e um serviço pode aparecer em zero ou várias ordens de serviço.

  ## 4. Exemplos de dados

  • Cliente PF: ID 1, cadastro em 10/06/2025, tipo PF, nome João Silva, CPF 111.222.333-44, telefones (11) 98888-7777 e (11) 3456-7890.
  • Cliente PJ: ID 9, cadastro em 15/01/2025, tipo PJ, razão social Transportadora Rápida Ltda, CNPJ 12.345.678/0001-90, telefone (11)4002-8922.
  • Veículo: placa ABC1234, cliente 1, marca/modelo Renault Clio, ano 2007, cor Prata.
  • Funcionário: matrícula 4, nome Pedro Lima, cargo Lavador, salário R$ 2.200,00, supervisor matrícula 2 (Ana Souza)
  • Serviços: código 2 (Lavagem Completa, R$ 80,00) e código 8 (Lavagem de Motor, R$ 120,00).
  • Ordem de serviço: nº 1, veículo ABC1234, responsável matrícula 4, data de abertura 04/08/2026, status Concluída.
  • Itens da O.S. 1: serviço 2 (valor cobrado R$ 80,00) e serviço 8 (valor cobrado R$ 120,00).