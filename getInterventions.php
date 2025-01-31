<?php
function getInterventions($username) {
    try {
        // Connexion à la base de données PostgreSQL
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');

        // Préparer la requête SQL pour récupérer les interventions par nom d'utilisateur de l'auteur
        $sql = "select dateintervention,lieu,heure_debut,heure_fin,etat  from intervention ,auteur ,intervention_auteur where
        auteur.id_auteur = intervention_auteur.id_auteur
        and intervention.id_intervention = intervention_auteur.id_intervention
        and Auteur.nomutilisateur =:username";
        $stmt = $dbh->prepare($sql);
        
        // Exécuter la requête avec le nom d'utilisateur fourni
        $stmt->execute(array(':username' => $username));

        // Récupérer toutes les lignes de résultats sous forme de tableau associatif
        $interventions = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Retourner les interventions trouvées
        return $interventions;
        
        // Fermer la connexion à la base de données
        $dbh = null;

    } catch(PDOException $e) {
        // Gérer les erreurs de connexion à la base de données
        echo "Erreur de connexion à la base de données PostgreSQL : " . $e->getMessage();
        return array(); // Retourner un tableau vide en cas d'erreur
    }
}

header('Content-Type: application/json');
$interventions = getInterventions($_GET["nomutilisateur"]);
// Afficher les interventions
echo json_encode($interventions);
?>
