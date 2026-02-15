# Interton CLI: run and build modes

Target version: `Interton beta-v_.6.2`

## 1. CLI validation

```bash
intertonc --version
intertonc --help
```

Expected output (sample):

```text
Interton compiler beta-v_.6.2
Usage: interton_compiler [options] <file1> [file2 ...]
```

## 2. Main modes

- `--run` (default execution mode)
- `--run-compiled` (compile and run)
- `--assemble` (emit executable)
- `--emit-llvm` (emit `.ll`)
- `--emit-obj` (emit object file)
- `--emit-exe` (emit executable)
- `-o <path>` (output path)

## 3. Practical commands

### 3.1 Run mode

```bash
intertonc --run hello_world.it
```

Expected output:

```text
Hello, Interton
```

### 3.2 Compiled run

```bash
intertonc --run-compiled hello_world.it
```

Expected output:

```text
Hello, Interton
```

### 3.3 Emit LLVM

```bash
intertonc --emit-llvm src/main.it -o output/main.ll
```

Expected result: `output/main.ll` exists.

### 3.4 Emit object

```bash
intertonc --emit-obj src/main.it -o output/main.obj
```

Expected result: `output/main.obj` exists.

### 3.5 Emit executable

```bash
intertonc --emit-exe src/main.it -o output/main.exe
```

Expected result: `output/main.exe` exists.

## 4. Mode selection guidance

1. use `--run` for daily feedback,
2. use `--run-compiled` for release-path verification,
3. use `--emit-*` for CI artifacts and explicit packaging flows.

## 5. Release-first user flow

Install from releases:

`https://github.com/5c0uT/Interton/releases`

Windows automation:

```powershell
pwsh scripts/install_interton.ps1
```

Installer workflow includes path setup, hash verification, and hello-world smoke.

## 6. Minimal `.it` smoke file

```interton
adding std.io

call main() -> int {
    inscribe("CLI smoke ok")
    return 0
}
```

Run:

```bash
intertonc --run smoke.it
```

Expected output:

```text
CLI smoke ok
```


