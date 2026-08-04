#!/bin/bash
# sysop.sh — the per-host system-operations daemon (designs/sysop.md).
#
# Usage: sysop.sh        (single per-host instance, driven by garden-sysop.timer)
#
# A DETERMINISTIC, no-LLM consumer of host-directed system operations off the bus.
# It reads this host's `host/<GARDEN>` topic, parses each message against a CLOSED
# operation vocabulary (set-workers, drain, reset-failed, restore, unit, deploy,
# local-model, maintain), applies a trust gate BEFORE execution, and delegates each op to the
# EXISTING hardened same-host tool (set-workers.sh, drain-fleet.sh, …) — it adds
# addressing + a gate, never new privileged mechanics. It runs on EVERY host (leader
# and follower alike): the whole point is to drive an UNATTENDED FOLLOWER by a
# message instead of a human sitting at it.
#
# Most ops are single-tick: the sysop applies them and records one terminal outcome.
# `local-model` is the sole ASYNC op (designs/sysop-local-model.md): it makes the
# host's `local` routing default present in the host's garden Ollama store. A pull is
# tens of gigabytes, so the sysop never runs `ollama pull` inside its own oneshot
# tick — it validates + freezes the request, starts a fixed non-enabled
# garden-local-model-pull.service with --no-block, and each LATER tick polls the
# host-local execution record and reports the transition (accepted-in-progress →
# accepted-and-applied | failed). The target is resolved ON the host from the
# deployed closed inventory; the message carries NO model/tag/url/registry — an
# arbitrary pull is unrepresentable in the vocabulary.
#
# ── Security invariants (designs/sysop.md §5; restated, never relaxed) ─────────
#   1. NEVER execute an arbitrary command or a shell string from a message. There
#      is no `op: shell`/`op: run`/passthrough; the §4 closed set is exhaustive.
#   `maintain` is the second ASYNC op (designs/sysop-repo-maintenance.md): it authorizes
#   root-repo-guard.sh to break a CONFIRMED-STALE git gc.pid lock and run one bounded gc
#   on $GARDEN_ROOT/.git. The sysop does a cheap synchronous liveness precheck (refuse a
#   LIVE gc), then starts the fixed non-enabled garden-root-maintenance.service --no-block
#   and polls its host-local result on later ticks. It never runs git in $GARDEN_ROOT —
#   the guard (the sanctioned root mover) does, via that unit — and never drops history.
#
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
#   * MAINTAINER ATTESTATION (destructive tier only — deploy, unit, local-model, maintain): the
#     message must carry authorized_by: <login> with <login> on maintainers/allowlist.
#     Attestation, not authentication — its value is that the irreversible tier
#     cannot be triggered by ACCIDENT, only by a message that names a maintainer.
#     local-model joins this tier because a tens-of-GiB pull can exhaust a follower's
#     disk and stop its journal consumers, so the issuer gate alone is not
#     proportionate to the consequence (designs/sysop-local-model.md § Decision).
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
# --- local-model op seams (all overridable so the harness drives the async pull
#     state machine with NO real ollama, systemd, or 22 GB download) ---
: "${GARDEN_SYSOP_LOCALMODEL_STATE:=$GARDEN_STATE/sysop/local-model}"  # host-local execution record + terminal result
: "${GARDEN_SYSOP_LOCALMODEL_UNIT:=garden-local-model-pull.service}"   # the fixed, non-enabled async pull unit
: "${GARDEN_SYSOP_OLLAMA_BIN:=ollama}"                     # binary whose presence gates the op (command -v)
: "${GARDEN_SYSOP_ENDPOINT_CMD:=}"                         # test seam: rc0 iff the garden Ollama endpoint responds
: "${GARDEN_SYSOP_PRESENT_CMD:=}"                          # test seam: <target> → rc0 iff endpoint already serves it
: "${GARDEN_SYSOP_FREE_BYTES_CMD:=}"                       # test seam: echoes free bytes on the model-store filesystem
: "${GARDEN_SYSOP_PULL_START:=}"                           # test seam: start the async pull unit (--no-block); rc0 = accepted
: "${GARDEN_SYSOP_PULL_ACTIVE_CMD:=}"                      # test seam: echoes active|inactive for the pull unit
: "${GARDEN_SYSOP_HEARTBEAT_SECONDS:=600}"                 # min seconds between in-progress heartbeat acks
# --- maintain op seams (async root-repo gc-lock escalation; overridable for tests) ---
: "${GARDEN_SYSOP_MAINT_STATE:=$GARDEN_STATE/sysop/root-maintenance}"  # host-local exec/result/attach record
: "${GARDEN_SYSOP_MAINT_UNIT:=garden-root-maintenance.service}"        # the fixed, non-enabled async maintenance unit
: "${GARDEN_SYSOP_ROOT_GITDIR:=$GARDEN_ROOT/.git}"                     # where the root repo's gc.pid lives (PLAIN FILE read; never git in $GARDEN_ROOT)
: "${GARDEN_SYSOP_MAINT_START:=}"                                      # test seam: start the async maint unit (--no-block); rc0 = accepted
: "${GARDEN_SYSOP_MAINT_ACTIVE_CMD:=}"                                 # test seam: echoes active|inactive for the maint unit

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

