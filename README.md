# AWS EKS Infrastructure & GitOps CI/CD Pipeline

Цей проєкт містить Terraform-код для розгортання інфраструктури в AWS (EKS, VPC, ECR, RDS) та налаштування GitOps CI/CD за допомогою Jenkins та ArgoCD.

---

## 🏗️ Архітектура

* **VPC:** 3 публічні та 3 приватні підмережі в Multi-AZ.
* **EKS Cluster & Node Group:** Розгорнуті суворо в **приватних підмережах**.
* **RDS PostgreSQL:** База даних у приватних підмережах.
* **ECR:** Приватний реєстр для Docker-образів.
* **Jenkins:** CI-інструмент для автоматичної збірки образів через Kaniko (IRSA auth).
* **ArgoCD:** GitOps CD-інструмент для деплою додатка з Helm-чарту (`charts/django-app`).

---

## 🔄 Схема CI/CD (GitOps Workflow)

```text
[Developer] ---> (git push) ---> [GitHub: DevOps Repo]
                                       │
                    ┌──────────────────┴──────────────────┐
                    ▼                                     ▼
           [Jenkins Pipeline]                     [ArgoCD Controller]
                    │                                     │
     1. Pull source code                                  │
     2. Build image via Kaniko                            │ (Monitors repo
     3. Push image to Amazon ECR                          │  & syncs state)
     4. Update image tag in values.yaml                   │
                    │                                     │
                    ▼                                     ▼
        [GitHub: charts/django-app] ────────────────► [EKS Cluster]
                                                      (Pods update)

                                                      
## 🚀 Інструкція з розгортання

### 1. Форматування та ініціалізація Terraform
```bash
terraform fmt -recursive
terraform init
```

### 2. Застосування конфігурації
```bash
terraform plan
terraform apply
```

---

## 🔑 Підключення та управління

### 1. Оновлення kubeconfig для EKS
```bash
aws eks update-kubeconfig --region us-west-2 --name lesson-5-eks
```

### 2. Отримання пароля та підключення до Jenkins
```bash
kubectl get svc -n jenkins
kubectl exec -it svc/jenkins -n jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password
```

### 3. Отримання пароля та доступ до ArgoCD UI
```bash
# Пароль для користувача admin:
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Порт-форвардинг веб-інтерфейсу (https://localhost:8080):
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```

---

## 🧹 Видалення ресурсів
```bash
terraform destroy
```