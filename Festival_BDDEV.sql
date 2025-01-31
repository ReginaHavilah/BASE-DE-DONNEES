CREATE TABLE compte (
nomUtilisateur varchar(50) NOT NULL PRIMARY KEY,
motPasse varchar(30) NOT NULL constraint mot_de_passe CHECK (
        LENGTH(motPasse) >= 8 AND                            
        motPasse ~ '[A-Z]' AND                               
        motPasse ~ '[a-z]' AND                           
        motPasse ~ '[[:punct:]]'                          
    )
);

CREATE TABLE langue (
    id_langue SERIAL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL UNIQUE
);

-- on ne peut avoir qu'une seule commission dans la base de donnés 
CREATE OR REPLACE FUNCTION check_unique_commission()
RETURNS BOOLEAN AS $$
BEGIN
    IF (SELECT COUNT(*) FROM commission) > 1 THEN
        RAISE EXCEPTION 'Il ne peut y avoir qu''une seule entrée dans la table commission.';
    END IF;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;



CREATE TABLE commission (
    id_commission SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    nomUtilisateur VARCHAR(50) NOT NULL,
    FOREIGN KEY (nomUtilisateur) REFERENCES compte (nomUtilisateur),
    CONSTRAINT unique_commission CHECK (check_unique_commission())
   
);


CREATE TABLE interprete (
    id_interprete SERIAL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    mail VARCHAR(50) NOT NULL UNIQUE CHECK (mail LIKE '%_@_%._%'),
    telephone VARCHAR(20) NOT NULL UNIQUE,
    nomUtilisateur VARCHAR(50) NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    FOREIGN KEY (nomUtilisateur) REFERENCES compte (nomUtilisateur),
    CONSTRAINT chk_telephone CHECK (telephone ~ '^[0-9]+$')
);

