-- MySQL Script generated by MySQL Workbench
-- 02/23/18 16:22:38
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema meuamigo
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema meuamigo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `meuamigo` DEFAULT CHARACTER SET latin1 ;
USE `meuamigo` ;

-- -----------------------------------------------------
-- Table `meuamigo`.`cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`cursos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`usuarios` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `telefone` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `email` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `nascimento` DATE NOT NULL,
  `tipo` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `senha` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `curso_id` INT(11) NOT NULL,
  `origem` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  `foto` BLOB NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `usuarios_curso_id_index` (`curso_id` ASC),
  CONSTRAINT `fk_usuarios_cursos1`
    FOREIGN KEY (`curso_id`)
    REFERENCES `meuamigo`.`cursos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`contatos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`contatos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario_local` INT(11) NOT NULL,
  `id_usuario_estrangeiro` INT(11) NOT NULL,
  `aceito` TINYINT(1) NOT NULL,
  `estrangeiroaceito` TINYINT(1) NOT NULL,
  `localaceito` TINYINT(1) NOT NULL,
  `notaestrangeiro` INT(11) NULL DEFAULT NULL,
  `notalocal` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contatos_usuarios_idx` (`id_usuario_local` ASC),
  INDEX `fk_contatos_usuarios1_idx` (`id_usuario_estrangeiro` ASC),
  CONSTRAINT `fk_contatos_usuarios`
    FOREIGN KEY (`id_usuario_local`)
    REFERENCES `meuamigo`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contatos_usuarios1`
    FOREIGN KEY (`id_usuario_estrangeiro`)
    REFERENCES `meuamigo`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 14
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`interesses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`interesses` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`linguas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`linguas` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(191) CHARACTER SET 'utf8mb4' NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`usuario_interesses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`usuario_interesses` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` INT(11) NOT NULL,
  `id_interesse` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_usuario_interesses_usuarios1_idx` (`id_usuario` ASC),
  INDEX `fk_usuario_interesses_interesses1_idx` (`id_interesse` ASC),
  CONSTRAINT `fk_usuario_interesses_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `meuamigo`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_interesses_interesses1`
    FOREIGN KEY (`id_interesse`)
    REFERENCES `meuamigo`.`interesses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `meuamigo`.`usuario_linguas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `meuamigo`.`usuario_linguas` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_usuario` INT(11) NOT NULL,
  `id_lingua` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_usuario_linguas_usuarios1_idx` (`id_usuario` ASC),
  INDEX `fk_usuario_linguas_linguas1_idx` (`id_lingua` ASC),
  CONSTRAINT `fk_usuario_linguas_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `meuamigo`.`usuarios` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_linguas_linguas1`
    FOREIGN KEY (`id_lingua`)
    REFERENCES `meuamigo`.`linguas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8mb4;

USE `meuamigo` ;

-- -----------------------------------------------------
-- function score
-- -----------------------------------------------------

DELIMITER $$
USE `meuamigo`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `score`(id1 INTEGER, id2 INTEGER) RETURNS int(11)
    READS SQL DATA
BEGIN
	declare qtd_interesses INTEGER;
    declare qtd_linguas INTEGER;
    SET qtd_interesses = (SELECT COUNT(DISTINCT(u2.id_interesse)) FROM usuario_interesses u1 JOIN usuario_interesses u2 ON u1.id_interesse = u2.id_interesse AND u1.id_usuario != u2.id_usuario WHERE (u1.id_usuario = id1 AND u2.id_usuario = id2) OR (u1.id_usuario = id2 AND u2.id_usuario = id1) );
    SET qtd_linguas = (SELECT COUNT(DISTINCT(u2.id_lingua)) FROM usuario_linguas u1 JOIN usuario_linguas u2 ON u1.id_lingua = u2.id_lingua AND u1.id_usuario != u2.id_usuario WHERE (u1.id_usuario = id1 AND u2.id_usuario = id2) OR (u1.id_usuario = id2 AND u2.id_usuario = id1) );
RETURN qtd_interesses + (qtd_linguas *2);
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
