# Interton CLI: режимы запуска и сборки

Целевая версия: `Interton beta-v_.6.1`

## 1. Базовая проверка CLI

```bash
intertonc --version
intertonc --help
```

Ожидаемый вывод (пример):

```text
Interton compiler beta-v_.6.1
Usage: interton_compiler [options] <file1> [file2 ...]
```

## 2. Основные режимы

- `--run` - интерпретация/запуск (режим по умолчанию)
- `--run-compiled` - компиляция и запуск
- `--assemble` - emit executable
- `--emit-llvm` - генерация `.ll`
- `--emit-obj` - генерация объектного файла
- `--emit-exe` - генерация исполняемого файла
- `-o <path>` - выходной файл

## 3. Практические команды

### 3.1 Run-mode

```bash
intertonc --run hello_world.it
```

Ожидаемый вывод:

```text
Hello, Interton
```

### 3.2 Compiled run

```bash
intertonc --run-compiled hello_world.it
```

Ожидаемый вывод:

```text
Hello, Interton
```

### 3.3 LLVM IR

```bash
intertonc --emit-llvm src/main.it -o output/main.ll
```

Ожидаемый результат: файл `output/main.ll` создан.

### 3.4 Object file

```bash
intertonc --emit-obj src/main.it -o output/main.obj
```

Ожидаемый результат: файл `output/main.obj` создан.

### 3.5 Executable

```bash
intertonc --emit-exe src/main.it -o output/main.exe
```

Ожидаемый результат: файл `output/main.exe` создан.

## 4. Как выбирать режим

1. `--run` - быстрый цикл разработки.
2. `--run-compiled` - проверка release-пути.
3. `--emit-*` - CI/CD и выпуск артефактов.

## 5. Рекомендованный CI-пайплайн

1. Проверка `--version` и `--help`.
2. Smoke `--run` на `hello_world.it`.
3. Smoke `--run-compiled` на том же файле.
4. Emit целевого артефакта (`--emit-exe`/`--emit-obj`/`--emit-llvm`).

## 6. Релизный путь установки для пользователя

Сначала скачивайте релизы:

`https://github.com/5c0uT/Interton/releases`

Windows-автоматизация:

```powershell
pwsh scripts/install_interton.ps1
```

Что выполняется автоматически:

1. создание директории установки,
2. настройка PATH,
3. SHA-проверка,
4. hello-world smoke.

## 7. Минимальный smoke-набор после обновления

1. `intertonc --version`
2. `intertonc --help`
3. `intertonc --run hello_world.it`
4. `intertonc --run-compiled hello_world.it`

## 8. Минимальный `.it` smoke-файл

```interton
adding std.io

call main() -> int {
    inscribe("CLI smoke ok")
    return 0
}
```

Запуск:

```bash
intertonc --run smoke.it
```

Ожидаемый вывод:

```text
CLI smoke ok
```

