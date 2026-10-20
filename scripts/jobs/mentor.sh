#!/bin/bash
# mentor.sh — the self-improvement service: watch the log AND journalctl for
# failures, debug them, and find ways to make the automation more reliable (or
# to move a responsibility off an agent into a script).
#
# Usage: mentor.sh
#
# Part of the garden's self-healing posture: every automation is supervised and
# shells out to `claude -p` inner agents, and automation is SILENT UNTIL AN
# ERROR. This service feeds two failure surfaces to an inner agent (the mentor
# role): (1) new journal progress/error entries, and (2) recent warnings/errors
# from `journalctl --user` across ALL garden-* services. The inner agent debugs
# and proposes improvements, posting them as jobs for gardeners. The script is
# thin and quiet; only its own failures surface.
#
# Pluggable for tests: GARDEN_MENTOR_HANDLER <digest-sha> <clone-dir>.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="mentor"
: "${GARDEN_MENTOR_HANDLER:=$HERE/handlers/mentor-claude.sh}"
: "${GARDEN_MENTOR_REJECT_THRESHOLD:=3}"
[[ "$GARDEN_MENTOR_REJECT_THRESHOLD" =~ ^[1-9][0-9]*$ ]] \
  || die "GARDEN_MENTOR_REJECT_THRESHOLD must be a positive integer"
# Cap (in ticks) on the transient-outage warning backoff: warnings double their
# gap (ticks 1,2,4,8,…) until it reaches this cap, then repeat every cap ticks so
# a sustained outage stays visible but never floods. See note_transient_outage.
: "${GARDEN_MENTOR_OUTAGE_BACKOFF_CAP:=32}"
[[ "$GARDEN_MENTOR_OUTAGE_BACKOFF_CAP" =~ ^[1-9][0-9]*$ ]] \
  || die "GARDEN_MENTOR_OUTAGE_BACKOFF_CAP must be a positive integer"
# Retry backoff for the HANDLER itself under a transient outage: after the Nth
# consecutive transient attempt the next attempt waits BASE*2^(N-1) seconds,
# capped at MAX. Ticks before that deadline skip the provider call entirely. The
# 1500s base sits under the 30-minute timer period, so the first retry is the
# very next tick and later retries thin out (1, 2, 4, … ticks) to the 4h cap.
: "${GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS:=1500}"
: "${GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS:=14400}"
[[ "$GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS" =~ ^[1-9][0-9]*$ ]] \
  || die "GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS must be a positive integer"
[[ "$GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS" =~ ^[1-9][0-9]*$ ]] \
  || die "GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS must be a positive integer"
# Clock seam for tests; production reads the wall clock.
_mentor_now() { printf '%s\n' "${GARDEN_MENTOR_NOW:-$(date -u +%s)}"; }

fleet_draining && exit 0

DIR="${GARDEN_MENTOR_CLONE:-$GARDEN_STATE/mentor/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"
clone_unlock "$DIR"

SEEN="$GARDEN_STATE/mentor/seen"
JSINCE="$GARDEN_STATE/mentor/journalctl-since"
REJECTION_STATE="$GARDEN_STATE/mentor/semantic-rejections"
OUTAGE_STATE="$GARDEN_STATE/mentor/transient-outage"
mkdir -p "$(dirname "$SEEN")"; touch "$SEEN"

# --- transient-outage warning backoff ----------------------------------------
# A sustained transient provider outage (a claude quota/usage cut, an Anthropic
# overload/5xx, an api.github.com/network blip) leaves $SEEN/$JSINCE UNADVANCED so
# the retry intent is honored — but that means the SAME inputs are re-attempted
# EVERY tick, and the old code logged a fresh WARN each time. On a multi-hour
# outage that is one root cause screaming once per tick, which both violates
# silent-until-error and buries the eventual real signal. These helpers persist
# the episode (a consecutive-transient-tick counter, in $OUTAGE_STATE) and rate-
# limit the WARN on a bounded exponential backoff, then emit ONE recovery notice
# when the outage clears. The episode also carries a next-retry deadline
# (epoch seconds, exponential in the attempt count): ticks before it skip the
# handler entirely, so a sustained outage stops costing one provider call per
# tick (2026-10-20: the same outage was re-hit at 08:50, 09:20, and 10:20Z).
# State line: "<last-sha> <consecutive-transient-attempts> <next-retry-epoch>".

