# Getting Started / Быстрый старт

<p align="center">
  <img src="../../interton.ico" alt="Interton icon" width="48">
</p>
<p align="center">
  <img src="../../Interton.svg" alt="Interton logo" width="420">
</p>

Target version / Целевая версия: `Interton beta-v_.6.1`

This page is a bilingual navigation hub for first-time users.

Эта страница - двуязычная точка входа для нового пользователя.

## 1. Start here / Начните отсюда

- RU guide: `ru/00-quick-start.md`
- EN guide: `en/00-quick-start.md`
- Main user index: `README.md`
- Release upload checklist: `release-checklist.md`

## 2. Minimum installation checklist / Минимальный чеклист установки

Recommended order:

1. Windows: use MSI from `https://github.com/5c0uT/Interton/releases`.
2. Linux/macOS: use `scripts/install_interton.sh`.
3. Manual binary-to-PATH setup only as fallback.
4. Validate runtime availability.

```bash
intertonc --version
intertonc --help
```

Expected output (sample):

```text
Interton compiler beta-v_.6.1
Usage: interton_compiler [options] <file1> [file2 ...]
```

## 3. First program smoke

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

## 4. Recommended next steps

1. Read language basics (`ru/01-language-basics.md` or `en/01-language-basics.md`).
2. Read operators and function model.
3. Move to modules/FFI/domain stacks after core language is clear.
4. Use reference docs for built-ins and Mermaid behavior:
   `ru/10-standard-library-reference.md`, `en/10-standard-library-reference.md`,
   `ru/11-mermaid-guide.md`, `en/11-mermaid-guide.md`.

## 5. Windows automated installer

```powershell
pwsh scripts/install_interton.ps1
```

What is configured automatically:

1. install directory creation,
2. PATH configuration,
3. SHA256 validation,
4. hello-world smoke execution.

## 6. IDE status

IDE integration guide is available as status page and is currently marked as in development:

- `09-IDE-Guide.md`

