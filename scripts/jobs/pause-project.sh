#!/bin/bash
# pause-project.sh — arm, lift, or report a PROJECT PAUSE as journal state.
#
# A project pause used to live ONLY as deployed prose in roles/COMMON.md, which
# reaches a host only via deploy. A host running a stale garden therefore silently
# violated every pause newer than its deployed sha — and on 2026-09-16/17 a leader on
# ~09-04 code posted and ran ~60 IronHorse fuzz jobs a week after the 09-09 pause its
# code predated. This tool writes the pause into JOURNAL STATE (pauses/<slug>.md on
# journal2), which every host reads live at the post/claim/promote chokepoints
# (common.sh project_pause_hit), so the directive is honored without a deploy.
# Design: designs/project-pause-enforcement.md.
#
# Usage:
#   pause-project.sh <slug> on  --maintainer NAME --directive REF --scope TEXT
#                               [--match ERE]...       arm/refresh the pause
#   pause-project.sh <slug> off                        LIFT the pause (delete record)
#   pause-project.sh status <slug>                     report one project's pause
#   pause-project.sh list                              list all active pauses
#
#   <slug>          the project name, kebab-case (e.g. ironhorse). It IS the fail-safe
#                   match: the record's filename is always readable, so a job whose base
#                   or body contains the slug is paused even if the record body is
#                   corrupt. Keep it to the string the project's jobs actually name.
#   --maintainer    the authorizing maintainer (who paused it).
#   --directive     a citation for the directive (an issue/PR URL or a short ref),
#                   e.g. "kriscendobot/garden#91, 2026-09-09".
#   --scope         one line naming what is paused (implementation, review, fuzz, …).
#   --match ERE     extra case-insensitive extended-regexp patterns tested against a
#                   job's base+body, for jobs that do not literally contain the slug.
#                   Repeatable. The slug substring is ALWAYS matched regardless.
#
# COMMON.md keeps the HUMAN-READABLE statement of the pause; this record is what
# MACHINERY consults. Keep the two from drifting: arming/lifting here should be paired
# with the matching edit to roles/COMMON.md § Project scope, and `status`/`list` are
# the surface a human (or a guard) uses to confirm the journal matches the prose. The
# record body itself embeds the directive so the two are cross-referable.
#
# The record is CAS-raced onto origin/journal2 the same way brake-foreman.sh writes the
# foreman brake and set-main-host.sh writes the leader marker: first pusher wins, losers
# re-sync and retry. Its EXISTENCE means paused; lifting deletes it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="pause-project"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# Validate a slug into a single filesystem/ref-safe token (kebab-case only), so a
# record can never escape the pauses/ directory or collide with the fail-safe slug
# match semantics.
valid_slug() {
  case "$1" in
    ''|-*|*/*|.*) return 1;;
    *[!A-Za-z0-9._-]*) return 1;;
    *) return 0;;
  esac
}

rec_path() { printf '%s/%s/%s.md' "$DIR" "$GARDEN_PAUSES_PATH" "$1"; }

action="${1:-}"
case "$action" in
  list)
    ensure_clone "$DIR"; sync_clone "$DIR"
    d="$DIR/$GARDEN_PAUSES_PATH"
    found=0
    if [ -d "$d" ]; then
      for rec in "$d"/*.md; do
        [ -e "$rec" ] || continue
        found=1
        slug="$(basename "$rec" .md)"
        maint="$(plan_field "$rec" maintainer 2>/dev/null || true)"
        directive="$(plan_field "$rec" directive 2>/dev/null || true)"
        scope="$(plan_field "$rec" scope 2>/dev/null || true)"
        printf '%s\tpaused_by=%s\tdirective=%s\tscope=%s\n' \
          "$slug" "${maint:-?}" "${directive:-?}" "${scope:-?}"
      done
    fi
    [ "$found" -eq 1 ] || log "no active project pauses"
    exit 0
    ;;
  status)
    slug="${2:?usage: pause-project.sh status <slug>}"
    valid_slug "$slug" || die "illegal slug: '$slug'"
    ensure_clone "$DIR"; sync_clone "$DIR"
    rec="$(rec_path "$slug")"
    if [ -e "$rec" ]; then
      log "PAUSED: $slug"
      sed 's/^/  /' "$rec" 2>/dev/null || true
      exit 0
    fi
    log "not paused: no journal record $GARDEN_PAUSES_PATH/$slug.md"
    exit 0
    ;;
esac

# The mutating forms take <slug> first, then on|off.
slug="${1:?usage: pause-project.sh <slug> on|off  | status <slug> | list}"
sub="${2:-}"
valid_slug "$slug" || die "illegal slug: '$slug' (kebab-case, no slashes)"
shift 2 2>/dev/null || die "usage: pause-project.sh <slug> on|off  | status <slug> | list"

maintainer=""
directive=""
scope=""
matches=()
while [ $# -gt 0 ]; do
  case "$1" in
    --maintainer) maintainer="${2:?--maintainer needs a value}"; shift 2;;
    --directive)  directive="${2:?--directive needs a value}"; shift 2;;
    --scope)      scope="${2:?--scope needs a value}"; shift 2;;
    --match)      matches+=("${2:?--match needs an ERE}"); shift 2;;
    --) shift; break;;
    -*) die "unknown option: '$1'";;
    *) die "unexpected argument: '$1'";;
  esac
done

rel="$GARDEN_PAUSES_PATH/$slug.md"
rec="$(rec_path "$slug")"

case "$sub" in
  on)
    [ -n "$maintainer" ] || die "arming a pause requires --maintainer NAME"
    [ -n "$directive" ]  || die "arming a pause requires --directive REF (issue/PR/citation)"
    [ -n "$scope" ]      || die "arming a pause requires --scope TEXT (what is paused)"
    case "$scope" in *$'\n'*) die "--scope must be one line";; esac
    ensure_clone "$DIR"
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      mkdir -p "$DIR/$GARDEN_PAUSES_PATH"
      {
        printf 'project: %s\n' "$slug"
        printf 'maintainer: %s\n' "$(yaml_single_quote_scalar "$maintainer")"
        printf 'directive: %s\n' "$(yaml_single_quote_scalar "$directive")"
        printf 'scope: %s\n' "$(yaml_single_quote_scalar "$scope")"
        printf 'paused_at: %s\n' "$(date -u +%FT%TZ)"
        printf 'paused_by_host: %s\n' "$GARDEN"
        for m in "${matches[@]}"; do printf 'match: %s\n' "$m"; done
        printf -- '---\n\n'
        printf 'Project **%s** is PAUSED.\n\n' "$slug"
        printf 'While this record exists on journal2, the garden does NOT post, park,\n'
        printf 'claim, or promote work for this project. Every host reads it LIVE at the\n'
        printf 'post/claim/promote chokepoints (scripts/jobs/common.sh project_pause_hit),\n'
        printf 'so the pause is honored even by a host whose DEPLOYED roles/COMMON.md\n'
        printf 'predates it — the gap that produced the 2026-09-16/17 fuzz storm.\n\n'
        printf 'Authorizing maintainer: %s\n' "$maintainer"
        printf 'Directive: %s\n' "$directive"
        printf 'Scope: %s\n\n' "$scope"
        printf 'The human-readable statement of this pause lives in roles/COMMON.md\n'
        printf -- '§ Project scope; keep the two in sync.\n\n'
        printf 'To LIFT this pause (the only authorized way to run the work again):\n'
        printf '    scripts/jobs/pause-project.sh %s off\n' "$slug"
        printf 'and update roles/COMMON.md to match.\n'
      } > "$rec"
      git -C "$DIR" add "$rel"
      rc=0; commit_and_push "$DIR" "pause project '$slug' (by $GARDEN; $maintainer, $directive)" || rc=$?
      [ "$rc" -eq 0 ] && { log "PAUSED project '$slug' as journal state ($rel). Now update roles/COMMON.md § Project scope to match."; exit 0; }
      [ "$rc" -eq 2 ] && { log "pause record for '$slug' already up to date"; exit 0; }
      log "pause-project lost a push race (attempt $attempt); retrying"
      backoff "$attempt"
    done
    die "could not arm pause for '$slug' after retries"
    ;;
  off)
    ensure_clone "$DIR"
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      if [ ! -e "$rec" ]; then
        log "project '$slug' was not paused (no record $rel); nothing to lift"
        exit 0
      fi
      git -C "$DIR" rm -q "$rel"
      rc=0; commit_and_push "$DIR" "lift pause on project '$slug' (by $GARDEN)" || rc=$?
      [ "$rc" -eq 0 ] && { log "LIFTED pause on project '$slug' ($rel deleted). Now update roles/COMMON.md § Project scope to match."; exit 0; }
      [ "$rc" -eq 2 ] && { log "pause on '$slug' already lifted"; exit 0; }
      log "pause-project lost a push race (attempt $attempt); retrying"
      backoff "$attempt"
    done
    die "could not lift pause for '$slug' after retries"
    ;;
  *)
    die "usage: pause-project.sh <slug> on|off  | status <slug> | list"
    ;;
esac
