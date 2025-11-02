-- Criação do banco de dados para o cenário de E-Commerce
-- drop database ecomerce;
CREATE DATABASE IF NOT EXISTS ecomerce;
USE ecomerce;

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Cliente VARCHAR(15),
    Nome_meio_inicial CHAR(1),
    Sobrenome VARCHAR(15),
    CPF_Cliente CHAR(11) UNIQUE,
    CNPJ_cliente CHAR(14) UNIQUE,
    Razao_Cliente VARCHAR(50),
    Nome_Fantasia_Cliente VARCHAR(100),
    Endereco_Cliente VARCHAR(255) not null,
    CONSTRAINT chk_Cliente_Tipo CHECK (
        (CPF_Cliente IS NOT NULL AND Nome_Cliente IS NOT NULL AND CNPJ_Cliente IS NULL AND Razao_Cliente IS NULL AND Nome_Fantasia_Cliente IS NULL)
        OR 
        (CPF_Cliente IS NULL AND Nome_Cliente IS NULL AND CNPJ_Cliente IS NOT NULL AND Razao_Cliente IS NOT NULL AND Nome_Fantasia_Cliente IS NOT NULL)
    )
);

-- Tabela Produto
CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Produto VARCHAR(50) NOT NULL,
    ProdutoDescrição varchar(255),
    Categoria ENUM('eletrônico', 'alimentos', 'brinquedos', 'vestimenta') NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    Avaliação FLOAT DEFAULT 0,
    Dimensões VARCHAR(10),
    Peso VARCHAR(10)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idPedidoCliente INT,
    Status_Pedido ENUM('Em andamento', 'Processando', 'Enviado', 'Entregue'),
    PedidoDescrição VARCHAR(255),
    Valor_Frete FLOAT DEFAULT 10,
    Codigo_Rastreio VARCHAR(50),
    CONSTRAINT fk_Pedido_Cliente FOREIGN KEY (idPedidoCliente)
        REFERENCES Cliente (idCliente)
);

-- Tabela Pagamento
CREATE TABLE Pagamento(
    idPagamentoPedido INT,
    idPagamento INT PRIMARY KEY,
    Forma_Pagamento ENUM('Parcelado', 'Crédito', 'Débito', 'A_vista') NOT NULL DEFAULT 'A_vista',
    Debitado_Pagamento BOOLEAN NOT NULL DEFAULT FALSE,
    Valor_Pagamento DECIMAL(10,2),
    CONSTRAINT pk_Pagamento_Pedido FOREIGN KEY (idPagamentoPedido)
        REFERENCES Pedido (idPedido)
);

-- Tabela Estoque
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Endereço_Estoque VARCHAR(255),
    Quantidade_Estoque INT DEFAULT 0
);

-- Tabela Fornecedor 
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Razão_Fornecedor VARCHAR(100) not null,
    CNPJ_Fornecedor CHAR(14) NOT NULL UNIQUE,
    Contato_Fornecedor CHAR(11) NOT NULL
);

-- Tabela Vendedor
CREATE TABLE Vendedor (
    idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    Nome_Vendedor VARCHAR(50),
    CPF_Vendedor CHAR(11) UNIQUE,
    CNPJ_Vendedor CHAR(14) UNIQUE,
    Razao_Vendedor VARCHAR(50),
    Nome_Fantasia_Vendedor VARCHAR(100),
    Endereco_Vendedor VARCHAR(255) NOT NULL,
    Contato CHAR(11) NOT NULL,
    CONSTRAINT chk_Vendedor_Tipo CHECK (
        (CPF_Vendedor IS NOT NULL AND Nome_Vendedor IS NOT NULL AND CNPJ_Vendedor IS NULL AND Razao_Vendedor IS NULL AND Nome_Fantasia_Vendedor IS NULL)
        OR 
        (CPF_Vendedor IS NULL AND Nome_Vendedor IS NULL AND CNPJ_Vendedor IS NOT NULL AND Razao_Vendedor IS NOT NULL AND Nome_Fantasia_Vendedor IS NOT NULL)
    )
);

