-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-09-2024 a las 16:10:32
-- Versión del servidor: 10.4.25-MariaDB
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pruebacert`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `banco`
--

CREATE TABLE `banco` (
  `id_bc` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(20) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `banco`
--

INSERT INTO `banco` (`id_bc`, `nombre`) VALUES
(1, 'Banco Popular'),
(2, 'Banco Agrario'),
(3, 'Efecty'),
(4, 'Supergiros'),
(5, '4-72'),
(6, 'Matrix'),
(7, 'Banco de Bogota');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `departamentos` varchar(50) NOT NULL,
  `id_dp` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`departamentos`, `id_dp`) VALUES
('Amazonas', 1),
('Antioquia', 2),
('Arauca', 3),
('Atlántico', 4),
('Bolívar', 5),
('Boyacá', 6),
('Caldas', 7),
('Caquetá', 8),
('Casanare', 9),
('Cauca', 10),
('Cesar', 11),
('Chocó', 12),
('Córdoba', 13),
('Cundinamarca', 14),
('Guainía', 15),
('Guaviare', 16),
('Huila', 17),
('La Guajira', 18),
('Magdalena', 19),
('Meta', 20),
('Nariño', 21),
('Norte de Santander', 22),
('Putumayo', 23),
('Quindío', 24),
('Risaralda', 25),
('San Andrés y Providencia', 26),
('Santander', 27),
('Sucre', 28),
('Tolima', 29),
('Valle del Cauca', 30),
('Vaupés', 31),
('Vichada', 32),
('CAIC', 33),
('OPADI', 34),
('Agilizaciones', 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos`
--

