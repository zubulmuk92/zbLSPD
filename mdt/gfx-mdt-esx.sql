ALTER TABLE `users` ADD COLUMN `ranks` LONGTEXT NOT NULL;
	
CREATE TABLE IF NOT EXISTS `gfxmdt_appointment` (
  `id` varchar(50) NOT NULL,
  `date` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_appointment`;

CREATE TABLE IF NOT EXISTS `gfxmdt_avatars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_avatars`;

CREATE TABLE IF NOT EXISTS `gfxmdt_banlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `addedBy` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `ranks` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_banlist`;

CREATE TABLE IF NOT EXISTS `gfxmdt_department` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_department`;

CREATE TABLE IF NOT EXISTS `gfxmdt_fines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `jailTime` varchar(50) DEFAULT NULL,
  `jailType` varchar(50) DEFAULT NULL,
  `money` varchar(50) DEFAULT NULL,
  `lastEdited` varchar(50) DEFAULT NULL,
  `addedBy` varchar(50) DEFAULT NULL,
  `punishment` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_fines`;

CREATE TABLE IF NOT EXISTS `gfxmdt_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `text` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_notifications`;

CREATE TABLE IF NOT EXISTS `gfxmdt_offenders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `madeBy` varchar(50) DEFAULT NULL,
  `ranks` varchar(50) DEFAULT NULL,
  `reportText` varchar(50) DEFAULT NULL,
  `evidences` varchar(50) DEFAULT NULL,
  `fines` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_offenders`;

CREATE TABLE IF NOT EXISTS `gfxmdt_polices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `madeBy` varchar(50) DEFAULT NULL,
  `ranks` varchar(50) DEFAULT NULL,
  `reportText` varchar(50) DEFAULT NULL,
  `evidences` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_polices`;

CREATE TABLE IF NOT EXISTS `gfxmdt_records` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `text` varchar(50) DEFAULT NULL,
  `ranks` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `addedBy` varchar(50) DEFAULT NULL,
  `reportText` varchar(50) DEFAULT NULL,
  `offenders` varchar(50) DEFAULT NULL,
  `evidences` varchar(50) DEFAULT NULL,
  `polices` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_records`;

CREATE TABLE IF NOT EXISTS `gfxmdt_wanteds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `avatar` longtext DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `ranks` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `reportText` varchar(50) DEFAULT NULL,
  `addedBy` varchar(50) DEFAULT NULL,
  `evidences` longtext DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
DELETE FROM `gfxmdt_wanteds`;

CREATE TABLE IF NOT EXISTS `gloveboxitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(8) NOT NULL DEFAULT '[]',
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`plate`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DELETE FROM `gloveboxitems`;