#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/colchuck-ai/bard.git"
BRANCH="main"
AGENT="cursor"
DEST=""

usage() {
  cat <<'EOF'
Install the bard Agent Skill.

Usage: install.sh [--agent <name>] [DIR]

Options:
  --agent <name>   Install into a known agent's skills directory:
                     cursor   ~/.cursor/skills/bard   (default)
                     claude   ~/.claude/skills/bard
                     agents   ~/.agents/skills/bard
  -h, --help       Show this help.

Arguments:
  DIR              Install directly into DIR, overriding --agent.

Examples:
  install.sh                                              # ~/.cursor/skills/bard
  install.sh --agent claude                               # ~/.claude/skills/bard
  install.sh ~/.config/my-agent/skills/bard               # custom directory

When piping from curl, pass options after `-s --`:
  curl -fsSL <url>/install.sh | bash -s -- --agent claude
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --agent)
      if [ $# -lt 2 ]; then echo "--agent needs a value (cursor, claude, agents)" >&2; exit 1; fi
      AGENT="$2"; shift 2 ;;
    --agent=*) AGENT="${1#*=}"; shift ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *)
      if [ -n "$DEST" ]; then echo "Only one DIR may be given" >&2; usage >&2; exit 1; fi
      DEST="$1"; shift ;;
  esac
done

# A directory may also follow `--`.
if [ $# -gt 0 ]; then
  if [ -n "$DEST" ] || [ $# -gt 1 ]; then echo "Only one DIR may be given" >&2; usage >&2; exit 1; fi
  DEST="$1"
fi

# Resolve the destination from the agent when no explicit directory is given.
if [ -z "$DEST" ]; then
  case "$AGENT" in
    cursor) DEST="$HOME/.cursor/skills/bard" ;;
    claude) DEST="$HOME/.claude/skills/bard" ;;
    agents) DEST="$HOME/.agents/skills/bard" ;;
    *) echo "Unknown agent: $AGENT" >&2; usage >&2; exit 1 ;;
  esac
fi

# Refuse to delete anything that isn't empty or an existing bard install.
if [ -e "$DEST" ] && [ -n "$(ls -A "$DEST" 2>/dev/null)" ]; then
  if ! grep -qs '^name: bard$' "$DEST/SKILL.md"; then
    echo "Refusing to overwrite $DEST: it is not empty and has no bard SKILL.md." >&2
    echo "Pass an empty directory or an existing bard install." >&2
    exit 1
  fi
fi

# Install from this checkout when run inside one; otherwise clone the repo.
# (When piped from curl there is no script file, so always clone.)
SCRIPT_DIR=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
fi
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/bard/SKILL.md" ]; then
  SRC="$SCRIPT_DIR"
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  git clone --depth 1 --branch "$BRANCH" "$REPO" "$TMP/bard"
  SRC="$TMP/bard"
fi

# Never delete a source checkout or follow a symlink into one.
if [ -L "$DEST" ]; then
  echo "Refusing to install over a symlink ($DEST). Remove the link or pass its target explicitly." >&2
  exit 1
fi
if [ -e "$DEST/.git" ] || [ -d "$DEST/evals" ]; then
  echo "Refusing to overwrite $DEST: it looks like a source checkout, not an install." >&2
  exit 1
fi
mkdir -p "$(dirname "$DEST")"
DEST="$(cd "$(dirname "$DEST")" && pwd -P)/$(basename "$DEST")"
case "$DEST/" in "$SRC/"*) echo "Refusing to install into the source checkout ($DEST)" >&2; exit 1 ;; esac
case "$SRC/" in "$DEST/"*) echo "Refusing to install over a directory containing the source ($DEST)" >&2; exit 1 ;; esac

rm -rf "$DEST"
mkdir -p "$DEST"
# "/." copies the directory's contents (a trailing "/" alone nests it on GNU cp).
cp -R "$SRC/bard/." "$DEST/"
rm -rf "$DEST/evals"   # evals are for development, not needed at runtime
cp "$SRC/LICENSE" "$DEST/"
[ -f "$DEST/SKILL.md" ] || { echo "Install failed: $DEST/SKILL.md missing" >&2; exit 1; }

echo "Installed bard skill to $DEST"
