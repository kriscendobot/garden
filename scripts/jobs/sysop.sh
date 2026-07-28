#!/bin/bash
# sysop.sh — the per-host system-operations daemon (designs/sysop.md).
#
# Usage: sysop.sh        (single per-host instance, driven by garden-sysop.timer)
#
# A DETERMINISTIC, no-LLM consumer of host-directed system operations off the bus.
# It reads this host's `host/<GARDEN>` topic, parses each message against a CLOSED
# operation vocabulary, applies a trust gate BEFORE execution, and delegates each
# op to the EXISTING hardened same-host tool (set-workers.sh, drain-fleet.sh, …) —
# it adds addressing + a gate, never new privileged mechanics. It runs on EVERY
# host (leader and follower alike): the whole point is to drive an UNATTENDED
# FOLLOWER by a message instead of a human sitting at it.
#
# ── Security invariants (designs/sysop.md §5; restated, never relaxed) ─────────
#   1. NEVER execute an arbitrary command or a shell string from a message. There
#      is no `op: shell`/`op: run`/passthrough; the §4 closed set is exhaustive.
#   2. NEVER run claude/an LLM on message content. All parsing + dispatch is plain
#      bash — the gate is deterministic code, before execution, in the shape of the
#      mention-watcher / issue-inbox sender gates. There is not even a downstream
#      LLM step to gate.
#   3. NEVER touch credentials; no op reads/writes/moves any token or gh state.
#   4. NEVER ferry or originate identity_switch_authorized (maintainer-only). No
#      ferry op exists; every journal write here is under the ordinary bot identity
#      via the standard producer clone.
#   5. NEVER run git inside $GARDEN_ROOT. All journal I/O goes through clones under
#      $GARDEN_STATE; the one root-advancing op, `deploy`, delegates to the
#      sanctioned mover deploy-garden.sh and never itself runs git in $GARDEN_ROOT.
#   6. The sysop only ever mutates the host it runs on. Addressing enforces this: a
#      sysop reads only messages aimed at its OWN GARDEN identity, and every write
#      is performed by this host about itself (so set-workers.sh's cross-host
#      refusal passes by construction, never bypassed).
#
# ── Trust model (designs/sysop.md §6) ─────────────────────────────────────────
# The real boundary is journal-push access (the whole fleet); `from_host` is
# self-asserted. On top of that boundary the sysop adds defense-in-depth:
#   * ISSUER GATE (all ops): from_host must be on config/sysop-issuers (default:
#     the leader identity). A stray op from an unexpected host is inert AND visible.
#   * MAINTAINER ATTESTATION (destructive tier only — deploy, unit): the message
#     must carry authorized_by: <login> with <login> on maintainers/allowlist.
#     Attestation, not authentication — its value is that the irreversible tier
#     cannot be triggered by ACCIDENT, only by a message that names a maintainer.
#
# Idempotency (designs/sysop.md §6): every op converges to a target state, so a
# replay is harmless; the out-of-journal seen-marker surfaces each msgid once, and
# the committed sysop-log/<GARDEN>/<msgid>.md record is the belt that survives a
# wiped seen-marker. We mark a message seen AFTER processing (not before) so a tick
# that dies mid-op re-surfaces it rather than losing it; the sysop-log check then
# prevents a double-apply on the re-surface.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="sysop"

# DELIBERATELY NO `fleet_draining && exit` guard (unlike the watchers): a drained
# host MUST still tick the sysop, or it could never receive its own `drain off`
# and the fleet would be WEDGED UNDRAINABLE from the bus — the exact failure this
# daemon exists to prevent (designs/sysop.md §7). The sysop ticks and executes ops
# — especially `drain off` — regardless of the draining marker.

# --- seams (all overridable so the test harness injects deterministic stubs) ---
: "${GARDEN_SYSOP_CLONE:=$GARDEN_STATE/sysop/journal}"        # read clone (msgs/config/allowlist/sysop-log)
: "${GARDEN_SYSOP_SEEN:=$GARDEN_STATE/seen/sysop-$GARDEN}"    # out-of-journal exactly-once cursor
: "${GARDEN_SYSOP_SET_WORKERS:=$HERE/set-workers.sh}"
: "${GARDEN_SYSOP_DRAIN:=$HERE/drain-fleet.sh}"
: "${GARDEN_SYSOP_DEPLOY:=$HERE/deploy-garden.sh}"
: "${GARDEN_SYSOP_REAPER:=$HERE/reaper.sh}"
: "${GARDEN_SYSOP_DEADMAIL:=$HERE/deadmail.sh}"
: "${GARDEN_SYSOP_ACK_SEND:=$HERE/send-msg.sh}"              # ack to host/<from_host>
: "${GARDEN_SYSOP_ACK_INBOX:=$HERE/inbox-send.sh}"          # ack to a live job doer (reply_to: job/<base>)
: "${GARDEN_SYSOP_ISSUERS:=}"                               # override issuer set (file path OR inline ws-separated)
: "${GARDEN_MAINTAINERS_ALLOWLIST:=}"                      # override maintainer allowlist file (else journal)
: "${GARDEN_SYSOP_INSTALLED_UNIT_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user}"
: "${GARDEN_SYSOP_MAIN_HEAD_CMD:=}"                        # test seam: echoes origin main2 HEAD for the deploy to_sha guard

