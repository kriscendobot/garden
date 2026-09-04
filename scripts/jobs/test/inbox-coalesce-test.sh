#!/bin/bash
# inbox-coalesce-test.sh — the coalescing contract for the RAW inbox path
# (audit rec 9 / cybernetics-audit § 3.3).
#
# The maintainer inbox had two disciplined write paths (watchdog-notice.sh,
# doom-notice.sh) and one unlimited one: inbox-send.sh minted a fresh file per
# call unless the caller supplied a stable id — and a stable id merely
# idempotent-SKIPPED (the GitHub-comment re-poll contract), never amended. The
# autonomous notify callers (message-user, orchestrate, gauntlet, follow-up
# liaison) therefore piled one file per send, the duplicate mass the 2026-07-28
# floods proved dominant.
#
# GARDEN_MSG_COALESCE=1 opts a caller into the proven amend-while-unread
# discipline instead. Asserts, on a throwaway journal with no network:
#   A. CONTROL — 11 plain sends (random id) produce 11 unread files.
#   B. COALESCE — 11 coalescing sends of the SAME (sender, episode) key produce
#      exactly ONE entry whose notice_count is the OCCURRENCE count (11), with
#      first_seen/last_seen; throttled occurrences fold, they are never dropped.
#   C. DISTINCT episodes keep distinct entries (key on (sender, episode)).
#   D. ARCHIVE — once the recipient drains the entry (unread→read), the next
#      coalescing send posts a FRESH entry, it does not amend the archived one.
#   E. message-user.sh — identical content coalesces; DISTINCT human-authored
#      content from the same gardener gets a DISTINCT entry (never folded).
#
# Usage: inbox-coalesce-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this suite cannot splice the
# real journal/state under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# Not /tmp (noexec here) and not inside a git repo.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-inbox-coalesce-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

BARE="$TR/journal.git"
seed_journal() {
  rm -rf "$BARE"
  git init -q --bare "$BARE"
  local seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p inbox/maintainer/unread inbox/maintainer/read
    touch inbox/maintainer/unread/.gitkeep inbox/maintainer/read/.gitkeep )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}
seed_journal
STATE="$TR/state"

# --- drivers -----------------------------------------------------------------
# send: a plain inbox-send (control). coalesce: a coalescing send with a stable
# episode id. muser: message-user.sh (episode key derived from content).
send() {  # send <sender> <body>
  env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="$1" \
    "$JOBS/inbox-send.sh" maintainer <<<"$2" >>"$TR/out" 2>&1
}
coalesce() {  # coalesce [--throttle N] <sender> <episode-id> <body>
  local throttle=3600
  if [ "$1" = --throttle ]; then throttle="$2"; shift 2; fi
  env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER="$1" \
    GARDEN_MSG_COALESCE=1 GARDEN_MSG_ID="$2" GARDEN_MSG_COALESCE_THROTTLE_SECS="$throttle" \
    "$JOBS/inbox-send.sh" maintainer <<<"$3" >>"$TR/out" 2>&1
}
muser() {  # muser [--throttle N] <doer> <body>
  local throttle=3600
  if [ "$1" = --throttle ]; then throttle="$2"; shift 2; fi
  env GARDEN=testhost GARDEN_STATE="$STATE" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_SKIP_REF_CHECK=1 GARDEN_MSG_COALESCE_THROTTLE_SECS="$throttle" \
    "$JOBS/message-user.sh" "$1" <<<"$2" >>"$TR/out" 2>&1
}

