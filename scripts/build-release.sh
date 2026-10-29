#!/usr/bin/env bash
# Build the release assets install.sh downloads: dist/bard.tar.gz and dist/checksums.txt.
# The archive holds one top-level bard/ folder: the skill (without evals) plus LICENSE.
# Needs GNU tar (Linux, or gtar on macOS); CI and the release workflow run it on Linux.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
out="$root/dist"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT

rm -rf "$out" && mkdir -p "$out" "$stage/bard"
cp -R "$root/skills/bard/." "$stage/bard/"
rm -rf "$stage/bard/evals"
cp "$root/LICENSE" "$stage/bard/"
# Fixed owner, order and mtime, so the same commit builds the same archive.
tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='1970-01-01' \
  -C "$stage" -cf - bard | gzip -n > "$out/bard.tar.gz"
(cd "$out" && sha256sum bard.tar.gz > checksums.txt)
echo "Built $out/bard.tar.gz"
cat "$out/checksums.txt"
