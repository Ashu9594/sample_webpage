#!/usr/bin/env bash
# Expose your local static server on a temporary public HTTPS URL (no Cloudflare account).
# Prereq: python server already running, e.g.  python3 -m http.server 8765
set -euo pipefail
cd "$(dirname "$0")"
PORT="${1:-8765}"
ROOT="http://127.0.0.1:${PORT}"

CF=".tools/cloudflared"
if [[ ! -x "$CF" ]]; then
  mkdir -p .tools
  arch="$(uname -m)"
  case "$arch" in
    arm64) asset="cloudflared-darwin-arm64.tgz" ;;
    x86_64) asset="cloudflared-darwin-amd64.tgz" ;;
    *)
      echo "Unsupported arch: $arch. Install ngrok from https://ngrok.com/download instead."
      exit 1
      ;;
  esac
  echo "Downloading cloudflared ($asset)…"
  curl -fsSL -o .tools/cloudflared.tgz "https://github.com/cloudflare/cloudflared/releases/latest/download/${asset}"
  tar -xzf .tools/cloudflared.tgz -C .tools
  chmod +x "$CF"
  rm -f .tools/cloudflared.tgz
fi

echo "Starting tunnel → ${ROOT}"
echo "Share this with colleagues (add /index.html if the root shows a file list):"
echo ""
exec "$CF" tunnel --url "$ROOT"