CLONE="$GARDEN_SYSOP_CLONE"

# --- read config: the issuer set (config/sysop-issuers; default = the leader) ---
declare -a ISSUERS=()
load_issuers() {
  ISSUERS=()
  local line src
  if [ -n "$GARDEN_SYSOP_ISSUERS" ]; then
    if [ -f "$GARDEN_SYSOP_ISSUERS" ]; then
      src="file:$GARDEN_SYSOP_ISSUERS"
      while IFS= read -r line; do line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]')"; [ -n "$line" ] && ISSUERS+=("$line"); done < "$GARDEN_SYSOP_ISSUERS"
    else
      src="inline"
      for line in $GARDEN_SYSOP_ISSUERS; do line="${line%%#*}"; [ -n "$line" ] && ISSUERS+=("$line"); done
    fi
  else
    src="journal:config/sysop-issuers"
    while IFS= read -r line; do line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]')"; [ -n "$line" ] && ISSUERS+=("$line"); done \
      < <(git -C "$CLONE" show "origin/$JOURNAL_BRANCH:config/sysop-issuers" 2>/dev/null || true)
  fi
  # Default: the leader identity (the liaison, the human-facing relay, runs there).
  if [ "${#ISSUERS[@]}" -eq 0 ]; then
    local leader; leader="$(leader_host 2>/dev/null || true)"
    [ -n "$leader" ] && ISSUERS+=("$leader")
    src="$src (empty → defaulted to leader '${leader:-<none>}')"
  fi
  log "loaded ${#ISSUERS[@]} issuer(s) from $src"
}
is_issuer() {  # is_issuer <from_host>
  local h="$1" a
  [ -n "$h" ] || return 1
  for a in "${ISSUERS[@]}"; do [ "$a" = "$h" ] && return 0; done
  return 1
}

# --- read config: the maintainer allowlist (destructive-tier attestation) ------
# Same source as the issue inbox: maintainers/allowlist on origin/journal2, one
# login per line, '#' comments, case-insensitive. A file override supplies a fixture.
declare -a MAINTAINERS=()
load_maintainers() {
  MAINTAINERS=()
  local line
  if [ -n "$GARDEN_MAINTAINERS_ALLOWLIST" ] && [ -f "$GARDEN_MAINTAINERS_ALLOWLIST" ]; then
    while IFS= read -r line; do line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"; [ -n "$line" ] && MAINTAINERS+=("$line"); done < "$GARDEN_MAINTAINERS_ALLOWLIST"
  else
    while IFS= read -r line; do line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"; [ -n "$line" ] && MAINTAINERS+=("$line"); done \
      < <(git -C "$CLONE" show "origin/$JOURNAL_BRANCH:maintainers/allowlist" 2>/dev/null || true)
  fi
}
is_maintainer() {  # is_maintainer <login>
  local login="$1" lc a
  [ -n "$login" ] || return 1
  lc="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"
  for a in "${MAINTAINERS[@]}"; do [ "$a" = "$lc" ] && return 0; done
  return 1
}

# --- one message file's fields --------------------------------------------------
# The message is send-msg.sh frontmatter (from_host/from/sent_at/to, then '---',
# then the op body). Keys never collide across header and body (op:, kind:, count:,
# state:, reason:, action:, name:, to_sha:, authorized_by:, reply_to: live in the
# body; from_host:/from:/to: in the header), so a single anchored grep over the whole
# file is unambiguous. `^from:` cannot match `^from_host:` (the ':' anchors it).
MSGFILE=""
field() { sed -n "s/^$1:[[:space:]]*//p" "$MSGFILE" | head -1; }

