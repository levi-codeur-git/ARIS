# ARIS — Administration Réseaux, Informatique et Sécurité

ARIS est un projet personnel de mise en pratique des compétences en administration réseau, systèmes Linux, services réseau, supervision, automatisation et sécurité informatique.

Le projet reproduit progressivement l'environnement informatique d'une organisation répartie sur plusieurs bâtiments, depuis la conception du réseau jusqu'à l'administration et au durcissement d'un serveur Linux.

## Objectifs

Le projet a pour objectifs de :

* concevoir et segmenter un réseau d'entreprise ;
* mettre en œuvre des VLAN et du routage inter-VLAN ;
* déployer et administrer un serveur Linux ;
* mettre en place des services réseau ;
* automatiser les tâches d'administration ;
* superviser l'état du système ;
* appliquer des mesures de sécurité et de durcissement ;
* documenter les configurations et les procédures ;
* construire un portfolio technique reproductible.

---

## Architecture réseau

Le réseau est conçu autour de deux bâtiments et de plusieurs services répartis par VLAN.

### VLAN

| VLAN | Nom           | Utilisation                       |
| ---: | ------------- | --------------------------------- |
|   10 | DIRECTION     | Services de direction             |
|   20 | FINANCE       | Services financiers               |
|   30 | RH-COMMERCIAL | Ressources humaines et commercial |
|   40 | INFO-SUPPORT  | Informatique et support           |
|   50 | MANAGEMENT    | Administration et gestion         |
|   60 | PRODUCTION    | Environnement de production       |
|   99 | SERVEURS      | Infrastructure serveur            |

### Routage

Le routage inter-VLAN est réalisé avec un routeur Cisco 2911/K9 en **Router-on-a-Stick**.

Les passerelles principales sont :

```text
VLAN 10 → 192.168.10.1
VLAN 20 → 192.168.20.1
VLAN 30 → 192.168.30.1
VLAN 40 → 192.168.40.1
VLAN 50 → 192.168.50.1
VLAN 60 → 192.168.60.1
VLAN 99 → 192.168.99.1
```

Le DHCP est centralisé sur l'infrastructure serveur avec relais DHCP (`ip helper-address`) configuré sur les interfaces VLAN du routeur.

La première validation réseau a été réalisée avec Cisco Packet Tracer.

---

## Infrastructure Linux

L'environnement serveur est virtualisé avec **VMware Workstation Pro**.

### Serveur

```text
Hostname : server-01
OS       : Ubuntu Server
RAM      : 2 Go
Réseau   : 192.168.63.128/24
```

Le serveur possède également une interface dédiée au réseau interne ARIS :

```text
ens37 → 192.168.99.20/24
```

### Client

Un poste client Ubuntu est également utilisé pour tester les services et les accès réseau.

---

## Services déployés

Plusieurs services ont été installés et configurés sur le serveur Linux.

### SSH

Administration distante du serveur avec plusieurs mesures de sécurisation :

* connexion root interdite ;
* authentification par clé publique ;
* authentification par mot de passe désactivée ;
* nombre de tentatives limité ;
* nombre de sessions limité.

### Nginx

Serveur web utilisé pour héberger les ressources web du projet.

Le protocole TLS a été durci afin de conserver uniquement :

```text
TLS 1.2
TLS 1.3
```

### BIND9

Serveur DNS local utilisé pour le domaine :

```text
aris.local
```

La configuration et la zone DNS ont été vérifiées avec les outils de validation BIND.

### Samba

Un partage réseau a été mis en place :

```text
ARIS-Share
```

Le partage utilise le groupe :

```text
aris-admin
```

Les permissions Linux et Samba sont configurées afin de contrôler l'accès aux ressources.

### Fail2ban

Fail2ban protège notamment le service SSH contre les tentatives répétées d'authentification.

Configuration principale :

```text
maxretry = 3
findtime = 10 minutes
bantime  = 15 minutes
```

### Netdata

Netdata est utilisé pour la supervision en temps réel des ressources et services du serveur.

L'interface de supervision est accessible sur le réseau interne ARIS.

---

## Sécurité

La sécurité constitue une partie importante du projet.

### Pare-feu

UFW est configuré avec :

```text
Default incoming : DENY
Default outgoing : ALLOW
```

Les ports nécessaires sont autorisés uniquement depuis les réseaux concernés.

### Services protégés

Les services suivants ont été contrôlés et sécurisés :

* SSH
* Nginx
* BIND9
* Samba
* Fail2ban
* Netdata

### Contrôles réalisés

Les validations comprennent notamment :

* vérification des services actifs ;
* vérification des ports ouverts ;
* contrôle de la configuration SSH ;
* contrôle du pare-feu ;
* validation de la configuration DNS ;
* contrôle des permissions Samba ;
* vérification de la protection Fail2ban ;
* durcissement des protocoles TLS de Nginx.

