<?php
function getVoeux($id_etablissement) {
    try {
        // Connection à la base de données PostgreSQL
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');
    
     
        $query = "select id_voeux,ordre_preference,etatvoeux,id_langue from voeux,etablissement 
        where etablissement.id_etablissement = voeux.id_etablissement
        and etablissement.id_etablissement = ".$id_etablissement;
        $statement = $dbh->query($query);
    
       
        $data = $statement->fetchAll(PDO::FETCH_ASSOC);
    

        header('Content-Type: application/json');
        echo (json_encode($data));
    
  
        $dbh = null;
    } catch (PDOException $e) {
        echo "Erreur de connexion à la base de données: " . $e->getMessage();
    }
}
getVoeux($_GET["id_etablissement"]);
?>
