## Gemini 3.1 PRO (Raciocinio alto)

Você é um experiente DBA e Consultor de T.I com anos de experiência.

To com esse trablho de BD para fazer. Preciso de ajuda nos 3 primeiros passos. Explique um por um e me dê insights de ideias e o que posso usar, em epecial o primeiro passo, quero seguir os padrões reais de uma empresa real para documentar esses requistos. Sobre o cenário gostaria de algo voltado a carros, um sistema de estoque de auto-peças ou de oficina não sei, o que acha que atenderia melhor todos os requisitos desse trabalho? 

Para um projeto acadêmico que exige aplicar todas as regras do Modelo Entidade-Relacionamento (MER) e se manter entre 4 e 10 tabelas na normalização, o cenário de Oficina de Estética Automotiva e Mecânica Rápida é a melhor escolha.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Um sistema de autopeças puro costuma ter regras de generalização mais fracas (forçando a barra para dividir categorias de peças) e poucas entidades fracas naturais. Já o cenário de serviços automotivos permite encaixar naturalmente as exigências do professor (generalização de clientes PF/PJ, entidades associativas em ordens de serviço, chaves compostas) e rende um esquema relacional de exatamente 8 a 9 tabelas.

Como você quer o padrão real de mercado para o Passo 1, no mundo corporativo nós DBAs e Engenheiros de Dados não recebemos um texto corrido genérico; nós estruturamos um Documento de Especificação de Domínio. Ele divide o "Por quê" (Visão Geral), as "Regras do Jogo" (Regras de Negócio e Cardinalidades) e as "Provas" (Exemplos de Dados).

Aqui está a modelagem detalhada dos três primeiros passos para você usar como base.

Passo 1: Descrição do Cenário (Especificação de Requisitos)
No seu documento final (o PDF do trabalho), você pode apresentar o Passo 1 exatamente com esta estrutura profissional:

1. Visão Geral do Domínio de Negócio
O sistema tem como objetivo gerenciar o fluxo operacional de um centro de estética automotiva. O foco do banco de dados é registrar os clientes e seus respectivos veículos, controlar a alocação de funcionários e gerar Ordens de Serviço (OS) detalhadas com os serviços prestados. A aplicação deve garantir a integridade financeira e o histórico de manutenções de cada veículo atendido.

2. Entidades e Regras de Negócio (Regras de Relacionamento)

Clientes (Generalização/Especialização): O centro atende consumidores finais e frotas de empresas. Portanto, a entidade Cliente é uma superclasse. Ela deve se especializar em Pessoa_Fisica (armazenando CPF e Data de Nascimento) e Pessoa_Juridica (armazenando CNPJ e Inscricao Estadual).   
BD - N2 - Trabalho de BDR - V1.4.pdf

Cardinalidade: Um Cliente pode possuir um ou mais Veículos (1:N), e um Veículo pertence a apenas um Cliente (1:1).

Telefones de Contato (Entidade Fraca): Para manter o histórico de contatos, um cliente pode ter múltiplos telefones. O Telefone é uma entidade fraca, pois sua existência depende estruturalmente do Cliente (se o cliente for removido do sistema por LGPD, seus telefones deixam de existir).   
BD - N2 - Trabalho de BDR - V1.4.pdf

Veículos (Entidade Forte): Registra os carros (Placa, Marca, Modelo, Ano) que dão entrada no pátio.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Funcionários (Entidade Forte): Registra a equipe operacional e administrativa (Matricula, Nome, Cargo, Salario).

Serviços (Entidade Forte): O catálogo de estética e mecânica (Código, Descrição, Valor_Tabela). Exemplos: "Polimento Cristalizado", "Higienização Interna", "Troca de Óleo".

Ordem de Serviço (OS): É o documento central. Uma OS é aberta para um único Veículo (1:1 naquele atendimento) e é gerenciada por um único Funcionário responsável (1:1).

Cardinalidade: Um Veículo pode ter várias OS ao longo do tempo (1:N), e um Funcionário pode gerenciar várias OS (1:N).

Itens da OS (Entidade Associativa): Uma Ordem de Serviço pode conter múltiplos Serviços (ex: Lavagem + Polimento), e um mesmo Serviço pode aparecer em milhares de OS diferentes. Para resolver essa relação (N:M), nasce a entidade associativa Item_OS.   
BD - N2 - Trabalho de BDR - V1.4.pdf

3. Exemplos de Dados (Mock Data)

Cliente PF: João Silva | CPF: 111.222.333-44 | (11) 98888-7777.

