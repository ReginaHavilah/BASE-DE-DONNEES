<?php
try {
    // Vérifier quel formulaire a été soumis
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
            // Connexion à la base de données PostgreSQL
            $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');
            // Récupération des données du formulaire
            $username = $_POST['registrationUsername'];
            $password = $_POST['password'];
            
            // Exécution de la procédure stockée
            $sql = "CALL connexion_utilisateur('$username','$password')";  
            $result = $dbh->query($sql);
            //header('Content-Type: application/json');

            // Vérification du succès de l'exécution
            if ($result) {
                //echo "Vous êtes connecté";
                echo $username;

            } else {
                echo "Erreur lors de l'exécution de la procédure stockée : " . $dbh->error;
            }
            
            // Fermeture de la connexion
            $dbh = null;
        
    }
} catch(PDOException $e) {
    echo "Erreur de connexion à la base de données PostgreSQL : " . $e->getMessage();
}
?>