# _outage_should_warn <count> — true on a doubling schedule (1,2,4,8,…) until the
# gap reaches GARDEN_MENTOR_OUTAGE_BACKOFF_CAP, then once every cap ticks. Bounded
# so warnings thin out under a long outage yet never fall permanently silent.
_outage_should_warn() {
  local n="$1" cap="$GARDEN_MENTOR_OUTAGE_BACKOFF_CAP"
  if [ "$n" -le "$cap" ]; then
    [ $(( n & (n - 1) )) -eq 0 ]   # power of two → the doubling boundaries
  else
    [ $(( n % cap )) -eq 0 ]
  fi
}

# note_transient_outage <sha> <message> — record one transient tick and emit a
# rate-limited WARN. The counter increments on ANY consecutive transient tick,
# not only a matching $sha: a sustained outage's digest can drift (our own WARN
# feeds back into the next journalctl read, and new warnings accrue), and the
# episode we are throttling is "the provider is down", not one exact blob. $sha is
# retained only for the human-readable line. Leaves the input markers untouched;
# the caller's `exit 0` performs the retry.
note_transient_outage() {
  local sha="$1" msg="$2" count=0 _prev _deadline delay i
  read -r _prev count _deadline 2>/dev/null < "$OUTAGE_STATE" || true
  [[ "$count" =~ ^[0-9]+$ ]] || count=0
  count=$((count + 1))
  delay="$GARDEN_MENTOR_OUTAGE_RETRY_BASE_SECS"
  for (( i = 1; i < count && delay < GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS; i++ )); do
    delay=$((delay * 2))
  done
  [ "$delay" -le "$GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS" ] || delay="$GARDEN_MENTOR_OUTAGE_RETRY_MAX_SECS"
  printf '%s %s %s\n' "$sha" "$count" "$(( $(_mentor_now) + delay ))" > "$OUTAGE_STATE"
  if _outage_should_warn "$count"; then
    log "WARN: $msg (transient outage tick #$count; next handler retry in ${delay}s; further duplicate warnings suppressed with exponential backoff)"
  fi
}

# outage_retry_deferred — true while an open outage episode's next-retry deadline
# is still in the future. A missing/legacy (deadline-less) state is eligible.
outage_retry_deferred() {
  [ -f "$OUTAGE_STATE" ] || return 1
  local _sha _count deadline=""
  read -r _sha _count deadline 2>/dev/null < "$OUTAGE_STATE" || true
  [[ "$deadline" =~ ^[0-9]+$ ]] || return 1
  [ "$(_mentor_now)" -lt "$deadline" ]
}

# note_transient_recovery — close an open transient-outage episode with a SINGLE
# recovery notice. A no-op when no episode is open, so every non-transient outcome
# (handler success, semantic rejection, a real defect) can call it unconditionally.
note_transient_recovery() {
  [ -f "$OUTAGE_STATE" ] || return 0
  local sha="" count=0 _deadline
  read -r sha count _deadline 2>/dev/null < "$OUTAGE_STATE" || true
  [[ "$count" =~ ^[0-9]+$ ]] || count=0
  rm -f "$OUTAGE_STATE"
  log "mentor transient provider outage cleared after $count consecutive tick(s) (last digest $sha)"
}