# update_sysop_log — like write_sysop_log, but OVERWRITES an existing record. Only
# the async local-model op uses it, to move a msgid's record from the non-terminal
# `accepted-in-progress` to its terminal outcome once the pull finishes. Single-tick
# ops never call this (their record is terminal on first write and immutable).
update_sysop_log() {  # update_sysop_log <msgid> <op> <from_host> <outcome> <detail>
  local msgid="$1" op="$2" fh="$3" outcome="$4" detail="$5"
  local DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
  local rel="sysop-log/$GARDEN/$msgid.md" attempt rc
  ensure_clone "$DIR"
  for attempt in $(seq 1 25); do
    sync_clone "$DIR"
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
    [ "$rc" -eq 2 ] && return 0                          # nothing to commit → already at this outcome
    backoff "$attempt"
  done
  log "WARN: could not update sysop-log for $msgid to $outcome after retries"
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

# =============================================================================
# --- the async local-model provisioning op (designs/sysop-local-model.md) -------
# The sysop never runs `ollama pull`. It validates + freezes the request, starts a
# fixed non-enabled unit with --no-block, and each later tick polls the host-local
# execution record. All external effects go through seams the harness overrides.
LM="$GARDEN_SYSOP_LOCALMODEL_STATE"

# The set of BODY keys a local-model message may carry (below the send-msg header).
# A `model`, `tag`, `url`, `registry`, or any other operation field is a parse error,
# so an arbitrary pull is unrepresentable in the vocabulary.
lm_body_has_only_allowed_fields() {  # rc0 iff every body key ∈ {op,authorized_by,reply_to}
  local k
  # Body = everything after the first '---' line send-msg.sh writes.
  while IFS= read -r k; do
    case "$k" in op|authorized_by|reply_to) ;; *) LM_BAD_FIELD="$k"; return 1;; esac
  done < <(sed '1,/^---$/d' "$MSGFILE" | sed -n 's/^\([A-Za-z0-9._-]\{1,\}\):.*/\1/p')
  return 0
}

lm_endpoint_ok() {  # rc0 iff the garden Ollama endpoint responds
  if [ -n "$GARDEN_SYSOP_ENDPOINT_CMD" ]; then "$GARDEN_SYSOP_ENDPOINT_CMD"; return $?; fi
  curl -fsS --max-time 5 "${GARDEN_LOCAL_OLLAMA_URL%/}/models" >/dev/null 2>&1
}

lm_present() {  # lm_present <target> — rc0 iff the endpoint already serves <target>
  if [ -n "$GARDEN_SYSOP_PRESENT_CMD" ]; then "$GARDEN_SYSOP_PRESENT_CMD" "$1"; return $?; fi
  # Reuse the local provider's EXACT presence predicate (incl. the unqualified→:latest
  # normalization) so provisioning and a real hermit job can never disagree.
  declare -F codex_local_model_present >/dev/null 2>&1 \
    || source "$HERE/handlers/codex-provider-common.sh"
  codex_local_model_present "$1"
}

