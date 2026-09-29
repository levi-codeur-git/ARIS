# Phase 4 — Services réseau

## Objectif
Déployer des services utiles à une infrastructure d'entreprise et vérifier leur fonctionnement depuis le client Linux.

## Services déployés
- **SSH / SFTP** : administration distante et transfert de fichiers.
- **Nginx** : serveur Web.
- **BIND9** : service DNS pour le domaine interne `aris.local`.
- **Samba** : partage de fichiers avec le partage `ARIS-Share` situé dans `/srv/aris/share`.

La zone DNS comprend notamment `files.aris.local` et `sftp.aris.local`.

## Validation
Les services ont été testés depuis `CLIENT-01-VM`, notamment avec une connexion SFTP, l'accès au partage Samba et la résolution DNS.

## Résultat
`SERVER-01` fournit plusieurs services réseau cohérents avec le rôle d'un serveur d'infrastructure ARIS.