Veículo: Renault Clio 1.6 16V | Placa: ABC-1234 | Ano: 2007.

Serviço: S01 - Vitrificação de Pintura | Valor: R$ 850,00.

OS: Número 1045 | Data: 14/11/2026 | Veículo: ABC-1234 | Responsável: Func. 02.

Item_OS: OS 1045 | Serviço: S01 | Qtd: 1 | Subtotal: R$ 850,00.

Passo 2: Diagrama Entidade-Relacionamento (DER)
Ao desenhar o DER em ferramentas como brModelo ou Draw.io, o professor avaliará se você atendeu ao checklist de notação visual. Veja como os elementos do Passo 1 se traduzem no desenho:   
BD - N2 - Trabalho de BDR - V1.4.pdf

Entidades Fortes (Retângulo simples): CLIENTE, VEICULO, FUNCIONARIO, SERVICO, ORDEM_SERVICO.

Generalização/Especialização (Triângulo com "IS-A" ou "É-UM"): Saindo de CLIENTE, desça um triângulo apontando para as entidades PESSOA_FISICA e PESSOA_JURIDICA. O atributo identificador (PK) fica apenas na superclasse CLIENTE (ex: ID_Cliente).

Entidade Fraca (Retângulo com borda dupla): TELEFONE. A relação entre Cliente e Telefone também tem losango de borda dupla. A chave do Telefone é parcialmente tracejada (ex: Numero), indicando que ela precisa do ID_Cliente para ser única.

Entidade Associativa (Retângulo com losango dentro): ITEM_OS. Fica exatamente no meio da linha que liga ORDEM_SERVICO e SERVICO.

Chaves Primárias (Sublinhadas): Atributos como ID_Cliente, Placa (ou ID_Veiculo), Matricula, Cod_Servico, Num_OS.

Chave Composta: A PK da entidade ITEM_OS será sublinhada duplamente como Num_OS + Cod_Servico. Isso garante que o mesmo serviço não seja inserido duas vezes na mesma Ordem de Serviço acidentalmente.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Passo 3: Modelo Relacional (MR) e Normalização
Aqui saímos do mundo conceitual e definimos as tabelas ("Esquema Físico Lógico") aplicando as Formas Normais. Uma boa documentação de DBA explica o "porquê" de cada regra ter sido aplicada.   
BD - N2 - Trabalho de BDR - V1.4.pdf

No seu documento, apresente a estrutura das tabelas desta forma:

Estrutura Final (9 Tabelas resultantes):

CLIENTE (ID_Cliente, Data_Cadastro, Tipo_Cliente)

PESSOA_FISICA (ID_Cliente (FK), CPF, RG, Nome, Data_Nascimento)

PESSOA_JURIDICA (ID_Cliente (FK), CNPJ, Razao_Social, Inscricao_Estadual)

TELEFONE_CLIENTE (ID_Cliente (FK), Numero)

VEICULO (Placa, ID_Cliente (FK), Marca, Modelo, Ano, Cor)

FUNCIONARIO (Matricula, Nome, Cargo, Salario)

SERVICO (Cod_Servico, Descricao, Valor_Atual)

ORDEM_SERVICO (Num_OS, Placa (FK), Matricula_Func (FK), Data_Abertura, Status)

ITEM_OS (Num_OS (FK), Cod_Servico (FK), Valor_Cobrado)

Justificativas de Normalização (Exigência do trabalho):   
BD - N2 - Trabalho de BDR - V1.4.pdf

Aplicação da 1ª Forma Normal (1FN) - Atomicidade: A 1FN diz que uma tabela não pode ter atributos multivalorados (listas). Em vez de colocar uma coluna Telefones separada por vírgulas na tabela Cliente, criamos a tabela TELEFONE_CLIENTE. Cada telefone é uma linha única.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Aplicação da 2ª Forma Normal (2FN) - Dependência Funcional Total: A 2FN foca nas chaves compostas. Na tabela ITEM_OS, a chave é (Num_OS, Cod_Servico). Se colocássemos a "Descrição do Serviço" nessa tabela, ela dependeria apenas do Cod_Servico, ferindo a 2FN. Por isso, a descrição ficou isolada na tabela SERVICO.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Aplicação da 3ª Forma Normal (3FN) - Sem Dependências Transitivas: A 3FN proíbe atributos calculados que dependem de outras colunas que não sejam a chave primária. Por exemplo, a tabela ORDEM_SERVICO não deve ter uma coluna Valor_Total. O valor total deve ser calculado no Passo 9 (Consultas DQL) usando SUM(Valor_Cobrado) da tabela ITEM_OS.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Dica de Ouro para a documentação: Como o edital do trabalho exige a declaração de uso de IA, não esqueça de documentar no PDF final os prompts que você utilizou para gerar ideias de esquema, mantendo o limite seguro exigido pela universidade.