lm_free_bytes() {  # echo free bytes on the filesystem holding the model store
  if [ -n "$GARDEN_SYSOP_FREE_BYTES_CMD" ]; then "$GARDEN_SYSOP_FREE_BYTES_CMD"; return $?; fi
  local dir; dir="$(ollama_models_dir)"
  while [ -n "$dir" ] && [ ! -d "$dir" ]; do
    local up; up="$(dirname "$dir")"; [ "$up" = "$dir" ] && break; dir="$up"
  done
  df -PB1 "$dir" 2>/dev/null | awk 'NR==2{print $4}'
}

lm_pull_start() {  # start the async pull unit --no-block; rc0 = systemd accepted the start
  if [ -n "$GARDEN_SYSOP_PULL_START" ]; then "$GARDEN_SYSOP_PULL_START"; return $?; fi
  unit_ctl start --no-block "$GARDEN_SYSOP_LOCALMODEL_UNIT"
}

lm_pull_active() {  # rc0 iff the pull unit is still active
  local s
  if [ -n "$GARDEN_SYSOP_PULL_ACTIVE_CMD" ]; then s="$("$GARDEN_SYSOP_PULL_ACTIVE_CMD" 2>/dev/null)";
  else s="$(unit_ctl_bounded is-active "$GARDEN_SYSOP_LOCALMODEL_UNIT" 2>/dev/null || true)"; fi
  [ "$s" = active ]
}

lm_exec_get() { sed -n "s/^$1:[[:space:]]*//p" "$LM/exec" 2>/dev/null | head -1; }

# lm_attach <msgid> <from_host> <reply_to> — record a message attached to the active
# execution so poll can finalize (log + ack) every waiter when the pull terminates.
lm_attach() {
  mkdir -p "$LM/attach" 2>/dev/null || true
  { printf 'from_host: %s\n' "$2"; printf 'reply_to: %s\n' "$3"; } > "$LM/attach/$1"
}

# lm_finalize <outcome> <detail> — terminal transition: update every attached msgid's
# sysop-log to <outcome> and send its terminal ack, then clear the execution record.
lm_finalize() {
  local outcome="$1" detail="$2" af m fh rt
  for af in "$LM"/attach/*; do
    [ -e "$af" ] || continue
    m="$(basename "$af")"
    fh="$(sed -n 's/^from_host:[[:space:]]*//p' "$af" | head -1)"
    rt="$(sed -n 's/^reply_to:[[:space:]]*//p'  "$af" | head -1)"
    update_sysop_log "$m" local-model "$fh" "$outcome" "$detail" || true
    send_ack "$fh" "$rt" "$m" local-model "$outcome" "$detail"
  done
  rm -rf "$LM/exec" "$LM/result" "$LM/attach" "$LM/heartbeat_at" 2>/dev/null || true
}

# poll_local_model — advance the async pull at the TOP of every tick, before any new
# message is consumed. Never waits for `ollama pull`; it only reads host-local state
# and the unit's activity, then reports one transition (designs § Async execution).
poll_local_model() {
  [ -f "$LM/exec" ] || return 0                 # no execution in flight
  local target; target="$(lm_exec_get target)"
  if [ -f "$LM/result" ]; then
    local ro rx tail
    ro="$(sed -n 's/^outcome:[[:space:]]*//p' "$LM/result" | head -1)"
    rx="$(sed -n 's/^exit:[[:space:]]*//p'    "$LM/result" | head -1)"
    tail="$(sed -n 's/^tail:[[:space:]]*//p'  "$LM/result" | head -1)"
    if [ "$ro" = success ]; then
      # Independently re-verify presence — a zero exit that did not actually land the
      # model is a failure, not a success (designs § Verifying).
      if lm_present "$target"; then
        log "local-model: $target pulled and verified present"
        lm_finalize accepted-and-applied "pulled and verified $target"
      else
        log "local-model: pull reported success but $target absent after pull"
        lm_finalize failed "pull reported success but $target absent after pull"
      fi
    else
      log "local-model: pull failed for $target (exit ${rx:-?})"
      lm_finalize failed "pull failed (exit ${rx:-?})${tail:+: $tail}"
    fi
    return 0
  fi
  # No terminal result yet. Still running → optional throttled heartbeat. Inactive
  # without a result → the unit died (reboot/kill): a terminal interrupted failure.
  if lm_pull_active; then
    local now last started
    now="$(date +%s 2>/dev/null || echo 0)"
    started="$(lm_exec_get started_epoch)"; : "${started:=$now}"
    last="$(cat "$LM/heartbeat_at" 2>/dev/null || echo 0)"
    if [ "$((now - last))" -ge "$GARDEN_SYSOP_HEARTBEAT_SECONDS" ]; then
      printf '%s\n' "$now" > "$LM/heartbeat_at"
      local af m fh rt
      for af in "$LM"/attach/*; do
        [ -e "$af" ] || continue
        m="$(basename "$af")"
        fh="$(sed -n 's/^from_host:[[:space:]]*//p' "$af" | head -1)"
        rt="$(sed -n 's/^reply_to:[[:space:]]*//p'  "$af" | head -1)"
        send_ack "$fh" "$rt" "$m" local-model accepted-in-progress "pulling $target ($((now - started))s elapsed)"
      done
    fi
  else
    log "local-model: pull unit inactive without a result — interrupted"
    lm_finalize failed "pull interrupted (unit inactive, no result)"
  fi
  return 0
}

