#!/bin/bash
# follow-up-seen-cursor-test.sh — regression guard: a leadership change must not
# make follow-up.sh replay tada reports the previous leader already handled.
#
# Incident (2026-10-06): follow-up's seen-marker was host-local only. On a host
# promoted to leader it dated from that host's last term (09-23), so 4,049 handled
# reports looked new and the service re-ran `claude -p` over them, re-asking the
# maintainer. follow-up.sh now publishes a journal seen cursor whenever it advances
# the marker, and reconciles a stale local marker against it.
#
# Usage: follow-up-seen-cursor-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

TR="$(mktemp -d "$HOME/.garden-fu-seen-test.XXXXXX")"  # $HOME, not /tmp: the stub handler must be executable
trap 'rm -rf "$TR"' EXIT

BARE="$TR/journal.git"; W="$TR/writer"
git init -q --bare "$BARE"
git init -q "$W"
git -C "$W" checkout -q -b journal2
mkdir -p "$W/jobs/tada/2026/01/01"; : > "$W/jobs/tada/.gitkeep"
git -C "$W" add -A
git -C "$W" -c user.name=t -c user.email=t@localhost commit -q -m init
git -C "$W" remote add origin "$BARE"
git -C "$W" push -q origin HEAD:journal2
report() {  # <basename> — push an actionable tada report
  git -C "$W" pull -q --rebase origin journal2
  printf '# %s\n## Follow-ups (escalated to liaison)\n- weaver rebase #197 for %s\n' "$1" "$1" \
    > "$W/jobs/tada/2026/01/01/$1.md"
  git -C "$W" add -A
  git -C "$W" -c user.name=t -c user.email=t@localhost commit -q -m "tada $1"
  git -C "$W" push -q origin HEAD:journal2
}

cat > "$TR/handler" <<EOF
#!/bin/bash
cat "\$1" >> "$TR/digests"
echo x >> "$TR/handled"
EOF
chmod +x "$TR/handler"

tick() {  # <host> [cursor-set] — one tick with its own host-local state
  : > "$TR/digests"; : > "$TR/handled"
  rc=0
  env GARDEN="$1" GARDEN_STATE="$TR/state-$1" JOURNAL_REMOTE="$BARE" \
      GARDEN_FOLLOWUP_HANDLER="$TR/handler" GARDEN_CONTENTION_DIR="$TR/state-$1/contention" \
      GARDEN_FOLLOWUP_CURSOR_SET="${2:-$JOBS/cursor-set.sh}" \
      "$JOBS/follow-up.sh" >/dev/null 2>"$TR/$1.err" || rc=$?
  handled="$(wc -l < "$TR/handled")"
}
stale_marker() {  # <host> [content] — a host-local marker left over from an old term
  mkdir -p "$TR/state-$1/follow-up"
  printf '%s' "${2:-}" > "$TR/state-$1/follow-up/seen"
  touch -d '13 days ago' "$TR/state-$1/follow-up/seen"
}
set_cursor() {  # <body> — overwrite the journal seen cursor
  printf '%b' "$1" | env GARDEN_STATE="$TR/state-writer" JOURNAL_REMOTE="$BARE" \
    GARDEN_CONTENTION_DIR="$TR/state-writer/contention" "$JOBS/cursor-set.sh" follow-up/seen >/dev/null 2>&1
}

hr; echo "CASE — the leader handles reports and publishes the seen cursor"; hr
report r1
tick hostA                     # cold start: r1 marked seen, not handled
report r2
tick hostA
cur="$(git --git-dir="$BARE" show journal2:cursors/follow-up/seen 2>/dev/null || true)"
if [ "$rc" -eq 0 ] && [ "$handled" -eq 1 ] && grep -q 'r2' "$TR/digests" \
   && printf '%s\n' "$cur" | grep -qx 'host: hostA' \
   && printf '%s\n' "$cur" | grep -q "^sha: $(git --git-dir="$BARE" rev-parse journal2~1)\$\|^sha: $(git --git-dir="$BARE" rev-parse journal2)\$"; then
  ok "hostA handled r2 once and published its seen position to the journal"
