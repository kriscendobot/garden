#!/bin/bash
# rerecord-reputation-arm.sh — carry an UNMASKED stealth id's accumulated reputation
# forward onto the now-named model's arm(s).
#
# Usage:
#   rerecord-reputation-arm.sh <old-arm-key> <new-arm-key> --authorized-by <login> [--dry-run]
#
# An <arm-key> is `<kind>/<provider>/<model>` using the RAW identity values as they
# appear in an event's frontmatter (NOT the sanitized directory names under
# reputation/arms/). `kind` and `provider` are single slash-free tokens, so the FIRST
# TWO slashes split the key and everything after the second slash is the `model` (which
# may itself contain slashes, e.g. a `<namespace>/<wire-id>` id). Examples:
#   old: openrouter-promo/openrouter-promo/openrouter-promo/openrouter/horizon-beta
#   new: openrouter/openrouter/openrouter/z-ai/glm-5.2:free
#
# WHY this shape. A cloaked ("stealth") OpenRouter id runs under its own kind/provider/
# namespace (openrouter-promo) precisely so its short-lived, separately-re-reviewed
# reputation NEVER pools with a stable named model's (design openrouter-provider.md
# § The stealth/promotional lane). When OpenRouter later PUBLISHES what a stealth id
# actually was — an external fact only a human confirms, never automatic — the garden
# should be able to keep the history it earned rather than restart that model at zero.
#
# HOW it works — through the reducer's single source of truth, never a hand-edited
# projection. The arm projections (reputation/arms/…) are a PURE FUNCTION of the event
# log (reputation/events/…, plus not-yet-finalized reputation/pending/…), recomputed
# every tick by reputation-reduce.sh, which keys each event on (kind, provider, model,
# thoughtfulness) × work_class × target. So this migration RELABELS the identity fields
# (kind/provider/model) of every event belonging to the old arm to the new arm's values,
# preserving thoughtfulness/work_class/target/accepted/dollars verbatim. The next reducer
# tick then re-projects that history onto the new model's arm(s) — one per (work_class,
# target, thoughtfulness) the model was used at, which is why an unmask can move MULTIPLE
# arms at once.
#
# MERGE COMES FREE. Because the reducer recomputes each arm from ALL events with that
# identity (Welford over the full set), relabeling onto a target arm that ALREADY has
# history simply folds the two together exactly on the next tick — a clean rename
# (target arm did not exist) and a merge-on-collision (it did) are the SAME operation
# here, with no approximate posterior combination. This is the payoff of going through
# the source of truth instead of editing a projection.
#
# ORPHAN GC. Once its events are relabeled, the old arm has zero events; the reducer
# only ever WRITES arms it still sees events for and never deletes a now-empty one, so
# its stale projection would linger and misreport history it no longer owns. This script
# therefore also removes the old model's now-orphaned reputation/arms/<kind>/<provider>/
# <model>/ subtree in the SAME commit. That is garbage-collecting a file the reducer
# will never revisit, not editing a reputation value.
#
# IDEMPOTENT + AUDITABLE. Matching is on the exact raw (kind, provider, model) triple, so
# a re-run finds zero old-arm events (they already carry the new identity) and is a clean
# no-op — no record, no commit. Every application that DOES move events writes an
# append-only journal record under reputation/migrations/ (what was renamed, when, by
# whom, and the exact event bases) and stamps each migrated event with rerecorded_from/
# _to/_by/_at provenance, so the transfer is never silent and never double-counted.
#
# ATTESTATION. An unmask is a destructive, maintainer-confirmed relabel of history, so —
# like the sysop's destructive ops (designs/sysop.md §6) — it REQUIRES --authorized-by
# <login> with <login> on the journal maintainers/allowlist. Journal-push access is the
# outer boundary; the attestation records WHO confirmed the unmask, in git.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=reputation.sh
source "$HERE/reputation.sh"   # REP_* layout constants + rep_sanitize/rep_arm_relpath
export GARDEN_TAG="rerecord-reputation-arm"

usage() { die "usage: rerecord-reputation-arm.sh <old-arm-key> <new-arm-key> --authorized-by <login> [--dry-run]"; }

