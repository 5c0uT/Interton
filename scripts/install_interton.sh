#!/usr/bin/env bash
set -Eeuo pipefail

REPO="5c0uT/Interton"
VERSION="0.6.2"
PREFIX="/usr/local"
MODE="auto"
ASSET_URL=""
ASSET_FILE=""
SKIP_SHA_CHECK=0
SKIP_HELLO_SMOKE=0
ASSUME_YES=0

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
version_file="$repo_root/release/version.env"
if [[ -f "$version_file" ]]; then
  parsed_version="$(grep -E '^INTERTON_PRODUCT_VERSION=' "$version_file" | head -n1 | cut -d'=' -f2- || true)"
  if [[ -n "$parsed_version" ]]; then
    VERSION="$parsed_version"
  fi
fi

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install_interton.sh [options]

Options:
  --version <X.Y.Z>      Release version hint (default: 0.6.2)
  --repo <owner/name>    GitHub repository (default: 5c0uT/Interton)
  --prefix <path>        Install prefix for tarball install (default: /usr/local)
  --mode <auto|tar|deb|rpm|pkg>
                         Preferred installer type (default: auto)
  --asset-url <url>      Direct URL to installer asset (skip GitHub asset resolution)
  --asset-file <path>    Local installer asset path (skip download)
  --skip-sha-check       Skip SHA256 verification
  --skip-hello-smoke     Skip hello_world smoke test
  --yes                  Non-interactive mode
  -h, --help             Show this help

Examples:
  bash scripts/install_interton.sh --yes
  bash scripts/install_interton.sh --version 0.6.2 --mode tar --prefix "$HOME/.local" --yes
  bash scripts/install_interton.sh --asset-url "https://.../intertonc-0.6.2-macos-arm64.pkg" --yes
EOF
}

status() { printf "[status] %s | %s\n" "$1" "$2"; }
info() { printf "[info] %s\n" "$*"; }
warn() { printf "[warn] %s\n" "$*" >&2; }
err() {
  local code="${1:-INSTALL_PROBLEM}"
  shift || true
  local message="${1:-Unknown installation error}"
  status "$code" "$message"
  printf "[error] %s\n" "$message" >&2
  exit 1
}

CURRENT_STAGE="initialization"
on_unhandled_error() {
  local exit_code="$1"
  local line_no="$2"
  status "INSTALL_PROBLEM" "Unhandled failure at stage '$CURRENT_STAGE' (line $line_no, exit $exit_code)."
  exit "$exit_code"
}
trap 'on_unhandled_error "$?" "$LINENO"' ERR

have_cmd() { command -v "$1" >/dev/null 2>&1; }

run_as_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
    return
  fi
  if have_cmd sudo; then
    sudo "$@"
    return
  fi
  err "INSTALL_PROBLEM" "Root privileges required for: $* (sudo not found)"
}

run_install_cmd() {
  local target_prefix="$1"
  shift
  if [[ -d "$target_prefix" && -w "$target_prefix" ]]; then
    "$@"
    return
  fi
  if [[ -w "$(dirname "$target_prefix")" ]]; then
    "$@"
    return
  fi
  run_as_root "$@"
}

sha256_upper() {
  local file="$1"
  if have_cmd sha256sum; then
    sha256sum "$file" | awk '{print toupper($1)}'
    return
  fi
  if have_cmd shasum; then
    shasum -a 256 "$file" | awk '{print toupper($1)}'
    return
  fi
  err "CHECK_FAILED" "No SHA256 tool found (sha256sum/shasum)"
}

resolve_asset_url_from_releases() {
  local api_url="$1"
  local version="$2"
  local names_multiline="$3"
  ASSET_NAMES="$names_multiline" python3 - "$api_url" "$version" <<'PY'
import json
import os
import sys
import urllib.request

api_url = sys.argv[1]
version = sys.argv[2]
asset_names = [x.strip() for x in os.environ.get("ASSET_NAMES", "").splitlines() if x.strip()]
if not asset_names:
    print("")
    raise SystemExit(0)

req = urllib.request.Request(
    api_url,
    headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "interton-installer"
    },
)
with urllib.request.urlopen(req, timeout=30) as resp:
    data = json.loads(resp.read().decode("utf-8"))

for rel in data:
    tag_name = (rel.get("tag_name") or "")
    rel_name = (rel.get("name") or "")
    if version and (version not in tag_name and version not in rel_name):
        continue
    assets = rel.get("assets") or []
    asset_map = {a.get("name"): a.get("browser_download_url") for a in assets}
    for wanted in asset_names:
        if wanted in asset_map:
            print(asset_map[wanted])
            raise SystemExit(0)

print("")
PY
}

