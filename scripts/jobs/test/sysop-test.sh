#!/bin/bash
# sysop-test.sh — the sysop daemon + host/<GARDEN> bus addressing (designs/sysop.md).
#
# Covers, against throwaway fixtures (no real systemd, no real journal remote):
#   - host/<GARDEN> round-trip send→read (send-msg.sh + read-msgs.sh)
#   - a path-escape address is rejected on BOTH the send and read paths
#   - each benign vocabulary op applied correctly (set-workers, drain, reset-failed,
#     restore, unit) and a destructive op (deploy) applied only with attestation
#   - an unknown op is refused; a parse-error is acked as such
#   - an arbitrary garden host can issue a benign op to another garden host
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
    GARDEN_MAINTAINERS_ALLOWLIST="$MAINT_FILE" \
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
for s in sysop.sh send-host-op.sh pull-local-model.sh root-maintenance.sh send-msg.sh read-msgs.sh; do
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
hr; echo "HOST AUTHORITY — an arbitrary garden host's benign op is accepted"; hr
: > "$REC_LOG"; : > "$ACK_LOG"; : > "$TR/mock-log"; : > "$TR/mock-state"
seed_op "$EVIL" "$TARGET" op=set-workers kind=gardener count=5
run_sysop "$TR/s-evil"
grep -q 'set-workers gardener 5' "$REC_LOG" \
  && ok "arbitrary from_host delegated set-workers to the addressed host" \
  || bad "arbitrary from_host was not dispatched (rec: $(cat "$REC_LOG"))"
grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" \
  && ok "arbitrary from_host op acked applied" || bad "arbitrary from_host op not acked applied"

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

# ============================================================================
hr; echo "LOCAL-MODEL — the async provisioning op's state machine (no real pull)"; hr
# Fixtures: a tier inventory whose `local` rows carry the fourth pull_bytes column,
# and a routing table whose `local` default names the target the op resolves. NOTHING
# below pulls a real model, talks to a real Ollama, or enables a real unit — every
# external effect is a seam stub.
LM_INV="$TR/lm-inventory.tsv"
{ printf 'local\ttestmodel:tiny\tmyrmidon\t1048576\n'
  printf 'local\tothermodel:tiny\tmyrmidon\t2097152\n'; } > "$LM_INV"
LM_INV_NOBYTES="$TR/lm-inventory-nobytes.tsv"
printf 'local\ttestmodel:tiny\tmyrmidon\n' > "$LM_INV_NOBYTES"   # classified but no pull_bytes
LM_ROUTE_A="$TR/lm-route-a.tsv"; printf 'local\ttestmodel*\ttestmodel:tiny\n'   > "$LM_ROUTE_A"
LM_ROUTE_B="$TR/lm-route-b.tsv"; printf 'local\tothermodel*\tothermodel:tiny\n' > "$LM_ROUTE_B"

cat > "$TR/lm-yes.sh"      <<'EOF'
#!/bin/bash
exit 0
EOF
cat > "$TR/lm-no.sh"       <<'EOF'
#!/bin/bash
exit 1
EOF
cat > "$TR/lm-free-big.sh" <<'EOF'
#!/bin/bash
echo 21474836480
EOF
cat > "$TR/lm-free-small.sh" <<'EOF'
#!/bin/bash
echo 1000
EOF
cat > "$TR/lm-active.sh"   <<'EOF'
#!/bin/bash
echo active
EOF
cat > "$TR/lm-inactive.sh" <<'EOF'
#!/bin/bash
echo inactive
EOF
cat > "$TR/lm-pull-start.sh" <<'EOF'
#!/bin/bash
printf 'pull-start\n' >> "$REC_LOG"
EOF
chmod +x "$TR"/lm-*.sh