# --- the durable journal record + the bus ack (designs/sysop.md §8) ------------
# Writes sysop-log/<GARDEN>/<msgid>.md (audit trail AND idempotency belt) via the
# producer clone with a CAS loop, then acks the sender. Best-effort: a record that
# cannot land still acks + marks seen (natural op idempotency covers a lost record).
write_sysop_log() {  # write_sysop_log <msgid> <op> <from_host> <outcome> <detail>
  local msgid="$1" op="$2" fh="$3" outcome="$4" detail="$5"
  local DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  local rel="sysop-log/$GARDEN/$msgid.md" attempt rc
  ensure_clone "$DIR"
  for attempt in $(seq 1 25); do
    sync_clone "$DIR"
    [ -f "$DIR/$rel" ] && return 0                       # already recorded (idempotent)
    mkdir -p "$DIR/sysop-log/$GARDEN"
    {
      printf 'op: %s\n'        "$op"
      printf 'from_host: %s\n' "$fh"
      printf 'host: %s\n'      "$GARDEN"
      printf 'outcome: %s\n'   "$outcome"
      printf 'msgid: %s\n'     "$msgid"
      printf 'detail: %s\n'    "$detail"
      printf 'at: %s\n'        "$(date -u +%FT%TZ)"
    } > "$DIR/$rel"
    git -C "$DIR" add "$rel"
    rc=0; commit_and_push "$DIR" "sysop-log($GARDEN) $msgid $outcome" || rc=$?
    [ "$rc" -eq 0 ] && return 0
    [ "$rc" -eq 2 ] && return 0                          # nothing to commit → already there
    backoff "$attempt"
  done
  log "WARN: could not record sysop-log for $msgid after retries (op idempotency still protects replay)"
  return 1
}

send_ack() {  # send_ack <from_host> <reply_to> <msgid> <op> <outcome> <detail>
  local fh="$1" reply="$2" msgid="$3" op="$4" outcome="$5" detail="$6" bf
  bf="$(mktemp)"
  {
    printf 'sysop_ack: %s\n' "$outcome"
    printf 'op: %s\n'        "$op"
    printf 'host: %s\n'      "$GARDEN"
    printf 'msgid: %s\n'     "$msgid"
    printf 'detail: %s\n'    "$detail"
    printf 'at: %s\n'        "$(date -u +%FT%TZ)"
  } > "$bf"
  if [ -n "$reply" ] && [ "${reply#job/}" != "$reply" ]; then
    GARDEN_SENDER="sysop-$GARDEN" GARDEN_SKIP_REF_CHECK=1 "$GARDEN_SYSOP_ACK_INBOX" "${reply#job/}" "$bf" >/dev/null 2>&1 \
      || log "WARN: ack inbox-send to '$reply' failed (audit record still written)"
  elif [ -n "$fh" ]; then
    GARDEN_SENDER="sysop-$GARDEN" GARDEN_SKIP_REF_CHECK=1 "$GARDEN_SYSOP_ACK_SEND" "host/$fh" "$bf" >/dev/null 2>&1 \
      || log "WARN: ack to 'host/$fh' failed (audit record still written)"
  fi
  rm -f "$bf" 2>/dev/null || true
}

mark_seen() {  # mark_seen <id-line>
  mkdir -p "$(dirname "$GARDEN_SYSOP_SEEN")" 2>/dev/null || true
  printf '%s\n' "$1" >> "$GARDEN_SYSOP_SEEN"
}

# Resolve origin main2 HEAD for the deploy to_sha guard (never touching $GARDEN_ROOT).
origin_main_head() {
  if [ -n "$GARDEN_SYSOP_MAIN_HEAD_CMD" ]; then "$GARDEN_SYSOP_MAIN_HEAD_CMD"; return; fi
  local url; url="$(journal_remote 2>/dev/null || true)"
  [ -n "$url" ] || return 1
  git -C "$CLONE" ls-remote "$url" "refs/heads/$GARDEN_MAIN_BRANCH" 2>/dev/null | awk '{print $1}' | head -1
}

# --- the closed operation vocabulary (designs/sysop.md §4) ----------------------
# Sets OUTCOME + DETAIL and (except deploy, which acks BEFORE self-restart) performs
# the op. OUTCOME ∈ accepted-and-applied | refused | parse-error | failed.
OUTCOME=""; DETAIL=""