# A panel's ordinary "approve / no findings" result is progress, not a failure
# surface.  Keep this classifier deliberately narrow: only a result entry with an
# explicit approve verdict and an explicit empty-findings statement qualifies.
# Any warning/error language makes the entry actionable even when the author also
# wrote "approve".  Unknown formats fail open into the mentor digest.
is_routine_approval_result() { # <entry-file>
  awk '
    BEGIN {
      kind = ""; verdicts = 0; approvals = 0; in_findings = 0
      finding_bullets = 0; clear_bullets = 0; inline_clear = 0; hazard = 0
    }
    {
      raw = $0
      line = tolower(raw)
      if (line ~ /^kind:[[:space:]]*/) {
        sub(/^kind:[[:space:]]*/, "", line)
        gsub(/[[:space:]]/, "", line)
        kind = line
      }

      # Markdown emphasis is decoration around the protocol labels, not data.
      plain = line
      gsub(/\*/, "", plain)
      sub(/^[[:space:]]+/, "", plain)
      sub(/[[:space:]]+$/, "", plain)
      if (plain ~ /^verdict:[[:space:]]*/) {
        verdict = plain
        sub(/^verdict:[[:space:]]*/, "", verdict)
        sub(/[.[:space:]]+$/, "", verdict)
        verdicts++
        if (verdict == "approve") approvals++
      }
      if (plain ~ /^findings:[[:space:]]*/) {
        in_findings = 1
        if (plain ~ /^findings:[[:space:]]*none[.[:space:]]*$/) inline_clear = 1
        next
      }
      if (in_findings && plain ~ /^-[[:space:]]*/) {
        finding_bullets++
        if (plain ~ /^-[[:space:]]*none([.[:space:]]|$)/ ||
            plain ~ /^-[[:space:]]*no[[:space:]].*findings?([.[:space:]]|$)/) clear_bullets++
      }

      # Conservative by design: even "no warnings" stays in the digest.  It is
      # safer to wake the mentor for an unusual result than to hide a real alarm.
      if (line ~ /(^|[^[:alnum:]_])(error|errors|warning|warnings|fatal|failure|failed)([^[:alnum:]_]|$)/) hazard = 1
    }
    END {
      empty_findings = inline_clear ||
        (finding_bullets > 0 && clear_bullets == finding_bullets)
      exit !(kind == "result" && verdicts > 0 && approvals == verdicts &&
             empty_findings && !hazard)
    }
  ' "$1"
}

# 1. new journal entries since last run. Routine clean panel approvals are
# consumed here and never enter the digest; actionable and unrecognized results
# retain the existing retry-on-handler-failure semantics below.
new=()
routine=()
while IFS= read -r f; do
  rel="${f#"$DIR"/}"
  grep -qxF "$rel" "$SEEN" && continue
  if is_routine_approval_result "$f"; then
    routine+=("$rel")
  else
    new+=("$f")
  fi
done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort)
# These entries need no agent outcome, so their consumption is independent of a
# handler/provider outage affecting a different, actionable entry in this tick.
for rel in "${routine[@]}"; do printf '%s\n' "$rel" >> "$SEEN"; done

# 2. recent service failures from journalctl across all garden-* units
#    (production path; tolerant when systemd/journalctl is absent)
since="$(cat "$JSINCE" 2>/dev/null || echo '-1h')"
# Capture the cursor for the NEXT tick NOW, before the journalctl read: the old
# code stamped JSINCE with the time AFTER the handler finished (a claude -p run
# of many minutes), so any garden-* warning logged during the read-to-stamp gap
# fell below the next tick's --since and was never surfaced — a silent per-tick
# blind window in the very service that exists to see failures. Stamping the
# pre-read time makes windows contiguous; a warning right at the boundary may
# be seen twice, and a duplicate beats a blind spot.
tick_start="$(date -u +%FT%TZ)"
jlog=""
if command -v journalctl >/dev/null 2>&1; then
  systemd_user_env
  # `timeout` guards against a hang: in a headless cron/`claude -p` context the
  # `--user` journal/dbus connection may never establish and `journalctl --user`
  # blocks forever, wedging the whole mentor tick. A 30s bound degrades a stuck
  # connection to an empty digest instead of an indefinite hang.
  jlog="$(timeout 30 journalctl --user -u 'garden-*' -p warning --since "$since" --no-pager 2>/dev/null || true)"
  # When there are no matching warnings, `journalctl --no-pager` prints the
  # sentinel `-- No entries --` to stdout — a non-empty string. That is distinct
  # from the empty string, so the step-3 `[ -z "$jlog" ]` silence guard would
  # never short-circuit and the mentor would wake `claude -p` against pure noise.
  # Normalize the sentinel to empty (whitespace-tolerant, to also catch a
  # leading/trailing-newline variant) so a clean-and-reachable journalctl with
  # nothing to report keeps the mentor silent.
  [ "$(printf '%s' "$jlog" | tr -d '[:space:]')" = "--Noentries--" ] && jlog=""
