# Banco de Dados — Estética Automotiva (SQL Server 2022)

Modelagem e implementação completa de um banco de dados relacional (`ESTETICA_AUTOMOTIVA`) desenvolvido para a disciplina de Banco de Dados Relacional. O sistema organiza o fluxo operacional de um centro de estética automotiva: cadastro de clientes (PF e PJ), múltiplos telefones, veículos, hierarquia de funcionários, catálogo de serviços e controle de Ordens de Serviço com histórico financeiro.

## Tecnologias
* **SGBD:** Microsoft SQL Server 2022
* **Ferramenta de execução:** SQL Server Management Studio (SSMS)
* **Modelagem:** brModelo (DER) e dbdiagram.io (Modelo Relacional)

## Estrutura do banco

O esquema foi modelado do DER até a **3ª Forma Normal (3FN)**, resultando em **9 tabelas principais** (`CLIENTE`, `PESSOA_FISICA`, `PESSOA_JURIDICA`, `TELEFONE_CLIENTE`, `VEICULO`, `FUNCIONARIO`, `SERVICO`, `O_S` e `ITEM_OS`), além da tabela customizada `Dicionario` para documentação interna das colunas.

### Recursos implementados
* **Integridade e regras de negócio:** chaves primárias compostas (`TELEFONE_CLIENTE` e `ITEM_OS`), restrições `CHECK` (`Tipo_Cliente`, `Salario > 0` e `Status`) e auto-relacionamento de supervisão em `FUNCIONARIO`.
* **View:** `vw_Historico_OS`, consolidando dados da OS, veículo, cliente (PF/PJ), responsável e cálculo dinâmico do valor total.
* **Stored Procedure:** `usp_Abrir_OS`, com validação de existência de veículo, funcionário e serviço, e controle transacional (`BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK`) para gravar a OS e o primeiro item de forma atômica.
* **Triggers:** `trg_PESSOA_FISICA_Exclusividade` e `trg_PESSOA_JURIDICA_Exclusividade`, garantindo que um mesmo cliente não seja cadastrado como PF e PJ simultaneamente.
* **Índices secundários:** 5 índices não-clusterizados voltados para FKs, busca por nome e cobertura de consultas por período (`IX_O_S_Data_Abertura` com `INCLUDE (Status)`). As justificativas técnicas estão em [`docs/03_justificativa_indices.md`](docs/03_justificativa_indices.md).
* **Manutenção (DDL/DML):** inclusão de colunas (`Quilometragem` e `Data_Admissao`), padronização de `CPF` para `CHAR(11)` sem máscara, ajuste de `SERVICO.Descricao` e remoção da coluna `RG`.
* **Consultas (DQL):** 10 consultas cobrindo `INNER`, `LEFT`, `RIGHT` e `FULL OUTER JOIN`, comparação entre sintaxe antiga e ANSI, auto-relacionamento, filtros (`BETWEEN`, `IN`, `NOT IN`, `IS NULL`, `IS NOT NULL`, `LIKE`), CTE com funções de janela e CTE recursiva para organograma.

## Diagramas

### Modelo Conceitual (DER)
![DER Estética Automotiva](diagrams/der_conceitual.png)

### Modelo Relacional
![Modelo Relacional](diagrams/modelo_relacional.png)

## Organização do repositório

```text
bdr-n2-sqlserver-2026/
├── docs/
│   ├── 01_descricao_cenario.md
│   ├── 02_normalizacao_3fn.md
│   ├── 03_justificativa_indices.md
│   ├── 04_registro_uso_ia.md
│   └── Trabalho_BDR_N2_Final.pdf
├── diagrams/
|   ├── der_conceitual.dia
│   ├── der_conceitual.png
│   └── modelo_relacional.png
└── sql/
    ├── modulos/
    │   ├── 01_ddl_estrutura.sql
    │   ├── 02_dicionario_dados.sql
    │   ├── 03_objetos_avancados.sql
    │   ├── 04_dml_povoamento.sql
    │   ├── 05_manutencao_ddl_dml.sql
    │   └── 06_dql_consultas.sql
    └── entrega/
        └── script_completo_sqlserver2022.sql