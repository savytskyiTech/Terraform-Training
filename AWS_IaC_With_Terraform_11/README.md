# Задача 11 — міграція S3 backend

Terraform state перенесено через `terraform init -migrate-state` зі старого S3 bucket у новий. IAM policy `aws_iam_policy.custom_policy` залишилася тією самою.

| Параметр | Значення лабораторної |
| --- | --- |
| Старий bucket | `cmtr-p9rj0mw4-backend-bucket-1791453002` |
| Новий bucket | `cmtr-p9rj0mw4-backend-new-bucket-1791453002` |
| Ключ state | `tf_code.tfstate` |
| Регіон | `eu-west-1` |

`providers.tf` містить фінальну backend-конфігурацію з новим bucket. [GitLab fork](https://gitlab.com/savytskyiTech/module_aws_typ2_task11), коміт `a3d0558`.

## Послідовність команд

Команди виконуються з каталогу задачі. Для повторення потрібен state у старому bucket та підготовлений новий bucket.

```bash
terraform init \
  -backend-config='bucket=cmtr-p9rj0mw4-backend-bucket-1791453002' \
  -backend-config='key=tf_code.tfstate' \
  -backend-config='region=eu-west-1'

terraform init -migrate-state \
  -backend-config='bucket=cmtr-p9rj0mw4-backend-new-bucket-1791453002' \
  -backend-config='key=tf_code.tfstate' \
  -backend-config='region=eu-west-1'

terraform state list
terraform fmt -check
terraform validate
terraform plan
```

На другому `init` Terraform просить підтвердити копіювання state до нового backend. Під час виконання лабораторної використано `-force-copy -input=false`, щоб підтвердити копіювання без інтерактивного запиту. Перед міграцією збережено локальну копію state для звірки.

Після міграції всі атрибути керованих ресурсів та outputs збіглися з вихідними; ARN та унікальний ID IAM policy збережено. Фінальний план показав `No changes`.

## Що розібрати під час навчання

- Як backend визначає місце зберігання state.
- Як поєднуються блок `backend`, `-backend-config` та локальний кеш `.terraform`.
- Чим `init -migrate-state` відрізняється від `init -reconfigure`.
- Чому для міграції backend не потрібен новий `terraform apply`.
