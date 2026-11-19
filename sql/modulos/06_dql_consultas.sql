use ESTETICA_AUTOMOTIVA;
go

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

SELECT f.Matricula, f.Nome, f.Cargo
from FUNCIONARIO f
where f.Matricula not in (select os.Matricula_Func
from O_S os
where os.Data_Abertura between '2026-10-01' and '2026-10-31')
order by f.Nome;
go

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
