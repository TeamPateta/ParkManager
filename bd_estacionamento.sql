CREATE DATABASE db_estacionamento
USE db_estacionamento
Set Language Portugu�s

CREATE TABLE tb_estacionamento(
    id INT PRIMARY KEY IDENTITY,
    valor_hr DECIMAL(10,2),
	tolerancia TIME(0),
	qtd_vagas INT NOT NULL,
	vagas_atuais INT NOT NULL,
	status SMALLINT NOT NULL
)

CREATE TABLE tb_cliente(
    id_cliente INT PRIMARY KEY IDENTITY,
	nome VARCHAR(80) not null,
	telefone VARCHAR(14),
	status SMALLINT NOT NULL
)

CREATE TABLE tb_automovel(
    id_automovel INT PRIMARY KEY NOT NULL,
	automovel VARCHAR(20) 
)

CREATE TABLE tb_marca(
    id_marca INT PRIMARY KEY IDENTITY NOT NULL,
	marca VARCHAR(25),
	id_automovel INT NOT NULL,
	FOREIGN KEY(id_automovel) REFERENCES tb_automovel
)

CREATE TABLE tb_carro(
    id_carro INT PRIMARY KEY IDENTITY,
	cliente_id INT NOT NULL,
	id_marca INT NOT NULL,
	placa VARCHAR(7) NOT NULL,
	status SMALLINT NOT NULL,
	FOREIGN KEY(cliente_id) REFERENCES tb_cliente,
	FOREIGN KEY (id_marca) REFERENCES tb_marca
)

CREATE TABLE tb_ticket(
   id_ticket INT PRIMARY KEY IDENTITY NOT NULL,
   carro_id INT,
   status SMALLINT NOT NULL
)

CREATE TABLE tb_usuario(
    id_usuario INT PRIMARY KEY IDENTITY,
    login VARCHAR(20) UNIQUE NOT NULL,
	senha VARCHAR(18) NOT NULL,
	nivel SMALLINT NOT NULL, --1 para cliente, 2 para funcionario, 3 para adm
	status SMALLINT NOT NULL
)

CREATE TABLE tb_entrada(
   id_entrada INT PRIMARY KEY IDENTITY,
   ticket_id INT NOT NULL,
   usuario_id INT NOT NULL,
   hr_entrada TIME(7) NOT NULL,
   data DATE,
   status SMALLINT NOT NULL,
   FOREIGN KEY (usuario_id) REFERENCES tb_usuario
)

CREATE TABLE tb_forma_pgt(
   id_pgt INT PRIMARY KEY IDENTITY,
   descricao VARCHAR(18),
   status SMALLINT
)

CREATE TABLE tb_saida(
   id_saida INT PRIMARY KEY IDENTITY NOT NULL,
   ticket_id INT NOT NULL,
   usuario_id INT NOT NULL,
   hr_saida TIME NOT NULL,
   data DATE NOT NULL,
   forma_pgt_id INT NOT NULL,
   total DECIMAL(10,2),
   status SMALLINT NOT NULL,
   FOREIGN KEY (ticket_id) REFERENCES tb_ticket,
   FOREIGN KEY (usuario_id) REFERENCES tb_usuario,
   FOREIGN KEY (forma_pgt_id) REFERENCES tb_forma_pgt
)

CREATE TABLE tb_fotos(
   id_fotos INT PRIMARY KEY,
   ticket_id INT,
   foto_caminho VARCHAR(100) UNIQUE
   FOREIGN KEY (ticket_id) REFERENCES tb_ticket
)

INSERT INTO tb_estacionamento (valor_hr,tolerancia, qtd_vagas, vagas_atuais, status) VALUES
('8', '00:15:00', '20', '0', '1');

INSERT INTO tb_cliente(nome,telefone,status) VALUES('Carlos','17981391754', 1);

INSERT INTO tb_automovel (id_automovel, automovel) VALUES
(1,'carro'),
(2,'moto'),
(3,'caminhonete'),
(4,'caminh�o'),
(5, 'carro e moto'),
(6, 'carro e caminhonete'),
(7, 'carro e caminh�o');

INSERT INTO tb_marca (marca, id_automovel) VALUES
('Audi', '1'),
('Avelloz', '2'),
('BMW', '5'),
('BRP', '2'),
('Bravax', '2'),
('Bull', '2'),
('CFMoto', '2'),
('Chevrolet', '6'),
('Citro�n', '1'),
('Dafra', '2'),
('DAF', '3'),
('Dayang', '2'),
('Dodge', '1'),
('Ducati', '2'),
('Ferrari', '1'),
('Fiat', '6'),
('Ford', '1'),
('Foton', '3'),
('Haojue', '2'),
('Harley-Davidson', '2'),
('Honda', '5'),
('Hyundai', '6'),
('Iros', '2'),
('Iveco', '6'),
('Jaguar', '1'),
('Jeep', '1'),
('KTM', '2'),
('Kawasaki', '2'),
('Kymco', '2'),
('Lamborghini', '1'),
('Land Rover', '1'),
('MAN', '3'),
('Maserati', '1'),
('McLaren', '1'),
('Mercedes-Benz', '7'),
('Mitsubishi', '1'),
('Motocar', '2'),
('Nissan', '1'),
('Peugeot', '1'),
('Porshe', '1'),
('RAM', '6'),
('Renault', '6'),
('Royal Enfield', '2'),
('Scania', '4'),
('Shineray', '2'),
('Sousa', '2'),
('Subaru', '1'),
('Suzuki', '5'),
('Toller', '1'),
('Toyota', '6'),
('Traxx', '2'),
('Triumph', '2'),
('Vespa', '2'),
('Volkswagen', '5'),
('Voltz', '2'),
('Volvo', '7'),
('Wuyang', '2'),
('Yamaha', '2');

INSERT INTO tb_carro(cliente_id,id_marca,placa,status) VALUES(1, 1, 'GOD3492', 1)

INSERT INTO tb_ticket(carro_id,status) VALUES(1,0)

INSERT INTO tb_usuario(login,senha,nivel,status) VALUES('teampateta', '0123', 3, 1)

INSERT INTO tb_entrada(ticket_id, usuario_id, hr_entrada, data, status) VALUES (1, 1, '12:00:00', '01-09-2021', 0)

INSERT INTO tb_forma_pgt (descricao,status) VALUES('PIX', 0)

INSERT INTO tb_saida (ticket_id, usuario_id, hr_saida, data, forma_pgt_id, total, status) VALUES (1, 1, '13:00:00', '01-09-2021', 1, 8, 0)

INSERT INTO tb_fotos (id_fotos, ticket_id, foto_caminho) VALUES (1, 1, 'C:\Program Files (x86)\Microsoft Visual Studio\fotos');
