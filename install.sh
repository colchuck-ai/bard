#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="colchuck-ai/bard"
REPO_URL="https://github.com/$REPO_SLUG.git"
# BARD_RELEASES_URL lets tests point downloads at a local mirror.
RELEASES="${BARD_RELEASES_URL:-https://github.com/$REPO_SLUG/releases}"
ASSET="bard.tar.gz"

AGENT="claude"
SCOPE="global"
REF=""
DEST=""
DRY_RUN=0

usage() {
  cat <<'EOF'
Install the bard Agent Skill.

Usage: install.sh [--agent <name>] [--project] [--ref <tag|branch>] [--dry-run] [DIR]

Options:
  --agent <name>   Which agent to install for (default: claude):
                     name       global path                    --project path
                     claude     ~/.claude/skills/bard          .claude/skills/bard
                     cursor     ~/.cursor/skills/bard          .agents/skills/bard
                     codex      ~/.agents/skills/bard          .agents/skills/bard
                     gemini     ~/.gemini/skills/bard          .agents/skills/bard
                     copilot    ~/.copilot/skills/bard         .agents/skills/bard
                     opencode   ~/.config/opencode/skills/bard .agents/skills/bard
                     windsurf   ~/.codeium/windsurf/skills/bard .windsurf/skills/bard
                     goose      ~/.config/goose/skills/bard    .goose/skills/bard
                     amp        ~/.config/agents/skills/bard   .agents/skills/bard
                     agents     ~/.agents/skills/bard          .agents/skills/bard
                   (claude-code, gemini-cli and github-copilot are accepted too.)
  --project        Install into the current project instead of your home directory.
  --ref <ref>      What to install:
                     (none)     the latest release (or this checkout, if run from one)
                     v1.2.3     that release, checksum-verified
                     main       a branch, cloned with git
  --dry-run        Print what would be installed where, and change nothing.
  -h, --help       Show this help.

Arguments:
  DIR              Install directly into DIR, overriding --agent and --project.

Examples:
  install.sh                                  # latest release, ~/.claude/skills/bard
  install.sh --agent cursor                   # ~/.cursor/skills/bard
  install.sh --agent claude --project         # ./.claude/skills/bard
  install.sh --ref v0.1.0                     # pin a release
  install.sh ~/.config/my-agent/skills/bard   # custom directory

When piping from curl, pass options after `-s --`:
  curl -fsSL https://raw.githubusercontent.com/colchuck-ai/bard/main/install.sh | bash -s -- --agent cursor

For agents not listed here, `npx skills add` covers many more (see README).
EOF
}

die() { echo "install.sh: $*" >&2; exit 1; }

need_value() { [ $# -ge 2 ] || die "$1 needs a value (see --help)"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --agent) need_value "$@"; AGENT="$2"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    --ref) need_value "$@"; REF="$2"; shift 2 ;;
    --ref=*) REF="${1#*=}"; shift ;;
    --project) SCOPE="project"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *)
      [ -z "$DEST" ] || die "only one DIR may be given"
      DEST="$1"; shift ;;
  esac
done

# A directory may also follow `--`.
if [ $# -gt 0 ]; then
  { [ -z "$DEST" ] && [ $# -eq 1 ]; } || die "only one DIR may be given"
  DEST="$1"
fi

# Resolve the destination from the agent when no explicit directory is given.
# Paths match the `npx skills` CLI, so both installers put bard in the same place.
if [ -z "$DEST" ]; then
  case "$AGENT" in
    claude|claude-code)  g="$HOME/.claude/skills";          p=".claude/skills" ;;
    cursor)              g="$HOME/.cursor/skills";          p=".agents/skills" ;;
    codex|agents)        g="$HOME/.agents/skills";          p=".agents/skills" ;;
    gemini|gemini-cli)   g="$HOME/.gemini/skills";          p=".agents/skills" ;;
    copilot|github-copilot) g="$HOME/.copilot/skills";      p=".agents/skills" ;;
    opencode)            g="$HOME/.config/opencode/skills"; p=".agents/skills" ;;
    windsurf)            g="$HOME/.codeium/windsurf/skills"; p=".windsurf/skills" ;;
    goose)               g="$HOME/.config/goose/skills";    p=".goose/skills" ;;
    amp)                 g="$HOME/.config/agents/skills";   p=".agents/skills" ;;
    *) echo "Unknown agent: $AGENT" >&2; usage >&2; exit 1 ;;
  esac
  if [ "$SCOPE" = "project" ]; then DEST="$PWD/$p/bard"; else DEST="$g/bard"; fi
