#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_DOMAIN="https://coolxincool2026.github.io"
DEFAULT_KEY_FILE="$ROOT_DIR/e634e3d6-7cdb-4d6a-99b7-bd32bf291f91.txt"
INDEXNOW_ENDPOINT="${INDEXNOW_ENDPOINT:-https://api.indexnow.org/indexnow}"
DOMAIN="${INDEXNOW_DOMAIN:-$DEFAULT_DOMAIN}"
KEY_FILE="${INDEXNOW_KEY_FILE:-$DEFAULT_KEY_FILE}"
KEY="${INDEXNOW_KEY:-$(basename "$KEY_FILE" .txt)}"

usage() {
  cat <<'EOF'
Usage:
  submit-indexnow.sh [url1 url2 ...]

Behavior:
  - If URLs are provided, submit those URLs.
  - If no URLs are provided, submit every URL listed in ../sitemap.xml.

Environment variables:
  INDEXNOW_DOMAIN      Override the canonical host, default https://coolxincool2026.github.io
  INDEXNOW_KEY_FILE    Override the key file path
  INDEXNOW_KEY         Override the key value
  INDEXNOW_ENDPOINT    Override the endpoint, default https://api.indexnow.org/indexnow

Important:
  Submit only after the same URLs and key file are already deployed publicly.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ ! -f "$KEY_FILE" ]]; then
  echo "IndexNow key file not found: $KEY_FILE" >&2
  exit 1
fi

if [[ $# -gt 0 ]]; then
  URLS=("$@")
else
  URLS=()
  while IFS= read -r url; do
    [[ -n "$url" ]] && URLS+=("$url")
  done < <(
    python3 - <<'PY' "$ROOT_DIR/sitemap.xml"
import sys
import xml.etree.ElementTree as ET

tree = ET.parse(sys.argv[1])
root = tree.getroot()
ns = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
for url in root.findall("sm:url", ns):
    loc = url.find("sm:loc", ns)
    if loc is not None and loc.text:
        print(loc.text.strip())
PY
  )
fi

if [[ ${#URLS[@]} -eq 0 ]]; then
  echo "No URLs to submit." >&2
  exit 1
fi

PAYLOAD="$(
  python3 - <<'PY' "$DOMAIN" "$KEY" "$KEY_FILE" "${URLS[@]}"
import json
import os
import sys
from pathlib import Path

domain = sys.argv[1]
key = sys.argv[2]
key_file = Path(sys.argv[3]).name
urls = sys.argv[4:]

payload = {
    "host": domain.replace("https://", "").replace("http://", ""),
    "key": key,
    "keyLocation": f"{domain}/{key_file}",
    "urlList": urls,
}

print(json.dumps(payload, ensure_ascii=False))
PY
)"

curl -fsS \
  --connect-timeout 10 \
  --max-time 30 \
  -H "Content-Type: application/json; charset=utf-8" \
  --data "$PAYLOAD" \
  "$INDEXNOW_ENDPOINT" >/dev/null

echo "Submitted ${#URLS[@]} URLs to IndexNow via $INDEXNOW_ENDPOINT"