To com esse trabalho para fazer, devo criar um repo no github? Se sim como faria e o que estaria dentro desse repo

Sim, vale muito a pena criar um repositório no GitHub, desde que você o mantenha privado até a data de entrega (22/11/2026).   
BD - N2 - Trabalho de BDR - V1.4.pdf

No mundo real da engenharia de software, ninguém desenvolve scripts de banco de dados em grupo trocando arquivos pelo WhatsApp (script_final_v3_AGORA_VAI.sql). Quando até 5 pessoas mexem na mesma estrutura simultaneamente sem controle de versão, surgem dois problemas graves: conflitos de dependência (alguém altera uma chave estrangeira e quebra os INSERTs e JOINs do colega) e perda de rastreabilidade (ninguém sabe quem apagou uma restrição CHECK ou mudou um tipo de dado). O Git resolve exatamente essa dor ao criar um histórico imutável de cada alteração e permitir que vocês testem módulos isolados antes de juntar tudo.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Além disso, como o edital prevê desconto de até 100% da nota em caso de plágio ou cópia entre grupos, manter o repositório privado durante o desenvolvimento impede que outros grupos copiem seu código. Depois do dia 22/11/2026, você muda a visibilidade para Público e ganha um projeto completo de SQL Server 2022 no seu portfólio.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 2

Atenção à regra oficial: O link do GitHub não substitui a entrega no ava.anchieta.br, que exige obrigatoriamente o envio de um arquivo PDF e um único arquivo .SQL executável no SQL Server 2022. O GitHub será a linha de montagem da equipe para gerar esses dois arquivos sem erros.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Como Criar e Operar o Repositório
Crie o repositório como Private: Dê um nome claro (ex: bdr-n2-sqlserver-2026), marque a opção Private, inicialize com um README.md e adicione os integrantes do grupo como Collaborators em Settings > Collaborators.

Proteja a branch main e trabalhe por etapas: Como cada passo do trabalho depende diretamente da precisão do passo anterior, criem branches curtas por entrega (feat/cenario-der, feat/ddl-tabelas, feat/objetos-avancados, feat/dql-consultas). Só façam merge na main depois de rodar o script no SQL Server Management Studio (SSMS) e confirmar que não há erros de sintaxe ou chave estrangeira.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Desenvolva modularizado, entregue unificado: Em equipe, dividir o SQL em 6 arquivos pequenos evita que duas pessoas editem a mesma linha ao mesmo tempo. No final, vocês juntam os módulos na ordem exata de execução dentro de um único arquivo .sql bem comentado, conforme exigido pelo professor.   
BD - N2 - Trabalho de BDR - V1.4.pdf

O Que Deve Estar Dentro do Repositório
Organize as pastas refletindo diretamente a ordem de dependência dos 10 passos do trabalho:   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 1

Plaintext
bdr-n2-sqlserver-2026/
├── README.md
├── .gitignore
├── docs/
│   ├── 01_descricao_cenario.md
│   ├── 02_normalizacao_3fn.md
│   ├── 03_justificativa_indices.md
│   ├── 04_registro_uso_ia.md
│   └── Trabalho_BDR_N2_Final.pdf
├── diagrams/
│   ├── der_conceitual.brM          # ou .drawio (arquivo editável)
│   ├── der_conceitual.png
│   └── modelo_relacional.png
├── sql/
│   ├── modules/
│   │   ├── 01_ddl_estrutura.sql
│   │   ├── 02_dicionario_dados.sql
│   │   ├── 03_objetos_avancados.sql
│   │   ├── 04_dml_povoamento.sql
│   │   ├── 05_manutencao_ddl_dml.sql
│   │   └── 06_dql_consultas.sql
│   └── entrega/
│       └── script_completo_sqlserver2022.sql
Detalhamento do Conteúdo por Pasta
README.md: Resumo do domínio de negócio escolhido, lista dos integrantes (até 5, devidamente inscritos no grupo no AVA), instruções de execução no SQL Server 2022 e, ao final, o link do vídeo de 10 a 15 minutos no YouTube.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 2

