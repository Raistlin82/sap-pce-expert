#!/usr/bin/env bash
# Build the Claude cowork / desktop ".skill" bundle from the plugin skill sources.
#
# The Claude Code form of this project is the plugin (this repo, installed via the
# marketplace). The cowork / desktop form is a ".skill" file: a zip whose top-level
# folder is the skill name, containing SKILL.md + references/ (NO README, NO tests).
#
# Output: dist/sap-pce-expert.skill  (gitignored build artifact)
# Usage:  ./build-skill.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILL_NAME="sap-pce-expert"
SRC="$ROOT/skills/$SKILL_NAME"
DIST="$ROOT/dist"
OUT="$DIST/$SKILL_NAME.skill"

# --- 1. Version consistency check (plugin.json / marketplace.json / SKILL.md) ---
V_PLUGIN=$(python3 -c "import json;print(json.load(open('$ROOT/.claude-plugin/plugin.json'))['version'])")
V_MARKET=$(python3 -c "import json;print(json.load(open('$ROOT/.claude-plugin/marketplace.json'))['plugins'][0]['version'])")
V_SKILL=$(python3 -c "import re;m=re.search(r'^\s*version:\s*\"?([0-9.]+)',open('$SRC/SKILL.md').read(),re.M);print(m.group(1))")
if [ "$V_PLUGIN" != "$V_MARKET" ] || [ "$V_PLUGIN" != "$V_SKILL" ]; then
  echo "ERROR: version mismatch — plugin.json=$V_PLUGIN marketplace.json=$V_MARKET SKILL.md=$V_SKILL" >&2
  exit 1
fi
echo "Version: $V_PLUGIN (consistent across plugin.json, marketplace.json, SKILL.md)"

# --- 2. SKILL.md frontmatter description must be <= 1024 chars (.skill constraint) ---
python3 - "$SRC/SKILL.md" <<'PY'
import re,sys
t=open(sys.argv[1]).read()
m=re.search(r'(?s)^description:\s*\|\n(.*?)\n[A-Za-z_]+:',t,re.M)
if not m:
    print("ERROR: could not parse SKILL.md description",file=sys.stderr); sys.exit(1)
n=len(m.group(1))
print(f"SKILL.md description: {n} chars", "OK" if n<=1024 else "-> EXCEEDS 1024")
sys.exit(0 if n<=1024 else 1)
PY

# --- 3. Stage a clean copy: <name>/SKILL.md + <name>/references/ only ---
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$SKILL_NAME"
cp "$SRC/SKILL.md" "$STAGE/$SKILL_NAME/SKILL.md"
cp -R "$SRC/references" "$STAGE/$SKILL_NAME/references"
# strip junk (do not ship README, tests, or OS cruft)
find "$STAGE" -name '.DS_Store' -delete
find "$STAGE" -name 'retrieval-tests.md' -delete

# --- 4. Zip to dist/<name>.skill ---
mkdir -p "$DIST"
rm -f "$OUT"
( cd "$STAGE" && zip -rq "$OUT" "$SKILL_NAME" )

# --- 5. Report ---
echo ""
echo "Built: $OUT"
unzip -l "$OUT"
