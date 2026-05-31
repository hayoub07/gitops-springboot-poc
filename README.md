# Spring Boot GitOps POC

POC simple pour comprendre la différence entre :

1. Déploiement DevOps classique `push` avec `kubectl apply`
2. Déploiement GitOps `pull` avec Argo CD

## Pré-requis

Installe :

- Java 21
- Maven
- Docker
- kubectl
- minikube
- argocd CLI optionnel

Vérifie :

```bash
java -version
mvn -version
docker version
kubectl version --client
minikube version
```

## 1. Lancer Kubernetes local

```bash
minikube start
kubectl get nodes
```

## 2. Build Spring Boot + image Docker locale

```bash
./scripts/01-build-local.sh
```

Important : l'image est construite dans le Docker daemon de Minikube avec :

```bash
eval $(minikube docker-env)
```

Donc Kubernetes local peut trouver l'image `gitops-demo:local`.

## 3. Approche DevOps classique push

Ici, le développeur ou la CI pousse directement vers Kubernetes :

```bash
./scripts/02-devops-push-deploy.sh
```

Tester :

```bash
./scripts/05-test-app.sh
```

Puis dans un autre terminal :

```bash
curl http://localhost:8081/hello
curl http://localhost:8081/
```

Tu dois voir :

```text
Hello GitOps from Spring Boot v1
```

## 4. Approche GitOps avec Argo CD

### 4.1 Installer Argo CD

```bash
./scripts/03-install-argocd.sh
```

UI Argo CD :

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Ouvre :

```text
https://localhost:8080
```

Login :

```text
admin
```

Password :

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo
```

### 4.2 Créer un vrai repo Git

Pour que GitOps marche vraiment, Argo CD doit lire un repo Git.

Crée un repo GitHub/GitLab, push ce dossier, puis modifie :

```yaml
repoURL: https://github.com/CHANGE_ME/gitops-springboot-poc.git
```

Dans :

```text
argocd-application-local.yaml
```

Ensuite :

```bash
./scripts/04-create-argocd-app.sh
```

Argo CD va lire :

```text
gitops/dev/
```

Et appliquer les manifests sur Kubernetes.

## 5. Voir la différence concrètement

### DevOps push

Tu fais :

```bash
kubectl apply -n demo -f k8s/dev/
```

Donc la CI ou le développeur a accès direct au cluster.

### GitOps pull

Tu modifies Git :

```text
gitops/dev/deployment.yaml
```

Puis :

```bash
git add .
git commit -m "chore: update gitops manifests"
git push
```

Argo CD détecte le changement et synchronise Kubernetes.

## 6. Commandes kubectl utiles

```bash
kubectl get pods -n demo
kubectl get svc -n demo
kubectl get deployment -n demo
kubectl describe pod <pod-name> -n demo
kubectl logs <pod-name> -n demo
kubectl rollout status deployment/gitops-demo -n demo
kubectl rollout restart deployment/gitops-demo -n demo
kubectl delete pod <pod-name> -n demo
```

## 7. Commandes Argo CD utiles

```bash
argocd app list
argocd app get gitops-demo
argocd app sync gitops-demo
argocd app diff gitops-demo
argocd app history gitops-demo
argocd app rollback gitops-demo <revision>
```

## 8. Est-ce qu'il faut OpenShift ?

Non pour ce POC.

Minikube suffit.

OpenShift est une distribution Kubernetes enterprise. Tu l'utilises si ton entreprise l'utilise déjà.

## 9. Est-ce qu'il faut Ansible ?

Non.

Ansible sert surtout à configurer des machines ou automatiser de l'installation.

## 10. Est-ce qu'il faut Terraform ?

Non pour tester localement.

Terraform sert plutôt à créer l'infrastructure : cluster, réseau, VM, database, etc.

## 11. Docker Hub vs Bitnami

Docker Hub est une registry pour stocker/télécharger des images Docker.

Bitnami fournit des images et charts prêts à l'emploi pour PostgreSQL, Redis, Kafka, etc.

Pour ce POC, tu n'as pas besoin de Bitnami.

## 12. Nettoyage

```bash
kubectl delete namespace demo
kubectl delete namespace argocd
minikube stop
```
