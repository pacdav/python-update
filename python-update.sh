#!/bin/bash
echo "Ce script va mettre a jour python3 vers une version plus récente"
echo "Recherche de votre ancienne version de python..."
version_act=$(python3 -V)
echo "L'ancienne version est une derivé de la version ? "${version_act:7:4} "Y/n"
read rep1
if [ "$rep1" == "y" ] || [ "$rep1" == "" ] || [ "$rep1" == "Y" ]; then
    echo "Parfait"
else 
    echo 'Quelle est votre version actuelle?' 
    echo 'Si vous ne savez pas, arrêter le script et lancer la commande "python3 -V"'
    read anc_version
    echo "L'ancienne version est une derivé de la version ? "${anc_version:0:3} "Y/n"
    read answ
    if [ "$answ" == "y" ] || [ "$answ" == "" ] || [ "$answ" == "Y" ]; then 
        anc_version=${anc_version:0:3} 
        echo $anc_version
    else
        echo "Est-ce un derivé de cette version "${anc_version:0:4} "Y/n"
        read rep
        if [ "$rep" == "y" ] || [ "$rep" == "" ] || [ "$rep" == "Y" ]; then
        anc_version=${anc_version:0:4} 
        echo $anc_version 
        else
            echo "relancez le programme!"
        fi
    fi
fi
echo "Quel version voulez vous télécharger"
read version
echo "Voulez-vous télécharger la version" $version "?" "Y/n"
read reponse
if [ "$reponse" == "y" ] || [ "$reponse" == "" ] || [ "$reponse" == "Y" ]; then
    echo "J'installe la version " $version
    #mise à jour et installation des bibliothèques obligatoires
    sudo apt-get update
    sudo apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev tar wget
    #Téléchargement de la version python demandée et décompression de l'archive
    wget https://www.python.org/ftp/python/$version/Python-$version.tgz
    tar zxf Python-$version.tgz
    cd Python-$version
    #compilation et installation du projet
    sudo ./configure --enable-optimizations
    sudo make -j 4
    sudo make altinstall
    cd ../
    #supression des fichiers qui ne seront plus utiles
    rm -r Python-$version
    rm Python-$version.tar.xz
    #cahngement des 
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python$anc_version 0
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python${version:0:4} 1
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 0
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
    sudo ln -s /usr/share/pyshared/lsb_release.py /usr/local/lib/python${version:0:4}/site-packages/lsb_release.py
else
    echo "Recommencez le script"
fi