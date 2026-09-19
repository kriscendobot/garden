#!/usr/bin/env bash
# ferry.sh — the garden's DEDICATED ferry dispatch loop, run HOST-NATIVE.
#
# WHAT THIS IS
# The boatman (roles/boatman/AGENT.md) carries an approved pull request from a
# garden fork UPSTREAM to a governance repo, under the MAINTAINER's identity. That
# is a permissioned, identity-crossing act that must run on the one host holding
# the maintainer's (kriskowal) git/gh credentials — never on a bot host, never
# under the fleet's bot-pinned `gh` wrapper. So ferry dispatch is deliberately
# taken OFF the ordinary journal job board (jobs/todo/) and given its own board
# and its own runner: this script, which the maintainer runs directly on their
# own machine, OUTSIDE the garden container (exactly like the repo-root `garden`
# launcher).
#
# It watches the dedicated ferry board `jobs/ferry/` on the journal branch
# (journal2) for directives, and for each one dispatches `claude -p` wearing the
# boatman role against that directive — using the operator's OWN ambient git/gh
# session (no bot-identity pin, no GARDEN_GH_IDENTITY override, no fleet PATH).
# Every boatman safety invariant (host preconditions, human-author-every-commit,
# trailer strip, per-commit identity override, the garden-side cross-link + mirror
# record, contribution-convention discovery) still runs — it lives in the role
# brief the dispatched agent reads, and is only RE-TRIGGERED here by a different
# mechanism, not rewritten.
#
# LOCKED OUT OF THE BOARD (job dedicated-ferry-dispatch): a `role: boatman` job on
# the ordinary board is refused mechanically — claim-job.sh will not claim it and
# gardener.sh will not run it. `scripts/ferry.sh` + `jobs/ferry/` is the ONLY way a
# ferry is dispatched.
#
# BOARD LIFECYCLE (mirrors todo->doin->tada in spirit, on jobs/ferry/):
#   jobs/ferry/<name>.md          — a pending ferry directive (the liaison writes here).
#   jobs/ferry/doing/<name>.md    — CLAIMED by this loop (a claim stamp appended);
#                                   a concurrent run sees the move and cannot re-dispatch.
#   jobs/ferry/done/<name>.md     — completed; a durable audit record (mirrors tada/),
#                                   the completion stamp appended. A directive that did
#                                   NOT complete stays in doing/ for the maintainer to
#                                   inspect (never silently retried, never lost).
#
# DIRECTIVE SHAPE (jobs/ferry/<name>.md) — the fields roles/boatman/AGENT.md § Job
# inputs requires, in their new home:
#
#     ---
#     downstream: kriscendobot/endo-but-for-bots#387   # the garden-side PR ferried FROM
#     downstream_branch: my-feature-frozen-abc1234     # its head branch
#     upstream: endojs/endo                            # the governance repo ferried TO
#     upstream_base: master                            # the upstream base branch
#     upstream_pr:                                     # set once opened (a fresh ferry has none)
#     human: Kris Kowal <kris@example.com>             # commit attribution (name + email)
#     identity_switch_authorized: true                 # MAINTAINER-ONLY; no agent may originate it
#     convention:                                      # optional: conventional-commits / DCO / squash policy
#     ---
#     Ferry endojs/endo-but-for-bots#387 upstream to endojs/endo (base master).
#     <one or two sentences of context for the boatman>
#
# BASH DIALECT: macOS stock bash 3.2 + BSD coreutils. No associative arrays,
# no mapfile/readarray, no ${var,,}, no `date -d`, no GNU `sed -i` (we avoid
# in-place sed entirely), no `readlink -f`. Tested with `bash --posix -n` and a
# `bash 3.2`-shaped review; see designs/dedicated-ferry-dispatch.md.

set -euo pipefail

# --- location (no readlink -f; BSD-safe cd/pwd idiom, as the `garden` launcher) --
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"          # ferry.sh lives at <root>/scripts/ferry.sh

# --- configuration (all overridable; sane host defaults) ----------------------
BRANCH="${GARDEN_FERRY_JOURNAL_BRANCH:-journal2}"
FERRY_STATE="${GARDEN_FERRY_STATE:-$ROOT/.garden-ferry}"   # gitignored (/.[!.]* in .gitignore)
CLONE="$FERRY_STATE/journal"                              # our OWN clone; never touches root/journal .git
LOCKDIR="$FERRY_STATE/lock"
LOGDIR="$FERRY_STATE/logs"
INTERVAL="${GARDEN_FERRY_INTERVAL:-30}"                    # seconds between polls in loop mode
CLAUDE_BIN="${GARDEN_FERRY_CLAUDE:-claude}"
COMPLETE_MARKER='<<<GARDEN-FERRY-COMPLETE>>>'