fi

# 3. nothing to look at → stay silent
if [ "${#new[@]}" -eq 0 ] && [ -z "$jlog" ]; then exit 0; fi

# 3b. an open transient outage whose retry deadline has not elapsed → skip the
#     handler silently. $SEEN/$JSINCE stay unadvanced, so the first eligible tick
#     sees everything that accrued meanwhile.
outage_retry_deferred && exit 0

# 4. build the combined digest
digest="$(mktemp "${TMPDIR:-/tmp}/garden-improve.XXXXXX")"
for f in "${new[@]}"; do
  printf '===== entry %s =====\n' "${f#"$DIR"/}" >> "$digest"; cat "$f" >> "$digest"; printf '\n' >> "$digest"
done
if [ -n "$jlog" ]; then
  printf '===== journalctl garden-* (since %s) =====\n%s\n' "$since" "$jlog" >> "$digest"
fi

# 5. capture the digest as a content-addressed blob in the mentor's own journal
#    clone, and hand the inner agent ONLY its SHA. The mentor (same host, same
#    clone) reads just the slices it needs via `git cat-file -p <sha> | grep/sed`
#    rather than carrying the whole journalctl tail in its context. Identical
#    digests hash to identical SHAs, so a recurring failure is recognizable by
#    its content address. See common.sh § failure capture and
#    designs/self-healing-audit.md (Part B #2).
sha="$(capture_blob "$digest" "$DIR")"
rm -f "$digest"   # the blob now lives in $DIR's object DB; the temp file is spent

# 6. hand the SHA to the inner agent; advance markers only on genuine success.
#    Capture the handler's combined stdout+stderr so a TRANSIENT inner-agent
#    outage — a `claude` quota/usage cut, an Anthropic overload/5xx, or an
#    api.github.com/network blip — is not mistaken for a real handler defect. On
#    a transient the intent this branch already carries (retry next tick) is
#    satisfied by leaving $SEEN/$JSINCE unadvanced (and arming the next-retry
#    deadline), so we WARN and exit 0.
#    A `die` (exit 1) here is doubly wrong on a transient: it (a) marks
#    garden-mentor.service Failed and (b) fires self-heal-run.sh into a `claude -p`
#    diagnosis that fails identically in the SAME outage (2026-07-02 01:20:07 and
#    01:50:08, a broad claude quota/usage cut + api.github.com outage). Reserve
#    the die (exit 1 → self-heal) path for a genuine, non-transient handler
#    failure. Mirrors gardener.sh's transient-vs-real classification.
capture="$(mktemp "${TMPDIR:-/tmp}/garden-mentor-capture.XXXXXX")"
# Capture the handler's exit code IMMEDIATELY into $rc. A bare `if
# "$HANDLER" …; then` would work for the success arm, but the failure arm below
# needs $rc to classify an EMPTY-output kill (rc=137/143 SIGKILL/OOM/SIGTERM, or
# the offline rc) — and `$?` there would already be clobbered by the `out="$(…)"`
# substitution. Run the handler as a plain statement under `set +e` (mirroring
# gardener.sh:376-381) so a non-zero exit is captured into $rc rather than
# tripping `set -e` before the classifier below runs.
set +e
"$GARDEN_MENTOR_HANDLER" "$sha" "$DIR" >"$capture" 2>&1
rc=$?
set -e
if [ "$rc" -eq 0 ]; then
  note_transient_recovery
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
  printf '%s\n' "$tick_start" > "$JSINCE"
  rm -f "$REJECTION_STATE"
  rm -f "$capture"
