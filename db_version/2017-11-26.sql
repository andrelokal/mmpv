-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.1.22-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win32
-- HeidiSQL Versão:              9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para mm_bd
CREATE DATABASE IF NOT EXISTS `mm_bd` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mm_bd`;

-- Copiando estrutura para tabela mm_bd.acesso
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

-- Copiando dados para a tabela mm_bd.acesso: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `acesso` DISABLE KEYS */;
INSERT INTO `acesso` (`id`, `modulo_id`, `funcionario_id`, `nivel_acesso`) VALUES
	(2, 1, 1, '');
/*!40000 ALTER TABLE `acesso` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.caixa
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
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.caixa: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `caixa` DISABLE KEYS */;
INSERT INTO `caixa` (`id`, `valor_inicial`, `valor_fechamento`, `funcionario_id`, `dt_abertura`, `dt_fechamento`) VALUES
	(33, 0.00, 0.00, 1, '2017-11-23 21:02:43', NULL);
/*!40000 ALTER TABLE `caixa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.categoria
CREATE TABLE IF NOT EXISTS `categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL COMMENT 'label',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.categoria: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` (`id`, `nome`) VALUES
	(2, 'Teste'),
	(3, 'Outra');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.comanda_mesa
CREATE TABLE IF NOT EXISTS `comanda_mesa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) NOT NULL,
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  `status` enum('L','O','P') NOT NULL DEFAULT 'L',
  `dt_status_O` timestamp NULL DEFAULT NULL,
  `dt_status_L` timestamp NULL DEFAULT NULL,
  `venda_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.comanda_mesa: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `comanda_mesa` DISABLE KEYS */;
INSERT INTO `comanda_mesa` (`id`, `codigo`, `active`, `status`, `dt_status_O`, `dt_status_L`, `venda_id`) VALUES
	(1, '01', 'y', 'O', '2017-11-23 09:26:56', NULL, 91),
	(2, '02', 'y', 'O', '2017-11-23 09:25:50', NULL, 92);