download_file() {
  local url="$1"
  local out="$2"
  if ! have_cmd curl; then
    err "INSTALL_PROBLEM" "curl is required to download assets"
  fi
  curl -fL --retry 3 --retry-delay 1 "$url" -o "$out"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    --repo) REPO="$2"; shift 2 ;;
    --prefix) PREFIX="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --asset-url) ASSET_URL="$2"; shift 2 ;;
    --asset-file) ASSET_FILE="$2"; shift 2 ;;
    --skip-sha-check) SKIP_SHA_CHECK=1; shift ;;
    --skip-hello-smoke) SKIP_HELLO_SMOKE=1; shift ;;
    --yes) ASSUME_YES=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) err "INSTALL_PROBLEM" "Unknown argument: $1" ;;
  esac
done

if [[ -n "$ASSET_URL" && -n "$ASSET_FILE" ]]; then
  err "INSTALL_PROBLEM" "Use only one of --asset-url or --asset-file"
fi

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
machine="$(uname -m)"

case "$os" in
  linux) ;;
  darwin) ;;
  *) err "INSTALL_PROBLEM" "Unsupported OS: $os (supported: linux, darwin)" ;;
esac

if [[ "$MODE" != "auto" && "$MODE" != "tar" && "$MODE" != "deb" && "$MODE" != "rpm" && "$MODE" != "pkg" ]]; then
  err "INSTALL_PROBLEM" "Unsupported mode: $MODE"
fi

if [[ "$os" == "darwin" && ( "$MODE" == "deb" || "$MODE" == "rpm" ) ]]; then
  err "INSTALL_PROBLEM" "Mode '$MODE' is not valid for macOS"
fi
if [[ "$os" == "linux" && "$MODE" == "pkg" ]]; then
  err "INSTALL_PROBLEM" "Mode 'pkg' is not valid for Linux"
fi

linux_deb_arch="$machine"
case "$machine" in
  x86_64|amd64) linux_deb_arch="amd64" ;;
  aarch64|arm64) linux_deb_arch="arm64" ;;
esac

linux_rpm_arch="$machine"
case "$machine" in
  arm64) linux_rpm_arch="aarch64" ;;
esac

asset_candidates=()
if [[ "$os" == "linux" ]]; then
  if [[ "$MODE" == "auto" ]]; then
    if have_cmd dpkg; then
      asset_candidates+=("intertonc_${VERSION}_${linux_deb_arch}.deb")
    fi
    if have_cmd rpm; then
      asset_candidates+=("intertonc-${VERSION}-1.${linux_rpm_arch}.rpm")
    fi
    asset_candidates+=("intertonc-${VERSION}-linux-${machine}.tar.gz")
  elif [[ "$MODE" == "deb" ]]; then
    asset_candidates+=("intertonc_${VERSION}_${linux_deb_arch}.deb")
  elif [[ "$MODE" == "rpm" ]]; then
    asset_candidates+=("intertonc-${VERSION}-1.${linux_rpm_arch}.rpm")
  else
    asset_candidates+=("intertonc-${VERSION}-linux-${machine}.tar.gz")
  fi
else
  if [[ "$MODE" == "auto" ]]; then
    if have_cmd installer; then
      asset_candidates+=("intertonc-${VERSION}-macos-${machine}.pkg")
    fi
    asset_candidates+=("intertonc-${VERSION}-macos-${machine}.tar.gz")
  elif [[ "$MODE" == "pkg" ]]; then
    asset_candidates+=("intertonc-${VERSION}-macos-${machine}.pkg")
  else
    asset_candidates+=("intertonc-${VERSION}-macos-${machine}.tar.gz")
  fi
fi

api_url="https://api.github.com/repos/${REPO}/releases?per_page=30"
work_dir="$(mktemp -d -t interton_install_XXXXXX)"
trap 'rm -rf "$work_dir"' EXIT

asset_path=""
selected_asset_name=""

if [[ -n "$ASSET_FILE" ]]; then
  CURRENT_STAGE="resolve asset"
  [[ -f "$ASSET_FILE" ]] || err "INSTALL_PROBLEM" "Asset file not found: $ASSET_FILE"
  asset_path="$ASSET_FILE"
  selected_asset_name="$(basename "$asset_path")"
  info "Using local asset file: $asset_path"
else
  if [[ -z "$ASSET_URL" ]]; then
    CURRENT_STAGE="resolve asset"
    names_multiline="$(printf "%s\n" "${asset_candidates[@]}")"
    ASSET_URL="$(resolve_asset_url_from_releases "$api_url" "$VERSION" "$names_multiline")"
    [[ -n "$ASSET_URL" ]] || err "INSTALL_PROBLEM" "No matching release asset found for version '$VERSION' and candidates: ${asset_candidates[*]}"
  fi
  CURRENT_STAGE="download asset"
  selected_asset_name="$(basename "${ASSET_URL%%\?*}")"
  asset_path="$work_dir/$selected_asset_name"
  status "INSTALL_PROGRESS" "Downloading asset: $selected_asset_name"
  info "Downloading asset: $selected_asset_name"
  download_file "$ASSET_URL" "$asset_path"
  status "INSTALL_PROGRESS" "Asset downloaded: $selected_asset_name"
fi

