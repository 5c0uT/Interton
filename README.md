# Interton User Documentation / Пользовательская документация Interton

<p align="center">
  <img src=".github/assets/Interton.svg" alt="Interton logo" width="560">
</p>

[![Repository](https://img.shields.io/badge/GitHub-5c0uT%2FInterton-black?logo=github)](https://github.com/5c0uT/Interton)
[![Releases](https://img.shields.io/badge/Releases-Download-success)](https://github.com/5c0uT/Interton/releases)
[![Build](https://img.shields.io/badge/CI-Passing-brightgreen)](https://github.com/5c0uT/Interton/actions)
[![Platforms](https://img.shields.io/badge/Platforms-Windows%20%7C%20macOS%20%7C%20Linux-informational)](https://github.com/5c0uT/Interton/releases)
[![Language](https://img.shields.io/badge/Docs-RU%20%2F%20EN-orange)](#documentation-map--карта-документации)
[![License](https://img.shields.io/badge/License-MIT-yellow)](../License.md)

Current target version / Целевая версия: `Interton beta-v_.6.2`

## EN

Interton is a language for practical engineering workflows: typed core language, standard modules, domain stacks (quantum/interference/ray), and foreign integration in one runtime entrypoint.

Official links:

- Repository: `https://github.com/5c0uT/Interton`
- Releases: `https://github.com/5c0uT/Interton/releases`

### Release-first installation policy

For users, always start with release artifacts from GitHub Releases.

Recommended order:

1. Windows: MSI installer (`intertonc-<release>.msi`).
2. Linux/macOS: loader `scripts/install_interton.sh`.
3. Manual install only as fallback.

```bash
intertonc --version
intertonc --help
```

Expected output (sample):

```text
Interton compiler beta-v_.6.2
Usage: interton_compiler [options] <file1> [file2 ...]
...
```

### Automated Windows install

```powershell
pwsh scripts/install_interton.ps1
```

The installer script performs:

1. Auto-detection of `intertonc.exe`.
2. Installation directory creation (default `C:\Interton\bin`, fallback to `%LOCALAPPDATA%\Interton\bin`).
3. Binary copy to install directory.
4. `INTERTONC_PATH` environment setup.
5. User `PATH` update.
6. SHA256 validation when `.sha256` file exists.
7. Smoke run for `hello_world.it`.

### Automated Linux/macOS loader

```bash
bash scripts/install_interton.sh --yes
```

One-line remote loader (without cloning repo):

The loader automatically:

1. resolves a release asset for your OS/arch,
2. downloads it,
3. verifies SHA256 (if `.sha256` is published),
4. installs via package/tar installer,
5. runs a `hello_world.it` smoke check.

### First program in 60 seconds

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

```bash
intertonc --run hello_world.it
```

Expected output:

```text
Hello, Interton
```

### Read docs by topic

- Entry point: `users/getting-started.md`
- Language basics: `users/en/01-language-basics.md`
- Operators: `users/en/02-operators.md`
- Functions/procedures/lambdas: `users/en/03-functions-procedures-lambdas.md`
- Classes/OOP: `users/en/04-classes-oop.md`
- Modules/libraries: `users/en/05-modules-libraries.md`
- FFI: `users/en/06-ffi.md`
- Metadata/toning/tunnel/refocus: `users/en/07-metadata-toning-tunnel-refocus.md`
- Quantum/interference/ray stacks: `users/en/08-quantum-interference-ray.md`
- CLI run modes: `users/en/09-cli-run-modes.md`
- FAQ: `users/en/10-faq.md`
- Standard library reference: `users/en/11-standard-library-reference.md`
- Mermaid guide: `users/en/12-mermaid-guide.md`
- Release checklist: `users/release-checklist.md`
- IDE guide status: `users/ide-guide.md` (in development)

## RU

Interton - это язык для инженерной разработки с единым входом в типизированное ядро, стандартные модули, предметные стеки (quantum/interference/ray) и мультиязычную интеграцию.

Официальные ссылки:

- Репозиторий: `https://github.com/5c0uT/Interton`
- Релизы: `https://github.com/5c0uT/Interton/releases`

### Политика установки для пользователей

Для пользовательской работы всегда берите релизные артефакты из GitHub Releases.

Рекомендуемый порядок:

1. Windows: MSI-установщик (`intertonc-<release>.msi`).
2. Linux/macOS: загрузчик `scripts/install_interton.sh`.
3. Ручная установка только как fallback.

```bash
intertonc --version
intertonc --help
```

Ожидаемый вывод (пример):

```text
Interton compiler beta-v_.6.2
Usage: interton_compiler [options] <file1> [file2 ...]
...
```

### Автоустановка на Windows

```powershell
pwsh scripts/install_interton.ps1
```

Скрипт автоматически:

1. Находит `intertonc.exe`.
2. Создает директорию установки (`C:\Interton\bin` или fallback в `%LOCALAPPDATA%`).
3. Копирует бинарник.
4. Настраивает `INTERTONC_PATH`.
5. Обновляет пользовательский `PATH`.
6. Проверяет SHA256 при наличии `.sha256`.
7. Прогоняет smoke-тест `hello_world.it`.

### Автозагрузчик Linux/macOS

```bash
bash scripts/install_interton.sh --yes
```

Что делает загрузчик:

1. определяет нужный релизный артефакт под вашу ОС/архитектуру,
2. скачивает его,
3. сверяет SHA256 (если опубликован `.sha256`),
4. устанавливает через пакет/инсталлятор tar,
5. прогоняет `hello_world.it` smoke-тест.

### Первая программа за 1 минуту

```interton
adding std.io

call main() -> int {
    inscribe("Привет, Interton")
    return 0
}
```

```bash
intertonc --run hello_world.it
```

Ожидаемый вывод:

```text
Привет, Interton
```

### Чтение документации по темам

- Точка входа: `users/getting-started.md`
- Базовый синтаксис: `users/ru/01-language-basics.md`
- Операторы: `users/ru/02-operators.md`
- Функции/процедуры/лямбды: `users/ru/03-functions-procedures-lambdas.md`
- Классы/OOP: `users/ru/04-classes-oop.md`
- Модули/библиотеки: `users/ru/05-modules-libraries.md`
- FFI: `users/ru/06-ffi.md`
- Metadata/toning/tunnel/refocus: `users/ru/07-metadata-toning-tunnel-refocus.md`
- Quantum/interference/ray стеки: `users/ru/08-quantum-interference-ray.md`
- Режимы CLI: `users/ru/09-cli-run-modes.md`
- FAQ: `users/ru/10-faq.md`
- Справочник stdlib и built-ins: `users/ru/11-standard-library-reference.md`
- Mermaid-гайд: `users/ru/12-mermaid-guide.md`
- Релизный чеклист: `users/release-checklist.md`
- Статус IDE-гида: `users/ide-guide.md` (в разработке)

## Documentation Map / Карта документации

### Russian (`docs/users/ru`)

1. `users/ru/00-quick-start.md` - установка, проверка, smoke, обновление.
2. `users/ru/01-language-basics.md` - синтаксис, типы, коллекции, control flow.
3. `users/ru/02-operators.md` - арифметика, сравнения, присваивание, срезы.
4. `users/ru/03-functions-procedures-lambdas.md` - функции и композиция логики.
5. `users/ru/04-classes-oop.md` - классы, методы, работа с состоянием.
6. `users/ru/05-modules-libraries.md` - импорт, alias, std-модули.
7. `users/ru/06-ffi.md` - интеграция с внешними языками.
8. `users/ru/07-metadata-toning-tunnel-refocus.md` - продвинутые механики языка.
9. `users/ru/08-quantum-interference-ray.md` - доменные стеки.
10. `users/ru/09-cli-run-modes.md` - режимы запуска и сборки.
11. `users/ru/10-faq.md` - диагностика и рабочие ответы.
12. `users/ru/11-standard-library-reference.md` - справочник встроенных функций и stdlib.
13. `users/ru/12-mermaid-guide.md` - параметры Mermaid и runtime-статусы.
14. `users/release-checklist.md` - что именно публиковать в релиз по платформам.

### English (`docs/users/en`)

1. `users/en/00-quick-start.md` - install and first run.
2. `users/en/01-language-basics.md` - language core.
3. `users/en/02-operators.md` - expression and operator guide.
4. `users/en/03-functions-procedures-lambdas.md` - callable design.
5. `users/en/04-classes-oop.md` - class model and usage.
6. `users/en/05-modules-libraries.md` - imports and standard modules.
7. `users/en/06-ffi.md` - foreign integrations.
8. `users/en/07-metadata-toning-tunnel-refocus.md` - advanced runtime surface.
9. `users/en/08-quantum-interference-ray.md` - domain stacks.
10. `users/en/09-cli-run-modes.md` - CLI command matrix.
11. `users/en/10-faq.md` - troubleshooting.
12. `users/en/11-standard-library-reference.md` - built-ins and stdlib reference.
13. `users/en/12-mermaid-guide.md` - Mermaid runtime parameters and diagnostics.
14. `users/release-checklist.md` - exact cross-platform release upload checklist.

## Scope

This user documentation focuses on writing and running Interton programs.

Эта документация ориентирована на пользователя языка: как писать и запускать программы на Interton.

Compiler internals are documented in developer docs under `docs/developers`.

