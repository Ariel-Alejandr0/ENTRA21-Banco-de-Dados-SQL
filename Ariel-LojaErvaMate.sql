-- CRIANDO DATABASE
CREATE DATABASE Loja;
USE Loja;

CREATE USER 'admin'@'localhost'    IDENTIFIED BY 'adminloja123';
GRANT ALL PRIVILEGES ON Loja.* TO 'admin'@'localhost';-- CRIANDO PRIVILÉGIOS DO USUÁRIO

CREATE USER 'vendedor'@'localhost' IDENTIFIED BY 'vendedorloja123';

-- CRIANDO TABELAS 
CREATE TABLE Produtos (
	id_produto     INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto   VARCHAR(255),
    descricao      TEXT,
    preco_unitario DECIMAL(10, 2)
);

CREATE TABLE Entrada_Estoque (
	id_entrada     INT AUTO_INCREMENT PRIMARY KEY,
    id_produto     INT,
    quantidade     INT,
    data_entrada   DATE,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

CREATE TABLE Saida_Estoque (
	id_saida       INT AUTO_INCREMENT PRIMARY KEY,
    id_produto     INT,
    quantidade     INT,
    data_saida     DATE,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);  

CREATE TABLE Estoque_Minimo (
    id_estoque_minimo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_produto        INT NOT NULL,
    estoque_minimo    INT NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

GRANT INSERT, SELECT, UPDATE, DELETE  ON Loja.Produtos TO 'vendedor'@'localhost'; -- garante comando CRUD DML para o usuário vendedor na table Produtos

-- Tema: Loja de erva-mate

INSERT INTO Produtos (nome_produto, descricao, preco_unitario) 
VALUES 
("Cuia Mate in Box Clássica", "Cuia de chimarrão Mate in Box feito de inox", 80),
("Erva-mate Mate Guayrá 500g", "Moída Grossa | Orgânica & Agroflorestal | 500g", 20),
("Erva-mate Baita 1Kg", "Chimarrão, pacote a vácuo 1kg ", 18),
("Erva-mate Canarias 500g", "Erva mate tipo uruguaia , pacote 500g", 14),
("Trot’s Supreme FITX 500g", "Erva mate de Tererê extra grossa, pacote 500g", 20),
("Copo Termico de Cerveja", "Copo Termico 500ml Preto Black Sand Arell", 140),
("Copo Inox para Tereré Quadrado", "Copo Inox para Tereré Quadrado 200ml preto", 60),
("Bomba Mil Furos","Bomba Mil Furos, Bocal Banhado a Ouro, Desmontável", 100),
("Bomba Inox Chata com cano largo", "Bomba Inox Chata com cano largo para tereré 19cm", 23),
("Yerba mate Taragui", "Yerba mate Taragui padrão argentino 500g", 27);

SELECT * FROM Produtos;


 -- Entradas de estoque
INSERT INTO Entrada_Estoque (id_produto, quantidade, data_entrada) VALUES 
(10, 60, '2023-11-23'),(1, 5, '2023-11-22'),  (8, 5, '2023-11-22'),
(2, 30, '2023-11-23'), (3, 15, '2023-11-23'), (4, 60, '2023-11-23'), 
(5, 12, '2023-11-23'), (6, 5, '2023-11-23'),  (7, 5, '2023-11-23'), 
(9, 10, '2023-11-23'), (3, 15, '2023-11-15'), (3, 17, '2023-11-16'), 
(3, 4, '2023-11-17'),  (10, 6,'2023-11-15'),  (10, 25, '2023-11-16'), 
(5, 5,'2023-11-15'),   (5, 8, '2023-11-16'),  (5, 96, '2023-11-17'),
(2, 3,'2023-11-15'),   (2, 14, '2023-11-16'), (2, 4, '2023-11-17'),
(7, 1,'2023-11-15'),   (10, 6, '2023-11-16'), (10, 2, '2023-11-17'),
(10, 8, '2023-11-17');

SELECT * FROM Entrada_Estoque;

-- Saidas de estoque
INSERT INTO Saida_Estoque (id_produto, quantidade, data_saida) VALUES 
(1, 2, '2023-11-23'), (2, 15, '2023-11-23'),  (3, 4, '2023-11-23'), 
(4, 35, '2023-11-23'),(5, 6, '2023-11-23'),   (6, 2, '2023-11-23'), 
(7, 1, '2023-11-23'), (9, 3, '2023-11-23'),   (10, 31, '2023-11-23'),
(10, 3,'2023-11-15'), (10, 25, '2023-11-16'), (10, 4, '2023-11-17'),
(5, 5,'2023-11-15'),  (5, 4, '2023-11-16'),   (5, 96, '2023-11-17'),
(2, 1,'2023-11-15'),  (2, 14, '2023-11-16'),  (2, 2, '2023-11-17'),
(7, 1,'2023-11-15'),  (10, 3, '2023-11-16'),  (10, 2, '2023-11-17');


DELETE FROM Saida_Estoque WHERE id_saida > 21;

SELECT * FROM Saida_Estoque;
SELECT nome_produto FROM Produtos WHERE id_produto = 1;

-- insert estoque minimo

INSERT INTO Estoque_Minimo (estoque_minimo, id_produto) VALUES 
(17, 1), (18, 2),  (20, 3), (21, 4),(70, 5), 
(32, 6), (80, 7), (90, 8),   (91, 9), (92, 10);

-- SELECTs
SELECT * FROM Produtos WHERE nome_produto LIKE '%y%';

SELECT id_produto, SUM(quantidade) AS total_entradas 
FROM Entrada_Estoque GROUP BY id_produto; 

SELECT id_produto, SUM(quantidade) AS total_saidas 
FROM Saida_Estoque GROUP BY id_produto; 

-- SELECT COM JOINs
SELECT 
	tbProduto.id_produto,
    tbProduto.nome_produto,
    tbEntradas.total_entradas,
    tbSaidas.total_saidas,
    (tbEntradas.total_entradas) - COALESCE(tbSaidas.total_saidas, 0) AS saldo_atual
    FROM Produtos AS tbProduto
    INNER JOIN (SELECT id_produto, SUM(quantidade) AS total_entradas
		FROM Entrada_Estoque GROUP BY id_produto) tbEntradas
        ON tbProduto.id_produto = tbEntradas.id_produto
	LEFT JOIN (SELECT id_produto, SUM(quantidade) AS total_saidas
		FROM Saida_Estoque GROUP BY id_produto) tbSaidas
        ON tbProduto.id_produto = tbSaidas.id_produto;

-- Alterar a quantidade de uma entrada de estoque
UPDATE Entrada_Estoque SET quantidade = 20 WHERE id_entrada = 8;
 
-- updates de entrada
UPDATE Entrada_Estoque SET quantidade = 35 WHERE id_entrada = 4;
UPDATE Entrada_Estoque SET quantidade = 10 WHERE id_entrada = 7;
UPDATE Entrada_Estoque SET quantidade = 97 WHERE id_entrada = 19;

-- updates de saida
UPDATE Saida_Estoque SET quantidade = 16 WHERE id_saida = 3;
UPDATE Saida_Estoque SET quantidade = 38 WHERE id_saida = 10;
UPDATE Saida_Estoque SET quantidade = 17 WHERE id_saida = 13;

-- select de produtos com estoque abaixo do mínimo 

SELECT
    Produtos.id_produto,
    Produtos.nome_produto,
    Estoque_Minimo.estoque_minimo,
    (COALESCE(SUM(Entrada_Estoque.quantidade), 0) - COALESCE(SUM(Saida_Estoque.quantidade), 0)) AS saldo_atual
    FROM Produtos
    INNER JOIN Estoque_Minimo ON Produtos.id_produto = Estoque_Minimo.id_produto
    INNER JOIN Entrada_Estoque ON Produtos.id_produto = Entrada_Estoque.id_produto
    INNER JOIN Saida_Estoque ON Produtos.id_produto = Saida_Estoque.id_produto
    GROUP BY
        Produtos.id_produto, Produtos.nome_produto, Estoque_Minimo.estoque_minimo
    HAVING
        saldo_atual < Estoque_Minimo.estoque_minimo;