CREATE TABLE `documentos` (
  `id_dc` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(25) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `documentos`
--

INSERT INTO `documentos` (`id_dc`, `nombre`) VALUES
(1, 'Registro Civil'),
(2, 'Cédula'),
(3, 'Tarjeta de indentidad');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `localidades`
--

CREATE TABLE `localidades` (
  `localidad` varchar(50) NOT NULL,
  `id_lc` int(25) NOT NULL,
  `id_dp` int(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `localidades`
--

INSERT INTO `localidades` (`localidad`, `id_lc`, `id_dp`) VALUES
('Usaquén', 1, NULL),
('Chapinero', 2, NULL),
('Santa Fe', 3, NULL),
('San Cristóbal', 4, NULL),
('Usme', 5, NULL),
('Tunjuelito', 6, NULL),
('Bosa', 7, NULL),
('Kennedy', 8, NULL),
('Fontibón', 9, NULL),
('Engativá', 10, NULL),
('Suba', 11, NULL),
('Barrios Unidos', 12, NULL),
('Teusaquillo', 13, NULL),
('Los Mártires', 14, NULL),
('Antonio Nariño', 15, NULL),
('Puente Aranda', 16, NULL),
('La Candelaria', 17, NULL),
('Rafael Uribe Uribe', 18, NULL),
('Ciudad Bolívar', 19, NULL),
('Sumapaz', 20, NULL),
('Engativá Centro', 21, NULL),
('Kennedy Américas', 22, NULL),
('Suba Sede 2 Tibabuyes', 23, NULL),
('Agilizaciones', 24, NULL),
('CAIC', 25, NULL),
('OPADI', 26, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `motivoautorizacion`
--

CREATE TABLE `motivoautorizacion` (
  `id_mt` int(11) NOT NULL,
  `nombre` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `motivoautorizacion`
--

INSERT INTO `motivoautorizacion` (`id_mt`, `nombre`) VALUES
(1, 'Perdida de la consignación'),
(2, 'Error de digitación en N. Docu'),
(3, 'Consignación cliente'),
(4, 'Autorización años pasados'),
(5, 'Consignación deteriorada ');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oficios`
--

CREATE TABLE `oficios` (
  `id` int(11) NOT NULL,
  `fechaTramite` datetime DEFAULT NULL,
  `numeroFolio` int(10) UNSIGNED DEFAULT NULL,
  `numeroDocumento` bigint(20) DEFAULT NULL,
  `nombre` varchar(60) COLLATE utf8_spanish_ci DEFAULT NULL,
  `fechaConsignacion` date DEFAULT NULL,
  `valorConsignacion` decimal(50,2) DEFAULT NULL,
  `docCompleta` tinyint(4) DEFAULT NULL,
  `codigoUnico` varchar(15) COLLATE utf8_spanish_ci DEFAULT NULL,
  `archivoPlano` text COLLATE utf8_spanish_ci DEFAULT NULL,
  `observacion` text COLLATE utf8_spanish_ci DEFAULT NULL,
  `id_dp` int(25) DEFAULT NULL,
  `id_lc` int(25) DEFAULT NULL,
  `id_dc` int(10) UNSIGNED NOT NULL,
  `id_bc` int(10) UNSIGNED NOT NULL,
  `id_mt` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `id_val` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `oficios`
--

INSERT INTO `oficios` (`id`, `fechaTramite`, `numeroFolio`, `numeroDocumento`, `nombre`, `fechaConsignacion`, `valorConsignacion`, `docCompleta`, `codigoUnico`, `archivoPlano`, `observacion`, `id_dp`, `id_lc`, `id_dc`, `id_bc`, `id_mt`, `idUser`, `id_val`) VALUES
(5, NULL, NULL, 1234567, 'Diego Quiñones', '2024-09-11', '49350.00', 0, NULL, NULL, 'asdkjfkaljsdhflkjasd', 7, NULL, 2, 2, 3, 12, 1),
(6, NULL, NULL, 1234567, 'Diego Quiñones', '2024-09-11', '48400.00', NULL, NULL, 'sdfgdbgsfdg', 'sdakjfhsañdlkjflsdak', 5, NULL, 3, 7, 2, 12, 2),
(7, '2024-09-11 15:27:37', NULL, 1234567546, 'Diego Quiñones', '2024-09-11', '8000.00', 1, NULL, 'jejejejejejejeje', ':c', 7, NULL, 1, 6, 1, 12, 5),
(8, '2024-09-11 15:30:18', NULL, 1234567546, 'Diego Quiñones', '2024-09-11', '49350.00', 1, NULL, 'sjdkhfsjkld', 'fs-lkgjñdlska', 7, NULL, 2, 3, 3, 12, 4),
(9, '2024-09-11 15:31:13', NULL, 1234567546456, 'Diego Quiñones', '2024-09-11', '48400.00', 1, NULL, 'zdlksjfklds', 'sldkfjjkdfg', 15, NULL, 3, 3, 3, 12, 3),
(13, '2024-09-12 14:43:58', NULL, 1234567, 'Diego Quiñones', '2024-09-12', '49350.00', 1, NULL, 'sdlkfjklasjdflkñjsad', 'sdkljflñkasdjflksd', NULL, 13, 2, 2, 5, 12, 6),
(14, '2024-09-12 14:45:38', NULL, 1234567546, NULL, '2024-09-12', '49350.00', 1, NULL, 'sdkljflksd', '-,dflknglskñd', 10, NULL, 2, 3, 3, 12, 5),
(15, '2024-09-12 14:46:39', NULL, 1234567, 'si', '2024-09-12', '48400.00', 1, NULL, 'skljfdñlskd', 'sa-dklfjñisadlf', 10, NULL, 3, 3, 3, 12, 4),
(16, '2024-09-16 09:11:35', 1, 1019234989, 'traste', '2024-09-16', '49350.00', 1, NULL, 'sdjkhflsadjflñksadjflñka', 'sdjflasdjflñsadkjfñlkasd', 6, NULL, 2, 3, 3, 12, 5),
(18, '2024-09-16 11:35:06', 2, 1019234989, 'si', '2024-09-16', '48400.00', 1, NULL, 'k', NULL, NULL, 8, 3, 1, 5, 12, NULL),
(20, '2024-09-17 11:09:21', 3, 1234567546, 'diego jeje A', '2024-09-17', '49350.00', 1, NULL, 'sldkjfñlksd', 'dskfgsñdfmls trate', 11, NULL, 2, 3, 2, 12, 4),
(21, '2024-09-17 14:31:19', 4, 1019234989, 'jmm', '2024-09-17', '8000.00', 1, NULL, 'jeje', 'que es cordoba', 13, NULL, 1, 6, 3, 12, 3),
(22, '2024-09-18 14:40:27', 5, 1234567546, 'traste', '2024-09-18', '49350.00', 1, NULL, 'asdasf', 'aslfdksladkfl', NULL, 10, 2, 5, 4, 12, 5),
(24, '2024-09-19 14:59:33', 6, 1019234989, 'traste si', '2024-09-19', '49350.00', 1, NULL, 'asdfadsfads', 'jdejdasdjwe', 7, NULL, 2, 5, 2, 12, 5),
(25, '2024-09-20 10:18:01', 7, 1019234989, 'f', '2024-09-20', '48400.00', 1, NULL, 'añskdljfñalskdjf', 'choco\r\n', 12, NULL, 3, 3, 3, 12, 5),
(34, '2024-09-24 15:52:22', 8, 1234567546, 'traste', '2024-09-24', '49350.00', 1, NULL, 'jasdhfaslñdjfñlkasdjf', 'chocoooo', 12, NULL, 2, 4, 3, 12, 5),
(36, '2024-09-24 16:00:03', 9, 1019234989, 'traste', '2024-09-24', '8000.00', 1, NULL, 'asjdhfñalsdfj', 'que es arauca', 3, NULL, 1, 6, 2, 12, 3),
(38, '2024-09-24 16:02:47', 10, 1234567546, 'ayuda', '2024-09-24', '48400.00', 1, NULL, 'nOficionOficionOficionOficionOficio', 'q asco', 4, NULL, 3, 3, 4, 12, 6),
(39, '2024-09-24 16:04:48', 11, 999999, 'ayuda', '2024-09-24', '49350.00', 1, NULL, 'jfklasdñlkfjsdl', 'choco mano', 12, NULL, 2, 4, 2, 12, 4),
(40, '2024-09-24 16:06:05', 12, 1234567546, 'ayuda', '2024-09-24', '48400.00', 1, NULL, 'lsdjfñlasdkf', 'caqueta socio', 7, NULL, 3, 5, 4, 12, 5),
(41, '2024-09-24 16:10:49', 13, 1234567546, 'traste', '2024-09-24', '48400.00', 1, NULL, 'skjdhfksdjañhflkasd', 'jmmm', 3, NULL, 3, 5, 4, 12, 3),
(43, '2024-09-24 16:17:19', 14, 999999, 'ayuda', '2024-09-24', '48400.00', 1, NULL, 'adsklfjañlksdfjlkasd', '4-20', 9, NULL, 3, 5, 3, 12, 5),
(44, '2024-09-24 16:19:06', 15, 1019234989, 'ayuda', '2024-09-24', '49350.00', 1, NULL, 'ayuda', 'ayuda', 16, NULL, 2, 4, 2, 12, 4),
(45, '2024-09-24 16:23:49', 16, 1234567546, 'ayudaa pto', '2024-09-24', '49350.00', 1, NULL, 'ayudaa pto', 'ayudaa pto', 12, NULL, 2, 2, 3, 12, 6),
(46, '2024-09-24 16:28:22', 17, 1234567546, 'gogogog', '2024-09-24', '49350.00', 1, NULL, 'gogogog', 'gogogogo', 15, NULL, 2, 1, 2, 12, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idUser` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8_spanish_ci DEFAULT NULL,
  `contraseña` char(40) COLLATE utf8_spanish_ci DEFAULT NULL,
  `estado` enum('A','I') COLLATE utf8_spanish_ci NOT NULL,
  `usuario` varchar(20) COLLATE utf8_spanish_ci NOT NULL,
  `correo` varchar(40) COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idUser`, `nombre`, `contraseña`, `estado`, `usuario`, `correo`) VALUES
(12, 'Diego Quiñones', '0738d7546800c24511bd5038a806c84471637739', 'A', 'daquinones', 'daquinones@registraduria.gov.co'),
(13, 'Jefe1', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 'A', 'admin', 'jefe@registraduria.gov.co'),
(14, 'Bryan Muñoz', '4143cdb2f4caf4aaef356b245734f26f81b66a69', 'A', 'bfmunoz', 'bfmunoz@reistraduria.gov.co'),
(18, 'asd', '099953225020ef4477450cb6c0ca8e8586a18b03', 'I', 'asd', 'asd@registraduria.gov.co'),
(19, 'bryan', 'b04245f2b1cfc55d2e134c8d498244c702327321', 'I', 'fbmunoz', 'fa@registraduria.gov.co');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `validaciondocumentos`
--

CREATE TABLE `validaciondocumentos` (
  `id_val` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(30) COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci;

--
-- Volcado de datos para la tabla `validaciondocumentos`
--

INSERT INTO `validaciondocumentos` (`id_val`, `nombre`) VALUES
(1, 'Defunción'),
(2, 'Fotocopia de Identidad'),
(3, 'Consignación Original'),
(4, 'Verificación ANI'),
(5, 'Verificación Archivo Plano'),
(6, 'Fecha Consignación'),
(7, 'Documentación Completa');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `banco`
--
ALTER TABLE `banco`
  ADD PRIMARY KEY (`id_bc`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`id_dp`);

--
-- Indices de la tabla `documentos`
--
ALTER TABLE `documentos`
  ADD PRIMARY KEY (`id_dc`);

--
-- Indices de la tabla `localidades`
--
ALTER TABLE `localidades`
  ADD PRIMARY KEY (`id_lc`),
  ADD KEY `id_dp` (`id_dp`);

--
-- Indices de la tabla `motivoautorizacion`
--
ALTER TABLE `motivoautorizacion`
  ADD PRIMARY KEY (`id_mt`);

--
-- Indices de la tabla `oficios`
--
ALTER TABLE `oficios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_dp` (`id_dp`),
  ADD KEY `id_lc` (`id_lc`),
  ADD KEY `id_dc` (`id_dc`),
  ADD KEY `id_bc` (`id_bc`),
  ADD KEY `id_mt` (`id_mt`),
  ADD KEY `idUser` (`idUser`),
  ADD KEY `id_val` (`id_val`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idUser`);

--
-- Indices de la tabla `validaciondocumentos`
--
ALTER TABLE `validaciondocumentos`
  ADD PRIMARY KEY (`id_val`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `banco`
--
ALTER TABLE `banco`
  MODIFY `id_bc` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id_dp` int(25) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `documentos`
--
ALTER TABLE `documentos`
  MODIFY `id_dc` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `localidades`
--
ALTER TABLE `localidades`
  MODIFY `id_lc` int(25) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `motivoautorizacion`
--
ALTER TABLE `motivoautorizacion`
  MODIFY `id_mt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `oficios`
--
ALTER TABLE `oficios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `validaciondocumentos`
--
ALTER TABLE `validaciondocumentos`
  MODIFY `id_val` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `localidades`
--
ALTER TABLE `localidades`
  ADD CONSTRAINT `localidades_ibfk_1` FOREIGN KEY (`id_dp`) REFERENCES `departamentos` (`id_dp`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `oficios`
--
ALTER TABLE `oficios`
  ADD CONSTRAINT `oficios_ibfk_1` FOREIGN KEY (`id_dp`) REFERENCES `departamentos` (`id_dp`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_2` FOREIGN KEY (`id_lc`) REFERENCES `localidades` (`id_lc`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_3` FOREIGN KEY (`id_dc`) REFERENCES `documentos` (`id_dc`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_4` FOREIGN KEY (`id_val`) REFERENCES `validaciondocumentos` (`id_val`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_5` FOREIGN KEY (`id_bc`) REFERENCES `banco` (`id_bc`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_6` FOREIGN KEY (`idUser`) REFERENCES `usuarios` (`idUser`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `oficios_ibfk_7` FOREIGN KEY (`id_mt`) REFERENCES `motivoautorizacion` (`id_mt`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