# =============================================================================
# --- the async root-repo maintenance op (designs/sysop-repo-maintenance.md) ------
# Same async shape as local-model: the sysop never runs gc inside its tick. It attests +
# prechecks synchronously, starts a fixed non-enabled unit --no-block, and each later
# tick polls the host-local result. root-maintenance.sh delegates to root-repo-guard.sh
# with the authorized gc-lock escalation, so this op grows NO gc logic of its own.
RM="$GARDEN_SYSOP_MAINT_STATE"

maint_start() {  # start the async maint unit --no-block; rc0 = systemd accepted the start
  if [ -n "$GARDEN_SYSOP_MAINT_START" ]; then "$GARDEN_SYSOP_MAINT_START"; return $?; fi
  unit_ctl start --no-block "$GARDEN_SYSOP_MAINT_UNIT"
}
maint_active() {  # rc0 iff the maint unit is still active
  local s
  if [ -n "$GARDEN_SYSOP_MAINT_ACTIVE_CMD" ]; then s="$("$GARDEN_SYSOP_MAINT_ACTIVE_CMD" 2>/dev/null)";
  else s="$(unit_ctl_bounded is-active "$GARDEN_SYSOP_MAINT_UNIT" 2>/dev/null || true)"; fi
  [ "$s" = active ]
}
maint_exec_get() { sed -n "s/^$1:[[:space:]]*//p" "$RM/exec" 2>/dev/null | head -1; }

rm_attach() {  # rm_attach <msgid> <from_host> <reply_to>
  mkdir -p "$RM/attach" 2>/dev/null || true
  { printf 'from_host: %s\n' "$2"; printf 'reply_to: %s\n' "$3"; } > "$RM/attach/$1"
}

# rm_finalize <outcome> <detail> — terminal transition: update every attached msgid's
# sysop-log to <outcome> and send its terminal ack, then clear the execution record.
rm_finalize() {
  local outcome="$1" detail="$2" af m fh rt
  for af in "$RM"/attach/*; do
    [ -e "$af" ] || continue
    m="$(basename "$af")"
    fh="$(sed -n 's/^from_host:[[:space:]]*//p' "$af" | head -1)"
    rt="$(sed -n 's/^reply_to:[[:space:]]*//p'  "$af" | head -1)"
    update_sysop_log "$m" maintain "$fh" "$outcome" "$detail" || true
    send_ack "$fh" "$rt" "$m" maintain "$outcome" "$detail"
  done
  rm -rf "$RM/exec" "$RM/result" "$RM/attach" "$RM/heartbeat_at" "$RM/guard-result" 2>/dev/null || true
}