-- Tabela Vendedor dos produtos
CREATE TABLE Vendedor_produtos(
    idVendedorProduto INT,
    idProduto INT,
    Quantidade INT DEFAULT 1,
    CHECK (Quantidade > 0),
    PRIMARY KEY (idVendedorProduto , idProduto),
    CONSTRAINT fk_Vendedor_Produto FOREIGN KEY (idVendedorProduto)
        REFERENCES Vendedor (idVendedor),
    CONSTRAINT fk_Produto_Venda FOREIGN KEY (idProduto)
        REFERENCES Produto (idProduto)
);

-- Tabela Estoque dos produtos 
CREATE TABLE Estoque_de_produtos (
    idEstoqueProduto INT,
    idProduto INT,
    Quantidade INT DEFAULT 1,
    CHECK (Quantidade > 0),
    PRIMARY KEY (idEstoqueProduto , idProduto),
    CONSTRAINT fk_Estoque_Produto FOREIGN KEY (idEstoqueProduto)
        REFERENCES Estoque (idEstoque),
    CONSTRAINT fk_Produto_Estocado FOREIGN KEY (idProduto)
        REFERENCES Produto (idProduto)
);

-- Tabela Fornecedor dos produtos
CREATE TABLE Fornecedor_produto (
    idFornecedorProduto INT,
    idProduto INT,
    Quantidade INT DEFAULT 1,
    CHECK (Quantidade > 0),
    PRIMARY KEY (idFornecedorProduto , idProduto),
    CONSTRAINT fk_Fornecedor_Produto FOREIGN KEY (idFornecedorProduto)
        REFERENCES Fornecedor (idFornecedor),
    CONSTRAINT fk_Produto_Fornecido FOREIGN KEY (idProduto)
        REFERENCES Produto (idProduto)
);

-- Tabela produtos do pedido
CREATE TABLE Produto_do_pedido (
    idPedidoProduto INT,
    idProduto INT,
    Quantidade INT DEFAULT 1,
    Disponibilidade ENUM('Disponivel', 'Sem estoque') DEFAULT 'Sem estoque',
    PRIMARY KEY (idPedidoProduto , idProduto),
    CONSTRAINT fk_Pedido_Produto FOREIGN KEY (idPedidoProduto)
        REFERENCES Pedido (idPedido),
    CONSTRAINT fk_Produto_Requisitado FOREIGN KEY (idProduto)
        REFERENCES Produto (idProduto)
);

INSERT INTO Cliente (Nome_Cliente, Nome_meio_inicial, Sobrenome, CPF_Cliente, CNPJ_cliente, Razao_Cliente, Nome_Fantasia_Cliente, Endereco_Cliente) VALUES
(NULL, NULL, NULL, NULL, '20514938000137', 'Pastor', 'e Filhos', 'Largo Mendes, 31 Jardim Leblon 45250-736 Silveira / RJ'),
('Nina', 'C', 'Aragão', '75068491276', NULL, NULL, NULL, 'Alameda da Cruz Renascença 64196-870 Pimenta / RR'),
(NULL, NULL, NULL, NULL, '52680179000179', 'Aparecida Ltda.', 'Ltda.', 'Residencial Luiz Otávio Casa Grande, 61 Vila Do Pombal 12136072 da Cunha dos Dourados / AL'),
('Daniela', 'O', 'Gomes', '17249638564', NULL, NULL, NULL, 'Morro Lorenzo da Rosa, 51 Ipe 83428094 Nogueira / MS'),
(NULL, NULL, NULL, NULL, '65872104000131', 'Siqueira', 'S/A', 'Área Yuri Moura Lorena 54352-037 da Costa do Sul / RJ'),
('Gabriela', 'Y', 'da Cruz', '28031569703', NULL, NULL, NULL, 'Área de da Rosa, 30 Vila Satélite 72487493 Carvalho dos Dourados / SE'),
(NULL, NULL, NULL, NULL, '80371642000136', 'da Paz', 'S.A.', 'Condomínio de Nascimento, 984 Ermelinda 19118604 Cunha de Araújo / RN'),
('Igor', 'Y', 'Moura', '21096837595', NULL, NULL, NULL, 'Loteamento de Jesus, 45 Castanheira 77971187 da Cunha de Viana / MT'),
(NULL, NULL, NULL, NULL, '05394871000150', 'Ramos Montenegro S.A.', 'S/A', 'Via Moreira, 67 Grota 24042678 Brito / PA'),
('Valentina', 'O', 'Câmara', '30712496599', NULL, NULL, NULL, 'Praça de Lima, 83 Alpes 05377284 Melo da Praia / MT');

