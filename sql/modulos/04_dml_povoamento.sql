use ESTETICA_AUTOMOTIVA;
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
(12, '2026-02-10', 'PJ');

insert into PESSOA_FISICA (ID_Cliente, CPF, RG, Nome, DT_Nascimento) values
(1, '111.222.333-44', '12.345.678-9', 'João Silva', '1990-05-20'),
(2, '222.333.444-55', NULL, 'Maria Costa', NULL),
(3, '333.444.555-66', '23.456.789-0', 'Lucas Andrade', '1985-11-02'),
(4, '444.555.666-77', '34.567.890-1', 'Fernanda Rocha', '1993-07-14'),
(5, '555.666.777-88', NULL, 'Ricardo Gomes', '1978-03-30'),
(6, '666.777.888-99', '56.789.012-3', 'Juliana Martins', '2000-09-08'),
(7, '777.888.999-00', NULL, 'Bruno Ferreira', '1996-12-25'),
(8, '888.999.000-11', '78.901.234-5', 'Camila Nunes', NULL);

INSERT INTO PESSOA_JURIDICA (ID_Cliente, CNPJ, Razao_Social, Inscricao_estadual) VALUES
(9, '12.345.678/0001-90', 'Transportadora Rápida Ltda', NULL),
(10, '23.456.789/0001-01', 'Locadora Via Sul Ltda', '110.042.490.114'),
(11, '34.567.890/0001-12', 'Auto Escola Direção Certa ME', '635.112.908.110'),
(12, '45.678.901/0001-23', 'Imobiliária Lar Ideal Ltda', NULL);

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
(12, '(11) 97654-3210');

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
('IMO6G12', 12, 'Toyota', 'Hilux', 2021, 'Preto');

insert into FUNCIONARIO (Matricula, Nome, Cargo, Salario, Matricula_Supervisor) values
(1, 'Carlos Mendes', 'Gerente', 7000.00, NULL),
(2, 'Ana Souza', 'Encarregada', 4000.00, 1),
(3, 'Rogério Alves', 'Encarregado', 3900.00, 1),
(4, 'Pedro Lima', 'Lavador', 2200.00, 2),
(5, 'Diego Ramos', 'Lavador', 2200.00, 2),
(6, 'Larissa Prado', 'Polidora', 2800.00, 3),
(7, 'Marcelo Dias', 'Higienizador', 2500.00, 3),
(8, 'Patrícia Lopes', 'Atendente', 2100.00, 1);

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
(10, 'Revitalização de Faróis', 140.00);

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
(20, 'QWE5678', 5, '2026-11-17', 'Aberta');

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
(20, 3, 230.00);
go

select 'CLIENTE' as Tabela, count(*) as Linhas from CLIENTE
union all select 'PESSOA_FISICA', count(*) from PESSOA_FISICA
union all select 'PESSOA_JURIDICA', count(*) from PESSOA_JURIDICA
union all select 'TELEFONE_CLIENTE', count(*) from TELEFONE_CLIENTE
union all select 'VEICULO', count(*) from VEICULO
union all select 'FUNCIONARIO', count(*) from FUNCIONARIO
union all select 'SERVICO', count(*) from SERVICO
union all select 'O_S', count(*) from O_S
union all select 'ITEM_OS', count(*) from ITEM_OS;
go