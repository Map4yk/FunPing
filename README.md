# Minecraft Server Ping Checker

PowerShell-скрипт для определения оптимального айпи на основе количества хопов и пинга.

## 🎯 Возможности

- Проверка доступности TCP-порта серверов
- Измерение пинга (время подключения)
- Подсчёт количества хопов через `tracert`
- Автоматический расчёт рейтинга (70% вес на hops, 30% на ping)
- Вывод TOP-5 лучших серверов
- Рекомендация оптимального сервера

## 📊 Алгоритм оценки

Скрипт использует нормализованный скоринг:
- **Hops (70%)** — меньше хопов = лучше маршрут
- **Ping (30%)** — меньше пинг = быстрее соединение

```
Score = (Hops/MaxHops) * 0.7 + (Ping/MaxPing) * 0.3
```

Чем ниже Score — тем лучше сервер.

## 🚀 Быстрый запуск
Через cmd.exe от имени администратора:
```cmd
powershell -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/Map4yk/FunPing/refs/heads/master/Main.ps1')"
```

Через PowerShell от имени администратора:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/Map4yk/FunPing/refs/heads/master/Main.ps1')
```

## 📥 Локальный запуск

1. Скачайте `Main.ps1`
2. Откройте PowerShell в папке со скриптом
3. Выполните:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Main.ps1
```

## 📋 Пример вывода

```
[+] IP: play2.funtime.su - OK | Hops: 8 | Ping: 45.32 ms
[+] IP: mc.funtime.su - OK | Hops: 10 | Ping: 52.18 ms
[+] IP: tcp.funtime.sh - CLOSED

TOP-5 SERVERS:
 #1 play2.funtime.su:25565 | Hops: 8 | Ping: 45.32 ms
 #2 neo.funtime.sh:25565 | Hops: 9 | Ping: 48.21 ms
 #3 mc.funtime.su:25565 | Hops: 10 | Ping: 52.18 ms
 #4 connect.funtime.su:25565 | Hops: 11 | Ping: 55.44 ms
 #5 tt.funtime.su:25565 | Hops: 12 | Ping: 60.12 ms

Recommended server: play2.funtime.su:25565 (Ping: 45.32 ms, Hops: 8)
```

## ⚙️ Требования

- Windows 10/11
- PowerShell 5.1+
- Доступ к интернету

## 📝 Лицензия

MIT
