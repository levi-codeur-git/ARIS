# Phase 6 — Sécurité

## Objectif
Réduire la surface d'exposition du serveur Linux et appliquer des mesures de durcissement adaptées à l'environnement ARIS.

## Réalisation
La phase comprend l'analyse de la surface de sécurité, le durcissement du serveur, la configuration du pare-feu **UFW**, le renforcement de l'accès **SSH**, la mise en place de **Fail2ban** et l'analyse des journaux et événements de sécurité.

Les règles réseau ont été définies selon les interfaces et les réseaux autorisés, notamment pour SSH, HTTP, DNS, Samba et Netdata.

## Validation
Des contrôles et tests de sécurité ont été réalisés afin de vérifier le comportement des protections mises en place.

## Résultat
`SERVER-01` dispose d'un niveau de sécurisation supérieur à une installation Linux par défaut, avec contrôle des accès réseau et mécanismes de protection contre certaines tentatives abusives.