# poll_root_maintenance — advance an in-flight maintenance run at the TOP of every tick,
# before any new message is consumed, so a terminal ack lands the tick the run finishes
# and a fast op (e.g. drain off) is not starved behind it.
poll_root_maintenance() {
  [ -f "$RM/exec" ] || return 0                 # no maintenance in flight
  if [ -f "$RM/result" ]; then
    local ro detail
    ro="$(sed -n 's/^outcome:[[:space:]]*//p' "$RM/result" | head -1)"
    detail="$(sed -n 's/^detail:[[:space:]]*//p' "$RM/result" | head -1)"
    case "$ro" in
      applied) log "maintain: completed — ${detail:-applied}"; rm_finalize accepted-and-applied "${detail:-maintenance applied}";;
      refused) log "maintain: refused — ${detail:-refused}";   rm_finalize refused "${detail:-refused}";;
      *)       log "maintain: failed — ${detail:-failed}";     rm_finalize failed "${detail:-maintenance failed}";;
    esac
    return 0
  fi
  # No terminal result yet. Active → optional throttled heartbeat. Inactive without a
  # result → the unit died (reboot/kill): a terminal interrupted failure.
  if maint_active; then
    local now last started
    now="$(date +%s 2>/dev/null || echo 0)"
    started="$(maint_exec_get started_epoch)"; : "${started:=$now}"
    last="$(cat "$RM/heartbeat_at" 2>/dev/null || echo 0)"
    if [ "$((now - last))" -ge "$GARDEN_SYSOP_HEARTBEAT_SECONDS" ]; then
      printf '%s\n' "$now" > "$RM/heartbeat_at"
      local af m fh rt
      for af in "$RM"/attach/*; do
        [ -e "$af" ] || continue
        m="$(basename "$af")"
        fh="$(sed -n 's/^from_host:[[:space:]]*//p' "$af" | head -1)"
        rt="$(sed -n 's/^reply_to:[[:space:]]*//p'  "$af" | head -1)"
        send_ack "$fh" "$rt" "$m" maintain accepted-in-progress "root-repo maintenance running ($((now - started))s elapsed)"
      done
    fi
  else
    log "maintain: unit inactive without a result — interrupted"
    rm_finalize failed "root-repo maintenance interrupted (unit inactive, no result)"
  fi
  return 0
}

# =============================================================================
# --- the closed operation vocabulary (designs/sysop.md §4) ----------------------
# Sets OUTCOME + DETAIL and (except deploy, which acks BEFORE self-restart) performs
# the op. OUTCOME ∈ accepted-and-applied | accepted-in-progress | refused |
# parse-error | failed.
OUTCOME=""; DETAIL=""

