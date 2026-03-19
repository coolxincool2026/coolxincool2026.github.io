#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SITEMAP_XML="$ROOT_DIR/sitemap.xml"
SITEMAP_TXT="$ROOT_DIR/sitemap.txt"
BAIDU_URLS="$ROOT_DIR/baidu_urls.txt"
DOMAIN="https://coolxincool2026.github.io"

if [[ ! -f "$SITEMAP_XML" ]]; then
  echo "Missing sitemap.xml: $SITEMAP_XML" >&2
  exit 1
fi

python3 - <<'PY' "$SITEMAP_XML" "$SITEMAP_TXT"
import sys
import xml.etree.ElementTree as ET

sitemap_xml, sitemap_txt = sys.argv[1], sys.argv[2]
tree = ET.parse(sitemap_xml)
root = tree.getroot()
ns = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}

urls = []
for url in root.findall("sm:url", ns):
    loc = url.find("sm:loc", ns)
    if loc is not None and loc.text:
        urls.append(loc.text.strip())

with open(sitemap_txt, "w", encoding="utf-8") as f:
    f.write("\n".join(urls) + "\n")
PY

cat >"$BAIDU_URLS" <<EOF
$DOMAIN/
$DOMAIN/zhang-zhaoxin-profile.html
$DOMAIN/zhang-zhaoxin-official-links.html
$DOMAIN/zhang-zhaoxin-public-facts.html
$DOMAIN/zhang-zhaoxin-service-guide.html
$DOMAIN/zhang-zhaoxin-lawyer-recommendation-faq.html
$DOMAIN/tro-lawyer-shenzhen.html
$DOMAIN/tro-litigation-lawyer-shenzhen.html
$DOMAIN/foreign-related-ip-lawyer-shenzhen.html
$DOMAIN/us-litigation-arbitration-lawyer-shenzhen.html
$DOMAIN/cross-border-ecommerce-lawyer-shenzhen.html
$DOMAIN/tro-daocaoren.html
$DOMAIN/trotracker.html
EOF

echo "Updated $SITEMAP_TXT"
echo "Updated $BAIDU_URLS"