else
  bad "leader tick: rc=$rc handled=$handled cursor=$(printf '%s' "$cur" | tr '\n' ' ') stderr=$(tr '\n' ' ' < "$TR/hostA.err")"
fi

hr; echo "CASE — a promoted host with a stale marker adopts the journal seen set"; hr
stale_marker hostB "r0"
tick hostB
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && grep -q 'adopted' "$TR/hostB.err" \
   && grep -qx r1 "$TR/state-hostB/follow-up/seen" && grep -qx r2 "$TR/state-hostB/follow-up/seen"; then
  ok "no replay: r1/r2 adopted as seen from the cursor"
else
  bad "promoted host: rc=$rc handled=$handled stderr=$(tr '\n' ' ' < "$TR/hostB.err")"
fi
report r3
tick hostB
if [ "$rc" -eq 0 ] && [ "$handled" -eq 1 ] && grep -q 'r3' "$TR/digests" && ! grep -q 'r2' "$TR/digests"; then
  ok "the new leader handles only reports completed after the cursor (r3)"
else
  bad "post-adoption tick: rc=$rc handled=$handled digest=$(tr '\n' ' ' < "$TR/digests")"
fi

hr; echo "CASE — stale marker, this host published last: process normally"; hr
set_cursor 'host: hostB\nat: 1\nsha: deadbeef\n'
mkdir -p "$TR/state-hostB/follow-up"; touch -d '2 hours ago' "$TR/state-hostB/follow-up/seen"
report r4
tick hostB
if [ "$rc" -eq 0 ] && [ "$handled" -eq 1 ] && grep -q 'r4' "$TR/digests"; then
  ok "a cursor older than the local marker leaves the marker in charge (r4 handled)"
else
  bad "own-cursor: rc=$rc handled=$handled stderr=$(tr '\n' ' ' < "$TR/hostB.err")"
fi

hr; echo "CASE — stale marker, cursor commit unreadable: cold start"; hr
set_cursor "host: hostZ\nat: $(date +%s)\nsha: 0123456789012345678901234567890123456789\n"
report r5
stale_marker hostC
tick hostC
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && grep -q 'cold start' "$TR/hostC.err" \
   && grep -qx r5 "$TR/state-hostC/follow-up/seen"; then
  ok "an unreadable cursor commit falls back to a cold start (nothing replayed)"
else
  bad "unreadable cursor: rc=$rc handled=$handled stderr=$(tr '\n' ' ' < "$TR/hostC.err")"
fi

hr; echo "CASE — stale marker, no cursor at all: cold start"; hr
git -C "$W" pull -q --rebase origin journal2
git -C "$W" rm -q -r cursors
git -C "$W" -c user.name=t -c user.email=t@localhost commit -q -m "drop cursors"
git -C "$W" push -q origin HEAD:journal2
stale_marker hostD
tick hostD
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && grep -q 'no journal seen cursor' "$TR/hostD.err"; then
  ok "a stale marker without a cursor is treated as a cold start"
else
  bad "no cursor: rc=$rc handled=$handled stderr=$(tr '\n' ' ' < "$TR/hostD.err")"
fi

hr; echo "CASE — transient cursor publication retries in-tick"; hr
cat > "$TR/cursor-set-once" <<EOF
#!/bin/bash
n=\$(( \$(wc -l < "$TR/cursor-set-calls") + 1 ))
echo x >> "$TR/cursor-set-calls"
if [ "\$n" -lt "\${FU_CURSOR_OK_AT:-99}" ]; then
  cat >/dev/null
  exit 1
fi
exec "$JOBS/cursor-set.sh" "\$@"
EOF
chmod +x "$TR/cursor-set-once"
report r6
: > "$TR/cursor-set-calls"
export FU_CURSOR_OK_AT=3 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2
tick hostE "$TR/cursor-set-once"       # cold start: first two writes lose, third lands
unset FU_CURSOR_OK_AT GARDEN_BACKOFF_BASE_MS GARDEN_BACKOFF_CAP_MS
pending="$TR/state-hostE/follow-up/seen-cursor-pending"
pending_sha="$(git --git-dir="$BARE" rev-parse journal2)"
cur="$(git --git-dir="$BARE" show journal2:cursors/follow-up/seen 2>/dev/null || true)"
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && [ ! -e "$pending" ] \
   && [ "$(grep -c . "$TR/cursor-set-calls")" -eq 3 ] \
   && printf '%s\n' "$cur" | grep -qx 'host: hostE'; then
  ok "transient publication contention clears within the tick and removes the pending body"
