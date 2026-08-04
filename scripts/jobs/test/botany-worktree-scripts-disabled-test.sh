#!/bin/bash
# botany-worktree-scripts-disabled-test.sh — prove, with a REAL package manager and
# a REAL lifecycle-script sentinel, that a botanist worktree is provisioned WITHOUT
# running the untrusted new version's install scripts, and that doing so does not
# doom the native-build cache ordinary jobs reuse.
#
# The gap this regresses (reported 2026-07-29 from the botany of
# endojs/endo-but-for-bots#867): roles/botanist/AGENT.md mandates a scripts-disabled
# install as its single strongest supply-chain control, but ensure-project-worktree.sh
# ran a plain scripts-ENABLED install during provisioning — BEFORE the botanist ever
# got control — so the untrusted version's preinstall executed in the container under
# the bot's credentials, and a botanist that then "installed with scripts disabled"
# attested to a safety property that no longer held.
#
# The fix (commit "fix(botanist): disable dependency install scripts") keys off the
# job role: the worker spine exports GARDEN_JOB_ROLE, and ensure-project-worktree.sh
# gives a `botanist` job a scripts-disabled install (npm/pnpm/Yarn scripts-disabled
# env) in a cache namespace disjoint from native-build jobs. Its own regression lives
# in project-worktree-isolation-test.sh and asserts the policy ENV is passed — the
# necessary-but-weaker "a flag was passed" shape. This test adds the shape the report
# asked for and that one lacks: a SENTINEL a lifecycle script would have written,
# driven through a REAL `npm`, so it proves the script did not RUN rather than that we
# tried to stop it — and it proves the real package manager actually honors the env
# the stub can only record.
#
# Assertions:
#   1. Ordinary job: install scripts RUN (positive control — the sentinel exists, and
#      the native-build path is not broken).
#   2. Botanist job (GARDEN_JOB_ROLE=botanist): install scripts DO NOT run (the
#      regression — sentinel absent, proven against a real npm).
#   3. The two policies keep DISJOINT caches: the botanist tree is keyed
#      `<lockhash>-scripts-disabled`, the ordinary one `<lockhash>-native-builds`, and
#      a later ordinary job on the SAME lockfile still runs scripts (no doom).
#
# Needs a real `npm` (an independent authority on the scripts-disabled env); SKIPs
# cleanly when absent. Hermetic otherwise: throwaway bare "fork" clone + throwaway
# garden root, offline (one local `file:` dependency, no network).

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS_SRC="$(cd "$HERE/.." && pwd)"

command -v npm  >/dev/null 2>&1 || { echo "  SKIP: no npm on PATH; the real-package-manager sentinel test needs it"; exit 0; }
command -v node >/dev/null 2>&1 || { echo "  SKIP: no node on PATH"; exit 0; }

pick_base() {
  local c
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
BASE_DIR="$(pick_base)" || { echo "  SKIP: no writable temp base"; exit 0; }
TR="$(mktemp -d "$BASE_DIR/botany-scripts-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)

GROOT="$TR/garden"
mkdir -p "$GROOT/scripts/jobs" "$GROOT/worktrees"
cp "$JOBS_SRC/common.sh" "$JOBS_SRC/usage-meter.sh" "$JOBS_SRC/quota-panel.sh" \
   "$JOBS_SRC/ensure-project-worktree.sh" "$GROOT/scripts/jobs/"
chmod +x "$GROOT/scripts/jobs/ensure-project-worktree.sh"
git -C "$GROOT" init -q
git -C "$GROOT" config user.name  garden-bot
git -C "$GROOT" config user.email garden-bot@localhost
HELPER="$GROOT/scripts/jobs/ensure-project-worktree.sh"
SCRATCH="$GROOT/scratch"

# --- seed a node "fork" whose lifecycle scripts write a sentinel -------------
# The root package's preinstall + postinstall append to LIFECYCLE_RAN in the worktree
# root. A real `npm ci` runs them; the botanist scripts-disabled env does not — that
# sentinel is the whole test. A trivial local `file:` dependency is added so a real
# node_modules is materialised (and genuinely snapshotted into the warm cache) in both
# policies, with no network. The lockfile is generated offline with --ignore-scripts,
# so seeding never runs the sentinel scripts itself.
SEED="$TR/seed"; UP="$TR/upstream.git"
mkdir -p "$SEED/dep"
printf '{ "name": "botany-sentinel-dep", "version": "1.0.0" }\n' > "$SEED/dep/package.json"
cat > "$SEED/package.json" <<'PKG'
{
  "name": "botany-sentinel",
  "version": "1.0.0",
  "private": true,
  "dependencies": { "botany-sentinel-dep": "file:./dep" },
  "scripts": {
    "preinstall": "echo pre >> LIFECYCLE_RAN",
    "postinstall": "echo post >> LIFECYCLE_RAN"
  }
}
PKG
( cd "$SEED" && npm install --package-lock-only --ignore-scripts \
    --no-audit --no-fund --offline >/dev/null 2>&1 ) \
  || ( cd "$SEED" && npm install --package-lock-only --ignore-scripts >/dev/null 2>&1 )
