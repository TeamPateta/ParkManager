/****** Object:  StoredProcedure [dbo].[Funcoes_Pesquisa]    Script Date: 02/10/2021 19:28:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [dbo].[Funcoes_Pesquisa](
@Flag int,
@Tipo varchar(20) = null,
@Placa varchar(7) = null,
@idTicket int = null,
@IdUsuario int =null,
@idCarro int = null,
@idCliente int = null,
@Login varchar(32) = null,
@DataEntrada datetime = null,
@DataSaida datetime = null,
@Status int = null,
@Nome varchar(45) = null,
@Telefone varchar (14) = null
)
AS
-- 0 = ComboBox Tipo
	IF(@Flag = 0)
	BEGIN
		SELECT id_automovel, automovel from tb_automovel
	END
-- 1 = ComboBox Marca
	IF(@Flag = 1)
	BEGIN
		SELECT A.automovel[Tipo], M.marca [Marca] FROM tb_automovel as A INNER JOIN tb_marca as M ON A.id_automovel = M.automovel_id AND A.automovel =@Tipo
	END
-- 2 = Quantidade Ticket's Abertos
	IF(@Flag = 2)
	BEGIN
		SELECT COUNT(id_ticket)AS [Ticket's Abertos] FROM tb_ticket WHERE status=1
	END
-- 3 = Carregar Tela Encerrar Ticket
	IF(@Flag = 3)
	BEGIN
		SELECT Ticket.id_ticket[#Ticket], CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada] FROM tb_ticket AS Ticket  INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket AND Ticket.id_ticket=@idTicket
	END
-- 4 = Métodos de Pagamento
	IF(@Flag = 4)
	BEGIN
		SELECT id_pgt,descricao FROM tb_forma_pgt WHERE status=1
	END
-- 5 = Verificar se há algum ticket em Aberto para Determinado Veiculo
	IF(@Flag = 5)
	BEGIN
		SELECT COUNT(id_ticket) FROM tb_ticket AS Ticket INNER JOIN tb_carro AS Car ON Ticket.carro_id = Car.id_carro WHERE Ticket.status=1 AND Car.placa=@Placa AND Car.status=1
	END
-- 6 =  Ticket's Aberto Load Tela Pesquisa Ticket
	IF(@Flag = 6)
	BEGIN
		SELECT Ticket.id_ticket[#Ticket],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada],Usuario.login[Usuario Entrada],Car.placa[Placa],A.automovel[Tipo],M.marca[Marca],Cli.nome[Nome Cliente],Cli.telefone[Telefone] FROM tb_ticket AS Ticket INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket INNER JOIN tb_usuario AS Usuario ON Entrada.usuario_id = Usuario.id_usuario INNER JOIN tb_carro AS Car ON Car.id_carro = Ticket.carro_id INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_cliente AS Cli ON Cli.id_cliente = Ticket.cliente_id WHERE Ticket.status = 1
	END
-- 7 = Pesquisa Ticket Especifico P/ Tela Operação
	IF(@Flag = 7)
	BEGIN
		SELECT Ticket.id_ticket[#Ticket], A.automovel[Tipo],M.marca[Marca],Car.placa[Placa],Cli.nome[Nome Cliente], Cli.telefone[Telefone],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS [Data Entrada] FROM tb_ticket AS Ticket INNER JOIN tb_carro as Car ON Ticket.carro_id = Car.id_carro INNER JOIN tb_cliente AS Cli ON Ticket.cliente_id = Cli.id_cliente INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket WHERE Ticket.Status=1 AND Car.placa=@Placa  
	END
-- 8 = SELECT Identificação do estacionamento
	IF(@Flag = 8)
	BEGIN	
		SELECT cnpj[CNPJ], razao_social[Razão Social], endereco[Encereço],bairro[Bairro], numero[Número], cidade[Cidade],estado[Estado] , cep[CEP], inscricao_estadual[Inscrição Estadual], telefone[Telefone] FROM tb_estacionamento WHERE status=1
	END
-- 9 = SELECT de usuario
	IF(@Flag = 9)
    BEGIN
	   	SELECT id_usuario[ID], login[Login],nivel[Nivel],status[Status] FROM tb_usuario WHERE status=1
    END
-- 10 = SELECT Usuario Especifico
	IF(@Flag = 10)
	BEGIN
		SELECT id_usuario[ID], login[Login],nivel[Nivel],status[Status] FROM tb_usuario WHERE id_usuario = @IdUsuario
	END
-- 11 = SELECT Usuario pelo Login
	IF(@Flag = 11)
	BEGIN
		SELECT login[Login] FROM tb_usuario WHERE login=@Login
	END
-- 12 = SELECT Tela Desenvolvedor
	IF(@Flag = 12)
	BEGIN
		SELECT caminho_log[Caminho Log], porta_arduino[Porta Arduino],string_conn[String Conexão] FROM tb_estacionamento WHERE status =1
	END
-- 13 = Pesquisa informações d eum veiculo pela placa
	IF(@Flag = 13)
	BEGIN
		SELECT Car.placa[Placa], A.automovel[Tipo], M.marca FROM tb_carro AS Car INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca WHERE Car.placa = @Placa AND Car.status=1
	END
--14 = SELECT Parametros do Sistema
	IF(@Flag = 14)
	BEGIN
		SELECT valor_hr[Valor Hora],valor_min[Valor Minimo], valor_unico[Valor Unico], tolerancia[Tolerancia], caminho_log[Caminho Log] FROM tb_estacionamento WHERE status=1
	END
--15 = SELECT Tela de Cadastro Veiculos
	IF(@Flag = 15)
	BEGIN
		SELECT Car.id_carro [ID],Car.placa[Placa], A.automovel[Tipo], M.marca FROM tb_carro AS Car INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca WHERE Car.status=1
	END
--16 = SELECT VEICULO ESPECIFICO
	IF(@Flag = 16)
	BEGIN
		SELECT Car.id_carro [ID],Car.placa[Placa], A.automovel[Tipo], M.marca, Car.status[Status] FROM tb_carro AS Car INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca WHERE Car.id_carro = @idCarro
	END
--17 = SELECT TICKETS ABERTO PARA UM VEICULO
	IF(@Flag = 17)
	BEGIN
		SELECT Ticket.id_ticket FROM tb_ticket AS Ticket INNER JOIN tb_carro AS Car ON Ticket.carro_id = Car.id_carro WHERE Ticket.status=1 AND Car.id_carro=@idCarro AND Car.status=1
	END
-- 18 = SELECT Tela pesquisa 
	IF(@Flag = 18)
	BEGIN
		IF(@Status = 0)
		BEGIN
			IF(@idTicket =0)
			BEGIN
				SELECT Ticket.id_ticket[#Ticket],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada],UsuarioEntrada.login[UsuarioEntrada],Car.placa[Placa],A.automovel[Tipo],M.marca[Marca],Cli.nome[Nome Cliente],Cli.telefone[Telefone],CONVERT(varchar, Saida.hr_saida,8)[Hora Saida],CONVERT(varchar,Saida.data_saida,103)[Data Saida], Saida.permanencia[Permanência], Saida.total[Total], Saida.troco[Troco], Forma.descricao[Forma Pagamento], UsuarioSaida.login[Usuario Saida]  FROM tb_ticket AS Ticket INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket INNER JOIN tb_saida AS Saida ON Saida.entrada_id = Entrada.id_entrada INNER JOIN tb_usuario AS UsuarioSaida ON Saida.usuario_id = UsuarioSaida.id_usuario INNER JOIN tb_usuario AS UsuarioEntrada ON UsuarioEntrada.id_usuario = Entrada.usuario_id  INNER JOIN tb_carro AS Car ON Car.id_carro = Ticket.carro_id INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_cliente AS Cli ON Cli.id_cliente = Ticket.cliente_id INNER JOIN tb_forma_pgt AS Forma ON Saida.forma_pgt_id = Forma.id_pgt WHERE  Car.placa LIKE ISNULL(@Placa,'')+'%' AND Entrada.data_entrada >= @DataEntrada AND Saida.data_saida <= @DataSaida AND Ticket.status=@Status
			END
			ELSE
			BEGIN
				SELECT Ticket.id_ticket[#Ticket],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada],UsuarioEntrada.login[UsuarioEntrada],Car.placa[Placa],A.automovel[Tipo],M.marca[Marca],Cli.nome[Nome Cliente],Cli.telefone[Telefone],CONVERT(varchar, Saida.hr_saida,8)[Hora Saida],CONVERT(varchar,Saida.data_saida,103)[Data Saida], Saida.permanencia[Permanência], Saida.total[Total], Saida.troco[Troco], Forma.descricao[Forma Pagamento], UsuarioSaida.login[Usuario Saida]  FROM tb_ticket AS Ticket INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket INNER JOIN tb_saida AS Saida ON Saida.entrada_id = Entrada.id_entrada INNER JOIN tb_usuario AS UsuarioSaida ON Saida.usuario_id = UsuarioSaida.id_usuario INNER JOIN tb_usuario AS UsuarioEntrada ON UsuarioEntrada.id_usuario = Entrada.usuario_id  INNER JOIN tb_carro AS Car ON Car.id_carro = Ticket.carro_id INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_cliente AS Cli ON Cli.id_cliente = Ticket.cliente_id INNER JOIN tb_forma_pgt AS Forma ON Saida.forma_pgt_id = Forma.id_pgt WHERE  Car.placa LIKE ISNULL(@Placa,'')+'%' AND Entrada.data_entrada >= @DataEntrada AND Saida.data_saida <= @DataSaida AND Ticket.status=@Status AND Ticket.id_ticket LIKE @idTicket
			END
		END
		ELSE
		BEGIN
			IF(@idTicket=0)
			BEGIN
				SELECT Ticket.id_ticket[#Ticket],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada],Usuario.login[Usuario Entrada],Car.placa[Placa],A.automovel[Tipo],M.marca[Marca],Cli.nome[Nome Cliente],Cli.telefone[Telefone] FROM tb_ticket AS Ticket INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket INNER JOIN tb_usuario AS Usuario ON Entrada.usuario_id = Usuario.id_usuario INNER JOIN tb_carro AS Car ON Car.id_carro = Ticket.carro_id INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_cliente AS Cli ON Cli.id_cliente = Ticket.cliente_id WHERE Car.placa LIKE ISNULL(@Placa,'')+'%' AND Entrada.data_entrada >= @DataEntrada AND Ticket.status=@Status
			END
			ELSE
			BEGIN
				SELECT Ticket.id_ticket[#Ticket],CONVERT(varchar, Entrada.hr_entrada,8) AS [Hora Entrada],CONVERT(varchar,Entrada.data_entrada,103) AS[Data Entrada],Usuario.login[Usuario Entrada],Car.placa[Placa],A.automovel[Tipo],M.marca[Marca],Cli.nome[Nome Cliente],Cli.telefone[Telefone] FROM tb_ticket AS Ticket INNER JOIN tb_entrada AS Entrada ON Entrada.ticket_id = Ticket.id_ticket INNER JOIN tb_usuario AS Usuario ON Entrada.usuario_id = Usuario.id_usuario INNER JOIN tb_carro AS Car ON Car.id_carro = Ticket.carro_id INNER JOIN tb_automovel AS A ON Car.tipo_id = A.id_automovel INNER JOIN tb_marca AS M ON Car.marca_id = M.id_marca INNER JOIN tb_cliente AS Cli ON Cli.id_cliente = Ticket.cliente_id WHERE Car.placa LIKE ISNULL(@Placa,'')+'%' AND Entrada.data_entrada >= @DataEntrada AND Ticket.status=@Status AND Ticket.id_ticket LIKE @idTicket
			END
		END
	END
-- 19 = SELECT Cliente grid
	IF(@Flag = 19)
	BEGIN
		SELECT id_cliente[ID],nome[Nome],telefone[Telefone] FROM tb_cliente WHERE status=@Status AND id_cliente > 1
	END
-- 20 = SELECT Cliente 
	IF(@Flag = 20)
	BEGIN
		SELECT id_cliente[ID],nome[Nome],telefone[Telefone],status[Status] FROM tb_cliente WHERE id_cliente = @idCliente
	END
-- 21 = SELECT CLIENTE PELO NOME E TELEFONE
	IF(@Flag = 21)
	BEGIN
		SELECT id_cliente[ID] FROM tb_cliente WHERE nome = @Nome AND telefone = @Telefone
	END
-- 22 = SELECT QTD TICKET PELO CLIENTE
	IF(@Flag = 22)
	BEGIN
		SELECT COUNT(id_ticket) FROM tb_ticket AS Ticket INNER JOIN tb_cliente AS Cli ON Ticket.cliente_id = Cli.id_Cliente AND Ticket.status=1 AND Cli.id_cliente = @idCliente
	END
