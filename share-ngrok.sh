#!/usr/bin/env bash
# Expose local site on ngrok free tier (https://….ngrok-free.app)
# One-time setup: https://dashboard.ngrok.com/signup then:
#   ./share-ngrok.sh --setup YOUR_AUTHTOKEN
set -euo pipefail
cd "$(dirname "$0")"
PORT="${1:-8765}"
NGROK=".tools/ngrok"

install_ngrok() {
  mkdir -p .tools
  arch="$(uname -m)"
  case "$arch" in
    arm64) zip="ngrok-v3-stable-darwin-arm64.zip" ;;
    x86_64) zip="ngrok-v3-stable-darwin-amd64.zip" ;;
    *)
      echo "Unsupported arch: $arch. Install ngrok from https://ngrok.com/download"
      exit 1
      ;;
  esac
  echo "Downloading ngrok…"
  curl -fsSL -o .tools/ngrok.zip "https://bin.equinox.io/c/bNyj1mQVY4c/${zip}"
  unzip -o -q .tools/ngrok.zip -d .tools
  chmod +x "$NGROK"
  rm -f .tools/ngrok.zip
}

if [[ "${1:-}" == "--setup" ]]; then
  token="${2:-}"
  if [[ -z "$token" ]]; then
    echo "Usage: ./share-ngrok.sh --setup YOUR_AUTHTOKEN"
    echo "Get token: https://dashboard.ngrok.com/get-started/your-authtoken"
    exit 1
  fi
  [[ -x "$NGROK" ]] || install_ngrok
  "$NGROK" config add-authtoken "$token"
  echo "Authtoken saved. Run: ./share-ngrok.sh"
  exit 0
fi

[[ -x "$NGROK" ]] || install_ngrok

if ! "$NGROK" config check >/dev/null 2>&1; then
  echo "Ngrok needs a free account authtoken (one-time)."
  echo ""
  echo "  1. Sign up: https://dashboard.ngrok.com/signup"
  echo "  2. Copy token: https://dashboard.ngrok.com/get-started/your-authtoken"
  echo "  3. Run:       ./share-ngrok.sh --setup YOUR_AUTHTOKEN"
  echo "  4. Then:      ./share-ngrok.sh"
  echo ""
  echo "Keep python3 -m http.server ${PORT} running in another terminal first."
  exit 1
fi

if ! curl -s -o /dev/null --connect-timeout 2 "http://127.0.0.1:${PORT}/index.html"; then
  echo "No server on port ${PORT}. Start it first:"
  echo "  python3 -m http.server ${PORT}"
  exit 1
fi

echo "Starting ngrok → http://127.0.0.1:${PORT}"
echo "Public URL will appear below (share …/index.html with colleagues)."
echo "Inspector: http://127.0.0.1:4040"
echo ""
exec "$NGROK" http "$PORT"
