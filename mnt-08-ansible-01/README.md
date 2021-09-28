# 08.01 Введение в Ansible

1. Запуск плейбука для test.yml
![Alt text](/png/01.png)

2. Файл с переменной some_fact для всех групп
![Alt text](/png/02.png)

3. Созданные контейнеры docker
![Alt text](/png/03.png)

4. Запуск плейбука для prod.yml
![Alt text](/png/04.png)

5. Факты в group_vars для групп deb и el изменил

6. Сами факты и перезапуск плейбука для prod.yaml
![Alt text](/png/06.png)

7. Зашифрованные ansible-vault файлы
![Alt text](/png/07.png)

8. Запуск плейбука с зашифрованными переменными
![Alt text](/png/08.png)

9. Список плагинов типа connection
![Alt text](/png/09.png)

10. В prod.yml добавлен localhost
![Alt text](/png/10.png)

11. Запуск плейбука с добавленным localhost
![Alt text](/png/11.png)

12. Собственно этот файл и читаем.

# Необязательная часть

1. Расшифровка зашифрованных файлов с переменными групп
![Alt text](/png/d01.png)

2. Переменная `some_fact` в файле `group_vars/all/exmp.yml` изменена и зашифрована
![Alt text](/png/d02.png)

3. Запуск плейбука
![Alt text](/png/d03.png)

4. Добавление хоста fedora в docker и prod.yml
![Alt text](/png/d04.png)

5. Скрипт для тестирования плейбука
[/playbook/ansible-test.sh](/playbook/ansible-test.sh)
Он же текстом

```bash
#!/bin/bash
docker start centos7 ubuntu fedora
ansible-playbook -i inventory/prod.yml --vault-password-file  ~/vault-pwd site.yml
docker stop centos7 ubuntu fedora
```
