# Security Policy

## EN

### Supported Versions

Security fixes are provided on a best-effort basis for the latest published release artifacts.

### Reporting A Vulnerability

Please do not open a public issue for security vulnerabilities.

Preferred reporting channel:

- Use GitHub "Security" tab for this repository and click "Report a vulnerability" (private disclosure).

If that option is not available:

- Contact the repository owner/maintainers via GitHub profile contact.

Include as much of the following as possible:

- Affected version (for example `0.6.2`) and platform (Windows/macOS/Linux, arch).
- Installation method (MSI/PKG/DEB/RPM/TAR or `scripts/install_interton.*`).
- Impact and exploitability assessment.
- Reproduction steps and proof-of-concept (if safe to share).
- Logs/output. Redact secrets and personal data.

### Supply Chain And Artifacts

If you suspect a release artifact or checksum file is compromised:

- Stop using the artifact immediately.
- Do not run suspicious binaries.
- Report via the private channel above.
- Provide the artifact name and the observed SHA256 vs expected `.sha256`.

## RU

### Поддерживаемые версии

Исправления безопасности публикуются по мере возможности для последнего релиза.

### Сообщить об уязвимости

Пожалуйста, не создавайте публичный issue для уязвимостей.

Предпочтительный канал:

- Вкладка GitHub "Security" в этом репозитории, кнопка "Report a vulnerability" (приватно).

Если приватный репорт недоступен:

- Свяжитесь с владельцем/мейнтейнерами через контакт в GitHub профиле.

Что приложить:

- Версия (например `0.6.2`), ОС/архитектура.
- Способ установки (MSI/PKG/DEB/RPM/TAR или `scripts/install_interton.*`).
- Влияние и сценарий эксплуатации.
- Шаги воспроизведения и PoC (если безопасно).
- Логи/вывод (без секретов и персональных данных).

### Артефакты и supply chain

Если есть подозрение на подмену артефакта/хешей:

- Немедленно прекратите использование.
- Не запускайте подозрительные бинарники.
- Сообщите приватно.
- Укажите имя файла и расхождение SHA256 с `.sha256`.

