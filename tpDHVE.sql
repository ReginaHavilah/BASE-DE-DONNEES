DROP DATABASE IF EXISTS tpDHVE;
CREATE DATABASE IF NOT EXISTS tpDHVE;
   USE tpDHVE;

CREATE TABLE IF NOT EXISTS Departement (
    id_departement INT UNSIGNED NOT NULL ,
    nom_departement VARCHAR(255),
    PRIMARY KEY (id_departement)
);

CREATE TABLE IF NOT EXISTS Ville (
    id_ville INT UNSIGNED NOT NULL,
    nom_ville VARCHAR(255) NOT NULL,
    code_postal INT UNSIGNED NOT NULL,
    id_departement INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_ville),
    FOREIGN KEY (id_departement) REFERENCES Departement(id_departement)
);

CREATE TABLE IF NOT EXISTS Attraction (
    id_Attraction INT UNSIGNED NOT NULL,
    id_ville INT UNSIGNED NOT NULL,
    nom VARCHAR(100),
    adresse TINYTEXT,
    localisation VARCHAR(500),
    moyenne DOUBLE,
    numTel VARCHAR (100),
    type ENUM('site touristique', 'musée','parc', 'divertissement', 'zoo','aquariums'),
    horaires tinytext,
    PRIMARY KEY (id_Attraction),
    FOREIGN KEY (id_ville) REFERENCES Ville(id_ville));

CREATE TABLE IF NOT EXISTS Activite (
    id_activite INT UNSIGNED NOT NULL,
    id_Attraction INT UNSIGNED NOT NULL,
    nom VARCHAR(255),
    description TEXT,
    typep ENUM('enfant', 'adulte'),
    duree varchar(50),
    prix REAL,
    PRIMARY KEY ( id_activite),
    FOREIGN KEY ( id_Attraction) REFERENCES Attraction(id_Attraction)
);

CREATE TABLE IF NOT EXISTS Hebergement (
    id_hebergement INT UNSIGNED NOT NULL,
    id_ville INT UNSIGNED NOT NULL,
    nom VARCHAR(100),
    adresse TINYTEXT,
    localisation VARCHAR(500),
    moyenne REAL,
    url VARCHAR(255),
    type_hebergement ENUM('Appartement', 'chambreHote','hotel', 'camping'),
    PRIMARY KEY (id_hebergement),
    FOREIGN KEY (id_ville) REFERENCES Ville(id_ville)
);

CREATE TABLE IF NOT EXISTS Hotel (
    id_hebergement INT UNSIGNED NOT NULL,
    nbetoiles INT UNSIGNED,
    nbchambre INT UNSIGNED,
    prix REAL,
    PRIMARY KEY (id_hebergement),
    FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement)
);


CREATE TABLE IF NOT EXISTS Camping (
    id_hebergement INT UNSIGNED NOT NULL,
    periode varchar(50),
    nbemplacements INT UNSIGNED,
    typeTcamping ENUM('Bungalow', 'Caravane', 'Camping Car', 'tente'),
    dprix REAL,
    PRIMARY KEY (id_hebergement),
    FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement)
);


CREATE TABLE IF NOT EXISTS Appartement (
    id_hebergement INT UNSIGNED NOT NULL,
    taille REAL,
    logement ENUM('T1', 'T2', 'T3'),
    prixNuit REAL,
    PRIMARY KEY (id_hebergement),
    FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement)
);

CREATE TABLE IF NOT EXISTS Chambre_hote (
    id_hebergement INT UNSIGNED NOT NULL,
    prixSansDej REAL,
    prixAvecDej REAL,
    PRIMARY KEY (id_hebergement),
    FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement)
);

CREATE TABLE IF NOT EXISTS Restaurant (
    id_restaurant INT UNSIGNED NOT NULL,
    id_ville INT UNSIGNED NOT NULL,
    nom VARCHAR(100),
    adresse TINYTEXT,
    localisation VARCHAR(500),
    moyenne REAL,
    type_cuisine VARCHAR(100),
    catprix INT,
    numTel VARCHAR(100),
    id_hotel INT UNSIGNED  NULL ,
    id_camping INT UNSIGNED  NULL ,
    PRIMARY KEY (id_restaurant),
    FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hebergement),
    FOREIGN KEY (id_camping) REFERENCES Camping(id_hebergement),
    FOREIGN KEY (id_ville) REFERENCES Ville(id_ville)
);

