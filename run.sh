#!/bin/bash

#
# Script to start your Portainer
#
# Uses the admin password specified in the .env file

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else
    echo "Please set up your .env file before starting your enviornment."
    exit 1
fi

#
# recupère le dossier courant
CURRENT_DOSSIER=$(pwd)

#
# 2 verifie le dossier du projet

 if [ $DATA_PATH!=$CURRENT_DOSSIER ]; then
     if [ -z $DATA_PATH ]; then
        DATA_PATH=$CURRENT_DOSSIER
     fi
     echo
     echo "#-----------------------------------------------------------"
     echo "#"
     echo "# ATTENTION!"
     echo "#"
     echo "# Le dossier qui va être utiliser pour le stockage sera :"
     echo "#"
     echo "#  $DATA_PATH"
     echo "#"
     echo "#-----------------------------------------------------------"
     echo "# dossier courant :"
     echo "#  $CURRENT_DOSSIER"
     echo "#-----------------------------------------------------------"
     echo
    PS3='Voulez vous continuez?'   # le prompt
    LISTE=("[Y]es" "[N]o / [A]nnuler" "[F]orcer dossier courant")  # liste de choix disponibles
    select CHOIX in "${LISTE[@]}" ; do
        case $REPLY in
            1|y|Y|o|O)
              break
            ;;
            2|n|N|A|a)
                echo "#-----------------------------------------------------------#"
                echo "#                         /!\                               #"
                echo "#   Operation Arreté aucune modification n'a été faite      #"
                echo "#                                                           #"
                echo "#-----------------------------------------------------------#"
              exit 1
            ;;
            3|F|f)
              DATA_PATH=$CURRENT_DOSSIER
              break
            ;;
        esac
    done
 fi

#
# 2.1 sauvegarde dans .env

echo "-----------------------------------------------------------"
echo "Dossier utiliser sera $DATA_PATH"
echo "il va être validé dans le .env"
echo "-----------------------------------------------------------"

DATA_PATH=$(echo $DATA_PATH | sed 's#\([]\!\(\)\#\%\@\*\$\/&\-\=[]\)#\\\1#g')
sed -i -e "s/^DATA_PATH\=[a-zA-Z0-9\/\-\ ]*/DATA_PATH\=$DATA_PATH/g" ./.env



#   2.2 rapel du fichier .env
source .env


# 3. Start container
docker-compose -f docker-compose.yml up -d



# Final message
echo
echo "#-----------------------------------------------------------"
echo "#"
echo "# The WebProxy take a few moments to get the SSL Certificates"
echo "#"
echo "# Please check your browser to see if it is running, use your"
echo "# domain(s): "
echo "# $DOMAINS"
echo "#"
echo "#-----------------------------------------------------------"
echo


exit 0