INSERT INTO Produto (Nome_Produto, Categoria, Valor, Avaliação, Dimensões, Peso) VALUES
('Produto1', 'eletrônico', 442.91, 3.0, '40x29', '5kg'),
('Produto2', 'alimentos', 369.15, 1.4, '41x30', '4kg'),
('Produto3', 'brinquedos', 226.85, 1.3, '43x47', '6kg'),
('Produto4', 'alimentos', 519.86, 3.4, '34x23', '9kg'),
('Produto5', 'vestimenta', 381.61, 2.3, '37x38', '1kg'),
('Produto6', 'vestimenta', 564.71, 1.6, '11x22', '8kg'),
('Produto7', 'brinquedos', 264.58, 4.4, '28x34', '5kg'),
('Produto8', 'alimentos', 90.23, 3.0, '46x35', '7kg'),
('Produto9', 'alimentos', 562.17, 3.8, '24x50', '4kg'),
('Produto10', 'eletrônico', 290.43, 3.3, '44x31', '9kg');

INSERT INTO Pedido (idPedidoCliente, Status_Pedido, PedidoDescrição, Valor_Frete, Codigo_Rastreio) VALUES
(3, 'Em andamento', 'Pedido de teste 1', 8.04, 'RSTRC00001'),
(7, 'Em andamento', 'Pedido de teste 2', 36.57, 'RSTRC00002'),
(2, 'Entregue', 'Pedido de teste 3', 7.88, 'RSTRC00003'),
(2, 'Processando', 'Pedido de teste 4', 8.98, 'RSTRC00004'),
(3, 'Enviado', 'Pedido de teste 5', 11.92, 'RSTRC00005'),
(8, 'Entregue', 'Pedido de teste 6', 22.79, 'RSTRC00006'),
(5, 'Enviado', 'Pedido de teste 7', 6.09, 'RSTRC00007'),
(8, 'Entregue', 'Pedido de teste 8', 39.87, 'RSTRC00008'),
(10, 'Enviado', 'Pedido de teste 9', 41.73, 'RSTRC00009'),
(7, 'Enviado', 'Pedido de teste 10', 36.71, 'RSTRC00010');

INSERT INTO Pagamento (idPagamentoPedido, idPagamento, Forma_Pagamento, Debitado_Pagamento, Valor_Pagamento) VALUES
(1, 1, 'Parcelado', TRUE, 826.45),
(2, 2, 'Crédito', TRUE, 411.19),
(3, 3, 'Débito', FALSE, 939.65),
(4, 4, 'Débito', TRUE, 731.31),
(5, 5, 'Débito', FALSE, 384.25),
(6, 6, 'A_vista', FALSE, 420.66),
(7, 7, 'Débito', FALSE, 1301.75),
(8, 8, 'Débito', TRUE, 546.79),
(9, 9, 'Débito', FALSE, 1115.03),
(10, 10, 'Débito', TRUE, 319.20);

INSERT INTO Estoque (Endereço_Estoque, Quantidade_Estoque) VALUES
('Quadra Henry Gabriel Rios, 97 Vila Jardim Montanhes 34729490 Machado / PE', 65),
('Parque Elisa Fogaça Nazare 89294-652 da Cruz / PA', 79),
('Rua Yan Pimenta, 51 Vila Madre Gertrudes 2ª Seção 01663915 Sá do Sul / MS', 57),
('Lago de Novais, 5 Vitoria 66576016 Pires do Oeste / SC', 51),
('Colônia de Albuquerque, 8 Miramar 37770993 Nogueira de Castro / GO', 72),
('Passarela Ramos, 256 Sagrada Família 24134844 Almeida / MA', 34),
('Distrito Renan da Cunha, 95 Novo Tupi 88409-147 Caldeira das Flores / MT', 51),
('Colônia Azevedo Vila Madre Gertrudes 4ª Seção 70857-487 Freitas / GO', 35),
('Via de Costa, 8 Vila União 21630-408 das Neves do Campo / AL', 64),
('Campo Gael Henrique Sampaio, 42 São Francisco 70328509 Nunes / SP', 21);