> Remarque : certains paramètres globaux Samba liés aux fonctionnalités invitées restent à revoir si ces fonctionnalités ne sont pas nécessaires dans l'environnement final.

---

## Automatisation

Plusieurs scripts Python et Bash ont été développés afin d'automatiser les tâches d'administration.

### Audit système

```text
linux/scripts/aris_audit.py
```

Le script contrôle notamment :

* le nom de la machine ;
* l'uptime ;
* la mémoire disponible ;
* l'utilisation du disque ;
* l'état des services ARIS.

Un rapport est généré automatiquement dans le répertoire des rapports.

### Health check

```text
linux/scripts/health_check.sh
```

Le script vérifie :

* l'espace disque ;
* la mémoire disponible ;
* les services ;
* les interfaces réseau.

Il retourne un code permettant d'identifier les états :

```text
0 → OK
1 → WARNING
2 → CRITICAL
```

### Sauvegarde

```text
linux/scripts/backup.sh
```

Le script réalise une sauvegarde des scripts et rapports ARIS et conserve les **5 dernières sauvegardes**.

### Nettoyage des rapports

```text
linux/scripts/cleanup_reports.sh
```

Le script permet de conserver les 20 derniers rapports de chaque type :

```text
audit
health
```

### Systemd

Les automatisations principales sont intégrées à systemd :

```text
aris-audit.service
aris-audit.timer

aris-backup.service
aris-backup.timer

aris-health.service
aris-health.timer
```

Les timers permettent l'exécution périodique des contrôles et sauvegardes.

---

## Structure du dépôt

```text
ARIS/
├── .gitignore
├── README.md
│
├── Phase-1-Cahier-des-Charges/
│   ├── README.md
│   └── screenshots/
├── Phase-2-Packet-Tracer/
│   ├── README.md
│   ├── screenshots/
│   └── fichiers-packet-tracer/
├── Phase-3-Linux/
│   ├── README.md
│   └── screenshots/
├── Phase-4-Services/
│   ├── README.md
│   └── screenshots/
├── Phase-5-Supervision/
│   ├── README.md
│   └── screenshots/
├── Phase-6-Securite/
│   ├── README.md
│   ├── screenshots/
│   └── configurations/
├── Phase-7-Automatisation/
│   ├── README.md
│   ├── screenshots/
│   ├── scripts/
│   └── configurations/
├── Phase-8-Git-GitHub/
│   ├── README.md
│   └── screenshots/
└── Phase-9-Presentation/
    ├── README.md
    └── screenshots/

## Technologies

### Réseau

* Cisco Packet Tracer
* Cisco IOS
* VLAN
* 802.1Q
* Router-on-a-Stick
* DHCP
* Routage inter-VLAN

### Systèmes

* Ubuntu Server
* Ubuntu Desktop
* VMware Workstation Pro
* Linux
* systemd

### Services

* OpenSSH
* Nginx
* BIND9
* Samba
* Fail2ban
* Netdata

### Automatisation

* Python
* Bash
* systemd timers

### Sécurité

* UFW
* Fail2ban
* SSH hardening
* TLS

### Versionnement

* Git
* GitHub

---

### Limitation d’intégration 

L’infrastructure réseau a été conçue et validée dans Cisco Packet Tracer, tandis que l’infrastructure serveur Linux a été déployée et testée dans VMware Workstation Pro. Les deux environnements sont opérationnels, mais n’ont pas pu être interconnectés directement en raison des limitations de Packet Tracer en tant que simulateur. Une intégration directe aurait nécessité l’utilisation d’un environnement d’émulation réseau tel que GNS3/EVE-NG et la reproduction d’une partie de l’infrastructure réseau.

---

## État du projet

| Phase | Domaine                             | État        |
| ----: | ----------------------------------- | ----------- |
|     1 | Cahier des charges                  | ✅ Terminée  |
|     2 | Réseau Cisco / Packet Tracer        | ✅ Terminée  |
|     3 | Administration Linux / VMware       | ✅ Terminée  |
|     4 | Services réseau                     | ✅ Terminée  |
|     5 | Supervision & automatisation        | ✅ Terminée  |
|     6 | Sécurité & durcissement             | ✅ Terminée  |
|     7 | Versionnement Git / GitHub          | 🔄 En cours  |
|     8 | Documentation & présentation finale | ⏳ À venir   |

---

## Auteur

**Mame Cheikh Ibrahima Fall NDOYE**
Eleve à l'Ecole Supérieure Polytechnique (ESP) de Dakar au département Génie Informatique, filière Réseaux & Télécommmunictions

Projet personnel réalisé dans le cadre du développement de compétences en :

* administration réseaux ;
* systèmes Linux ;
* services réseau ;
* automatisation ;
* cybersécurité.

---

## Licence

Projet personnel destiné à l'apprentissage, à la documentation et à la constitution d'un portfolio technique.


