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


# Terraform Module: RDS & Aurora Database

Цей Terraform-модуль призначений для гнучкого розгортання та керування базами даних в AWS. Модуль підтримує створення як стандартних інстансів **AWS RDS**, так і високодоступних кластерів **AWS Aurora**.

---

## 🚀 Приклад використання (Usage)

### 1. Звичайний інстанс Standalone RDS (PostgreSQL / MySQL)

hcl
module "rds" {
  source = "./modules/rds"

  name       = "myapp-db"
  use_aurora = false

  # Налаштування RDS Engine
  engine                     = "postgres"
  engine_version             = "17"
  parameter_group_family_rds = "postgres17"

  # Конфігурація інстансу
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = true

  # Облікові дані та мережа
  db_name             = "myapp"
  username            = var.db_username
  password            = var.db_password
  vpc_id              = module.vpc.vpc_id
  subnet_private_ids  = module.vpc.private_subnets
  subnet_public_ids   = module.vpc.public_subnets
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
  publicly_accessible = false

  # Резервне копіювання та параметри
  backup_retention_period = 1
  parameters = {
    max_connections            = "200"
    log_min_duration_statement = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

### 2. Кластер AWS Aurora (Aurora PostgreSQL / Aurora MySQL)

Для активації кластера Aurora достатньо змінити прапорець `use_aurora = true`:

hcl
module "aurora" {
  source = "./modules/rds"

  name       = "myapp-aurora"
  use_aurora = true

  # Налаштування Aurora Engine
  engine_cluster                = "aurora-postgresql"
  engine_version_cluster        = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  aurora_reader_count           = 2

  # Конфігурація інстансу
  instance_class = "db.r6g.large"

  # Облікові дані та мережа
  db_name             = "myapp"
  username            = var.db_username
  password            = var.db_password
  vpc_id              = module.vpc.vpc_id
  subnet_private_ids  = module.vpc.private_subnets
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]

  tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}

## 🛠 Конфігурація та зміна параметрів БД

### 1. Як змінити тип БД (Engine)
* **Для RDS:** замініть значення змінної `engine`. Приклади: `"postgres"`, `"mysql"`, `"mariadb"`.
* **Для Aurora:** замініть значення змінної `engine_cluster`. Приклади: `"aurora-postgresql"`, `"aurora-mysql"`.

### 2. Як змінити версію БД (Engine Version)
* **Для RDS:** керується через змінну `engine_version` (наприклад, `"17"`, `"16.1"`). Також переконайтеся, що `parameter_group_family_rds` відповідає обраній версії (наприклад, `"postgres17"`).
* **Для Aurora:** керується через змінну `engine_version_cluster` (наприклад, `"15.3"`). Відповідно задайте `parameter_group_family_aurora` (наприклад, `"aurora-postgresql15"`).

### 3. Як змінити клас інстансу (Instance Class)
За потужність та обсяг оперативної пам'яті відповідає змінна `instance_class`:
* **Тестове середовище (Dev/Test):** `db.t3.micro`, `db.t3.small`, `db.t4g.micro`.
* **Продакшен (Production):** `db.m6g.large`, `db.r6g.large` тощо.

### 4. Перемикання між RDS та Aurora
Модуль містить внутрішню логіку (`count`), що дозволяє перемикатися між Standalone RDS та Aurora за допомогою однієї змінної:
* `use_aurora = false` — створює одиночний RDS інстанс (з можливістю `multi_az = true`).
* `use_aurora = true` — створює кластер Aurora (1 Writer інстанс та `aurora_reader_count` Reader інстансів).