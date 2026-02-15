# IDE Guide / Гид по IDE

Target version / Целевая версия: `Interton beta-v_.6.2`

## Status / Статус

`IDE support is currently in active development.`

`Поддержка IDE сейчас находится в активной разработке.`

## What is stable today / Что стабильно уже сейчас

1. CLI workflow via `intertonc --run` and `intertonc --run-compiled`.
2. Manual integration in editors through shell tasks.
3. File extension `.it` as plain text if syntax plugin is unavailable.

## Recommended approach for now / Рекомендованный подход сейчас

1. Use release binaries from `https://github.com/5c0uT/Interton/releases`.
2. Configure editor tasks that call `intertonc` directly.
3. Treat IDE integrations as optional convenience layer, not a required runtime component.

## Primary references / Основные ссылки

1. `docs/users/README.md`
2. `docs/users/getting-started.md`
3. `docs/users/ru/09-cli-run-modes.md`
4. `docs/users/en/09-cli-run-modes.md`