# --- journal readers ---------------------------------------------------------
snap() { local d; d="$(mktemp -d "$TR/snap.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$d" 2>/dev/null; printf '%s' "$d"; }
unread_count() { local d n; d="$(snap)"; n=$(ls -1 "$d/inbox/maintainer/unread" | grep -vxc '.gitkeep' || true); rm -rf "$d"; printf '%s' "$n"; }
names() { local d; d="$(snap)"; ls -1 "$d/inbox/maintainer/unread" | grep -vx '.gitkeep' | sort; rm -rf "$d"; }
field() { local d v=""; d="$(snap)"; [ -f "$d/inbox/maintainer/unread/$1" ] && v="$(sed -n "s/^$2:[[:space:]]*//p" "$d/inbox/maintainer/unread/$1" | head -1)"; rm -rf "$d"; printf '%s' "$v"; }
body_of() { local d; d="$(snap)"; cat "$d/inbox/maintainer/unread/$1" 2>/dev/null; rm -rf "$d"; }
# Drain the maintainer inbox (unread -> read), mimicking maintainer-watch/archive.
drain() {
  local d; d="$(snap)"
  local f b
  for f in "$d/inbox/maintainer/unread"/*.md; do
    [ -e "$f" ] || continue; b="$(basename "$f")"; [ "$b" = .gitkeep ] && continue
    git -C "$d" mv "inbox/maintainer/unread/$b" "inbox/maintainer/read/$b"
  done
  git -C "$d" "${git_id[@]}" commit -q -m drain >/dev/null 2>&1 || true
  git -C "$d" push -q origin "$BRANCH" >/dev/null 2>&1 || true
  rm -rf "$d"
}

MSG='orchestration halted: child build-x failed; halting the serial run.'

# ============================================================================
hr; echo "A — CONTROL: plain sends post one file per occurrence"; hr
for i in $(seq 1 11); do send orchestrator:x-halted "$MSG"; done
[ "$(unread_count)" -eq 11 ] && ok "11 plain sends → 11 unread files (the flood)" \
  || bad "control produced $(unread_count) files (want 11)"

# ============================================================================
hr; echo "B — COALESCE: 11 occurrences of one episode → ONE counted entry"; hr
seed_journal; rm -rf "$STATE"
coalesce orchestrator:x-halted x-halted "$MSG"
[ "$(unread_count)" -eq 1 ] && ok "first occurrence posts exactly one entry" \
  || bad "first occurrence produced $(unread_count) entries (want 1)"
for i in $(seq 2 10); do coalesce orchestrator:x-halted x-halted "$MSG"; done
[ "$(unread_count)" -eq 1 ] && ok "9 throttled occurrences add NO new entries" \
  || bad "throttled occurrences added entries ($(unread_count) total)"
coalesce --throttle 0 orchestrator:x-halted x-halted "$MSG occurrence eleven"
FILE=x-halted.md
[ "$(unread_count)" -eq 1 ] && ok "after 11 occurrences: still ONE entry" \
  || bad "coalesced path produced $(unread_count) entries (want 1)"
[ "$(field "$FILE" notice_count)" = "11" ] && ok "notice_count is the OCCURRENCE count (11), not the delivery count (2)" \
  || bad "notice_count = $(field "$FILE" notice_count) (want 11)"
[ -n "$(field "$FILE" first_seen)" ] && ok "carries first_seen" || bad "no first_seen frontmatter"
[ -n "$(field "$FILE" last_seen)" ]  && ok "carries last_seen"  || bad "no last_seen frontmatter"
grep -qi 'occurrence #11' <<<"$(body_of "$FILE")" && ok "body states the occurrence count in prose" || bad "body omits the occurrence count"
grep -q 'occurrence eleven' <<<"$(body_of "$FILE")" && ok "body carries the LATEST detail" || bad "body lost the latest detail"

# ============================================================================
hr; echo "C — DISTINCT episodes keep distinct entries"; hr
coalesce --throttle 0 orchestrator:x-complete x-complete "orchestration x complete."
[ "$(unread_count)" -eq 2 ] && ok "a different episode gets its own entry (2 total)" \
  || bad "distinct episode did not get its own entry ($(unread_count) total)"
names | grep -qx x-complete.md && ok "the second entry is keyed by its own episode" \
  || bad "second entry not keyed by episode: $(names | tr '\n' ' ')"

# ============================================================================
hr; echo "D — ARCHIVE: a re-occurrence after drain posts a FRESH entry"; hr
seed_journal; rm -rf "$STATE"
coalesce orchestrator:x-halted x-halted "$MSG"
[ "$(field x-halted.md notice_count)" = "1" ] && ok "fresh episode starts at count 1" \
  || bad "fresh episode count = $(field x-halted.md notice_count) (want 1)"
drain
[ "$(unread_count)" -eq 0 ] && ok "recipient drained the entry (unread=0)" || bad "drain left $(unread_count) unread"
coalesce --throttle 0 orchestrator:x-halted x-halted "$MSG again"
[ "$(unread_count)" -eq 1 ] && ok "a re-occurrence after drain posts a NEW entry (not folded into the read one)" \
  || bad "post-drain re-occurrence produced $(unread_count) unread (want 1)"
[ "$(field x-halted.md notice_count)" = "1" ] && ok "the new entry is a fresh episode (count reset to 1)" \
  || bad "post-drain entry count = $(field x-halted.md notice_count) (want 1, a fresh episode)"

# ============================================================================
hr; echo "E — message-user.sh: identical content folds, distinct content does not"; hr
seed_journal; rm -rf "$STATE"
muser build-widget "waiting on CI to go green; still red."
muser --throttle 0 build-widget "waiting on CI to go green; still red."
[ "$(unread_count)" -eq 1 ] && ok "the SAME message twice from one gardener → ONE entry (count folds)" \
  || bad "identical message produced $(unread_count) entries (want 1)"
mfile="$(names | head -1)"
[ "$(field "$mfile" notice_count)" = "2" ] && ok "notice_count counts the repeat (2)" \
  || bad "notice_count = $(field "$mfile" notice_count) (want 2)"
[ "$(field "$mfile" reply_to)" = "build-widget" ] && ok "message-user preserves reply_to routing under coalescing" \
  || bad "reply_to lost: '$(field "$mfile" reply_to)' (want build-widget)"
muser --throttle 0 build-widget "CI is green now; merging."
[ "$(unread_count)" -eq 2 ] && ok "a DISTINCT message from the same gardener gets a DISTINCT entry (not folded)" \
  || bad "distinct content folded: $(unread_count) entries (want 2)"

hr
echo "inbox-coalesce: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