/*!40000 ALTER TABLE `comanda_mesa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.config
CREATE TABLE IF NOT EXISTS `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome_empresa` varchar(50) DEFAULT NULL,
  `desc_cupom` varchar(250) DEFAULT NULL,
  `print_port` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.config: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` (`id`, `nome_empresa`, `desc_cupom`, `print_port`) VALUES
	(1, 'JJ - armarinho', NULL, NULL);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.entrada_produto
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.entrada_produto: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `entrada_produto` DISABLE KEYS */;
INSERT INTO `entrada_produto` (`id`, `tipo`, `produto_id`, `fornecedor_id`, `quantidade`, `lote`, `dt_compra`, `dt_validade`, `valor_unitario`, `valor_total`, `motivo_saida`, `dt_lancamento`) VALUES
	(1, 'E', 2, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, '2017-10-27 13:16:28'),
	(2, 'E', 2, NULL, 50, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-23 09:22:44');
/*!40000 ALTER TABLE `entrada_produto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.fisica
CREATE TABLE IF NOT EXISTS `fisica` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pessoa_id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL COMMENT 'label',
  `telefone` varchar(50) NOT NULL,
  `cpf` varchar(20) DEFAULT NULL,
  `CEP` varchar(10) DEFAULT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `endereco` text,
  `observacao` text,
  `rg` varchar(20) DEFAULT NULL,
  `dt_nascimento` date DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL COMMENT 'SEXO:\nH=HOMEM\nM=MULHER\n',
  `tem_conta` enum('y','n') DEFAULT 'y',
  `dia_mes_pagto` int(11) DEFAULT NULL,
  `limite_conta` double(7,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pessoa_id_UNIQUE` (`pessoa_id`),
  UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  KEY `fk_fisica_pessoa2_idx` (`pessoa_id`),
  CONSTRAINT `fk_fisica_pessoa2` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.fisica: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `fisica` DISABLE KEYS */;
INSERT INTO `fisica` (`id`, `pessoa_id`, `nome`, `telefone`, `cpf`, `CEP`, `numero`, `endereco`, `observacao`, `rg`, `dt_nascimento`, `sexo`, `tem_conta`, `dia_mes_pagto`, `limite_conta`) VALUES
	(1, 133, 'Ulisses Bueno da Silva', '', '301.625.408-50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'y', NULL, 20.00);
/*!40000 ALTER TABLE `fisica` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.fisica_conta
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
  CONSTRAINT `FK_fisica_conta_venda` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fisica_conta_ibfk_1` FOREIGN KEY (`caixa_id`) REFERENCES `caixa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.fisica_conta: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `fisica_conta` DISABLE KEYS */;
/*!40000 ALTER TABLE `fisica_conta` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.forma_pagto
CREATE TABLE IF NOT EXISTS `forma_pagto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) NOT NULL,
  `active` enum('y','n') DEFAULT NULL,
  `active_c` enum('y','n') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.forma_pagto: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `forma_pagto` DISABLE KEYS */;
INSERT INTO `forma_pagto` (`id`, `nome`, `active`, `active_c`) VALUES
	(1, 'Dinheiro', 'y', 'y'),
	(2, 'Cartao Debito', 'y', 'y'),
	(3, 'Cartao Credito', 'y', 'y'),
	(4, 'Conta Cliente', 'y', 'n');
/*!40000 ALTER TABLE `forma_pagto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.funcionario
CREATE TABLE IF NOT EXISTS `funcionario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `tipo_us` enum('R','M','N') NOT NULL DEFAULT 'N',
  `pessoa_id` int(11) NOT NULL,
  `login` varchar(50) NOT NULL,
  `senha` varchar(150) DEFAULT NULL,
  `token_change_password` varchar(100) DEFAULT NULL,
  `delivery` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`id`),
  UNIQUE KEY `login_UNIQUE` (`login`),
  KEY `fk_funcionario_pessoa1_idx` (`pessoa_id`),
  CONSTRAINT `fk_funcionario_pessoa1` FOREIGN KEY (`pessoa_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.funcionario: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `funcionario` DISABLE KEYS */;
INSERT INTO `funcionario` (`id`, `nome`, `tipo_us`, `pessoa_id`, `login`, `senha`, `token_change_password`, `delivery`) VALUES
	(1, 'Administrador', 'M', 1, 'adm', '4297f44b13955235245b2497399d7a93', '', 'N');
/*!40000 ALTER TABLE `funcionario` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.funcionario_priv
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

-- Copiando dados para a tabela mm_bd.funcionario_priv: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `funcionario_priv` DISABLE KEYS */;
/*!40000 ALTER TABLE `funcionario_priv` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.help
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

-- Copiando dados para a tabela mm_bd.help: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `help` DISABLE KEYS */;
INSERT INTO `help` (`id`, `title`, `description`, `modulo_id`, `order`) VALUES
	(8, 'Venda de Produtos', '...', 1, 6),
	(10, 'Testão', '', 1, 0);
/*!40000 ALTER TABLE `help` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.help_item
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

-- Copiando dados para a tabela mm_bd.help_item: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `help_item` DISABLE KEYS */;
INSERT INTO `help_item` (`id`, `help_id`, `title_item`, `resume`, `description_item`, `order_item`) VALUES
	(10, 8, 'Adicionar Item na Venda', 'Digite o código ou o código de barra do produto que deseja adicionar a venda', '...', 10),
	(11, 8, 'Definir Quantidade do Item na Venda', '', '...', 11),
	(12, 8, 'Excluir um ou mais Itens da Venda', '', '...', 12),
	(13, 8, 'Efetuar Pagamento da Venda', '', '...', 13),
	(14, 8, 'Cancelar uma Venda', '', '...', 14),
	(15, 8, 'Pesquisar Preço e/ou Estoque de Produto', '', '...', 15);
/*!40000 ALTER TABLE `help_item` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.itens_venda
CREATE TABLE IF NOT EXISTS `itens_venda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venda_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` double(7,2) DEFAULT NULL,
  `valor_unitario` decimal(7,2) DEFAULT NULL,
  `status` enum('E','A','C','X') NOT NULL DEFAULT 'C' COMMENT 'E = Enviado, A = Andamento, C = Concluido, X = Cancelado',
  `nome_cliente` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_itens_venda_venda1_idx` (`venda_id`),
  KEY `fk_itens_venda_produto1_idx` (`produto_id`),
  CONSTRAINT `fk_itens_venda_produto1` FOREIGN KEY (`produto_id`) REFERENCES `produto` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_itens_venda_venda1` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.itens_venda: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `itens_venda` DISABLE KEYS */;
INSERT INTO `itens_venda` (`id`, `venda_id`, `produto_id`, `quantidade`, `valor_unitario`, `status`, `nome_cliente`) VALUES
	(52, 80, 4, 1.00, 54.53, 'C', NULL),
	(59, 86, 2, 2.00, 10.00, 'C', NULL),
	(62, 89, 2, 1.00, 10.00, 'C', NULL),
	(63, 90, 2, 1.00, 10.00, 'C', NULL),
	(64, 90, 3, 1.00, 23.23, 'C', NULL),
	(119, 92, 3, 1.00, 23.23, 'E', NULL);
/*!40000 ALTER TABLE `itens_venda` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.juridica
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

-- Copiando dados para a tabela mm_bd.juridica: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `juridica` DISABLE KEYS */;
/*!40000 ALTER TABLE `juridica` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.log
CREATE TABLE IF NOT EXISTS `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `log` longtext NOT NULL,
  `data` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.log: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.module
CREATE TABLE IF NOT EXISTS `module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(200) NOT NULL COMMENT 'label',
  `parent` int(11) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  `link` varchar(255) DEFAULT NULL,
  `order` float DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Copiando dados para a tabela mm_bd.module: ~13 rows (aproximadamente)
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` (`module_id`, `text`, `parent`, `active`, `link`, `order`, `icon`) VALUES
	(1, 'Cadastro', NULL, 'Y', '', 1, NULL),
	(2, 'Categoria', 1, 'Y', 'internals/category', 1.1, NULL),
	(6, 'Produtos', NULL, 'Y', 'internals/product', 0.1, 'fa-futbol-o'),
	(13, 'Fornecedores', 1, 'Y', 'internals/company', 1.3, NULL),
	(14, 'Funcionários', 1, 'Y', 'internals/employee', 1.4, NULL),
	(15, 'Clientes', 1, 'Y', 'internals/buyer', 1.5, NULL),
	(16, 'Unidades', 1, 'Y', 'internals/measure', 1.6, NULL),
	(17, 'Formas de Pagamento', 1, 'Y', 'internals/payment', 1.7, NULL),
	(18, 'Controle de Estoque', NULL, 'Y', 'internals/stock', 0.2, NULL),
	(19, 'Relatórios', NULL, 'Y', NULL, 2, NULL),
	(20, 'Vendas', 19, 'Y', NULL, 2.1, NULL),
	(21, 'Perfil', NULL, 'Y', NULL, 3, NULL),
	(22, 'Mesas', 1, 'Y', 'grid/tables', 1.8, NULL);
/*!40000 ALTER TABLE `module` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.modulo
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

-- Copiando dados para a tabela mm_bd.modulo: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `modulo` DISABLE KEYS */;
INSERT INTO `modulo` (`id`, `text`, `pai`, `statusID`, `link`, `ordem`) VALUES
	(1, 'Vender', NULL, '1', '/internals/sell.php', 1),
	(15, 'Suporte', NULL, '1', NULL, 16),
	(17, 'Atendimento', 15, '1', '/internals/atendimento.php', 17),
	(18, 'Alterar Senha', 15, '1', '/internals/alterar_senha.php', 18);
/*!40000 ALTER TABLE `modulo` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.modulo_priv
CREATE TABLE IF NOT EXISTS `modulo_priv` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modulo_id` int(11) NOT NULL DEFAULT '0',
  `texto` varchar(50) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_modulo_priv_modulo` (`modulo_id`),
  CONSTRAINT `FK_modulo_priv_modulo` FOREIGN KEY (`modulo_id`) REFERENCES `modulo` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.modulo_priv: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `modulo_priv` DISABLE KEYS */;
/*!40000 ALTER TABLE `modulo_priv` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.pessoa
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
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.pessoa: ~45 rows (aproximadamente)
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
	(133, 'AT', 'F', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2017-11-01 07:58:04', '2017-11-01 07:58:04');
/*!40000 ALTER TABLE `pessoa` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.produto
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
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`),
  UNIQUE KEY `codbar_UNIQUE` (`codbar`),
  KEY `fk_produto_categoria1_idx` (`categoria_id`),
  KEY `fk_produto_unidade1_idx` (`unidade_id`),
  CONSTRAINT `fk_produto_categoria1` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto_unidade1` FOREIGN KEY (`unidade_id`) REFERENCES `unidade` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.produto: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` (`id`, `codigo`, `codbar`, `categoria_id`, `nome`, `descricao`, `valor`, `unidade_id`, `estoque_min`, `estoque`, `tem_estoque`, `active`) VALUES
	(2, '001', NULL, 2, 'Teste', NULL, 10.00, 1, 5, -101, 'n', 'y'),
	(3, '002', NULL, 2, 'Produto', NULL, 23.23, 1, 0, -105, 'n', 'y'),
	(4, '003', NULL, 2, 'Produto 3', NULL, 54.53, 1, 0, -48, 'n', 'y');
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.unidade
CREATE TABLE IF NOT EXISTS `unidade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) NOT NULL COMMENT 'label',
  `active` enum('y','n') NOT NULL DEFAULT 'y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.unidade: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` (`id`, `descricao`, `active`) VALUES
	(1, 'Unidade', 'y'),
	(2, 'Livre', 'y'),
	(3, 'Kg', 'y');
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.venda
CREATE TABLE IF NOT EXISTS `venda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) DEFAULT NULL,
  `desconto` double(7,2) DEFAULT '0.00',
  `total` decimal(7,2) DEFAULT NULL,
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('A','F','C') DEFAULT NULL COMMENT 'A = Aberta F = Fechada C = Cancelada',
  `comanda_mesa_id` int(11) DEFAULT NULL,
  `caixa_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_venda_pessoa1_idx` (`cliente_id`),
  KEY `FK_venda_comanda_mesa` (`comanda_mesa_id`),
  KEY `FK_venda_caixa` (`caixa_id`),
  CONSTRAINT `FK_venda_caixa` FOREIGN KEY (`caixa_id`) REFERENCES `caixa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_venda_comanda_mesa` FOREIGN KEY (`comanda_mesa_id`) REFERENCES `comanda_mesa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_venda_pessoa1` FOREIGN KEY (`cliente_id`) REFERENCES `pessoa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.venda: ~10 rows (aproximadamente)
/*!40000 ALTER TABLE `venda` DISABLE KEYS */;
INSERT INTO `venda` (`id`, `cliente_id`, `desconto`, `total`, `data`, `status`, `comanda_mesa_id`, `caixa_id`) VALUES
	(80, NULL, 0.00, 74.53, '2017-11-23 23:28:25', 'F', NULL, 33),
	(82, NULL, 0.00, NULL, '2017-11-23 23:29:42', NULL, NULL, 33),
	(83, NULL, 0.00, NULL, '2017-11-23 23:30:04', NULL, NULL, 33),
	(84, NULL, 0.00, NULL, '2017-11-23 23:30:21', NULL, NULL, 33),
	(85, NULL, 0.00, NULL, '2017-11-23 23:30:28', NULL, NULL, 33),
	(86, NULL, 0.00, NULL, '2017-11-23 23:31:06', NULL, NULL, 33),
	(89, NULL, 0.00, 10.00, '2017-11-23 23:34:27', 'F', NULL, 33),
	(90, NULL, 0.00, 33.23, '2017-11-23 23:34:47', 'F', NULL, 33),
	(91, NULL, 0.00, NULL, '2017-11-23 23:36:36', 'A', 1, 33),
	(92, NULL, 0.00, NULL, '2017-11-23 23:39:36', 'A', 2, 33);
/*!40000 ALTER TABLE `venda` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd.venda_pagto
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
  CONSTRAINT `FK_venda_pagto_venda` FOREIGN KEY (`venda_id`) REFERENCES `venda` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `venda_pagto_ibfk_1` FOREIGN KEY (`fisica_conta_id`) REFERENCES `fisica_conta` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela mm_bd.venda_pagto: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `venda_pagto` DISABLE KEYS */;
INSERT INTO `venda_pagto` (`id`, `venda_id`, `fisica_conta_id`, `forma_pagto_id`, `valor`) VALUES
	(13, 80, NULL, 1, 74.53),
	(17, 89, NULL, 1, 10.00),
	(18, 90, NULL, 1, 33.23);
/*!40000 ALTER TABLE `venda_pagto` ENABLE KEYS */;

-- Copiando estrutura para tabela mm_bd._user_
CREATE TABLE IF NOT EXISTS `_user_` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `token_change_password` varchar(100) NOT NULL,
  `dt_register` datetime DEFAULT CURRENT_TIMESTAMP,
  `dt_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- Copiando dados para a tabela mm_bd._user_: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `_user_` DISABLE KEYS */;
INSERT INTO `_user_` (`id`, `email`, `password`, `token_change_password`, `dt_register`, `dt_update`) VALUES
	(3, 'ulisses.bueno@gmail.com', '4297f44b13955235245b2497399d7a93', '955a49810b7685fdaeea6f008c33fcf7', '2017-06-09 21:29:18', '2017-10-27 13:00:11');
/*!40000 ALTER TABLE `_user_` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
