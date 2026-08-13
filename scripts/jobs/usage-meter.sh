#!/bin/bash
# usage-meter.sh — a deterministic weekly token meter for the fleet, sourced from
# Claude Code's own session logs (ccusage-style).
#
# Source this; do not execute it. common.sh sources it so every job-board script
# (and any `claude -p` handler) inherits the helpers.
#
# WHY this exists: the foreman is where the garden spends tokens autonomously — it
# promotes deferred plan jobs and generates new milestone steps via `claude -p`,
# each of which can ignite a full design/build/panel chain. Before that pump the
# foreman must check, in PLAIN CODE with NO LLM, whether the garden is at risk of
# hitting its weekly token quota, and back off if so.
#
# THE BILLING MODEL: the WHOLE fleet runs `claude -p` on a SINGLE Claude Max x20
# subscription — NOT an API key. The Admin Usage & Cost API
# (/v1/organizations/usage_report) is API-key / Console-billing only and does NOT
# apply to a subscription, so it is deliberately NOT wired here.
#
# THE USAGE SOURCE (primary, authoritative):
#   Claude Code already records every assistant turn's token `usage` to its own
#   session logs at ~/.claude/projects/**/*.jsonl. Each assistant-turn line carries
#   a top-level `.timestamp` (ISO-8601) and a `.message.usage` object with
#   `input_tokens`, `output_tokens`, `cache_creation_input_tokens`, and
#   `cache_read_input_tokens`. meter_window_total sums BILLABLE tokens over the
#   trailing window from these logs — deterministically, in plain code (jq over the
#   JSONL). This is the same data ccusage reads; it needs no API key and no
#   external dashboard. The session logs are the SINGLE SOURCE OF TRUTH for "tokens
#   spent in the trailing window".
#
#   DEDUP: a single assistant message id appears on MULTIPLE log lines (one per
#   streamed content block), each repeating the message's final `usage`. We dedup
#   by message id (first occurrence wins) so re-reads never double-count.
#
#   BILLABLE definition: input + output + cache_creation (cache_read EXCLUDED — it
#   bills at a small fraction and would otherwise dominate the sum and trip the
#   back-off far too early). This matches how the Max plan's spend tracks most
#   closely. To adjust, set GARDEN_TOKEN_COUNT_CACHE_READ=1 to also fold in
#   cache_read_input_tokens (the most likely tuning knob); the formula itself lives
#   in _meter_session_total and is a one-line change otherwise.
#
# THE LEDGER (optional fallback ONLY):
#   The hand-/handler-appended TSV ledger (meter_record / meter_claude, below) is
#   retained as a FALLBACK consulted only when the session-log directory is missing
#   or unreadable. It is no longer the primary source. Ledger format (TSV,
#   append-only, host-local): <epoch-seconds>\t<billable-tokens>.
#
# MULTI-HOST: ~/.claude is PER-HOST, but the Max x20 weekly quota is GLOBAL to the
# subscription. The current design is a documented SINGLE-HOST assumption
# (endolinbot is the only `claude -p` spender). If the fleet ever spends on more
# than one host sharing the one subscription, this per-host sum UNDERCOUNTS.
#   TODO(multi-host): aggregate across hosts via the journal — each host publishes
#   its trailing-window total to a journal path and the meter sums them. Until then
#   a single host is assumed; widening to N hosts without aggregation silently
#   undercounts and would back off too late.
#
# THE WEEK BOUNDARY: a rolling trailing window (default 7 days), NOT a fixed
# calendar reset, because the subscription's actual weekly-reset cadence is not
# machine-readable to the fleet (OPEN QUESTION — Claude Code `/usage` shows the
# reset; if it becomes known, set GARDEN_TOKEN_WINDOW_SECS and/or teach
# meter_window_total a calendar cutoff). A trailing window is the safe default: it
# can only OVER-count relative to a fixed reset (an event 6 days before a reset
# still counts for one more day), so it errs toward backing off slightly early.
#
# FAIL-OPEN: a missing or unreadable meter must NEVER wedge the pump. When the
# quota is unset the meter is simply OFF (gating disabled). When the quota is set
# but neither source can be read, meter_quota_status returns `unknown` and the
# caller proceeds with a logged warning — a broken meter can slow nothing to a
# halt. Only a CONFIRMED at/over-high-water reading backs the pump off.
#
# All helpers are best-effort and never abort their caller (callers run under
# `set -e`); recording failures are swallowed, reads degrade to `unknown`.