if [[ "$ASSUME_YES" -ne 1 ]]; then
  echo "Install plan:"
  echo "  OS:        $os"
  echo "  Arch:      $machine"
  echo "  Asset:     $selected_asset_name"
  echo "  Prefix:    $PREFIX"
  echo "Continue? [y/N]"
  read -r ans
  case "$ans" in
    y|Y|yes|YES) ;;
    *) status "INSTALL_ABORTED" "Installation cancelled by user."; echo "Aborted."; exit 0 ;;
  esac
fi

if [[ "$SKIP_SHA_CHECK" -ne 1 && -n "$ASSET_URL" ]]; then
  CURRENT_STAGE="verify checksum"
  sha_name="${selected_asset_name}.sha256"
  sha_url="$(resolve_asset_url_from_releases "$api_url" "$VERSION" "$sha_name")"
  if [[ -n "$sha_url" ]]; then
    sha_path="$work_dir/$sha_name"
    status "CHECK_PROGRESS" "Downloading checksum file: $sha_name"
    info "Downloading SHA256 file: $sha_name"
    download_file "$sha_url" "$sha_path"
    expected_sha="$(awk 'NR==1 {print toupper($1)}' "$sha_path")"
    actual_sha="$(sha256_upper "$asset_path")"
    if [[ -z "$expected_sha" ]]; then
      warn "Could not parse SHA256 from $sha_name"
    elif [[ "$expected_sha" != "$actual_sha" ]]; then
      err "CHECK_FAILED" "SHA256 mismatch for asset '$selected_asset_name' (expected $expected_sha, got $actual_sha)"
    else
      status "CHECK_PASSED" "SHA256 verified for '$selected_asset_name'."
      info "SHA256 verified."
    fi
  else
    status "CHECK_SKIPPED" "Checksum file not found for '$selected_asset_name'; verification skipped."
    warn "SHA256 asset not found for $selected_asset_name, skipped verification."
  fi
elif [[ "$SKIP_SHA_CHECK" -eq 1 ]]; then
  status "CHECK_SKIPPED" "Checksum verification skipped by --skip-sha-check."
fi

CURRENT_STAGE="install package"
status "INSTALL_PROGRESS" "Installing asset '$selected_asset_name'."
case "$selected_asset_name" in
  *.deb)
    have_cmd dpkg || err "INSTALL_PROBLEM" "dpkg is required for .deb installation"
    run_as_root dpkg -i "$asset_path"
    ;;
  *.rpm)
    have_cmd rpm || err "INSTALL_PROBLEM" "rpm is required for .rpm installation"
    run_as_root rpm -Uvh --replacepkgs "$asset_path"
    ;;
  *.pkg)
    have_cmd installer || err "INSTALL_PROBLEM" "installer is required for .pkg installation"
    run_as_root installer -pkg "$asset_path" -target /
    ;;
  *.tar.gz)
    extract_dir="$work_dir/extract"
    mkdir -p "$extract_dir"
    tar -xzf "$asset_path" -C "$extract_dir"
    install_script="$extract_dir/install.sh"
    if [[ ! -x "$install_script" ]]; then
      install_script="$(find "$extract_dir" -maxdepth 2 -type f -name install.sh | head -n 1 || true)"
    fi
    [[ -n "$install_script" && -x "$install_script" ]] || err "INSTALL_PROBLEM" "install.sh not found inside tarball"
    run_install_cmd "$PREFIX" "$install_script" "$PREFIX"
    ;;
  *)
    err "INSTALL_PROBLEM" "Unsupported asset type: $selected_asset_name"
    ;;
esac
status "INSTALL_PROGRESS" "Installer completed for '$selected_asset_name'."

installed_bin=""
if have_cmd intertonc; then
  installed_bin="$(command -v intertonc)"
elif [[ -x "$PREFIX/bin/intertonc" ]]; then
  installed_bin="$PREFIX/bin/intertonc"
fi
[[ -n "$installed_bin" ]] || err "INSTALL_PROBLEM" "Installed binary not found. Check PATH or prefix '$PREFIX/bin'."

if [[ ":$PATH:" != *":$PREFIX/bin:"* && "$installed_bin" == "$PREFIX/bin/intertonc" ]]; then
  warn "Path '$PREFIX/bin' is not in PATH. Add it to your shell profile."
  warn "Example: export PATH=\"$PREFIX/bin:\$PATH\""
fi

info "Installed binary: $installed_bin"
"$installed_bin" --version

if [[ "$SKIP_HELLO_SMOKE" -ne 1 ]]; then
  CURRENT_STAGE="hello smoke check"
  smoke_file="$work_dir/hello_world.it"
  cat > "$smoke_file" <<'EOF'
adding std.io

call main() -> int {
    inscribe("Hello, Interton")
    return 0
}
EOF
  info "Running hello_world smoke test..."
  "$installed_bin" --run "$smoke_file"
  status "CHECK_PASSED" "hello_world smoke test passed."
else
  status "CHECK_SKIPPED" "hello_world smoke test skipped by --skip-hello-smoke."
fi

CURRENT_STAGE="done"
status "INSTALL_SUCCESS" "Interton installation finished successfully."
info "Installation completed."