elif [ ! -s "$capture" ] && is_transient_empty_failure "$rc"; then
  # EMPTY capture + a signal/offline rc — a `claude -p` handler SIGKILLed/
  # OOM-killed (rc=137/143) or cut mid-call by a quota/network blip that flushed
  # nothing to $capture — matches neither is_transient_claude_signature nor
  # _fetch_stderr_is_offline (both need signature TEXT), so without this branch it
  # would fall through to `die` and fire self-heal-run.sh into a diagnosis that
  # fails identically in the SAME outage (the observed 30-min FATAL loop on
  # endolinbot, 2026-07-05 18:20/18:50/19:20, bare "FATAL: improve handler failed"
  # with no preceding $out diagnostic → empty output). Classify it transient,
  # mirroring gardener.sh's empty-capture branch (gardener.sh:679-687) via the
  # SAME common.sh helper so the two handlers stay aligned: WARN + exit 0, leaving
  # $SEEN/$JSINCE unadvanced so the next tick retries.
  rm -f "$capture" "$REJECTION_STATE"
  note_transient_outage "$sha" "improve handler killed with empty output (rc=$rc); leaving markers, retrying after backoff"
  exit 0
else
  out="$(tail -c 65536 "$capture" 2>/dev/null || true)"
  rm -f "$capture"
  # mentor-claude.sh's own all-providers-exhausted FATAL: every configured
  # provider returned its "unavailable" code (rc=10: quota backoff, an
  # unreachable local-inference endpoint, a failed provider run), so no provider
  # was reached. That is the handler's fallback-exhausted outage, not a defect in
  # the digest, and the paragraph above says it must retry rather than die.
  if is_transient_claude_signature "$out" || _fetch_stderr_is_offline "$out" \
     || printf '%s' "$out" | grep -qF 'no configured mentor inference provider was available'; then
    rm -f "$REJECTION_STATE"
    note_transient_outage "$sha" "improve handler hit a transient outage; leaving markers, retrying after backoff"
    exit 0
  fi
  # Past the transient checks: this tick reached the provider and got a real
  # verdict, so any open outage episode is over — close it with one recovery
  # notice before the semantic/real-failure handling below.
  note_transient_recovery
  if printf '%s' "$out" | grep -q 'malformed semantic output'; then
    # A semantic rejection correctly refuses provider fallback, but retrying the
    # same content-addressed digest forever only reproduces the same decision.
    # Bound that episode, then consume the inputs and surface one actionable page.
    prior_sha=""; reject_count=0
    read -r prior_sha reject_count 2>/dev/null < "$REJECTION_STATE" || true
    [[ "$reject_count" =~ ^[0-9]+$ ]] || reject_count=0
    if [ "$prior_sha" = "$sha" ]; then reject_count=$((reject_count + 1)); else reject_count=1; fi
    printf '%s %s\n' "$sha" "$reject_count" > "$REJECTION_STATE"
    if [ "$reject_count" -ge "$GARDEN_MENTOR_REJECT_THRESHOLD" ]; then
      printf '%s\n' "$out" >&2
      alert_maintainer "mentor-semantic-rejection-$sha" \
        "mentor rejected digest $sha semantically $reject_count consecutive times on host $GARDEN. The retry backstop advanced its input markers after the last rejection. Latest diagnostic: ${out:0:1000}"
      for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
      printf '%s\n' "$tick_start" > "$JSINCE"
      log "WARN: mentor digest $sha reached $reject_count semantic rejections; advanced markers and escalated to the maintainer"
      exit 0
    fi
    printf '%s\n' "$out" >&2
    log "WARN: mentor digest $sha was rejected semantically ($reject_count/$GARDEN_MENTOR_REJECT_THRESHOLD); leaving input markers unchanged for the next tick"
    exit 0
  else
    rm -f "$REJECTION_STATE"
  fi
  printf '%s\n' "$out" >&2   # surface the real diagnostic before we die
  die "improve handler failed; leaving markers so the next tick retries"
fi
