-- insertion 

INSERT INTO compte (nomUtilisateur, motPasse) VALUES
('john_doe', 'MotDePasse123!'),
('alice_smith', 'P@ssw0rd'),
('emma_jones', 'Secret789*'),
('mike_wilson', 'StrongPassword1!'),
('sarah_brown', 'SecurePass123$'),
('david_miller', 'Pa$$w0rd!'),
('laura_taylor', 'Pass123word$'),
('chris_jackson', 'MyP@ssw0rd!'),
('jennifer_clark', 'ComplexPwd123!'),
('ryan_anderson', 'Secure123*'),
('emily_thomas', 'StrongP@ssw0rd!'),
('jason_white', 'Pwd123!4'),
('sophia_harris', 'P@ssw0rd123!'),
('alexandra_martin', 'SecurePassword123!'),
('kevin_cook', 'MySecretPwd123!'),
('jessica_young', 'StrongPwd456!');

INSERT INTO langue (nom) VALUES 
    ('anglais'),
    ('allemand'),
    ('espagnol'),
    ('français'),
    ('chinois'),
    ('hindi'),
    ('arabe')
;


INSERT INTO commission (nom, adresse, nomUtilisateur) 
VALUES ('commission scolaire', '123 Rue de l''École, Villeville, Pays', 'john_doe');


INSERT INTO interprete (nom, prenom, mail, telephone, nomUtilisateur, adresse) 
VALUES 
    ('Dupont', 'Jean', 'jean.dupont@example.com', '1234567890', 'emma_jones', '10 Rue de la Liberté, Ville'),
    ('Smith', 'Emily', 'emily.smith@example.com', '9876543210', 'mike_wilson', '20 Avenue des Fleurs, Villeneuve'),
    ('Garcia', 'Maria', 'maria.garcia@example.com', '5555555555', 'sarah_brown', '30 Rue du Château, Villefort'),
    ('Chang', 'Li', 'li.chang@example.com', '9999999999', 'jennifer_clark', '40 Rue du Moulin, Villeneuve-sur-Lot')
;

INSERT INTO edition (annee, date_debut, date_fin, nom_edition, id_commission) 
VALUES 
    (2024, '2024-06-01', '2024-06-05', 'Édition 2024', 3),
    (2023, '2023-07-01', '2023-07-05', 'Édition 2023', 3),
    (2022, '2022-08-01', '2022-08-05', 'Édition 2022', 3),
    (2021, '2021-09-01', '2021-09-05', 'Édition 2021', 3)
;


INSERT INTO etablissement (nom, adresse, codepostal, typeE, tel, nomUtilisateur, mail) 
VALUES 
    ('Université de Ville', '123 Avenue des Sciences', '12345', 'universite', '123456789', 'david_miller', 'universite@exemple.com'),
    ('Lycée Paul Valéry', '456 Rue du Lycée', '54321', 'lycee general', '987654321', 'laura_taylor', 'lycee@exemple.com'),
    ('Collège Marcel Pagnol', '789 Rue du Collège', '67890', 'college', '555556555', 'chris_jackson', 'college@exemple.com'),
    ('École Maternelle Victor Hugo', '1010 Rue de l''Ecole', '13579', 'Ecole primaire ou maternelle', '997999999', 'jennifer_clark', 'ecole@exemple.com')
;


INSERT INTO auteur (nom, prenom, mail, telephone, biographie, adresse, nomUtilisateur) 
VALUES 
    ('Martin', 'Jean', 'jean.martin@example.com', '123456789', 'Jean Martin est un auteur prolifique avec une passion pour les romans d''aventure.', '123 Rue des Auteurs', 'jason_white'),
    ('Gagnon', 'Sophie', 'sophie.gagnon@example.com', '987654321', 'Sophie Gagnon est une poète talentueuse connue pour ses vers libres.', '456 Avenue des Poètes', 'sophia_harris'),
    ('Tremblay', 'Michel', 'michel.tremblay@example.com', '555555555', 'Michel Tremblay est un dramaturge québécois reconnu pour ses pièces intimistes.', '789 Boulevard des Dramaturges', 'alexandra_martin'),
    ('Lavoie', 'Isabelle', 'isabelle.lavoie@example.com', '999999999', 'Isabelle Lavoie est une romancière passionnée par les récits historiques.', '1010 Chemin des Romanciers', 'kevin_cook')
;

INSERT INTO accompagnateur (nom, prenom, mail, adresse, telephone, nomUtilisateur) 
VALUES 
    ('Girard', 'Marie', 'marie.girard@example.com', '123 Rue des Accompagnateurs', '1234567890', 'emily_thomas'),
    ('Lefebvre', 'Pierre', 'pierre.lefebvre@example.com', '456 Avenue de l''Accompagnement', '9876543210', 'jessica_young'),
    ('Boucher', 'Sophie', 'sophie.boucher@example.com', '789 Boulevard du Soutien', '5555557555', 'ryan_anderson')
;

INSERT INTO ouvrage (titre, date_publication, genre, classe_concerne, public_cible) 
VALUES 
    ('Le Destin de l''Élue', '2023-05-15', 'fantastique', '5IEME', 'adolescent'),
    ('Les Ombres du Passé', '2022-09-20', 'thriller', 'PREMIERE', 'adulte'),
    ('L''Énigme du Manoir', '2023-02-10', 'policier', '4IEME', 'enfant'),
    ('Au-delà des Étoiles', '2022-12-30', 'science-fiction', 'SECONDE', 'adolescent'),
    ('Le Mystère de la Forêt Maudite', '2023-06-25', 'horreur', 'CM2', 'enfant'),
    ('L''École des Sorciers', '2022-11-05', 'fantastique', '6IEME', 'enfant'),
    ('La Dernière Légende', '2022-10-10', 'historique', 'TERMINAL', 'adulte'),
    ('Le Secret du Pharaon', '2023-03-18', 'Drame', '3IEME', 'enfant'),
    ('Les Murmures de l''Océan', '2023-07-20', 'romantique', 'Superieur', 'adulte'),
    ('L''Empire des Dragons', '2022-08-08', 'fantastique', 'PREMIERE', 'adolescent')
