# R_backup

Script Shell avec fichiers de configurations indépendants pour :
* Backup complet mensuel
* Backup incrémental journalier
* Sauvegarde sql 

## Comment ça fonctionne ? 
```
    debut du mois [n] = 5 (choisir le jour ou vous commencez la sauvegarde)
    -> creation du dossier du mois
    -> Backup complet le jour [5] du mois 
    -> backup incremental jours [6] du mois à [4] du mois+1
    -> on recommence
```

Copiez le fichier de configuration **default.conf.sample** documenté pour créer votre propre configuration de sauvegarde locale ou distante. Le script est exécuté de cette manière : 
```
r_backup "/chemin/fichier/mon_fichier.conf"
```
Ajoutez ce script dans la table  **cron** pour automatiser vos sauvegardes.

### Prérequis

Pour pouvoir utiliser le script shell pour la réalisation des backups, vous devez disposer des paquets suivants sur votre machine :

* [rsync](https://rsync.samba.org/) - outils de synchronisation et de sauvegarde
* [xz](https://tukaani.org/xz/format.html) - outils de compression par flux de données (7z)
* [mysqldump](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html) - outils de sauvegarde de base de données


### Installation

Clonez ou téléchargez le dépot pour récupérer les fichiers suivants : 
* r_backup.sh
* default.conf.sample 

Le script **r_backup.sh** doit avoir les droits d'exécution pour pouvoir être lancé avec l'utilisateur courant.
```
chmod +x r_backup.sh
```

## Auteur

* **Adam Grassart** - [adam-grassart.fr](https://adam-grassart.fr)

## Licence
Le projet est sous licence MIT - voir le [LICENSE.md](LICENSE.md) pour les détails.

