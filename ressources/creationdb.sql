CREATE DATABASE LVDELH;


USE LVDELH;


CREATE TABLE `hero` (
  `id_hero` int PRIMARY KEY,
  `page_id` int
);

CREATE TABLE `chapitre` (
  `id_chapitre` int PRIMARY KEY,
  `livre_id` int,
  `numero_chapitre` int,
  `nom_chapitre` varchar(50)
);

CREATE TABLE `page` (
  `id_page` int PRIMARY KEY,
  `livre_id` int,
  `numero_page` int,
  `chapitre_id` int,
  `texte` text
);

CREATE TABLE `livre` (
  `id_livre` int PRIMARY KEY,
  `titre` varchar(255),
  `prenom_auteur` varchar(255),
  `nom_auteur` varchar(255)
);

ALTER TABLE `page` ADD FOREIGN KEY (`chapitre_id`) REFERENCES `chapitre` (`id_chapitre`);

ALTER TABLE `hero` ADD FOREIGN KEY (`page_id`) REFERENCES `page` (`id_page`);

ALTER TABLE `chapitre` ADD FOREIGN KEY (`livre_id`) REFERENCES `livre` (`id_livre`);

ALTER TABLE `page` ADD FOREIGN KEY (`livre_id`) REFERENCES `livre` (`id_livre`);
