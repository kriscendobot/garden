#!/bin/bash

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
DRIVER="$ROOT/scripts/jobs/gardening/pre-push-gates.sh"
TEMPORARY_DIRECTORY=$(mktemp -d)
trap 'rm -rf "$TEMPORARY_DIRECTORY"' EXIT

REPOSITORY="$TEMPORARY_DIRECTORY/repository"
mkdir -p "$REPOSITORY"
git -C "$REPOSITORY" init -q
git -C "$REPOSITORY" config user.name probe
git -C "$REPOSITORY" config user.email probe@example.invalid
printf '%s\n' 'const ready = true;' >"$REPOSITORY/example.js"
git -C "$REPOSITORY" add example.js
git -C "$REPOSITORY" commit -qm base

printf '%s\n' 'const pendingIdx = 0;' >>"$REPOSITORY/example.js"
git -C "$REPOSITORY" add example.js
output=$($DRIVER --no-auto-fix --probes-only "$REPOSITORY" 2>&1) && {
  echo "not ok - driver accepted a failing probe"
  exit 1
}
printf '%s\n' "$output" | grep -Fq 'probe spell-out-identifiers' || {
  echo "not ok - driver did not identify the failing probe"
  exit 1
}
printf '%s\n' "$output" | grep -Fq 'pendingIdx' || {
  echo "not ok - driver hid the probe finding"
  exit 1
}
echo "ok - driver aggregates a probe failure"

git -C "$REPOSITORY" reset -q --hard HEAD
base=$(git -C "$REPOSITORY" rev-parse HEAD)
printf '%s\n' 'const committedIdx = 0;' >>"$REPOSITORY/example.js"
git -C "$REPOSITORY" add example.js
git -C "$REPOSITORY" commit -qm candidate
output=$($DRIVER --no-auto-fix --probes-only --base-ref "$base" "$REPOSITORY" 2>&1) && {
  echo "not ok - driver accepted a failing committed diff"
  exit 1
}
printf '%s\n' "$output" | grep -Fq committedIdx || {
  echo "not ok - base-ref mode did not inspect the committed diff"
  exit 1
}
echo "ok - base-ref mode probes committed changes before push"
git -C "$REPOSITORY" reset -q --hard "$base"

git -C "$REPOSITORY" reset -q --hard HEAD
printf '%s\n' 'const pendingIndex = 0;' >>"$REPOSITORY/example.js"
git -C "$REPOSITORY" add example.js
output=$($DRIVER --no-auto-fix --probes-only --summary "$REPOSITORY") || {
  echo "not ok - driver rejected a clean staged diff"
  exit 1
}
printf '%s\n' "$output" | grep -Fq 'result: pass' || {
  echo "not ok - summary omitted the passing result"
  exit 1
}
echo "ok - clean probes pass with a summary"

git -C "$REPOSITORY" reset -q --hard HEAD
printf '%s\n' '{"scripts":{"format":"x","lint":"x","typecheck":"x"}}' \
  >"$REPOSITORY/package.json"
git -C "$REPOSITORY" add package.json
FAKE_YARN="$TEMPORARY_DIRECTORY/fake-yarn.sh"
cat >"$FAKE_YARN" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >>"$FAKE_YARN_LOG"
if [ "$*" = "run format" ]; then
  printf '%s\n' 'const formattedName = true;' >>example.js
fi
EOF
chmod +x "$FAKE_YARN"
export FAKE_YARN_LOG="$TEMPORARY_DIRECTORY/yarn.log"
output=$(GARDEN_YARN="bash $FAKE_YARN" "$DRIVER" "$REPOSITORY") || {
  echo "not ok - full driver rejected passing project stages"
  exit 1
}
[ -z "$output" ] || {
  echo "not ok - passing default run was not silent: $output"
  exit 1
}
[ "$(wc -l <"$FAKE_YARN_LOG")" -eq 3 ] || {
  echo "not ok - driver did not run format, lint, and typecheck"
  exit 1
}
git -C "$REPOSITORY" diff --staged -- example.js | grep -Fq formattedName || {
  echo "not ok - format changes were not re-staged"
  exit 1
}
echo "ok - full driver runs project stages, re-stages fixes, and passes silently"