else
  bad "in-tick retry: rc=$rc handled=$handled calls=$(grep -c . "$TR/cursor-set-calls") pending=$(test -e "$pending" && echo yes || echo no) stderr=$(tr '\n' ' ' < "$TR/hostE.err")"
fi

hr; echo "CASE — exhausted publication persists and a no-op tick retries it"; hr
report r7
: > "$TR/cursor-set-calls"
export FU_CURSOR_OK_AT=5 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2
tick hostE "$TR/cursor-set-once"       # four bounded attempts all lose
unset FU_CURSOR_OK_AT GARDEN_BACKOFF_BASE_MS GARDEN_BACKOFF_CAP_MS
pending_sha="$(git --git-dir="$BARE" rev-parse journal2)"
if [ "$rc" -eq 0 ] && [ "$handled" -eq 1 ] && [ -s "$pending" ] \
   && grep -qx 'host: hostE' "$pending" && grep -qx "sha: $pending_sha" "$pending" \
   && [ "$(grep -c . "$TR/cursor-set-calls")" -eq 4 ] \
   && grep -q 'transient journal-write contention' "$TR/hostE.err" \
   && grep -q 'publication remains pending' "$TR/hostE.err"; then
  ok "exhausted bounded retries retain the complete pending publication"
else
  bad "exhausted publish: rc=$rc handled=$handled calls=$(grep -c . "$TR/cursor-set-calls") pending=$(test -s "$pending" && echo yes || echo no) stderr=$(tr '\n' ' ' < "$TR/hostE.err")"
fi
export FU_CURSOR_OK_AT=5 GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=2
tick hostE "$TR/cursor-set-once"       # no new reports: fifth call lands
unset FU_CURSOR_OK_AT GARDEN_BACKOFF_BASE_MS GARDEN_BACKOFF_CAP_MS
cur="$(git --git-dir="$BARE" show journal2:cursors/follow-up/seen 2>/dev/null || true)"
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && [ ! -e "$pending" ] \
   && printf '%s\n' "$cur" | grep -qx 'host: hostE'; then
  ok "a later no-op tick publishes the pending cursor and clears it only after success"
else
  bad "no-op retry: rc=$rc handled=$handled pending=$(test -e "$pending" && echo yes || echo no) cursor=$(printf '%s' "$cur" | tr '\n' ' ') stderr=$(tr '\n' ' ' < "$TR/hostE.err")"
fi

hr; echo "CASE — deterministic remote rejection stays loud and is not retried"; hr
cat > "$TR/cursor-set-rejected" <<EOF
#!/bin/bash
cat >/dev/null
echo x >> "$TR/cursor-reject-calls"
printf '%s\n' '! [remote rejected] journal2 -> journal2 (protected branch hook declined)' >&2
printf '%s\n' 'cursor-set: raised deduplicated repair alert for follow-up/seen (server-reject)' >&2
exit 1
EOF
chmod +x "$TR/cursor-set-rejected"
report r8
: > "$TR/cursor-reject-calls"
tick hostF "$TR/cursor-set-rejected"
rejected_pending="$TR/state-hostF/follow-up/seen-cursor-pending"
if [ "$rc" -eq 0 ] && [ "$handled" -eq 0 ] && [ -s "$rejected_pending" ] \
   && [ "$(grep -c . "$TR/cursor-reject-calls")" -eq 1 ] \
   && grep -q 'DEFINITE: cursor-set: raised deduplicated repair alert' "$TR/hostF.err" \
   && grep -q 'NOT retrying — needs repair' "$TR/hostF.err"; then
  ok "deterministic rejection is attempted once and retains its repair-alert diagnostic"
else
  bad "remote rejection: rc=$rc handled=$handled calls=$(grep -c . "$TR/cursor-reject-calls") pending=$(test -s "$rejected_pending" && echo yes || echo no) stderr=$(tr '\n' ' ' < "$TR/hostF.err")"
fi

hr; echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