# --- configuration (all overridable) ----------------------------------------

# The weekly token ceiling. UNSET/0 means the meter is OFF (no gating) — the safe
# default until the maintainer sets the real Max x20 ceiling for this fleet (it is
# not machine-readable from the subscription; surface it as an open question and
# wire it via the foreman unit env / a journal-tracked config). See the foreman
# unit (scripts/systemd/garden-foreman.service) for where to set it.
: "${GARDEN_TOKEN_WEEKLY_QUOTA:=0}"
# High-water mark as a fraction of the quota; at/over this the foreman backs off.
: "${GARDEN_TOKEN_BACKOFF_FRACTION:=0.85}"
# The rolling window, in seconds (default 7 days). See "THE WEEK BOUNDARY" above.
: "${GARDEN_TOKEN_WINDOW_SECS:=604800}"
# PRIMARY SOURCE: Claude Code's session-log directory (per-host). Overridable for
# tests and for a non-default ~/.claude location.
: "${GARDEN_CCUSAGE_LOGDIR:=${HOME:-/home/$(id -un 2>/dev/null || echo kris)}/.claude/projects}"
# Set to 1 to also count cache_read_input_tokens as billable (default: excluded).
: "${GARDEN_TOKEN_COUNT_CACHE_READ:=0}"
# FALLBACK SOURCE: the host-local rolling ledger. Outside any reset-prone worktree.
: "${GARDEN_USAGE_LEDGER:=$GARDEN_STATE/usage/ledger}"
# Soft cap on ledger lines before an opportunistic prune of out-of-window rows.
: "${GARDEN_USAGE_LEDGER_MAXLINES:=20000}"

# Wall clock in epoch seconds, overridable for deterministic tests.
meter_now() { printf '%s\n' "${GARDEN_USAGE_NOW:-$(date +%s)}"; }

# meter_record <billable-tokens> — append one usage event to the FALLBACK ledger.
# Ignores empty/non-integer/zero input. Atomic append; never fails the caller.
# (The ledger is a fallback only; the primary source is the session logs.)
meter_record() {
  local tokens="${1:-}" ledger="$GARDEN_USAGE_LEDGER" n
  case "$tokens" in ''|*[!0-9]*) return 0 ;; esac
  [ "$tokens" -gt 0 ] || return 0
  mkdir -p "$(dirname "$ledger")" 2>/dev/null || return 0
  printf '%s\t%s\n' "$(meter_now)" "$tokens" >> "$ledger" 2>/dev/null || true
  # Opportunistic prune so the ledger cannot grow without bound.
  n="$(wc -l < "$ledger" 2>/dev/null || echo 0)"
  [ "${n:-0}" -gt "$GARDEN_USAGE_LEDGER_MAXLINES" ] && meter_prune
  return 0
}

# meter_prune — drop ledger rows older than the window. Guarded by a non-blocking
# flock so a concurrent recorder is never disturbed (skip the prune rather than
# block); a rare lost prune just defers cleanup to a later append. Best-effort.
meter_prune() {
  local ledger="$GARDEN_USAGE_LEDGER" lf cutoff tmp fd
  [ -f "$ledger" ] || return 0
  lf="${ledger}.lock"
  exec {fd}>>"$lf" 2>/dev/null || return 0
  if flock -n "$fd"; then
    cutoff=$(( "$(meter_now)" - GARDEN_TOKEN_WINDOW_SECS ))
    tmp="$(mktemp "${ledger}.XXXXXX" 2>/dev/null)" || { exec {fd}>&- 2>/dev/null || true; return 0; }
    if awk -F'\t' -v c="$cutoff" '($1+0)>=c' "$ledger" > "$tmp" 2>/dev/null; then
      mv -f "$tmp" "$ledger" 2>/dev/null || rm -f "$tmp" 2>/dev/null
    else
      rm -f "$tmp" 2>/dev/null
    fi
  fi
  exec {fd}>&- 2>/dev/null || true
  return 0
}