.gitignore: Configure para ignorar arquivos temporários do sistema operacional (Thumbs.db, .DS_Store), pastas ocultas de IDE (.vs/, .vscode/) e backups locais de banco (.bak, .mdf, .ldf).

docs/ (Base para montar o PDF):

01_descricao_cenario.md: Documentação do domínio com visão de Engenharia de Software, detalhando entidades, relacionamentos, cardinalidades e exemplos reais de dados (Passo 1).   
BD - N2 - Trabalho de BDR - V1.4.pdf

02_normalizacao_3fn.md: Passo a passo explícito da aplicação da 1FN, 2FN e 3FN até chegar ao esquema final de 4 a 10 tabelas relacionadas (Passo 3).   
BD - N2 - Trabalho de BDR - V1.4.pdf

03_justificativa_indices.md: Explicação técnica do porquê da escolha das colunas nos índices não-clusterizados (Passo 6).   
BD - N2 - Trabalho de BDR - V1.4.pdf

04_registro_uso_ia.md: Caso utilizem IA (limite máximo de 30%), registrem aqui qual ferramenta foi usada, os prompts exatos e os resultados retornados para evitar penalização de até 100% da nota.   
BD - N2 - Trabalho de BDR - V1.4.pdf

Trabalho_BDR_N2_Final.pdf: O documento final consolidado com os prints de execução e o link do YouTube.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 1

diagrams/ (Passos 2 e 3): Guarde tanto a imagem exportada (.png) quanto o arquivo-fonte editável do DER (contendo entidade forte, fraca, associativa, chave composta e generalização/especialização) e do Modelo Relacional. Se precisar ajustar um atributo na véspera, ninguém precisa redesenhar o diagrama do zero.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 1

sql/modules/ (Passos 4 a 9):

01_ddl_estrutura.sql: Criação do banco e das 4 a 10 tabelas no SQL Server 2022 com tipos adequados, PRIMARY KEY, FOREIGN KEY, NOT NULL, CHECK e padrão de nomenclatura (Passo 4).   
BD - N2 - Trabalho de BDR - V1.4.pdf

02_dicionario_dados.sql: Criação e povoamento da tabela Dicionario dentro do próprio banco documentando tabelas, colunas, tipos e descrições (Passo 5).   
BD - N2 - Trabalho de BDR - V1.4.pdf

03_objetos_avancados.sql: Criação e comandos de execução/teste de pelo menos 1 VIEW, 1 STORED PROCEDURE, 1 TRIGGER e os índices não-clusterizados (Passo 6).   
BD - N2 - Trabalho de BDR - V1.4.pdf

04_dml_povoamento.sql: Massa de dados via INSERT respeitando a hierarquia das chaves estrangeiras e com volume suficiente para sustentar as consultas complexas (Passo 7).   
BD - N2 - Trabalho de BDR - V1.4.pdf

05_manutencao_ddl_dml.sql: Comandos ALTER TABLE (adicionar campo, modificar tipo e remover coluna) seguidos dos UPDATEs para tratar os dados afetados (Passo 8).   
BD - N2 - Trabalho de BDR - V1.4.pdf

06_dql_consultas.sql: As 10 consultas comentadas com seus respectivos enunciados, cobrindo diferentes JOINs, auto-relacionamento, comparação entre sintaxe antiga e ANSI moderna, IN, NOT IN, BETWEEN, IS NULL, IS NOT NULL, LIKE com os dois coringas em posições distintas e pelo menos uma CTE (Passo 9).   
BD - N2 - Trabalho de BDR - V1.4.pdf

sql/entrega/script_completo_sqlserver2022.sql: Arquivo único resultante da junção ordenada dos módulos 01 a 06, testado em um banco limpo para garantir que rode do início ao fim sem falhas no dia da gravação do vídeo.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 1

Como hoje é dia 14/11 e o prazo vai até 22/11/2026, a melhor estratégia para reter o conteúdo e não travar no final é dividir em blocos curtos: fechar o Cenário, o DER e a 3FN (Passos 1 a 3) nos próximos dois dias, pois qualquer falha de cardinalidade agora quebra todo o SQL depois.   
BD - N2 - Trabalho de BDR - V1.4.pdf
+ 2

Qual cenário de negócio você e seu grupo decidiram modelar para o Passo 1, e quais entidades principais vocês já identificaram?



## Claude chat (opus 5.5)

https://github.com/yThxz/bdr-n2-sqlserver-2026/blob/main/docs/04_registro_uso_ia.md
olhe como esta o repositório do trabalho, o Thiago me disse que posso fazer a partir do passo 6, me de um resumo completo de como esta o andamento do trabalho e o que posso fazer no momento, me explique o passo 6, 7 e 8 com detalhes para maximizar minha compreensão das tarefas