INSERT INTO Fornecedor (Razão_Fornecedor, CNPJ_Fornecedor, Contato_Fornecedor) VALUES
('Lima', '24518670000162', '55219417707'),
('Silveira', '76019348000192', '55419887990'),
('Fonseca', '46570819000195', '55819920370'),
('Teixeira e Filhos', '96487035000176', '55119219360'),
('da Luz', '45039862000166', '55119538865'),
('Nunes S/A', '70148592000179', '55219858121'),
('Silveira', '24698710000103', '55619687992'),
('Freitas', '30458192000145', '55319390345'),
('Dias - EI', '30719586000100', '55819116739'),
('Novais S.A.', '31820564000102', '55519313693');

INSERT INTO Vendedor (Nome_Vendedor, CPF_Vendedor, CNPJ_Vendedor, Razao_Vendedor, Nome_Fantasia_Vendedor, Endereco_Vendedor, Contato) VALUES
(NULL, NULL, '71365248000102', 'Moura Guerra - EI', '- EI', 'Favela Maria Helena Caldeira, 988 Petropolis 32417494 da Costa da Serra / MG', '55619930593'),
('Antony', '58943760175', NULL, NULL, NULL, 'Vila Sarah Siqueira Vila Mangueiras 41709-597 Souza de Minas / AP', '55619715988'),
(NULL, NULL, '34106825000107', 'Campos', '- ME', 'Alameda Beatriz Pires Santa Sofia 18536357 Lopes / AP', '55619726900'),
('Anthony', '76598421020', NULL, NULL, NULL, 'Aeroporto de Abreu, 3 Pilar 82410-373 Freitas do Oeste / SE', '55319961376'),
(NULL, NULL, '68543792000184', 'Ramos Ltda.', '- ME', 'Ladeira Isadora Teixeira, 88 Centro 43577-616 Lima das Flores / PR', '55619133244'),
('Luiz Henrique', '50934687110', NULL, NULL, NULL, 'Ladeira Campos Novo Tupi 89906190 da Paz do Campo / TO', '55319106555'),
(NULL, NULL, '81672903000110', 'Lopes', '- ME', 'Chácara de Pacheco, 749 Brasil Industrial 75098596 Ramos / PA', '55819268766'),
('Pedro Lucas', '62459178085', NULL, NULL, NULL, 'Pátio Isaque Pereira Alta Tensão 2ª Seção 56223-948 Farias da Serra / SE', '55119482241'),
(NULL, NULL, '12469503000190', 'Nunes da Cruz - ME', 'S.A.', 'Distrito Costa, 858 Jardim São José 60618-080 Teixeira / ES', '55819346778'),
('Mariane', '56417893057', NULL, NULL, NULL, 'Estação Gabriela Garcia Céu Azul 98551-373 Peixoto / AL', '55719643686');

INSERT INTO Vendedor_produtos (idVendedorProduto, idProduto, Quantidade) VALUES
(6, 4, 14),
(2, 3, 13),
(1, 1, 12),
(5, 9, 12),
(9, 9, 5),
(8, 3, 14),
(2, 2, 9),
(6, 6, 13),
(6, 7, 19),
(4, 7, 7);

INSERT INTO Estoque_de_produtos (idEstoqueProduto, idProduto, Quantidade) VALUES
(4, 7, 47),
(6, 4, 32),
(3, 1, 49),
(10, 3, 27),
(1, 7, 40),
(7, 10, 11),
(3, 2, 11),
(1, 5, 35),
(8, 7, 2),
(2, 1, 24);

INSERT INTO Fornecedor_produto (idFornecedorProduto, idProduto, Quantidade) VALUES
(8, 4, 4),
(6, 10, 23),
(6, 6, 23),
(8, 9, 28),
(6, 5, 28),
(3, 2, 18),
(10, 3, 21),
(9, 9, 11),
(7, 10, 28),
(3, 8, 17);

INSERT INTO Produto_do_pedido (idPedidoProduto, idProduto, Quantidade, Disponibilidade) VALUES
(10, 8, 4, 'Disponivel'),
(10, 1, 1, 'Disponivel'),
(7, 8, 2, 'Disponivel'),
(2, 6, 5, 'Disponivel'),
(2, 2, 3, 'Disponivel'),
(4, 2, 2, 'Sem estoque'),
(9, 10, 1, 'Sem estoque'),
(4, 7, 4, 'Sem estoque'),
(2, 5, 2, 'Disponivel'),
(3, 1, 1, 'Disponivel');

