#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  publish-github-pages.sh <repo-path-or-url> [branch]

Examples:
  publish-github-pages.sh /path/to/coolxincool2026.github.io
  publish-github-pages.sh https://github.com/coolxincool2026/coolxincool2026.github.io.git
  publish-github-pages.sh git@github.com:coolxincool2026/coolxincool2026.github.io.git main

Behavior:
  1. Sync the site source into ./dist
  2. Copy dist contents into the target GitHub Pages repo root
  3. Commit and push if there are changes
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

TARGET="${1}"
BRANCH="${2:-main}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SITE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST_DIR="$SITE_DIR/dist"
TMP_REPO=""

cleanup() {
  if [[ -n "$TMP_REPO" && -d "$TMP_REPO" ]]; then
    rm -rf "$TMP_REPO"
  fi
}
trap cleanup EXIT

rsync -a --delete --exclude 'dist' "$SITE_DIR/" "$DIST_DIR/"

if [[ -d "$TARGET/.git" ]]; then
  REPO_DIR="$TARGET"
else
  TMP_REPO="$(mktemp -d /tmp/coolxincool2026-pages.XXXXXX)"
  git clone --branch "$BRANCH" "$TARGET" "$TMP_REPO"
  REPO_DIR="$TMP_REPO"
fi

git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null

rsync -a --delete "$DIST_DIR/" "$REPO_DIR/"

if git -C "$REPO_DIR" diff --quiet && git -C "$REPO_DIR" diff --cached --quiet && [[ -z "$(git -C "$REPO_DIR" status --short)" ]]; then
  echo "No changes to publish."
  exit 0
fi

git -C "$REPO_DIR" add -A
git -C "$REPO_DIR" commit -m "Deploy latest site updates"
git -C "$REPO_DIR" push origin "$BRANCH"

echo "Published to $REPO_DIR on branch $BRANCH"
