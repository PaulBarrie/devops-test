# Techincal test for Dreamquark

Ce test technique permettra de passer en revu les éléments que nous recherchons à Dreamquark sur les compétences s'articulant autour des métiers de DevOps/SRE. Il se veut volontairement ouvert afin de capter toutes les propositions de mise en oeuvre.

Il se découpera en 3 parties:
 - Docker/Docker-compose
 - Kubernetes
 - Helm/Mise en production/propositions


### Docker/Docker-compose

Le soft est déjà développé et consiste à une simple app (en NodeJS) permettant d'upload un fichier et le sauvegarder en base (MongoDB).
Quelques points de détail: 
 - Il est conseillé de surchargé les fichiers de configuration dans le dossier `uploader-app/config`.
 - Utilise le Makefile afin de faciliter les commandes

Livrables attendus:
  - [ ] Ecriture du fichier docker-compose.yaml (dans le dossier uploader-app) afin de lancer l'application en local
  - [ ] Configuration correcte de l'application node & initialisation de Mongo
  - [ ] Utilisation d'un seul network
  - [ ] Volume persistant pour la base
  
BONUS:
  - [ ] Résolution DNS depuis le PC hôte, ajout d'un (reverse)proxy ?
  - [ ] Ajout de SSL sur ce proxy
  - [ ] SSL entre les composants 
  - [ ] Toute autre forme de propositions, amélioration de configuration, nouvelle brique, etc !


### Kubernetes

Afin de préparer la mise en production, nous te proposition d'écrire les fichiers `.yaml` afin de déployer cette application dans un cluster kubernetes. Il y a peu d'incidence sur le type de cluster (AWS/Azure/GCP ou minikube). Nous demanderons seulement lors de ton entretien une démo live !

Yaml à fournir:
  - [ ] Deploiement de l'application JS
  - [ ] Deployment/StatefulSet de la base MongoDB
  - [ ] Création d'un volume pour la persistance de la base
  - [ ] Les services correspondant pour l'ouverture du flux vers l'extérieur
  - [ ] Ingress

BONUS:
  - [ ] TLS sur l'Ingress
  - [ ] Init container sur le MongoDB
  - [ ] SSL entre les composants
  - [ ] Toute autre forme de propositions !


### Helm/Mise en production/propositions

Nous voici à l'heure de la mise en production. Quoi de mieux que de créer une chart Helm pour faciliter tout ça ?

  - [ ] Template des composants crées pour la partie précédente
  - [ ] Un `values.yaml` avec quelques valeurs modifiables
  - [ ] Un `README.md` en décrivant légèrement ce qu'il est possible de changer
  - [ ] Package de l'application en archive

### BONUS

Toute proposition/initative/remarque sur chacune des précédentes parties est appréciée, laisse libre court à ton imagination.

Quelques pistes de réflexion et d'amélioration possible:
  - Une CI/CD de ton choix (juste un fichier de configuration suffit !)
  - Si une montée en charge arrive, que ce soit des requêtes lourdes et/ou multiples, comment se prémunir avec Kubernetes ?
  - Une solution de monitoring providentielle ? Quelles seraient les répercussions sur le déploiement (et les fichiers Yaml par exemple ? Sidecars ?)
  - La même chose pour une solution de logging centralisé ?
  - Ce que tu veux !