# _meter_session_total <logdir> <cutoff-epoch> — sum BILLABLE tokens from Claude
# Code session JSONL under <logdir>, deduped by message id (first occurrence
# wins), counting only assistant turns whose timestamp epoch is >= <cutoff>.
# Prints the integer sum on stdout. Returns:
#   0 with <sum>  on a successful scan (sum may legitimately be 0),
#   1             on a tooling error (no jq, find failed) → unknown upstream.
# Resilient to individual malformed log lines (jq -R 'fromjson? // empty' skips
# them) so one corrupt line never blinds the meter.
_meter_session_total() {
  local logdir="$1" cutoff="$2" inccr listing rc sum
  command -v jq >/dev/null 2>&1 || return 1   # cannot parse JSON → unknown (fail open)

  # Normalize the cache_read toggle to a strict 0/1 for jq --argjson.
  case "${GARDEN_TOKEN_COUNT_CACHE_READ:-0}" in 1|true|yes|on) inccr=1 ;; *) inccr=0 ;; esac

  # Only files modified at/after the cutoff can hold in-window turns (logs are
  # append-only with monotonically increasing timestamps), so prune by mtime to
  # bound the scan over what may be thousands of session files. find exits non-zero
  # if the dir is unreadable or -newermt is unsupported → treat as unknown.
  listing="$(find "$logdir" -maxdepth 6 -type f -name '*.jsonl' -newermt "@$cutoff" 2>/dev/null)"; rc=$?
  [ "$rc" -ne 0 ] && return 1
  [ -z "$listing" ] && { printf '0\n'; return 0; }   # no in-window logs → genuine 0

  # Per-line: parse (skipping malformed), keep assistant turns carrying usage,
  # emit  <message-id>\t<epoch>\t<billable-tokens>. Strip fractional seconds before
  # fromdateiso8601 (jq 1.7 cannot parse ".506Z"); a missing/unparseable timestamp
  # yields -1 so it falls out of any positive-cutoff window.
  sum="$(printf '%s\n' "$listing" | tr '\n' '\0' | xargs -0 jq -Rr --argjson cr "$inccr" '
            fromjson? // empty
            | select(.type=="assistant" and (.message.usage != null))
            | [ (.message.id // .uuid // "noid"),
                ((.timestamp // "") | sub("\\.[0-9]+Z$";"Z") | (fromdateiso8601? // -1)),
                ( (.message.usage.input_tokens // 0)
                  + (.message.usage.output_tokens // 0)
                  + (.message.usage.cache_creation_input_tokens // 0)
                  + (if $cr == 1 then (.message.usage.cache_read_input_tokens // 0) else 0 end) ) ]
            | @tsv' 2>/dev/null \
        | awk -F'\t' -v c="$cutoff" '
            !seen[$1]++ { if (($2 + 0) >= c) s += ($3 + 0) }
            END { printf "%d\n", s + 0 }')"
  case "$sum" in ''|*[!0-9]*) return 1 ;; esac
  printf '%s\n' "$sum"
  return 0
}

# meter_window_total [<window-secs>] — sum billable tokens within the trailing
# window. Prefers Claude Code session logs (primary); falls back to the legacy
# ledger only if the log dir is missing/unreadable. Prints the integer total.
# Returns:
#   0 with <sum> when a source was read OK (sum may be 0),
#   1            when no source could be read (→ `unknown` upstream → fail open).
meter_window_total() {
  local window="${1:-$GARDEN_TOKEN_WINDOW_SECS}" now cutoff ledger
  now="$(meter_now)"; case "$now" in ''|*[!0-9]*) return 1 ;; esac
  cutoff=$(( now - window ))

  # PRIMARY: Claude Code session logs.
  if [ -d "$GARDEN_CCUSAGE_LOGDIR" ] && [ -r "$GARDEN_CCUSAGE_LOGDIR" ] && [ -x "$GARDEN_CCUSAGE_LOGDIR" ]; then
    _meter_session_total "$GARDEN_CCUSAGE_LOGDIR" "$cutoff" && return 0
    # session scan failed (no jq / find error) → try the ledger, else unknown.
  fi

  # FALLBACK: the legacy handler-appended ledger.
  ledger="$GARDEN_USAGE_LEDGER"
  if [ -f "$ledger" ] && [ -r "$ledger" ]; then
    awk -F'\t' -v c="$cutoff" '($1+0)>=c { s += ($2+0) } END { printf "%d\n", s+0 }' "$ledger" 2>/dev/null && return 0
    return 1
  fi

  # Neither source available → unknown (fail open upstream).
  return 1
}

# meter_quota_status — the one deterministic verdict the foreman gates on. Prints
# exactly one word and always returns 0:
#   off      — no quota configured; gating disabled (proceed silently).
#   unknown  — quota set but the meter could not be read (proceed, but WARN).
#   ok       — under the high-water mark (proceed).
#   backoff  — at/over the high-water mark (pause the pump).
meter_quota_status() {
  local quota="${GARDEN_TOKEN_WEEKLY_QUOTA:-0}" frac="${GARDEN_TOKEN_BACKOFF_FRACTION:-0.85}" total
  case "$quota" in ''|0|*[!0-9]*) printf 'off\n'; return 0 ;; esac
  total="$(meter_window_total)" || { printf 'unknown\n'; return 0; }
  if awk -v t="$total" -v q="$quota" -v f="$frac" 'BEGIN { exit !(t >= q*f) }'; then
    printf 'backoff\n'
  else
    printf 'ok\n'
  fi
}

# meter_claude [<claude-args>...] — run `claude` in print mode, RECORD the call's
# billable token usage to the FALLBACK ledger, and print the model's result text on
# stdout (a drop-in for `claude -p <args>`: same stdout contract).
#
# NOTE: the primary meter source is now Claude Code's own session logs, which
# `claude -p` writes regardless of whether the call goes through meter_claude. So
# meter_claude's ledger append is now BELT-AND-SUSPENDERS for the fallback path,
# not the load-bearing record. It remains a safe drop-in.
#
# Fail-open by construction: if `jq` is absent we cannot parse the JSON envelope,
# so we fall back to plain `claude -p` (text output, no recording) rather than
# break the handler. A non-zero claude exit is passed through unrecorded.
#
# Caveat: do not pass your own --output-format; meter_claude sets json itself.
meter_claude() {
  # Resolve the CLI through the shared resolver (PATH, then the known install
  # locations — common.sh § agent-CLI resolution) rather than trusting the
  # inherited PATH; a single probe, since every caller here already treats an
  # unavailable provider as a soft skip. Falls back to the bare name if this file
  # is ever sourced without common.sh.
  local cli; cli="$(claude_bin_now 2>/dev/null || true)"; : "${cli:=claude}"
  if ! command -v jq >/dev/null 2>&1; then
    log "usage-meter: jq absent; running claude UNMETERED (fail-open)"
    "$cli" -p "$@"
    return $?
  fi
  local json rc toks result
  # Capture the rc through an `if`: a bare `json="$(claude …)"; rc=$?` dies AT
  # THE ASSIGNMENT under a caller's `set -e` when claude exits non-zero, so the
  # documented pass-through-with-log branch below was dead code and the caller
  # (foreman-claude.sh) crashed with no output and no diagnostic instead.
  if json="$("$cli" -p --output-format json "$@")"; then rc=0; else rc=$?; fi
  if [ "$rc" -ne 0 ]; then
    log "usage-meter: claude exited rc=$rc; usage not recorded"
    printf '%s' "$json"
    return "$rc"
  fi
  toks="$(printf '%s' "$json" \
    | jq -r '((.usage.input_tokens // 0) + (.usage.output_tokens // 0) + (.usage.cache_creation_input_tokens // 0)) | floor' \
      2>/dev/null || true)"
  meter_record "${toks:-}"
  result="$(printf '%s' "$json" | jq -r '.result // empty' 2>/dev/null || true)"
  printf '%s\n' "$result"
}

# --- per-engagement cost ledger ---------------------------------------------
# The weekly meter above remains the quota gate.  These helpers are deliberately
# separate: they record immutable, job-attributed measurements in journal2.

# job_session_dirs <base> — print Claude project-log directories belonging to a
# job's private garden/project worktrees.  This is intentionally not a time-window
# scan: snapshots before and after one handler invocation form the engagement delta.
job_session_dirs() {
  local base="${1:?}" safe root p enc
  safe="$(printf '%s' "$base" | tr -c 'A-Za-z0-9._-' '_')"
  for root in "$GARDEN_SCRATCH/gardener-wt-$base" "$GARDEN_SCRATCH/project-wt-$safe"*; do
    [ -n "$root" ] || continue
    for enc in "$(printf '%s' "$root" | sed 's#/#-#g')" "$(printf '%s' "$root" | sed 's#[/.]#-#g')"; do
      p="$GARDEN_CCUSAGE_LOGDIR/$enc"
      printf '%s\n' "$p"
    done
  done | awk '!seen[$0]++'
}

# meter_job_session_usage <base> — four cumulative classes, tab-separated:
# input, output, cache-creation, cache-read.  Dedupe by Claude message id across
# all candidate job dirs.  Missing dirs are a genuine zero; an unreadable existing
# dir or absent jq is unknown (return 1), so callers fail open rather than inventing
# a zero measurement.
meter_job_session_usage() {
  local base="${1:?}" d files out
  command -v jq >/dev/null 2>&1 || return 1
  files=""
  while IFS= read -r d; do
    [ -e "$d" ] || continue
    [ -r "$d" ] && [ -x "$d" ] || return 1
    files+="$(find "$d" -type f -name '*.jsonl' -print 2>/dev/null)"$'\n'
  done < <(job_session_dirs "$base")
  [ -n "${files//$'\n'/}" ] || { printf '0\t0\t0\t0\n'; return 0; }
  out="$(printf '%s' "$files" | tr '\n' '\0' | xargs -0 jq -Rr '
      fromjson? // empty | select(.type=="assistant" and (.message.usage != null))
      | [(.message.id // .uuid // "noid"), (.message.usage.input_tokens // 0),
         (.message.usage.output_tokens // 0), (.message.usage.cache_creation_input_tokens // 0),
         (.message.usage.cache_read_input_tokens // 0)] | @tsv' 2>/dev/null |
    awk -F'\t' '!seen[$1]++ {i+=$2;o+=$3;c+=$4;r+=$5} END {printf "%d\\t%d\\t%d\\t%d\\n",i,o,c,r}')" || return 1
  case "$out" in *$'\t'*$'\t'*$'\t'*) printf '%s\n' "$out" ;; *) return 1 ;; esac
}

meter_job_session_total() {
  local u
  u="$(meter_job_session_usage "$1")" || return 1
  awk -F'\t' -v cr="${GARDEN_TOKEN_COUNT_CACHE_READ:-0}" '{print $1+$2+$3+((cr==1)?$4:0)}' <<<"$u"
}

# usage_capture_result <file> <model> <provider-envelope-json>
# Store only the provider's terminal, cumulative fields.  The handoff is outside
# the worktree and is never disclosed to the agent prompt.
usage_capture_result() {
  local file="$1" model="$2" envelope="$3" row
  command -v jq >/dev/null 2>&1 || return 1
  row="$(jq -ce --arg model "$model" '
    {source:"result"}
    + (if $model != "" then {model:$model} else {} end)
    + (if .num_turns != null then {num_turns:.num_turns} else {} end)
    + (if .duration_ms != null then {elapsed_s:(.duration_ms / 1000 | floor)} else {} end)
    + (if .usage.input_tokens != null then {input_tokens:.usage.input_tokens} else {} end)
    + (if .usage.output_tokens != null then {output_tokens:.usage.output_tokens} else {} end)
    + (if .usage.cache_creation_input_tokens != null then {cache_creation_tokens:.usage.cache_creation_input_tokens} else {} end)
    + (if .usage.cache_read_input_tokens != null then {cache_read_tokens:.usage.cache_read_input_tokens} else {} end)
    + (if .total_cost_usd != null then {total_cost_usd:.total_cost_usd} else {} end)' <<<"$envelope" 2>/dev/null)" || return 1
  printf '%s\n' "$row" > "$file" 2>/dev/null
}

# usage_capture_rusage <file> <time-output> — merge GNU time's user/sys seconds
# and maximum resident set into an already captured provider result, best-effort.
usage_capture_rusage() {
  local file="$1" timefile="$2" u s rss
  [ -s "$file" ] && [ -s "$timefile" ] && command -v jq >/dev/null 2>&1 || return 1
  IFS=$'\t' read -r u s rss < "$timefile" || return 1
  [[ "$u" =~ ^[0-9]+([.][0-9]+)?$ ]] && [[ "$s" =~ ^[0-9]+([.][0-9]+)?$ ]] && [[ "$rss" =~ ^[0-9]+$ ]] || return 1
  jq --argjson u "$(awk -v n="$u" 'BEGIN{printf "%d",n*1000}')" \
     --argjson s "$(awk -v n="$s" 'BEGIN{printf "%d",n*1000}')" --argjson rss "$rss" \
     '. + {cpu_user_ms:$u,cpu_sys_ms:$s,peak_rss_kb:$rss}' "$file" > "$file.tmp" 2>/dev/null \
    && mv "$file.tmp" "$file" || { rm -f "$file.tmp"; return 1; }
}

# usage_ledger_stage_row <clone> <base> <elapsed> <outcome> <measurement-json>
# Stage one append-only CostRecord.  This is stage-only so a completion can carry
# its row on the existing completion push while failures use usage-append.sh.
usage_ledger_stage_row() {
  local dir="$1" base="$2" elapsed="$3" outcome="$4" measurement="${5:-}" jf tada_path role row
  mkdir -p "$dir/usage" || return 1
  jf="$dir/$JOBS_DOIN/$base.md"
  if [ ! -f "$jf" ]; then
    tada_path="$(tada_find "$dir" "$base" || true)"
    [ -z "$tada_path" ] || jf="$dir/$tada_path"
  fi
  role="$(plan_role "$jf" 2>/dev/null || true)"
  case "$elapsed" in ''|*[!0-9]*) elapsed=0 ;; esac
  if command -v jq >/dev/null 2>&1 && [ -n "$measurement" ] && jq -e . >/dev/null 2>&1 <<<"$measurement"; then
    row="$(jq -cn --arg ts "$(date -u +%FT%TZ)" --arg base "$base" --arg host "$GARDEN" \
      --arg gardener "${GARDEN_GARDENER_ID:-}" --arg role "$role" --arg outcome "$outcome" --argjson elapsed "$elapsed" \
      --argjson measurement "$measurement" '
        $measurement + {ts:$ts,base:$base,host:$host,outcome:$outcome,elapsed_s:$elapsed}
        + (if $gardener!="" then {gardener:($gardener|tonumber)} else {} end)
        + (if $role!="" then {role:$role} else {} end)' 2>/dev/null)" || return 1
  else
    row="{\"ts\":\"$(date -u +%FT%TZ)\",\"base\":\"$base\",\"host\":\"$GARDEN\",\"outcome\":\"$outcome\",\"source\":\"none\",\"elapsed_s\":$elapsed}"
  fi
  printf '%s\n' "$row" >> "$dir/usage/$base.jsonl" || return 1
  git -C "$dir" add "usage/$base.jsonl"
}

# usage_footer <clone> <base> — authoritative, strip-and-regenerate report view.
usage_footer() {
  local f="$1/usage/$2.jsonl" summary
  [ -f "$f" ] || return 0
  command -v jq >/dev/null 2>&1 || return 1
  summary="$(jq -sce '
    reduce .[] as $r ({eng:0, hosts:{}, unmetered:0, unpriced:0, i:0, o:0, cc:0, cr:0, cost:0, wall:0, cpuu:0, cpus:0, rss:0, models:{}};
      .eng += 1 | .hosts[$r.host] = true |
      .unmetered += (if (($r.input_tokens? // $r.output_tokens? // $r.cache_creation_tokens? // $r.cache_read_tokens?) == null) then 1 else 0 end) |
      .unpriced += (if $r.total_cost_usd == null then 1 else 0 end) |
      .i += ($r.input_tokens // 0) | .o += ($r.output_tokens // 0) | .cc += ($r.cache_creation_tokens // 0) | .cr += ($r.cache_read_tokens // 0) |
      .cost += ($r.total_cost_usd // 0) | .wall += ($r.elapsed_s // 0) | .cpuu += ($r.cpu_user_ms // 0) | .cpus += ($r.cpu_sys_ms // 0) |
      .rss = ([.rss, ($r.peak_rss_kb // 0)]|max) | if $r.model then .models[$r.model] = ((.models[$r.model] // 0)+1) else . end)' "$f" 2>/dev/null)" || return 1
  printf '<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/%s.jsonl; not agent-authored — do not edit -->\n\n' "$2"
  jq -r '"## Cost\n- Engagements: \(.eng) on \((.hosts|keys|length)) host(s)" + (if .unmetered>0 then " (\(.unmetered) unmetered)" else "" end) +
    "\n- Input: \(.i) tokens (\(.cr) cached reads)\n- Output: \(.o) tokens\n- Cost: $\(.cost)" + (if .unpriced>0 then " (\(.unpriced) engagement(s) unpriced)" else "" end) +
    "\n- Wall-clock: \(.wall)s" + (if (.models|length)>0 then "\n- Model(s): \(.models|to_entries|map(.key + " ×" + (.value|tostring))|join(", "))" else "" end)' <<<"$summary"
  printf '\n<!-- garden-usage-end -->\n'
}
