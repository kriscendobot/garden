#!/bin/bash
# sysop-test.sh — the sysop daemon + host/<GARDEN> bus addressing (designs/sysop.md).
#
# Covers, against throwaway fixtures (no real systemd, no real journal remote):
#   - host/<GARDEN> round-trip send→read (send-msg.sh + read-msgs.sh)
#   - a path-escape address is rejected on BOTH the send and read paths
#   - each benign vocabulary op applied correctly (set-workers, drain, reset-failed,
#     restore, unit) and a destructive op (deploy) applied only with attestation
#   - an unknown op is refused; a parse-error is acked as such
#   - the issuer gate drops an untrusted from_host
#   - a replayed message is NOT double-applied (exactly-once)
#   - a DRAINED host still ticks the sysop and honors `drain off`
#   - the destructive tier is refused without authorized_by, and the sysop refuses
#     to act on garden-sysop.* itself (self-preservation)
#   - the ack + committed audit record distinguish outcomes
#   - the unit is enabled on a follower host (not leader-gated) and carries no
#     ExecCondition=is-main-host, and no drain guard
#   - sysop.sh invokes no claude/LLM
#   - DoD end-to-end: set another host's gardeners count from a different host and
#     show the target's hosts/<GARDEN> updated (cross-host guard satisfied by
#     running ON the target)
#
# Usage: sysop-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SRC="$ROOT/scripts/systemd"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# --- hermetic baseline (mirror run-test.sh: scrub ambient fleet env) ----------
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
export GARDEN_ROOT="$ROOT"

TR=/home/kris/.garden-sysop-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
git_id=(-c user.name=test -c user.email=test@localhost)

ISSUER="hosta-garden-aaaa1111"
TARGET="hostb-garden-bbbb2222"
EVIL="hostx-evil-99999999"
MAINTAINER="kriskowal"

# --- seed the shared origin --------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada msgs hosts config sysop-log maintainers \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada msgs hosts config sysop-log maintainers \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
  printf '%s\n' "$ISSUER" > config/sysop-issuers
  printf '%s\n' "$MAINTAINER" > maintainers/allowlist )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: sysop fixtures"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# --- fixtures: maintainer allowlist file, installed-unit dir, stubs ----------
MAINT_FILE="$TR/maintainers"; printf '%s\n' "$MAINTAINER" > "$MAINT_FILE"
UNIT_DIR="$TR/units"; mkdir -p "$UNIT_DIR"; : > "$UNIT_DIR/garden-foreman.timer"; : > "$UNIT_DIR/garden-sysop.timer"

MOCK="$HERE/mock-systemctl.sh"
ACK_LOG="$TR/acks"; : > "$ACK_LOG"
REC_LOG="$TR/rec"; : > "$REC_LOG"

cat > "$TR/rec-ack.sh" <<'EOF'
#!/bin/bash
{ printf 'ACK dest=%s ' "$1"; grep -hE '^(sysop_ack|detail):' "$2" 2>/dev/null | tr '\n' ' '; printf '\n'; } >> "$ACK_LOG"
EOF
cat > "$TR/rec-setworkers.sh" <<'EOF'
#!/bin/bash
printf 'set-workers %s\n' "$*" >> "$REC_LOG"
EOF
cat > "$TR/rec-reaper.sh" <<'EOF'
#!/bin/bash
printf 'reaper\n' >> "$REC_LOG"
EOF
cat > "$TR/rec-deadmail.sh" <<'EOF'
#!/bin/bash
printf 'deadmail\n' >> "$REC_LOG"
EOF
cat > "$TR/rec-deploy.sh" <<'EOF'
#!/bin/bash
printf 'deploy\n' >> "$REC_LOG"
EOF
chmod +x "$TR"/rec-*.sh

# --- helpers -----------------------------------------------------------------
# Send an op AS a given from_host, through the real send-host-op.sh → send-msg.sh.
seed_op() {  # seed_op <from_host> <target> <key=val>...
  local from="$1" target="$2"; shift 2
  env -i PATH="$PATH" HOME="$HOME" \
    GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="$from" GARDEN_STATE="$TR/state-$from" \
    "$JOBS/send-host-op.sh" "$target" "$@" >/dev/null 2>&1
}