log() { printf '[ferry %s] %s\n' "$(date -u +%FT%TZ)" "$*" >&2; }
die() { log "FATAL: $*"; exit 1; }

usage() {
  cat <<EOF
Usage: $(basename "$0") [--once] [--help]

Run the garden's dedicated ferry dispatch loop on the CREDENTIALED HOST, outside
the container, using your ambient git/gh session. Watches the jobs/ferry/ board on
'$BRANCH' and dispatches the boatman role (claude -p) for each pending directive.

  (no args)   Loop forever, polling every \${GARDEN_FERRY_INTERVAL:-30}s.
  --once      Run a single pass over the board and exit (useful for cron / testing).
  --help      This help.

Preconditions (this host must hold the maintainer credentials):
  * gh auth status shows the human account (e.g. kriskowal), and
  * you have push permission on the upstream governance repos.
The dispatched boatman re-verifies both before pushing and BLOCKS (leaving the
directive in jobs/ferry/doing/) if either is missing — it never pushes as the bot.

Environment:
  GARDEN_FERRY_JOURNAL_REMOTE   journal git remote (default: read from ./journal or the repo origin).
  GARDEN_FERRY_JOURNAL_BRANCH   journal branch (default: journal2).
  GARDEN_FERRY_STATE            host-local state/clone dir (default: <root>/.garden-ferry).
  GARDEN_FERRY_INTERVAL         loop poll interval seconds (default: 30).
  GARDEN_FERRY_CLAUDE           claude CLI to invoke (default: claude).
EOF
}

# --- journal remote resolution ------------------------------------------------
# Prefer an explicit override; else read the remote READ-ONLY from the local
# journal worktree (its own remote config), else from the repo root. `git config
# --get` is read-only and cannot corrupt the shared root repo; we never run a
# MUTATING git op against $ROOT or $ROOT/journal here — all writes go to $CLONE.
resolve_remote() {
  if [ -n "${GARDEN_FERRY_JOURNAL_REMOTE:-}" ]; then
    printf '%s\n' "$GARDEN_FERRY_JOURNAL_REMOTE"; return 0
  fi
  local url=""
  if [ -e "$ROOT/journal/.git" ]; then
    url="$(git -C "$ROOT/journal" config --get remote.origin.url 2>/dev/null || true)"
  fi
  if [ -z "$url" ] && [ -e "$ROOT/.git" ]; then
    url="$(git -C "$ROOT" config --get remote.origin.url 2>/dev/null || true)"
  fi
  [ -n "$url" ] || return 1
  printf '%s\n' "$url"
}

# --- clone sync (our own throwaway clone; never the deployed root/journal) -----
sync_clone() {
  if [ ! -e "$CLONE/.git" ]; then
    mkdir -p "$FERRY_STATE"
    git clone --quiet --branch "$BRANCH" "$REMOTE" "$CLONE" \
      || die "could not clone journal '$REMOTE' ($BRANCH) into $CLONE"
    return 0
  fi
  git -C "$CLONE" fetch --quiet origin "$BRANCH" || { log "WARN: fetch failed (offline?); using last-synced state"; return 1; }
  git -C "$CLONE" checkout --quiet -B "$BRANCH" "origin/$BRANCH" 2>/dev/null \
    || git -C "$CLONE" reset --quiet --hard "origin/$BRANCH"
  git -C "$CLONE" reset --quiet --hard "origin/$BRANCH"
  git -C "$CLONE" clean -fdq
  return 0
}

# --- commit + CAS push (adds/moves rebase cleanly; retry on a lost race) -------
commit_push() {
  local msg="$1" i
  git -C "$CLONE" add -A
  # nothing staged is a no-op success (idempotent re-run)
  git -C "$CLONE" diff --cached --quiet && return 0
  # Use the ambient host identity (this IS the maintainer's machine). Fall back to
  # a neutral name only if the host git config names nobody, so a commit never fails.
  local cn ce
  cn="$(git -C "$CLONE" config user.name 2>/dev/null || true)";  [ -n "$cn" ] || cn="garden-ferry"
  ce="$(git -C "$CLONE" config user.email 2>/dev/null || true)"; [ -n "$ce" ] || ce="garden-ferry@localhost"
  git -C "$CLONE" -c user.name="$cn" -c user.email="$ce" commit --quiet -m "$msg" || return 1
  for i in 1 2 3 4 5; do
    if git -C "$CLONE" push --quiet origin "HEAD:$BRANCH" 2>/dev/null; then return 0; fi
    log "push race on '$msg' (attempt $i); re-syncing and rebasing"
    git -C "$CLONE" fetch --quiet origin "$BRANCH" || return 1
    if ! git -C "$CLONE" rebase --quiet "origin/$BRANCH"; then
      git -C "$CLONE" rebase --abort >/dev/null 2>&1 || true
      return 1
    fi
    sleep 1
  done
  return 1
}