Select * from produto;

-- buscar quais produtos possem avaliação maior que 3,5
Select * from produto p where p.avaliação > 3.5;

-- buscar quais pagamentos já foram feitos e feitos via cartão
SELECT * FROM Pagamento
	WHERE Debitado_Pagamento = TRUE
	AND Forma_Pagamento IN ('Crédito', 'Débito')
ORDER BY Valor_Pagamento DESC;


select * from Produto_do_pedido;

-- buscar clientes com pedidos realizados
select * from cliente c inner join pedido p on c.idCliente = p.idPedidoCliente
						inner join Produto_do_pedido pp on p.idPedido = pp.idPedidoProduto;

-- buscar quais pedidos já estão pagos
SELECT c.Nome_Cliente, c.Razao_Cliente, p.Nome_Produto, pp.Quantidade, pe.Valor_Frete, pg.Valor_Pagamento FROM Pedido pe
	JOIN Cliente c ON pe.idPedidoCliente = c.idCliente
	JOIN Produto_do_pedido pp ON pe.idPedido = pp.idPedidoProduto
	JOIN Produto p ON pp.idProduto = p.idProduto
	JOIN Pagamento pg ON pe.idPedido = pg.idPagamentoPedido
WHERE pg.Debitado_Pagamento = TRUE;
    
-- buscar quais pedidos ainda não foram pagos
SELECT c.Nome_Cliente, c.Razao_Cliente, p.Nome_Produto, pp.Quantidade, pe.Valor_Frete, pg.Valor_Pagamento FROM Pedido pe
	JOIN Cliente c ON pe.idPedidoCliente = c.idCliente
	JOIN Produto_do_pedido pp ON pe.idPedido = pp.idPedidoProduto
	JOIN Produto p ON pp.idProduto = p.idProduto
	JOIN Pagamento pg ON pe.idPedido = pg.idPagamentoPedido
WHERE pg.Debitado_Pagamento = FALSE;
  
-- buscar quais estoques possuem mais de 10 unidades de um produto
SELECT p.Nome_Produto, p.Valor, ep.Quantidade, e.Endereço_Estoque FROM Estoque_de_produtos ep
	JOIN Produto p ON ep.idProduto = p.idProduto
	JOIN Estoque e ON ep.idEstoqueProduto = e.idEstoque
WHERE ep.Quantidade > 10
order by ep.Quantidade;

-- buscar qual foi o produto mais vendido por terceiros e o valor total vendido
SELECT p.Nome_Produto, p.Categoria, p.Avaliação, SUM(vp.Quantidade * p.Valor) AS Valor_Total_Vendido FROM Vendedor_produtos vp
	JOIN Produto p ON vp.idProduto = p.idProduto
GROUP BY vp.idProduto
ORDER BY Valor_Total_Vendido DESC LIMIT 1;

SELECT p.Nome_Produto, p.Categoria, p.Avaliação, SUM(vp.Quantidade * p.Valor) AS Valor_Total_Vendido FROM Vendedor_produtos vp
	JOIN Produto p ON vp.idProduto = p.idProduto
GROUP BY vp.idProduto
ORDER BY Valor_Total_Vendido DESC LIMIT 3;

-- buscar produtos vendidos por terceiros com quantidade maior que 20
SELECT p.Nome_Produto, p.Categoria, SUM(vp.Quantidade) AS Total_Vendido FROM Vendedor_produtos vp
	JOIN Produto p ON vp.idProduto = p.idProduto
GROUP BY vp.idProduto
HAVING SUM(vp.Quantidade) > 20;

-- buscar o ranking de categorias mais pedidas
SELECT p.Categoria, SUM(pp.Quantidade) AS Total_Unidades_Pedidas FROM Produto_do_pedido pp
	JOIN Produto p ON pp.idProduto = p.idProduto
GROUP BY p.Categoria
HAVING SUM(pp.Quantidade) > 0
ORDER BY Total_Unidades_Pedidas DESC;