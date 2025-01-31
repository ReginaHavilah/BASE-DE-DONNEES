USE  tpDHVE;
-- ensemble des hotels de Nancy
SELECT h.id_hebergement AS Num ,h.prix AS Prix ,h.nbchambre AS NbChambre,h.nbetoiles AS NbEtoile
FROM Hotel h
JOIN Hebergement hi ON h.id_hebergement = hi.id_hebergement
JOIN Ville v ON hi.id_ville = v.id_ville
WHERE v.nom_ville = 'Nancy';

-- ensemble des avis de l'internaute ayant le pseudo ""

SELECT a.note, a.date_avis, a.commentaire
FROM Avis a
JOIN Internaute I ON a.id_avis = I.id_avis
WHERE I.pseudo = 'jeandu';

-- ensemble des attractions  ayant un avis moyen supérieur à 4 donné par les familles dans la ville de « Metz »

SELECT a.nom, a.type, a.adresse
FROM Attraction a
JOIN Avis av ON a.id_Attraction = av.id_Attraction
JOIN Ville v ON a.id_ville = v.id_ville
WHERE av.type = 'Famille'
AND v.nom_ville = 'Metz'
GROUP BY a.nom, a.type, a.adresse
HAVING AVG(av.note) > 4;

-- lesactivitésgratuites(nom,description,catégoried’attraction)proposées pour les enfants dans la ville d’« Epinal »


SELECT a.nom, a.description, at.type
FROM Activite a
JOIN Attraction at ON a.id_Attraction = at.id_Attraction
JOIN Ville v ON at.id_ville = v.id_ville
WHERE a.typep = 'enfant'
AND v.nom_ville = 'Toulouse'
AND a.prix = 0;

-- lister les hôtels (nom, ville, adresse, nombre d’étoiles) qui possèdent un restaurant
-- proposant des menus gastro dans le département de la « Paris ».

SELECT he.nom, v.nom_ville, he.adresse, h.nbetoiles
FROM Hebergement he
JOIN Hotel h ON he.id_hebergement = h.id_hebergement
JOIN Restaurant r ON r.id_Hotel = h.id_hebergement
JOIN Menu m ON r.id_restaurant = m.id_restaurant
JOIN Ville v ON r.id_ville = v.id_ville
JOIN Departement d ON v.id_departement = d.id_departement
WHERE m.type = 'gastro'
AND d.nom_departement = 'Paris';

-- le nombre de musées proposant des visites guidées pour adulte de moins 10
-- euros dans la ville de « Nancy »

SELECT COUNT(*) AS nombreMusé FROM Attraction a, Activite at ,Ville v
WHERE a.id_Attraction = at.id_Attraction
AND a.id_ville = v.id_ville
AND a.type='Musee'
AND at.typeP='adulte'
AND at.prix <10
AND v.id_ville='Nancy';
-- le prix moyen d’un menu gastro dans les villes d’« Epinal, Metz et
-- Nancy »,

SELECT AVG(m.prix) AS prismoyen
FROM Menu m
JOIN Restaurant r ON m.id_restaurant = r.id_restaurant
JOIN Ville v ON v.id_ville = r.id_ville
WHERE v.nom_ville IN ('Epinal', 'Metz', 'Nancy')
AND m.type = 'gastro'
GROUP BY m.id_menu;

-- nombres moyens de photographies associées aux attractions classés par
-- catégories d’attraction,

SELECT sous_requete.type, AVG(sous_requete.nombre_photos) AS nombreMoyen
FROM (SELECT a.type,a.id_Attraction, COUNT(*) as nombre_photos
     FROM Photographie p
     JOIN Attraction a ON a.id_Attraction = p.id_Attraction
     GROUP BY a.type, a.id_Attraction) AS sous_requete
GROUP BY
    sous_requete.type;

-- durées maximum des activités proposées dans la ville d’« Strasboug »
-- classées par forme d’activité

SELECT at.typep ,MAX(at.duree) FROM Activite at
JOIN Attraction a ON a.id_Attraction=at.id_Attraction
JOIN Ville v ON v.id_ville=a.id_ville
WHERE v.nom_ville='Strasbourg'
GROUP BY at.typeP;

-- nombre de campings ouverts en hiver et proposant des emplacements
-- pour camping car dans la ville de « Gérardmer »
SELECT COUNT(*)
FROM Camping c
JOIN Hebergement h ON c.id_hebergement = h.id_hebergement
JOIN Ville v ON h.id_ville = v.id_ville
WHERE v.nom_ville = 'Lyon'
AND c.periode = 'Ete'
AND c.typeTcamping = 'Camping car';