dispatch_op() {  # dispatch_op <op> <from_host> <msgid>
  local op="$1" fh="$2" msgid="$3"

  # Destructive tier requires maintainer attestation BEFORE any parse/execute.
  case "$op" in
    deploy|unit|local-model|maintain)
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
      # liaison-judgement half (doom triage / redispatch) stays with a human.
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
    local-model)
      # ASYNC provisioning (designs/sysop-local-model.md). Attestation is already
      # verified above. Every check below fails CLOSED before network/unit activity.
      # 1. The message may carry NO operation field but authorized_by/reply_to.
      LM_BAD_FIELD=""
      if ! lm_body_has_only_allowed_fields; then
        OUTCOME="parse-error"; DETAIL="local-model: unexpected field '${LM_BAD_FIELD}' (op takes only authorized_by; no model/tag/url/registry)"; return
      fi
      # 2. Resolve + validate the target from the deployed closed inventory.
      local target tier pull_bytes
      target="$(model_routing_default local 2>/dev/null || true)"
      if [ -z "$target" ]; then OUTCOME="failed"; DETAIL="local-model: no 'local' routing default configured"; return; fi
      if ! tier="$(model_dispatch_tier local "$target" 2>/dev/null)" || [ -z "$tier" ]; then
        OUTCOME="failed"; DETAIL="local-model: target '$target' is not classified in model-tier-inventory.tsv (deploy corrected inventory)"; return
      fi
      if ! pull_bytes="$(model_pull_bytes local "$target" 2>/dev/null)" || ! [[ "$pull_bytes" =~ ^[0-9]+$ ]]; then
        OUTCOME="failed"; DETAIL="local-model: target '$target' has no reviewed pull_bytes in the inventory (deploy corrected inventory)"; return
      fi
      # 3. Preconditions: the ollama binary, then the reachable garden endpoint.
      if ! command -v "$GARDEN_SYSOP_OLLAMA_BIN" >/dev/null 2>&1; then
        OUTCOME="failed"; DETAIL="local-model: '$GARDEN_SYSOP_OLLAMA_BIN' not installed (a host-image operation, not a sysop op)"; return
      fi
      if ! lm_endpoint_ok; then
        OUTCOME="failed"; DETAIL="local-model: garden Ollama endpoint ($GARDEN_LOCAL_OLLAMA_URL) unreachable — establish it first (set-workers hermit N>0, or attested unit start garden-ollama.service); hermits:0 keeps it disabled"; return
      fi
      # 4. Already served → clean terminal no-op; no pull unit, no egress.
      if lm_present "$target"; then
        OUTCOME="accepted-and-applied"; DETAIL="already present ($target)"; return
      fi
      # 5. Disk preflight: free >= pull_bytes + max(10 GiB, pull_bytes/4).
      local free head required tenGiB
      free="$(lm_free_bytes 2>/dev/null || true)"
      if ! [[ "$free" =~ ^[0-9]+$ ]]; then
        OUTCOME="failed"; DETAIL="local-model: could not determine free bytes on the model store"; return
      fi
      tenGiB=$((10 * 1024 * 1024 * 1024))
      head=$(( pull_bytes / 4 )); [ "$head" -lt "$tenGiB" ] && head=$tenGiB
      required=$(( pull_bytes + head ))
      if [ "$free" -lt "$required" ]; then
        OUTCOME="refused"; DETAIL="local-model: insufficient disk for $target — free=$free required=$required (pull_bytes=$pull_bytes)"; return
      fi
      # 6. Serialize on a host-local lock: attach to an active same-target pull, refuse
      #    a different target as busy, else freeze the record and start the unit.
      mkdir -p "$LM" 2>/dev/null || true
      exec 9>"$LM/lock" || { OUTCOME="failed"; DETAIL="local-model: cannot open host-local lock"; return; }
      flock 9
      if [ -f "$LM/exec" ]; then
        local active; active="$(lm_exec_get target)"
        if [ "$active" = "$target" ]; then
          lm_attach "$msgid" "$fh" "$(field reply_to)"
          OUTCOME="accepted-in-progress"; DETAIL="attached to active pull of $target"
        else
          OUTCOME="refused"; DETAIL="local-model: busy pulling '$active'; refusing '$target' (one pull at a time; never retarget)"
        fi
        flock -u 9; return
      fi
      # Freeze the execution record, then start the async pull with --no-block.
      local inv_digest dep_sha now
      inv_digest="$( (sha1sum 2>/dev/null || shasum) < "$(_model_tier_inventory_file)" | cut -c1-16 )"
      dep_sha="$(deployed_sha 2>/dev/null || true)"
      now="$(date +%s 2>/dev/null || echo 0)"
      {
        printf 'target: %s\n'          "$target"
        printf 'tier: %s\n'            "$tier"
        printf 'pull_bytes: %s\n'      "$pull_bytes"
        printf 'inventory_digest: %s\n' "$inv_digest"
        printf 'deployed_sha: %s\n'    "$dep_sha"
        printf 'started_at: %s\n'      "$(date -u +%FT%TZ)"
        printf 'started_epoch: %s\n'   "$now"
      } > "$LM/exec.tmp" && mv -f "$LM/exec.tmp" "$LM/exec"
      lm_attach "$msgid" "$fh" "$(field reply_to)"
      local rc=0; lm_pull_start >/dev/null 2>&1 || rc=$?
      if [ "$rc" -ne 0 ]; then
        rm -rf "$LM/exec" "$LM/attach" 2>/dev/null || true
        OUTCOME="failed"; DETAIL="local-model: systemd rejected the pull start (rc=$rc)"
      else
        OUTCOME="accepted-in-progress"; DETAIL="pull started for $target (tier $tier, $pull_bytes bytes)"
      fi
      flock -u 9
      ;;
    maintain)
      # ASYNC root-repo maintenance (designs/sysop-repo-maintenance.md). Attestation is
      # already verified above. Delegates to root-repo-guard.sh's gc-lock escalation via
      # the async unit; grows no gc logic of its own.
      # 1. The message may carry NO operation field but authorized_by/reply_to.
      LM_BAD_FIELD=""
      if ! lm_body_has_only_allowed_fields; then
        OUTCOME="parse-error"; DETAIL="maintain: unexpected field '${LM_BAD_FIELD}' (op takes only authorized_by; no path/ref/force — an arbitrary repo op is unrepresentable)"; return
      fi
      # 2. Synchronous cheap precheck: refuse immediately if a LIVE git gc holds the
      #    root's gc.pid lock. Reads a PLAIN FILE ($GARDEN_ROOT/.git/gc.pid) — never runs
      #    git in $GARDEN_ROOT (the guard, via the async unit, is the sanctioned actor).
      local lockline lpid lhost
      lockline="$(read_gc_lock "$GARDEN_SYSOP_ROOT_GITDIR")"
      lpid="${lockline%% *}"; lhost="${lockline#* }"; [ "$lhost" = "$lpid" ] && lhost=""
      if [ -n "$lpid" ] && gc_lock_holder_alive "$lpid"; then
        OUTCOME="refused"; DETAIL="maintain: a LIVE git gc holds $GARDEN_SYSOP_ROOT_GITDIR/gc.pid (pid $lpid${lhost:+ host $lhost}); not clobbering it. If it is wedged, kill it by hand and re-issue."; return
      fi
      # 3. Serialize on a host-local lock: attach to an in-flight run (maintenance is
      #    idempotent — no distinct target), else freeze the record and start the unit.
      mkdir -p "$RM" 2>/dev/null || true
      exec 8>"$RM/lock" || { OUTCOME="failed"; DETAIL="maintain: cannot open host-local lock"; return; }
      flock 8
      if [ -f "$RM/exec" ]; then
        rm_attach "$msgid" "$fh" "$(field reply_to)"
        OUTCOME="accepted-in-progress"; DETAIL="attached to an in-flight root-repo maintenance run"
        flock -u 8; return
      fi
      local now
      now="$(date +%s 2>/dev/null || echo 0)"
      {
        printf 'requested_at: %s\n'  "$(date -u +%FT%TZ)"
        printf 'started_epoch: %s\n' "$now"
        printf 'gitdir: %s\n'        "$GARDEN_SYSOP_ROOT_GITDIR"
      } > "$RM/exec.tmp" && mv -f "$RM/exec.tmp" "$RM/exec"
      rm -f "$RM/result" "$RM/guard-result" 2>/dev/null || true
      rm_attach "$msgid" "$fh" "$(field reply_to)"
      local rc=0; maint_start >/dev/null 2>&1 || rc=$?
      if [ "$rc" -ne 0 ]; then
        rm -rf "$RM/exec" "$RM/attach" 2>/dev/null || true
        OUTCOME="failed"; DETAIL="maintain: systemd rejected the maintenance start (rc=$rc)"
      else
        OUTCOME="accepted-in-progress"; DETAIL="root-repo maintenance started (authorized gc-lock escalation)"
      fi
      flock -u 8
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