Vou baixar a versão atual do repositório para ver o que mudou desde ontem.

O repositório é privado, então não consigo abrir pelo link. Vou ver se existe uma cópia dele no seu computador.

Também não há cópia local. Vou tentar abrir o repositório no navegador do app, onde talvez você já esteja logado no GitHub.

Não consegui abrir o repositório atualizado: o GitHub devolve "página não encontrada" (404). Isso acontece quando o repositório é privado e o navegador do app não está logado numa conta com acesso a ele. Por isso o andamento abaixo é o da versão que você me mandou ontem em .zip. Se alguém subiu algo depois, eu não vi.

## Andamento (versão de ontem)

| Passo | Situação |
|---|---|
| 1. Cenário | Feito, mas precisa ser reescrito com as palavras do grupo (está quase igual à resposta do Gemini) e completado (falta a supervisão entre funcionários) |
| 2. DER | Feito e bom |
| 3. Modelo relacional + 3FN | O diagrama está feito; o texto da normalização está incompleto |
| 4. Script físico | 9 tabelas criadas, mas sem comentários, com PKs sem nome e faltando CHECK/UNIQUE |
| 5. Dicionário | Vazio |
| **6, 7 e 8 (os seus)** | **Vazios**: os arquivos `03_objetos_avancados.sql`, `04_dml_povoamento.sql`, `05_manutencao_ddl_dml.sql` e `docs/03_justificativa_indices.md` existem mas estão em branco |
| 9, 10, PDF, README | Vazios |

**O que você pode fazer já:** os Passos 6, 7 e 8 dependem só das tabelas do Passo 4, que já existem. Você pode começar hoje. Combine duas coisas com o grupo:
- Quem faz o **Passo 9** depende dos seus dados (Passo 7) e da estrutura depois das suas alterações (Passo 8). Avise o que você vai inserir e alterar.
- Quem faz o **Passo 5** precisa atualizar o dicionário depois do seu Passo 8.

---

## Passo 6: objetos avançados

O professor pede **pelo menos 1 view, 1 procedure e 1 trigger**, mais **índices não clusterizados com justificativa**. O script precisa mostrar a **criação e o uso** de cada objeto.

### View
Uma view é um **SELECT salvo com nome**. Ela não guarda dados: cada vez que você consulta a view, o SELECT roda de novo. Funciona como uma "tabela virtual".

Para que serve: esconder um JOIN complicado atrás de um nome simples. Quem precisa do relatório escreve só `SELECT * FROM vw_...`.

Ideia para vocês: `vw_Historico_OS`, juntando O_S, VEICULO, CLIENTE, PESSOA_FISICA/PJ, FUNCIONARIO e ITEM_OS, com o **valor total calculado** por `SUM(Valor_Cobrado)`. Isso conversa com o argumento da 3FN de vocês: o total não é guardado, é calculado na hora.

```sql
CREATE OR ALTER VIEW vw_Historico_OS AS
SELECT os.Num_OS, os.Data_Abertura, v.Placa, ...,
       COALESCE(pf.Nome, pj.Razao_Social) AS Cliente,   -- nome da PF ou razão social da PJ
       SUM(i.Valor_Cobrado) AS Valor_Total
FROM O_S os
INNER JOIN VEICULO v ON v.Placa = os.Placa
...
GROUP BY os.Num_OS, os.Data_Abertura, v.Placa, ...;
GO
```

Regras que costumam dar erro:
- `CREATE VIEW` precisa ser o primeiro comando do lote, então coloque `GO` antes e depois.
- Não pode ter `ORDER BY` dentro da view. Ordene no SELECT que usa a view.
- Com `GROUP BY`, toda coluna que não é agregada precisa aparecer no `GROUP BY`.

**Uso:** `SELECT * FROM vw_Historico_OS WHERE Status = 'Concluída';`

### Stored procedure
Uma procedure é um **programa guardado no banco**: recebe parâmetros, valida, executa vários comandos e pode devolver resultado.

Ideia para vocês: `usp_Abrir_OS(@Placa, @Matricula, @Cod_Servico)`. O fluxo:
1. Verifica se a placa, o funcionário e o serviço existem. Se algum não existir, usa `THROW` para gerar um erro com mensagem.
2. `BEGIN TRANSACTION`.
3. Calcula o próximo número: `MAX(Num_OS) + 1`.
4. Insere a O_S com Status `'Aberta'`.
5. Insere o ITEM_OS com o `Valor_Atual` do serviço.
6. `COMMIT`. Se der erro em qualquer ponto, o `CATCH` faz `ROLLBACK`.

