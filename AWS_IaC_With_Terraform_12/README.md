# Задача 12 — імпорт наявної IAM policy

IAM policy `cmtr-p9rj0mw4-iam-policy` вже існувала в AWS. Її опис додано до `resources.tf`, а сам ресурс зареєстровано у Terraform state командою `terraform import` як `aws_iam_policy.custom_policy`.

- Bucket лабораторної: `cmtr-p9rj0mw4-backend-bucket-1791625191`.
- Ключ state: `tf_code.tfstate`; регіон: `eu-west-1`.
- Policy має шлях `/`, опис `Custom role with limited permissions`, дозволяє `ec2:*` та `s3:*` для `Resource = "*"`, не має тегів.
- [GitLab fork](https://gitlab.com/savytskyiTech/module_aws_typ2_task12), коміт `b10949b`.

У лабораторному середовищі репозиторій є робочим каталогом `tf_code`. Тут його файли збережено безпосередньо в каталозі задачі.

## Послідовність команд

Перед імпортом через AWS CLI прочитано ARN, опис, шлях, теги та чинну версію документа policy. `resources.tf` підготовлено відповідно до цих даних.

```bash
terraform init
terraform fmt
terraform validate

TASK12_POLICY_ARN=$(aws iam list-policies \
  --scope Local \
  --query "Policies[?PolicyName=='cmtr-p9rj0mw4-iam-policy'].Arn | [0]" \
  --output text)

aws iam get-policy --policy-arn "$TASK12_POLICY_ARN"
aws iam get-policy-version \
  --policy-arn "$TASK12_POLICY_ARN" \
  --version-id v1

terraform import aws_iam_policy.custom_policy "$TASK12_POLICY_ARN"

terraform state list
terraform fmt -check
terraform validate
terraform plan
```

`v1` була чинною версією в цій лабораторній; для іншої policy її потрібно взяти з `DefaultVersionId` у результаті `get-policy`. Для повторення імпорту потрібна наявна policy, ще не зареєстрована за цією адресою у state.

Фінальний план показав `No changes`. Унікальний ID policy, її версія та дата останньої зміни збіглися з даними до імпорту.

## Що розібрати під час навчання

- Як отримати ARN та фактичну конфігурацію AWS-ресурсу.
- Чому перед CLI-імпортом потрібне оголошення ресурсу в Terraform.
- Що `terraform import` записує у state та чому він не генерує конфігурацію.
- Як використовувати `plan`, щоб знайти розбіжності між кодом і наявним ресурсом.