dispatch_op() {  # dispatch_op <op> <from_host> <msgid>
  local op="$1" fh="$2" msgid="$3"

  # Destructive tier requires maintainer attestation BEFORE any parse/execute.
  case "$op" in
    deploy|unit)
      local ab; ab="$(field authorized_by)"
      if [ -z "$ab" ]; then OUTCOME="refused"; DETAIL="destructive op '$op' missing authorized_by"; return; fi
      if ! is_maintainer "$ab"; then OUTCOME="refused"; DETAIL="destructive op '$op' authorized_by '$ab' not on maintainers/allowlist"; return; fi
      ;;
  esac

  case "$op" in
    set-workers)
      local kind count
      kind="$(field kind)"; count="$(field count)"
      if [ -z "$kind" ] || ! worker_kinds | grep -qx "$kind"; then
        OUTCOME="parse-error"; DETAIL="set-workers: unknown/missing kind '${kind:-<none>}'"; return
      fi
      if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        OUTCOME="parse-error"; DETAIL="set-workers: missing/invalid count '${count:-<none>}'"; return
      fi
      # Runs ON this host → set-workers.sh writes hosts/<its own GARDEN> and its
      # cross-host refusal + gardener floor-of-1 both stand by construction.
      local rc=0 out
      out="$("$GARDEN_SYSOP_SET_WORKERS" "$kind" "$count" 2>&1)" || rc=$?
      if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="set-workers $kind=$count";
      else OUTCOME="failed"; DETAIL="set-workers $kind=$count rc=$rc: $(printf '%s' "$out" | tail -1)"; fi
      ;;
    drain)
      local state reason
      state="$(field state)"; reason="$(field reason)"
      case "$state" in
        on)  local rc=0; "$GARDEN_SYSOP_DRAIN" on "$reason" >/dev/null 2>&1 || rc=$?
             if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="drain on${reason:+ ($reason)}"; else OUTCOME="failed"; DETAIL="drain on rc=$rc"; fi;;
        off) local rc=0; "$GARDEN_SYSOP_DRAIN" off >/dev/null 2>&1 || rc=$?
             if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="drain off"; else OUTCOME="failed"; DETAIL="drain off rc=$rc"; fi;;
        *)   OUTCOME="parse-error"; DETAIL="drain: state must be on|off (got '${state:-<none>}')";;
      esac
      ;;
    reset-failed)
      local rc=0; unit_ctl reset-failed 'garden-*' >/dev/null 2>&1 || rc=$?
      if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="reset-failed garden-*"; else OUTCOME="failed"; DETAIL="reset-failed rc=$rc"; fi
      ;;
    restore)
      # The DETERMINISTIC recovery one-shots only (designs/sysop.md §4/§9): the
      # liaison-judgement half (poison triage / redispatch) stays with a human.
      local rc=0 steps=()
      unit_ctl reset-failed 'garden-*' >/dev/null 2>&1 && steps+=(reset-failed) || rc=1
      "$GARDEN_SYSOP_REAPER"   >/dev/null 2>&1 && steps+=(reaper)   || rc=1
      "$GARDEN_SYSOP_DEADMAIL" >/dev/null 2>&1 && steps+=(deadmail) || rc=1
      if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="restore: ${steps[*]}"; else OUTCOME="failed"; DETAIL="restore partial: ran ${steps[*]:-none}"; fi
      ;;
    unit)
      local action name
      action="$(field action)"; name="$(field name)"
      case "$action" in start|stop|restart) :;; *) OUTCOME="parse-error"; DETAIL="unit: action must be start|stop|restart (got '${action:-<none>}')"; return;; esac
      case "$name" in
        garden-*.service|garden-*.timer) :;;
        *) OUTCOME="parse-error"; DETAIL="unit: name must match garden-*.{service,timer} (got '${name:-<none>}')"; return;;
      esac
      # Self-preservation: the sysop may never be told to silence itself.
      case "$name" in garden-sysop.service|garden-sysop.timer) OUTCOME="refused"; DETAIL="unit: refusing to $action $name (self-preservation)"; return;; esac
      if [ ! -e "$GARDEN_SYSOP_INSTALLED_UNIT_DIR/$name" ]; then
        OUTCOME="refused"; DETAIL="unit: '$name' is not an installed garden unit"; return
      fi
      local rc=0; unit_ctl "$action" "$name" >/dev/null 2>&1 || rc=$?
      if [ "$rc" -eq 0 ]; then OUTCOME="accepted-and-applied"; DETAIL="unit $action $name"; else OUTCOME="failed"; DETAIL="unit $action $name rc=$rc"; fi
      ;;
    deploy)
      local to_sha; to_sha="$(field to_sha)"
      if [ -n "$to_sha" ]; then
        if ! [[ "$to_sha" =~ ^[0-9a-f]{40}$ ]]; then OUTCOME="parse-error"; DETAIL="deploy: to_sha must be 40-hex (got '$to_sha')"; return; fi
        local head; head="$(origin_main_head 2>/dev/null || true)"
        if [ -n "$head" ] && [ "$head" != "$to_sha" ]; then
          OUTCOME="refused"; DETAIL="deploy: to_sha '$to_sha' != origin/$GARDEN_MAIN_BRANCH HEAD '$head' (stale)"; return
        fi
        # head unresolvable → proceed; deploy-garden.sh deploys the current dev tip
        # and re-records the deployed sha (the to_sha guard is best-effort advisory).
      fi
      # SELF-RESTARTING OP: deploy-garden.sh restarts the fleet (incl. this sysop),
      # so we RECORD + ACK "started" BEFORE invoking it (designs/sysop.md §7). The
      # sender learns "deploy started here" even though the acking process is torn
      # down. Signal to the caller (via OUTCOME) that we already acked.
      OUTCOME="accepted-and-applied"; DETAIL="deploy started (fleet restart imminent)"
      write_sysop_log "$msgid" "$op" "$fh" "$OUTCOME" "$DETAIL" || true
      send_ack "$fh" "$(field reply_to)" "$msgid" "$op" "$OUTCOME" "$DETAIL"
      mark_seen "host/$GARDEN/$msgid.md"
      OUTCOME="__already-acked__"
      "$GARDEN_SYSOP_DEPLOY" >/dev/null 2>&1 || log "WARN: deploy-garden.sh returned non-zero (it manages its own drain/quiesce/abort)"
      ;;
    *)
      OUTCOME="refused"; DETAIL="unknown op '${op:-<none>}'"
      ;;
  esac
}

