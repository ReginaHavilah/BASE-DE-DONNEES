<?php
try {
    // Vérifier quel formulaire a été soumis
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        //si c est le formulaire d inscription alors 
        $dbh = new PDO('pgsql:host=localhost;port=5432;dbname=Festival_littéraire;user=postgres;password=root');
        echo("Connexion");
        if (isset($_POST['submit'])) {
            // Récupérer les données du formulaire
            $nom = $_POST['signupLastName'];
            $prenom = $_POST['signupFirstName'];
            $email = $_POST['signupEmail'];
            $telephone = $_POST['signupPhone'];
            $adresse = $_POST['signupAddress'];
            $role = $_POST['signupRole'];
            $username=$_POST['signupUsername'];
            $password=$_POST ['signupPassword'];
            switch ($role) {
                case "Auteur":
                    echo("hello");
                   $biographie=$_POST['authorBio']; 
                        //creer le compte et ajouter l auteur dans la base
                    $sql = "CALL inserer_auteur('$nom', '$prenom', '$email', '$telephone','$biographie', '$adresse', '$username','$password')";
                    
                        // Vérifiez si les langues parlées ont été cochées
                    if (isset($_POST['spokenLanguages'])) {
                            $spokenLanguages = $_POST['spokenLanguages'];
                            // Vous pouvez maintenant traiter chaque langue parlée
                            foreach ($spokenLanguages as $language) {
                                echo "Langue parlée: " . $language . "<br>";
                            }
                    } else 
                    {
                            echo "Aucune langue parlée sélectionnée.<br>";
                    }
                    
                        // Vérifiez si les langues écrites ont été cochées
                    if (isset($_POST['writtenLanguages'])) {
                            $writtenLanguages = $_POST['writtenLanguages'];
                            // Vous pouvez maintenant traiter chaque langue écrite
                            foreach ($writtenLanguages as $language) {
                                echo "Langue écrite: " . $language . "<br>";
                            }
                    } else {
                            echo "Aucune langue écrite sélectionnée.<br>";
                        }
                    
                    break;

                case "Interprète":
                    // creer le compte et inserer l interprete dans la base
                    $spokenLanguages = $_POST['spokenLanguage'];
                    $interpretedLanguages = $_POST['interpretedLanguage'];
                    $sql = "CALL inserer_interprete('$nom', '$prenom', '$email','$telephone', '$adresse', '$username','$password')";
                   
                    // Insertion des langues parle 
                    foreach ($spokenLanguages as $language) {
                        $sql = "CALL ajouter_langue_parlee('$nom','$prenom','$language')"; 
                        if ($dbh->query($sql) !== TRUE) {
                            echo "Erreur lors de l'insertion de la langue parlée : " . $dbh->error;
                        }
                    }
                    // Insertion des langues interprete 
                    foreach ($interpretedLanguages as $language) {
                        $sql = "CALL ajouter_langue_interpretee('$nom','$prenom','$language')";
                        if ($dbh->query($sql) !== TRUE) {
                            echo "Erreur lors de l'insertion de la langue interprétée : " . $dbh->error;
                        }
                    }
                    break;
                case "Accompagnateur":
                    // Appeler la procédure stockée pour les accompagnateurs
                    $sql = "CALL inserer_accompagnateur('$nom', '$prenom', '$email', '$telephone','$adresse', '$username','$password')";
                    break;
                case "Etablissement":
                    //recuperation d info supplementaire
                    echo("debut"); 
                    $code=$_POST['codePostal'];
                    $nomEta=$_POST['nomEtablissement'];
                    $typpe=$_POST['typeEtablissement'];
                    echo($typpe);
                    // creer le compte 
                    $sql = "CALL inserer_etablissement('$nomEta','$adresse','$code','$email','$typpe', '$telephone', '$username','$password')";
                    break;
                default:
                    // Gérer le cas ou le role n'est pas reconnu
                    echo "Role non reconnu.";
                    break;
            }
            // Exécuter la requête
            if ($dbh->query($sql)) {
                echo "Procédure stockée exécutée avec succès.";
            } else {
                echo "Erreur lors de l'exécution de la procédure stockée : " . $dbh->error;
            }
        } 
    }
} catch(PDOException $e) {
    echo "Erreur de connexion à la base de données PostgreSQL : " . $e->getMessage();
}

// se deconnecter 
$dbh = null;
?>
