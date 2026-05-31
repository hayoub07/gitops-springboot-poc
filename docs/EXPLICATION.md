# Explication rapide pour développeur

## Kubernetes

Kubernetes exécute ton application dans des Pods.

- Deployment : décrit combien de replicas tu veux.
- Pod : instance réelle qui tourne.
- Service : point d'accès stable vers les Pods.
- Namespace : séparation logique, comme un espace projet.

## Argo CD

Argo CD regarde un repo Git et compare :

- état désiré dans Git
- état réel dans Kubernetes

Si les deux sont différents, l'application devient `OutOfSync`.

Avec auto-sync, Argo CD corrige automatiquement le cluster.

## DevOps push

La pipeline fait directement :

```bash
kubectl apply -f deployment.yaml
```

C'est simple mais la pipeline a accès au cluster.

## GitOps pull

La pipeline ne touche pas Kubernetes.
Elle modifie seulement Git.

Argo CD, qui tourne dans Kubernetes, applique les changements.

## Pourquoi c'est mieux ?

- Git est la source de vérité.
- Rollback avec git revert.
- Historique clair.
- Moins d'accès direct au cluster.
- Argo CD détecte les changements manuels dans Kubernetes.

## Exemple de scénario

1. Tu changes le code Java.
2. La CI build l'image Docker `gitops-demo:1.0.1`.
3. La CI modifie `deployment.yaml` :

```yaml
image: gitops-demo:1.0.1
```

4. La CI commit/push dans le repo GitOps.
5. Argo CD déploie automatiquement.
