# 10.01. Зачем и что нужно мониторить

1. Основные метрики для мониторинга HTTP приложения: время отклика (Latency), величина трафика (Traffic), уровень ошибок (Errors), загруженность/насыщенность (Saturation) (в данном случае CPU). 
2. Предложение: считаем метрики SLI и показываем насколько они попадают в значения или диапазоны SLO. Из этого рассчитываем уровень SLA.
3. Самое простое что можно сделать - завести отдельный web сервис в котором выводить напрямую текстовые файлы с логами ошибок приложения. Если сервис распределенный, ничего не мешает собирать логи через syslog или поднять везде web сервис и спроксировать вывод логов со всех серверов через один основной.
4. В примере забыли про коды 3хх, в таком случае нужно считать от суммы кодов 2хх и 3хх. 

# Дополнительное задание 
Строка конфигурации через файл `/etc/crontab`:
```
*  *  *  *  * root /data/script/mon.py
```
Т.к. нам нужно запускать скрипт раз в минуту то можно указать все звездочки, cron и так выполняется раз в минуту.

Пример скрипта `/data/script/mon.py`. Скрипт написан и использованием библиотеки psutil. Напрямую парсить данные через /proc это странно:
```python
#!/usr/bin/python3
import psutil
import json
from datetime import datetime as dt

result = dict()

now = dt.now()
result['timestamp'] = now.strftime("%s")

#Загрузка CPU
result['cpuload_p'] = psutil.cpu_percent(interval=1)
#Загрузка виртуальной памяти
result['vmload_p'] = psutil.virtual_memory().percent
#Загрузка свопа
result['swapload_p'] = psutil.swap_memory().percent

#Общее количество операций чтения со всех дисков
result['disk_io_r'] = psutil.disk_io_counters().read_count
#Общее количество операций записи со всех дисков
result['disk_io_w'] = psutil.disk_io_counters().write_count
#Общее количество прочитанных байт со всех дисков
result['disk_bytes_r'] = psutil.disk_io_counters().read_bytes
#Общее количество записанных байт со всех дисков
result['disk_bytes_w'] = psutil.disk_io_counters().write_bytes

#Общее количество отправленных байт со всех интерфейсов
result['net_bytes_s'] = psutil.net_io_counters().bytes_sent
#Общее количество полученных байт со всех интерфейсов
result['net_bytes_r'] = psutil.net_io_counters().bytes_recv

filepath = "/var/log/"+now.strftime("%y-%m-%d")+"-awesome-monitoring.log"

with open(filepath, "a") as log:
    log.write(json.dumps(result)+"\n")
```

Пример вывода:
```json
{"timestamp": "1641664234", "cpuload_p": 16.5, "vmload_p": 72.0, "swapload_p": 5.7, "disk_io_r": 19852268, "disk_io_w": 151300219, "disk_bytes_r": 830828390400, "disk_bytes_w": 4235232534528, "net_bytes_s": 2263586546091, "net_bytes_r": 1938457577619}
{"timestamp": "1641664327", "cpuload_p": 14.6, "vmload_p": 72.0, "swapload_p": 5.7, "disk_io_r": 19870128, "disk_io_w": 151316671, "disk_bytes_r": 831308064768, "disk_bytes_w": 4236638674944, "net_bytes_s": 2263764519071, "net_bytes_r": 1938612035740}
{"timestamp": "1641664381", "cpuload_p": 21.7, "vmload_p": 72.0, "swapload_p": 5.7, "disk_io_r": 19873861, "disk_io_w": 151326050, "disk_bytes_r": 831429748736, "disk_bytes_w": 4237129555968, "net_bytes_s": 2263868487094, "net_bytes_r": 1938701542712}
{"timestamp": "1641664441", "cpuload_p": 15.7, "vmload_p": 72.0, "swapload_p": 5.7, "disk_io_r": 20131763, "disk_io_w": 151339177, "disk_bytes_r": 833761351680, "disk_bytes_w": 4239817535488, "net_bytes_s": 2263986774323, "net_bytes_r": 1938802867712}
{"timestamp": "1641664501", "cpuload_p": 14.8, "vmload_p": 72.0, "swapload_p": 5.7, "disk_io_r": 20134407, "disk_io_w": 151349210, "disk_bytes_r": 833813899264, "disk_bytes_w": 4240900202496, "net_bytes_s": 2264129553679, "net_bytes_r": 1938920913069}
{"timestamp": "1641664562", "cpuload_p": 17.8, "vmload_p": 72.1, "swapload_p": 5.7, "disk_io_r": 20156149, "disk_io_w": 151358187, "disk_bytes_r": 834592622592, "disk_bytes_w": 4241427341312, "net_bytes_s": 2264259372506, "net_bytes_r": 1939034649926}
```