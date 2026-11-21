-------------------- Passo 4 --------------------
CREATE DATABASE ESTETICA_AUTOMOTIVA
GO

USE ESTETICA_AUTOMOTIVA
GO

CREATE TABLE CLIENTE (
	ID_Cliente INT NOT NULL PRIMARY KEY,
	Data_Cadastro DATE NOT NULL,
	Tipo_Cliente CHAR(02) NOT NULL,
	CONSTRAINT CHK_Tipo_Cliente CHECK (Tipo_Cliente IN ('PF', 'PJ'))
)

CREATE TABLE PESSOA_FISICA (
	ID_Cliente INT NOT NULL PRIMARY KEY,
	CPF VARCHAR(14) NOT NULL,
	RG VARCHAR(15),
	Nome VARCHAR(100) NOT NULL,
	DT_Nascimento DATE,
	CONSTRAINT FK_PF_Cliente FOREIGN KEY(ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
)

CREATE TABLE PESSOA_JURIDICA (
	ID_Cliente INT NOT NULL PRIMARY KEY,
	CNPJ VARCHAR(18) NOT NULL,
	Razao_Social VARCHAR(100) NOT NULL,
	Inscricao_estadual VARCHAR(20),
	CONSTRAINT FK_PJ_Cliente FOREIGN KEY(ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
)

CREATE TABLE TELEFONE_CLIENTE (
	ID_Cliente INT NOT NULL,
	Numero VARCHAR(15) Not NULL,
	CONSTRAINT FK_Tel_Cliente FOREIGN KEY(ID_Cliente) REFERENCES CLIENTE(ID_Cliente),
	CONSTRAINT PK_Telefone PRIMARY KEY (ID_Cliente, Numero)
)

CREATE TABLE VEICULO (
	Placa CHAR(7) NOT NULL PRIMARY KEY,
	ID_Cliente INT NOT NULL,
	Marca VARCHAR(30) NOT NULL,
	Modelo VARCHAR(30) NOT NULL,
	Ano SMALLINT,
	Cor VARCHAR(30),
	CONSTRAINT FK_Veiculo_Cliente FOREIGN KEY(ID_Cliente) REFERENCES CLIENTE(ID_Cliente)
)

CREATE TABLE FUNCIONARIO (
	Matricula INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Cargo VARCHAR(30) NOT NULL,
	Salario DECIMAL(10,2) NOT NULL,
	Matricula_Supervisor INT NULL,
	CONSTRAINT CHK_Salario CHECK (Salario > 0),
	CONSTRAINT FK_Func_Supervisor FOREIGN KEY(Matricula_Supervisor) REFERENCES FUNCIONARIO(Matricula)
)

CREATE TABLE SERVICO (
	COD_Servico INT NOT NULL PRIMARY KEY,
	Descricao VARCHAR(100),
	Valor_Atual DECIMAL(10,2) NOT NULL
)

CREATE TABLE O_S (
	Num_OS INT NOT NULL primary key,
	Placa CHAR(7) NOT NULL,
	Matricula_Func INT NOT NULL,
	Data_Abertura DATE NOT NULL,
	Status VARCHAR(20) NOT NULL,
	CONSTRAINT FK_O_S_Placa FOREIGN KEY(Placa) REFERENCES VEICULO(Placa),
	CONSTRAINT FK_O_S_Funcionario FOREIGN KEY(Matricula_Func) REFERENCES FUNCIONARIO(Matricula),
	CONSTRAINT CHK_Status CHECK (Status IN ('Aberta', 'Andamento', 'Concluída', 'Cancelada'))
)

CREATE TABLE ITEM_OS (
	Num_OS INT NOT NULL,
	COD_Servico INT NOT NULL,
	Valor_Cobrado DECIMAL(10,2) NOT NULL,
	CONSTRAINT FK_ITEM_OS_NUM_OS FOREIGN KEY(Num_OS) REFERENCES O_S(Num_OS),
	CONSTRAINT FK_ITEM_OS_COD_Servico FOREIGN KEY(COD_Servico) REFERENCES SERVICO(COD_Servico),
	CONSTRAINT PK_Item_OS PRIMARY KEY (Num_OS, COD_Servico)
)
GO

-------------------- Passo 5 --------------------
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

-------------------- Passo 6 --------------------
USE ESTETICA_AUTOMOTIVA;
GO

create or alter view vw_Historico_OS
as
select
os.Num_OS, os.Data_Abertura,
  os.Status,
  v.Placa, v.Marca,
  v.Modelo,
  c.Tipo_Cliente,
case when c.Tipo_Cliente = 'PF' then pf.Nome else pj.Razao_Social end as Nome_Cliente,
f.Nome as Funcionario_Responsavel,
isnull(sum(i.Valor_Cobrado),0) as Valor_Total

from O_S os

inner join VEICULO v on v.Placa = os.Placa
inner join CLIENTE c on c.ID_Cliente = v.ID_Cliente
left join PESSOA_FISICA pf on pf.ID_Cliente = c.ID_Cliente
left join PESSOA_JURIDICA pj on pj.ID_Cliente = c.ID_Cliente
inner join FUNCIONARIO f on f.Matricula = os.Matricula_Func
left join ITEM_OS i on i.Num_OS = os.Num_OS

    group by
    os.Num_OS, os.Data_Abertura, os.Status,
    v.Placa, v.Marca, v.Modelo, c.Tipo_Cliente,
    pf.Nome, pj.Razao_Social, f.Nome;
go

create or alter procedure usp_Abrir_OS
    @Placa char(7),
    @Matricula int,
    @Cod_Servico int
as
begin
set nocount on;

if not exists (select 1 from VEICULO where Placa = @Placa)
begin
raiserror('Erro: placa não encontrada.',16,1);
return;
end

    if not exists (select 1 from FUNCIONARIO where Matricula = @Matricula)
begin
raiserror('Erro: funcionário não encontrado.', 16, 1);
return;
end

if not exists (select 1 from SERVICO where COD_Servico = @Cod_Servico)
begin
raiserror('Erro: serviço não encontrado.',16,1);
return;
end

declare @NovoNumero int; declare @Valor decimal(10,2);

select @Valor = Valor_Atual from SERVICO where COD_Servico = @Cod_Servico;

begin try
begin transaction;

select @NovoNumero = isnull(max(Num_OS),0)+1 from O_S;

insert into O_S (Num_OS, Placa, Matricula_Func, Data_Abertura, Status)
values (@NovoNumero,@Placa,@Matricula,cast(getdate() as date),'Aberta');

insert into ITEM_OS (Num_OS, COD_Servico, Valor_Cobrado)
values (@NovoNumero, @Cod_Servico, @Valor);

commit transaction;

select @NovoNumero as OS_Criada;
end try
begin catch
if @@trancount > 0
rollback transaction;
throw;
end catch
end;
go

create or alter trigger trg_PESSOA_FISICA_Exclusividade
on PESSOA_FISICA
after insert, update
as
begin
set nocount on;

if exists (select 1 from inserted i inner join CLIENTE c on c.ID_Cliente = i.ID_Cliente where c.Tipo_Cliente <> 'PF')
begin
raiserror('Erro: este cliente não é do tipo PF.', 16, 1);
rollback transaction;
return;
end

  if exists (
  select 1 from inserted i
  inner join PESSOA_JURIDICA pj on pj.ID_Cliente = i.ID_Cliente
)
begin
raiserror('Erro: este cliente já está cadastrado como PJ.',16,1);
rollback transaction;
return;
end
end;
go

create or alter trigger trg_PESSOA_JURIDICA_Exclusividade
on PESSOA_JURIDICA
after insert, update
as
begin
set nocount on;

if exists (select 1
from inserted i
inner join CLIENTE c on c.ID_Cliente = i.ID_Cliente
where c.Tipo_Cliente <> 'PJ')
begin
raiserror('Erro: este cliente não é do tipo PJ.', 16, 1);
rollback transaction;
return;
end

if exists (select 1 from inserted i inner join PESSOA_FISICA pf on pf.ID_Cliente = i.ID_Cliente)
begin
raiserror('Erro: este cliente já está cadastrado como PF.',16,1);
rollback transaction;
return;
end
end;
go

drop index if exists IX_O_S_Placa on O_S;
create nonclustered index IX_O_S_Placa on O_S (Placa);

drop index if exists IX_O_S_Data_Abertura on O_S;
create nonclustered index IX_O_S_Data_Abertura
    on O_S (Data_Abertura) include (Status);

drop index if exists IX_VEICULO_ID_Cliente on VEICULO;
create nonclustered index IX_VEICULO_ID_Cliente on VEICULO (ID_Cliente);

drop index if exists IX_ITEM_OS_COD_Servico on ITEM_OS;
create nonclustered index IX_ITEM_OS_COD_Servico on ITEM_OS (COD_Servico);

drop index if exists IX_PESSOA_FISICA_Nome on PESSOA_FISICA;
create nonclustered index IX_PESSOA_FISICA_Nome on PESSOA_FISICA (Nome);
go

select t.name as Tabela, i.name as Indice,
    i.type_desc as Tipo
from sys.indexes i
  inner join sys.tables t on t.object_id = i.object_id
where i.name like 'IX_%'
order by t.name;
go

-------------------- Passo 7 --------------------
use ESTETICA_AUTOMOTIVA
go

INSERT INTO CLIENTE (ID_Cliente, Data_Cadastro, Tipo_Cliente) VALUES
(1, '2025-06-10', 'PF'),
(2, '2026-01-15', 'PF'),
(3, '2025-02-20', 'PF'),
(4, '2025-04-08', 'PF'),
(5, '2025-08-30', 'PF'),
(6, '2025-11-12', 'PF'),
(7, '2026-03-05', 'PF'),
(8, '2026-05-19', 'PF'),
(9, '2025-01-15', 'PJ'),
(10, '2025-03-22', 'PJ'),
(11, '2025-07-01', 'PJ'),
(12, '2026-02-10', 'PJ')

insert into PESSOA_FISICA (ID_Cliente, CPF, RG, Nome, DT_Nascimento) values
(1, '111.222.333-44', '12.345.678-9', 'João Silva', '1990-05-20'),
(2, '222.333.444-55', NULL, 'Maria Costa', NULL),
(3, '333.444.555-66', '23.456.789-0', 'Lucas Andrade', '1985-11-02'),
(4, '444.555.666-77', '34.567.890-1', 'Fernanda Rocha', '1993-07-14'),
(5, '555.666.777-88', NULL, 'Ricardo Gomes', '1978-03-30'),
(6, '666.777.888-99', '56.789.012-3', 'Juliana Martins', '2000-09-08'),
(7, '777.888.999-00', NULL, 'Bruno Ferreira', '1996-12-25'),
(8, '888.999.000-11', '78.901.234-5', 'Camila Nunes', NULL)

INSERT INTO PESSOA_JURIDICA (ID_Cliente, CNPJ, Razao_Social, Inscricao_estadual) VALUES
(9, '12.345.678/0001-90', 'Transportadora Rápida Ltda', NULL),
(10, '23.456.789/0001-01', 'Locadora Via Sul Ltda', '110.042.490.114'),
(11, '34.567.890/0001-12', 'Auto Escola Direção Certa ME', '635.112.908.110'),
(12, '45.678.901/0001-23', 'Imobiliária Lar Ideal Ltda', NULL)

insert into TELEFONE_CLIENTE (ID_Cliente, Numero) values
(1, '(11) 98888-7777'),
(1, '(11) 3456-7890'),
(3, '(11) 97777-1234'),
(4, '(11) 96666-4321'),
(4, '(11) 4567-1122'),
(5, '(19) 99876-5432'),
(6, '(11) 95555-8888'),
(8, '(11) 94444-2222'),
(9, '(11) 4002-8922'),
(9, '(11) 98123-4567'),
(10, '(11) 3333-4444'),
(11, '(11) 2222-5555'),
(12, '(11) 97654-3210')

INSERT INTO VEICULO (Placa, ID_Cliente, Marca, Modelo, Ano, Cor) VALUES
('ABC1234', 1, 'Renault', 'Clio', 2007, 'Prata'),
('BRA2E19', 1, 'Honda', 'Civic', 2018, 'Preto'),
('QWE5678', 3, 'Volkswagen', 'Gol', 2012, 'Branco'),
('RTY9C21', 4, 'Toyota', 'Corolla', 2022, 'Cinza'),
('UIO3456', 5, 'Chevrolet', 'Onix', 2020, NULL),
('PAS7F88', 6, 'Jeep', 'Compass', 2023, 'Vermelho'),
('DFG4321', 7, 'Fiat', 'Argo', 2021, 'Azul'),
('HJK8D77', 8, 'Hyundai', 'HB20', 2019, 'Branco'),
('FRT2B45', 9, 'Mercedes', 'Sprinter', 2021, NULL),
('FRT3C56', 9, 'Mercedes', 'Sprinter', 2022, 'Branco'),
('FRT4D67', 9, 'Volvo', 'FH 540', 2020, NULL),
('LOC1A23', 10, 'Fiat', 'Mobi', 2023, 'Prata'),
('LOC2B34', 10, 'Renault', 'Kwid', 2024, 'Branco'),
('AUT5E90', 11, 'Volkswagen', 'Polo', 2022, 'Branco'),
('IMO6G12', 12, 'Toyota', 'Hilux', 2021, 'Preto')

insert into FUNCIONARIO (Matricula, Nome, Cargo, Salario, Matricula_Supervisor) values
(1, 'Carlos Mendes', 'Gerente', 7000.00, NULL),
(2, 'Ana Souza', 'Encarregada', 4000.00, 1),
(3, 'Rogério Alves', 'Encarregado', 3900.00, 1),
(4, 'Pedro Lima', 'Lavador', 2200.00, 2),
(5, 'Diego Ramos', 'Lavador', 2200.00, 2),
(6, 'Larissa Prado', 'Polidora', 2800.00, 3),
(7, 'Marcelo Dias', 'Higienizador', 2500.00, 3),
(8, 'Patrícia Lopes', 'Atendente', 2100.00, 1)

INSERT INTO SERVICO (COD_Servico, Descricao, Valor_Atual) VALUES
(1, 'Lavagem Simples', 50.00),
(2, 'Lavagem Completa', 80.00),
(3, 'Higienização Interna', 250.00),
(4, 'Polimento Técnico', 400.00),
(5, 'Vitrificação de Pintura', 850.00),
(6, 'Cristalização de Vidros', 150.00),
(7, 'Hidratação de Couro', 180.00),
(8, 'Lavagem de Motor', 120.00),
(9, 'Película Automotiva', 600.00),
(10, 'Revitalização de Faróis', 140.00)

insert into O_S (Num_OS, Placa, Matricula_Func, Data_Abertura, Status) values
(1, 'ABC1234', 4, '2026-08-04', 'Concluída'),
(2, 'FRT2B45', 2, '2026-08-06', 'Concluída'),
(3, 'QWE5678', 4, '2026-08-11', 'Concluída'),
(4, 'RTY9C21', 6, '2026-08-19', 'Concluída'),
(5, 'FRT3C56', 5, '2026-08-27', 'Concluída'),
(6, 'BRA2E19', 6, '2026-09-03', 'Concluída'),
(7, 'UIO3456', 7, '2026-09-09', 'Concluída'),
(8, 'PAS7F88', 6, '2026-09-16', 'Concluída'),
(9, 'LOC1A23', 5, '2026-09-22', 'Cancelada'),
(10, 'FRT4D67', 4, '2026-09-29', 'Concluída'),
(11, 'HJK8D77', 7, '2026-10-02', 'Concluída'),
(12, 'DFG4321', 4, '2026-10-08', 'Concluída'),
(13, 'AUT5E90', 3, '2026-10-14', 'Concluída'),
(14, 'LOC2B34', 5, '2026-10-21', 'Concluída'),
(15, 'ABC1234', 7, '2026-10-28', 'Concluída'),
(16, 'IMO6G12', 6, '2026-11-03', 'Concluída'),
(17, 'FRT2B45', 2, '2026-11-09', 'Andamento'),
(18, 'RTY9C21', 6, '2026-11-12', 'Andamento'),
(19, 'BRA2E19', 4, '2026-11-16', 'Aberta'),
(20, 'QWE5678', 5, '2026-11-17', 'Aberta')

INSERT INTO ITEM_OS (Num_OS, COD_Servico, Valor_Cobrado) VALUES
(1, 2, 80.00), (1, 8, 120.00),
(2, 1, 45.00), (2, 8, 108.00),
(3, 2, 80.00),
(4, 4, 400.00), (4, 5, 850.00),
(5, 2, 72.00),
(6, 3, 250.00), (6, 7, 180.00),
(7, 1, 50.00),
(8, 5, 800.00), (8, 6, 150.00),
(9, 1, 50.00),
(10, 2, 72.00), (10, 8, 108.00),
(11, 3, 250.00),
(12, 2, 80.00), (12, 6, 150.00),
(13, 1, 50.00),
(14, 1, 45.00),
(15, 4, 380.00), (15, 7, 180.00),
(16, 3, 250.00), (16, 2, 80.00),
(17, 2, 72.00),
(18, 5, 850.00),
(19, 1, 50.00),
(20, 3, 230.00)
go

select 'CLIENTE' as Tabela, count(*) as Linhas from CLIENTE
union all select 'PESSOA_FISICA', count(*) from PESSOA_FISICA
union all select 'PESSOA_JURIDICA', count(*) from PESSOA_JURIDICA
union all select 'TELEFONE_CLIENTE', count(*) from TELEFONE_CLIENTE
union all select 'VEICULO', count(*) from VEICULO
union all select 'FUNCIONARIO', count(*) from FUNCIONARIO
union all select 'SERVICO', count(*) from SERVICO
union all select 'O_S', count(*) from O_S
union all select 'ITEM_OS', count(*) from ITEM_OS
Go

-- Passo 6 (Utilizacao): testes da Procedure, View e Trigger apos o povoamento
begin try
exec usp_Abrir_OS @Placa = 'DFG4321', @Matricula = 7, @Cod_Servico = 6;
select * from vw_Historico_OS where Placa = 'DFG4321';

insert into PESSOA_JURIDICA (ID_Cliente, CNPJ, Razao_Social)
values (1, '99.999.999/0001-99', 'Empresa Teste');
end try
begin catch
if @@trancount > 0 rollback transaction;
print 'Trigger bloqueou: ' + error_message();
end catch
go

select * from PESSOA_JURIDICA where ID_Cliente = 1;
Go

-------------------- Passo 8 --------------------
use ESTETICA_AUTOMOTIVA
go

ALTER TABLE VEICULO ADD Quilometragem INT NULL
go


ALTER TABLE FUNCIONARIO ADD Data_Admissao DATE NULL
go

update VEICULO set Quilometragem = (2026 - Ano) * 12000

update FUNCIONARIO SET Data_Admissao = '2018-02-01' WHERE Matricula = 1
update FUNCIONARIO set Data_Admissao = '2019-06-10' where Matricula = 2
update FUNCIONARIO SET Data_Admissao = '2020-01-15' WHERE Matricula = 3
update FUNCIONARIO set Data_Admissao = '2021-03-01' where Matricula = 4
update FUNCIONARIO SET Data_Admissao = '2022-08-22' WHERE Matricula = 5
update FUNCIONARIO set Data_Admissao = '2023-05-02' where Matricula = 6
update FUNCIONARIO SET Data_Admissao = '2024-02-19' WHERE Matricula = 7
update FUNCIONARIO set Data_Admissao = '2025-07-07' where Matricula = 8
go

alter table FUNCIONARIO alter column Data_Admissao date not null
go

update PESSOA_FISICA
set CPF = replace(replace(CPF, '.', ''), '-', '');
go

alter table PESSOA_FISICA alter column CPF char(11) not null
go

select ID_Cliente, Nome, CPF from PESSOA_FISICA
go

update SERVICO set Descricao = 'Serviço sem descrição' where Descricao is null
go

alter table SERVICO alter column Descricao varchar(150) not null
go

alter table PESSOA_FISICA drop column RG
go

select TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in ('VEICULO', 'FUNCIONARIO', 'PESSOA_FISICA', 'SERVICO')
order by TABLE_NAME, ORDINAL_POSITION
Go

-------------------- Passo 9 --------------------
use ESTETICA_AUTOMOTIVA;
go

-- Consulta 1: OS concluídas em outubro de 2026 com veículo e funcionário, escrita na sintaxe antiga e no INNER JOIN padrão para comparar.
select os.Num_OS, os.Data_Abertura, v.Placa, v.Modelo, f.Nome as Funcionario
from O_S os, VEICULO v, FUNCIONARIO f
where os.Placa = v.Placa
and os.Matricula_Func = f.Matricula
and os.Status = 'Concluída'
and os.Data_Abertura BETWEEN '2026-10-01' AND '2026-10-31'
order by os.Data_Abertura;

SELECT os.Num_OS, os.Data_Abertura, v.Placa, v.Modelo, f.Nome AS Funcionario
from O_S os
inner join VEICULO v on v.Placa = os.Placa
inner join FUNCIONARIO f on f.Matricula = os.Matricula_Func
where os.Status = 'Concluída'
and os.Data_Abertura between '2026-10-01' and '2026-10-31'
order by os.Data_Abertura;
go

-- Consulta 2: Clientes cadastrados que ainda não têm nenhum veículo vinculado, encontrados com LEFT JOIN e IS NULL.
select c.ID_Cliente,
coalesce(pf.Nome, pj.Razao_Social) as Cliente,
c.Tipo_Cliente,
c.Data_Cadastro
from CLIENTE c
left join VEICULO v on v.ID_Cliente = c.ID_Cliente
left join PESSOA_FISICA pf on pf.ID_Cliente = c.ID_Cliente
left join PESSOA_JURIDICA pj on pj.ID_Cliente = c.ID_Cliente
where v.Placa is null;
go

-- Consulta 3: Total de vendas e faturamento de cada serviço com RIGHT JOIN, trazendo até os que nunca foram vendidos.
SELECT s.COD_Servico,
s.Descricao,
s.Valor_Atual,
count(i.COD_Servico) as Vezes_Vendido,
isnull(sum(i.Valor_Cobrado), 0) as Total_Faturado
from ITEM_OS i
right join SERVICO s on s.COD_Servico = i.COD_Servico
group by s.COD_Servico, s.Descricao, s.Valor_Atual
order by Total_Faturado desc;
go

-- Consulta 4: Checa com FULL OUTER JOIN e IS NOT NULL se algum cliente caiu em PESSOA_FISICA e PESSOA_JURIDICA ao mesmo tempo.
select c.ID_Cliente,
c.Tipo_Cliente,
case when pf.ID_Cliente is not null then 'CPF' else 'CNPJ' end as Documento,
coalesce(pf.CPF, pj.CNPJ) as Numero_Documento,
coalesce(pf.Nome, pj.Razao_Social) as Nome_Razao_Social,
case when pf.ID_Cliente is not null and pj.ID_Cliente is not null
then 'ERRO: PF e PJ' else 'OK' end as Verificacao
from PESSOA_FISICA pf
full outer join PESSOA_JURIDICA pj on pj.ID_Cliente = pf.ID_Cliente
inner join CLIENTE c on c.ID_Cliente = coalesce(pf.ID_Cliente, pj.ID_Cliente)
order by c.ID_Cliente;
go

-- Consulta 5: Lista os funcionários com o nome do supervisor direto e quantas OS cada um atendeu, com auto-relacionamento.
SELECT f.Matricula,
f.Nome as Funcionario,
f.Cargo,
isnull(s.Nome, '(topo da hierarquia)') as Supervisor,
(select count(*) from O_S os
where os.Matricula_Func = f.Matricula) as Total_OS
from FUNCIONARIO f
left join FUNCIONARIO s on s.Matricula = f.Matricula_Supervisor
order by s.Nome, f.Nome;
go

-- Consulta 6: Serviços de códigos 3 a 7 feitos entre setembro e outubro de 2026 em OS concluídas ou em andamento, só em carros com cor preenchida, filtrados com BETWEEN, IN e IS NOT NULL.
select os.Num_OS, os.Data_Abertura, v.Placa, v.Modelo, v.Cor,
s.Descricao as Servico, i.Valor_Cobrado
from O_S os
inner join VEICULO v on v.Placa = os.Placa
inner join ITEM_OS i on i.Num_OS = os.Num_OS
inner join SERVICO s on s.COD_Servico = i.COD_Servico
where os.Data_Abertura BETWEEN '2026-09-01' AND '2026-10-31'
and os.Status in ('Concluída', 'Andamento')
and i.COD_Servico in (3, 4, 5, 6, 7)
and v.Cor is not null
order by os.Data_Abertura;
go

-- Consulta 7: Funcionários que não pegaram nenhuma OS em outubro de 2026, combinando NOT IN e BETWEEN.
SELECT f.Matricula, f.Nome, f.Cargo
from FUNCIONARIO f
where f.Matricula not in (select os.Matricula_Func
from O_S os
where os.Data_Abertura between '2026-10-01' and '2026-10-31')
order by f.Nome;
go

-- Consulta 8: Busca clientes com celular de SP (11) 9____-____, nome com "a" na segunda letra ou empresa terminando em "Ltda", usando LIKE com % e _.
select coalesce(pf.Nome, pj.Razao_Social) as Cliente,
t.Numero,
case
when t.Numero like '(11) 9____-____' then 'Celular SP (_ no meio)'
when pf.Nome like '_a%' then '2ª letra "a" (_ no início, % no fim)'
when pj.Razao_Social like '%Ltda' then 'Empresa Ltda (% no início)'
end as Regra_Encontrada
from TELEFONE_CLIENTE t
inner join CLIENTE c on c.ID_Cliente = t.ID_Cliente
left join PESSOA_FISICA pf on pf.ID_Cliente = c.ID_Cliente
left join PESSOA_JURIDICA pj on pj.ID_Cliente = c.ID_Cliente
where t.Numero like '(11) 9____-____'
or pf.Nome like '_a%'
or pj.Razao_Social like '%Ltda'
order by Cliente;
go

-- Consulta 9: Ranking de faturamento por funcionário em OS concluídas, com uma CTE para comparar cada um com a média da equipe.
with Faturamento as (
select f.Matricula,
f.Nome,
f.Cargo,
count(distinct os.Num_OS) as Qtd_OS,
sum(i.Valor_Cobrado) as Total_Faturado
from FUNCIONARIO f
inner join O_S os on os.Matricula_Func = f.Matricula
inner join ITEM_OS i on i.Num_OS = os.Num_OS
where os.Status = 'Concluída'
group by f.Matricula, f.Nome, f.Cargo
)
SELECT RANK() OVER (ORDER BY Total_Faturado DESC) AS Posicao,
Nome,
Cargo,
Qtd_OS,
Total_Faturado,
cast(avg(Total_Faturado) over () as decimal(10,2)) as Media_Equipe,
case when Total_Faturado >= avg(Total_Faturado) over ()
then 'Acima da média' else 'Abaixo da média' end as Situacao
from Faturamento
order by Posicao;
go

-- Consulta 10: Organograma da equipe montado com CTE recursiva, mostrando a hierarquia completa a partir da gerência.
with Hierarquia as (
select Matricula, Nome, Cargo,
0 as Nivel,
cast(Nome as varchar(500)) as Caminho
from FUNCIONARIO
where Matricula_Supervisor is null

union all

select f.Matricula, f.Nome, f.Cargo,
h.Nivel + 1,
cast(h.Caminho + ' > ' + f.Nome as varchar(500))
from FUNCIONARIO f
inner join Hierarquia h on f.Matricula_Supervisor = h.Matricula
)
select replicate('    ', Nivel) + Nome as Organograma,
Cargo,
Nivel,
Caminho
from Hierarquia
order by Caminho;
go

