# Phase 5 — Supervision

## Objectif
Mettre en place une supervision permettant de suivre l'état et les ressources du serveur ARIS.

## Réalisation
**Netdata** a été installé sur `SERVER-01`. Son interface est accessible sur le réseau laboratoire via `192.168.99.20:19999`.

La supervision couvre notamment le CPU, la mémoire, le swap, le stockage, l'utilisation disque, le trafic réseau, les interfaces `ens33` et `ens37`, ainsi que l'état des services.

Les journaux système, SSH, Nginx, Samba et BIND9 ont également été examinés.

## Validation
Le service Netdata est actif et accessible depuis `CLIENT-01-VM`. Une vérification de l'état des alarmes a également été effectuée.

## Résultat
ARIS dispose d'une première couche de supervision permettant d'observer l'état du serveur et de ses services.