# Run the target host's sysop with the standard test seams. Extra KEY=VAL env may
# be appended as args; delegate seams default to recorders unless overridden.
run_sysop() {  # run_sysop <state-dir> [EXTRA_ENV=VAL ...]
  local state="$1"; shift
  env -i PATH="$PATH" HOME="$HOME" \
    GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="$TARGET" GARDEN_STATE="$state" GARDEN_LEADER="$ISSUER" \
    GARDEN_SYSOP_ISSUERS="$ISSUER" GARDEN_MAINTAINERS_ALLOWLIST="$MAINT_FILE" \
    GARDEN_SYSOP_INSTALLED_UNIT_DIR="$UNIT_DIR" \
    GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$TR/mock-state" GARDEN_MOCK_LOG="$TR/mock-log" \
    GARDEN_SYSOP_ACK_SEND="$TR/rec-ack.sh" GARDEN_SYSOP_ACK_INBOX="$TR/rec-ack.sh" ACK_LOG="$ACK_LOG" REC_LOG="$REC_LOG" \
    GARDEN_SYSOP_SET_WORKERS="$TR/rec-setworkers.sh" \
    GARDEN_SYSOP_REAPER="$TR/rec-reaper.sh" GARDEN_SYSOP_DEADMAIL="$TR/rec-deadmail.sh" \
    GARDEN_SYSOP_DEPLOY="$TR/rec-deploy.sh" GARDEN_SYSOP_MAIN_HEAD_CMD="/bin/true" \
    "$@" \
    "$JOBS/sysop.sh" >>"$TR/sysop.out" 2>&1
}

# Read a committed file back from the bare origin.
from_bare() {  # from_bare <path>
  git -C "$BARE" show "$BRANCH:$1" 2>/dev/null
}

# ============================================================================
hr; echo "STATIC — the scripts parse, and sysop.sh invokes no claude/LLM"; hr
for s in sysop.sh send-host-op.sh send-msg.sh read-msgs.sh; do
  bash -n "$JOBS/$s" && ok "$s parses" || bad "$s has a syntax error"
done
if grep -nE 'claude[ _-]?(-p|bin)|agent_bin|claude_bin|meter_claude' "$JOBS/sysop.sh" >/dev/null; then
  bad "sysop.sh appears to invoke claude/an LLM"
else
  ok "sysop.sh invokes no claude/LLM (deterministic path)"
fi

# ============================================================================
hr; echo "ADDRESS — host/<GARDEN> round-trip send→read, delivered once"; hr
echo "ping the sysop" | env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" \
  JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN="$ISSUER" GARDEN_STATE="$TR/rt-send" \
  "$JOBS/send-msg.sh" "host/$TARGET" >/dev/null 2>&1
out1="$(env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$TARGET" GARDEN_STATE="$TR/rt-read" "$JOBS/read-msgs.sh" "sysop-$TARGET" "host/$TARGET" 2>/dev/null)"; c1=$?
out2="$(env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$TARGET" GARDEN_STATE="$TR/rt-read" "$JOBS/read-msgs.sh" "sysop-$TARGET" "host/$TARGET" 2>/dev/null)"; c2=$?
{ [ "$c1" -eq 1 ] && grep -q 'ping the sysop' <<<"$out1"; } \
  && ok "host/$TARGET message delivered once (count=1, body present)" || bad "round-trip read failed (c1=$c1)"
[ "$c2" -eq 0 ] && ok "the same message is not redelivered (count=0)" || bad "message redelivered (c2=$c2)"

# ============================================================================
hr; echo "ADDRESS — a path-escape address is rejected on send AND read"; hr
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$ISSUER" GARDEN_STATE="$TR/esc" "$JOBS/send-msg.sh" 'host/../../x' </dev/null >/dev/null 2>&1
[ "$?" -ne 0 ] && ok "send-msg.sh rejects host/../../x (no escape from msgs/)" || bad "send-msg.sh ACCEPTED a path-escape address"
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$TARGET" GARDEN_STATE="$TR/esc2" "$JOBS/read-msgs.sh" k 'host/../../x' >/dev/null 2>&1
[ "$?" -ne 0 ] && ok "read-msgs.sh rejects host/../../x (guard on the read side too)" || bad "read-msgs.sh ACCEPTED a path-escape address"

