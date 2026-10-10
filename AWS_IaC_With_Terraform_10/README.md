# Задача 10 — перенесення ресурсу між state

Наявна IAM policy `resource-move-demo-policy` була зареєстрована як `aws_iam_policy.custom_policy` у `tf_code_1.tfstate`. Її запис перенесено до `tf_code_2.tfstate` через `terraform state mv`, без змін policy в AWS.

- `tf_code_1/` — фінальна вихідна конфігурація без ресурсу policy.
- `tf_code_2/resources.tf` — єдине оголошення policy після перенесення.
- S3 bucket лабораторної: `cmtr-p9rj0mw4-backend-bucket-1791402464`.
- [GitLab fork](https://gitlab.com/savytskyiTech/module_aws_typ2_task10), фінальний коміт `b34fb1e`.

## Послідовність команд

Команди виконуються з каталогу цієї задачі. Для повторення потрібен вихідний стан: policy ще в першому state, другий state порожній. Фінальні конфігурації в репозиторії вже відповідають результату перенесення.

```bash
terraform -chdir=tf_code_1 init \
  -backend-config='bucket=cmtr-p9rj0mw4-backend-bucket-1791402464' \
  -backend-config='key=tf_code_1.tfstate' \
  -backend-config='region=eu-west-1'

terraform -chdir=tf_code_2 init \
  -backend-config='bucket=cmtr-p9rj0mw4-backend-bucket-1791402464' \
  -backend-config='key=tf_code_2.tfstate' \
  -backend-config='region=eu-west-1'

terraform -chdir=tf_code_1 state pull > source.tfstate
terraform -chdir=tf_code_2 state pull > destination.tfstate

terraform state mv \
  -state=source.tfstate \
  -state-out=destination.tfstate \
  aws_iam_policy.custom_policy aws_iam_policy.custom_policy

terraform -chdir=tf_code_1 state push source.tfstate
terraform -chdir=tf_code_2 state push destination.tfstate

terraform -chdir=tf_code_1 state list
terraform -chdir=tf_code_2 state list
terraform -chdir=tf_code_1 fmt -check
terraform -chdir=tf_code_2 fmt -check
terraform -chdir=tf_code_1 validate
terraform -chdir=tf_code_2 validate
terraform -chdir=tf_code_1 plan
terraform -chdir=tf_code_2 plan
```

`state mv` у цьому прикладі запускається з батьківського каталогу без backend-конфігурації: він працює з двома локальними копіями remote state. Перед операцією збережено окремі копії обох вихідних state. Між читанням і записом state інші Terraform-операції з цими backend не повинні виконуватися; два записи до S3 не є однією атомарною операцією.

Після перенесення перший `state list` порожній, другий містить `aws_iam_policy.custom_policy`. Обидва плани показали `No changes`; AWS ARN policy збережено.

## Що розібрати під час навчання

- Як адреса `aws_iam_policy.custom_policy` пов'язана з записом state і реальним AWS ARN.
- Чому перенесення state має супроводжуватися перенесенням оголошення ресурсу.
- Як працюють `state pull`, `state mv`, `state push`, serial, lineage та блокування.
- Чому один ресурс має бути керований лише однією конфігурацією після міграції.
