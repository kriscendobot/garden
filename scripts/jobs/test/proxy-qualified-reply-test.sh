#!/bin/bash
# proxy-qualified-reply-test.sh — regression guard for the PROXY VALIDATES ITS OWN
# GENERATED ANSWER fix (improve-proxy-qualified-replies, 2026-08-23).
#
# THE GAP THIS CLOSES: the proxy handler (handlers/proxy-claude.sh) took the reply
# `claude -p` drafted for a blocked gardener and delivered it via maintainer-reply.sh
# WITHOUT validating it first. maintainer-reply.sh runs the deterministic
# check-issue-refs.sh gate on the reply, so a drafted answer carrying a bare `#N`
# (which an LLM answer about a PR very naturally emits — "see PR #340") made that gate
# `die`. Under `set -euo pipefail` the die propagated out of the handler, so proxy.sh
# NEVER advanced its seen-marker — and every five minutes the same digest was
# re-enumerated, the same malformed reply re-drafted, and the tick re-died. A single
# malformed proxy reply crash-looped garden-proxy indefinitely, and the gardener was
# never answered NOR deferred.
#
# THE FIX: the handler now VALIDATES each generated ANSWER (the same check-issue-refs
# gate) BEFORE delivery. On rejection it runs ONE bounded repair pass — handing the
# reply and the validator diagnostics back to the agent to fully-qualify the
# reference(s) — and re-validates. If the reply now validates it is delivered; if it
# still does not, the question is DEFERRED with a DEDUPLICATED maintainer note
# (deterministic GARDEN_MSG_ID, so a re-run never re-piles the note) instead of the
# handler dying. Either way the handler exits 0, so proxy.sh advances the seen-marker
# and the crash-loop is broken.
#
# SUBTEST 1 — a drafted reply with a bare `#N` that the repair pass FIXES: the
#             corrected (fully-qualified) reply is delivered to the gardener, the
#             maintainer message is archived, a report is posted, handler exits 0.
# SUBTEST 2 — a drafted reply with a bare `#N` that survives the repair pass: the
#             handler exits 0 (NO crash), the gardener gets NO malformed reply, the
#             gating question is left UNREAD for the maintainer, and exactly one
#             deduplicated "could not deliver a valid answer" note is posted — a
#             second identical run adds NO further note.
# SUBTEST 3 — a clean drafted reply (no partial refs) is delivered unchanged with no
#             repair pass invoked.
#
# Usage: proxy-qualified-reply-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# The fixture writes a fake `claude` script and hands its path to the handler, which
# runs `[ -x ]`/execve on it — both fail with EACCES on a `noexec` mount (this
# container's /tmp is exactly that). Probe each candidate base by running a throwaway
# script there and take the first that works, ending at $HOME (the historical
# exec-capable fallback), mirroring run-test.sh.
tr_base=""
for cand in "${TMPDIR:-}" /var/tmp /tmp "$HOME"; do
  { [ -n "$cand" ] && [ -d "$cand" ] && [ -w "$cand" ]; } || continue
  probe="$(mktemp -d "$cand/.garden-qref-probe.XXXXXX" 2>/dev/null)" || continue
  printf '#!/bin/sh\nexit 0\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null || true
  if [ -x "$probe/x" ] && "$probe/x" 2>/dev/null; then rm -rf "$probe"; tr_base="$cand"; break; fi
  rm -rf "$probe"
done
[ -n "$tr_base" ] || tr_base="$HOME"
TR="$(mktemp -d "$tr_base/.garden-proxy-qref.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
BRANCH=journal2
BARE="$TR/journal.git"

# seed a throwaway origin with the board + inbox structure.
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
dirs=(jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors
      inbox/maintainer/unread inbox/maintainer/read)
