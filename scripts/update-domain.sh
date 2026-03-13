#!/bin/zsh

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 https://your-domain.example"
  exit 1
fi

NEW_DOMAIN="${1%/}"
OLD_DOMAINS=(
  "https://zhangzhaoxin-lawyer-20260310.surge.sh"
  "https://coolxincool2026.github.io"
)

case "$NEW_DOMAIN" in
  http://*|https://*)
    ;;
  *)
    echo "Domain must include http:// or https://"
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SITE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

FILES=(
  "$SITE_DIR/index.html"
  "$SITE_DIR/tro-lawyer-shenzhen.html"
  "$SITE_DIR/cross-border-dispute-lawyer-shenzhen.html"
  "$SITE_DIR/cross-border-ecommerce-lawyer-shenzhen.html"
  "$SITE_DIR/sitemap.xml"
  "$SITE_DIR/llms.txt"
  "$SITE_DIR/llms-full.txt"
  "$SITE_DIR/robots.txt"
  "$SITE_DIR/README.md"
)

for file in "${FILES[@]}"; do
  for old_domain in "${OLD_DOMAINS[@]}"; do
    perl -0pi -e "s#\Q$old_domain\E#$NEW_DOMAIN#g" "$file"
  done
done

echo "Updated domain references to: $NEW_DOMAIN"
