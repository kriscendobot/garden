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
GARDEN_TAG="mentor"
: "${GARDEN_MENTOR_HANDLER:=$HERE/handlers/mentor-claude.sh}"

fleet_draining && exit 0

DIR="${GARDEN_MENTOR_CLONE:-$GARDEN_STATE/mentor/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

SEEN="$GARDEN_STATE/mentor/seen"
JSINCE="$GARDEN_STATE/mentor/journalctl-since"
mkdir -p "$(dirname "$SEEN")"; touch "$SEEN"

# 1. new journal entries since last run
new=()
while IFS= read -r f; do
  rel="${f#"$DIR"/}"
  grep -qxF "$rel" "$SEEN" && continue
  new+=("$f")
done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort)

# 2. recent service failures from journalctl across all garden-* units
#    (production path; tolerant when systemd/journalctl is absent)
since="$(cat "$JSINCE" 2>/dev/null || echo '-1h')"
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
#    satisfied simply by leaving $SEEN/$JSINCE unadvanced, so we WARN and exit 0.
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
  for f in "${new[@]}"; do printf '%s\n' "${f#"$DIR"/}" >> "$SEEN"; done
  date -u +%FT%TZ > "$JSINCE"
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
  rm -f "$capture"
  log "WARN: improve handler killed with empty output (rc=$rc); leaving markers, retrying next tick"
  exit 0
else
  out="$(tail -c 65536 "$capture" 2>/dev/null || true)"
  rm -f "$capture"
  if is_transient_claude_signature "$out" || _fetch_stderr_is_offline "$out"; then
    log "WARN: improve handler hit a transient outage; leaving markers, retrying next tick"
    exit 0
  fi
  printf '%s\n' "$out" >&2   # surface the real diagnostic before we die
  die "improve handler failed; leaving markers so the next tick retries"
fi
