# Interton FAQ (RU)

Целевая версия: `Interton beta-v_.6.2`

## 1. `intertonc` не запускается. Что делать?

Проверка:

1. `intertonc --version`
2. `intertonc --help`
3. `where intertonc` (Windows) или `which intertonc` (Linux/macOS)

Если команда не находится, проблема почти всегда в `PATH`.

## 2. Как проверить, что версия правильная?

```bash
intertonc --version
```

Ожидайте строку с `beta-v_.6.2`.

## 3. Что использовать каждый день: `--run` или `--run-compiled`?

- Ежедневная разработка: `--run`.
- Проверка release-конвейера: `--run-compiled`.

## 4. После обновления релиза старый бинарник все еще запускается

Причина: в `PATH` раньше стоит другой каталог.

Решение:

1. Проверьте путь через `where intertonc`/`which intertonc`.
2. Удалите старый путь из `PATH`.
3. Оставьте только актуальный путь к новой версии.

## 5. FFI падает или дает неожиданный результат

Типовые причины:

1. несовместимые типы,
2. не установлен runtime внешнего языка,
3. разные версии runtime на разных машинах,
4. невалидные входные данные.

## 6. Как быстро проверить корректность установки?

Используйте минимальный smoke:

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

И команды запуска:

```bash
intertonc --help
intertonc --run hello_world.it
intertonc --run-compiled hello_world.it
```

Ожидаемый вывод на запуске программы:

```text
Hello, Interton
```

## 7. Где брать установщики?

Только из официальных релизов:

`https://github.com/5c0uT/Interton/releases`

В том числе там публикуются Windows MSI-установщики (например `intertonc-<release>.msi`).

## 8. Как работает автоматический установщик Windows?

```powershell
pwsh scripts/install_interton.ps1
```

Он:

1. создает папку установки,
2. прописывает PATH,
3. проверяет SHA256,
4. прогоняет `hello_world.it`.

## 9. Можно ли автоматизировать установку на Linux/macOS через загрузчик?

Да. Используйте:

```bash
bash scripts/install_interton.sh --yes
```

или:

```bash
curl -fsSL https://raw.githubusercontent.com/5c0uT/Interton/main/scripts/install_interton.sh | bash -s -- --yes
```

Загрузчик сам скачивает нужный артефакт релиза, проверяет SHA256 (если доступен) и запускает smoke.

## 10. Почему вывод в примерах иногда отличается?

Возможные причины:

1. различия ОС,
2. различия версий внешних runtime для FFI,
3. вероятностные механики (например quantum/refocus).

## 11. Где смотреть техдок по внутренностям компилятора?

`../../developers/`

## 12. Почему у `.it` не обновилась иконка после установки?

Обычно это кэш иконок Windows.

Проверьте:

1. ассоциация `.it` указывает на `IntertonFile`,
2. `DefaultIcon` указывает на актуальный `interton.ico`,
3. open-command указывает на актуальный `intertonc.exe`.

Обновление кэша:

```powershell
ie4uinit.exe -show
ie4uinit.exe -ClearIconCache
```

Если нужно, повторно примените ассоциацию:

```powershell
pwsh scripts/install_interton.ps1 -RegisterIt -SkipShaCheck -SkipHelloSmoke
```

## 13. Какие метаданные должны быть в Windows-артефактах?

Для `intertonc.exe`:

1. `FileDescription`,
2. `FileVersion`,
3. `ProductName`,
4. `ProductVersion` (`beta-v_.6.2`),
5. `CompanyName`,
6. copyright.

Для MSI:

1. `ARPCOMMENTS`,
2. `ARPCONTACT`,
3. `ARPURLINFOABOUT`,
4. `ARPHELPLINK`,
5. `ARPPRODUCTICON`.


