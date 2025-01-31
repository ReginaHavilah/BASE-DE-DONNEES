<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<?php
// Vérifier si le formulaire a été soumis
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Vérifier si les champs requis sont définis et non vides
    if (isset($_POST["signupLastname"]) && isset($_POST["signupFirstName"]) && isset($_POST["signupUsername"]) && isset($_POST["signupEmail"]) && isset($_POST["signupPassword"]) && isset($_POST["signupPhone"]) && isset($_POST["signupAddress"]) && isset($_POST["signupRole"])) {
        
        // Récupérer les données du formulaire
        $lastname = $_POST["signupLastname"];
        $firstname = $_POST["signupFirstName"];
        $username = $_POST["signupUsername"];
        $email = $_POST["signupEmail"];
        $password = $_POST["signupPassword"];
        $phone = $_POST["signupPhone"];
        $address = $_POST["signupAddress"];
        $role = $_POST["signupRole"];

        try {
            // Connexion à la base de données PostgreSQL
            $dbh = pg_connect("host=localhost port=5432 dbname=Festival_littéraire user=postgres password=root");
            echo("connected");
            // Préparer la requête SQL pour l'insertion des données dans la table "compte"
            $sql = "INSERT INTO compte (nomutilisateur, motpasse) VALUES ('$username', '$password')";

            // Exécuter la requête SQL
            $result = pg_query($dbh, $sql);

            if ($result) {
                echo "Nouveau compte créé avec succès!";
            } else {
                echo "Erreur lors de la création du compte: " . pg_last_error($dbh);
            }

            // Fermer la connexion à la base de données
            pg_close($dbh);
        } catch (Exception $e) {
            echo "Erreur de connexion à la base de données: " . $e->getMessage();
        }
    } else {
        echo "Tous les champs requis doivent être remplis.";
    }
}
?>

</body>
</html>
