-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           5.7.21-log - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Copiando estrutura para tabela mm.acesso
CREATE TABLE IF NOT EXISTS `acesso` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modulo_id` int(11) NOT NULL,
  `funcionario_id` int(11) NOT NULL,
  `nivel_acesso` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_acesso_funcionario1_idx` (`funcionario_id`),
  KEY `fk_acesso_modulo1` (`modulo_id`),
  CONSTRAINT `fk_acesso_funcionario1` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_acesso_modulo1` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.acesso: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `acesso` DISABLE KEYS */;
INSERT INTO `acesso` (`id`, `modulo_id`, `funcionario_id`, `nivel_acesso`) VALUES
	(2, 1, 1, '');
/*!40000 ALTER TABLE `acesso` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.caixa
CREATE TABLE IF NOT EXISTS `caixa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `valor_inicial` double(7,2) DEFAULT '0.00',
  `valor_fechamento` double(7,2) DEFAULT '0.00',
  `funcionario_id` int(11) NOT NULL DEFAULT '0',
  `dt_abertura` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dt_fechamento` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_caixa_funcionario` (`funcionario_id`),
  CONSTRAINT `FK_caixa_funcionario` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.caixa: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `caixa` DISABLE KEYS */;
INSERT INTO `caixa` (`id`, `valor_inicial`, `valor_fechamento`, `funcionario_id`, `dt_abertura`, `dt_fechamento`) VALUES
	(33, 0.00, 0.00, 1, '2017-11-23 21:02:43', '2017-12-02 19:30:08'),
	(34, 123.00, 0.00, 1, '2017-12-02 16:30:15', '2017-12-02 21:37:30'),
	(35, 145.69, NULL, 1, '2017-12-02 18:37:41', '2018-02-11 17:35:03');
/*!40000 ALTER TABLE `caixa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.categoria
CREATE TABLE IF NOT EXISTS `categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL COMMENT 'label',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.categoria: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` (`id`, `nome`) VALUES
	(2, 'Teste'),
	(3, 'Outra'),
	(4, 'Pizza'),
	(5, 'Bebida');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.comanda_mesa
CREATE TABLE IF NOT EXISTS `comanda_mesa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  `status` enum('L','O','P') NOT NULL DEFAULT 'L',
  `dt_status_O` timestamp NULL DEFAULT NULL,
  `dt_status_L` timestamp NULL DEFAULT NULL,
  `venda_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.comanda_mesa: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `comanda_mesa` DISABLE KEYS */;
INSERT INTO `comanda_mesa` (`id`, `codigo`, `active`, `status`, `dt_status_O`, `dt_status_L`, `venda_id`) VALUES
	(3, '01', 'y', 'L', '2018-02-11 13:09:51', NULL, NULL),
	(4, '02', 'y', 'L', '2018-02-11 14:33:27', NULL, NULL),
	(5, '03', 'y', 'L', NULL, NULL, NULL),
	(6, '04', 'y', 'L', NULL, NULL, NULL);
/*!40000 ALTER TABLE `comanda_mesa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.config
CREATE TABLE IF NOT EXISTS `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome_empresa` varchar(50) DEFAULT NULL,
  `desc_cupom` varchar(250) DEFAULT NULL,
  `print_port` varchar(30) DEFAULT NULL,
  `valor_entregador_delivery` decimal(10,2) DEFAULT NULL,
  `pizza_tamanho_min` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.config: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` (`id`, `nome_empresa`, `desc_cupom`, `print_port`, `valor_entregador_delivery`, `pizza_tamanho_min`) VALUES
	(1, 'JJ - armarinho - Bazar e Variedades', NULL, NULL, NULL, 0.50);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.delivery
CREATE TABLE IF NOT EXISTS `delivery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venda_id` int(11) NOT NULL,
  `dt_register` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dt_saida` timestamp NULL DEFAULT NULL,
  `status` enum('E','A','T','C','P','X') COLLATE latin1_general_ci NOT NULL DEFAULT 'E' COMMENT 'E = Esperando, A = Aguardado Entregador, T = Transporte, C = Concluido, P = Pago',
  `forma` enum('M','D') COLLATE latin1_general_ci NOT NULL COMMENT 'M = Maquininha, D = Dinheiro',
  `troco` decimal(10,2) DEFAULT NULL,
  `detalhes` text COLLATE latin1_general_ci,
  `ent_1` int(11) DEFAULT NULL,
  `ent_2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__venda` (`venda_id`),
  CONSTRAINT `FK__venda` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- Copiando dados para a tabela mm.delivery: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` (`id`, `venda_id`, `dt_register`, `dt_saida`, `status`, `forma`, `troco`, `detalhes`, `ent_1`, `ent_2`) VALUES
	(1, 222, '2017-12-01 23:55:59', NULL, 'A', 'M', NULL, NULL, NULL, NULL),
	(2, 228, '2017-12-02 18:27:47', NULL, 'A', 'D', 10.60, NULL, NULL, NULL);
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.entrada_produto
CREATE TABLE IF NOT EXISTS `entrada_produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` enum('E','S') NOT NULL DEFAULT 'E' COMMENT 'E=Entrada, S=Saida',
  `produto_id` int(11) NOT NULL,
  `fornecedor_id` int(11) DEFAULT NULL,
  `quantidade` decimal(10,0) NOT NULL,
  `lote` varchar(45) DEFAULT NULL,
  `dt_compra` date DEFAULT NULL,
  `dt_validade` date DEFAULT NULL,
  `valor_unitario` decimal(7,2) DEFAULT NULL,
  `valor_total` decimal(7,2) DEFAULT NULL,
  `motivo_saida` text,
  `dt_lancamento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_entrada_produto_produto1_idx` (`produto_id`),
  KEY `fk_entrada_produto_pessoa1_idx` (`fornecedor_id`),
  CONSTRAINT `fk_entrada_produto_pessoa1` FOREIGN KEY (`fornecedor_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_entrada_produto_produto1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.entrada_produto: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `entrada_produto` DISABLE KEYS */;
