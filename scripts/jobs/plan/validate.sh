#!/bin/bash
# plan/validate.sh — validate the plan records against the schema.
#
# Usage: plan/validate.sh [<plan-dir>]
#   <plan-dir> defaults to journal/plan relative to GARDEN_ROOT.
#
# This is the garden mechanism that replaces the endo `designs/CLAUDE.md`
# "every design must carry a metadata table" discipline (per designs/plan-in-journal.md).
# It validates each record's frontmatter against the schema, enforces slug
# uniqueness, resolves repository slugs, and rejects any record targeting
# agoric-sdk (the unconditional exclusion). It is meant to run as a pre-push gate
# and as a job posted on plan change.
#
# Exit 0 = clean; 1 = one or more ERRORs; warnings never fail the gate.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
# common.sh is optional here (validate runs both in-fleet and standalone in tests).
[ -f "$HERE/../common.sh" ] && { GARDEN_TAG="plan-validate"; source "$HERE/../common.sh" 2>/dev/null || true; }

PLAN_DIR="${1:-${GARDEN_ROOT:-$(cd "$HERE/../../.." && pwd)}/journal/plan}"
[ -d "$PLAN_DIR" ] || { echo "plan-validate: no plan dir at $PLAN_DIR" >&2; exit 0; }

errors=0; warnings=0
err()  { printf 'ERROR  %s\n' "$*" >&2; errors=$((errors+1)); }
warn() { printf 'warn   %s\n' "$*" >&2; warnings=$((warnings+1)); }

# Collect slugs first (for uniqueness + depends_on resolution).
declare -A seen_slug
all_slugs=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  s="$(fm_field "$f" slug)"
  [ -n "$s" ] && all_slugs="$all_slugs $s"
done < <(list_records "$PLAN_DIR")

slug_known() { case " $all_slugs " in *" $1 "*) return 0;; *) return 1;; esac; }

while IFS= read -r f; do
  [ -n "$f" ] || continue
  rel="${f#"$PLAN_DIR"/}"
  slug="$(fm_field "$f" slug)"
  repo="$(fm_field "$f" repository)"
  status="$(fm_field "$f" status)"
  size="$(fm_field "$f" size)"
  milestone="$(fm_field "$f" milestone)"
  created="$(fm_field "$f" created)"
  updated="$(fm_field "$f" updated)"

  # Required fields.
  [ -n "$slug" ]    || err "$rel: missing required field 'slug'"
  [ -n "$repo" ]    || err "$rel: missing required field 'repository'"
  [ -n "$status" ]  || err "$rel: missing required field 'status'"
  [ -n "$created" ] || warn "$rel: missing 'created'"
  [ -n "$updated" ] || warn "$rel: missing 'updated'"

  # Slug should match the file name and the directory should match the repository.
  base="$(basename "$f" .md)"
  [ -z "$slug" ] || [ "$slug" = "$base" ] || warn "$rel: slug '$slug' != file name '$base'"
  dir="$(basename "$(dirname "$f")")"
  [ -z "$repo" ] || [ "$repo" = "$dir" ] || warn "$rel: repository '$repo' != directory '$dir'"

  # Slug uniqueness.
  if [ -n "$slug" ]; then
    if [ -n "${seen_slug[$slug]:-}" ]; then
      err "$rel: duplicate slug '$slug' (also in ${seen_slug[$slug]})"
    else
      seen_slug[$slug]="$rel"
    fi
  fi

  # Status enum.
  if [ -n "$status" ] && ! printf '%s' "$status" | grep -qxE "$PLAN_STATUSES"; then
    err "$rel: unknown status '$status' (allowed: ${PLAN_STATUSES//|/, })"
  fi

  # Size token (optional).
  if [ -n "$size" ] && ! printf '%s' "$size" | grep -qxE "$PLAN_SIZES"; then
    err "$rel: invalid size '$size' (allowed: ${PLAN_SIZES//|/, } or empty)"
  fi

  # Repository resolution + the unconditional agoric-sdk exclusion.
  if [ -n "$repo" ]; then
    url="$(repo_url "$PLAN_DIR" "$repo")"
    if [ -z "$url" ]; then
      err "$rel: repository slug '$repo' not in repositories.md"
    elif printf '%s' "$url" | grep -qiE 'agoric-sdk'; then
      err "$rel: repository '$repo' resolves to agoric-sdk ($url) — excluded unconditionally"
    fi
  fi

  # Milestone reference (optional; warn-only so an unfiled record is not fatal).
  if [ -n "$milestone" ] && [ ! -f "$PLAN_DIR/milestones/$milestone.md" ]; then
    warn "$rel: milestone '$milestone' has no milestones/$milestone.md"
  fi

  # depends_on resolution across the whole record set (dangling edge = warn).
  while IFS= read -r dep; do
    [ -n "$dep" ] || continue
    slug_known "$dep" || warn "$rel: depends_on '$dep' resolves to no known design slug"
  done < <(fm_list "$f" depends_on)
done < <(list_records "$PLAN_DIR")

printf 'plan-validate: %d record(s), %d error(s), %d warning(s)\n' \
  "$(list_records "$PLAN_DIR" | grep -c . || true)" "$errors" "$warnings" >&2
[ "$errors" -eq 0 ]
