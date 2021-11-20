/*
* Fichier: creationdb.sql
* Auteurs: Félix Michaud, Vincent Bélisle, Maxime Boucher
* Date: 08 novembre 2021,
* Description: Création de la base de données LDVELH et de son user.
*/

CREATE DATABASE LDVELH;

USE LDVELH;

# Création des tables de la bd.
SET page_lue = 0; 


CREATE TABLE `hero` (
  `id_hero` int PRIMARY KEY,
  `vie` int,
  `endurance` int,
  `equipement` varchar(255)
);

CREATE TABLE `fiche_personnage` (
  `hero_id` int,
  `vie` int,
  `endurance` int,
  `equipement` varchar(255)
);

CREATE TABLE `chapitre` (
  `id_chapitre` int PRIMARY KEY AUTO_INCREMENT,
  `numero_chapitre` int,
  `texte` text
  
);

CREATE TABLE `livre` (
  `id_livre` int PRIMARY KEY,
  `titre` varchar(255),
  `prenom_auteur` varchar(255),
  `nom_auteur` varchar(255)
);


ALTER TABLE `hero` ADD FOREIGN KEY (`id_hero`) REFERENCES `livre` (`id_livre`);

ALTER TABLE `fiche_personnage` ADD FOREIGN KEY (`hero_id`) REFERENCES `hero` (`id_hero`);


# Création de l'usager pour la bd.
CREATE USER 'hero'@'localhost' IDENTIFIED BY 'hero';
GRANT SELECT, UPDATE, INSERT ON ldvelh.* TO 'hero'@'localhost';

DELIMITER $$
CREATE FUNCTION dee() RETURNS INT NO SQL
BEGIN
	DECLARE dee_aleatoire INT; 
	SET dee_aleatoire = FLOOR(RAND()*(7-1)+1);
	RETURN dee_aleatoire;
END $$
DELIMITER ; 

DELIMITER $$
CREATE FUNCTION calcul_vie(perte_vie INT, id_hero INT) RETURNS INT READS SQL DATA DETERMINISTIC
BEGIN
DECLARE vie_personnage INT; 
SET vie_personnage = (SELECT vie FROM hero WHERE id_hero = id_hero);

RETURN vie_personnage = perte_vie; 
END $$
DELIMITER ;

DELIMITER $$ 
CREATE TRIGGER gestion_point_vie AFTER UPDATE ON hero FOR EACH ROW

BEGIN
	if vie <= 0 THEN
		SET vivant = 0; 
	END IF 
END $
DELIMITER ;

DELIMITER $$
CREATE TRIGGER suivi_page_lue AFTER UPDATE ON session FOR EACH ROW
BEGIN
	IF !(NEW.chapitre_id <=> OLD.chapitre_id) THEN 
		hero.page_lue = hero.page_lue +1; 
	END IF
END $
DELIMITER ; 

SELECT page_lue; 