/*!40000 ALTER TABLE `entrada_produto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.fisica
CREATE TABLE IF NOT EXISTS `fisica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pessoa_id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL COMMENT 'label',
  `telefone` varchar(50) NOT NULL,
  `cpf` varchar(20) DEFAULT NULL,
  `CEP` varchar(10) DEFAULT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `endereco` text,
  `complemento` varchar(255) DEFAULT NULL,
  `observacao` text,
  `rg` varchar(20) DEFAULT NULL,
  `dt_nascimento` date DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL COMMENT 'SEXO:\nH=HOMEM\nM=MULHER\n',
  `tem_conta` enum('y','n') DEFAULT 'y',
  `dia_mes_pagto` int(11) DEFAULT NULL,
  `limite_conta` double(7,2) DEFAULT NULL,
  `dt_cadastro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pessoa_id_UNIQUE` (`pessoa_id`),
  UNIQUE KEY `telefone` (`telefone`),
  UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  KEY `fk_fisica_pessoa2_idx` (`pessoa_id`),
  CONSTRAINT `fk_fisica_pessoa2` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.fisica: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `fisica` DISABLE KEYS */;
INSERT INTO `fisica` (`id`, `pessoa_id`, `nome`, `telefone`, `cpf`, `CEP`, `numero`, `endereco`, `complemento`, `observacao`, `rg`, `dt_nascimento`, `sexo`, `tem_conta`, `dia_mes_pagto`, `limite_conta`, `dt_cadastro`) VALUES
	(1, 144, 'Ulisses', '(12) 32323-2323', '301.625.408-50', '08485050', '12', 'Rua Estrelizia, Conjunto Habitacional Santa Etelvina II, São Paulo, SP', NULL, NULL, NULL, NULL, 'H', 'y', NULL, 20.00, '2017-11-28 08:20:40'),
	(2, 134, 'Fulano', '(11) 11111-1111', NULL, '08485060', '11', 'Rua Pau Formiga, Conjunto Habitacional Santa Etelvina II, São Paulo, SP', 'Perto do posto', 'Troco 30,', NULL, NULL, NULL, 'y', NULL, NULL, '2017-11-28 08:20:40'),
	(9, 141, 'Ricardo', '(11) 97475-8181', NULL, '08563780', '750', 'Rua Coronel Benedito de Almeida, de 451/452 ao fim, Vila Gonçalves, Poá, SP', NULL, NULL, NULL, NULL, NULL, 'y', NULL, NULL, '2017-11-28 08:23:31'),
	(10, 142, 'Fulano', '(11) 1111-1111', NULL, '11111111', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y', NULL, NULL, '2017-11-28 09:33:11'),
	(11, 143, 'Ulisses Bueno', '(11) 99203-5937', NULL, '08584050', '198', 'Rua dos Militares, Jardim América, Itaquaquecetuba, SP', 'Mercado Irmãos Silva', 'Sem cebola', NULL, NULL, NULL, 'y', NULL, NULL, '2017-11-29 07:59:56'),
	(12, 145, 'Flavio', '(11) 97482-9869', NULL, '08584000', '192', 'Rua tal', 'sdfsd', 'fgkldflg g dgdf', NULL, NULL, NULL, 'y', NULL, NULL, '2017-12-02 18:27:41');
/*!40000 ALTER TABLE `fisica` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.fisica_conta
CREATE TABLE IF NOT EXISTS `fisica_conta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fisica_id` int(11) NOT NULL,
  `tipo` enum('D','C') NOT NULL,
  `valor` double(7,2) NOT NULL,
  `desconto` int(11) DEFAULT '0',
  `dt_cadastro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `caixa_id` int(11) NOT NULL,
  `venda_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__fisica` (`fisica_id`),
  KEY `caixa_id` (`caixa_id`),
  KEY `FK_fisica_conta_venda` (`venda_id`),
  CONSTRAINT `FK__fisica` FOREIGN KEY (`fisica_id`) REFERENCES `fisica` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_fisica_conta_venda` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fisica_conta_ibfk_1` FOREIGN KEY (`caixa_id`) REFERENCES `caixa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.fisica_conta: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `fisica_conta` DISABLE KEYS */;
INSERT INTO `fisica_conta` (`id`, `fisica_id`, `tipo`, `valor`, `desconto`, `dt_cadastro`, `caixa_id`, `venda_id`) VALUES
	(23, 11, 'D', 39.85, NULL, '2017-12-01 23:55:59', 33, 222);
/*!40000 ALTER TABLE `fisica_conta` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.forma_pagto
CREATE TABLE IF NOT EXISTS `forma_pagto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `active` enum('y','n') DEFAULT NULL,
  `active_c` enum('y','n') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.forma_pagto: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `forma_pagto` DISABLE KEYS */;
INSERT INTO `forma_pagto` (`id`, `nome`, `active`, `active_c`) VALUES
	(1, 'Dinheiro', 'y', 'y'),
	(2, 'Cartao Debito', 'y', 'y'),
	(3, 'Cartao Credito', 'y', 'y'),
	(4, 'Conta Cliente', 'y', 'n');
/*!40000 ALTER TABLE `forma_pagto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.funcionario
CREATE TABLE IF NOT EXISTS `funcionario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `tipo_us` enum('R','M','N') NOT NULL DEFAULT 'N',
  `pessoa_id` int(11) NOT NULL,
  `login` varchar(50) NOT NULL,
  `senha` varchar(150) DEFAULT NULL,
  `token_change_password` varchar(100) DEFAULT NULL,
  `delivery` enum('Y','N') DEFAULT 'N',
  `valor_entregador` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  KEY `fk_funcionario_pessoa1_idx` (`pessoa_id`),
  CONSTRAINT `fk_funcionario_pessoa1` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.funcionario: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` (`id`, `nome`, `tipo_us`, `pessoa_id`, `login`, `senha`, `token_change_password`, `delivery`, `valor_entregador`) VALUES
	(1, 'Administrador', 'M', 1, 'adm', '4297f44b13955235245b2497399d7a93', '', 'N', NULL);
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.funcionario_priv
CREATE TABLE IF NOT EXISTS `funcionario_priv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `funcionario_id` int(11) NOT NULL DEFAULT '0',
  `priv_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_funcionario_priv_funcionario` (`funcionario_id`),
  KEY `FK_funcionario_priv_modulo_priv` (`priv_id`),
  CONSTRAINT `FK_funcionario_priv_funcionario` FOREIGN KEY (`funcionario_id`) REFERENCES `funcionario` (`id`),
  CONSTRAINT `FK_funcionario_priv_modulo_priv` FOREIGN KEY (`priv_id`) REFERENCES `modulo_priv` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.funcionario_priv: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `funcionario_priv` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario_priv` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.help
CREATE TABLE IF NOT EXISTS `help` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) NOT NULL,
  `description` mediumtext NOT NULL,
  `modulo_id` int(11) NOT NULL,
  `order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_help_modulo` (`modulo_id`),
  CONSTRAINT `FK_help_modulo` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.help: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `help` DISABLE KEYS */;
INSERT INTO `help` (`id`, `title`, `description`, `modulo_id`, `order`) VALUES
	(8, 'Venda de Produtos', '...', 1, 6),
	(10, 'Testão', '', 1, 0);
/*!40000 ALTER TABLE `help` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.help_item
CREATE TABLE IF NOT EXISTS `help_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `help_id` int(11) NOT NULL,
  `title_item` varchar(250) NOT NULL,
  `resume` varchar(100) NOT NULL,
  `description_item` mediumtext NOT NULL,
  `order_item` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_help_item_help` (`help_id`),
  CONSTRAINT `FK_help_item_help` FOREIGN KEY (`help_id`) REFERENCES `help` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.help_item: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `help_item` DISABLE KEYS */;
INSERT INTO `help_item` (`id`, `help_id`, `title_item`, `resume`, `description_item`, `order_item`) VALUES
	(10, 8, 'Adicionar Item na Venda', 'Digite o código ou o código de barra do produto que deseja adicionar a venda', '...', 10),
	(11, 8, 'Definir Quantidade do Item na Venda', '', '...', 11),
	(12, 8, 'Excluir um ou mais Itens da Venda', '', '...', 12),
	(13, 8, 'Efetuar Pagamento da Venda', '', '...', 13),
	(14, 8, 'Cancelar uma Venda', '', '...', 14),
	(15, 8, 'Pesquisar Preço e/ou Estoque de Produto', '', '...', 15);
/*!40000 ALTER TABLE `help_item` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.itens_venda
CREATE TABLE IF NOT EXISTS `itens_venda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venda_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `tamanho_id` int(11) DEFAULT NULL,
  `quantidade` double(7,2) DEFAULT NULL,
  `valor_unitario` decimal(7,2) DEFAULT NULL,
  `status` enum('E','A','C','X') NOT NULL DEFAULT 'C' COMMENT 'E = Enviado, A = Andamento, C = Concluido, X = Cancelado',
  `nome_cliente` varchar(100) DEFAULT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_itens_venda_venda1_idx` (`venda_id`),
  KEY `fk_itens_venda_produto1_idx` (`produto_id`),
  CONSTRAINT `fk_itens_venda_produto1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_itens_venda_venda1` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.itens_venda: ~26 rows (aproximadamente)
/*!40000 ALTER TABLE `itens_venda` DISABLE KEYS */;
INSERT INTO `itens_venda` (`id`, `venda_id`, `produto_id`, `tamanho_id`, `quantidade`, `valor_unitario`, `status`, `nome_cliente`, `descricao`) VALUES
	(1, 216, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(2, 217, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(3, 217, 70, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(4, 217, 73, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(10, 218, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(11, 218, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(12, 218, 70, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(14, 220, 71, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(15, 220, 72, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(16, 221, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(17, 221, 1, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(18, 222, 1, NULL, 1.00, 39.85, 'C', NULL, NULL),
	(19, 223, 1, NULL, 1.00, 39.85, 'C', NULL, '<b>1/2</b> (P01) MUSSARELA / <b>1/2</b> (P02) CATUPIRI'),
	(20, 224, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(21, 225, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(22, 226, 70, NULL, 1.00, 45.00, 'C', NULL, NULL),
	(23, 227, 69, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(24, 227, 70, NULL, 1.00, 45.00, 'C', NULL, NULL),
	(25, 227, 71, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(26, 228, 70, NULL, 1.00, 45.00, 'C', NULL, NULL),
	(27, 228, 70, NULL, 1.00, 45.00, 'C', NULL, NULL),
	(28, 228, 71, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(29, 228, 72, NULL, 1.00, 34.70, 'C', NULL, NULL),
	(30, 229, 69, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(37, 232, 69, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(38, 233, 69, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(39, 234, 70, NULL, 1.00, 45.00, 'A', NULL, NULL),
	(40, 235, 71, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(41, 235, 71, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(42, 237, 71, NULL, 1.00, 34.70, 'A', NULL, NULL),
	(43, 236, 70, NULL, 1.00, 45.00, 'A', NULL, NULL);
/*!40000 ALTER TABLE `itens_venda` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.juridica
CREATE TABLE IF NOT EXISTS `juridica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pessoa_id` int(11) NOT NULL,
  `cnpj` varchar(100) NOT NULL,
  `razao_social` varchar(200) NOT NULL,
  `nome_fantasia` varchar(200) NOT NULL COMMENT 'label',
  `inscricao_estadual` varchar(100) DEFAULT NULL,
  `ccm` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cnpj_UNIQUE` (`cnpj`),
  UNIQUE KEY `pessoa_id_UNIQUE` (`pessoa_id`),
  KEY `fk_juridica_pessoa2_idx` (`pessoa_id`),
  CONSTRAINT `fk_juridica_pessoa2` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.juridica: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `juridica` DISABLE KEYS */;
/*!40000 ALTER TABLE `juridica` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.log
CREATE TABLE IF NOT EXISTS `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `log` longtext NOT NULL,
  `data` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.log: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.module
CREATE TABLE IF NOT EXISTS `module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(200) NOT NULL COMMENT 'label',
  `parent` int(11) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  `link` varchar(255) DEFAULT NULL,
  `order` float DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Copiando dados para a tabela mm.module: ~16 rows (aproximadamente)
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` (`module_id`, `text`, `parent`, `active`, `link`, `order`, `icon`) VALUES
	(1, 'Cadastro', NULL, 'Y', '', 3, 'fa-keyboard-o'),
	(2, 'Categoria', 23, 'Y', 'internals/category', 5.1, 'fa-sitemap'),
	(6, 'Produtos', NULL, 'Y', 'internals/product', 1, ' fa-gift'),
	(13, 'Fornecedores', 1, 'Y', 'internals/company', 3.1, 'fa-truck'),
	(14, 'Funcionários', 1, 'Y', 'internals/employee', 3.2, 'fa-address-card-o'),
	(15, 'Clientes', 1, 'Y', 'internals/buyer', 3.3, 'fa-users'),
	(16, 'Unidades', 23, 'Y', 'internals/measure', 5.2, 'fa-eyedropper'),
	(17, 'Formas de Pagamento', 23, 'Y', 'internals/payment', 5.3, 'fa-money'),
	(18, 'Controle de Estoque', NULL, 'Y', 'internals/stock', 2, 'fa-cubes'),
	(19, 'Relatorios', NULL, 'Y', NULL, 4, 'fa-bar-chart'),
	(20, 'Faturamento', 19, 'Y', 'rel/sale', 4.1, 'fa-money'),
	(21, 'Configuracoes', NULL, 'Y', 'internals/profile', 6, 'fa-sliders'),
	(22, 'Mesas', 23, 'Y', 'grid/tables', 5.4, 'fa-bell-o'),
	(23, 'Manutencao', NULL, 'Y', NULL, 5, 'fa-wrench'),
	(24, 'Delivery', 19, 'Y', 'rel/delivery', 4.2, 'fa-motorcycle'),
	(25, 'Dashboard', NULL, 'Y', 'internals/home', 0, 'fa-home'),
	(26, 'Monitor Pedidos', NULL, 'Y', 'internals/monitor', NULL, NULL);
/*!40000 ALTER TABLE `module` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.modulo
CREATE TABLE IF NOT EXISTS `modulo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(200) NOT NULL COMMENT 'label',
  `pai` int(11) DEFAULT NULL,
  `statusID` tinytext,
  `link` varchar(255) DEFAULT NULL,
  `ordem` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_modulo_modulo1_idx` (`pai`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.modulo: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `modulo` DISABLE KEYS */;
INSERT INTO `modulo` (`id`, `text`, `pai`, `statusID`, `link`, `ordem`) VALUES
	(1, 'Vender', NULL, '1', '/internals/sell.php', 1),
	(15, 'Suporte', NULL, '1', NULL, 16),
	(17, 'Atendimento', 15, '1', '/internals/atendimento.php', 17),
	(18, 'Alterar Senha', 15, '1', '/internals/alterar_senha.php', 18);
/*!40000 ALTER TABLE `modulo` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.modulo_priv
CREATE TABLE IF NOT EXISTS `modulo_priv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modulo_id` int(11) NOT NULL DEFAULT '0',
  `texto` varchar(50) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_modulo_priv_modulo` (`modulo_id`),
  CONSTRAINT `FK_modulo_priv_modulo` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.modulo_priv: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `modulo_priv` DISABLE KEYS */;
/*!40000 ALTER TABLE `modulo_priv` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.pessoa
CREATE TABLE IF NOT EXISTS `pessoa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(2) NOT NULL COMMENT 'AT=ATIVO\\\\\\\\nIN=INATIVO\\\\\\\\n',
  `tipo` enum('F','J') NOT NULL COMMENT 'F=FISICA\\nJ=JURIDICA\\n',
  `rua` varchar(100) DEFAULT NULL,
  `numero` varchar(5) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  `cep` varchar(30) DEFAULT NULL,
  `pais` varchar(45) DEFAULT NULL,
  `telefone` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `dt_atualizacao` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dt_cadastro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.pessoa: ~57 rows (aproximadamente)
/*!40000 ALTER TABLE `pessoa` DISABLE KEYS */;
INSERT INTO `pessoa` (`id`, `status`, `tipo`, `rua`, `numero`, `bairro`, `cidade`, `uf`, `cep`, `pais`, `telefone`, `email`, `dt_atualizacao`, `dt_cadastro`) VALUES
	(1, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ulisses.bueno@gmail.com', '2017-11-21 09:00:12', '2017-03-27 21:14:40'),
	(88, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-16 13:45:29', '2017-10-16 13:45:29'),
	(89, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 10:57:22', '2017-10-17 10:57:22'),
	(91, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 10:57:50', '2017-10-17 10:57:50'),
	(92, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 10:58:25', '2017-10-17 10:58:25'),
	(93, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 10:59:48', '2017-10-17 10:59:48'),
	(94, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 11:04:55', '2017-10-17 11:04:55'),
	(95, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 11:05:39', '2017-10-17 11:05:39'),
	(96, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:22:51', '2017-10-17 16:22:51'),
	(97, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:23:25', '2017-10-17 16:23:25'),
	(98, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:23:35', '2017-10-17 16:23:35'),
	(99, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:23:48', '2017-10-17 16:23:48'),
	(100, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:24:23', '2017-10-17 16:24:23'),
	(101, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:25:30', '2017-10-17 16:25:30'),
	(102, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:26:05', '2017-10-17 16:26:05'),
	(103, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 16:28:38', '2017-10-17 16:28:38'),
	(104, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:17:06', '2017-10-17 17:17:06'),
	(105, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:17:40', '2017-10-17 17:17:40'),
	(106, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:18:15', '2017-10-17 17:18:15'),
	(107, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:19:30', '2017-10-17 17:19:30'),
	(108, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:20:05', '2017-10-17 17:20:05'),
	(109, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:21:58', '2017-10-17 17:21:58'),
	(110, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:22:24', '2017-10-17 17:22:24'),
	(111, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:22:50', '2017-10-17 17:22:50'),
	(112, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:23:06', '2017-10-17 17:23:06'),
	(113, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:23:51', '2017-10-17 17:23:51'),
	(114, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-17 17:24:06', '2017-10-17 17:24:06'),
	(115, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 07:54:06', '2017-10-18 07:54:06'),
	(116, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 07:58:59', '2017-10-18 07:58:59'),
	(117, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 07:59:23', '2017-10-18 07:59:23'),
	(118, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 07:59:33', '2017-10-18 07:59:33'),
	(119, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:00:04', '2017-10-18 08:00:04'),
	(120, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:00:36', '2017-10-18 08:00:36'),
	(121, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:01:02', '2017-10-18 08:01:02'),
	(122, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:01:58', '2017-10-18 08:01:58'),
	(123, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:02:35', '2017-10-18 08:02:35'),
	(124, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:03:56', '2017-10-18 08:03:56'),
	(125, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:12:52', '2017-10-18 08:12:52'),
	(127, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 08:27:42', '2017-10-18 08:27:42'),
	(128, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 10:51:22', '2017-10-18 10:51:22'),
	(129, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 10:51:26', '2017-10-18 10:51:26'),
	(130, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 10:51:38', '2017-10-18 10:51:38'),
	(131, 'AT', 'F', '', '', '', '', '', '', '', '', '', '2017-10-18 10:51:39', '2017-10-18 10:51:39'),
	(132, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-10-31 16:17:15', '2017-10-31 16:17:15'),
	(133, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-01 07:58:04', '2017-11-01 07:58:04'),
	(134, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-27 20:53:08', '2017-11-27 20:53:08'),
	(135, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-27 20:53:13', '2017-11-27 20:53:13'),
	(136, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-27 20:54:06', '2017-11-27 20:54:06'),
	(137, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-27 20:54:25', '2017-11-27 20:54:25'),
	(138, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-27 20:55:24', '2017-11-27 20:55:24'),
	(139, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-28 08:16:43', '2017-11-28 08:16:43'),
	(140, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-28 08:16:51', '2017-11-28 08:16:51'),
	(141, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-28 08:23:31', '2017-11-28 08:23:31'),
	(142, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-28 09:33:11', '2017-11-28 09:33:11'),
	(143, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-29 07:59:56', '2017-11-29 07:59:56'),
	(144, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-29 21:18:43', '2017-11-29 21:18:43'),
	(145, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-12-02 18:27:41', '2017-12-02 18:27:41');
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.produto
CREATE TABLE IF NOT EXISTS `produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(45) DEFAULT NULL,
  `codbar` varchar(255) DEFAULT NULL,
  `categoria_id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL COMMENT 'label',
  `descricao` varchar(1000) DEFAULT NULL,
  `valor` decimal(7,2) NOT NULL,
  `unidade_id` int(11) NOT NULL,
  `estoque_min` int(11) DEFAULT '0',
  `estoque` int(11) DEFAULT '0',
  `tem_estoque` enum('y','n') NOT NULL DEFAULT 'y',
  `status_inicial` enum('E','A','C','X') NOT NULL DEFAULT 'C',
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  `nome_vinculo` varchar(100) DEFAULT NULL,
  `prod_vinculado` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  UNIQUE KEY `codbar_UNIQUE` (`codbar`),
  KEY `fk_produto_categoria1_idx` (`categoria_id`),
  KEY `fk_produto_unidade1_idx` (`unidade_id`),
  CONSTRAINT `fk_produto_categoria1` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto_unidade1` FOREIGN KEY (`unidade_id`) REFERENCES `unidade` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.produto: ~65 rows (aproximadamente)
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` (`id`, `codigo`, `codbar`, `categoria_id`, `nome`, `descricao`, `valor`, `unidade_id`, `estoque_min`, `estoque`, `tem_estoque`, `status_inicial`, `active`, `nome_vinculo`, `prod_vinculado`) VALUES
	(1, 'PX', NULL, 4, 'PIZZA MISTA', NULL, 0.00, 2, 0, -3, 'y', 'A', 'n', NULL, NULL),
	(69, 'P01', NULL, 4, 'MUSSARELA', 'mussarela, tomate e azeitonas', 34.70, 4, 0, -25, 'n', 'A', 'y', NULL, NULL),
	(70, 'P02', NULL, 4, 'CATUPIRI', 'catupiri, tomate e azeitonas', 45.00, 4, 0, -13, 'n', 'A', 'y', NULL, NULL),
	(71, 'P03', NULL, 4, 'MARGUERITA', 'mussarela, tomate, manjeric?o, parmes?o e azeitonas', 34.70, 4, 0, -9, 'n', 'A', 'y', NULL, NULL),
	(72, 'P04', NULL, 4, 'PROMUSSA', 'provolone, mussarela e azeitonas', 34.70, 4, 0, -3, 'n', 'A', 'y', NULL, NULL),
	(73, 'P05', NULL, 4, 'TR?S QUEIJOS', 'mussarela, provolone, catupiri e azeitonas', 34.70, 4, 0, -3, 'n', 'A', 'y', NULL, NULL),
	(74, 'P06', NULL, 4, 'QUATRO QUEIJOS', 'mussarela, provolone, catupiri, gorgonzola e azeitonas', 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(75, 'P07', NULL, 4, 'CALABRESA ( calabresa, mussarela, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(76, 'P08', NULL, 4, 'PRESUNTO (mussarela, tomate, presunto e azeitonas)', NULL, 34.70, 4, 0, -2, 'n', 'A', 'y', NULL, NULL),
	(77, 'P09', NULL, 4, 'ALICHE (mussarela, aliche, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(78, 'P10', NULL, 4, 'ATUM (mussarela, atum, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(79, 'P11', NULL, 4, 'LOMBO (mussarela, lombo e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(80, 'P12', NULL, 4, 'CATUPIRI ESPECIAL (catupiri, presunto e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(81, 'P13', NULL, 4, 'BACON (mussarela, bacon, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(82, 'P14', NULL, 4, 'FRANGO (frango, mussarela, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(83, 'P15', NULL, 4, 'FRANGO COM CATUPIRI (frango, catupiri, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(84, 'P16', NULL, 4, 'CATUNGA (catupiri, atum, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(85, 'P17', NULL, 4, 'FIORENTINA (catupiri, lombo e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(86, 'P18', NULL, 4, 'MILIONÁRIA (catupiri, milho, calabresa e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(87, 'P19', NULL, 4, 'MINEIRINHA (catupiri, lombo, tomate, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(88, 'P20', NULL, 4, 'PEKA´S (ervilha, cenoura, palmito, ovos, cebola, vagem, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(89, 'P21', NULL, 4, 'À MODA DO PIZZAIOLO (calabresa, catupiri, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(90, 'P22', NULL, 4, 'À BRASILEIRA (mussarela, tomate, ovos, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(91, 'P23', NULL, 4, 'ESCAROLA (mussarela, escarola, bacon, cebola, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(92, 'P24', NULL, 4, 'NAPOLITANA (mussarela, tomate, parmesão e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(93, 'P25', NULL, 4, 'DA MAMA (mussarela, milho, brócolis, palmito e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(94, 'P26', NULL, 4, 'PORTUGUESA (mussarela, presunto, ovos, ervilha, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(95, 'P27', NULL, 4, 'VENEZA (frango, champignon, catupiri, tomate, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(96, 'P28', NULL, 4, 'PARAGUAIA (presunto, tomate, ovos, ervilha, calabresa, mussarela, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(97, 'P29', NULL, 4, 'LISBOA (presunto, calabresa, tomate, cebola, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(98, 'P30', NULL, 4, 'BOLIVIANA (lombo, bacon, ovos, tomate, mussarela, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(99, 'P31', NULL, 4, 'ITALIANA (mussarela, lombo, calabresa, tomate, milho, ovos, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(100, 'P32', NULL, 4, 'PALMITO (mussarela, palmito e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(101, 'P33', NULL, 4, 'MILHO (mussarela, milho, bacon e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(102, 'P34', NULL, 4, 'CHAMPIGNON (mussarela, champignon, bacon e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(103, 'P35', NULL, 4, 'MARAVILHA (atum, palmito, ervilha, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(104, 'P36', NULL, 4, 'TATUAGEM (presunto, palmito, cebola, mussarela, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(105, 'P37', NULL, 4, 'SALAME (mussarela, salame, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(106, 'P38', NULL, 4, '2001 (milho, palmito, lombo, mussarela, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(107, 'P39', NULL, 4, 'BRÓCOLIS (mussarela, brócolis, bacon e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(108, 'P40', NULL, 4, 'MILHO COM CATUPIRI (catupiri, milho, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(109, 'P41', NULL, 4, 'BOM GOSTO (5 ingredientes à sua escolha)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(110, 'P42', NULL, 4, 'PEPPERONI (mussarela, pepperoni, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(111, 'P43', NULL, 4, 'ALHO (mussarela, tomate, cebola, alho e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(112, 'P44', NULL, 4, 'CAMARÃO ( mussarela ou catupiri com camarão temperado)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(113, 'P45', NULL, 4, 'BAIANA (mussarela, calabresa moída apimentada, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(114, 'P46', NULL, 4, 'BERINJELA (mussarela, berinjela, bacon, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(115, 'P47', NULL, 4, 'RÚCULA (mussarela de búfala, tomate seco, rúcula e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(116, 'P48', NULL, 4, 'RAMONES (calabresa, gorgonzola, vinagrete e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(117, 'P49', NULL, 4, 'KADÚ (mussarela, catupiri, batata palha e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(118, 'P50', NULL, 4, 'À MODA DA CASA (catupiri, lombo, palmito, champignon, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(119, 'P51', NULL, 4, 'PIZZA RUTE (mussarela, champignon, pimentão, tomate, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(120, 'P52', NULL, 4, 'CAIPIRA (frango, catupiri, milho e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(121, 'P53', NULL, 4, 'SICILIANA (mussarela, palmito, champignon, pimentão, bacon e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(122, 'P54', NULL, 4, 'FRANGOLINO (mussarela, frango, palmito, tomate, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(123, 'P55', NULL, 4, 'FRANGO ESPECIAL (mussarela, frango refogado, bacon, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(124, 'P56', NULL, 4, 'MARGUERITA ESPECIAL (mussarela, molho, tomate seco, gorgonzola, parmesão, manjericão e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(125, 'P57', NULL, 4, 'CAMUSSA (catupiri, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(126, 'P58', NULL, 4, 'BROCOLIS ESPECIAL (brócolis, catupiri, alho, cebola, mussarela, tomate e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(127, 'P59', NULL, 4, 'ATUM ESPECIAL (mussarela, atum, aliche, tomate, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(128, 'P60', NULL, 4, 'PRESUNTO ESPECIAL (presunto, milho, catupiri, coberta com mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(129, 'P61', NULL, 4, 'CHEFE (mussarela, presunto, champignon, cebola e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(130, 'P62', NULL, 4, 'AMERICANA (calabresa, presunto, milho, palmito, ovos, cebola, mussarela e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(131, 'P63', NULL, 4, 'BACALHAU (mussarela, bacalhau desfiado, ovos, tomate, cebola, rodelas de batata e azeitonas)', NULL, 34.70, 4, 0, 0, 'n', 'A', 'y', NULL, NULL),
	(133, 'B01', NULL, 5, 'Coca cola 600ml', NULL, 5.00, 1, 2, 0, 'y', 'C', 'y', NULL, NULL);
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.produto_tamanho
CREATE TABLE IF NOT EXISTS `produto_tamanho` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `produto_id` int(11) NOT NULL,
  `descricao` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__produto` (`produto_id`),
  CONSTRAINT `FK__produto` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- Copiando dados para a tabela mm.produto_tamanho: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `produto_tamanho` DISABLE KEYS */;
INSERT INTO `produto_tamanho` (`id`, `produto_id`, `descricao`, `valor`) VALUES
	(2, 69, 'P', 20.00),
	(3, 69, 'M', 30.00);
/*!40000 ALTER TABLE `produto_tamanho` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.unidade
CREATE TABLE IF NOT EXISTS `unidade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) NOT NULL COMMENT 'label',
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.unidade: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` (`id`, `descricao`, `active`) VALUES
	(1, 'Unidade', 'y'),
	(2, 'Livre', 'y'),
	(3, 'Kg', 'y'),
	(4, 'Fração', 'y');
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.venda
CREATE TABLE IF NOT EXISTS `venda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `NrPedido` int(11) DEFAULT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `desconto` double(7,2) DEFAULT '0.00',
  `total` decimal(7,2) DEFAULT NULL,
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('A','F','C','E') DEFAULT NULL COMMENT 'A = Aberta F = Fechada C = Cancelada, E = Entrega, X = Cancelado',
  `comanda_mesa_id` int(11) DEFAULT NULL,
  `caixa_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_venda_pessoa1_idx` (`cliente_id`),
  KEY `FK_venda_comanda_mesa` (`comanda_mesa_id`),
  KEY `FK_venda_caixa` (`caixa_id`),
  CONSTRAINT `FK_venda_caixa` FOREIGN KEY (`caixa_id`) REFERENCES `caixa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_venda_comanda_mesa` FOREIGN KEY (`comanda_mesa_id`) REFERENCES `comanda_mesa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.venda: ~21 rows (aproximadamente)
/*!40000 ALTER TABLE `venda` DISABLE KEYS */;
INSERT INTO `venda` (`id`, `NrPedido`, `cliente_id`, `desconto`, `total`, `data`, `status`, `comanda_mesa_id`, `caixa_id`) VALUES
	(216, 0, NULL, 0.00, 34.70, '2017-12-01 18:45:13', 'A', NULL, 33),
	(217, 0, NULL, 0.00, 104.10, '2017-12-01 19:19:17', 'A', NULL, 33),
	(218, 0, NULL, 0.00, 69.40, '2017-12-01 19:27:23', 'A', 3, 33),
	(219, 0, NULL, 0.00, 34.70, '2017-12-01 19:44:57', 'A', 3, 33),
	(220, 0, NULL, 0.00, 69.40, '2017-12-01 19:45:15', 'A', NULL, 33),
	(221, 0, NULL, 0.00, 69.40, '2017-12-01 23:44:14', 'A', NULL, 33),
	(222, 0, NULL, 0.00, 39.85, '2017-12-01 23:55:59', 'A', NULL, 33),
	(223, 0, NULL, 0.00, 39.85, '2017-12-02 00:03:03', 'A', NULL, 33),
	(224, 0, NULL, 0.00, 34.70, '2017-12-02 16:26:21', 'A', NULL, 33),
	(225, 0, NULL, 0.00, 34.70, '2017-12-02 16:29:34', 'A', NULL, 33),
	(226, 0, NULL, 0.00, 45.00, '2017-12-02 16:32:24', 'A', NULL, 34),
	(227, 0, NULL, 0.00, 114.40, '2017-12-02 18:25:39', 'A', NULL, 34),
	(228, 0, NULL, 0.00, 159.40, '2017-12-02 18:27:47', 'A', NULL, 34),
	(229, 0, NULL, 0.00, 34.70, '2017-12-02 18:46:39', 'A', NULL, 35),
	(232, 32, NULL, 0.00, 34.70, '2018-02-06 23:01:49', 'A', NULL, 35),
	(233, 33, NULL, 0.00, 34.70, '2018-02-06 23:02:02', 'A', NULL, 35),
	(234, 34, NULL, 0.00, 45.00, '2018-02-06 23:02:17', 'A', 3, 35),
	(235, 35, NULL, 0.00, 138.80, '2018-02-06 23:02:33', 'A', 3, 35),
	(236, 36, NULL, 0.00, 45.00, '2018-02-06 23:02:48', 'A', 3, 35),
	(237, 37, NULL, 0.00, 69.40, '2018-02-06 23:03:53', 'A', 4, 35),
	(238, 38, NULL, 0.00, NULL, '2018-02-06 23:04:00', 'A', 4, 35);
/*!40000 ALTER TABLE `venda` ENABLE KEYS */;

-- Copiando estrutura para tabela mm.venda_pagto
CREATE TABLE IF NOT EXISTS `venda_pagto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venda_id` int(11) DEFAULT NULL,
  `fisica_conta_id` int(11) DEFAULT NULL,
  `forma_pagto_id` int(11) NOT NULL DEFAULT '0',
  `valor` double(7,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `FK_venda_pagto_venda` (`venda_id`),
  KEY `FK_venda_pagto_forma_pagto` (`forma_pagto_id`),
  KEY `fisica_conta_id` (`fisica_conta_id`),
  CONSTRAINT `FK_venda_pagto_forma_pagto` FOREIGN KEY (`forma_pagto_id`) REFERENCES `forma_pagto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_venda_pagto_venda` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `venda_pagto_ibfk_1` FOREIGN KEY (`fisica_conta_id`) REFERENCES `fisica_conta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm.venda_pagto: ~19 rows (aproximadamente)
/*!40000 ALTER TABLE `venda_pagto` DISABLE KEYS */;
INSERT INTO `venda_pagto` (`id`, `venda_id`, `fisica_conta_id`, `forma_pagto_id`, `valor`) VALUES
	(1, 216, NULL, 1, 34.70),
	(2, 217, NULL, 1, 104.10),
	(3, 218, NULL, 1, 69.40),
	(4, 219, NULL, 1, 34.70),
	(5, 220, NULL, 1, 69.40),
	(6, 221, NULL, 1, 69.40),
	(7, 222, NULL, 4, 39.85),
	(8, 223, NULL, 1, 39.85),
	(9, 224, NULL, 1, 34.70),
	(10, 225, NULL, 1, 34.70),
	(11, 226, NULL, 1, 30.00),
	(12, 226, NULL, 3, 15.00),
	(13, 227, NULL, 1, 114.40),
	(14, 228, NULL, 4, 159.40),
	(15, 229, NULL, 1, 34.70),
	(18, 232, NULL, 1, 34.70),
	(19, 233, NULL, 1, 34.70),
	(20, 234, NULL, 1, 45.00),
	(21, 235, NULL, 1, 138.80),
	(22, 237, NULL, 1, 69.40),
	(23, 236, NULL, 1, 45.00);
/*!40000 ALTER TABLE `venda_pagto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm._user_
CREATE TABLE IF NOT EXISTS `_user_` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `token_change_password` varchar(100) NOT NULL,
  `dt_register` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Copiando dados para a tabela mm._user_: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `_user_` DISABLE KEYS */;
INSERT INTO `_user_` (`id`, `email`, `password`, `token_change_password`, `dt_register`, `dt_update`) VALUES
	(3, 'ulisses.bueno@gmail.com', '4297f44b13955235245b2497399d7a93', '', '2017-06-09 21:29:18', '2017-12-06 22:16:11');
/*!40000 ALTER TABLE `_user_` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
