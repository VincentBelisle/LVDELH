/*
* Fichier: creationdb.sql
* Auteurs: Félix Michaud, Vincent Bélisle, Maxime Boucher
* Date: 08 novembre 2021,
* Description: Création de la base de données LDVELH et de son user.
*/
DROP DATABASE LDVELH; 
CREATE DATABASE LDVELH;
USE LDVELH;

CREATE TABLE `hero` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `nom` varchar(255),
  `page_lue` int	
);

CREATE TABLE `fiche_personnage` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `session_id` int,
  `vie` int,
  `endurance` int,
  `sac_a_dos_id` int,
  `aventure_id` int
);

CREATE TABLE `aventure` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `discipline_1` varchar(255),
  `discipline_2` varchar(255),
  `discipline_3` varchar(255),
  `discipline_4` varchar(255),
  `discipline_5` varchar(255),
  `arme` varchar(255)
);

CREATE TABLE `sac_a_dos` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `objet_1` varchar(255),
  `objet_2` varchar(255),
  `objet_3` varchar(255),
  `objet_4` varchar(255),
  `objet_5` varchar(255),
  `objet_6` varchar(255),
  `objet_7` varchar(255),
  `objet_8` varchar(255),
  `repas` varchar(255),
  `argent` int
);

CREATE TABLE `chapitre` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `livre_id` int,
  `numero_chapitre` int,
  `texte` text
);

CREATE TABLE `livre` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `titre` varchar(255),
  `prenom_auteur` varchar(255),
  `nom_auteur` varchar(255)
);

CREATE TABLE `session` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `hero_id` int,
  `chapitre_id` int,
  `nom` varchar(255)
);

ALTER TABLE `session` ADD FOREIGN KEY (`hero_id`) REFERENCES `hero` (`id`);

ALTER TABLE `fiche_personnage` ADD FOREIGN KEY (`session_id`) REFERENCES `session` (`id`);

ALTER TABLE `session` ADD FOREIGN KEY (`chapitre_id`) REFERENCES  `chapitre` (`id`);

ALTER TABLE `chapitre` ADD FOREIGN KEY (`livre_id`) REFERENCES `livre` (`id`);

ALTER TABLE `fiche_personnage` ADD FOREIGN KEY  (`sac_a_dos_id`) REFERENCES `sac_a_dos` (`id`);

ALTER TABLE `fiche_personnage`  ADD FOREIGN KEY  (`aventure_id`) REFERENCES `aventure`(`id`);

# Insertion initiales
INSERT INTO livre (titre,prenom_auteur,nom_auteur)
VALUES ("Les-maitres-des-tenebres","Jean","Bozo");

INSERT INTO hero (nom) VALUES("Michel");

# Création de l'usager pour la bd.
#CREATE USER 'hero'@'localhost' IDENTIFIED BY 'hero';
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

DELIMITER $$
DROP PROCEDURE IF EXISTS afficher_chapitre$$
CREATE PROCEDURE afficher_chapitre(IN _session_id INT)
BEGIN

DECLARE _chapitre_id INT;

SET _chapitre_id = (SELECT chapitre_id FROM session WHERE id = _session_id);

SELECT texte FROM chapitre WHERE id =  _chapitre_id;

END $$
DELIMITER ;


CALL afficher_chapitre(1);

