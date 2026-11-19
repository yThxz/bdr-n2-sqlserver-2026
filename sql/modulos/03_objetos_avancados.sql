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

exec usp_Abrir_OS @Placa = 'TST9A01',@Matricula = 901,
    @Cod_Servico = 901;
go

select *
  from vw_Historico_OS where Placa = 'TST9A01';
go

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
go