# ============================================================================
hr; echo "ISSUER GATE — an untrusted from_host is dropped (refused, acked, not run)"; hr
: > "$REC_LOG"; : > "$ACK_LOG"; : > "$TR/mock-log"; : > "$TR/mock-state"
seed_op "$EVIL" "$TARGET" op=set-workers kind=gardener count=5
run_sysop "$TR/s-evil"
grep -q '^set-workers' "$REC_LOG" \
  && bad "an untrusted-issuer op was EXECUTED" || ok "untrusted-issuer op not executed"
grep -q 'sysop_ack: refused' "$ACK_LOG" && ok "untrusted-issuer op acked refused" || bad "no refused ack for untrusted issuer"

# ============================================================================
hr; echo "APPLY — set-workers (benign) delegates to set-workers.sh on this host"; hr
: > "$REC_LOG"; : > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=set-workers kind=gardener count=2
run_sysop "$TR/s-sw"
grep -q 'set-workers gardener 2' "$REC_LOG" \
  && ok "set-workers gardener=2 delegated to set-workers.sh (kind count, no host arg)" \
  || bad "set-workers not delegated correctly (rec: $(cat "$REC_LOG"))"
grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && ok "set-workers acked applied" || bad "set-workers not acked applied"

# The op carries no way to name ANOTHER host: the sysop always calls set-workers.sh
# with only <kind> <count>, so the write is always about the host it runs on.
grep -qE 'set-workers gardener 2( |$)' "$REC_LOG" && [ "$(grep -c 'set-workers' "$REC_LOG")" -eq 1 ] \
  && ok "set-workers invoked exactly once, host-scoped (no cross-host arg possible)" || bad "set-workers host-scoping unexpected"

# ============================================================================
hr; echo "APPLY — drain on/off delegates to the REAL drain-fleet.sh (marker toggles)"; hr
: > "$ACK_LOG"
DS="$TR/s-drain"; mkdir -p "$DS"
seed_op "$ISSUER" "$TARGET" op=drain state=on reason='weekly quota'
run_sysop "$DS" GARDEN_SYSOP_DRAIN="$JOBS/drain-fleet.sh"
[ -e "$DS/draining" ] && ok "drain state=on wrote the draining marker" || bad "drain on did not write the marker"

# ============================================================================
hr; echo "DRAIN — a DRAINED host still ticks the sysop and honors drain off"; hr
: > "$ACK_LOG"
# $DS is still drained from above. Seed drain off; the sysop must NOT skip under drain.
seed_op "$ISSUER" "$TARGET" op=drain state=off
run_sysop "$DS" GARDEN_SYSOP_DRAIN="$JOBS/drain-fleet.sh"
[ ! -e "$DS/draining" ] && ok "a drained host executed drain off (marker removed — not wedged)" \
  || bad "drain off NOT honored on a drained host (fleet would be wedged undrainable)"
grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && ok "drain off acked applied while drained" || bad "drain off not acked while drained"

# ============================================================================
hr; echo "APPLY — reset-failed + restore delegate to the recovery one-shots"; hr
: > "$REC_LOG"; : > "$ACK_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=reset-failed
run_sysop "$TR/s-rf"
grep -q "reset-failed garden-\*" "$TR/mock-log" && ok "reset-failed → systemctl reset-failed 'garden-*'" || bad "reset-failed not delegated (mock: $(cat "$TR/mock-log"))"
: > "$REC_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=restore
run_sysop "$TR/s-restore"
{ grep -q "reset-failed garden-\*" "$TR/mock-log" && grep -qx reaper "$REC_LOG" && grep -qx deadmail "$REC_LOG"; } \
  && ok "restore ran reset-failed + reaper + deadmail (deterministic one-shots only)" \
  || bad "restore did not run all three one-shots (mock: $(cat "$TR/mock-log"); rec: $(cat "$REC_LOG"))"

