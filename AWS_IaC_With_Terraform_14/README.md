# Задача 14 — network, network_security та application modules

Коренева конфігурація з’єднує три локальні модулі. Вся інфраструктура задачі створюється з нуля в `eu-west-1`; Terraform використовує local backend за замовчуванням.

```text
AWS_IaC_With_Terraform_14/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── versions.tf
└── modules/
    ├── network/
    ├── network_security/
    └── application/
```

Кожен модуль містить `main.tf`, `variables.tf`, `outputs.tf` та `versions.tf`. AWS provider налаштований у root і успадковується модулями.

## Ресурси та зв’язки

| Модуль | Вміст | Outputs |
| --- | --- | --- |
| `network` | VPC `10.10.0.0/16`, три public subnets, IGW, route table, маршрут до інтернету та associations | VPC ID, subnet IDs |
| `network_security` | SSH SG, public HTTP SG, private HTTP SG із вкладеними ingress/egress rules | Map security group IDs |
| `application` | Amazon Linux 2023 AMI data source, Launch Template, ASG, ALB, target group, HTTP listener, ASG attachment | Load balancer DNS name |

Підмережі мають CIDR `10.10.1.0/24`, `10.10.3.0/24`, `10.10.5.0/24` і розташовані в `eu-west-1a`, `eu-west-1b`, `eu-west-1c`. Імена ресурсів генеруються з `project_id` або передаються через inputs модулів.

Маршрут `0.0.0.0/0` до IGW описано вкладеним блоком `route` у `aws_route_table`. Окремий ресурс `aws_route` не використовується, оскільки перевірка платформи його не дозволяє.

SSH та HTTP до ALB дозволені тільки з `18.153.146.156/32` і `194.147.221.112/32`. HTTP до інстансів дозволений від public HTTP security group балансувальника. EC2 використовують SSH і private HTTP SG; ALB — public HTTP SG.

Усі ingress/egress правила задані вкладеними блоками в `aws_security_group`; окремі ресурси `aws_security_group_rule` не використовуються відповідно до обмеження перевірки платформи.

ASG має `desired_capacity = 2`, `min_size = 2`, `max_size = 2`. Target group приєднана через `aws_autoscaling_attachment`; ASG ігнорує зміни `load_balancers` і `target_group_arns`.

User data встановлює Apache, отримує instance ID через IMDSv2, читає UUID з `/sys/devices/virtual/dmi/id/product_uuid` та створює сторінку:

```text
This message was generated on instance <instance-id> with the following UUID <machine-uuid>
```

Для встановлення packages інстанси отримують public IP і вихідний доступ до інтернету. Створювані taggable resources, інстанси та volumes мають теги `Terraform=true` і `Project=cmtr-p9rj0mw4`.

## Workflow

Команди запускаються з цього каталогу з чинним AWS-доступом лабораторної:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=task14.tfplan
```

Root `terraform validate` перевіряє також усі підключені child modules. Несекретні значення містяться в `terraform.tfvars`; credentials передаються через AWS profile або environment.

Перевірка 13.10.2026: `init`, `fmt -recursive -check` та `validate` успішні; фінальний план після перенесення маршруту й security group rules у вкладені блоки містить **18 create, 0 update, 0 destroy**. JSON плану підтверджує відсутність `aws_route` і `aws_security_group_rule`, наявність маршруту в `aws_route_table`, обидва дозволені CIDR для SSH/HTTP та вихідний доступ. Синтаксис Bash user data також перевірено. Workflow задачі завершується планом; AWS-ресурси під час локальної перевірки не створювалися.

Після розгортання DNS і URL доступні через outputs `load_balancer_dns_name` та `application_url`.
