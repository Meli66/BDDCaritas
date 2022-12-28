-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE =
        'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema caritas
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema caritas
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `caritas` DEFAULT CHARACTER SET utf8;
USE `caritas`;

-- -----------------------------------------------------
-- Table `caritas`.`alimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`alimento`
(
    `id_alimento`   SMALLINT(5) UNSIGNED                 NOT NULL AUTO_INCREMENT,
    `tipo_alimento` ENUM ('PERECEDERO', 'NO_PERECEDERO') NOT NULL,
    PRIMARY KEY (`id_alimento`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_alimento` ON `caritas`.`alimento` (`id_alimento` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`comida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`comida`
(
    `id_comida`   SMALLINT(5) UNSIGNED                  NOT NULL AUTO_INCREMENT,
    `fecha`       DATE                                  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `tipo_comida` ENUM ('DESAYUNO', 'ALMUERZO', 'CENA') NOT NULL,
    PRIMARY KEY (`id_comida`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_comida` ON `caritas`.`comida` (`id_comida` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`grupo_familiar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`grupo_familiar`
(
    `id_grupo_familiar` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id_grupo_familiar`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_grupo_familiar` ON `caritas`.`grupo_familiar` (`id_grupo_familiar` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`persona_asistida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`persona_asistida`
(
    `id_persona_asistida` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre`              VARCHAR(15)          NOT NULL,
    `apellido`            VARCHAR(15)          NOT NULL,
    `dni`                 VARCHAR(15)          NOT NULL,
    `fecha_nacimiento`    DATE                 NOT NULL,
    `id_grupo_familiar`   SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_persona_asistida`),
    FOREIGN KEY (`id_grupo_familiar`) REFERENCES `caritas`.`grupo_familiar` (`id_grupo_familiar`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_persona_asistida` ON `caritas`.`persona_asistida` (`id_persona_asistida` ASC);

CREATE INDEX `fk_persona_damnificada_grupo_familiar1_idx` ON `caritas`.`persona_asistida` (`id_grupo_familiar` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`comida_persona_asistida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`comida_persona_asistida`
(
    `id_comida`           SMALLINT(5) UNSIGNED NOT NULL,
    `id_persona_asistida` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_comida`) REFERENCES `caritas`.`comida` (`id_comida`),
    FOREIGN KEY (`id_persona_asistida`) REFERENCES `caritas`.`persona_asistida` (`id_persona_asistida`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_comedor_persona_damnificada_comedor1_idx` ON `caritas`.`comida_persona_asistida` (`id_comida` ASC);

CREATE INDEX `fk_comedor_persona_damnificada_persona_damnificada1_idx` ON `caritas`.`comida_persona_asistida` (`id_persona_asistida` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`curso_formacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`curso_formacion`
(
    `id_curso_formacion` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `nombre_curso`       VARCHAR(45)          NOT NULL,
    `cupo_maximo`        TINYINT(4)           NOT NULL DEFAULT 15,
    `horario`            TIME                 NOT NULL,
    PRIMARY KEY (`id_curso_formacion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_curso_formacion` ON `caritas`.`curso_formacion` (`id_curso_formacion` ASC);

CREATE INDEX `fk_curso_formacion_curso_formacion1_idx` ON `caritas`.`curso_formacion` (`id_curso_formacion` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`curso_persona_asistida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`curso_persona_asistida`
(
    `id_curso_formacion`  SMALLINT(5) UNSIGNED NOT NULL,
    `id_persona_asistida` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_curso_formacion`) REFERENCES `caritas`.`curso_formacion` (`id_curso_formacion`),
    FOREIGN KEY (`id_persona_asistida`) REFERENCES `caritas`.`persona_asistida` (`id_persona_asistida`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_curso_peersona_damnificada_curso_formacion1_idx` ON `caritas`.`curso_persona_asistida` (`id_curso_formacion` ASC);

CREATE INDEX `fk_curso_peersona_damnificada_persona_damnificada1_idx` ON `caritas`.`curso_persona_asistida` (`id_persona_asistida` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`persona`
(
    `id_persona`       SMALLINT(5) UNSIGNED                       NOT NULL AUTO_INCREMENT,
    `nombre`           VARCHAR(15)                                NOT NULL,
    `apellido`         VARCHAR(15)                                NOT NULL,
    `dni`              VARCHAR(10)                                NOT NULL,
    `fecha_nacimiento` DATE                                       NOT NULL,
    `tipo`             ENUM ('VOLUNTARIO', 'DONANTE', 'PROFESOR') NOT NULL,
    `telefono`         VARCHAR(15)                                NULL DEFAULT NULL,
    `email`            VARCHAR(30)                                NULL DEFAULT NULL,
    PRIMARY KEY (`id_persona`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_profesor` ON `caritas`.`persona` (`id_persona` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`curso_profesor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`curso_profesor`
(
    `id_profesor`        SMALLINT(5) UNSIGNED NOT NULL,
    `id_curso_formacion` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_profesor`) REFERENCES `caritas`.`persona` (`id_persona`),
    FOREIGN KEY (`id_curso_formacion`) REFERENCES `caritas`.`curso_formacion` (`id_curso_formacion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `id_curso_formacion` ON `caritas`.`curso_profesor` (`id_curso_formacion` ASC);

CREATE INDEX `fk_curso_profesor_profesor1_idx` ON `caritas`.`curso_profesor` (`id_profesor` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal`
(
    `id_sucursal` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id_sucursal`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_sucursal` ON `caritas`.`sucursal` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_tesoreria1_idx` ON `caritas`.`sucursal` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_persona_voluntaria_sucursal1_idx` ON `caritas`.`sucursal` (`id_sucursal` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`curso_sucursal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`curso_sucursal`
(
    `id_sucursal`        SMALLINT(5) UNSIGNED NOT NULL,
    `id_curso_formacion` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`),
    FOREIGN KEY (`id_curso_formacion`) REFERENCES `caritas`.`curso_formacion` (`id_curso_formacion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sucursal_curso_sucursal1_idx` ON `caritas`.`curso_sucursal` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_curso_curso_formacion1_idx` ON `caritas`.`curso_sucursal` (`id_curso_formacion` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`direccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`direccion`
(
    `id_direccion` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `calle`        VARCHAR(30)          NOT NULL,
    `altura`       SMALLINT(6)          NOT NULL,
    `barrio`       VARCHAR(30)          NOT NULL,
    `piso`         TINYINT(4)           NULL DEFAULT NULL,
    `otro`         VARCHAR(30)          NULL DEFAULT NULL,
    PRIMARY KEY (`id_direccion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_direccion` ON `caritas`.`direccion` (`id_direccion` ASC);

CREATE INDEX `fk_direccion_persona_voluntaria_direccion1_idx` ON `caritas`.`direccion` (`id_direccion` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`tesoreria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`tesoreria`
(
    `id_tesoreria` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `caja`         FLOAT                NOT NULL,
    `id_sucursal`  SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_tesoreria`),
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_tesoreria` ON `caritas`.`tesoreria` (`id_tesoreria` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`remedio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`remedio`
(
    `id_remedio`      SMALLINT(5) UNSIGNED              NOT NULL AUTO_INCREMENT,
    `tipo_de_remedio` ENUM ('CON_RESETA', 'SIN_RECETA') NOT NULL,
    PRIMARY KEY (`id_remedio`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_remedio` ON `caritas`.`remedio` (`id_remedio` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`donante_detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`donante_detalle`
(
    `id_donante_detalle` SMALLINT UNSIGNED                      NOT NULL UNIQUE AUTO_INCREMENT,
    `monto`              FLOAT                                  NOT NULL,
    `fecha`              DATE                                   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `detalle`            ENUM ('ALIMENTO', 'REMEDIO', 'DINERO') NOT NULL,
    `id_tesoreria`       SMALLINT(5) UNSIGNED                   NOT NULL,
    `id_persona`         SMALLINT(5) UNSIGNED                   NOT NULL,
    `id_alimento`        SMALLINT(5) UNSIGNED                   NOT NULL,
    `id_remedio`         SMALLINT(5) UNSIGNED                   NOT NULL,
    PRIMARY KEY (`id_donante_detalle`),
    FOREIGN KEY (`id_tesoreria`) REFERENCES `caritas`.`tesoreria` (`id_tesoreria`),
    FOREIGN KEY (`id_persona`) REFERENCES `caritas`.`persona` (`id_persona`),
    FOREIGN KEY (`id_alimento`) REFERENCES `caritas`.`alimento` (`id_alimento`),
    FOREIGN KEY (`id_remedio`) REFERENCES `caritas`.`remedio` (`id_remedio`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_donante_dinero_dinero_donante1_idx` ON `caritas`.`donante_detalle` (`id_tesoreria` ASC);

CREATE INDEX `fk_donante_dinero_persona1_idx` ON `caritas`.`donante_detalle` (`id_persona` ASC);

CREATE INDEX `fk_donante_detalle_alimento1_idx` ON `caritas`.`donante_detalle` (`id_alimento` ASC);

CREATE INDEX `fk_donante_detalle_remedio1_idx` ON `caritas`.`donante_detalle` (`id_remedio` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`entrega`
(
    `id_entrega` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `fecha`      DATE                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_entrega`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_entrega` ON `caritas`.`entrega` (`id_entrega` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`entrega_alimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`entrega_alimento`
(
    `id_entrega_alimento` SMALLINT UNSIGNED    NOT NULL UNIQUE AUTO_INCREMENT,
    `cantidad`            TINYINT(4)           NOT NULL,
    `id_alimento`         SMALLINT(5) UNSIGNED NOT NULL,
    `id_entrega`          SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_entrega_alimento`),
    FOREIGN KEY (`id_alimento`) REFERENCES `caritas`.`alimento` (`id_alimento`),
    FOREIGN KEY (`id_entrega`) REFERENCES `caritas`.`entrega` (`id_entrega`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_entrega_alimento_alimento1_idx` ON `caritas`.`entrega_alimento` (`id_alimento` ASC);

CREATE INDEX `fk_entrega_alimento_entrega1_idx` ON `caritas`.`entrega_alimento` (`id_entrega` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`entrega_grupo_familiar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`entrega_grupo_familiar`
(
    `id_entrega`        SMALLINT(5) UNSIGNED NOT NULL,
    `id_grupo_familiar` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_entrega`) REFERENCES `caritas`.`entrega` (`id_entrega`),
    FOREIGN KEY (`id_grupo_familiar`) REFERENCES `caritas`.`grupo_familiar` (`id_grupo_familiar`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_entrega_grupo_familiar_entrega1_idx` ON `caritas`.`entrega_grupo_familiar` (`id_entrega` ASC);

CREATE INDEX `fk_entrega_grupo_familiar_grupo_familiar1_idx` ON `caritas`.`entrega_grupo_familiar` (`id_grupo_familiar` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`gasto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`gasto`
(
    `id_gasto` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `detalle`  VARCHAR(45)          NOT NULL,
    `monto`    FLOAT                NOT NULL,
    PRIMARY KEY (`id_gasto`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_gasto` ON `caritas`.`gasto` (`id_gasto` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`grupo_familiar_direccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`grupo_familiar_direccion`
(
    `id_direccion`      SMALLINT(5) UNSIGNED NOT NULL,
    `id_grupo_familiar` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_direccion`) REFERENCES `caritas`.`direccion` (`id_direccion`),
    FOREIGN KEY (`id_grupo_familiar`) REFERENCES `caritas`.`grupo_familiar` (`id_grupo_familiar`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_grupo_familiar_direccion_direccion1_idx` ON `caritas`.`grupo_familiar_direccion` (`id_direccion` ASC);

CREATE INDEX `fk_grupo_familiar_direccion_grupo_familiar1_idx` ON `caritas`.`grupo_familiar_direccion` (`id_grupo_familiar` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`personar_direccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`personar_direccion`
(
    `id_persona`   SMALLINT(5) UNSIGNED NOT NULL,
    `id_direccion` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_persona`) REFERENCES `caritas`.`persona` (`id_persona`),
    FOREIGN KEY (`id_direccion`) REFERENCES `caritas`.`direccion` (`id_direccion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_profesor_direccion_profesor1_idx` ON `caritas`.`personar_direccion` (`id_persona` ASC);

CREATE INDEX `fk_profesor_direccion_direccion1_idx` ON `caritas`.`personar_direccion` (`id_direccion` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal_alimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal_alimento`
(
    `id_sucursal_alimento` SMALLINT UNSIGNED    NOT NULL UNIQUE AUTO_INCREMENT,
    `stock`                TINYINT(4)           NOT NULL DEFAULT 0,
    `id_alimento`          SMALLINT(5) UNSIGNED NOT NULL,
    `id_sucursal`          SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_sucursal_alimento`),
    FOREIGN KEY (`id_alimento`) REFERENCES `caritas`.`alimento` (`id_alimento`),
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sucursal_alimento_alimento1_idx` ON `caritas`.`sucursal_alimento` (`id_alimento` ASC);

CREATE INDEX `fk_sucursal_alimento_sucursal1_idx` ON `caritas`.`sucursal_alimento` (`id_sucursal` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal_comida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal_comida`
(
    `id_sucursal` SMALLINT(5) UNSIGNED NOT NULL,
    `id_comida`   SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`),
    FOREIGN KEY (`id_comida`) REFERENCES `caritas`.`comida` (`id_comida`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sucursal_comida_sucursal1_idx` ON `caritas`.`sucursal_comida` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_comida_comida1_idx` ON `caritas`.`sucursal_comida` (`id_comida` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal_direccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal_direccion`
(
    `id_sucursal`  SMALLINT(5) UNSIGNED NOT NULL,
    `id_direccion` SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`),
    FOREIGN KEY (`id_direccion`) REFERENCES `caritas`.`direccion` (`id_direccion`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sucursal_direccion_sucursal1_idx` ON `caritas`.`sucursal_direccion` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_direccion_direccion1_idx` ON `caritas`.`sucursal_direccion` (`id_direccion` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal_persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal_persona`
(
    `id_sucursal` SMALLINT(5) UNSIGNED NOT NULL,
    `id_persona`  SMALLINT(5) UNSIGNED NOT NULL,
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`),
    FOREIGN KEY (`id_persona`) REFERENCES `caritas`.`persona` (`id_persona`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `id_sucursal` ON `caritas`.`sucursal_persona` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_persona_voluntaria_persona1_idx` ON `caritas`.`sucursal_persona` (`id_persona` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`sucursal_remedio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`sucursal_remedio`
(
    `id_sucursal_remedio` SMALLINT UNSIGNED    NOT NULL UNIQUE AUTO_INCREMENT,
    `stock`               TINYINT(4)           NOT NULL,
    `id_sucursal`         SMALLINT(5) UNSIGNED NOT NULL,
    `id_remedio`          SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_sucursal_remedio`),
    FOREIGN KEY (`id_sucursal`) REFERENCES `caritas`.`sucursal` (`id_sucursal`),
    FOREIGN KEY (`id_remedio`) REFERENCES `caritas`.`remedio` (`id_remedio`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_sucursal_remedio_sucursal1_idx` ON `caritas`.`sucursal_remedio` (`id_sucursal` ASC);

CREATE INDEX `fk_sucursal_remedio_remedio1_idx` ON `caritas`.`sucursal_remedio` (`id_remedio` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`tarea`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`tarea`
(
    `id_tarea`   SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    `detalle`    VARCHAR(45)          NOT NULL,
    `id_persona` SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_tarea`),
    FOREIGN KEY (`id_persona`) REFERENCES `caritas`.`persona` (`id_persona`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `id_tarea` ON `caritas`.`tarea` (`id_tarea` ASC);

CREATE INDEX `fk_tarea_persona1_idx` ON `caritas`.`tarea` (`id_persona` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`tesoreria_gasto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`tesoreria_gasto`
(
    `id_tesoreria_gasto` SMALLINT UNSIGNED    NOT NULL UNIQUE AUTO_INCREMENT,
    `fecha_gasto`        DATE                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `motivo`             VARCHAR(45)          NOT NULL,
    `id_tesoreria`       SMALLINT(5) UNSIGNED NOT NULL,
    `id_gasto`           SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_tesoreria_gasto`),
    FOREIGN KEY (`id_tesoreria`) REFERENCES `caritas`.`tesoreria` (`id_tesoreria`),
    FOREIGN KEY (`id_gasto`) REFERENCES `caritas`.`gasto` (`id_gasto`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_tesoreria_gasto_tesoreria1_idx` ON `caritas`.`tesoreria_gasto` (`id_tesoreria` ASC);

CREATE INDEX `fk_tesoreria_gasto_gasto1_idx` ON `caritas`.`tesoreria_gasto` (`id_gasto` ASC);


-- -----------------------------------------------------
-- Table `caritas`.`tesoreria_persona_voluntaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `caritas`.`tesoreria_persona`
(
    `id_tesoreria_persona` SMALLINT UNSIGNED    NOT NULL UNIQUE AUTO_INCREMENT,
    `fecha_inicio`         DATE                 NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `fecha_fin`            DATE                 NOT NULL,
    `id_tesoreria`         SMALLINT(5) UNSIGNED NOT NULL,
    `id_persona`           SMALLINT(5) UNSIGNED NOT NULL,
    PRIMARY KEY (`id_tesoreria_persona`),
    FOREIGN KEY (`id_tesoreria`) REFERENCES `caritas`.`tesoreria` (`id_tesoreria`),
    FOREIGN KEY (`id_persona`) REFERENCES `caritas`.`persona` (`id_persona`)
)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_tesoreria_persona_tesoreria1_idx` ON `caritas`.`tesoreria_persona` (`id_tesoreria` ASC);

CREATE INDEX `fk_tesoreria_persona_persona1_idx` ON `caritas`.`tesoreria_persona` (`id_persona` ASC);


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
-- drop database caritas