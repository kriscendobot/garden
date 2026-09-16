#!/bin/bash
# worker-exec-tmpdir-test.sh - regression coverage for the executable TMPDIR
# inherited by every agent launched through handlers/worker-common.sh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# Keep the fixture outside the garden repository and on an exec-capable mount.
# /tmp is deliberately noexec in the production container, so try it only after
# the locations that can host the executable control and fallback probes.
pick_exec_base() {
  local candidate probe rc
  for candidate in "${GARDEN_TEST_TMPDIR:-}" /var/tmp "${TMPDIR:-}" /tmp; do
    [ -n "$candidate" ] || continue
    mkdir -p "$candidate" 2>/dev/null || true
    [ -d "$candidate" ] && [ -w "$candidate" ] || continue
    probe="$(mktemp -d "$candidate/worker-tmp-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 23\n' > "$probe/x"
    chmod +x "$probe/x" 2>/dev/null || true
    set +e; "$probe/x" >/dev/null 2>&1; rc=$?; set -e
    rm -rf "$probe"
    [ "$rc" -eq 23 ] && { printf '%s\n' "$candidate"; return 0; }
  done
  return 1
}

EXEC_BASE="$(pick_exec_base)" || {
  echo "  SKIP: no writable exec-capable location for worker TMPDIR fixture"
  exit 0
}
TR="$(mktemp -d "$EXEC_BASE/worker-exec-tmpdir.XXXXXX")"
trap 'chmod 700 "$TR/noexec" 2>/dev/null || true; rm -rf "$TR"' EXIT
mkdir -p "$TR/noexec" "$TR/scratch"

# Model an unusable/noexec preferred TMPDIR without requiring mount privileges:
# removing search permission makes exec_tmpdir reject it and choose scratch.
chmod 600 "$TR/noexec"

result="$({
  export TMPDIR="$TR/noexec"
  export GARDEN_SCRATCH="$TR/scratch"
  export GARDEN_TEST=1
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  # shellcheck source=../handlers/worker-common.sh
  source "$JOBS/handlers/worker-common.sh"

  # Stand in for Yarn's portable-shell package-bin wrapper: create a 755 file
  # beneath inherited TMPDIR and execute it from a child agent shell.
  bash -c '
    test "$TMPDIR" = "$GARDEN_SCRATCH/tmpexec" || exit 41
    shim="$TMPDIR/ava-$$"
    printf "#!/bin/sh\\nprintf yarn-bin-ran\\n" > "$shim"
    chmod +x "$shim"
    "$shim"
    rm -f "$shim"
  '
} 2>/dev/null)" || true

if [ "$result" = yarn-bin-ran ]; then
  ok "worker-common exports an exec-capable TMPDIR to the agent process"
else
  bad "agent could not execute a Yarn-style bin wrapper (output='$result')"
fi

echo "----------------------------------------------------------------"
echo "worker-exec-tmpdir: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
