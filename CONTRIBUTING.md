# Contributing

## EN

This repository is release-focused: user documentation, install scripts, examples, and packaged artifacts.

If your change is about the compiler/IDE/runtime internals, the best place is the main source repository (see the project links in `README.md`).

### What You Can Contribute Here

- Documentation fixes and improvements: `docs/` (EN/RU).
- Install flows and helpers: `scripts/`.
- Examples and expected behavior: `examples/`.
- Release packaging metadata and artifacts: `releases/` (only when explicitly intended).

### Before You Open An Issue

- Check `docs/getting-started.md` and the relevant language index in `docs/en/README.md` or `docs/ru/README.md`.
- If the issue is about installation, include your OS/arch and which installer you used (MSI/PKG/DEB/RPM/TAR or `scripts/install_interton.*`).
- Do not post security-sensitive findings publicly. Use `SECURITY.md`.

### Pull Request Workflow

1. Fork the repo and create a branch.
2. Keep changes focused. Prefer small PRs.
3. Write a clear description: what, why, and how to verify.
4. Open a PR using the template.

### Testing And Verification

Depending on what you changed:

- Docs: ensure links and paths are correct, and update both languages if needed.
- Install scripts:
  - Windows: `pwsh scripts/install_interton.ps1`
  - Linux/macOS: `bash scripts/install_interton.sh --yes`
- Examples:
  - Run a subset: `intertonc --run <file.it>`
  - Run the suite (requires `intertonc` available): `python examples/test_examples.py`

If you cannot run some checks (OS-specific), state that in the PR.

### Style Notes

- Keep docs bilingual when the page exists in both `docs/en/` and `docs/ru/`.
- Prefer predictable filenames and consistent naming with existing docs.
- Avoid committing secrets, tokens, or private data in any files.

## RU

Этот репозиторий ориентирован на релизный путь: пользовательская документация, скрипты установки, примеры и артефакты.

Если изменения относятся к внутренностям компилятора/IDE/runtime, правильнее отправлять их в основной репозиторий исходников (ссылки есть в `README.md`).

### Что можно улучшать здесь

- Документация: `docs/` (EN/RU).
- Скрипты установки: `scripts/`.
- Примеры: `examples/`.
- Артефакты релиза: `releases/` (только если это реально требуется).

### Перед созданием issue

- Проверьте `docs/getting-started.md` и индекс `docs/en/README.md` или `docs/ru/README.md`.
- Для проблем установки укажите ОС/архитектуру и способ установки (MSI/PKG/DEB/RPM/TAR или `scripts/install_interton.*`).
- Не публикуйте уязвимости публично. См. `SECURITY.md`.

### Как делать PR

1. Форкните репозиторий и создайте ветку.
2. Делайте небольшие, сфокусированные PR.
3. Опишите: что поменялось, зачем, и как проверить.
4. Откройте PR по шаблону.

### Проверки

- Документация: проверьте ссылки/пути, при необходимости обновите обе языковые версии.
- Скрипты установки:
  - Windows: `pwsh scripts/install_interton.ps1`
  - Linux/macOS: `bash scripts/install_interton.sh --yes`
- Примеры:
  - Частично: `intertonc --run <file.it>`
  - Набор примеров (нужен `intertonc`): `python examples/test_examples.py`

Если вы не можете прогнать часть проверок (например, из-за ОС), укажите это в PR.

