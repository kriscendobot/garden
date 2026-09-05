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

# Regression: npm projects must not need an agent-created `yarn` compatibility
# shim. The packageManager declaration wins and npm receives its required `--`
# separator when the driver appends --fix to a plain lint script.
git -C "$REPOSITORY" reset -q --hard HEAD
git -C "$REPOSITORY" clean -qfd
printf '%s\n' \
  '{"packageManager":"npm@10.8.2","scripts":{"format":"x","lint-fix":"x","typecheck":"x"}}' \
  >"$REPOSITORY/package.json"
git -C "$REPOSITORY" add package.json
FAKE_BIN="$TEMPORARY_DIRECTORY/npm-bin"
mkdir -p "$FAKE_BIN"
cat >"$FAKE_BIN/npm" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >>"$FAKE_NPM_LOG"
EOF
cat >"$FAKE_BIN/yarn" <<'EOF'
#!/bin/bash
echo "yarn must not run for an npm project" >&2
exit 99
EOF
chmod +x "$FAKE_BIN/npm" "$FAKE_BIN/yarn"
export FAKE_NPM_LOG="$TEMPORARY_DIRECTORY/npm.log"
output=$(GARDEN_PACKAGE_RUNNER="bash $FAKE_BIN/npm" "$DRIVER" --summary "$REPOSITORY") || {
  echo "not ok - driver rejected a declared npm project"
  printf '%s\n' "$output"
  exit 1
}
if ! { grep -Fxq 'run format' "$FAKE_NPM_LOG" \
  && grep -Fxq 'run lint-fix' "$FAKE_NPM_LOG" \
  && grep -Fxq 'run typecheck' "$FAKE_NPM_LOG"; }; then
    echo "not ok - driver did not run every project stage with npm"
    cat "$FAKE_NPM_LOG"
    exit 1
fi
printf '%s\n' "$output" | grep -Fq 'npm typecheck' || {
  echo "not ok - summary did not name the selected npm runner"
  exit 1
}

printf '%s\n' \
  '{"packageManager":"npm@10.8.2","scripts":{"lint":"x"}}' \
  >"$REPOSITORY/package.json"
rm -f "$FAKE_NPM_LOG"
GARDEN_PACKAGE_RUNNER="bash $FAKE_BIN/npm" "$DRIVER" "$REPOSITORY" || {
  echo "not ok - driver rejected npm lint argument forwarding"
  exit 1
}
grep -Fxq 'run lint -- --fix' "$FAKE_NPM_LOG" || {
  echo "not ok - driver did not use npm's separator for lint --fix"
  cat "$FAKE_NPM_LOG"
  exit 1
}
echo "ok - packageManager selects npm for format, lint-fix, lint, and typecheck"

# Regression (endojs/endo-but-for-bots#1014): a file whose `spell-out-exempt`
# marker sits in the first five lines must stay exempt even when the file is far
# longer than the head window. The old exemption check piped the whole file
# through `printf ... | head -5 | grep -q`; under `pipefail` a file past the
# pipe buffer makes `printf` take a SIGPIPE (exit 141) once `head` closes its
# read end, so the pipeline reports failure even though `grep -q` matched — and
# the marker is silently voided on exactly the large files most likely to need
# it. This file exceeds the 64 KiB pipe buffer and carries an abbreviated
# identifier (`pendingIdx`), so a voided exemption would fail the probe.
git -C "$REPOSITORY" reset -q --hard HEAD
git -C "$REPOSITORY" clean -qfd
{
  printf '%s\n' '// spell-out-exempt'
  printf '%s\n' 'const pendingIdx = 0;'
  for i in $(seq 1 5000); do printf 'const filler%d = %d;\n' "$i" "$i"; done
} >"$REPOSITORY/exempt-long.js"
git -C "$REPOSITORY" add exempt-long.js
output=$($DRIVER --no-auto-fix --probes-only --summary "$REPOSITORY") || {
  echo "not ok - long spell-out-exempt file was rejected (head|grep SIGPIPE regression)"
  exit 1
}
printf '%s\n' "$output" | grep -Fq 'result: pass' || {
  echo "not ok - long spell-out-exempt file did not pass cleanly"
  exit 1
}
echo "ok - a long spell-out-exempt file stays exempt under pipefail"
git -C "$REPOSITORY" reset -q --hard HEAD
git -C "$REPOSITORY" clean -qfd