O que a transação garante: ou grava a OS **e** o item, ou não grava nada. Nunca fica uma OS sem item.

Use o prefixo `usp_` em vez de `sp_`: procedures com `sp_` o SQL Server procura primeiro no banco `master`.

**Uso:** um `EXEC` que funciona e outro com uma placa inexistente dentro de `BEGIN TRY ... END TRY BEGIN CATCH ... END CATCH`, para mostrar a validação funcionando. Isso fica ótimo no vídeo.

### Trigger
Um trigger é um código que **roda sozinho** quando alguém faz INSERT, UPDATE ou DELETE numa tabela. Ninguém chama o trigger.

Conceitos que você precisa saber:
- **AFTER** roda depois do comando e pode desfazê-lo. **INSTEAD OF** roda no lugar do comando.
- Dentro do trigger existem duas tabelas temporárias: `inserted` (as linhas novas) e `deleted` (as linhas antigas, no caso de UPDATE e DELETE).
- Um INSERT pode trazer várias linhas de uma vez. Por isso o trigger sempre consulta `inserted` com JOIN e nunca supõe que veio uma linha só.

Ideia para vocês: **impedir que um cliente seja PF e PJ ao mesmo tempo**. Hoje o script de vocês permite isso. Uma CHECK não resolve, porque ela só enxerga a própria linha e não consegue olhar outra tabela. O trigger consegue:

```sql
CREATE OR ALTER TRIGGER trg_PESSOA_FISICA_Exclusividade
ON PESSOA_FISICA AFTER INSERT, UPDATE AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i
               INNER JOIN PESSOA_JURIDICA pj ON pj.ID_Cliente = i.ID_Cliente)
    BEGIN
        THROW 50010, N'Cliente já cadastrado como PJ.', 1;
    END;
END;
```

A outra opção do guia é bloquear a inclusão de itens numa OS `Concluída`. Se escolher essa, crie o trigger **depois** dos INSERTs do Passo 7. Senão ele bloqueia os seus próprios dados históricos.

**Uso:** tente inserir algo proibido dentro de um TRY/CATCH, mostre a mensagem de erro e depois um SELECT provando que nada foi gravado.

### Índices não clusterizados
Pense no índice remissivo no final de um livro. Sem ele, para achar um assunto você lê o livro inteiro (o "table scan"). Com ele, você vai direto à página.

- **Clusterizado:** é a própria ordem física da tabela, e só existe um por tabela. Cada PRIMARY KEY já cria um automaticamente.
- **Não clusterizado:** é uma estrutura separada que aponta para as linhas. É esse que o professor pede.
- **O SQL Server não cria índice automático para FOREIGN KEY.** Colunas de FK usadas em JOIN são as melhores candidatas.
- Também são boas candidatas: colunas filtradas com frequência (`WHERE`, `BETWEEN`) e colunas buscadas com `LIKE 'abc%'`. Com `'%abc'` o índice não ajuda.
- O custo: índice ocupa espaço e deixa INSERT e UPDATE mais lentos. Por isso não se indexa tudo, e por isso o professor pede justificativa.

Sugestões com justificativa:

| Índice | Justificativa |
|---|---|
| `O_S(Placa)` | FK usada em todo JOIN com VEICULO (histórico do carro) |
| `O_S(Data_Abertura) INCLUDE (Status)` | Relatórios por período usam BETWEEN. O INCLUDE evita voltar à tabela para ler o Status |
| `VEICULO(ID_Cliente)` | FK usada para listar os carros de um cliente |
| `ITEM_OS(COD_Servico)` | A PK é (Num_OS, COD_Servico) e começa por Num_OS, então buscar só pelo serviço não aproveita a PK |
| `PESSOA_FISICA(Nome)` | O atendimento busca o cliente pelo nome com `LIKE 'João%'` |

Escreva essas justificativas em `docs/03_justificativa_indices.md`, que hoje está vazio.

---

## Passo 7: INSERTs

### 1. Ordem dos INSERTs
A ordem segue as FKs: a tabela "pai" sempre antes da "filha".

CLIENTE → PESSOA_FISICA / PESSOA_JURIDICA → TELEFONE_CLIENTE → VEICULO → FUNCIONARIO → SERVICO → O_S → ITEM_OS

