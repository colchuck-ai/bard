#!/usr/bin/env bash
# Check that skills/bard/SKILL.md's metadata.version matches a release tag.
# Usage: scripts/check-version.sh v1.2.3
set -euo pipefail
tag="${1:?usage: check-version.sh <tag, e.g. v1.2.3>}"
file="$(dirname "$0")/../skills/bard/SKILL.md"
version="$(sed -n 's/^  version: "\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$file" | head -1)"
if [ "v$version" != "$tag" ]; then
  echo "Tag $tag does not match metadata.version \"$version\" in skills/bard/SKILL.md." >&2
  echo "Bump the version in SKILL.md, commit, and tag that commit." >&2
  exit 1
fi
echo "Version $version matches tag $tag"
