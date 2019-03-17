#!/bin/bash

#Suppression toutes les anciennes commandes.
clear

#Démarrage de la boucle pour répéter ce script.
while true; do
        echo " "
        echo "                         FTP Manager v0.1 by Its_Power"
        echo " "
        echo "Menu Principal >"
        echo "    1 - Installer toutes les dépendances et services."
        echo "    2 - Status du service FTP."
        echo "    3 - Redémarrer le service FTP."
        echo "    4 - Configurer Pure-FTPD (pré-fait)."
        echo "    5 - Créer un accès FTP."
        echo "    6 - Informations sur un utilisateur FTP."
        echo "    7 - Informations sur les utilisateur FTP connectés."
        echo "    8 - Changer le mot de passe d'un utilisateur FTP."
        echo "    9 - Supprimer un utilisateur FTP."
        echo "   10 - Lister les utilisateur FTP."
        echo "    0 - Quitter"
        echo " "
        read -p 'Commande >> ' input

        case "$input" in
                "0")
                        clear
                        exit 1
                ;;

                "1")
                        clear
                        echo ">> Installation des dépendances et services:"
                        sudo apt-get install pure-ftpd openssl
        ;;

                "2")
                        clear
                        echo ">> Status du service Pure-FTPD:"
                        sudo /etc/init.d/pure-ftpd status | grep -e 'Active'
        ;;

                "3")
                        clear
                        echo ">> Redémarrage du service Pure-FTPD:"
                        sudo /etc/init.d/pure-ftpd restart
        ;;

                "4")
                        clear
                        echo ">> Configuration du service Pure-FTPD:"
                        sudo echo yes > /etc/pure-ftpd/conf/CreateHomeDir
                        echo ">> CreateHomeDir: yes"
                        sudo echo no > /etc/pure-ftpd/conf/PAMAuthentication
                        echo ">> PAMAuthentication: no"
                        sudo echo no > /etc/pure-ftpd/conf/UnixAuthentication
                        echo ">> UnixAuthentication: no"
                        echo ">> Génération d'une clé SSL sécurisée"
                        sudo openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
                        sudo echo 2 > /etc/pure-ftpd/conf/TLS
                        echo ">> TLS: 2"
                        sudo /etc/init.d/pure-ftpd restart
                        echo ">> Activation d'un lien symbolique pour l'authentification"
                        sudo ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/50pure
                        echo ">> Création du groupe: groupftp et d'un utilisateur userftp"
                        sudo groupadd groupftp && sudo useradd -g groupftp -d /dev/null -s /bin/false userftp
                        grep ftp /etc/passwd /etc/group
        ;;

                "5")
                        clear
                        echo ">> Création d'un compte FTP chroot:"
                        read -p "Nom d''utilisateur: " username
                        read -p 'Répertoire de base: (/home/ftp) ' base
                        sudo mkdir -p "$base"
                        sudo chown root:groupftp "$base"
                        read -p 'Nom du dossier chroot: ' chrootfolder
                        sudo pure-pw useradd $username -u userftp -g groupftp -d $base/$chrootfolder -m
        ;;


                "6")
                        clear
                        echo ">> Informations sur un userftp:"
                        read -p 'Nom d utilisateur: ' username
                        sudo pure-pw show "$username"
        ;;

                "7")
                        clear
                        echo ">> Informations sur les userftp connectés:"
                        sudo pure-ftpwho
        ;;

                "8")
                        clear
                        echo ">> Changer le mot de passe d'un userftp:"
                        read -p 'Nom d utilisateur: ' username
                        sudo pure-pw passwd $username -m
        ;;

                "9")
                        clear
                        echo ">> Supprimer un userftp:"
                        read -p 'Nom d utilisateur: ' username
                        sudo pure-pw userdel $username -m
        ;;

                "10")
                        clear
                        echo ">> Lister les userftp:"
                        sudo pure-pw list
        ;;

                *)
                        clear
                        echo ">> Veuillez recommencer votre commande."
        ;;
        esac
done