Na tabela FUNCIONARIO, o supervisor precisa existir antes do subordinado, ou os dois precisam ir no mesmo INSERT com várias linhas.

### 2. Cuidados com as regras do Passo 4
- `Tipo_Cliente = 'PF'` precisa corresponder a uma linha em PESSOA_FISICA. O mesmo vale para PJ.
- O Status precisa ser **exatamente** `'Concluída'`, com acento, porque é o que o CHECK aceita.
- **A placa é `CHAR(7)`.** Então `'ABC1234'` funciona, mas `'ABC-1234'` tem 8 caracteres e dá erro. O próprio cenário de vocês usa `ABC-1234` como exemplo.
- Datas no formato `'2026-10-15'` e decimais com ponto: `850.00`.

### 3. Dados pensados para o Passo 9
Este é o ponto mais importante. As consultas só funcionam se houver dados para elas devolverem:

| Caso que precisa existir nos dados | Consulta que depende dele |
|---|---|
| Cliente sem veículo | LEFT JOIN + IS NULL |
| Funcionário sem supervisor e pelo menos 3 níveis de hierarquia | Autorrelacionamento e CTE recursiva |
| Funcionário que nunca gerenciou OS | NOT IN |
| Serviço que nunca foi vendido | RIGHT JOIN |
| Veículo com `Cor` NULL | IS NULL / IS NOT NULL |
| PJ sem inscrição estadual | IS NULL |
| OS de todos os status, espalhadas por alguns meses | IN e BETWEEN |
| Cliente com 2 telefones | Justifica a entidade fraca |
| `Valor_Cobrado` diferente do `Valor_Atual` | Mostra um desconto |

Volume sugerido: cerca de 12 clientes, 15 veículos, 8 funcionários, 10 serviços, 20 OS e 35 itens. No final, faça um `SELECT COUNT(*)` por tabela para conferir.

---

## Passo 8: alterar a estrutura (DDL) e tratar os dados (DML)

- **DDL** muda a estrutura: `ALTER TABLE`.
- **DML** muda os dados: `UPDATE`.

O professor pede os três tipos de ALTER, cada um seguido do tratamento dos dados.

### Incluir uma coluna
As linhas que já existem ficam com NULL na coluna nova. O caminho seguro:
1. `ALTER TABLE VEICULO ADD Quilometragem INT NULL;`
2. `GO`
3. `UPDATE` preenchendo os valores.
4. Se quiser, `ALTER COLUMN ... NOT NULL` no final.

O `GO` é necessário porque o SQL Server compila o lote inteiro antes de executar. Para ele, a coluna nova ainda "não existe" dentro do mesmo lote.

### Modificar o tipo de uma coluna
Os dados precisam caber no tipo novo. Exemplo: CPF de `VARCHAR(14)` (`111.222.333-44`) para `CHAR(11)`:
1. Primeiro o `UPDATE ... SET CPF = REPLACE(REPLACE(CPF,'.',''),'-','')`.
2. Depois o `ALTER COLUMN CPF CHAR(11) NOT NULL`.

O `ALTER COLUMN` falha se a coluna tiver UNIQUE, CHECK ou índice. Nesse caso: remove a restrição, trata os dados, altera e recria.

Aqui aparece outro problema do Passo 4: restrições criadas sem nome recebem nomes aleatórios, e aí fica difícil fazer o `DROP CONSTRAINT`. Evite alterar colunas que são PK, como a Placa.

### Remover uma coluna
`ALTER TABLE PESSOA_FISICA DROP COLUMN RG;`. A justificativa é a LGPD: não guardar dado que a empresa não usa. O DROP falha se alguma restrição, índice ou view usar a coluna. O RG está livre.

### Depois do Passo 8
- Avise quem faz o **Passo 9**: as consultas rodam depois das suas alterações. Por exemplo, o RG não vai mais existir e o CPF fica sem pontos.
- Avise quem faz o **Passo 5** para atualizar o dicionário.

O exemplo do pet shop que deixei na sua pasta tem tudo isso funcionando, nas seções 6.1 a 6.5, 7 e 8.1 a 8.6. Use como consulta, mas escreva o código de vocês. Registre também esta conversa no `04_registro_uso_ia.md`.

---

**Para eu ver o repositório atual**, escolha uma destas opções:
- **Logar no GitHub no navegador do app.** Abra esta conversa no app Claude para desktop, aperte **Ctrl+Shift+B** para mostrar o navegador, entre na sua conta e me avise.
- **Me mandar um .zip novo.** No GitHub: **Code → Download ZIP**.
- **Pedir acesso ao Thiago.** Se você ainda não é colaborador do repositório, ele precisa te adicionar.

