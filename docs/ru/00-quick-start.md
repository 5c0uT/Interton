# Interton: быстрый старт

Целевая версия: `Interton beta-v_.6.1`

## 1. Что вы получите после этого гайда

После прохождения этого файла вы сможете:

1. корректно установить Interton из релиза,
2. проверить окружение,
3. выполнить smoke-тест,
4. запускать `.it` файлы в `--run` и `--run-compiled`,
5. понимать, где лежат установщики и как проверять их целостность.

## 2. Только официальный источник

Используйте только:

- Репозиторий: `https://github.com/5c0uT/Interton`
- Релизы: `https://github.com/5c0uT/Interton/releases`

Рекомендация: для пользовательской установки берите релизный бинарник, а не сборку из исходников.

## 3. Быстрая установка

### 3.1 Windows MSI-установщик (рекомендуется для большинства пользователей)

В релизах есть установщик формата MSI, который собирается packaging-пайплайном.

Типичный артефакт:

- `intertonc-<release>.msi`

Сценарий применения:

1. Запустите MSI.
2. Завершите установку через мастер.
3. Перезапустите терминал.
4. Проверьте `intertonc --version` и `intertonc --help`.

Что дает MSI в текущем пайплайне:

1. установка в `Program Files\Interton\bin`,
2. добавление пути к бинарнику в системный `PATH`,
3. готовый артефакт `*.msi.sha256` для ручной сверки.

### 3.2 Windows (автозагрузчик с проверками)

```powershell
pwsh scripts/install_interton.ps1
```

Что делает скрипт:

1. Находит `intertonc.exe` автоматически.
2. Создает каталог установки (`C:\Interton\bin`, fallback в `%LOCALAPPDATA%\Interton\bin`).
3. Копирует бинарник.
4. Настраивает `INTERTONC_PATH`.
5. Добавляет каталог в пользовательский `PATH`.
6. Сверяет SHA256 при наличии `.sha256`.
7. Выполняет `hello_world.it` smoke-тест.

Полезные флаги:

- `-InstallDir "D:\Tools\Interton\bin"`
- `-SkipShaCheck`
- `-SkipHelloSmoke`
- `-RegisterIt` (привязывает `.it` к Interton и выставляет иконку файла)

Примечание по иконке:

1. `interton.ico` поставляется как multi-size (`16/24/32/40/48/64/96/128/256`),
2. это обеспечивает корректный resize в проводнике на разных масштабах UI.

Статусы установщика (консоль):

- `[status] CHECK_FAILED | ...` - ошибка проверки (например SHA/hello smoke),
- `[status] CHECK_SKIPPED | ...` - проверка пропущена флагом,
- `[status] INSTALL_SUCCESS | ...` - установка завершилась успешно,
- `[status] INSTALL_PROBLEM | ...` - критическая ошибка установки.

### 3.3 Windows (ручной fallback)

Используйте только если MSI/скрипт недоступны.

1. Скачайте релизный архив.
2. Распакуйте `intertonc.exe` в `C:\Interton\bin`.
3. Добавьте `C:\Interton\bin` в пользовательский `PATH`.
4. Перезапустите терминал.

Проверка:

```powershell
intertonc --version
intertonc --help
```

Ожидаемый вывод (пример):

```text
Interton compiler beta-v_.6.1
Usage: interton_compiler [options] <file1> [file2 ...]
```

### 3.4 Linux/macOS

Автоматический путь (рекомендовано):

```bash
bash scripts/install_interton.sh --yes
```

Загрузчик автоматически:

1. определяет нужный артефакт релиза под вашу ОС/архитектуру,
2. скачивает пакет/архив,
3. проверяет SHA256 (если есть `.sha256`),
4. устанавливает `intertonc`,
5. запускает hello-world smoke.

Уведомления загрузчика (в консоли):

- `[status] CHECK_FAILED | ...` - проверка (например SHA256) не пройдена.
- `[status] INSTALL_SUCCESS | ...` - установка завершена успешно.
- `[status] INSTALL_PROBLEM | ...` - ошибка установки/окружения, нужна проверка логов.

Ручной fallback (если нужен полный контроль):

1. Скачайте релизный архив для вашей ОС.
2. Поместите `intertonc` в каталог из `PATH`.
3. Дайте права на запуск.

```bash
chmod +x /path/to/intertonc
intertonc --version
intertonc --help
```

## 4. Первый запуск программы

Создайте `hello_world.it`:

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

Запустите:

```bash
intertonc --run hello_world.it
```

Ожидаемый вывод:

```text
Hello, Interton
```

## 5. Проверка compiled-конвейера

```bash
intertonc --run-compiled hello_world.it
```

Ожидаемый вывод:

```text
Hello, Interton
```

## 6. Проверка SHA256 вручную

Если рядом лежит файл `intertonc.exe.sha256`, проверьте хеш вручную.

```powershell
Get-FileHash -Algorithm SHA256 .\intertonc.exe
```

Ожидаемый результат: хеш должен совпасть с содержимым `.sha256`.

## 7. Быстрый чеклист готовности

1. `intertonc --version` отрабатывает.
2. `intertonc --help` показывает режимы.
3. `hello_world.it` работает в `--run`.
4. `hello_world.it` работает в `--run-compiled`.
5. Путь к бинарнику зафиксирован в `PATH`.

## 8. Куда идти дальше

1. Язык: `01-language-basics.md`
2. Операторы: `02-operators.md`
3. Функции: `03-functions-procedures-lambdas.md`
4. OOP: `04-classes-oop.md`
5. Модули: `04-modules-libraries.md`
6. FFI: `05-ffi.md`
7. Продвинутые механики: `06-metadata-toning-tunnel-refocus.md`
8. Доменные стеки: `07-quantum-interference-ray.md`
9. CLI: `08-cli-run-modes.md`
10. Вопросы/ошибки: `09-faq.md`
11. Справочник stdlib: `10-standard-library-reference.md`
12. Mermaid-гайд: `11-mermaid-guide.md`