# Advance any in-flight async local-model pull BEFORE consuming new messages, so a
# terminal ack lands the tick the pull finishes and a fast op (e.g. drain off) is not
# starved behind it. Polling never waits for `ollama pull` (designs § Async execution).
poll_local_model
# Likewise advance an in-flight root-repo maintenance run (designs/sysop-repo-maintenance.md);
# polling never waits for gc — it only reads the host-local terminal result.
poll_root_maintenance

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
  # Acks are addressed back to the issuing host so an operator can observe them;
  # they are not new operations.  In particular, an ack for `op: deploy` must
  # never be parsed as a destructive deploy request and acked again.
  if [ -n "$(field sysop_ack)" ]; then
    mark_seen "$idline"
    continue
  fi
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
    accepted-in-progress) acted=$((acted+1));   log "IN-PROGRESS op '$op' msgid=$msgid: $DETAIL (a later tick finalizes)";;
    *)                    refused=$((refused+1)); log "$( [ "$OUTCOME" = failed ] && echo FAILED || echo REFUSED ) op '${op:-<none>}' msgid=$msgid ($OUTCOME): $DETAIL";;
  esac
  # For accepted-in-progress this writes a NON-terminal record + in-progress ack; the
  # poll step updates it to a terminal outcome once the pull finishes. All other
  # outcomes are terminal here (write_sysop_log will not overwrite an existing record).
  write_sysop_log "$msgid" "${op:-<none>}" "$from_host" "$OUTCOME" "$DETAIL" || true
  send_ack "$from_host" "$reply_to" "$msgid" "${op:-<none>}" "$OUTCOME" "$DETAIL"
  mark_seen "$idline"
done

log "sysop tick complete on $GARDEN (applied $acted; refused/failed $refused)"
