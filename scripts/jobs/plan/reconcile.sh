#!/bin/bash
# plan/reconcile.sh — advance each plan record's lifecycle by comparing its
# status/pr against actual PR and board state (per designs/plan-in-journal.md).
#
# Usage: plan/reconcile.sh <plan-dir> [<journal-dir>]
#   <plan-dir>     the journal/plan tree (records are mutated in place)
#   <journal-dir>  the journal worktree root (for board state); default = <plan-dir>/..
#
# Reconciliation is continuous and NOT maintainer-gated. The Complete flip is
# automatic: when a record's `pr` is observed merged, the record advances to
# Complete on its own, with an audit note appended to the record body. This script
# does the detection + mutation; the CALLER stages/commits/pushes the result (the
# bulletin loop or the weekly Sunday job), so reconcile itself does no git network.
#
# Detection: GitHub PR merge state, for records whose `pr` resolves to a GitHub
# URL. The design's authoritative Complete signal is a *detected merge* — a
# completed *board* job (a build/design job reaching tada) is NOT a merge and must
# not flip a record to Complete, so the board is used only as a non-authoritative
# cross-check note, never as a flip trigger.
# A record already in a done/terminal state (Complete/Active/Reference/Deprecated/
# Superseded) is left untouched. Forgiving: a record with no resolvable merged PR
# is a no-op.
#
# Network is gated: set GARDEN_PLAN_RECONCILE_GH=0 to skip all gh queries (board-
# only mode), e.g. for the per-tick bulletin path before merge-detection is proven.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
[ -f "$HERE/../common.sh" ] && { GARDEN_TAG="plan-reconcile"; source "$HERE/../common.sh" 2>/dev/null || true; }

PLAN_DIR="${1:?usage: reconcile.sh <plan-dir> [<journal-dir>]}"
JOURNAL_DIR="${2:-$(cd "$PLAN_DIR/.." && pwd)}"
: "${GARDEN_PLAN_RECONCILE_GH:=1}"
[ -d "$PLAN_DIR" ] || { echo "plan-reconcile: no plan dir at $PLAN_DIR" >&2; exit 0; }

now_iso="$(date -u +%FT%TZ)"
changed=0

# Resolve a record's `pr` value + its repository URL into "owner/name#N", or empty
# if it does not resolve to a GitHub PR. Forms: <repo-slug>#N | owner/name#N |
# https://github.com/owner/name/pull/N.
resolve_gh_pr() {
  local pr="$1" repo_slug="$2" url owner_name num
  case "$pr" in
    *github.com/*/pull/*) owner_name="$(printf '%s' "$pr" | sed -E 's|.*github.com/([^/]+/[^/]+)/pull/[0-9]+.*|\1|')"
                          num="$(printf '%s' "$pr" | sed -E 's|.*/pull/([0-9]+).*|\1|')";;
    */*#[0-9]*)          owner_name="${pr%#*}"; num="${pr#*#}";;
    *#[0-9]*)            num="${pr#*#}"
                          url="$(repo_url "$PLAN_DIR" "$repo_slug")"
                          case "$url" in *github.com/*) owner_name="$(printf '%s' "$url" | sed -E 's|.*github.com/([^/]+/[^/.]+).*|\1|')";; *) return 0;; esac;;
    *) return 0;;
  esac
  [ -n "$owner_name" ] && [ -n "$num" ] && printf '%s#%s\n' "$owner_name" "$num"
}

# Is a GitHub PR merged? echo "merged" / "" (best-effort; never fatal).
pr_is_merged() {
  [ "$GARDEN_PLAN_RECONCILE_GH" = 1 ] || return 0
  command -v gh >/dev/null 2>&1 || return 0
  local on="${1%#*}" num="${1#*#}" state
  state="$(gh pr view "$num" --repo "$on" --json mergedAt --jq '.mergedAt // empty' 2>/dev/null || true)"
  [ -n "$state" ] && printf 'merged\n' || true
}

while IFS= read -r f; do
  [ -n "$f" ] || continue
  slug="$(fm_field "$f" slug)"; [ -n "$slug" ] || slug="$(basename "$f" .md)"
  status="$(fm_field "$f" status)"
  repo="$(fm_field "$f" repository)"
  pr="$(fm_field "$f" pr)"
  is_complete_status "$status" && continue
  case "$status" in Deprecated|Superseded) continue;; esac

  reason=""
  if [ -n "$pr" ]; then
    gh_pr="$(resolve_gh_pr "$pr" "$repo")"
    if [ -n "$gh_pr" ] && [ "$(pr_is_merged "$gh_pr")" = merged ]; then
      reason="PR $gh_pr observed merged"
    fi
  fi
  [ -n "$reason" ] || continue

  # Flip to Complete and append an audit note to the body.
  tmpf="$(mktemp)"
  awk -v now="$now_iso" '
    NR==1 && $0!="---" { print; next }
    inhdr==0 && $0=="---" { inhdr=1; print; next }
    inhdr==1 {
      if ($0=="---") {
        # close the frontmatter: stamp updated if not already present this pass
        print "updated: " now
        inhdr=2; print; next
      }
      if ($0 ~ /^status:/) { print "status: Complete"; seen_status=1; next }
      if ($0 ~ /^updated:/) { next }  # drop; re-emit just before closing ---
      print; next
    }
    { print }
  ' "$f" > "$tmpf"
  {
    printf '\n---\n_Reconciled %s: status → Complete (%s)._\n' "$now_iso" "$reason"
  } >> "$tmpf"
  mv "$tmpf" "$f"
  changed=$((changed+1))
  printf 'reconciled %s: Complete (%s)\n' "$slug" "$reason" >&2
done < <(list_records "$PLAN_DIR")

echo "plan-reconcile: $changed record(s) advanced" >&2