( cd "$SEED"; mkdir -p "${dirs[@]}"; for d in "${dirs[@]}"; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + inbox structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=qrefhost GARDEN_STATE="$TR/state" GARDEN_SCRATCH="$TR/scratch"
export GARDEN_POST_ATTEMPTS=50
mkdir -p "$GARDEN_SCRATCH"

place() {  # place <relpath> < body-on-stdin
  local rel="$1" wt; wt="$(mktemp -d "$TR/place.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  mkdir -p "$(dirname "$wt/$rel")"; cat > "$wt/$rel"
  git -C "$wt" add "$rel"
  git -C "$wt" "${git_id[@]}" commit -q -m "place $rel"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
count_glob() {  # count_glob <dir-relpath> <grep-pattern> — matching files in a fresh clone
  local v n; v="$(mktemp -d "$TR/cg.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$v" 2>/dev/null
  n="$(find "$v/$1" -type f -name '*.md' 2>/dev/null | xargs -r grep -l "$2" 2>/dev/null | grep -c . || true)"
  rm -rf "$v"; printf '%s' "$n"
}
has_msg() {  # has_msg <dir-relpath> <grep-pattern> — any file whose CONTENT matches?
  [ "$(count_glob "$1" "$2")" -ge 1 ]
}
has_file() {  # has_file <relpath> — a specific file present in a fresh clone?
  local v r; v="$(mktemp -d "$TR/hf.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$v" 2>/dev/null
  [ -e "$v/$1" ]; r=$?; rm -rf "$v"; return $r
}

# A fake `claude` CLI injected via GARDEN_CLAUDE_BIN. It is invoked as
# `claude -p --dangerously-skip-permissions "<prompt>"`. It distinguishes the
# REPAIR call (prompt contains "ORIGINAL ANSWER") from the first call and emits an
# ANSWER block per the scenario in $QREF_MODE:
#   repair-fixes: first call → bare `#N`; repair call → fully-qualified slug.
#   repair-fails: every call → bare `#N` (the malformed reply never gets fixed).
#   clean:        first call → already fully-qualified (no repair should run).
FAKE="$TR/fake-claude.sh"
cat > "$FAKE" <<'FAKE_EOF'
#!/bin/bash
set -euo pipefail
prompt="${!#}"   # last arg is the prompt
emit() { printf 'ANSWER\n%s\nENDANSWER\n' "$1"; }
case "${QREF_MODE:-}" in
  repair-fixes)
    if printf '%s' "$prompt" | grep -q 'ORIGINAL ANSWER'; then
      emit '(proxy/tentative) proceed; track endojs/endo-but-for-bots#340 as the blocker.'
    else
      emit '(proxy/tentative) proceed; track PR #340 as the blocker.'
    fi ;;
  repair-fails)
    emit '(proxy/tentative) proceed; track PR #340 as the blocker.' ;;
  clean)
    emit '(proxy/tentative) proceed; track endojs/endo-but-for-bots#340 as the blocker.' ;;
  *) echo "fake-claude: unknown QREF_MODE=${QREF_MODE:-}" >&2; exit 2 ;;
esac
FAKE_EOF
chmod +x "$FAKE"
export GARDEN_CLAUDE_BIN="$FAKE"

# Build the digest proxy.sh would hand the handler for one live gating question, and
# seed the matching maintainer message + a LIVE doer inbox so delivery/archival work.
# Returns nothing; sets $DIGEST and uses msgid/doer given.
seed_question() {  # seed_question <msgid> <doer>
  local msgid="$1" doer="$2"
  place "inbox/maintainer/unread/$msgid" <<EOF
from_host: $GARDEN
from: gardener:$doer
reply_to: $doer
sent_at: 2026-08-23T00:00:00Z
---
The upstream PR I depend on is not merged yet — should I keep waiting or pivot?
EOF
  # A live doer inbox makes this a gating question and lets the reply be delivered.
  place "inbox/$doer/unread/.gitkeep" < /dev/null
  DIGEST="$(mktemp "$TR/digest.XXXXXX")"
  {
    printf '===== QUESTION %s =====\n' "$msgid"
    printf 'doer: %s\n' "$doer"
    printf 'reply_to: %s\n' "$doer"
    printf 'The upstream PR I depend on is not merged yet — should I keep waiting or pivot?\n'
    printf '===== END QUESTION %s =====\n\n' "$msgid"
  } > "$DIGEST"
}

run_handler() {  # run_handler <mode> <digest> → sets $RC
  RC=0
  QREF_MODE="$1" "$JOBS/handlers/proxy-claude.sh" "$2" > "$TR/handler.log" 2>&1 || RC=$?
}

