<?php
try {
    // Vérifier quel formulaire a été soumis
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');
        echo("Connexion");
        $name=$_POST['editionName'];
        $year=$_POST['editionYear'];
        $datedebut=$_POST['startDate'];
        $datefin=$_POST['endDate'];

        $sql="CALL creer_edition('$name','$year','$startDate','$endDate')";
        // Exécuter la requête
        if ($dbh->query($sql)) {
            echo "Procédure stockée exécutée avec succès.";
        } else {
            echo "Erreur lors de l'exécution de la procédure stockée : " . $dbh->error;
        }

    }
    
    } catch(PDOException $e) {
            echo "Erreur de connexion à la base de données PostgreSQL : " . $e->getMessage();
        }      
// se deconnecter 
$dbh = null;
?>