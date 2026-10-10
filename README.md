# Terraform Training

Репозиторій із виконаними лабораторними задачами з AWS і Terraform.

## Задачі 10–12: робота зі state

| Задача | Приклад | Теми для майбутнього плану навчання |
| --- | --- | --- |
| [10](AWS_IaC_With_Terraform_10/README.md) | Перенесення IAM policy між двома state | Адреси ресурсів, межі конфігурацій, `state pull`, `state mv`, `state push`, блокування state |
| [11](AWS_IaC_With_Terraform_11/README.md) | Міграція S3 backend у новий bucket | Backend, параметри `init`, `init -migrate-state`, відмінність між state та ресурсами AWS |
| [12](AWS_IaC_With_Terraform_12/README.md) | Імпорт наявної IAM policy | ARN, `terraform import`, відповідність конфігурації наявному ресурсу, перевірка через `plan` |

Каталоги містять фінальні конфігурації після виконання задач. У README кожної задачі збережено контекст і послідовність команд. Під час виконання всі фінальні плани показали `No changes`, а конфігурації пройшли `terraform fmt` і `terraform validate`.

Назви bucket і ресурсів належать тимчасовим лабораторним середовищам. Для повторення вправ потрібні власні підготовлені ресурси, AWS-доступ та актуальні backend-параметри. State-файли й credentials до Git не додаються.
