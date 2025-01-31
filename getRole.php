<?php
function getRole($username) {
    try {
        // Connexion à la base de données PostgreSQL
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');

        // Initialiser un tableau pour stocker les rôles trouvés
        $roles = array();

        // Vérifier la présence de l'utilisateur dans chaque table
        $tables = array('accompagnateur', 'interprete', 'auteur', 'etablissement', 'commission');
        foreach ($tables as $table) {
            $sql = "SELECT COUNT(*) FROM $table WHERE nomutilisateur = :username";
            $stmt = $dbh->prepare($sql);
            $stmt->execute(array(':username' => $username));
            $result = $stmt->fetchColumn();

            // Si l'utilisateur est trouvé dans cette table, ajouter le nom de la table au tableau des rôles
            if ($result > 0) {
                $roles[] = $table;
            }
        }

        // Définir le type de contenu de la réponse comme JSON
        header('Content-Type: application/json');

        // Retourner les rôles trouvés au format JSON
        echo json_encode($roles);
        
        // Fermer la connexion à la base de données
        $dbh = null;

    } catch(PDOException $e) {
        // Gérer les erreurs de connexion à la base de données
        echo "Erreur de connexion à la base de données PostgreSQL : " . $e->getMessage();
    }
}

// Appel de la fonction avec les paramètres provenant de $_GET
getRole($_GET["username"]);
?>