CREATE TABLE IF NOT EXISTS  Menu (
    id_menu INT UNSIGNED NOT NULL,
    id_restaurant INT UNSIGNED NOT NULL,
    nom VARCHAR(255),
    type ENUM('gastro', 'enfant', 'vegetarien'),
    choixEntree VARCHAR(255),
    choixPlats VARCHAR(255),
    choixDessert VARCHAR(255),
    prix DECIMAL(8, 2),
    PRIMARY KEY (id_menu),
    FOREIGN KEY (id_restaurant) REFERENCES Restaurant(id_restaurant)
);

CREATE TABLE IF NOT EXISTS Avis (
    id_avis INT UNSIGNED  NULL,
    id_hebergement INT UNSIGNED NULL,
    id_restaurant INT UNSIGNED  NULL,
    id_attraction INT UNSIGNED  NULL,
    note INT,
    date_avis DATE,
    commentaire TEXT,
    type ENUM('Couple', 'Famille', 'Amis', 'Solo'),
    PRIMARY KEY (id_avis),
    FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement),
    FOREIGN KEY (id_attraction) REFERENCES Attraction(id_Attraction),
    FOREIGN KEY (id_restaurant) REFERENCES Restaurant(id_restaurant)
);

CREATE TABLE IF NOT EXISTS Internaute (
    id_internaute INT UNSIGNED NOT NULL,
    id_avis INT UNSIGNED  NULL,
    pseudo VARCHAR(255),
    mdp VARCHAR(100),
    mail VARCHAR(250),
    id_ville INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_internaute),
    FOREIGN KEY (id_avis) REFERENCES Avis (id_avis),
    FOREIGN KEY (id_ville) REFERENCES Ville(id_ville)
);
CREATE TABLE IF NOT EXISTS Photographie (
    id_photo INT UNSIGNED NOT NULL,
    id_hebergement INT UNSIGNED  NULL,-- Null si c'est une photo d'un hébergement ou d'un restaurant
    id_restaurant INT UNSIGNED NULL,
    id_attraction INT UNSIGNED  NULL,
    url_photo VARCHAR(200),
    PRIMARY KEY (id_photo),
   FOREIGN KEY (id_hebergement) REFERENCES Hebergement(id_hebergement),
    FOREIGN KEY (id_attraction) REFERENCES Attraction(id_Attraction),
    FOREIGN KEY (id_restaurant) REFERENCES Restaurant(id_restaurant)
);
INSERT INTO Departement (id_Departement, nom_departement)
VALUES
  (75, 'Paris'),
  (13, 'Bouches-du-Rhône'),
  (69, 'Rhône'),
  (31, 'Haute-Garonne'),
  (6, 'Alpes-Maritimes'),
  (44, 'Loire-Atlantique'),
  (67, 'Bas-Rhin'),
  (34, 'Hérault'),
  (33, 'Gironde'),
  (59, 'Nord'),
  (35, 'Ille-et-Vilaine'),
  (78, 'Yvelines');

INSERT INTO Departement(id_departement, nom_departement) VALUES
                                                             (54, 'Meurthe-Moselle'),
                                                             (57, 'Moselle'),
                                                             (88,'Vosges');
INSERT INTO Ville(id_ville, nom_ville,code_postal, id_departement) VALUES
                                                           (13,'Aix-en-provence',13001,13),
                                                           (14, 'Aveize',69014,69 ),
                                                           (15,'Nancy',54000,54),
                                                           (16, 'Metz', 57000, 57),
                                                           (17, 'Epinal',88000,88);



INSERT INTO Ville (id_ville, nom_ville, code_postal, id_departement) VALUES
  (1, 'Paris', 75000, 75),
  (2, 'Marseille', 13000, 13),
  (3, 'Lyon', 69000, 69),
  (4, 'Toulouse', 31000, 31),
  (5, 'Nice', 06000, 6),
  (6, 'Nantes', 44000, 44),
  (7, 'Strasbourg', 67000, 67),
  (8, 'Montpellier', 34000, 34),
  (9, 'Bordeaux', 33000, 33),
  (10, 'Lille', 59000, 59),
  (11, 'Rennes', 35000, 35),
  (12, 'Versailles', 78000,78);