# ============================================================================
hr; echo "REFUSE — unknown op refused; parse-error acked as such"; hr
: > "$REC_LOG"; : > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=frobnicate
run_sysop "$TR/s-unknown"
grep -q 'sysop_ack: refused' "$ACK_LOG" && ok "unknown op 'frobnicate' refused + acked" || bad "unknown op not refused"
: > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=set-workers kind=gardener count=notanumber
run_sysop "$TR/s-parse"
grep -q 'sysop_ack: parse-error' "$ACK_LOG" && ok "invalid set-workers count → parse-error ack" || bad "bad count not a parse-error"

# ============================================================================
hr; echo "DESTRUCTIVE — refused without authorized_by; unit self-preservation"; hr
: > "$REC_LOG"; : > "$ACK_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=deploy
run_sysop "$TR/s-deploy-noauth"
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -qx deploy "$REC_LOG"; } \
  && ok "deploy without authorized_by refused (deploy-garden NOT invoked)" || bad "deploy ran without attestation!"
: > "$ACK_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=unit action=stop name=garden-sysop.timer authorized_by="$MAINTAINER"
run_sysop "$TR/s-selfpreserve"
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -q 'stop garden-sysop.timer' "$TR/mock-log"; } \
  && ok "unit stop garden-sysop.timer refused (self-preservation)" || bad "sysop was told to silence itself!"
# A destructive op with a NON-maintainer authorized_by is refused too.
: > "$ACK_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=unit action=restart name=garden-foreman.timer authorized_by=nobody
run_sysop "$TR/s-badauth"
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -q 'restart garden-foreman.timer' "$TR/mock-log"; } \
  && ok "authorized_by not on maintainers/allowlist → refused" || bad "forged attestation accepted"