# --- the boatman prompt (single source of truth stays roles/boatman/AGENT.md) --
# We do NOT re-inline the role's safety steps here (that would drift); we tell the
# dispatched agent to READ and WEAR the role, and state only the HOST-NATIVE deltas.
build_prompt() {
  local name="$1" body="$2"
  cat <<EOF
You are the garden BOATMAN. Read roles/boatman/AGENT.md IN FULL (it is at
$ROOT/roles/boatman/AGENT.md) and follow EVERY operating norm and safety step it
specifies. Also read the skills it names (skills/pr-handoff/SKILL.md,
skills/pr-formation/SKILL.md). Your job is to ferry ONE approved pull request
upstream, described by the directive at the end of this prompt.

HOST-NATIVE EXECUTION CONTEXT (this is the one thing that differs from the role
brief, which was written for the in-container fleet):
- You are running ON THE MAINTAINER'S HOST, outside the garden container, using the
  operator's OWN ambient git and gh session. Plain \`git\` and \`gh\` already act as
  the MAINTAINER (e.g. kriskowal). There is NO fleet gh wrapper and NO bot-identity
  pin on this path.
- Therefore do NOT set GARDEN_GH_IDENTITY on any command — that override exists only
  to escape the in-container bot pin, which is not present here. Use \`gh\` and \`git\`
  directly.
- Your working directory is the garden root ($ROOT). Do NOT run mutating git in the
  root repo or the journal/ worktree. Create the project checkout you ferry in with a
  fresh clone or worktree UNDER \$TMPDIR (git init / git clone it yourself), never
  inside $ROOT.

SAFETY INVARIANTS YOU MUST STILL HONOR (from roles/boatman/AGENT.md — do not skip):
- HOST PRECONDITIONS: \`gh auth status\` must show the human account and
  \`gh api repos/<upstream> --jq .permissions\` must show push:true (or admin:true).
  If either is missing, STOP: write a clear blocked explanation and do NOT push and
  do NOT emit the completion marker below.
- IDENTITY SWITCH: the directive MUST carry \`identity_switch_authorized: true\`
  (maintainer-originated). If it does not, STOP with a blocked explanation; do not push.
- HUMAN AUTHOR, EVERY COMMIT: every transferred commit is authored by the named
  human; strip Co-Authored-By / "Generated with [Claude Code]" / any bot trailer.
  Use the per-commit \`git -c user.name=... -c user.email=... commit/rebase\` override.
- One clean, reviewable upstream series against the upstream's natural base.
- The garden-side cross-link comment (\`Mirror of <upstream-PR-URL> (head <short-SHA>).\`)
  and the upstream<->mirror journal mapping (record-mirror.sh), per the role's Done list.
- Follow the upstream project's contribution conventions (CONTRIBUTING.md, PR template).

COMPLETION CONTRACT:
- When the ferry is GENUINELY complete (upstream PR open, human-attributed, cross-link
  + mirror recorded), print a short report of what you did (garden PR URL, upstream PR
  URL, upstream head SHA, cross-link comment id) and then, as your VERY LAST line, on
  its own line, emit EXACTLY:
      $COMPLETE_MARKER
- If you are BLOCKED or unfinished for ANY reason, explain why and do NOT emit that
  line. The dispatcher leaves an unmarked directive in jobs/ferry/doing/ for the
  maintainer to inspect; it is never silently retried.

----- FERRY DIRECTIVE ($name) -----
$body
----- END DIRECTIVE -----
EOF
}

# --- dispatch one directive ---------------------------------------------------
dispatch_one() {
  local name="$1"
  local rel="jobs/ferry/$name.md"
  # Re-sync and re-check right before claiming so a peer/prior claim is seen.
  sync_clone || return 0
  if [ ! -e "$CLONE/$rel" ]; then
    log "'$name' no longer pending (claimed/removed elsewhere); skipping"
    return 0
  fi
  mkdir -p "$CLONE/jobs/ferry/doing"
  git -C "$CLONE" mv "$rel" "jobs/ferry/doing/$name.md"
  {
    printf '\n---\nferry_claim:\n'
    printf '  host: %s\n' "$(hostname -s 2>/dev/null || echo host)"
    printf '  claimed_at: %s\n' "$(date -u +%FT%TZ)"
  } >> "$CLONE/jobs/ferry/doing/$name.md"
  if ! commit_push "ferry-claim($name)"; then
    log "could not claim '$name' (lost push race or offline); leaving pending for next tick"
    return 0
  fi
  log "claimed ferry directive '$name'; dispatching the boatman (claude -p)"

  local body prompt logf rc
  body="$(cat "$CLONE/jobs/ferry/doing/$name.md")"
  prompt="$(build_prompt "$name" "$body")"
  mkdir -p "$LOGDIR"
  logf="$LOGDIR/$name.$(date -u +%Y%m%dT%H%M%SZ).log"

  set +e
  ( cd "$ROOT" && "$CLAUDE_BIN" -p --dangerously-skip-permissions "$prompt" ) 2>&1 | tee "$logf"
  rc=${PIPESTATUS[0]}
  set -e

  # Re-sync (keeps our pushed doing/ file; picks up any peer journal changes),
  # then archive on genuine completion or record the failure in place.
  sync_clone || log "WARN: could not re-sync before archiving '$name'; retrying push anyway"
  if [ "$rc" -eq 0 ] && grep -q -- "$COMPLETE_MARKER" "$logf"; then
    mkdir -p "$CLONE/jobs/ferry/done"
    if [ -e "$CLONE/jobs/ferry/doing/$name.md" ]; then
      git -C "$CLONE" mv "jobs/ferry/doing/$name.md" "jobs/ferry/done/$name.md"
    fi
    {
      printf '\n---\nferry_done:\n'
      printf '  completed_at: %s\n' "$(date -u +%FT%TZ)"
      printf '  exit: 0\n'
      printf '  log: %s\n' "$logf"
    } >> "$CLONE/jobs/ferry/done/$name.md"
    commit_push "ferry-done($name)" || log "WARN: could not push done marker for '$name' (it is archived locally at $CLONE)"
    log "ferry '$name' COMPLETE; archived to jobs/ferry/done/ (log: $logf)"
  else
    if [ -e "$CLONE/jobs/ferry/doing/$name.md" ]; then
      {
        printf '\n---\nferry_failed:\n'
        printf '  at: %s\n' "$(date -u +%FT%TZ)"
        printf '  exit: %s\n' "$rc"
        printf '  marker: %s\n' "$(grep -q -- "$COMPLETE_MARKER" "$logf" && echo present || echo absent)"
        printf '  log: %s\n' "$logf"
      } >> "$CLONE/jobs/ferry/doing/$name.md"
      commit_push "ferry-blocked($name) rc=$rc" || true
    fi
    log "WARN: ferry '$name' did NOT complete (exit $rc); left in jobs/ferry/doing/ for maintainer inspection (log: $logf)"
  fi
}

# --- one pass over the board --------------------------------------------------
run_once() {
  sync_clone || { log "journal unreachable this pass; will retry"; return 0; }
  local ferry_dir="$CLONE/jobs/ferry"
  mkdir -p "$ferry_dir/doing" "$ferry_dir/done"
  local found=0 f name
  for f in "$ferry_dir"/*.md; do
    [ -e "$f" ] || continue          # literal-glob guard (no nullglob in bash 3.2)
    found=1
    name="$(basename "$f" .md)"
    dispatch_one "$name" || log "WARN: dispatch of '$name' errored; continuing"
  done
  [ "$found" -eq 1 ] || log "no pending ferry directives on jobs/ferry/"
}

# --- main ---------------------------------------------------------------------
MODE=loop
case "${1:-}" in
  --once) MODE=once ;;
  -h|--help|help) usage; exit 0 ;;
  "") ;;
  *) usage; exit 1 ;;
esac

# Warn if we appear to be INSIDE the container: ferry.sh is host-native by design
# (it must use the maintainer's ambient credentials, not the fleet's bot pin).
if [ -e /.dockerenv ]; then
  log "WARNING: /.dockerenv present — you appear to be INSIDE the garden container."
  log "         ferry.sh is meant to run ON THE HOST, using the maintainer's ambient"
  log "         git/gh session. Inside the container gh is pinned to the bot and cannot"
  log "         push upstream as the maintainer. Exit and run scripts/ferry.sh on the host."
fi

REMOTE="$(resolve_remote)" || die "could not resolve the journal remote; set GARDEN_FERRY_JOURNAL_REMOTE (or run from a garden checkout with a ./journal worktree or a repo origin)."

# Single-runner lock (mkdir is atomic and portable; no flock dependency).
mkdir -p "$FERRY_STATE"
if ! mkdir "$LOCKDIR" 2>/dev/null; then
  die "another ferry.sh appears to be running (lock: $LOCKDIR). Remove it if stale."
fi
trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT INT TERM

log "ferry dispatcher up: remote=$REMOTE branch=$BRANCH clone=$CLONE mode=$MODE"

if [ "$MODE" = once ]; then
  run_once
  exit 0
fi

while :; do
  run_once
  sleep "$INTERVAL"
done
