USE Orders;

-- Esta tabela armazena informações dos pedidos, como ID, data do pedido, total do pedido e o ID do cliente associado ao pedido.
CREATE TABLE orders (
  id INT auto_increment PRIMARY KEY,
  order_date DATETIME NOT NULL,
  order_total FLOAT NOT NULL,
  customer_id INT
);

-- Esta tabela armazena os tipos de itens disponíveis.
CREATE TABLE item_type_enum (
  id INT auto_increment PRIMARY KEY,
  type_name VARCHAR(100) NOT NULL
);

-- Esta tabela armazena informações dos itens, como ID, ID do tipo de item, nome e preço.
CREATE TABLE itens (
  id INT auto_increment PRIMARY KEY,
  item_name VARCHAR(100) NOT NULL,
  item_price FLOAT NOT NULL,
  item_description VARCHAR(256),
  item_img_url VARCHAR(256),
  item_type_id INT NOT NULL,
  FOREIGN KEY (item_type_id) REFERENCES item_type_enum(id)
);

-- Esta tabela relaciona os itens de um pedido específico, registrando o ID do pedido, o ID do item, a quantidade do item no pedido e um ID exclusivo para o relacionamento.
CREATE TABLE order_item (
  id INT auto_increment PRIMARY KEY,
  order_id INT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  item_id INT NOT NULL,
  FOREIGN KEY (item_id) REFERENCES itens(id),
  order_item_qtd INT NOT NULL
);

-- Definindo a codificação de caracteres para UTF-8
SET character_set_client = utf8;
SET character_set_connection = utf8;
SET character_set_results = utf8;
SET collation_connection = utf8_general_ci;


-- CADASTRANDO OS TIPOS DE ITENS - Bebida, Lanche, Acompanhamento, Sombremesa
INSERT INTO item_type_enum (type_name) VALUES ('Bebida');
INSERT INTO item_type_enum (type_name) VALUES ('Lanche');
INSERT INTO item_type_enum (type_name) VALUES ('Acompanhamento');
INSERT INTO item_type_enum (type_name) VALUES ('Sobremesa');

-- CADASTRANDO UM ITEM DE CADA CATEGORIA
INSERT INTO itens (item_type_id, item_name, item_description, item_img_url, item_price) VALUES (1, 'Coca-cola', 'Refrigerante sabor cola', 'https://www.shutterstock.com/pt/image-vector/novi-sad-serbia-january-21-2018-1008479416', 5.90);
INSERT INTO itens (item_type_id, item_name, item_description, item_img_url, item_price) VALUES (2, 'X-Tudo', 'Pão, Hamburguer e salada', 'https://www.shutterstock.com/pt/image-vector/3d-rendering-delicious-cheese-burger-2168020455', 16.90);
INSERT INTO itens (item_type_id, item_name, item_description, item_img_url, item_price) VALUES (3, 'Batata-Frita', 'Batata-frita 200gms', 'https://www.shutterstock.com/pt/image-photo/french-fries-510881971', 9.90);
INSERT INTO itens (item_type_id, item_name, item_description, item_img_url, item_price) VALUES (4, 'Sorvete de Morango', 'Delicioso sorvete de morango', 'https://www.shutterstock.com/pt/image-photo/ice-cream-cone-vanilla-strawberry-flavors-645817927', 2.90);

-- CADASTRANDO UM PEDIDO COM A DATA ATUAL PARA O PRIMEIRO CLIENTE
INSERT INTO orders (order_date, order_total, customer_id) VALUES (NOW(), 35.60, 1);

-- CADASTRANDO UM ITEM DE CADA CATEGORIA AO PEDIDO
INSERT INTO order_item (order_id, item_id, order_item_qtd) VALUES (1, 1, 1);
INSERT INTO order_item (order_id, item_id, order_item_qtd) VALUES (1, 2, 1);
INSERT INTO order_item (order_id, item_id, order_item_qtd) VALUES (1, 3, 1);
INSERT INTO order_item (order_id, item_id, order_item_qtd) VALUES (1, 4, 1);