# ============================================================================
hr; echo "SUBTEST 1 — a bare-#N reply the REPAIR pass fixes is delivered fully-qualified"; hr
seed_question q1.md gardener-a
run_handler repair-fixes "$DIGEST"
[ "$RC" -eq 0 ] && ok "handler exits 0 (no crash) on a reply repaired to a qualified ref" \
  || { bad "handler exited $RC"; sed 's/^/    /' "$TR/handler.log"; }
has_msg inbox/gardener-a/unread 'endojs/endo-but-for-bots#340' \
  && ok "the fully-qualified, repaired reply was delivered to the gardener" \
  || bad "the repaired reply did not reach the gardener's inbox"
{ ! has_msg inbox/gardener-a/unread 'PR #340' \
  || has_msg inbox/gardener-a/unread 'endojs/endo-but-for-bots#340'; } \
  && ok "the gardener never received the bare-#N malformed reply" \
  || bad "a bare-#N reply leaked into the gardener's inbox"
{ ! has_file inbox/maintainer/unread/q1.md && has_file inbox/maintainer/read/q1.md; } \
  && ok "the maintainer gating message was archived (answered)" \
  || bad "the answered maintainer message was not archived"
has_msg inbox/maintainer/unread 'proxy answered a gating question' \
  && ok "a proxy report was posted back to the maintainer" \
  || bad "no proxy report posted after the answer"

# ============================================================================
hr; echo "SUBTEST 2 — a bare-#N reply that SURVIVES repair is deferred (deduped), not crash-looped"; hr
seed_question q2.md gardener-b
run_handler repair-fails "$DIGEST"
[ "$RC" -eq 0 ] && ok "handler exits 0 — the crash-loop is broken (a valid answer could not be produced)" \
  || { bad "handler exited $RC (this is the crash-loop the fix must prevent)"; sed 's/^/    /' "$TR/handler.log"; }
[ "$(count_glob inbox/gardener-b/unread 'proxy/tentative')" -eq 0 ] \
  && ok "no (malformed) reply was delivered to the gardener" \
  || bad "a reply was delivered despite failing validation"
{ has_file inbox/maintainer/unread/q2.md && ! has_file inbox/maintainer/read/q2.md; } \
  && ok "the gating question is left UNREAD for the maintainer (a true deferral)" \
  || bad "the gating question was archived instead of deferred"
n_notes_1="$(count_glob inbox/maintainer/unread 'could not deliver a valid answer')"
[ "$n_notes_1" -eq 1 ] \
  && ok "exactly one 'could not deliver a valid answer' maintainer note posted" \
  || bad "expected 1 deferral note, found $n_notes_1"
# Re-run the SAME question: the deduplicated note (deterministic GARDEN_MSG_ID) must
# NOT re-pile a second copy — this is what keeps the note from spamming every tick.
run_handler repair-fails "$DIGEST"
[ "$RC" -eq 0 ] && ok "re-run also exits 0 (idempotent, still no crash)" \
  || { bad "re-run exited $RC"; sed 's/^/    /' "$TR/handler.log"; }
n_notes_2="$(count_glob inbox/maintainer/unread 'could not deliver a valid answer')"
[ "$n_notes_2" -eq 1 ] \
  && ok "the deferral note is DEDUPLICATED across runs (still exactly one)" \
  || bad "the deferral note was re-piled ($n_notes_2 copies after a second run)"

# ============================================================================
hr; echo "SUBTEST 3 — a clean reply is delivered unchanged (no needless repair)"; hr
seed_question q3.md gardener-c
run_handler clean "$DIGEST"
[ "$RC" -eq 0 ] && ok "handler exits 0 on a clean reply" \
  || { bad "handler exited $RC"; sed 's/^/    /' "$TR/handler.log"; }
has_msg inbox/gardener-c/unread 'endojs/endo-but-for-bots#340' \
  && ok "the clean, fully-qualified reply was delivered to the gardener" \
  || bad "the clean reply did not reach the gardener"
{ ! has_file inbox/maintainer/unread/q3.md && has_file inbox/maintainer/read/q3.md; } \
  && ok "the maintainer gating message was archived (answered)" \
  || bad "the answered maintainer message was not archived"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