# ============================================================================
hr; echo "APPLY — attested unit + deploy (destructive tier, ack before self-restart)"; hr
: > "$REC_LOG"; : > "$ACK_LOG"; : > "$TR/mock-log"
seed_op "$ISSUER" "$TARGET" op=unit action=restart name=garden-foreman.timer authorized_by="$MAINTAINER"
run_sysop "$TR/s-unit"
{ grep -q 'restart garden-foreman.timer' "$TR/mock-log" && grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG"; } \
  && ok "attested unit restart applied + acked" || bad "attested unit restart not applied (mock: $(cat "$TR/mock-log"))"
: > "$REC_LOG"; : > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=deploy authorized_by="$MAINTAINER"
run_sysop "$TR/s-deploy"
{ grep -qx deploy "$REC_LOG" && grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && grep -q 'deploy started' "$ACK_LOG"; } \
  && ok "attested deploy invoked deploy-garden.sh, acked 'started' before restart" || bad "attested deploy path wrong (rec: $(cat "$REC_LOG"); ack: $(cat "$ACK_LOG"))"

# ============================================================================
hr; echo "IDEMPOTENT — a replayed message is not double-applied"; hr
: > "$REC_LOG"; : > "$ACK_LOG"
RS="$TR/s-replay"
seed_op "$ISSUER" "$TARGET" op=set-workers kind=gardener count=3
run_sysop "$RS"          # first tick: applies
run_sysop "$RS"          # second tick (same state): must skip via seen-marker
n="$(grep -c 'set-workers' "$REC_LOG")"
[ "$n" -eq 1 ] && ok "replayed set-workers applied exactly once (n=$n)" || bad "double-apply on replay (n=$n)"
# Belt: even a WIPED seen-marker skips it, because the committed sysop-log record exists.
: > "$REC_LOG"
rm -rf "$RS/seen"
run_sysop "$RS"
[ "$(grep -c 'set-workers' "$REC_LOG")" -eq 0 ] \
  && ok "a wiped seen-marker still skips (committed sysop-log belt)" || bad "belt idempotency failed"

# ============================================================================
hr; echo "AUDIT — every processed op leaves a committed sysop-log/<GARDEN>/ record"; hr
recs="$(git -C "$BARE" ls-tree -r --name-only "$BRANCH" 2>/dev/null | grep -c "^sysop-log/$TARGET/" || true)"
[ "${recs:-0}" -ge 1 ] && ok "sysop-log/$TARGET/ holds $recs committed audit record(s)" || bad "no committed audit records found"

# ============================================================================
hr; echo "DoD END-TO-END — set another host's gardeners count from a different host"; hr
# The motivating case: an operator on host A (the ISSUER) throttles host B (TARGET)
# to 2 gardeners. Here the sysop uses the REAL set-workers.sh (no stub), so the write
# lands in the journal hosts/<TARGET> — proving the cross-host guard is SATISFIED by
# running ON the target (set-workers writes hosts/<its-own-GARDEN>), never bypassed.
: > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=set-workers kind=gardener count=2
run_sysop "$TR/s-e2e" GARDEN_SYSOP_SET_WORKERS="$JOBS/set-workers.sh"
hb="$(from_bare "hosts/$TARGET")"
if grep -q '^gardeners: 2' <<<"$hb"; then
  ok "hosts/$TARGET updated to gardeners: 2 via the real set-workers.sh (pool reconcile follows on B)"
else
  bad "hosts/$TARGET not updated (got: $(tr '\n' ' ' <<<"$hb"))"
fi
grep -q "^updated_by: $TARGET" <<<"$hb" \
  && ok "the write is recorded as BY $TARGET (host wrote its own record — guard satisfied, not bypassed)" \
  || bad "hosts/$TARGET not written by the target itself"

# ============================================================================
hr; echo "UNIT — enabled on a follower, no leader gate, no drain guard"; hr
# Follower = a host whose GARDEN != the leader marker. enable-services must still
# enable garden-sysop.timer (it is NOT leader-gated and NOT monitoring-excluded).
ETR="$TR/enable"; mkdir -p "$ETR"
export GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$ETR/armed" GARDEN_MOCK_LOG="$ETR/log"
: > "$GARDEN_MOCK_STATE"; : > "$GARDEN_MOCK_LOG"
export XDG_CONFIG_HOME="$ETR/config"; DEST="$XDG_CONFIG_HOME/systemd/user"; rm -rf "$DEST"; mkdir -p "$DEST"
for f in "$SRC"/garden-*.service "$SRC"/garden-*.timer; do [ -e "$f" ] && cp "$f" "$DEST/$(basename "$f")"; done
[ -e "$SRC/garden-worker@.service.in" ] && sed -e "s#@GARDEN_ROOT@#$ROOT#g" -e "s#@WORKER_KIND@#gardener#g" "$SRC/garden-worker@.service.in" > "$DEST/garden-gardener@.service"
# Run as a FOLLOWER: GARDEN != GARDEN_LEADER.
GARDEN="$TARGET" GARDEN_LEADER="$ISSUER" "$JOBS/install-units.sh" enable-services >/dev/null 2>&1
grep -qxF 'garden-sysop.timer' "$GARDEN_MOCK_STATE" \
  && ok "garden-sysop.timer enabled on a follower host (runs on every host)" || bad "garden-sysop.timer NOT enabled on a follower"
grep -qE '^ExecCondition=.*is-main-host' "$SRC/garden-sysop.service" \
  && bad "garden-sysop.service is leader-gated (ExecCondition=is-main-host) — must run everywhere" \
  || ok "garden-sysop.service carries no is-main-host ExecCondition (not leader-gated)"
# Strip full-line comments first: sysop.sh MENTIONS fleet_draining in a comment
# (explaining why it deliberately omits the guard); only an EXECUTABLE occurrence
# would be the actual guard.
grep -vE '^[[:space:]]*#' "$JOBS/sysop.sh" | grep -q 'fleet_draining' \
  && bad "sysop.sh has an executable fleet_draining guard (a drained host could not receive drain off)" \
  || ok "sysop.sh has no executable drain guard (ticks under drain, as required)"
unset XDG_CONFIG_HOME GARDEN_UNIT_CTL GARDEN_MOCK_STATE GARDEN_MOCK_LOG

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