old_key=""; new_key=""; by=""; dry_run=0
while [ $# -gt 0 ]; do
  case "$1" in
    --authorized-by)  by="${2:?--authorized-by needs a login}"; shift 2 ;;
    --authorized-by=*) by="${1#*=}"; shift ;;
    --dry-run)        dry_run=1; shift ;;
    --) shift; break ;;
    -*) die "unknown flag '$1'" ;;
    *)  if [ -z "$old_key" ]; then old_key="$1"; elif [ -z "$new_key" ]; then new_key="$1"; else die "unexpected argument '$1'"; fi; shift ;;
  esac
done
[ -n "$old_key" ] && [ -n "$new_key" ] || usage
[ -n "$by" ] || die "missing --authorized-by <login> (an unmask is maintainer-attested; designs/sysop.md §6)"
[ "$old_key" != "$new_key" ] || die "old and new arm keys are identical ('$old_key'); nothing to migrate"

# --- parse an arm key `<kind>/<provider>/<model>` (kind/provider slash-free) --------
# split on the FIRST TWO slashes; everything after the 2nd slash is the model.
parse_key() {   # parse_key <key> <out-kind-var> <out-provider-var> <out-model-var>
  local key="$1" k p m
  case "$key" in */*/*) : ;; *) die "arm key '$key' must be <kind>/<provider>/<model> (at least two slashes)";; esac
  k="${key%%/*}"; local rest="${key#*/}"
  p="${rest%%/*}"; m="${rest#*/}"
  [ -n "$k" ] && [ -n "$p" ] && [ -n "$m" ] || die "arm key '$key' has an empty kind/provider/model segment"
  printf -v "$2" '%s' "$k"; printf -v "$3" '%s' "$p"; printf -v "$4" '%s' "$m"
}
old_kind=""; old_provider=""; old_model=""
new_kind=""; new_provider=""; new_model=""
parse_key "$old_key" old_kind old_provider old_model
parse_key "$new_key" new_kind new_provider new_model

now="$(date -u +%FT%TZ)"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

# --- maintainer attestation gate (same source as the sysop / issue inbox) -----------
is_maintainer() {   # is_maintainer <login> — reads maintainers/allowlist in the clone
  local login lc line src="${GARDEN_MAINTAINERS_ALLOWLIST:-$DIR/maintainers/allowlist}"
  login="$1"; lc="$(printf '%s' "$login" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
  [ -n "$lc" ] || return 1
  [ -f "$src" ] || return 1
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
    [ "$line" = "$lc" ] && return 0
  done < "$src"
  return 1
}

# --- rewrite one event's identity fields (frontmatter only) + stamp provenance ------
rewrite_event() {   # rewrite_event <file>
  local f="$1"
  awk -v nk="$new_kind" -v np="$new_provider" -v nm="$new_model" \
      -v okey="$old_key" -v nkey="$new_key" -v by="$by" -v at="$now" '
    BEGIN { infm = 0 }
    NR == 1 && $0 == "---" { infm = 1; print; next }
    infm == 1 && $0 == "---" {
      print "rerecorded_from: " okey
      print "rerecorded_to: " nkey
      print "rerecorded_by: " by
      print "rerecorded_at: " at
      infm = 0; print; next
    }
    infm == 1 && /^kind:[[:space:]]/     { print "kind: " nk; next }
    infm == 1 && /^provider:[[:space:]]/ { print "provider: " np; next }
    infm == 1 && /^model:[[:space:]]/    { print "model: " nm; next }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}