fi

# Refuse to delete anything that isn't empty or an existing bard install.
if [ -e "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ]; then
  if ! grep -qs '^name: bard$' "$DEST/SKILL.md"; then
    die "refusing to overwrite $DEST: it is not empty and has no bard SKILL.md. Pass an empty directory or an existing bard install."
  fi
fi
# Never delete a source checkout or follow a symlink into one.
[ ! -L "$DEST" ] || die "refusing to install over a symlink ($DEST). Remove the link or pass its target explicitly."
if [ -e "$DEST/.git" ] || [ -d "$DEST/evals" ]; then
  die "refusing to overwrite $DEST: it looks like a source checkout, not an install."
fi

# Pick the source. A local checkout is used only when run from one with no --ref.
# (When piped from curl there is no script file, so there is no checkout.)
SCRIPT_DIR=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fi
if [ -z "$REF" ] && [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/skills/bard/SKILL.md" ]; then
  MODE="local";   WHAT="this checkout ($SCRIPT_DIR)"
elif [ -z "$REF" ]; then
  MODE="release"; WHAT="the latest release"; URL_BASE="$RELEASES/latest/download"
elif printf '%s' "$REF" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+'; then
  MODE="release"; WHAT="release $REF"; URL_BASE="$RELEASES/download/$REF"
else
  MODE="branch";  WHAT="branch $REF"
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Would install bard from $WHAT into $DEST"
  exit 0
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fetch() { # url dest
  if command -v curl >/dev/null 2>&1; then curl -fsSL -o "$2" "$1"
  elif command -v wget >/dev/null 2>&1; then wget -qO "$2" "$1"
  else die "need curl or wget to download a release"; fi
}
sha256_of() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | awk '{print $1}'
  else die "need sha256sum or shasum to verify the download"; fi
}

case "$MODE" in
  local)
    SKILL_SRC="$SCRIPT_DIR/skills/bard"; LICENSE_SRC="$SCRIPT_DIR/LICENSE"
    # Don't install into (or over) the checkout we're copying from.
    mkdir -p "$(dirname "$DEST")"
    DEST="$(cd "$(dirname "$DEST")" && pwd -P)/$(basename "$DEST")"
    case "$DEST/" in "$SCRIPT_DIR/"*) die "refusing to install into the source checkout ($DEST)" ;; esac
    case "$SCRIPT_DIR/" in "$DEST/"*) die "refusing to install over a directory containing the source ($DEST)" ;; esac
    ;;
  release)
    fetch "$URL_BASE/$ASSET" "$TMP/$ASSET" \
      || die "could not download $ASSET from $WHAT. If no release exists yet, try --ref main."
    fetch "$URL_BASE/checksums.txt" "$TMP/checksums.txt" || die "could not download checksums.txt from $WHAT"
    want="$(awk -v f="$ASSET" '$2 == f {print $1}' "$TMP/checksums.txt")"
    [ -n "$want" ] || die "checksums.txt has no entry for $ASSET"
    [ "$(sha256_of "$TMP/$ASSET")" = "$want" ] || die "checksum mismatch for $ASSET; the download is corrupt or tampered with. Nothing was installed."
    tar -xzf "$TMP/$ASSET" -C "$TMP"
    SKILL_SRC="$TMP/bard"; LICENSE_SRC="$TMP/bard/LICENSE"
    ;;
  branch)
    git clone --quiet --depth 1 --branch "$REF" "$REPO_URL" "$TMP/repo" || die "could not clone branch $REF"
    SKILL_SRC="$TMP/repo/skills/bard"; LICENSE_SRC="$TMP/repo/LICENSE"
    ;;
esac
[ -f "$SKILL_SRC/SKILL.md" ] || die "source has no SKILL.md ($SKILL_SRC)"

rm -rf "$DEST"
mkdir -p "$DEST"
# "/." copies the directory's contents (a trailing "/" alone nests it on GNU cp).
cp -R "$SKILL_SRC/." "$DEST/"
rm -rf "$DEST/evals"   # evals are for development, not needed at runtime
[ -f "$DEST/LICENSE" ] || cp "$LICENSE_SRC" "$DEST/"
[ -f "$DEST/SKILL.md" ] || die "install failed: $DEST/SKILL.md missing"

echo "Installed bard from $WHAT to $DEST"