CREATE TABLE edition (
    id_edition SERIAL PRIMARY KEY,
    annee INT NOT NULL, 
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nom_edition VARCHAR(255) NOT NULL UNIQUE ,
    id_commission INT NOT NULL,
    FOREIGN KEY (id_commission) REFERENCES COMMISSION (id_commission),
    CONSTRAINT date_fin_superieure_date_debut CHECK (date_fin > date_debut),
    CONSTRAINT intervalle_annee CHECK (annee >= 1900 AND annee <= EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TYPE Tetablissement AS ENUM (
    'universite',
    'lycee general',
    'lycee professionnel',
    'college',
    'Ecole primaire ou maternelle',
    'etablissement medico-social',
    'etablissement penitentiaire'
);

CREATE TABLE etablissement (
    id_etablissement SERIAL PRIMARY KEY,
    nom VARCHAR(50) UNIQUE NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    codepostal VARCHAR(5) NOT NULL,
    typeE Tetablissement NOT NULL,
    tel VARCHAR(9) NOT NULL,
    nomUtilisateur VARCHAR(50) NOT NULL,
    mail VARCHAR(50) NOT NULL UNIQUE CHECK (mail LIKE '%_@_%._%'),
    FOREIGN KEY (nomUtilisateur) REFERENCES compte (nomUtilisateur),
    CONSTRAINT chk_telephone CHECK (tel ~ '^[0-9]+$')
);


CREATE TABLE auteur(
    id_auteur SERIAL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    mail VARCHAR(50) NOT NULL UNIQUE CHECK (mail LIKE '%_@_%._%'),
    telephone VARCHAR(15) NOT NULL,
    biographie TEXT,
    adresse VARCHAR(50) NOT NULL,
    nomUtilisateur VARCHAR(30) NOT NULL,
    FOREIGN KEY (nomUtilisateur) REFERENCES compte (nomUtilisateur),
    CONSTRAINT chk_telephone CHECK (telephone ~ '^[0-9]+$')
);

CREATE TABLE accompagnateur (
    id_accompagnateur SERIAL PRIMARY KEY,
    nom VARCHAR(30) NOT NULL,
    prenom VARCHAR(30) NOT NULL,
    mail VARCHAR(50) NOT NULL UNIQUE,--- Contrainte pour un email unique
    adresse VARCHAR(50) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    nomUtilisateur VARCHAR(50) NOT NULL,
    FOREIGN KEY (nomUtilisateur) REFERENCES compte (nomUtilisateur),
    constraint dom_mail_format CHECK (mail LIKE '%_@_%._%'), --- Contrainte pour un email valide,
    CONSTRAINT chk_telephone CHECK (telephone ~ '^[0-9]+$')
);


-- enumeration pour le genre de l'ouvrage
CREATE TYPE TGenre AS ENUM (
    'Drame',
    'historique',
    'romantique',
    'horreur',
    'fantastique',
    'policier',
    'theatre',
    'science-fiction',
    'thriller',
    'religieux',
    'satirique',
    'autres'
);

-- enumeration pour la classe concernee
CREATE TYPE Tclasse AS ENUM (
    'CE1',
    'CE2',
    'CM1',
    'CM2',
    '6IEME',
    '5IEME',
    '4IEME',
    '3IEME',
    'SECONDE',
    'PREMIERE',
    'TERMINAL',
    'Superieur'
);

-- enumeration pour le public cible
CREATE TYPE Tpublic AS ENUM (
    'adulte',
    'adolescent',
    'enfant',
    'autres'
);

CREATE TABLE ouvrage (
    id_livre SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    date_publication DATE NOT NULL CHECK (date_publication < CURRENT_DATE),
    genre TGenre NOT NULL,
    classe_concerne Tclasse NOT NULL,
    public_cible Tpublic NOT NULL
);


CREATE TABLE campagne_voeux (
    id_campagne SERIAL PRIMARY KEY,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    id_commission INT NOT NULL,
    CONSTRAINT dates_valides CHECK (date_fin >= date_debut),
    FOREIGN KEY (id_commission) REFERENCES commission (id_commission)
);


-- enumeration pour l'ordre de preference
CREATE TYPE Tordre AS ENUM ('1', '2', '3');

-- enumeration pour l'etat des voeux
CREATE TYPE TetatVoeux AS ENUM ('accepte', 'rejete', 'en attente');


CREATE TABLE voeux (
    id_voeux SERIAL PRIMARY KEY,
    date_emission DATE NOT NULL,
    ordre_preference Tordre NOT NULL,
    etatVoeux TetatVoeux NOT NULL,
    id_langue INT NOT NULL,
    id_etablissement INT NOT NULL,
    id_campagne INT NOT NULL,
    id_livre INT NOT NULL,
    FOREIGN KEY (id_langue) REFERENCES langue (id_langue),
    FOREIGN KEY (id_livre) REFERENCES ouvrage (id_livre),
    FOREIGN KEY (id_etablissement) REFERENCES etablissement (id_etablissement),
    FOREIGN KEY (id_campagne) REFERENCES campagne_voeux(id_campagne),
	CONSTRAINT etablissement_ordre_unique UNIQUE (id_etablissement, ordre_preference)
);


CREATE TABLE referent (
    id_referent SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    mail VARCHAR(100)  NOT NULL UNIQUE CHECK (mail LIKE '%_@_%._%'),
    telephone VARCHAR(20)  NOT NULL UNIQUE,
    id_etablissement INT NOT NULL,
	id_voeux INT NOT NULL,
	FOREIGN KEY (id_voeux) REFERENCES voeux (id_voeux),
    FOREIGN KEY (id_etablissement) REFERENCES etablissement (id_etablissement),
    CONSTRAINT chk_telephone CHECK (telephone ~ '^[0-9]+$')
);



-- enumeration pour l'etat de l'intervention
CREATE TYPE Tetat AS ENUM ('planifie', 'reporte', 'annule','realise');

CREATE TABLE intervention (
    id_intervention SERIAL PRIMARY KEY,
    dateIntervention DATE NOT NULL CHECK (dateIntervention >= CURRENT_DATE),
    lieu VARCHAR(100) NOT NULL,
    heure_debut TIME NOT NULL,
    heure_fin TIME NOT NULL,
    etat Tetat NOT NULL,
    nbPresent INT,
    id_etablissement INT NOT NULL,
    id_commission INT NOT NULL,
    id_interprete INT NULL,
    FOREIGN KEY (id_etablissement) REFERENCES ETABLISSEMENT (id_etablissement),
    FOREIGN KEY (id_commission) REFERENCES COMMISSION (id_commission),
    FOREIGN KEY (id_interprete) REFERENCES INTERPRETE (id_interprete),
    CONSTRAINT dureepositif CHECK (heure_fin >= heure_debut),
    CONSTRAINT duree_intervention CHECK (EXTRACT(HOUR FROM heure_fin - heure_debut) BETWEEN 2 AND 4) -- Contrainte sur la durÃ©e de l'intervention
);


  
-- intervention et accompagnateur (intervient)
CREATE TABLE intervention_accompagnateur (
    id_intervention INT NOT NULL,
    id_accompagnateur INT NOT NULL,
    PRIMARY KEY (id_intervention, id_accompagnateur),
    FOREIGN KEY (id_intervention) REFERENCES intervention (id_intervention),
    FOREIGN KEY (id_accompagnateur) REFERENCES accompagnateur (id_accompagnateur)
);

-- intervention et auteur (intervient)
CREATE TABLE intervention_auteur (
    id_intervention INT NOT NULL,
    id_auteur INT NOT NULL,
    PRIMARY KEY (id_intervention, id_auteur),
    FOREIGN KEY (id_intervention) REFERENCES intervention (id_intervention),
    FOREIGN KEY (id_auteur) REFERENCES auteur (id_auteur)
);

-- auteur et ouvrage (ecris)
CREATE TABLE auteur_ouvrage (
    id_auteur INT NOT NULL,
    id_livre INT NOT NULL,
    PRIMARY KEY (id_auteur, id_livre),
    FOREIGN KEY (id_auteur) REFERENCES auteur (id_auteur),
    FOREIGN KEY (id_livre) REFERENCES ouvrage (id_livre)
);

-- auteur et langues (parle)
CREATE TABLE auteur_langues (
    id_auteur INT NOT NULL,
    id_langue INT NOT NULL,
    PRIMARY KEY (id_auteur, id_langue),
    FOREIGN KEY (id_auteur) REFERENCES auteur (id_auteur),
    FOREIGN KEY (id_langue) REFERENCES langue (id_langue)
);

-- etablissement et edition (participe)
CREATE TABLE etablissement_edition (
    id_etablissement INT NOT NULL,
    id_edition INT NOT NULL,
    PRIMARY KEY (id_etablissement, id_edition),
    FOREIGN KEY (id_etablissement) REFERENCES etablissement (id_etablissement),
    FOREIGN KEY (id_edition) REFERENCES edition (id_edition)
);

-- auteur et edition (participe):
CREATE TABLE auteur_edition (
    id_auteur INT NOT NULL,
    id_edition INT NOT NULL,
    PRIMARY KEY (id_auteur, id_edition),
    FOREIGN KEY (id_auteur) REFERENCES auteur (id_auteur),
    FOREIGN KEY (id_edition) REFERENCES edition (id_edition)
);

-- accompagnateur et edition (participe):
CREATE TABLE accompagnateur_edition (
    id_accompagnateur INT NOT NULL,
    id_edition INT NOT NULL,
    PRIMARY KEY (id_accompagnateur, id_edition),
    FOREIGN KEY (id_accompagnateur) REFERENCES accompagnateur (id_accompagnateur),
    FOREIGN KEY (id_edition) REFERENCES edition (id_edition)
);

-- interprete et edition (participe):
CREATE TABLE interprete_edition (
    id_interprete INT NOT NULL,
    id_edition INT NOT NULL,
    PRIMARY KEY (id_interprete, id_edition),
    FOREIGN KEY (id_interprete) REFERENCES interprete (id_interprete),
    FOREIGN KEY (id_edition) REFERENCES edition (id_edition)
);

-- ouvrage et langue (est ecrit)
CREATE TABLE ouvrage_langue (
    id_livre INT NOT NULL,
    id_langue INT NOT NULL,
    PRIMARY KEY (id_livre, id_langue),
    FOREIGN KEY (id_livre) REFERENCES ouvrage (id_livre),
    FOREIGN KEY (id_langue) REFERENCES langue (id_langue)
);

-- interprete et langue (parle)
CREATE TABLE interprete_langue_parlee (
    id_interprete INT NOT NULL,
    id_langue_parlee INT NOT NULL,
    PRIMARY KEY (id_interprete, id_langue_parlee),
    FOREIGN KEY (id_interprete) REFERENCES interprete (id_interprete),
    FOREIGN KEY (id_langue_parlee) REFERENCES langue (id_langue)
);
-- interprete et langue (interprete )
CREATE TABLE interprete_langue_interpretee (
    id_interprete INT NOT NULL,
    id_langue_interpretee INT NOT NULL,
    PRIMARY KEY (id_interprete, id_langue_interpretee),
    FOREIGN KEY (id_interprete) REFERENCES interprete (id_interprete),
    FOREIGN KEY (id_langue_interpretee) REFERENCES langue (id_langue)
);


CREATE OR REPLACE FUNCTION check_etat_voeu()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        (OLD.etatVoeux = 'accepte' AND NEW.etatVoeux IN ('en attente', 'rejete') ) OR
        (OLD.etatVoeux = 'rejete' AND NEW.etatVoeux IN ('en attente', 'accepte'))
    ) THEN
        RAISE EXCEPTION 'le voeux ne peux passer de cet etat a un autre';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_etat_voeux_trigger
BEFORE UPDATE ON voeux
FOR EACH ROW
EXECUTE FUNCTION check_etat_voeu();


-- trigger pour l'insertion d'une intervention 


CREATE OR REPLACE FUNCTION check_etat_intervention()
RETURNS TRIGGER AS $$
BEGIN
    IF (
        (OLD.etat = 'realise' AND NEW.etat = 'annule') OR
        (OLD.etat = 'annule' AND NEW.etat = 'realise')
    ) THEN
        RAISE EXCEPTION 'Une intervention réalisée ne peut pas être annulée et une intervention annulée ne peut pas être réalisée.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_etat_intervention_trigger
BEFORE UPDATE ON intervention
FOR EACH ROW
EXECUTE FUNCTION check_etat_intervention();

-- trigger pour empecher la modification du type d'un Ã©tablissement 

CREATE OR REPLACE FUNCTION pas_changement()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.typeE IS NOT NULL AND OLD.typeE <> NEW.typeE THEN
        RAISE EXCEPTION 'Le type de l etablissement n ''est pas modifiable.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pas_changement_trigger BEFORE UPDATE ON etablissement
FOR EACH ROW EXECUTE FUNCTION pas_changement();



-- procedure d'identification dans la base de donnée 
CREATE OR REPLACE PROCEDURE connexion_utilisateur(
    IN p_nomUtilisateur VARCHAR(50),
    IN p_motPasse VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_compte_existe BOOLEAN;
BEGIN
    -- Vérifier si le compte existe dans la base de données
    SELECT EXISTS(SELECT 1 FROM compte WHERE nomUtilisateur = p_nomUtilisateur AND motPasse = p_motPasse)
    INTO v_compte_existe;
    -- Si le compte existe, l'utilisateur est connecté
    IF v_compte_existe THEN
        RAISE NOTICE 'Connexion réussie. Bienvenue, %.', p_nomUtilisateur;
    ELSE
        RAISE EXCEPTION 'Nom d''utilisateur ou mot de passe incorrect.';
    END IF;
END;
$$;


-- procédure pour inserer un compte dans la base de données 
CREATE OR REPLACE PROCEDURE creation_compte(nom varchar (50), Passe VARCHAR(50))
LANGUAGE plpgsql AS $$
BEGIN
IF EXISTS(SELECT 1 FROM compte WHERE nomUtilisateur = nom ) THEN
        RAISE EXCEPTION 'Ce compte existe déjà';
END IF;
-- insertion du compte sinon 
INSERT INTO compte(nomUtilisateur, motPasse) VALUES (nom, Passe);
END;
$$;

-- procédure d'insertion d'un auteur dans la base de données
CREATE OR REPLACE PROCEDURE inserer_auteur(
    IN p_nom VARCHAR(30),
    IN p_prenom VARCHAR(30),
    IN p_mail VARCHAR(50),
    IN p_telephone VARCHAR(15),
    IN p_biographie TEXT,
    IN p_adresse VARCHAR(50),
    IN p_nomUtilisateur VARCHAR(30),
    IN p_motPasse VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier si le nom d'utilisateur existe dans la table compte
    IF NOT EXISTS (SELECT 1 FROM compte WHERE nomUtilisateur = p_nomUtilisateur) THEN
        CALL creation_compte(p_nomUtilisateur,p_motPasse);
    END IF;

    -- Insérer le nouvel auteur
    INSERT INTO auteur (nom, prenom, mail, telephone, biographie, adresse, nomUtilisateur)
    VALUES (p_nom, p_prenom, p_mail, p_telephone, p_biographie, p_adresse, p_nomUtilisateur);
    
     RAISE NOTICE 'Vous venez d'' être enregistrer dans la base de données.';
END;
$$;


-- procédure d'insertion d'un accompagnateur dans la base de données 
CREATE OR REPLACE PROCEDURE inserer_accompagnateur(
    IN p_nom VARCHAR(30),
    IN p_prenom VARCHAR(30),
    IN p_mail VARCHAR(50),
    IN p_adresse VARCHAR(50),
    IN p_telephone VARCHAR(20),
    IN p_nomUtilisateur VARCHAR(50),
    IN p_motPasse VARCHAR(50)
)
LANGUAGE plpgsql
AS $$

BEGIN
    -- Vérifier si le nom d'utilisateur existe dans la table compte
    IF NOT EXISTS (SELECT 1 FROM compte WHERE nomUtilisateur = p_nomUtilisateur) THEN
        CALL creation_compte(p_nomUtilisateur,p_motPasse);
    END IF; 

    -- Insérer le nouvel accompagnateur
    INSERT INTO accompagnateur (nom, prenom, mail, adresse, telephone, nomUtilisateur)
    VALUES (p_nom, p_prenom, p_mail, p_adresse, p_telephone, p_nomUtilisateur);
   
    RAISE NOTICE 'Vous venez d'' être enregistrer dans la base de données.';
END;
$$;

-- procédure d'insertion d'un établissement dans la base de données
CREATE OR REPLACE PROCEDURE inserer_etablissement(
    IN p_nom VARCHAR(50),
    IN p_adresse VARCHAR(50),
    IN p_codepostal VARCHAR(5),
	IN p_mail VARCHAR(20),
    IN p_type Tetablissement,
    IN p_tel VARCHAR(9),
    IN p_nomUtilisateur VARCHAR(50),
	IN p_motPasse VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier si le nom d'utilisateur existe dans la table compte
    IF NOT EXISTS (SELECT 1 FROM compte WHERE nomUtilisateur = p_nomUtilisateur) THEN
        CALL creation_compte(p_nomUtilisateur,p_motPasse);
    END IF;

    -- Insérer le nouvel établissement
    INSERT INTO etablissement (nom, adresse, codepostal, typeE, tel, nomUtilisateur,mail)
    VALUES (p_nom, p_adresse, p_codepostal, p_type, p_tel, p_nomUtilisateur,p_mail);
    
    RAISE NOTICE 'Vous venez d'' être enregistrer dans la base de données.';
END;
$$;

-- procédure d'insertion d'un interprète dans la base de données
CREATE OR REPLACE PROCEDURE inserer_interprete(
  IN  p_nom VARCHAR(30),
  IN  p_prenom VARCHAR(30),
  IN  p_mail VARCHAR(50),
  IN p_telephone VARCHAR(20),
  IN p_adresse VARCHAR (20),
  IN  p_nom_utilisateur VARCHAR(50),
  IN p_motPasse VARCHAR(50)
)
AS $$

BEGIN
    -- Vérifier si le nom d'utilisateur existe dans la table compte
    IF NOT EXISTS (SELECT 1 FROM compte WHERE nomUtilisateur = p_nom_utilisateur) THEN
        CALL creation_compte(p_nom_utilisateur,p_motPasse);
    END IF;

    INSERT INTO interprete (nom, prenom, mail, telephone, nomUtilisateur, adresse)
    VALUES (p_nom, p_prenom, p_mail, p_telephone, p_nom_utilisateur, p_adresse);
    
   RAISE NOTICE 'Vous venez d'' être enregistrer dans la base de données.';
END;
$$ LANGUAGE plpgsql;


-- ajouter les langues parlés par l'interprete
CREATE OR REPLACE PROCEDURE ajouter_langue_parlee(
  IN p_nom VARCHAR(50),
  IN p_prenom VARCHAR(50),
  IN  p_langue_parlee VARCHAR (50)
)
AS $$
DECLARE
    v_id_langue INT;
    v_id_interprete INT;
BEGIN
    -- Chercher l'ID de la langue correspondant au nom entré
    SELECT id_langue INTO v_id_langue FROM langue WHERE nom = p_langue_parlee;
    -- chercher l interprete avec le nom et prenom
   SELECT id_interprete INTO v_id_interprete FROM interprete WHERE nom = p_nom AND prenom=p_prenom;
     
    -- Vérifier si la langue existe
    IF v_id_langue IS NULL THEN
        RAISE EXCEPTION 'Cette langue  n''existe pas.';
    END IF;

    -- Insertion dans la table
    INSERT INTO interprete_langue_parlee (id_interprete, id_langue_parlee)
    VALUES (v_id_interprete, v_id_langue);
END;
$$ LANGUAGE plpgsql;

-- insertion des langues interprétés par l'interprete 
CREATE OR REPLACE PROCEDURE ajouter_langue_interpretee(
   IN p_nom VARCHAR(50),
  IN p_prenom VARCHAR(50),
  IN  p_langue_parlee VARCHAR (50)
)
AS $$
DECLARE
    v_id_langue INT;
    v_id_interprete INT;
BEGIN
    -- Chercher l'ID de la langue correspondant au nom entré
    SELECT id_langue INTO v_id_langue FROM langue WHERE nom = p_langue_parlee;
    -- chercher l interprete avec le nom et prenom
   SELECT id_interprete INTO v_id_interprete FROM interprete WHERE nom = p_nom AND prenom=p_prenom;
     
     -- Vérifier si la langue existe
    IF v_id_langue IS NULL THEN
        RAISE EXCEPTION 'La langue spécifiée n''existe pas.';
    END IF;

    -- Insertion 
    INSERT INTO interprete_langue_interpretee (id_interprete, id_langue_interpretee)
    VALUES (v_id_interprete, v_id_langue);
    
END;
$$ LANGUAGE plpgsql;



-- fonction qui récupère l'id de l'unique commission 
CREATE OR REPLACE FUNCTION get_unique_commission_id()
RETURNS INT AS $$
DECLARE
    commission_id INT;
BEGIN
    SELECT id_commission INTO commission_id FROM commission;
    RETURN commission_id;
END;
$$ LANGUAGE plpgsql;



-- procedure qui insere la langue parle par un auteur
CREATE OR REPLACE PROCEDURE insert_auteur_langue(
    username_auteur VARCHAR(30),
    p_nom_langue VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
DECLARE
   v_id_auteur INT;
    v_id_langue INT;
BEGIN
    -- trouver l'id de l'auteur et celle de la langue 
    SELECT id_langue INTO v_id_langue FROM langue WHERE nom = p_nom_langue;
   SELECT id_auteur INTO v_id_auteur FROM auteur WHERE nomUtilisateur = username_auteur;

    -- Si la langue n'existe pas, lancer une exception
    IF v_id_langue IS NULL THEN
        RAISE EXCEPTION 'La langue spécifiée n''existe pas.';
    END IF;
    -- Insérer l'association entre l'auteur et la langue dans la table auteur_langues
    INSERT INTO auteur_langues (id_auteur, id_langue) VALUES (v_id_auteur, v_id_langue);
END;
$$;


-- la commission cree une edition 
CREATE OR REPLACE PROCEDURE creer_edition(
    IN  in_nom_edition VARCHAR(255),
    IN in_annee INT,
    IN in_date_debut DATE,
    IN in_date_fin DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    commission_id INT;
BEGIN
    -- Récupérer l'ID de l'unique commission
    commission_id = get_unique_commission_id();

    -- Vérifier si l'ID de la commission est NULL
    IF commission_id IS NULL THEN
        RAISE EXCEPTION 'Aucune commission n''a été trouvée dans la base de données. On ne peut creer une edition';
        ELSE  IF EXISTS (SELECT 1 FROM edition WHERE nom_edition = in_nom_edition AND date_debut = in_date_debut AND date_fin = in_date_fin) 
-- Vérifier si une édition avec les mêmes informations existe déjà
                THEN  RAISE EXCEPTION 'Une édition avec les mêmes informations existe déjà.';
              ELSE 
                -- Insérer l'édition avec l'ID de la commission récupérée
                INSERT INTO edition (nom_edition, annee, date_debut, date_fin, id_commission)
                VALUES (in_nom_edition, in_annee, in_date_debut, in_date_fin, commission_id);
             END IF;
    END IF;
    RAISE NOTICE 'Edition creer.';
END;
$$;

--lancer une campagne
CREATE OR REPLACE PROCEDURE lancer_campagne(
  IN  in_date_debut DATE,
  IN   in_date_fin DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    commission_id INT;
BEGIN
    -- Récupérer l'ID de l'unique commission
    commission_id = get_unique_commission_id();

    -- Vérifier si l'ID de la commission est NULL
    IF commission_id IS NULL THEN
        RAISE EXCEPTION 'Aucune commission n''a été trouvée dans la base de données.';
    ELSE
        -- Vérifier s'il existe d'autres campagnes avec les mêmes dates de début et de fin
        IF EXISTS (SELECT 1 FROM campagne_voeux WHERE date_debut = in_date_debut AND date_fin = in_date_fin) THEN
            RAISE EXCEPTION 'Il existe déjà une campagne avec les mêmes dates de début et de fin.';
        ELSE
            -- Insérer la nouvelle campagne avec l'ID de la commission récupérée
            INSERT INTO campagne_voeux (date_debut, date_fin, id_commission)
            VALUES (in_date_debut, in_date_fin, commission_id);
            RAISE NOTICE 'La campagne est lancé';
        END IF;
    END IF;
END;
$$;

--Verification du nombre de voeux d'un etablissement  par campagne 
CREATE OR REPLACE FUNCTION nb_Voeux_eta() RETURNS TRIGGER AS $$
DECLARE
 	Voeux_count INTEGER;
BEGIN
	SELECT COUNT(*)
	INTO Voeux_count 
	FROM Voeux
	WHERE id_Etablissement= NEW.id_Etablissement;
	
	IF  Voeux_count = 3 THEN 
	RAISE EXCEPTION 'Un Etablissement ne peut formuler que 3 voeux par campagne.';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_nb_Voeux_eta
BEFORE INSERT ON Voeux
FOR EACH ROW
EXECUTE FUNCTION nb_Voeux_eta();


--verifie qu'un voeu a ete emis avant la date limite de la campagne
CREATE OR REPLACE FUNCTION check_date()
RETURNS TRIGGER AS $$
DECLARE 
    date_debut DATE;
    date_fin DATE;
BEGIN
    -- Récupérer les dates de début et de fin de la campagne de vœux qu'on veut insérer
    SELECT date_debut, date_fin INTO date_debut, date_fin
    FROM campagne_de_voeux
    WHERE id_campagne = NEW.id_campagne; 

    -- Vérifier si la date du vœux est dans l'intervalle des dates de la campagne de vœux
    IF NEW.date_voeux NOT BETWEEN date_debut AND date_fin THEN
        RAISE EXCEPTION 'La date n''est pas comprise dans la période de la campagne de vœux.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verif_date_voeux
BEFORE INSERT ON voeux
FOR EACH ROW
EXECUTE FUNCTION check_date();

-- Afficher la liste de tous les voeux par établissements 
CREATE OR REPLACE PROCEDURE liste_voeux_par_etablissement()
LANGUAGE plpgsql
AS $$
DECLARE
    v_row record;
BEGIN
    -- Sélectionner les voeux regroupés par établissement
    FOR v_row IN SELECT e.nom AS nom_etablissement, 
       v.id_voeux, 
       v.ordre_preference, 
       v.etatvoeux, 
       v.id_langue, 
	   v.id_etablissement,
       v.id_campagne, 
       v.id_livre
        FROM voeux v
    INNER JOIN etablissement e ON v.id_etablissement = e.id_etablissement
    GROUP BY e.nom, v.id_voeux, v.ordre_preference, v.etatvoeux, v.id_langue, v.id_campagne, v.id_livre
 LOOP
        -- Afficher les détails du voeu par établissement
        RAISE NOTICE 'Établissement: %, ID Voeux: %, Ordre de préférence: %, État: %, ID Langue: %, ID Campagne: %, ID Livre: %',
                     v_row.id_etablissement, v_row.id_voeux, v_row.ordre_preference, v_row.etatvoeux, v_row.id_langue, v_row.id_campagne, v_row.id_livre;
    END LOOP;
END;
$$;







 
-- validation d un voeu par la commission 
CREATE OR REPLACE PROCEDURE valider_voeu(
    IN p_id_voeu INT
)
LANGUAGE plpgsql
AS $$
DECLARE 
 etat TetatVoeux ; 
BEGIN
 -- verifie l etat du voeu 
 SELECT etatVoeux INTO etat FROM voeux WHERE id_voeux=P_id_voeu;
    IF (etat!='en attente') THEN
    RAISE EXCEPTION 'On ne peut valide ou rejete un voeu qui n''es pas en attente';
   END IF; 
    -- Mettre à jour l'état du vœu en 'validé'
    UPDATE voeux
    SET etatVoeux = 'accepte'
    WHERE id_voeux = p_id_voeu;
	 RAISE NOTICE'Voeu accepté';
END;
$$;

-- refus d un voeu par la commission 
CREATE OR REPLACE PROCEDURE rejeter_voeu(
    IN p_id_voeu INT
)
LANGUAGE plpgsql
AS $$
DECLARE 
 etat TetatVoeux ; 
BEGIN
SELECT etatVoeux INTO etat FROM voeux WHERE id_voeux=P_id_voeu;
    IF (etat!='en attente') THEN
    RAISE EXCEPTION 'On ne peut valide ou rejete un voeu qui n''es pas en attente';
   END IF; 
    -- Mettre à jour l'état du vœu en 'validé'
    UPDATE voeux
    SET etatVoeux = 'rejete'
    WHERE id_voeux = p_id_voeu;
    RAISE NOTICE'Voeu rejeté';
END;
$$;

-- Test : CALL rejeter_voeu(7); select * from voeux;
-- insertion d une langue
CREATE OR REPLACE PROCEDURE insert_auteur_langue(
    p_id_auteur INT,
    p_nom_langue VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_langue INT;
BEGIN
    -- Vérifier si la langue existe déjà dans la table Langue
    SELECT id_langue INTO v_id_langue FROM langue WHERE nom = p_nom_langue;

    -- Si la langue n'existe pas, lancer une exception
    IF v_id_langue IS NULL THEN
        RAISE EXCEPTION 'La langue spécifiée n''existe pas.';
    END IF;
    -- Insérer l'association entre l'auteur et la langue dans la table auteur_langues
    INSERT INTO auteur_langues (id_auteur, id_langue) VALUES (p_id_auteur, v_id_langue);

END;
$$;

-- CALL insert_auteur_langue(1,'hindi'); select * from langue ;
-- ajouter un ouvrage 
CREATE OR REPLACE PROCEDURE ajouter_ouvrage(
    IN nom_auteur VARCHAR(50),
    IN titre_livre VARCHAR(50),
    IN datepublication DATE,
    IN genre_ouvrage Tgenre,
    IN classe Tclasse,
    IN public Tpublic)
LANGUAGE plpgsql AS $$
DECLARE
id_auteurr INT;
id_ouvrage INT;
BEGIN
IF EXISTS (SELECT 1 FROM ouvrage WHERE titre=titre_livre) THEN 
  RAISE EXCEPTION 'Un livre avec ce titre existe deja dans le systeme';
END IF;
--insertion de l'ouvrage
INSERT INTO ouvrage(titre,date_publication, genre,classe_concerne, public_cible)
VALUES (titre_livre,datepublication,genre_ouvrage,classe,public);
-- chercher l'id de l'ouvrage inserer 
SELECT id_livre INTO id_ouvrage FROM ouvrage WHERE titre=titre_livre;
-- chercher l'id de l'auteur 
SELECT id_auteur INTO id_auteurr FROM auteur WHERE nomUtilisateur=nom_auteur;
IF id_auteurr IS NULL THEN RAISE EXCEPTION 'L''auteur ne figure pas dans la base';
END IF;
-- on vérifie si l association n existe pas encore 
IF (SELECT 1 FROM auteur_ouvrage WHERE id_livre=id_ouvrage AND id_auteur=id_auteurr)
THEN RAISE EXCEPTION ' Vous aviez déjà ajouter cet ouvrage ';
END IF; 
-- ajouter l'association entre l'ouvrage et son auteur
INSERT INTO auteur_ouvrage(id_auteur, id_livre) VALUES (id_auteurr, id_ouvrage);
RAISE NOTICE 'Livre ajouter';
END;
$$

--CALL ajouter_ouvrage('jason_white','Roméo et Juliette','2003-04-02','Drame','TERMINAL','adolescent');

--SELECT * from ouvrage;
-- afficher les interventions d'un auteur  
CREATE OR REPLACE PROCEDURE liste_interventions_par_auteur(
    username_auteur VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_row RECORD;
BEGIN
    -- Sélectionner les interventions de l'auteur spécifié
    FOR v_row IN 
        SELECT i.*
        FROM intervention i
        INNER JOIN intervention_auteur ia ON i.id_intervention = ia.id_intervention
        INNER JOIN auteur a ON ia.id_auteur = a.id_auteur
        WHERE a.nomUtilisateur =username_auteur
    LOOP
        -- Afficher les détails de chaque intervention
        RAISE NOTICE 'ID Intervention: %, Date: %, Lieu: %, Heure début: %, Heure fin: %, État: %, Nombre de présents: %',
                     v_row.id_intervention, v_row.dateintervention, v_row.lieu, v_row.heure_debut, v_row.heure_fin, v_row.etat, v_row.nbPresent;
    END LOOP;
END;
$$;
 
-- CALL liste_interventions_par_auteur('jason_white');

-- l'auteur veut s'inscrire à une edition 
CREATE OR REPLACE PROCEDURE auteur_edition(
IN nom VARCHAR (250),
IN username_auteur VARCHAR(250)
)
 AS $$ 
DECLARE
id_aut INT;
id_edi INT;
BEGIN 
-- retrouver l id de l interprete par son nom utilisateur  
SELECT id_auteur INTO id_aut
FROM auteur
WHERE nomUtilisateur=username_auteur;
-- retrouver l id de l edition par son nom 
SELECT id_edition INTO id_edi
FROM edition
WHERE nom_edition=nom;
IF id_edi IS NULL 
THEN RAISE EXCEPTION 'Aucune edition ne porte le nom %.',nom; 
-- Verifier s'il existe deja une inscription de cet acteur a cette edition  
ELSE IF (SELECT 1 FROM auteur_edition WHERE id_auteur=id_aut AND id_edition=id_edi)
        THEN RAISE EXCEPTION 'Vous êtes déjà inscrit à cette édition';
        ELSE
        INSERT INTO auteur_edition(id_auteur,id_edition) VALUES (id_aut,id_edi);
        RAISE NOTICE 'Vous venez de vous inscrire à l'' edition %.', nom;
    END IF; 
END IF; 
END;
$$ LANGUAGE plpgsql ;


-- CALL auteur_edition('Édition 2023','sophia_harris');

-- établissement veut faire un voeu 
CREATE OR REPLACE PROCEDURE faire_voeu(
    IN p_nom_etablissement VARCHAR(50),
    IN p_nom_langue VARCHAR(30),
    IN p_date_debut_campagne DATE,
    IN p_date_fin_campagne DATE,
    IN p_ordre_preference Tordre,
    IN p_titre_ouvrage VARCHAR(100) -- Ajout du paramètre titre de l'ouvrage
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_etablissement INT;
    v_id_langue INT;
    v_id_campagne INT;
    v_id_ouvrage INT; -- Variable pour stocker l'ID de l'ouvrage
    v_nombre_voeux INT;
	     p_id_commission INT;
BEGIN
-- recuperer l'id unique de la commission
p_id_commission=get_unique_commission_id();
-- Récupérer l'ID de l'établissement
    SELECT id_etablissement INTO v_id_etablissement
    FROM etablissement
    WHERE nom = p_nom_etablissement;
    IF v_id_etablissement IS NULL THEN 
    RAISE EXCEPTION 'Aucun etablissement ne porte ce nom';
    END IF;

    -- Vérifier si l'établissement a déjà fait 3 voeux
    SELECT COUNT(*) INTO v_nombre_voeux
    FROM voeux
    WHERE id_etablissement = v_id_etablissement;

-- Récupérer l'ID de la langue
    SELECT id_langue INTO v_id_langue
    FROM langue
    WHERE nom = p_nom_langue;
    IF v_id_langue IS NULL THEN 
    RAISE EXCEPTION 'Cette langue n''existe pas dans la base de données.';
    END IF;
    -- Récupérer l'ID de la campagne de voeux
    SELECT id_campagne INTO v_id_campagne
    FROM campagne_voeux
    WHERE date_debut = p_date_debut_campagne AND date_fin = p_date_fin_campagne AND id_commission = p_id_commission;
    IF v_id_campagne IS NULL THEN 
    RAISE EXCEPTION 'Pas de campagne dans cette période.';
    END IF;
    -- Récupérer l'ID de l'ouvrage en utilisant son titre
    SELECT id_livre INTO v_id_ouvrage
    FROM ouvrage
    WHERE titre = p_titre_ouvrage;
    IF v_id_ouvrage IS NULL THEN 
    RAISE EXCEPTION 'Aucun ouvrage ne porte ce nom';
    END IF;

   IF (p_date_fin_campagne<CURRENT_DATE )THEN
    RAISE EXCEPTION 'Vous ne pouvez fais de voeux après la date limite';
    RETURN;
   ELSE IF v_nombre_voeux >= 3 THEN
            RAISE EXCEPTION 'L''établissement a déjà atteint la limite de 3 voeux.';
            RETURN;
        ELSE  -- Insérer le vœu avec l'ID de l'ouvrage récupéré

            INSERT INTO voeux (date_emission,ordre_preference, etatVoeux, id_langue, id_etablissement, id_campagne, id_livre)
            VALUES (CURRENT_DATE,p_ordre_preference, 'en attente', v_id_langue, v_id_etablissement, v_id_campagne, v_id_ouvrage);
            RAISE NOTICE 'Voeux exprimé et pris en compte.';
        END IF;
    
    END IF;  
END;
$$;


--CALL faire_voeu('Lycée Paul Valéry','anglais','2024-06-01', '2024-06-30','3','Les Ombres du Passé'); 


-- Inscription d'un accompagnateur à une édition
CREATE OR REPLACE PROCEDURE accompagnateur_edition(
IN nom VARCHAR (250),
IN username_accompagnateur VARCHAR(250)
)
 AS $$ 
DECLARE
id_accomp INT;
id_edi INT;
BEGIN 
-- retrouver l id de l accompagnateur par son mail  
SELECT id_accompagnateur INTO id_accomp 
FROM accompagnateur 
WHERE nomUtilisateur=username_accompagnateur;
-- retrouver l id de l edition par son nom 
SELECT id_edition INTO id_edi
FROM edition
WHERE nom_edition=nom;

-- si l edition n existe pas 
IF id_edi IS NULL 
THEN RAISE EXCEPTION 'Aucune edition ne porte le nom %.',nom; 
-- Verifier s'il existe deja une association entre accompagnateur et edition 
ELSE IF (SELECT 1 FROM accompagnateur_edition WHERE id_accompagnateur=id_accomp AND id_edition=id_edi)
    THEN RAISE EXCEPTION 'Vous êtes déjà inscrit à cette édition';
    ELSE INSERT INTO accompagnateur_edition(id_accompagnateur,id_edition) VALUES (id_accomp,id_edi);
    RAISE NOTICE 'Vous venez de vous inscrire à l'' edition %.', nom;
    END IF; 
END IF; 
END;
$$ LANGUAGE plpgsql ;


--CALL accompagnateur_edition('Édition 2021','emily_thomas');

-- inscription d'un interprete  à une edition 
CREATE OR REPLACE PROCEDURE interprete_edition(
IN nom VARCHAR (250),
IN username_interprete VARCHAR(250)
)
 AS $$ 
DECLARE
id_inter INT;
id_edi INT;
BEGIN 
-- retrouver l id de l interprete par son mail  
SELECT id_interprete INTO id_inter
FROM interprete 
WHERE nomUtilisateur=username_interprete;
-- retrouver l id de l edition par son nom 
SELECT id_edition INTO id_edi
FROM edition
WHERE nom_edition=nom;

IF id_edi IS NULL 
THEN RAISE EXCEPTION 'Aucune edition ne porte le nom %.',nom; 
-- Verifier s'il existe deja une inscription de cet acteur a cette edition  
ELSE IF (SELECT 1 FROM interprete_edition WHERE id_interprete=id_inter AND id_edition=id_edi)
        THEN RAISE EXCEPTION 'Vous êtes déjà inscrit à cette édition';
        ELSE
        INSERT INTO interprete_edition(id_interprete,id_edition) VALUES (id_inter,id_edi);
        RAISE NOTICE 'Vous venez de vous inscrire à l'' edition %.', nom;
    END IF; 
END IF; 
END;
$$ LANGUAGE plpgsql ;

--Test: CALL interprete_edition('Édition 2021','emma_jones') 

-- liste interpretes pouvant intervenir 
CREATE OR REPLACE FUNCTION liste_interpretees(IN p_titre_livre VARCHAR(255), IN  p_nom_etablissement VARCHAR(50))
RETURNS TABLE (id_interprete INT, nomInter VARCHAR(100), prenom VARCHAR(100), mail VARCHAR(100), telephone VARCHAR(100)) 
AS $$
DECLARE
BEGIN

RETURN QUERY SELECT DISTINCT i.id_interprete, i.nom, i.prenom, i.mail, i.telephone
FROM interprete i
JOIN interprete_langue_interpretee ili ON i.id_interprete = ili.id_interprete
JOIN interprete_langue_parlee ilp ON i.id_interprete = ilp.id_interprete
JOIN langue l ON ili.id_langue_interpretee = l.id_langue AND ilp.id_langue_parlee = l.id_langue
WHERE ilp.id_langue_parlee IN (
    SELECT id_langue 
    FROM auteur_langues a 
    WHERE a.id_auteur = (
        SELECT a.id_auteur 
        FROM auteur a
        JOIN auteur_ouvrage ao ON a.id_auteur = ao.id_auteur
        WHERE ao.id_livre = (
            SELECT id_livre
            FROM ouvrage
            WHERE titre = p_titre_livre
            LIMIT 1
        )
        LIMIT 1
    )
)
AND ili.id_langue_interpretee = (
    SELECT id_langue  
    FROM voeux 
    WHERE id_voeux = (
        SELECT id_voeux 
        FROM voeux
        WHERE id_livre = (
            SELECT id_livre
            FROM ouvrage
            WHERE titre = p_titre_livre
            LIMIT 1
        )
        AND id_etablissement = (
            SELECT id_etablissement 
            FROM etablissement
            WHERE nom = p_nom_etablissement
            LIMIT 1
        )
        LIMIT 1
    )
    LIMIT 1
);


END;
$$
LANGUAGE plpgsql;


-- SELECT * FROM liste_interpretees('Le Destin de l''Élue','Université de Ville');

--- créer une intervention 
CREATE OR REPLACE PROCEDURE creer_intervention(
    p_titre_livre VARCHAR(255),
    p_nom_etablissement VARCHAR(50),
    p_date_intervention DATE,
    p_lieu VARCHAR(100),
    p_heure_debut TIME,
    p_heure_fin TIME,
    p_id_interprete INT,
    p_id_accompagnateur INT
)
AS $$
DECLARE
    v_id_livre INT;
    v_id_etablissement INT;
    v_id_voeu INT;
    v_id_auteur INT;
    v_id_interprete INT;
    v_nb_interventions INT;
    v_id_commission INT;
    etat TetatVoeux ; 
BEGIN
-- verifier si l intervention existe déjà 
   IF EXISTS (
        SELECT 1
        FROM intervention
        WHERE dateIntervention = p_date_intervention
        AND lieu = p_lieu
        AND heure_debut = p_heure_debut
        AND heure_fin = p_heure_fin
        AND id_interprete = p_id_interprete
        AND id_etablissement = (SELECT id_etablissement FROM etablissement WHERE nom = p_nom_etablissement)
    ) THEN
        RAISE EXCEPTION 'Une intervention avec les mêmes attributs existe déjà.';
    END IF;
   -- l'id de l'unique commission de la base 
    v_id_commission = get_unique_commission_id();
    -- Recherche de l'ID du livre en fonction du titre
    SELECT id_livre INTO v_id_livre
    FROM ouvrage
    WHERE titre = p_titre_livre;
    IF v_id_livre IS NULL 
    THEN RAISE EXCEPTION 'Aucun livre de la base ne porte ce nom';
    END IF;
    -- Recherche de l'ID de l'établissement en fonction de son nom
    SELECT id_etablissement INTO v_id_etablissement
    FROM etablissement
    WHERE nom = p_nom_etablissement;
    IF v_id_etablissement IS NULL THEN
    RAISE EXCEPTION 'Aucun etablissement ne porte ce nom';
    END IF; 
    -- Recherche de l'ID du vœu en fonction de l'ID du livre et de l'ID de l'établissement
    SELECT id_voeux INTO v_id_voeu
    FROM voeux
    WHERE id_livre = v_id_livre
    AND id_etablissement = v_id_etablissement
    AND id_campagne = (
        SELECT id_campagne
        FROM campagne_voeux
        WHERE date_debut <= p_date_intervention
        AND date_fin >= p_date_intervention
    );
    -- verifie si l'etat du voeu trouvé est accepte 
    SELECT etatVoeux INTO etat FROM voeux WHERE id_voeux=v_id_voeu;
    IF (etat!='accepte') THEN
    RAISE EXCEPTION 'On ne peut creer une intervention que pour un voeu valide';
   END IF; 
    -- Sélectionner l'auteur du livre
    SELECT id_auteur INTO v_id_auteur
    FROM auteur_ouvrage
    WHERE id_livre = v_id_livre
    LIMIT 1;

    -- Vérifier si l'auteur peut parler la langue du vœu
    IF EXISTS (
        SELECT 1
        FROM auteur_langues al
        JOIN voeux v ON al.id_langue = v.id_langue
        WHERE al.id_auteur = v_id_auteur
        AND v.id_voeux = v_id_voeu
    ) THEN
        -- Si l'auteur peut parler la langue, on n'a pas besoin d'un interprète
        v_id_interprete := NULL;
    ELSE
        -- Sinon, on prend celui en paramètre
       v_id_interprete:=p_id_interprete;
    END IF;

    -- nombre d'interventions de l'auteur le jour même
    SELECT COUNT(*) INTO v_nb_interventions
    FROM intervention_auteur ia
    JOIN intervention i ON ia.id_intervention = i.id_intervention
    WHERE ia.id_auteur = v_id_auteur
    AND dateIntervention = p_date_intervention;

    IF v_nb_interventions >= 3 THEN
       RAISE NOTICE 'L''auteur a déjà atteint le nombre maximum d''interventions pour ce jour.';
        RETURN;
    END IF;
   
   --vérifier si l'auteur n'a pas d'intervention à cette date là et à l'heure là 
  IF EXISTS (
    SELECT 1
    FROM intervention_auteur ia
    JOIN auteur a ON ia.id_auteur = a.id_auteur
    JOIN intervention i ON ia.id_intervention = i.id_intervention
    WHERE a.id_auteur = v_id_auteur
    AND i.dateIntervention = p_date_intervention
    AND (i.heure_debut BETWEEN p_heure_debut AND p_heure_fin OR i.heure_fin BETWEEN p_heure_debut AND p_heure_fin)
) THEN 
    RAISE EXCEPTION 'L''auteur a une intervention pendant cet horaire';
END IF;

 -- Insérer l'intervention
    INSERT INTO intervention (dateIntervention, lieu, heure_debut, heure_fin, etat, nbPresent, id_etablissement, id_commission, id_interprete)
    VALUES (p_date_intervention, p_lieu, p_heure_debut, p_heure_fin, 'planifie', 0, v_id_etablissement,v_id_commission,v_id_interprete) ; 
    
   RAISE NOTICE 'Intervention créée avec succès.';

END;
$$ LANGUAGE plpgsql;

	
--
CALL creer_intervention ('Roméo et Juliette','Université de Ville','2024-04-24','Boudonville','15:00:00','17:00:00',11,2);

select * from intervention ;
-- désistement auteur 
CREATE OR REPLACE PROCEDURE desister_intervention(
    p_nom_utilisateur_auteur VARCHAR(30),
    p_id_intervention INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_auteur INT;
BEGIN
    -- Rechercher l'ID de l'auteur en fonction du nom d'utilisateur
    SELECT id_auteur INTO v_id_auteur
    FROM auteur
    WHERE nomUtilisateur = p_nom_utilisateur_auteur;

    -- Vérifier si l'auteur a une intervention planifiée correspondant à l'ID fourni
    IF EXISTS (
        SELECT 1
        FROM intervention_auteur
        WHERE id_auteur = v_id_auteur
        AND id_intervention = p_id_intervention
    ) THEN
        -- Mettre à jour l'état de l'intervention à "annulé"
        UPDATE intervention
        SET etat = 'annule'
        WHERE id_intervention = p_id_intervention;

        -- Supprimer la ligne correspondante dans la table associative intervention_auteur
        DELETE FROM intervention_auteur
        WHERE id_auteur = v_id_auteur
        AND id_intervention = p_id_intervention;

       RAISE NOTICE 'Désistement de l''intervention effectué avec succès.';
    ELSE
       RAISE NOTICE 'L''auteur n''est pas inscrit à cette intervention ou elle n''est pas planifiée.';
    END IF;
END;
$$;

-- Test: CALL desister_intervention('jason_white',3);


-- désistement établissement 
CREATE OR REPLACE PROCEDURE desister_intervention_etablissement(
    p_nom_utilisateur_etablissement VARCHAR(50),
    p_id_intervention INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Vérifier si l'établissement est inscrit à l'intervention spécifiée
    IF EXISTS (
        SELECT 1
        FROM intervention
        WHERE id_intervention = p_id_intervention
        AND id_etablissement = (
            SELECT id_etablissement
            FROM etablissement
            WHERE nomUtilisateur = p_nom_utilisateur_etablissement
        )
    ) THEN
        -- Mettre à jour l'état de l'intervention à "annulé"
        UPDATE intervention
        SET etat = 'annule'
        WHERE id_intervention = p_id_intervention;

       RAISE NOTICE 'Désistement de l''établissement de l''intervention effectué avec succès.';
    ELSE
        RAISE NOTICE  'L''établissement n''est pas inscrit à cette intervention.';
    END IF;
END;
$$;

-- CALL desister_intervention_etablissement('david_miller',1);

-- liste intervention accompagnateur 
CREATE OR REPLACE PROCEDURE liste_interventions_par_accompagnateur(
    username_accompagnateur VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_row RECORD;
BEGIN
    -- Sélectionner les interventions de l'accompagnateur spécifié
    FOR v_row IN 
        SELECT i.*
        FROM intervention i
        INNER JOIN intervention_accompagnateur ia ON i.id_intervention = ia.id_intervention
        INNER JOIN accompagnateur a ON ia.id_accompagnateur = a.id_accompagnateur
        WHERE a.nomUtilisateur = username_accompagnateur
    LOOP
        -- Afficher les détails de chaque intervention
        RAISE NOTICE 'ID Intervention: %, Date: %, Lieu: %, Heure début: %, Heure fin: %, État: %, Nombre de présents: %',
                     v_row.id_intervention, v_row.dateintervention, v_row.lieu, v_row.heure_debut, v_row.heure_fin, v_row.etat, v_row.nbPresent;
    END LOOP;
END;
$$;

--Test : call liste_interventions_par_accompagnateur('emily_thomas');

-- liste intervention d un interpretes 
CREATE OR REPLACE PROCEDURE liste_interventions_par_interprete(
   username_interprete VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_row RECORD;
BEGIN
    -- Sélectionner les interventions de l'interprète spécifié
    FOR v_row IN 
        SELECT i.*
        FROM intervention i
        WHERE i.id_interprete IS NOT NULL
        AND EXISTS (
            SELECT 1
            FROM interprete inte
            WHERE inte.nomUtilisateur = username_interprete
            AND i.id_interprete = inte.id_interprete
        )
    LOOP
        -- Afficher les détails de chaque intervention
        RAISE NOTICE 'ID Intervention: %, Date: %, Lieu: %, Heure début: %, Heure fin: %, État: %, Nombre de présents: %',
                     v_row.id_intervention, v_row.dateintervention, v_row.lieu, v_row.heure_debut, v_row.heure_fin, v_row.etat, v_row.nbPresent;
    END LOOP;
END;
$$;

-- Test: CALL liste_interventions_par_interprete('emma_jones'); 
 
-- inscription d'un établissement  à une edition 
CREATE OR REPLACE PROCEDURE etablissement_edition(
IN nom VARCHAR (250),
IN username_etablissement VARCHAR(250)
)
 AS $$ 
DECLARE
id_eta INT;
id_edi INT;
BEGIN 
-- retrouver l id de l etablissement par son username  
SELECT id_etablissement INTO id_eta
FROM etablissement
WHERE nomUtilisateur=username_etablissement;

-- retrouver l id de l edition par son nom 
SELECT id_edition INTO id_edi
FROM edition
WHERE nom_edition=nom;

IF id_edi IS NULL 
THEN RAISE EXCEPTION 'Aucune edition ne porte le nom %.',nom; 
-- Verifier s'il existe deja une inscription de cet etablissement a cette edition  
ELSE IF (SELECT 1 FROM etablissement_edition WHERE id_etablissement=id_eta AND id_edition=id_edi)
        THEN RAISE EXCEPTION 'Vous êtes déjà inscrit à cette édition';
        ELSE
        INSERT INTO etablissement_edition(id_etablissement,id_edition) VALUES (id_eta,id_edi);
        RAISE NOTICE 'Vous venez de vous inscrire à l'' edition %.', nom;
    END IF; 
END IF; 
END;
$$ LANGUAGE plpgsql ;

-- Test : CALL etablissement_edition ('Édition 2023','laura_taylor');

CREATE OR REPLACE FUNCTION determination_nbre_eleve(intervention_id INT)
RETURNS INT AS
$$
DECLARE
    nombre_eleve INT;
BEGIN
    -- Vérifier si l'intervention existe et a comme état "réalisé"
    IF NOT EXISTS (SELECT 1 FROM intervention WHERE intervention_id = intervention_id AND etat = 'realise') THEN
       RAISE EXCEPTION 'Cette intervention n existe pas ou n est pas encore realise';
	 ELSE  -- Sélectionner le nombre d'élèves présents lors de cette intervention
        SELECT  nbPresent INTO nombre_eleve FROM intervention WHERE id_intervention = intervention_id;
        RETURN nombre_eleve;
		RAISE NOTICE 'Nombre d''elève:%',nombre_eleve;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- SELECT * FROM  determination_nbre_eleve(2); Au depart cette intervention est planifie et nbpresent est null
-- UPDATE intervention SET etat = 'realise' WHERE id_intervention = 2; 
-- UPDATE intervention SET  nbPresent = 20 WHERE id_intervention = 2;
-- On rappelle la fonction et on a 20. 
		

CREATE OR REPLACE FUNCTION determination_taux_participation(edition_id INT)
RETURNS DECIMAL(5, 2) AS
$$
DECLARE
    total_etablissements INT;
    etablissements_participants INT;
    taux_participation DECIMAL;
BEGIN
    -- Vérifier si l'édition existe dans la base de données
    IF NOT EXISTS (SELECT 1 FROM edition WHERE id_edition = edition_id) THEN
        RAISE EXCEPTION 'La base ne contient pas cette édition';
    ELSE
        -- Compter le nombre total d'établissements pour cette édition
        SELECT COUNT(*) INTO total_etablissements FROM etablissement_edition WHERE id_edition = edition_id;

        -- Compter le nombre d'établissements distincts ayant participé à la campagne de voeux pour cette édition
        SELECT COUNT(DISTINCT id_etablissement) INTO etablissements_participants
        FROM voeux
        WHERE id_etablissement IN (SELECT id_etablissement FROM etablissement_edition WHERE id_edition = edition_id);
        -- Calculer le taux de participation
        IF total_etablissements > 0 THEN
            taux_participation = (etablissements_participants / total_etablissements) * 100.0;
            -- Afficher le taux de participation calculé
            RAISE NOTICE 'Le taux de participation à l''édition % est de %', edition_id, taux_participation;
            RETURN taux_participation;
        ELSE
            RETURN NULL; -- Retourner NULL si aucun établissement n'est trouvé pour cette édition
        END IF;
   END IF;     
END;
$$
LANGUAGE plpgsql;

 
-- tous les etablissements inscris a l'édition 2024 ont fais un voeu donc taux=100
-- SELECT * FROM determination_taux_participation(7);
-- on fait inscrit un etablissements a l edition 2023 et il ne fera pas de voeux 
-- INSERT INTO compte (nomUtilisateur, motPasse) VALUES ('virgie_besse', 'MotDePasse123!');
-- INSERT INTO etablissement (nom, adresse, codepostal, typeE, tel, nomUtilisateur, mail) 
-- VALUES 
--    ('Université de Lorraine', '13 Rue Cours Leopold', '54000', 'universite', '656734554', 'virgie_besse', 'idmc@exemple.com');
	
--CALL etablissement_edition ('Édition 2023','virgie_besse');

 SELECT * FROM determination_taux_participation(8);