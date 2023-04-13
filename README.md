# Test_Dumps_BDD

Script – Sauvegarde des bases de données sous Linux

Afin d'assurer une tolérance aux pannes et une sauvegarde des informations importantes, 
une sauvegarde des bases de données Mysql peut être faite avec un script.

Il est en effet intéressant de pouvoir automatiser la sauvegarde des bases de données d'un serveur, 
car elles contiennent souvent des informations importantes et vitales dans une entreprise. 
Ce backup sera effectué par un utilisateur « backup » qui sauvegardera régulièrement et 
automatiquement l'ensemble des bases de données du serveur.

Création de l'utilisateur de backup
Il faut tout d'abord créer un utilisateur qui aura uniquement les droits de lecture sur 
l'ensemble des bases de données. Les opérations seront lancées à partir d'un script, 
il serait donc dangereux de les lancer avec un utilisateur ayant des droits de modification, 
de création ou de suppression sur les bases de données.On se connecte au serveur de base de données :

mysql -u root -p

On crée l'utilisateur 'backup'@'localhost'. Il est important de préciser que backup n'agira uniquement que 
depuis le serveur local (depuis le script qui sera situé sur le serveur).

CREATE USER 'backup'@'localhost' IDENTIFIED BY '';
On donne uniquement les droits de lecture à l'utilisateur 'backup'@'localhost' sur toutes les bases de données :

GRANT SHOW DATABASES, SELECT, LOCK TABLES, RELOAD ON *.* to 'backup'@'localhost' ;
On demande au serveur de relire la table des droits pour s'assurer que les commandes prennent bien effet :

FLUSH PRIVILEGES ;

Le script de sauvegarde
Si on dispose de plusieurs bases de données, il est intéressant de faire un script qui automatisera le listage, la lecture et la sauvegarde de chaque base de données.Il nous faut tout d'abord créer un répertoire temporaire afin de stocker les données :

mkdir /home/user/save_BD
Pour sauvegarder la base de données, nous utiliserons mysqldump. C'est un utilitaire qui permet d'exporter 
une base ou un groupe de bases vers un fichier texte, pour la sauvegarde ou le transfert entre deux serveurs 
(pas nécessairement entre serveurs MySQL).

L'export contiendra les requêtes SQL nécessaires pour créer la table et la remplir.

Puis on crée le script qui automatisera la sauvegarde.

vim backup_script.sh (confère script du repository)

Explication des paramètres:

LISTEBDD : Cette variable contiendra l'ensemble des noms des bases de données de notre serveur MySQL :
echo 'show databases" : on chercher ici à lister les bases de données de notre serveur MySQL
| mysql -u backup --password=< mot de passe >) : on indique ici les identifiants de la connexion MySQL. -u est pour l'utilisateur.
mysqldump : on lance l’outil mysqldump qui sert au backup des bases de données
-u backup : C'est l'utilisateur qui agira dans mysqldump, il doit avoir au minimum les droits de lectures sur 
les bases de données --single-transaction : 

Cette option ajoute la commande SQL BEGIN avant d'exporter les données vers le serveur. 

C'est généralement pratique pour les tables InnoDB et le niveau d'isolation de transaction READ_COMMITTED, 
car ce mode va exporter l'état de la base au moment de la commande BEGIN sans bloquer les autres applications. 

Il faut pour utiliser cette option que l'utilisateur ait les droit "LOCK TABLES"--password : 
C'est le mot de passe de l'utilisateur en question
$BDD : nom de la base de données, ce nom est une variable qui change en fonction de la lecture

$LISTEDBB> "$CHEMIN/$BDD"_"$DATE.sql": 
on stocke ensuite la base de données dans un fichier portant son nom avec l'extension ".sql"

Il faut donner la possibilité à ce script d'être exécuté :

chmod +x backup_script.sh

L'automatisation de la tâche
Nous pouvons utiliser le service cron pour le lancement automatique du script de sauvegarde à un intervalle 
régulier. Par exemple, si nous souhaitons que le script s'exécute toutes les jours à 10 heures du matin. 

Nous utiliserons la commande "contrab -e" pour modifier le fichier contrab. Puis nous y ajouterons cette ligne:

00 10 * * * root sh
Le script exécutera tous les jours à 10 heures du matin.