[ -f "$SEED/package-lock.json" ] || { echo "  SKIP: could not generate a package-lock.json offline"; exit 0; }
git init -q --bare "$UP"
( cd "$SEED"
  git "${git_id[@]}" init -q
  git "${git_id[@]}" add -A
  git "${git_id[@]}" commit -qm seed
  git "${git_id[@]}" branch -M main
  git "${git_id[@]}" remote add origin "$UP"
  git "${git_id[@]}" push -q -u origin main ) >/dev/null 2>&1
BARE="$GROOT/worktrees/endojs-sentinel.git"
git clone -q --bare "$UP" "$BARE"
git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git -C "$BARE" remote set-url origin "$UP"

ERRF="$TR/helper.stderr"; : > "$ERRF"
run() {  # run <base> [GARDEN_JOB_ROLE=botanist]  → echoes the worktree path
  # `env` applies the leading assignments at runtime; a bare `$@` prefix would NOT be
  # parsed as an assignment (bash fixes assignment tokens before expansion), so the
  # optional role override must ride through `env`.
  local base="$1"; shift || true
  env GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" "$@" \
    bash "$HELPER" "$base" endojs/sentinel main 2>>"$ERRF"
}

LOCKHASH="$(git hash-object "$SEED/package-lock.json")"
CACHE="$GROOT/.garden-state/dep-cache/endojs-sentinel"

# === 1: ordinary job → scripts RUN (positive control; native path intact) =====
P_ORD="$(run garden-ordinary-build)"
[ -n "$P_ORD" ] && [ -d "$P_ORD" ] \
  && ok "ordinary job is handed a worktree" \
  || bad "ordinary job produced no worktree (P='$P_ORD')"
[ -f "$P_ORD/LIFECYCLE_RAN" ] \
  && ok "ordinary job RUNS install scripts (sentinel present — control valid, native path intact)" \
  || bad "ordinary job did NOT run install scripts — the test cannot detect script execution, or ordinary provisioning is broken"

# === 2: botanist job (GARDEN_JOB_ROLE=botanist) → scripts DO NOT run ===========
# This is the regression, proven against a REAL npm: the scripts-disabled env the
# spine passes must actually suppress the untrusted preinstall, not merely be present.
P_BOT="$(run garden-botany-review GARDEN_JOB_ROLE=botanist)"
[ -n "$P_BOT" ] && [ -d "$P_BOT" ] \
  && ok "botanist job is handed a worktree" \
  || bad "botanist job produced no worktree (P='$P_BOT')"
[ ! -f "$P_BOT/LIFECYCLE_RAN" ] \
  && ok "botanist job does NOT run install scripts (sentinel absent against real npm — the fix holds)" \
  || bad "botanist job RAN install scripts (sentinel present at $P_BOT/LIFECYCLE_RAN) — the supply-chain gap is OPEN"

# === 3: the two policies keep DISJOINT caches (no dooming) ==================
[ -d "$CACHE/$LOCKHASH-native-builds" ] \
  && ok "the ordinary cache is keyed <lockhash>-native-builds" \
  || bad "no native-builds cache dir at $CACHE/$LOCKHASH-native-builds"
[ -d "$CACHE/$LOCKHASH-scripts-disabled" ] \
  && ok "the botanist cache is keyed <lockhash>-scripts-disabled (disjoint namespace)" \
  || bad "no scripts-disabled cache dir at $CACHE/$LOCKHASH-scripts-disabled"
# A SECOND ordinary job on the SAME lockfile must still get scripts run — i.e. the
# scripts-disabled cache did not doom the native-build key it shares a slug with.
P_ORD2="$(run garden-ordinary-build-2)"
[ -f "$P_ORD2/LIFECYCLE_RAN" ] \
  && ok "a later ordinary job on the same lockfile still runs scripts (scripts-disabled cache did not doom it)" \
  || bad "a later ordinary job got a scripts-disabled tree — the scripts-disabled cache DOOMED the native-build key"

echo "----------------------------------------------------------------"
echo "botany-worktree-scripts-disabled: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
