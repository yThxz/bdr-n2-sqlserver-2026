
use ESTETICA_AUTOMOTIVA;
go

ALTER TABLE VEICULO ADD Quilometragem INT NULL;
go


ALTER TABLE FUNCIONARIO ADD Data_Admissao DATE NULL;
go

update VEICULO set Quilometragem = (2026 - Ano) * 12000;

update FUNCIONARIO SET Data_Admissao = '2018-02-01' WHERE Matricula = 1;
update FUNCIONARIO set Data_Admissao = '2019-06-10' where Matricula = 2;
update FUNCIONARIO SET Data_Admissao = '2020-01-15' WHERE Matricula = 3;
update FUNCIONARIO set Data_Admissao = '2021-03-01' where Matricula = 4;
update FUNCIONARIO SET Data_Admissao = '2022-08-22' WHERE Matricula = 5;
update FUNCIONARIO set Data_Admissao = '2023-05-02' where Matricula = 6;
update FUNCIONARIO SET Data_Admissao = '2024-02-19' WHERE Matricula = 7;
update FUNCIONARIO set Data_Admissao = '2025-07-07' where Matricula = 8;
go

alter table FUNCIONARIO alter column Data_Admissao date not null;
go

update PESSOA_FISICA
set CPF = replace(replace(CPF, '.', ''), '-', '');
go

alter table PESSOA_FISICA alter column CPF char(11) not null;
go

select ID_Cliente, Nome, CPF from PESSOA_FISICA;
go

update SERVICO set Descricao = 'Serviço sem descrição' where Descricao is null;
go

alter table SERVICO alter column Descricao varchar(150) not null;
go

alter table PESSOA_FISICA drop column RG;
go

select TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in ('VEICULO', 'FUNCIONARIO', 'PESSOA_FISICA', 'SERVICO')
order by TABLE_NAME, ORDINAL_POSITION;
go