# Base seams shared by every local-model tick: inventory + routing fixtures, a present
# ollama binary (/bin/true), a reachable endpoint, present=no, big disk, active unit,
# recording pull-start. Individual tests override single tokens by APPENDING (env's
# last assignment wins).
LMBASE="GARDEN_MODEL_TIER_INVENTORY_FILE=$LM_INV GARDEN_MODEL_ROUTING_FILE=$LM_ROUTE_A \
GARDEN_SYSOP_OLLAMA_BIN=/bin/true GARDEN_SYSOP_ENDPOINT_CMD=$TR/lm-yes.sh \
GARDEN_SYSOP_PRESENT_CMD=$TR/lm-no.sh GARDEN_SYSOP_FREE_BYTES_CMD=$TR/lm-free-big.sh \
GARDEN_SYSOP_PULL_START=$TR/lm-pull-start.sh GARDEN_SYSOP_PULL_ACTIVE_CMD=$TR/lm-inactive.sh"

# --- trust gate: destructive tier refused without / with a bad authorized_by -------
: > "$REC_LOG"; : > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model
# shellcheck disable=SC2086
run_sysop "$TR/lm-noauth" $LMBASE
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "local-model without authorized_by refused (no pull started)" || bad "local-model ran without attestation!"
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by=nobody
# shellcheck disable=SC2086
run_sysop "$TR/lm-badauth" $LMBASE
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "local-model authorized_by not on allowlist refused (no pull started)" || bad "forged attestation accepted for local-model"

