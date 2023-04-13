#!/bin/bash
# On liste nos bases de données
LISTEBDD=$( echo 'show databases' | mysql -u backup --password=< superMotDePasse >)
for BDD in $LISTEBDD do
# Exclusion des BDD information_schema , mysql et Database
if [[ $BDD != "information_schema" ]] && [[ $BDD != "mysql" ]] && [[ $BDD != "Database" ]]; then
# Emplacement du dossier ou nous allons stocker les bases de données, un dossier par base de données
  CHEMIN=/home/user/save_BD/$BDD
# On backup notre base de donnees
  mysqldump -u backup --single-transaction --password= $BDD > "$CHEMIN/OKOMAY.sql"
  echo "|Sauvegarde de la base de donnees OKOMAY.sql ";
fi
done
