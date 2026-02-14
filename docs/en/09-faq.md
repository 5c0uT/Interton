# Interton FAQ (EN)

Target version: `Interton beta-v_.6.1`

## 1. `intertonc` is not found

Run:

1. `intertonc --version`
2. `intertonc --help`
3. `where intertonc` (Windows) or `which intertonc` (Linux/macOS)

If command is missing, this is usually a PATH issue.

## 2. How do I confirm the correct version?

```bash
intertonc --version
```

Expected version marker includes `beta-v_.6.1`.

## 3. Should I use `--run` or `--run-compiled`?

- `--run` for fast daily iteration.
- `--run-compiled` for compiled release-path validation.

## 4. We built MSI installers, right?

Yes. Windows release packaging includes MSI artifacts (for example `intertonc-<release>.msi`) generated in the packaging pipeline.

## 5. FFI fails unexpectedly

Common reasons:

1. type mismatch,
2. missing external runtime,
3. environment/version mismatch across machines,
4. invalid input crossing language boundary.

## 6. How to do a minimal post-install smoke

```interton
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
```

And run:

```bash
intertonc --help
intertonc --run hello_world.it
intertonc --run-compiled hello_world.it
```

Expected output from hello run:

```text
Hello, Interton
```

## 7. Where are official installers?

`https://github.com/5c0uT/Interton/releases`

## 8. How does Windows automated installer work?

```powershell
pwsh scripts/install_interton.ps1
```

It creates install directory, updates PATH, validates SHA256, and executes hello-world smoke.

## 9. Can Linux/macOS installation be automated with a loader?

Yes. Use:

```bash
bash scripts/install_interton.sh --yes
```

or:

```bash
curl -fsSL https://raw.githubusercontent.com/5c0uT/Interton/main/scripts/install_interton.sh | bash -s -- --yes
```

The loader resolves the matching release asset, downloads it, verifies SHA256 (when available), and runs smoke.

## 10. Where are compiler internals documented?

`../../developers/`

## 11. Why did `.it` file icons not update after install?

Most often this is Windows icon cache behavior.

Verify:

1. `.it` is mapped to `IntertonFile`,
2. `DefaultIcon` points to current `interton.ico`,
3. open-command points to current `intertonc.exe`.

Refresh icon cache:

```powershell
ie4uinit.exe -show
ie4uinit.exe -ClearIconCache
```

Re-apply association if needed:

```powershell
pwsh scripts/install_interton.ps1 -RegisterIt -SkipShaCheck -SkipHelloSmoke
```

## 12. What metadata is expected in Windows artifacts?

For `intertonc.exe`:

1. `FileDescription`,
2. `FileVersion`,
3. `ProductName`,
4. `ProductVersion` (`beta-v_.6.1`),
5. `CompanyName`,
6. copyright.

For MSI:

1. `ARPCOMMENTS`,
2. `ARPCONTACT`,
3. `ARPURLINFOABOUT`,
4. `ARPHELPLINK`,
5. `ARPPRODUCTICON`.

