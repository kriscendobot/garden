#!/bin/bash
# mock-garden.sh -- set up a temporary mock garden for driver tests.
#
# Source this file from a test script. After sourcing:
#
#   mock_garden_setup        # creates a temp dir, exports MOCK_GARDEN_ROOT,
#                            #  MOCK_GARDEN_JOURNAL, and the env the driver expects
#   mock_garden_set_pr_json  # writes a stubbed gh-pr-view JSON to GH_STUB
#   mock_garden_run_driver   # invokes driver.sh under the mock env
#   mock_garden_teardown     # removes the temp dir
#
# All paths are absolute; the harness sets cwd to a known location and
# returns to the caller's cwd on teardown.

# Resolve the real garden root from this script's location: this file
# lives at tests/driver/lib/mock-garden.sh, so .../../.. is the garden.
MOCK_HARNESS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)
REAL_GARDEN_ROOT=$(cd "$MOCK_HARNESS_DIR/../../.." && pwd)

mock_garden_setup() {
  MOCK_TMP=$(mktemp -d -t driver-mock-XXXXXX)
  MOCK_GARDEN_ROOT="$MOCK_TMP/garden"
  MOCK_GARDEN_JOURNAL="$MOCK_GARDEN_ROOT/journal"
  MOCK_STUBS="$MOCK_TMP/stubs"
  MOCK_BIN="$MOCK_TMP/bin"
  MOCK_LOGS="$MOCK_TMP/logs"

  mkdir -p "$MOCK_GARDEN_ROOT" "$MOCK_STUBS" "$MOCK_BIN" "$MOCK_LOGS"

  # 1. Copy scripts/driver/ and the skills the driver invokes into the
  #    mock garden. We do not copy the entire real garden; that would
  #    drag in the journal as a git submodule. The mock harness needs
  #    only the artifacts the driver references at runtime.
  mkdir -p "$MOCK_GARDEN_ROOT/scripts"
  cp -r "$REAL_GARDEN_ROOT/scripts/driver" "$MOCK_GARDEN_ROOT/scripts/"

  # Copy the skills the driver invokes.
  mkdir -p "$MOCK_GARDEN_ROOT/skills"
  cp -r "$REAL_GARDEN_ROOT/skills/gardener-inbox-error-reporting" \
        "$MOCK_GARDEN_ROOT/skills/" 2>/dev/null || true
  cp -r "$REAL_GARDEN_ROOT/skills/job-board" \
        "$MOCK_GARDEN_ROOT/skills/" 2>/dev/null || true

  # 2. Initialize a real git repo for the mock journal so hash-object
  #    and update-ref work.
  mkdir -p "$MOCK_GARDEN_JOURNAL"
  ( cd "$MOCK_GARDEN_JOURNAL" && \
    git init --quiet --initial-branch=journal && \
    git config user.name "mock-bot" && \
    git config user.email "mock@example.invalid" && \
    mkdir -p inboxes drivers entries jobs/open jobs/claimed jobs/done jobs/abandoned && \
    touch inboxes/.gitkeep drivers/.gitkeep entries/.gitkeep \
          jobs/open/.gitkeep jobs/claimed/.gitkeep jobs/done/.gitkeep jobs/abandoned/.gitkeep && \
    git add -A && \
    git commit --quiet -m "mock: initialize journal" )

  # 3. Build PATH stubs for gh, claude, and other binaries the driver
  #    might invoke. The stubs read from MOCK_STUBS/<name>.expected
  #    and write a transcript line to MOCK_LOGS/<name>.log.
  cat > "$MOCK_BIN/gh" <<'EOF'
#!/bin/bash
# gh stub for driver tests.
echo "gh $*" >> "${MOCK_LOGS:-/tmp}/gh.log"
case "$1 $2" in
  "pr view")
    if [ -n "${GH_STUB:-}" ] && [ -f "$GH_STUB" ]; then
      cat "$GH_STUB"
    else
      echo "{}"
    fi
    ;;
  "pr ready")
    echo "stub: gh pr ready ${@:3}" >> "${MOCK_LOGS:-/tmp}/gh-ready.log"
    exit 0
    ;;
  *)
    echo "stub: gh unrecognized: $*" >> "${MOCK_LOGS:-/tmp}/gh-unhandled.log"
    exit 0
    ;;
esac
EOF
  chmod +x "$MOCK_BIN/gh"

  cat > "$MOCK_BIN/claude" <<'EOF'
#!/bin/bash
# claude stub for driver tests.
echo "claude invoked with $*" >> "${MOCK_LOGS:-/tmp}/claude.log"
# Default: write a "no-op" response.
if [ "${CLAUDE_STUB_RESPONSE:-}" ]; then
  printf '%s' "$CLAUDE_STUB_RESPONSE"
else
  echo '{"verdict":"escalated","action":"no-op"}'
fi
EOF
  chmod +x "$MOCK_BIN/claude"

  # 4. Export env for the driver under test.
  export GARDEN_ROOT="$MOCK_GARDEN_ROOT"
  export GARDEN_JOURNAL="$MOCK_GARDEN_JOURNAL"
  export GARDEN_HOST="mock-host"
  export MOCK_LOGS
  export PATH="$MOCK_BIN:$PATH"

  return 0
}

mock_garden_set_pr_json() {
  local body=$1
  : > "$MOCK_TMP/pr.json"
  printf '%s' "$body" > "$MOCK_TMP/pr.json"
  export GH_STUB="$MOCK_TMP/pr.json"
}

mock_garden_clear_pr_json() {
  unset GH_STUB
  rm -f "$MOCK_TMP/pr.json"
}

mock_garden_run_driver() {
  local lane=$1
  shift
  bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" "$lane" "$@"
}

mock_garden_teardown() {
  if [ -n "${MOCK_TMP:-}" ] && [ -d "$MOCK_TMP" ]; then
    rm -rf "$MOCK_TMP"
  fi
  unset MOCK_TMP MOCK_GARDEN_ROOT MOCK_GARDEN_JOURNAL MOCK_STUBS MOCK_BIN MOCK_LOGS
  unset GARDEN_ROOT GARDEN_JOURNAL GARDEN_HOST GH_STUB
}

# Pretty-print helpers used by tests.
mock_garden_assert_eq() {
  local label=$1
  local expected=$2
  local actual=$3
  if [ "$expected" = "$actual" ]; then
    echo "  PASS: $label"
    return 0
  fi
  echo "  FAIL: $label"
  echo "    expected: $expected"
  echo "    actual:   $actual"
  return 1
}

mock_garden_assert_contains() {
  local label=$1
  local needle=$2
  local haystack=$3
  if printf '%s' "$haystack" | grep -q -F "$needle"; then
    echo "  PASS: $label"
    return 0
  fi
  echo "  FAIL: $label"
  echo "    expected to contain: $needle"
  echo "    actual:              $haystack"
  return 1
}

mock_garden_assert_file_contains() {
  local label=$1
  local needle=$2
  local path=$3
  if [ ! -f "$path" ]; then
    echo "  FAIL: $label"
    echo "    file does not exist: $path"
    return 1
  fi
  if grep -q -F "$needle" "$path"; then
    echo "  PASS: $label"
    return 0
  fi
  echo "  FAIL: $label"
  echo "    expected $path to contain: $needle"
  echo "    actual contents:"
  sed 's/^/      /' "$path"
  return 1
}
