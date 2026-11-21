USE ESTETICA_AUTOMOTIVA
GO

CREATE TABLE Dicionario (
    ID_Dicionario INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nome_Tabela   VARCHAR(50)  NOT NULL,
    Nome_Coluna   VARCHAR(50)  NOT NULL,
    Tipo_Dado     VARCHAR(30)  NOT NULL,
    Obrigatorio   CHAR(3)      NOT NULL,
    Tipo_Chave    VARCHAR(10)  NULL,
    Descricao     VARCHAR(300) NOT NULL,
    CONSTRAINT CHK_Dic_Obrigatorio CHECK (Obrigatorio IN ('SIM', 'NAO'))
)
GO

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('CLIENTE', 'ID_Cliente', 'INT', 'SIM', 'PK', 'Código único de cada cliente cadastrado na estética.'),
('CLIENTE', 'Data_Cadastro', 'DATE', 'SIM', NULL, 'Data em que o cliente entrou no sistema pela primeira vez.'),
('CLIENTE', 'Tipo_Cliente', 'CHAR(2)', 'SIM', NULL, 'Indica se o cliente é Pessoa Física ou Jurídica. Só aceita PF ou PJ por causa da regra CHECK.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('PESSOA_FISICA', 'ID_Cliente', 'INT', 'SIM', 'PK/FK', 'Mesmo ID da tabela CLIENTE, usado para ligar os dados de pessoa física ao cadastro principal.'),
('PESSOA_FISICA', 'CPF', 'VARCHAR(14)', 'SIM', NULL, 'CPF do cliente. Fica como texto para aceitar pontos, traço e zeros à esquerda.'),
('PESSOA_FISICA', 'RG', 'VARCHAR(15)', 'NAO', NULL, 'Número do RG do cliente. Campo opcional.'),
('PESSOA_FISICA', 'Nome', 'VARCHAR(100)', 'SIM', NULL, 'Nome completo do cliente.'),
('PESSOA_FISICA', 'DT_Nascimento', 'DATE', 'NAO', NULL, 'Data de nascimento do cliente, opcional para não travar atendimentos rápidos.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('PESSOA_JURIDICA', 'ID_Cliente', 'INT', 'SIM', 'PK/FK', 'Mesmo ID da tabela CLIENTE, ligando os dados da empresa ao cadastro principal.'),
('PESSOA_JURIDICA', 'CNPJ', 'VARCHAR(18)', 'SIM', NULL, 'CNPJ da empresa cliente, guardado como texto para manter pontuação e zeros à esquerda.'),
('PESSOA_JURIDICA', 'Razao_Social', 'VARCHAR(100)', 'SIM', NULL, 'Nome oficial de registro da empresa.'),
('PESSOA_JURIDICA', 'Inscricao_estadual', 'VARCHAR(20)', 'NAO', NULL, 'Inscrição estadual da empresa. Pode ficar vazio se for isenta.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('TELEFONE_CLIENTE', 'ID_Cliente', 'INT', 'SIM', 'PK/FK', 'Aponta de qual cliente é o telefone. Faz parte da chave composta junto com o número.'),
('TELEFONE_CLIENTE', 'Numero', 'VARCHAR(15)', 'SIM', 'PK', 'Telefone de contato com DDD. Junto com o ID_Cliente, evita cadastrar o mesmo número duas vezes para a mesma pessoa.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('VEICULO', 'Placa', 'CHAR(7)', 'SIM', 'PK', 'Placa do carro com 7 caracteres sem traço (funciona para padrão antigo e Mercosul).'),
('VEICULO', 'ID_Cliente', 'INT', 'SIM', 'FK', 'Indica quem é o dono do veículo, puxando o ID da tabela CLIENTE.'),
('VEICULO', 'Marca', 'VARCHAR(30)', 'SIM', NULL, 'Fabricante do carro (ex: Renault, Honda, Volkswagen).'),
('VEICULO', 'Modelo', 'VARCHAR(30)', 'SIM', NULL, 'Modelo específico do veículo (ex: Clio, Civic, Gol).'),
('VEICULO', 'Ano', 'SMALLINT', 'NAO', NULL, 'Ano de fabricação ou modelo do veículo. Campo opcional.'),
('VEICULO', 'Cor', 'VARCHAR(30)', 'NAO', NULL, 'Cor do carro para ajudar na identificação no pátio. Opcional.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('FUNCIONARIO', 'Matricula', 'INT', 'SIM', 'PK', 'Número de registro interno de cada funcionário da equipe.'),
('FUNCIONARIO', 'Nome', 'VARCHAR(100)', 'SIM', NULL, 'Nome completo do colaborador.'),
('FUNCIONARIO', 'Cargo', 'VARCHAR(30)', 'SIM', NULL, 'Função que o funcionário exerce na oficina (ex: Polidor, Lavador, Gerente).'),
('FUNCIONARIO', 'Salario', 'DECIMAL(10,2)', 'SIM', NULL, 'Salário mensal do funcionário. A regra CHECK impede cadastrar valor zerado ou negativo.'),
('FUNCIONARIO', 'Matricula_Supervisor', 'INT', 'NAO', 'FK', 'Matrícula do chefe direto desse funcionário (auto-relacionamento). Fica vazio para quem não tem superior.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('SERVICO', 'COD_Servico', 'INT', 'SIM', 'PK', 'Código único de cada serviço oferecido no catálogo da estética.'),
('SERVICO', 'Descricao', 'VARCHAR(100)', 'NAO', NULL, 'Nome ou resumo do serviço prestado (ex: Lavagem detalhada, Vitrificação).'),
('SERVICO', 'Valor_Atual', 'DECIMAL(10,2)', 'SIM', NULL, 'Preço de tabela vigente hoje para esse serviço.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('O_S', 'Num_OS', 'INT', 'SIM', 'PK', 'Número de controle único da Ordem de Serviço.'),
('O_S', 'Placa', 'CHAR(7)', 'SIM', 'FK', 'Placa do carro atendido nessa OS. Por ela também conseguimos descobrir quem é o cliente dono do carro.'),
('O_S', 'Matricula_Func', 'INT', 'SIM', 'FK', 'Matrícula do funcionário responsável por tocar o atendimento dessa OS.'),
('O_S', 'Data_Abertura', 'DATE', 'SIM', NULL, 'Dia em que o carro deu entrada e a OS foi aberta.'),
('O_S', 'Status', 'VARCHAR(20)', 'SIM', NULL, 'Situação atual do atendimento. A regra CHECK trava os valores para aceitar apenas: Aberta, Andamento, Concluída ou Cancelada.')

INSERT INTO Dicionario (Nome_Tabela, Nome_Coluna, Tipo_Dado, Obrigatorio, Tipo_Chave, Descricao)
VALUES
('ITEM_OS', 'Num_OS', 'INT', 'SIM', 'PK/FK', 'Número da OS em que o serviço foi lançado. Parte da chave composta junto com COD_Servico.'),
('ITEM_OS', 'COD_Servico', 'INT', 'SIM', 'PK/FK', 'Código do serviço incluído na OS. Junto com Num_OS, impede lançar o mesmo serviço duplicado no mesmo atendimento.'),
('ITEM_OS', 'Valor_Cobrado', 'DECIMAL(10,2)', 'SIM', NULL, 'Valor que foi realmente fechado com o cliente naquela OS. Guarda o histórico mesmo que o preço de tabela mude depois.')
GO
