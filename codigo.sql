-- Criação do banco de dados
CREATE DATABASE UNIDEV_teste;

-- Seleção do banco de dados
USE UNIDEV_teste;

-- Criação das tabelas
CREATE TABLE categoria_bolo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    categoria VARCHAR(50) NOT NULL UNIQUE,
    dias_validade INT NOT NULL
);

CREATE TABLE bolos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sabor VARCHAR(100) NOT NULL,
    id_categoria_bolo INT NOT NULL,
    estoque INT,
    preco DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_categoria_bolo) REFERENCES categoria_bolo(id)
);

CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_nascimento DATE
);

CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    forma_pagamento VARCHAR(50) NOT NULL
);

CREATE TABLE vendas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_pagamento INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    FOREIGN KEY (id_pagamento) REFERENCES pagamentos(id)
);

CREATE TABLE itens_venda (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT NOT NULL,
    id_bolo INT NOT NULL,
    quantidade INT,
    FOREIGN KEY (id_venda) REFERENCES vendas(id),
    FOREIGN KEY (id_bolo) REFERENCES bolos(id)
);


-- Inserindo valores nas tabelas
INSERT INTO categoria_bolo (categoria, dias_validade) VALUES
('Simples', 6),
('Confeitado', 2),
('Gourmet', 10),
('Pote', 30);

INSERT INTO bolos (sabor, id_categoria_bolo, estoque, preco) VALUES
('Bolo de Chocolate', 1, 20, 30.00),
('Bolo de Morango', 2, 15, 50.00),
('Bolo Red Velvet', 3, 10, 70.00),
('Bolo de Doce de Leite', 4, 25, 15.00);

INSERT INTO clientes (nome, telefone, data_nascimento) VALUES
('João Silva', '11987654321', '1990-05-12'),
('Maria Souza', '11991234567', '1985-08-22'),
('Carlos Mendes', '21976543210', '1992-11-30'),
('Ana Pereira', '31965432109', '1998-03-15'),
('Pedro Santos', '41912345678', '1975-07-01'),
('Lucas Oliveira', '51987654321', '2001-12-25'),
('Julia Costa', '61991234567', '1988-09-10'),
('Bruna Rocha', '71976543210', '1995-04-20');

INSERT INTO pagamentos (forma_pagamento)
VALUES
('dinheiro'),
('pix'),
('cartão de débito'),
('cartão de crédito');

INSERT INTO vendas (id_cliente, data_venda, id_pagamento, total) VALUES
(1, '2023-03-01 14:30:00', 1, 100.00),
(2, '2024-01-05 10:15:00', 2, 140.00),
(3, '2023-11-10 16:45:00', 3, 30.00),
(4, '2022-06-12 18:20:00', 4, 85.00),
(5, '2024-07-20 12:10:00', 1, 200.00),
(6, '2022-08-25 09:30:00', 3, 50.00),
(7, '2023-05-30 14:00:00', 2, 120.00),
(8, '2024-02-18 17:25:00', 4, 75.00);

INSERT INTO itens_venda (id_venda, id_bolo, quantidade) VALUES
    (1, 1, 2),
    (2, 2, 3),
    (3, 3, 1),
    (4, 4, 4),
    (5, 1, 1),
    (6, 2, 2),
    (7, 3, 1),
    (8, 4, 1);


-- Mostra a disposição de bolos em estoque
SELECT
    b.id,
    b.sabor,
    cb.categoria,
    b.estoque,
    b.preco
FROM bolos b
JOIN categoria_bolo cb ON b.id_categoria_bolo = cb.id;

-- Em quais meses ocorreram mais vendas
SELECT
    DATE_FORMAT(data_venda, '%Y-%m') AS mes,
    SUM(total) as total
FROM vendas
GROUP BY mes
ORDER BY total desc;

-- Quantas unidades ele vendeu em cada ano e quanto isso gerou de receita para ele
SELECT
    SUM(iv.quantidade) AS quantidade_vendida,
    DATE_FORMAT(v.data_venda, '%Y') AS ano,
    SUM(iv.quantidade * b.preco) AS total
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id
JOIN bolos b ON iv.id_bolo = b.id
GROUP BY ano
ORDER BY total DESC;

-- Quantas unidades ele vendeu em cada mês e quanto isso gerou de receita para ele
SELECT
    SUM(iv.quantidade) AS quantidade_vendida,
    DATE_FORMAT(v.data_venda, '%Y-%m') AS mes,
    SUM(iv.quantidade * b.preco) AS total
FROM itens_venda iv
JOIN vendas v ON iv.id_venda = v.id
JOIN bolos b ON iv.id_bolo = b.id
GROUP BY mes
ORDER BY total DESC;

-- Quais clientes mais compram (por valor gasto)
SELECT
    c.nome AS nome,
    SUM(v.total) as total
FROM clientes c
JOIN vendas v ON c.id = v.id_cliente
GROUP BY nome 
ORDER BY total DESC;

-- Quais clientes mais compraram na loja (por total de compras)
SELECT
    c.nome, 
    COUNT(*) AS vezes_compradas
FROM vendas v
JOIN clientes c ON v.id_cliente = c.id
GROUP BY c.nome
ORDER BY vezes_compradas DESC;

-- Quais formas de pagamento os clientes mais usam
SELECT 
    p.forma_pagamento,
    COUNT(*) AS total_uso
FROM vendas v
JOIN pagamentos p ON p.id = v.id_pagamento
GROUP BY p.forma_pagamento
ORDER BY total_uso DESC;