# --- parse error: a model/tag/url field makes an arbitrary pull unrepresentable ----
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER" model=evil/registry:tag
# shellcheck disable=SC2086
run_sysop "$TR/lm-extra" $LMBASE
{ grep -q 'sysop_ack: parse-error' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "an extra 'model' field is a parse-error (no pull started)" || bad "local-model accepted an extra model field"

# --- fail closed: the local target has no reviewed pull_bytes -----------------------
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/lm-nobytes" $LMBASE GARDEN_MODEL_TIER_INVENTORY_FILE="$LM_INV_NOBYTES"
{ grep -q 'sysop_ack: failed' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "a local target lacking pull_bytes fails closed before any pull" || bad "provisioned a target with no reviewed size"

# --- ollama-absent precondition -----------------------------------------------------
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/lm-noollama" $LMBASE GARDEN_SYSOP_OLLAMA_BIN=ollama-absent-xyz
{ grep -q 'sysop_ack: failed' "$ACK_LOG" && grep -q 'not installed' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "ollama absent → failed precondition (no pull started)" || bad "local-model ran with ollama absent"

# --- endpoint unreachable precondition ---------------------------------------------
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/lm-noendpoint" $LMBASE GARDEN_SYSOP_ENDPOINT_CMD="$TR/lm-no.sh"
{ grep -q 'sysop_ack: failed' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "unreachable garden endpoint → failed precondition (no pull started)" || bad "local-model started with no endpoint"

# --- already-present clean no-op ----------------------------------------------------
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/lm-present" $LMBASE GARDEN_SYSOP_PRESENT_CMD="$TR/lm-yes.sh"
{ grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && grep -q 'already present' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "an already-present target is a clean no-op (no pull, no egress)" || bad "already-present target still started a pull"

# --- insufficient disk refusal (reports observed + required bytes) -----------------
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/lm-nodisk" $LMBASE GARDEN_SYSOP_FREE_BYTES_CMD="$TR/lm-free-small.sh"
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && grep -qE 'free=1000 required=[0-9]+' "$ACK_LOG" && ! grep -qx pull-start "$REC_LOG"; } \
  && ok "insufficient disk refused with observed+required bytes (no pull started)" || bad "local-model started with insufficient disk"

# --- happy path: start (accepted-in-progress) then finalize (accepted-and-applied) --
: > "$ACK_LOG"; : > "$REC_LOG"
LMS="$TR/lm-run"; mkdir -p "$LMS"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# Tick 1: absent + big disk + start stub → freeze the execution record and start.
# shellcheck disable=SC2086
run_sysop "$LMS" $LMBASE GARDEN_SYSOP_PULL_ACTIVE_CMD="$TR/lm-active.sh"
STDIR="$LMS/sysop/local-model"
{ grep -q 'sysop_ack: accepted-in-progress' "$ACK_LOG" && [ "$(grep -c pull-start "$REC_LOG")" -eq 1 ] && [ -f "$STDIR/exec" ]; } \
  && ok "tick 1: pull started, execution frozen, acked accepted-in-progress" \
  || bad "tick 1 did not start the pull correctly (ack: $(cat "$ACK_LOG"); rec: $(cat "$REC_LOG"))"
# Simulate the pull helper finishing successfully (it writes the terminal result).
printf 'outcome: success\nexit: 0\ntail: pulled\nat: now\n' > "$STDIR/result"
# Tick 2: same state dir; poll sees exec+result, re-verifies present=yes → finalize.
: > "$ACK_LOG"
# shellcheck disable=SC2086
run_sysop "$LMS" $LMBASE GARDEN_SYSOP_PRESENT_CMD="$TR/lm-yes.sh"
{ grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && [ ! -f "$STDIR/exec" ]; } \
  && ok "tick 2: pull verified present, finalized accepted-and-applied, execution cleared" \
  || bad "tick 2 did not finalize the pull (ack: $(cat "$ACK_LOG"); exec present: $([ -f "$STDIR/exec" ] && echo yes || echo no))"
# The pull unit is NEVER auto-enabled (no [Install] section).
grep -q '^\[Install\]' "$SRC/garden-local-model-pull.service" \
  && bad "garden-local-model-pull.service has an [Install] section (would be auto-enabled)" \
  || ok "garden-local-model-pull.service carries no [Install] (started on demand only)"

# --- a fast op (drain off) is still processed while a pull is in flight ------------
: > "$ACK_LOG"
LMS2="$TR/lm-run2"; mkdir -p "$LMS2"
seed_op "$ISSUER" "$TARGET" op=local-model authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$LMS2" $LMBASE GARDEN_SYSOP_PULL_ACTIVE_CMD="$TR/lm-active.sh"   # start a pull (stays active, no result)
: > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=drain state=off
# shellcheck disable=SC2086
run_sysop "$LMS2" $LMBASE GARDEN_SYSOP_PULL_ACTIVE_CMD="$TR/lm-active.sh" GARDEN_SYSOP_DRAIN="$JOBS/drain-fleet.sh"
grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" \
  && ok "a fast op (drain off) is processed while the pull is still active (not starved)" \
  || bad "a fast op was starved behind an in-flight pull (ack: $(cat "$ACK_LOG"))"

# ============================================================================
hr; echo "MAINTAIN — the async root-repo gc-lock-escalation op (no real gc/systemd)"; hr
# A recording start stub + a gitdir fixture. NOTHING below runs a real git gc, touches
# $GARDEN_ROOT, or starts a real unit — every external effect is a seam stub.
cat > "$TR/mt-start.sh" <<'EOF'
#!/bin/bash
printf 'maint-start\n' >> "$REC_LOG"
EOF
chmod +x "$TR/mt-start.sh"
MTGD="$TR/mt-gd"; mkdir -p "$MTGD"; rm -f "$MTGD/gc.pid"
# Base seams shared by every maintain tick: an empty gitdir (no lock), a present unit
# (active), and a recording start stub. Individual tests override single tokens.
MTBASE="GARDEN_SYSOP_ROOT_GITDIR=$MTGD GARDEN_SYSOP_MAINT_START=$TR/mt-start.sh \
GARDEN_SYSOP_MAINT_ACTIVE_CMD=$TR/lm-active.sh"

# --- trust gate: destructive tier refused without / with a bad authorized_by -------
: > "$REC_LOG"; : > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=maintain
# shellcheck disable=SC2086
run_sysop "$TR/mt-noauth" $MTBASE
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -qx maint-start "$REC_LOG"; } \
  && ok "maintain without authorized_by refused (no maintenance started)" || bad "maintain ran without attestation!"
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=maintain authorized_by=nobody
# shellcheck disable=SC2086
run_sysop "$TR/mt-badauth" $MTBASE
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && ! grep -qx maint-start "$REC_LOG"; } \
  && ok "maintain authorized_by not on allowlist refused (no maintenance started)" || bad "forged attestation accepted for maintain"

# --- parse error: an extra op field makes an arbitrary repo op unrepresentable -----
: > "$ACK_LOG"; : > "$REC_LOG"
seed_op "$ISSUER" "$TARGET" op=maintain authorized_by="$MAINTAINER" force=1
# shellcheck disable=SC2086
run_sysop "$TR/mt-extra" $MTBASE
{ grep -q 'sysop_ack: parse-error' "$ACK_LOG" && ! grep -qx maint-start "$REC_LOG"; } \
  && ok "an extra 'force' field is a parse-error (no maintenance started)" || bad "maintain accepted an extra field"

# --- pid-still-alive refusal: a LIVE gc lock is refused synchronously, never started -
: > "$ACK_LOG"; : > "$REC_LOG"
printf '3728245 %s\n' "$TARGET" > "$MTGD/gc.pid"     # a lock naming a pid the seam calls LIVE
seed_op "$ISSUER" "$TARGET" op=maintain authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$TR/mt-live" $MTBASE GARDEN_GC_HOLDER_LIVE_CMD="$TR/lm-yes.sh"
{ grep -q 'sysop_ack: refused' "$ACK_LOG" && grep -q 'LIVE git gc' "$ACK_LOG" && ! grep -qx maint-start "$REC_LOG"; } \
  && ok "a lock held by a LIVE git gc is refused synchronously (no unit started)" || bad "maintain clobbered / started against a live gc lock"
rm -f "$MTGD/gc.pid"

# --- happy path: start (accepted-in-progress) then finalize (accepted-and-applied) --
: > "$ACK_LOG"; : > "$REC_LOG"
MTS="$TR/mt-run"; mkdir -p "$MTS"
seed_op "$ISSUER" "$TARGET" op=maintain authorized_by="$MAINTAINER"
# Tick 1: no live lock + start stub → freeze the execution record and start the unit.
# shellcheck disable=SC2086
run_sysop "$MTS" $MTBASE
MTDIR="$MTS/sysop/root-maintenance"
{ grep -q 'sysop_ack: accepted-in-progress' "$ACK_LOG" && [ "$(grep -c maint-start "$REC_LOG")" -eq 1 ] && [ -f "$MTDIR/exec" ]; } \
  && ok "tick 1: maintenance started, execution frozen, acked accepted-in-progress" \
  || bad "tick 1 did not start maintenance correctly (ack: $(cat "$ACK_LOG"); rec: $(cat "$REC_LOG"))"
# Simulate the async worker finishing (it writes the terminal result).
printf 'outcome: applied\ndetail: removed a stale gc.pid lock; git gc then succeeded\nat: now\n' > "$MTDIR/result"
: > "$ACK_LOG"
# shellcheck disable=SC2086
run_sysop "$MTS" $MTBASE
{ grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" && [ ! -f "$MTDIR/exec" ]; } \
  && ok "tick 2: worker result finalized accepted-and-applied, execution cleared" \
  || bad "tick 2 did not finalize maintenance (ack: $(cat "$ACK_LOG"); exec present: $([ -f "$MTDIR/exec" ] && echo yes || echo no))"
# The maintenance unit is NEVER auto-enabled (no [Install] section).
grep -q '^\[Install\]' "$SRC/garden-root-maintenance.service" \
  && bad "garden-root-maintenance.service has an [Install] section (would be auto-enabled)" \
  || ok "garden-root-maintenance.service carries no [Install] (started on demand only)"

# --- a fast op (drain off) is still processed while maintenance is in flight --------
: > "$ACK_LOG"
MTS2="$TR/mt-run2"; mkdir -p "$MTS2"
seed_op "$ISSUER" "$TARGET" op=maintain authorized_by="$MAINTAINER"
# shellcheck disable=SC2086
run_sysop "$MTS2" $MTBASE                                  # start maintenance (stays active, no result)
: > "$ACK_LOG"
seed_op "$ISSUER" "$TARGET" op=drain state=off
# shellcheck disable=SC2086
run_sysop "$MTS2" $MTBASE GARDEN_SYSOP_DRAIN="$JOBS/drain-fleet.sh"
grep -q 'sysop_ack: accepted-and-applied' "$ACK_LOG" \
  && ok "a fast op (drain off) is processed while maintenance is still active (not starved)" \
  || bad "a fast op was starved behind in-flight maintenance (ack: $(cat "$ACK_LOG"))"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
