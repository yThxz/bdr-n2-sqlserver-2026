## 1. Visão Geral do Domínio de Negócio
O sistema tem o objetivo de gerenciar o fluxo de um centro de estética automotiva. O foco do banco de dados é registrar os clientes e seus respectivos veículos, controlar a alocação de funcionários e gerar Ordens de Serviço (OS) detalhadas com os serviços prestados. A aplicação deve garantir a integridade financeira e o histórico de manutenções de cada veículo atendido.

## 2. Entidades e Regras de Negócio
* Clientes: O centro atende consumidores finais e frotas de empresas. Portanto, a entidade Cliente é uma superclasse. Ela deve se especializar em Pessoa_Fisica (armazenamento CPF e Data de Nascimento) e Pessoa_Juridica (armazenamento CNPJ e Inscrição Estadual).
  * Cardinalidade: Um Cliente pode possuir um ou mais Veículos (1:N), e um Veículo pertence a apenas um Cliente (1:1)
* Telefones de contato (Entidade Fraca): Para manter o histórico de contatos, um cliente pode ter múltiplos telefones. O Telefone é uma entidade fraca, pois sua existência depende estruturalmente do Cliente (se o cliente for removido do sistema por LGPD, seus telefones deixam de existir)
* Veículos (Entidade Forte): Registra os carros (Placa, Marca, Modelo, Ano) que dão entrada no pátio.
* Funcionários (Entidade Forte): Registra a equipe operacional e administrativa (Matricula, Nome, Cargo, Salario).
* Serviços (Entidade Forte): O catálogo de estética e mecânica (Código, Descrição, Valor_Tabela). Exemplos: "Polimento Cristalizado", "Higienização Interna", "Lavagem de Motor".
* Ordem de Serviço (OS): É o documento central. Uma OS é aberta para um único Veículo (1:1 naquele atendimento) e é gerenciada por um único Funcionário responsável (1:1).
  * Cardinalidade: Um Veículo pode ter várias OS ao longo do tempo (1:N), e um Funcionário pode gerenciar várias OS (1:N).
* Itens da OS (Entidade Associativa): Uma Ordem de Serviço pode conter múltiplos Serviços (ex: Lavagem + Polimento), e um mesmo Serviço pode aparecer em milhares de OS diferentes. Para resolver essa relação (N:M), nasce a entidade associativa Item_OS.

## 3. Exemplos de Dados (Mock Data)
* Cliente PF: João Silva | CPF: 111.222.333-44 | (11) 98888-7777.
* Veículo: Renault Clio 1.6 16V | Placa: ABC-1234 | Ano: 2007.
* Serviço: S01 - Vitrificação de Pintura | Valor: R$ 850,00.
* OS: Número 1045 | Data: 14/11/2026 | Veículo: ABC-1234 | Responsável: Func. 02.
* Item_OS: OS 1045 | Serviço: S01 | Qtd: 1 | Subtotal: R$ 850,00.