;


INSERT INTO campagne_voeux (date_debut, date_fin, id_commission)
VALUES 
    ('2024-06-01', '2024-06-30', 3),
    ('2025-07-01', '2025-07-31', 3)
;

-- SELECT * FROM langue; 15 … 21
INSERT INTO voeux (date_emission, ordre_preference, etatVoeux, id_langue, id_etablissement, id_campagne, id_livre) 
VALUES 
    ('2024-06-15', '1', 'en attente', 15, 1, 1, 1),
    ('2024-06-16', '2', 'en attente', 18, 1, 1, 1),
    ('2024-04-17', '1', 'en attente', 15, 2, 1, 1),
    ('2024-04-18', '2', 'en attente', 16, 2, 1, 1),
    ('2024-04-19', '1', 'en attente', 17, 3, 2, 1),
    ('2024-04-20', '2', 'en attente', 18, 3, 2, 1)
;

-- SELECT * FROM voeux; 7…12
-- SELECT * FROM etablissement; 1…4
INSERT INTO referent (nom, prenom, mail, telephone, id_etablissement, id_voeux) 
VALUES 
    ('Dubois', 'Sophie', 'sophie.dubois@example.com', '1234567870', 1, 7),
    ('Lefevre', 'Pierre', 'pierre.lefevre@example.com', '9876545210', 2, 9),
    ('Moreau', 'Charlotte', 'charlotte.moreau@example.com', '5445555555', 3, 12),
    ('Leroy', 'Alexandre', 'alexandre.leroy@example.com', '1113311111', 1, 9),
    ('Garcia', 'Elena', 'elena.garcia@example.com', '99994599999', 2, 8),
    ('Roux', 'Lucie', 'lucie.roux@example.com', '7777774567', 3, 11)
;

-- SELECT * FROM interprete; 9…12
INSERT INTO intervention (dateIntervention, lieu, heure_debut, heure_fin, etat, nbPresent, id_etablissement, id_commission, id_interprete) 
VALUES 
    ('2024-06-15', 'Salle de réunion A', '09:00', '11:00', 'planifie', 0, 1, 3, 9),
    ('2024-06-16', 'Salle de conférence B', '10:00', '12:00', 'planifie', 0, 2, 3, 10),
    ('2024-06-17', 'Amphithéâtre C', '13:00', '15:00', 'planifie', 40, 3, 3, 9),
    ('2024-06-18', 'Salle polyvalente D', '14:00', '16:00', 'planifie', 25, 1, 3, 11),
    ('2024-06-19', 'Auditorium E', '15:00', '17:00', 'planifie', 35, 2, 3, 10),
    ('2024-06-20', 'Salle de formation F', '16:00', '18:00', 'planifie', 45, 3, 3, 12)
;


-- intervention_accompagnateur
INSERT INTO intervention_accompagnateur (id_intervention, id_accompagnateur) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 3);

-- intervention_auteur
INSERT INTO intervention_auteur (id_intervention, id_auteur) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

-- auteur_ouvrage
INSERT INTO auteur_ouvrage (id_auteur, id_livre) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

-- auteur_langues
INSERT INTO auteur_langues (id_auteur, id_langue) VALUES
    (1, 15),
    (1, 18),
    (1, 16),
    (2, 17),
    (2, 16),
    (2, 21),
    (3, 19),
    (3, 15),
    (4, 15),
    (4, 16);


INSERT INTO etablissement_edition (id_etablissement, id_edition) VALUES
    (1, 7),
    (2, 7),
    (1, 9),
    (2, 10),
    (3, 8),
    (3, 9),
    (4, 10),
    (4, 8);

-- auteur_edition
INSERT INTO auteur_edition (id_auteur, id_edition) VALUES
    (1, 7),
    (2, 7),
    (1, 9),
    (2, 10),
    (3, 8),
    (3, 9),
    (4, 10),
    (4, 8),
    (4, 9);

-- accompagnateur_edition
INSERT INTO accompagnateur_edition (id_accompagnateur, id_edition) VALUES
    (1, 7),
    (2, 7),
    (1, 9),
    (2, 10),
    (3, 8),
    (3, 9),
    (2, 9);

-- interprete_edition
INSERT INTO interprete_edition (id_interprete, id_edition) VALUES
   (9, 7),
    (10, 7),
    (10, 9),
    (11, 10),
    (12, 8),
    (9, 9),
    (10, 10),
    (12, 7);

-- ouvrage_langue
SELECT * FROM langue;
INSERT INTO ouvrage_langue (id_livre, id_langue) VALUES
    (1, 15),
    (2, 18),
    (3, 15),
    (4, 18);
    

-- interprete_langue_parlee
INSERT INTO interprete_langue_parlee (id_interprete, id_langue_parlee) VALUES
    (9, 15),
    (10,18),
    (10, 17),
    (10, 15);

-- interprete_langue_interpretee
INSERT INTO interprete_langue_interpretee (id_interprete, id_langue_interpretee) VALUES
    (10, 15),
    (9, 18),
    (11, 17),
    (11, 19),
    (11, 15),
    (10, 18);