Com o repositório atual, eu revejo o andamento e confiro se os nomes das tabelas mudaram antes de você começar.


C:\Git\Anchieta\Projeto2SemestreBD\bdr-n2-sqlserver-2026\sql\modulos

olha como ficou, ja salvei, ta localmente, vamos seguir para fazer os commits, por onde faco commits no ssms ou por outro lugar ?

Os quatro arquivos estão salvos na branch feat/objetos-avancados, que é a branch certa. O 04 (Passo 7) e o 06 (Passo 9) estão iguais ao que combinamos. Mas antes do commit, corrija o 03. Do jeito que está, ele quebra quando roda.

Correções antes do commit

03_objetos_avancados.sql, na parte final (uso dos objetos):

Tem um begin try sem end try. É a linha logo antes de exec usp_Abrir_OS @Placa = 'DFG4321'.... Isso dá erro de sintaxe, e aí nem a procedure nem o teste do trigger rodam. Apague essa linha begin try. A que vem depois, antes do insert into PESSOA_JURIDICA, fica.
Ainda tem o teste com 'TST9A01' / 901 (o exec e o select logo depois dos índices). Esses dados não existem mais. Apague esses dois blocos.
Os blocos de dados de teste e de limpeza no final: apague tudo da linha --DADOS DE TESTE--- até o fim. Além de não servirem mais, o INSERT com CPF '999.999.999-99' dá erro depois do Passo 8, porque o CPF vira CHAR(11).
Coloque um comentário separando as duas partes do arquivo, por exemplo -- USO DOS OBJETOS: rodar depois do 04 (Passo 7). Sem isso, quem rodar o 03 inteiro antes dos INSERTs vai ver erro.

05_manutencao_ddl_dml.sql: as duas linhas com 185000 e 42000 (e o select logo abaixo) sobraram do exemplo antigo. Elas não quebram nada, porque o UPDATE com a fórmula sobrescreve, mas deixam o arquivo confuso. Apague.

Em todos os arquivos (importante para a nota):

Nenhum dos quatro tem comentários. O professor tira até 50% se não der para entender qual parte é qual. Coloque pelo menos um título por bloco, como -- PASSO 6 - VIEW: histórico das OS, com as suas palavras.
O 06 precisa dos enunciados. O professor pede “elabore os enunciados”. Antes de cada consulta, escreva um comentário com a pergunta que ela responde, por exemplo -- Q2: Quais clientes não têm veículo cadastrado?.

O docs/04_registro_uso_ia.md não foi alterado. A data dele é a mesma de quando você clonou o repositório. Registre o uso de IA antes de subir, já que a mensagem para o Thiago diz que já está registrado.

Como fazer os commits

O Git não roda dentro do SSMS de forma prática. Use o Terminal, que é o mais simples e funciona sempre. Depois de salvar as correções:

cd C:\Git\Anchieta\Projeto2SemestreBD\bdr-n2-sqlserver-2026
git status

O git status mostra os arquivos alterados em vermelho. Depois faça um commit por passo. Fica organizado e o Thiago consegue revisar cada um separado:

git add sql/modulos/03_objetos_avancados.sql
git commit -m "Passo 6: view, procedure, triggers e indices"

git add sql/modulos/04_dml_povoamento.sql
git commit -m "Passo 7: povoamento das tabelas"

git add sql/modulos/05_manutencao_ddl_dml.sql
git commit -m "Passo 8: alteracoes de estrutura e tratamento dos dados"

git add sql/modulos/06_dql_consultas.sql
git commit -m "Passo 9: 10 consultas DQL"

git add docs/04_registro_uso_ia.md
git commit -m "Registro de uso de IA (passos 6 a 9)"

git push -u origin feat/objetos-avancados
Se no primeiro commit aparecer “Please tell me who you are”, rode antes:
git config --global user.name "Seu Nome"
git config --global user.email "seu-email-do-github"
Depois do push, entre no repositório no GitHub. Vai aparecer um botão amarelo “Compare & pull request”. Clique, crie o pull request e marque o Thiago para revisar. Ele junta na main depois de aprovar.

Se preferir interface gráfica, abra a pasta do repositório no VS Code. Na aba Source Control (ícone de ramificação, Ctrl+Shift+G) dá para fazer o mesmo clicando.

Quando terminar as correções, me avise que eu leio os arquivos de novo antes de você fazer o push.
