# Задача 13 — Blue/Green із weighted routing

ALB слухає HTTP на порту 80 та пересилає запити до двох target groups. Кожне середовище має власний Launch Template і Auto Scaling group. VPC, дві публічні підмережі та три security groups знаходяться через data sources за тегами `Name`.

| Середовище | Заголовок сторінки | Початкова вага | Інстанси |
| --- | --- | --- | --- |
| Blue | `Blue Environment` | 100 | 1 × `t3.micro` |
| Green | `Green Environment` | 0 | 1 × `t3.micro` |

Ваги задають співвідношення трафіку: `100/0` направляє його до Blue, `50/50` розподіляє між обома середовищами, `0/100` направляє до Green. Обидві ASG мають мінімум 1 та максимум 2 інстанси. Вага 0 не вимикає Green-інстанси.

## Перевірка конфігурації

Команди виконуються з каталогу цієї задачі за наявності AWS-доступу до лабораторного акаунта:

```bash
terraform init
terraform fmt
terraform validate
terraform plan -var "blue_weight=100" -var "green_weight=0"
```

Ваги також збережені у `terraform.tfvars`. План показує майбутні зміни; для фактичного розгортання або перемикання трафіку потрібен окремий `terraform apply`. За умовами задачі виконується підготовка плану.

## Теми для навчання

- ALB listener, forward action, ваги та HTTP health checks.
- Зв'язок target group, Auto Scaling group і Launch Template.
- `for_each` для двох середовищ та адреси ресурсів із ключами `blue` і `green`.
- Base64 user data, встановлення Apache та запуск сервісу через systemd.
- Data sources, теги, змінні, validation та lifecycle precondition.
- Зміна ваг як спосіб переключення між версіями застосунку.
