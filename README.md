# BASE-DE-DONNEES
Ce projet vise à concevoir, structurer et interroger une base de données relationnelle. Il comprend la modélisation des données (MCD, MLD), l’implémentation en SQL, ainsi que des requêtes d’analyse pour extraire des insights pertinents.( projet 1)
### **📜 README.md – Projet de Base de Données pour un Festival Littéraire- Projet 2**  



---

```md
# 📂 Conception d’un Système d’Information pour un Festival Littéraire 📚

## 📝 Présentation du projet
Ce projet vise à développer un **système d'information** permettant la **gestion et la planification** des interventions d’auteurs dans les établissements scolaires, universitaires et pénitentiaires lors d’un **festival littéraire international**.  

L’objectif principal est d’optimiser la coordination des **auteurs, établissements, accompagnateurs et interprètes**, tout en assurant une **gestion efficace des inscriptions, des vœux des établissements et des interventions**.

---

## 🎯 Objectifs
✔️ Développer un **système de gestion de base de données relationnelle** pour le suivi des interventions du festival  
✔️ Implémenter des fonctionnalités de **gestion des inscriptions, des éditions, des interventions et des statistiques**  
✔️ Appliquer les **principes de normalisation et d’intégrité des données**  
✔️ Mettre en place une **interface web** pour faciliter l'interaction entre les différents acteurs  

---

## 📌 Acteurs du système
👥 **La commission** : Gère l’organisation du festival et valide les vœux des établissements  
🏫 **Les établissements** : Soumettent des vœux pour les interventions  
🖊 **Les auteurs** : Interviennent dans les établissements pour des conférences  
👨‍🏫 **Les accompagnateurs & interprètes** : Assistent les auteurs lors des interventions  

---

## 📂 Structure du projet
📁 `schema/` → Contient les **modèles UML (diagrammes de classes, Use Case, MCD, MLD)**  
📁 `data/` → Contient les **exemples de données** (fichiers  SQL)  
📁 `scripts/` → Contient les **scripts SQL pour la création et manipulation de la base de données**  
📁 `web/` → Contient les **fichiers du site web**   
📁 `rapport/` → Contient le **rapport détaillé du projet** en PDF  

---

## 🛠️ Technologies utilisées
- **Base de données** : PostgreSQL / MySQL  
- **Langage SQL** : Requêtes de gestion des données, création de tables, contraintes d’intégrité  
- **Outils de conception** : MySQL Workbench, DBeaver, PgAdmin  
- **Développement Web (si applicable)** : PHP, HTML, CSS, JavaScript  
- **Visualisation des données** : Power BI, Metabase  

---

## 📊 Modélisation des données
- 📌 **Diagramme de classes** pour définir les entités du système  
- 📌 **Modèle conceptuel de données (MCD)** et **Modèle logique de données (MLD)**  
- 📌 **Contraintes d’intégrité** pour assurer la cohérence des données  
- 📌 **Requêtes SQL avancées** pour gérer les statistiques du festival  

---

## 📜 Exemples de requêtes SQL
🔹 **Création de la table des auteurs** :
```sql
CREATE TABLE Auteurs (
    id_auteur SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    biographie TEXT
);
```
🔹 **Requête pour obtenir les interventions prévues pour un auteur** :
```sql
SELECT A.nom, A.prenom, E.nom_etablissement, I.date_intervention
FROM Interventions I
JOIN Auteurs A ON I.id_auteur = A.id_auteur
JOIN Etablissements E ON I.id_etablissement = E.id_etablissement
WHERE A.nom = 'Dupont';
```

---

## 📈 Résultats et statistiques
📊 Génération de **statistiques** sur :
- 🔹 Le **taux de participation** des établissements  
- 🔹 Le **nombre d’élèves présents** par intervention  
- 🔹 Les **ouvrages les plus demandés** par les établissements  

---

## 🚀 Comment exécuter le projet ?
1️⃣ **Importer le script SQL** dans PostgreSQL ou MySQL  
2️⃣ **Lancer les requêtes** pour peupler la base avec les données de test  
3️⃣ **Utiliser les fichiers web**  pour tester l’interface utilisateur(Ps: il manque le fichier JS pour le moment)

---

## 📌 Auteurs du projet
👩‍🎓 VOEDZO Essivi Marie-Josée
👩‍🎓 BOURAIMA Afdal & DE BADAR BADAROU Hosniath & DOTSU Olympe & EGLA Josiane 
  

---



