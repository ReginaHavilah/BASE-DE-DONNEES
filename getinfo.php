<?php
function getInfo($target) {
    try {
        // Connection à la base de données PostgreSQL
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');
    
        $query = "SELECT * FROM ".$target;
        $statement = $dbh->query($query);
    
        
        $data = $statement->fetchAll(PDO::FETCH_ASSOC);
    
       
        header('Content-Type: application/json');
        echo (json_encode($data));
    
        // Fermeture de la connexion à la base de données
        $dbh = null;
    } catch (PDOException $e) {
        echo "Erreur de connexion à la base de données: " . $e->getMessage();
    }
}
getInfo($_GET["target"]);
?>