INSERT INTO Attraction (id_attraction, nom, adresse, localisation, moyenne, numtel, type, horaires, id_ville)
VALUES
(1, 'Tour Eiffel', 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris', 'Paris, France', 4.8, '0892701234', 'site touristique', '09:30 - 23:45', 1),
(2, 'Calanques de Marseille', 'Route des Calanques, 13009 Marseille', 'Marseille, France', 4.9, '0491142010', 'parc', '08:00 - 19:00', 2),
(3, 'Parc de la Tête d"Or', 'Allée de Ceinture du Lac, 69006 Lyon', 'Lyon, France', 4.7, '0472694760', 'parc', '06:30 - 22:30', 3),
(4, 'Cité de l"Espace', 'Avenue Jean Gonord, 31500 Toulouse', 'Toulouse, France', 4.6, '0531301500', 'divertissement', '10:00 - 18:00', 4),
(5, 'Promenade des Anglais', 'Prom. des Anglais, 06000 Nice', 'Nice, France', 4.5, '0492036200', 'site touristique', '24/7', 5),
(6, 'Château des Ducs de Bretagne', '4 Place Marc Elder, 44000 Nantes', 'Nantes, France', 4.7, '0811532530', 'divertissement', '10:00 - 18:00', 6),
(7, 'Cathédrale de Strasbourg', 'Place de la Cathédrale, 67000 Strasbourg', 'Strasbourg, France', 4.8, '0388214343', 'site touristique', '07:00 - 19:00', 7),
(8, 'Place de la Comédie', 'Place de la Comédie, 34000 Montpellier', 'Montpellier, France', 4.6, '0467666000', 'site touristique', '24/7', 8),
(9, 'Miroir d"Eau', 'Place de la Bourse, 33000 Bordeaux', 'Bordeaux, France', 4.7, '0556442400', 'site touristique', '24/7', 9),
(10, 'Vieille Bourse', 'Place du Général de Gaulle, 59000 Lille', 'Lille, France', 4.5, '0320574000', 'site touristique', '09:00 - 18:00', 10),
(11, 'Parlement de Bretagne', 'Place du Parlement, 35000 Rennes', 'Rennes, France', 4.6, '0299286600', 'site touristique', '10:00 - 17:00', 11),
(12, 'Château de Versailles', 'Place d"Armes, 78000 Versailles', 'Versailles, France', 4.7, '0130837800', 'site touristique', '09:00 - 18:30', 12),
(13, 'Cours Mirabeau', 'Cours Mirabeau, 13100 Aix-en-Provence', 'Aix-en-Provence, France', 4.6, '0442911500', 'site touristique', '24/7', 13),
(14, 'Monts du Lyonnais', 'Aveize, 69610', 'Aveize, France', 4.8, '0478190101', 'parc', '24/7', 14),
(15, 'Place Stanislas', 'Place Stanislas, 54000 Nancy', 'Nancy, France', 4.9, '0383353663', 'site touristique', '24/7', 15);

INSERT INTO Activite (id_activite, nom, description, typeP, duree, prix, id_Attraction)
VALUES
(1, 'Visite Tour Eiffel', 'Visite guidée de la Tour Eiffel, y compris l"accès au sommet.', 'adulte', '2 heures', 25, 1),
(2, 'Randonnée Calanques', 'Randonnée guidée dans les Calanques de Marseille.', 'adulte', '4 heures', 30, 2),
(3, 'Zoo du Parc de la Tête d"Or', 'Visite du zoo au sein du Parc de la Tête d"Or.', 'enfant', '2 heures', 15, 3),
(4, 'Exploration de l"Espace', 'Visite interactive de la Cité de l"Espace.', 'enfant', '3 heures', 20, 4),
(5, 'Balade sur la Promenade', 'Balade guidée sur la Promenade des Anglais.', 'adulte', '1 heure 30 minutes', 10, 5),
(6, 'Histoire des Ducs de Bretagne', 'Tour guidé du Château des Ducs de Bretagne.', 'adulte', '2 heures', 20, 6),
(7, 'Tour de la Cathédrale', 'Visite guidée de la Cathédrale de Strasbourg.', 'adulte', '1 heure', 10, 7),
(8, 'Découverte de Montpellier', 'Tour à pied de la Place de la Comédie et alentours.', 'adulte', '2 heures', 15, 8),
(9, 'Miroir d"Eau et ses secrets', 'Visite et atelier photographique au Miroir d"Eau.', 'adulte', '2 heures', 20, 9),
(10, 'Lille Historique', 'Visite guidée historique de la Vieille Bourse de Lille.', 'adulte', '1 heure 30 minutes', 15, 10),
(11, 'Mystères du Parlement', 'Visite mystérieuse du Parlement de Bretagne.', 'adulte', '2 heures', 25, 11),
(12, 'Château de Versailles Royal', 'Visite complète du Château de Versailles.', 'adulte', '3 heures', 35, 12),
(13, 'Promenade à Aix', 'Balade guidée sur le Cours Mirabeau.', 'adulte', '1 heure', 10, 13),
(14, 'Randonnée Monts du Lyonnais', 'Randonnée guidée à travers les Monts du Lyonnais.', 'adulte', '5 heures', 40, 14),
(15, 'Découverte de Nancy', 'Visite guidée de la Place Stanislas et ses alentours.', 'adulte', '2 heures', 20, 15);

INSERT INTO Hebergement (id_hebergement, nom, adresse, localisation, moyenne, url, type_hebergement, id_ville)
VALUES
(1, 'Hotel de Paris', '1 Rue de la Paix, 75002 Paris', 'Paris, France', 4.8, 'https://hotelparis.com', 'Hotel', 1),
(2, 'Marseille Seaside Resort', '50 Boulevard de la Plage, 13008 Marseille', 'Marseille, France', 4.5, 'https://marseilleresort.com', 'Hotel', 2),
(3, 'Lyon City Apartments', '100 Rue de la République, 69002 Lyon', 'Lyon, France', 4.3, 'https://lyonapartments.com', 'Appartement', 3),
(4, 'Camping Toulouse', 'Parc de la Reynerie, 31000 Toulouse', 'Toulouse, France', 4.0, 'https://campingtoulouse.com', 'Camping', 4),
(5, 'Nice Bed & Breakfast', '25 Avenue des Fleurs, 06000 Nice', 'Nice, France', 4.6, 'https://nicebedbreakfast.com', 'chambreHote', 5),
(6, 'Nantes Holiday Inn', '10 Place Royale, 44000 Nantes', 'Nantes, France', 4.4, 'https://nantesholidayinn.com', 'Hotel', 6),
(7, 'Strasbourg Eco Lodge', '5 Rue du Dôme, 67000 Strasbourg', 'Strasbourg, France', 4.7, 'https://strasbourgecolodge.com', 'Appartement', 7),
(8, 'Montpellier Camping', '300 Avenue de la Liberté, 34000 Montpellier', 'Montpellier, France', 4.2, 'https://montpelliercamping.com', 'Camping', 8),
(9, 'Bordeaux Chateau Stay', '780 Route des Chateaux, 33000 Bordeaux', 'Bordeaux, France', 4.9, 'https://bordeauxchateau.com', 'Hotel', 9),
(10, 'Lille Loft Apartments', '48 Rue de la Clef, 59000 Lille', 'Lille, France', 4.5, 'https://lillelofts.com', 'Appartement', 10),
(11, 'Rennes City Center Hotel', '15 Avenue Janvier, 35000 Rennes', 'Rennes, France', 4.4, 'https://rennescityhotel.com', 'Hotel', 11),
(12, 'Versailles Royal Stay', '22 Rue de la Paroisse, 78000 Versailles', 'Versailles, France', 4.7, 'https://versaillesroyalstay.com', 'Hotel', 12),
(13, 'Aix-en-Provence Guest House', '30 Rue des Tanneurs, 13100 Aix-en-Provence', 'Aix-en-Provence, France', 4.6, 'https://aixguesthouse.com', 'chambreHote', 13),
(14, 'Aveize Countryside Camping', 'Les Balcons du Lyonnais, 69610 Aveize', 'Aveize, France', 4.3, 'https://aveizecamping.com', 'Camping', 14),
(15, 'Nancy Urban Apartments', '5 Rue Saint-Dizier, 54000 Nancy', 'Nancy, France', 4.5, 'https://nancyurbanapartments.com', 'Appartement', 15);

INSERT INTO Hotel (id_hebergement, nbetoiles, nbchambre, prix)
VALUES
(1, 5, 150, 300),
(2, 4, 100, 200),
(3, 3, 80, 100),
(4, 4, 120, 180),
(5, 5, 200, 350),
(6, 3, 75, 90),
(7, 4, 110, 220),
(8, 5, 130, 260),
(9, 3, 60, 120),
(10, 4, 140, 280),
(11, 3, 85, 160),
(12, 5, 170, 340),
(13, 4, 95, 190),
(14, 3, 70, 140),
(15, 4, 105, 210);

INSERT INTO Camping (id_hebergement, periode, nbemplacements, typeTcamping, dprix)
VALUES
(1, 'Hiver', 100, 'Bungalow', 50),
(2, 'Printemps', 80, 'Caravane', 40),
(3, 'Ete', 120, 'Camping Car', 30),
(4, 'Hiver', 150, 'tente', 45),
(5, 'Automne', 90, 'Bungalow', 55),
(6, 'Printemps', 110, 'Caravane', 35),
(7, 'Ete', 130, 'Bungalow', 60),
(8, 'Hiver', 140, 'Camping Car', 50),
(9, 'Automne', 100, 'tente', 45),
(10, 'Printemps', 85, 'Camping Car', 40),
(11, 'Automne', 95, 'Bungalow', 35),
(12, 'Hiver', 105, 'Camping Car', 55),
(13, 'Ete', 115, 'Bungalow', 50),
(14, 'Automne', 125, 'tente', 45),
(15, 'Hiver', 135, 'tente', 40);

INSERT INTO Appartement (id_hebergement, logement, taille, prixNuit)
VALUES
(1, 'T1', 30, 70),
(2, 'T2', 45, 85),
(3, 'T3', 60, 100),
(4, 'T2', 50, 90),
(5, 'T1', 25, 65),
(6, 'T2', 40, 80),
(7, 'T3', 55, 95),
(8, 'T2', 45, 85),
(9, 'T1', 35, 75),
(10, 'T2', 50, 100),
(11, 'T3', 65, 110),
(12, 'T2', 60, 105),
(13, 'T1', 40, 80),
(14, 'T2', 55, 90),
(15, 'T3', 70, 115);

INSERT INTO Chambre_hote (id_hebergement, prixSansDej, prixAvecdej)
VALUES
(1, 80, 95),
(2, 75, 90),
(3, 70, 85),
(4, 65, 80),
(5, 60, 75),
(6, 55, 70),
(7, 50, 65),
(8, 80, 95),
(9, 75, 90),
(10, 70, 85),
(11, 65, 80),
(12, 60, 75),
(13, 55, 70),
(14, 50, 65),
(15, 80, 95);


INSERT INTO Restaurant (id_restaurant, nom, adresse, localisation, moyenne, numTel, type_cuisine, catPrix, id_ville, id_hotel, id_camping)
VALUES
(1, 'Le Gourmet', '123 Rue de Cuisine, Paris', 'Paris, France', 4.5, '0123456789', 'Française', 3, 1, 1, NULL),
(2, 'La Terrasse', '456 Sea View, Marseille', 'Marseille, France', 4.3, '0234567891', 'Méditerranéenne', 1, 2, NULL, 2),
(3, 'Le Delice', '789 Gourmet St, Lyon', 'Lyon, France', 4.7, '0345678912', 'Locale', 3, 3, 3, NULL),
(4, 'Chez Toulouse', '101 Delicious Ave, Toulouse', 'Toulouse, France', 4.4, '0456789123', 'Traditionnelle', 1, 4, NULL, 4),
(5, 'Nice Flavors', '202 Ocean Rd, Nice', 'Nice, France', 4.6, '0567891234', 'Fruits de mer', 3, 5, 5, NULL),
(6, 'Nantes Seafood', '303 River St, Nantes', 'Nantes, France', 4.2, '0678912345', 'Fruits de mer', 1, 6, 6, NULL),
(7, 'Strasbourg Corner', '404 Wine St, Strasbourg', 'Strasbourg, France', 4.5, '0789123456', 'Locale', 2, 7, NULL, 7),
(8, 'Montpellier Bistro', '505 Sun Ave, Montpellier', 'Montpellier, France', 4.3, '0891234567', 'Méditerranéenne', 1, 8, NULL, 8),
(9, 'Bordeaux Gourmet', '606 Vineyard Blvd, Bordeaux', 'Bordeaux, France', 4.6, '0912345678', 'Française', 3, 9, 9, NULL),
(10, 'Lille Lounge', '707 Chic St, Lille', 'Lille, France', 4.4, '1023456789', 'Moderne',3, 10, NULL, 10),
(11, 'Rennes Bistro', '808 Garden Rd, Rennes', 'Rennes, France', 4.3, '1123456789', 'Traditionnelle', 1, 11, 11, NULL),
(12, 'Versailles Royal', '909 Palace St, Versailles', 'Versailles, France', 4.8, '1223456789', 'Gastronomique', 3, 12, NULL, 12),
(13, 'Aix-en-Provence Café', '233 Lavender Ln, Aix-en-Provence', 'Aix-en-Provence, France', 4.5, '1323456789', 'Locale', 1, 13, NULL, 13),
(14, 'Aveize Country', '321 Countryside Rd, Aveize', 'Aveize, France', 4.2, '1423456789', 'Rustique', 2, 14, NULL, 14),
(15, 'Nancy Delight', '123 City Center, Nancy', 'Nancy, France', 4.4, '1523456789', 'Moderne', 2, 15, 15, NULL);


INSERT INTO Menu (id_menu, nom, type, choixEntree, choixPlats, choixDessert, prix, id_restaurant)
VALUES
(1, 'Menu Gourmet', 'gastro', 'Foie Gras', 'Boeuf Bourguignon', 'Crème Brûlée', 50, 1),
(2, 'Menu Enfants', 'enfant', 'Tomates Cerises', 'Poulet Frites', 'Glace', 15, 2),
(3, 'Menu Végétarien', 'vegetarien', 'Salade de Quinoa', 'Risotto aux Champignons', 'Tarte aux Pommes', 35, 3),
(4, 'Menu du Chef', 'gastro', 'Carpaccio de Saint-Jacques', 'Magret de Canard', 'Fondant au Chocolat', 55, 4),
(5, 'Menu Mer', 'gastro', 'Huîtres', 'Loup de Mer', 'Sorbet Citron', 45, 5),
(6, 'Menu Tradition', 'gastro', 'Pâté en Croûte', 'Coq au Vin', 'Tarte Tatin', 40, 6),
(7, 'Menu Alsacien', 'gastro', 'Flammekueche', 'Choucroute Garnie', 'Kougelhopf', 50, 7),
(8, 'Menu Méditerranéen', 'vegetarien', 'Taboulé', 'Tajine de Légumes', 'Panna Cotta', 30, 8),
(9, 'Menu Bordelais', 'gastro', 'Escargots', 'Entrecôte à la Bordelaise', 'Cannelés', 60, 9),
(10, 'Menu du Nord', 'gastro', 'Soupe à l"Oignon', 'Moules Frites', 'Gaufres', 35, 10),
(11, 'Menu Breton', 'gastro', 'Crêpes au Froment', 'Kig Ha Farz', 'Far Breton', 40, 11),
(12, 'Menu Royal', 'gastro', 'Saumon Fumé', 'Filet Mignon', 'Macarons', 65, 12),
(13, 'Menu Provençal', 'vegetarien', 'Ratatouille', 'Socca', 'Tarte de Figues', 30, 13),
(14, 'Menu Champêtre', 'gastro', 'Terrine de Campagne', 'Potée', 'Clafoutis', 35, 14),
(15, 'Menu Lorrain', 'gastro', 'Quiche Lorraine', 'Bœuf Bourguignon', 'Madeleines', 40, 15);


INSERT INTO Avis (id_avis, note, date_avis, commentaire, type, id_restaurant, id_Attraction, id_hebergement) VALUES
(101, 4, '2023-11-15', 'Très bon restaurant, service impeccable.', 'Couple', 1, null, null),
(102, 5, '2023-11-16', 'Visite inoubliable, guides compétents.', 'Famille', null, 3, null),
(103, 3, '2023-11-17', 'Hôtel correct mais un peu bruyant.', 'Solo', null, null, 4),
(104, 5, '2023-11-18', 'Cuisine délicieuse, ambiance agréable.', 'Amis', 2, null, null),
(105, 2, '2023-11-19', 'Attraction décevante, trop d"attente.', 'Couple', null, 7, null),
(106, 4, '2023-11-20', 'Hôtel charmant, personnel accueillant.', 'Famille', null, null, 8),
(107, 5, '2023-11-21', 'Restaurant fantastique, plats exquis.', 'Solo', 13, null, null),
(108, 3, '2023-11-22', 'Attraction amusante mais assez chère.', 'Amis', null, 14, null),
(109, 4, '2023-11-23', 'Séjour agréable, hôtel bien situé.', 'Couple', null, null, 13),
(110, 5, '2023-11-24', 'Excellente expérience, à recommander.', 'Famille', 3, null, null),
(111, 2, '2023-11-25', 'Attraction surfaite, pas à la hauteur.', 'Solo', null, 4, null),
(112, 4, '2023-11-26', 'Hôtel confortable, bon rapport qualité-prix.', 'Amis', null, null, 4),
(113, 5, '2023-11-27', 'Restaurant haut de gamme, service impeccable.', 'Couple', 5, null, null),
(114, 3, '2023-11-28', 'Visite intéressante mais un peu courte.', 'Famille', null, 5, null),
(115, 4, '2023-11-29', 'Hôtel moderne, chambres spacieuses.', 'Solo', null, null, 13);


INSERT INTO Internaute (id_internaute, mail, pseudo, mdp, id_ville, id_avis) VALUES
(1, 'jean.dupont@email.com', 'jeandu', 'mdp123', 5, 101),
(2, 'marie.leroy@email.com', 'marielr', 'mdp456', 3, 102),
(3, 'luc.brunet@email.com', 'lucb88', 'mdp789', 11, 103),
(4, 'sophie.martin@email.com', 'sophiem', 'mdp101', 2, 104),
(5, 'paul.durand@email.com', 'pauld', 'mdp202', 7, 105),
(6, 'laura.petit@email.com', 'laurap', 'mdp303', 13, 106),
(7, 'remi.roux@email.com', 'remir', 'mdp404', 1, 107),
(8, 'chloe.moreau@email.com', 'chloem', 'mdp505', 15, 108),
(9, 'vincent.simmon@email.com', 'vincents', 'mdp606', 6, 109),
(10, 'elise.blanc@email.com', 'eliseb', 'mdp707', 4, 110),
(11, 'guillaume.bernard@email.com', 'guillaumeb', 'mdp808', 9, 111),
(12, 'claire.girard@email.com', 'claireg', 'mdp909', 8, 112),
(13, 'olivier.thomas@email.com', 'oliviert', 'mdp010', 10, 113),
(14, 'julie.robert@email.com', 'julier', 'mdp111', 12, 114),
(15, 'nicolas.richard@email.com', 'nicolasr', 'mdp212', 14, 115);


INSERT INTO Photographie (id_photo, url_photo, id_restaurant, id_Attraction, id_hebergement) VALUES
(1001, 'http://example.com/photo1.jpg', 1, null, null),
(1002, 'http://example.com/photo2.jpg', null, 3, null),
(1003, 'http://example.com/photo3.jpg', null, null, 4),
(1004, 'http://example.com/photo4.jpg', 2, null, null),
(1005, 'http://example.com/photo5.jpg', null, 10, null),
(1006, 'http://example.com/photo6.jpg', null, null, 12),
(1007, 'http://example.com/photo7.jpg', 2, null, null),
(1008, 'http://example.com/photo8.jpg', null, 3, null),
(1009, 'http://example.com/photo9.jpg', null, null, 4),
(1010, 'http://example.com/photo10.jpg', 12, null, null),
(1011, 'http://example.com/photo11.jpg', null, 14, null),
(1012, 'http://example.com/photo12.jpg', null, null, 14),
(1013, 'http://example.com/photo13.jpg', 5, null, null),
(1014, 'http://example.com/photo14.jpg', null, 7, null),
(1015, 'http://example.com/photo15.jpg', null, null, 15);


-- Creation des index entre la date ou un avis est donné et la note donné
ALTER TABLE Avis
 ADD INDEX classAvis(date_avis,note);


 CREATE USER 'internauteDHVE'@'localhost' IDENTIFIED BY 'jesuis4';
 GRANT SELECT ON tpDHVE.* TO 'internauteDHVE'@'localhost';

 CREATE USER 'gestionnaireDHVE'@'localhost' IDENTIFIED BY 'jegere5';
 GRANT SELECT, UPDATE, INSERT, DELETE ON tpDHVE.* TO 'gestionnaireDHVE'@'localhost';

 CREATE USER 'administrateurDHVE'@'localhost' IDENTIFIED BY 'hereisBoss2';
GRANT ALL PRIVILEGES  ON tpDHVE.* TO 'administrateurDHVE'@'localhost';

 CREATE USER 'utilisateurDHVE'@'localhost' IDENTIFIED BY 'hello6';
 GRANT INSERT ON tpDHVE.Internaute TO 'utilisateurDHVM'@'localhost';
 GRANT INSERT ON tpDHVE.Avis TO 'utilisateurDHVE'@'localhost';

CREATE VIEW VueB11 AS
    SELECT A.nom, A.adresse, A.type
FROM Attraction A
JOIN Activite Act ON A.id_Attraction = Act.id_Attraction
JOIN Avis Av ON A.id_Attraction = Av.id_Attraction
WHERE
    -- Extraire l'heure d'ouverture et de fermeture
    TIME(SUBSTRING_INDEX(A.horaires, ' - ', 1)) <= TIME('12:00:00')
    AND TIME(SUBSTRING_INDEX(SUBSTRING_INDEX(A.horaires, ' - ', -1), ' ', 1)) >= TIME('12:00:00')
    AND A.id_ville = 'Strasbourg'
    AND Act.typep = 'enfant'
    AND Act.prix = 0
    AND Av.type = 'famille'
    AND Av.note > 4;


CREATE VIEW Moyennes AS
SELECT
    'Attraction' AS Categorie,
    a.Nom AS Nom,
    a.Adresse AS Adresse,
    a.id_ville AS id_ville,
    AVG(n.Note) AS MoyenneNotes
FROM
    Attraction a
JOIN Avis n ON a.id_Attraction = n.id_Attraction
WHERE n.type = 'Couple'
GROUP BY a.id_Attraction

UNION

SELECT
    'Hotel' AS Categorie,
    H2.nom AS Nom,
    H2.Adresse AS Adresse,
    H2.id_ville AS id_ville,
    AVG(n.Note) AS MoyenneNotes
FROM
    Hotel h
JOIN Hebergement H2 on H2.id_hebergement = h.id_hebergement
JOIN Avis n ON h.id_hebergement = n.id_hebergement
WHERE n.type = 'Couple'
GROUP BY h.id_hebergement

UNION

SELECT
    'Restaurant' AS Categorie,
    r.Nom AS Nom,
    r.Adresse AS Adresse,
    r.id_ville AS id_ville,
    AVG(n.Note) AS MoyenneNotes
FROM
    Restaurant r
JOIN Avis n ON r.id_Restaurant = n.id_Restaurant
WHERE n.type = 'Couple'
GROUP BY r.id_Restaurant;


DROP PROCEDURE IF EXISTS procB12;
CREATE PROCEDURE procB12(IN villeVoulue INT)
BEGIN
    -- Préparation de la requête
    PREPARE requete12 FROM
    'SELECT Nom, Categorie, Adresse
    FROM Moyennes
    WHERE id_ville = ?
    GROUP BY Categorie
    ORDER BY MoyenneNotes DESC';

    -- Exécution de la requête avec le paramètre
    EXECUTE requete12 USING villeVoulue;

    -- Libération de la requête préparée
    DEALLOCATE PREPARE requete12;
END ;
CALL procB12 (1);


-- la création d’un Trigger « trig1 » qui vérifie si la relation entre une ville et le département sont bien  défini
-- Ce trigger empêchera l'insertion de toute nouvelle ville dans la table Ville si l'id_departement associé n'existe pas dans la table Departement
CREATE TRIGGER trig1
BEFORE INSERT ON Ville
FOR EACH ROW
BEGIN
    DECLARE departement_exists INT;

    -- Vérifier si l'id_departement existe dans la table Departement
    SELECT COUNT(*)
    INTO departement_exists
    FROM Departement
    WHERE id_departement = NEW.id_departement;

    -- déterminer si le département existe ou non
    IF departement_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''id_departement donné n''existe pas dans la table Departement.';
    END IF;

END;


INSERT INTO Ville (id_ville, nom_ville, id_departement)
VALUES (102, 'Fictionville', 2);