# =============================================================================
ensure_clone "$CLONE"
sync_clone "$CLONE"          # exits EX_TEMPFAIL on a transient outage (self-heal normalizes)

load_issuers
load_maintainers

mkdir -p "$(dirname "$GARDEN_SYSOP_SEEN")" 2>/dev/null || true
touch "$GARDEN_SYSOP_SEEN"

d="$CLONE/msgs/host/$GARDEN"
if [ ! -d "$d" ]; then
  log "no host ops addressed to $GARDEN (topic empty)"
  exit 0
fi

acted=0; refused=0
for f in $(ls -1 "$d" 2>/dev/null | grep -v -x '.gitkeep' | sort); do
  msgid="${f%.md}"
  idline="host/$GARDEN/$f"
  # Exactly-once: skip if the out-of-journal cursor already surfaced it, OR the
  # committed sysop-log belt already recorded it (survives a wiped seen-marker).
  grep -qxF "$idline" "$GARDEN_SYSOP_SEEN" && continue
  if [ -f "$CLONE/sysop-log/$GARDEN/$msgid.md" ]; then mark_seen "$idline"; continue; fi

  MSGFILE="$d/$f"
  from_host="$(field from_host)"
  op="$(field op)"
  reply_to="$(field reply_to)"

  # ISSUER GATE — deterministic, first, before any op is carried out.
  if ! is_issuer "$from_host"; then
    OUTCOME="refused"; DETAIL="from_host '${from_host:-<none>}' not in sysop-issuers"
    log "REFUSED op '${op:-<none>}' msgid=$msgid: $DETAIL"
    write_sysop_log "$msgid" "${op:-<none>}" "${from_host:-<none>}" "$OUTCOME" "$DETAIL" || true
    send_ack "$from_host" "$reply_to" "$msgid" "${op:-<none>}" "$OUTCOME" "$DETAIL"
    mark_seen "$idline"; refused=$((refused+1)); continue
  fi

  OUTCOME=""; DETAIL=""
  dispatch_op "$op" "$from_host" "$msgid"

  # `deploy` already recorded/acked/marked-seen before self-restarting; skip the tail.
  if [ "$OUTCOME" = "__already-acked__" ]; then acted=$((acted+1)); continue; fi

  case "$OUTCOME" in
    accepted-and-applied) acted=$((acted+1));   log "APPLIED op '$op' msgid=$msgid: $DETAIL";;
    *)                    refused=$((refused+1)); log "$( [ "$OUTCOME" = failed ] && echo FAILED || echo REFUSED ) op '${op:-<none>}' msgid=$msgid ($OUTCOME): $DETAIL";;
  esac
  write_sysop_log "$msgid" "${op:-<none>}" "$from_host" "$OUTCOME" "$DETAIL" || true
  send_ack "$from_host" "$reply_to" "$msgid" "${op:-<none>}" "$OUTCOME" "$DETAIL"
  mark_seen "$idline"
done

log "sysop tick complete on $GARDEN (applied $acted; refused/failed $refused)"