# --- the migration (CAS-retried on the journal push) --------------------------------
for attempt in $(seq 1 50); do
  sync_clone "$DIR"

  is_maintainer "$by" || die "authorized_by '$by' is not on the journal maintainers/allowlist (add-maintainer.sh <login> first; an unmask is maintainer-attested)"

  # collect every event/pending file whose RAW (kind,provider,model) matches the old arm.
  matched=(); shopt -s nullglob
  for d in "$REP_EVENTS" "$REP_PENDING"; do
    for f in "$DIR/$d"/*.md; do
      [ "$(plan_field "$f" kind)"     = "$old_kind" ]     || continue
      [ "$(plan_field "$f" provider)" = "$old_provider" ] || continue
      [ "$(plan_field "$f" model)"    = "$old_model" ]    || continue
      matched+=("$f")
    done
  done
  shopt -u nullglob

  if [ "${#matched[@]}" -eq 0 ]; then
    # Idempotent no-op: nothing carries the old identity (already migrated, or never
    # existed). Surface the distinct arms present so an operator can spot a typo.
    log "no events match old arm '$old_key' — nothing to migrate (already done, or key mismatch)"
    if [ "$dry_run" -eq 0 ]; then
      log "distinct (kind/provider/model) present in the event log:"
      shopt -s nullglob
      for f in "$DIR/$REP_EVENTS"/*.md "$DIR/$REP_PENDING"/*.md; do
        printf '%s/%s/%s\n' "$(plan_field "$f" kind)" "$(plan_field "$f" provider)" "$(plan_field "$f" model)"
      done | sort -u | sed 's/^/    /' >&2 || true
      shopt -u nullglob
    fi
    clone_unlock "$DIR" 2>/dev/null || true
    exit 0
  fi

  # record the exact bases we are moving (basename, demerit suffix and all).
  bases=(); for f in "${matched[@]}"; do bases+=("$(basename "$f" .md)"); done

  if [ "$dry_run" -eq 1 ]; then
    log "DRY RUN — would rerecord ${#matched[@]} event(s) from '$old_key' to '$new_key':"
    printf '    %s\n' "${bases[@]}" >&2
    old_subtree="$REP_ARMS/$(rep_sanitize "$old_kind")/$(rep_sanitize "$old_provider")/$(rep_sanitize "$old_model")"
    [ -d "$DIR/$old_subtree" ] && log "DRY RUN — would remove orphaned old projection subtree $old_subtree"
    clone_unlock "$DIR" 2>/dev/null || true
    exit 0
  fi

  # 1. relabel each matched event's identity + stamp provenance.
  for f in "${matched[@]}"; do
    rewrite_event "$f"
    git -C "$DIR" add "${f#"$DIR"/}"
  done

  # 2. GC the old model's now-orphaned projection subtree (the reducer never deletes it).
  old_subtree="$REP_ARMS/$(rep_sanitize "$old_kind")/$(rep_sanitize "$old_provider")/$(rep_sanitize "$old_model")"
  if [ -d "$DIR/$old_subtree" ]; then
    git -C "$DIR" rm -r -q --ignore-unmatch "$old_subtree" >/dev/null 2>&1 || rm -rf "${DIR:?}/${old_subtree:?}"
  fi

  # 3. append-only migration record (audit; never rewritten, never double-counted).
  keyhash="$(printf '%s->%s' "$old_key" "$new_key" | (sha1sum 2>/dev/null || shasum) | cut -c1-8)"
  recdir="$REP_ROOT/migrations"
  rec="$recdir/$(printf '%s' "$now" | tr -c 'A-Za-z0-9' '-')-$keyhash.md"
  mkdir -p "$DIR/$recdir"
  {
    printf -- '---\n'
    printf 'migrated_at: %s\n' "$now"
    printf 'authorized_by: %s\n' "$by"
    printf 'reason: stealth-id-unmask\n'
    printf 'old_kind: %s\n' "$old_kind"
    printf 'old_provider: %s\n' "$old_provider"
    printf 'old_model: %s\n' "$old_model"
    printf 'new_kind: %s\n' "$new_kind"
    printf 'new_provider: %s\n' "$new_provider"
    printf 'new_model: %s\n' "$new_model"
    printf 'event_count: %s\n' "${#matched[@]}"
    printf 'recorded_by: %s\n' "${GARDEN:-unknown}/rerecord-reputation-arm"
    printf -- '---\n'
    printf 'Rerecorded %s reputation event(s) from arm `%s` onto `%s` (stealth id unmasked; authorized by %s).\n\n' \
      "${#matched[@]}" "$old_key" "$new_key" "$by"
    printf 'Bases moved:\n'
    printf -- '- %s\n' "${bases[@]}"
  } > "$DIR/$rec"
  git -C "$DIR" add "$rec"

  rc=0; commit_and_push "$DIR" "reputation: rerecord arm $old_key -> $new_key (${#matched[@]} events, by $by)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "rerecorded ${#matched[@]} event(s) from '$old_key' to '$new_key' (record $rec); the next reducer tick re-projects the arm(s)"
    exit 0
  fi
  [ "$rc" -eq 2 ] && { log "nothing to commit (already migrated)"; exit 0; }
  log "rerecord lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not rerecord reputation arm $old_key -> $new_key after retries"
