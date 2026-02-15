# Interton: quick start (detailed user guide)

Target version: `Interton beta-v_.6.2`

## 1. What you will complete in this guide

After this file, you should be able to:

1. install Interton from official releases,
2. verify your environment,
3. run smoke checks,
4. run programs in `--run` and `--run-compiled`,
5. understand where installers are and how integrity is verified.

## 2. Official source only

Use only:

- Repository: `https://github.com/5c0uT/Interton`
- Releases: `https://github.com/5c0uT/Interton/releases`

Recommended policy: for end users, prefer release binaries instead of source builds.

## 3. Installation paths

### 3.1 Windows MSI installer (recommended for most users)

In releases, Windows packaging includes installer artifacts, including MSI packages produced by the release pipeline.

Typical Windows artifacts:

- `intertonc-<release>.msi`
- `intertonc.exe`
- corresponding `.sha256` files

Installer flow:

1. Run MSI.
2. Finish setup wizard.
3. Restart terminal.
4. Validate `intertonc --version` and `intertonc --help`.

What MSI currently does in pipeline output:

1. installs to `Program Files\Interton\bin`,
2. appends binary directory to system `PATH`,
3. publishes `*.msi.sha256` for manual integrity checks.

### 3.2 Windows automated loader (with runtime checks)

```powershell
pwsh scripts/install_interton.ps1
```

What the script does:

1. auto-detects `intertonc.exe`,
2. creates install directory (`C:\Interton\bin` or `%LOCALAPPDATA%\Interton\bin` fallback),
3. copies binary,
4. sets `INTERTONC_PATH`,
5. updates user `PATH`,
6. validates SHA256 if sidecar exists,
7. runs `hello_world.it` smoke test.

Useful options:

- `-InstallDir "D:\Tools\Interton\bin"`
- `-SkipShaCheck`
- `-SkipHelloSmoke`
- `-RegisterIt` (associates `.it` files with Interton and sets file icon)

Icon note:

1. shipped `interton.ico` is multi-size (`16/24/32/40/48/64/96/128/256`),
2. this keeps Explorer scaling consistent across UI zoom levels.

Installer status messages (console):

- `[status] CHECK_FAILED | ...` - validation failed (for example SHA/hello smoke),
- `[status] CHECK_SKIPPED | ...` - check skipped by flag,
- `[status] INSTALL_SUCCESS | ...` - installation completed successfully,
- `[status] INSTALL_PROBLEM | ...` - critical installation/environment failure.

### 3.3 Windows manual fallback

Use only if MSI/loader are not available.

1. Download release archive.
2. Extract `intertonc.exe` to `C:\Interton\bin`.
3. Add `C:\Interton\bin` to user `PATH`.
4. Restart terminal.

Validation:

```powershell
intertonc --version
intertonc --help
```

Expected output (sample):

```text
Interton compiler beta-v_.6.2
Usage: interton_compiler [options] <file1> [file2 ...]
```

### 3.4 Linux/macOS

Automated path (recommended):

```bash
bash scripts/install_interton.sh --yes
```

The loader automatically:

1. resolves a matching release asset for your OS/arch,
2. downloads package/archive,
3. verifies SHA256 (if `.sha256` exists),
4. installs `intertonc`,
5. runs hello-world smoke.

Loader status notifications (console):

- `[status] CHECK_FAILED | ...` - a verification step failed (for example SHA256).
- `[status] INSTALL_SUCCESS | ...` - installation finished successfully.
- `[status] INSTALL_PROBLEM | ...` - installation/environment problem occurred; check logs and rerun.

Manual fallback (if you need full control):

1. Download release archive.
2. Place `intertonc` in a directory included in `PATH`.
3. Mark as executable.

```bash
chmod +x /path/to/intertonc
intertonc --version
intertonc --help
```

## 4. First run

Create `hello_world.it`:

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

Run:

```bash
intertonc --run hello_world.it
```

Expected output:

```text
Hello, Interton
```

## 5. Compiled pipeline smoke

```bash
intertonc --run-compiled hello_world.it
```

Expected output:

```text
Hello, Interton
```

## 6. SHA256 verification (manual)

```powershell
Get-FileHash -Algorithm SHA256 .\intertonc.exe
```

Expected result: hash must match release `.sha256` file.

## 7. Ready-state checklist

1. `intertonc --version` works.
2. `intertonc --help` works.
3. hello world works in `--run`.
4. hello world works in `--run-compiled`.
5. binary path is stable in `PATH`.

## 8. Next docs

1. `01-language-basics.md`
2. `02-operators.md`
3. `03-functions-procedures-lambdas.md`
4. `04-classes-oop.md`
5. `05-modules-libraries.md`
6. `06-ffi.md`
7. `07-metadata-toning-tunnel-refocus.md`
8. `08-quantum-interference-ray.md`
9. `09-cli-run-modes.md`
10. `10-faq.md`
11. `11-standard-library-reference.md`
12. `12-mermaid-guide.md`


