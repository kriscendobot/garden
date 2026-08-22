#!/bin/bash
# related-design-state.sh — the deterministic (no-LLM) producer of CURRENT
# related-design review state, shared by the BUILD-preparation boundary and the
# code-PANEL boundary. Given a repo and the set of related design PRs a change
# declares (or that are discoverable from the change's own PR body), it RE-FETCHES
# each related design PR's live review decision and timestamps and answers one
# deterministic question: does an OUTSTANDING maintainer changes-requested
# direction still stand on a design this implementation depends on?
#
# Why this exists — the stale-related-design-direction review-miss cluster
# (review-misses/clusters/stale-related-design-direction.md, member
# kriscendobot/minion.town#48). On PR 48 the build asserted its serving slice was
# "independent" of the adjacent design PR 47 based only on a design DOCUMENT, while
# PR 47 already carried a maintainer changes-requested review that replaced the very
# seam PR 48 built on. The build and four code-panel rounds proceeded; the maintainer
# closed PR 48 for reconstruction. A design document is a snapshot; the PR's CURRENT
# review state is the live direction. This helper makes the live state a hard,
# machine-checkable input so no build or panel can declare independence from a stale
# doc/report. The SEMANTIC judgment — does the proposed seam still COMPOSE with the
# outstanding direction — stays with the agent (the builder at prep, the integrator
# seat at panel); this helper only surfaces the discoverable facts and fires toward
# review, never silently infers independence.
#
# Relatedness is DECLARED, never invented. The helper does not guess which open
# design PRs are "related" (that is a semantic call); it re-fetches only the PRs a
# change explicitly names, so an UNRELATED design PR — however hot its review — never
# blocks. A related PR whose changes-requested review was later approved/dismissed
# (reviewDecision no longer CHANGES_REQUESTED) is SATISFIED and likewise does not
# block. Only a related PR whose latest maintainer direction still stands as
# changes-requested raises attention.
#
# The related set is the UNION of:
#   * --related <n,n,...>            explicit numbers (the builder's dependency walk)
#   * a `<!-- garden-related-design: N,N -->` marker in --self's PR body (durable,
#     cross-incarnation, the same marker shape ensure-pr.sh uses for job identity),
#     re-fetched at the panel boundary so the build's declaration survives to review.
# --self (the change's own PR) is always excluded from the set.
#
# Output (stdout, grep-able AND human-readable). One line per related PR:
#   related-design pr=<n> decision=<CHANGES_REQUESTED|APPROVED|REVIEW_REQUIRED|none> \
#     relation=<outstanding|satisfied|none> changes_requested_at=<iso|-> \
#     impl_ref=<iso|-> newer_than_impl=<yes|no|unknown> title="..."
# then one verdict line:
#   related-design-verdict=<attention|clear>
# `attention` iff >=1 related PR has relation=outstanding.
#
# `newer_than_impl` compares the outstanding direction's timestamp to the
# implementation reference instant (--impl-ref / --worktree). It is EVIDENCE and a
# severity signal, NOT the trigger: the historical miss fired with the direction
# PREDATING the implementation's first commit (PR 47 review 2026-08-17T23:22:53Z
# before PR 48's first commit 2026-08-18T00:38:55Z), so requiring "newer" would have
# missed it. The trigger is simply an outstanding related direction; the timestamp
# tells the panel whether a later re-panel round saw NEWER direction than the head it
# reviewed (so a prior "clear" cannot stand).
#
# Exit status:
#   0  clear     — no related PR carries outstanding changes-requested direction
#   10 attention — >=1 related PR does (the caller reconciles or redirects/forces review)
#   2  usage error
#   3  could not determine (missing tools / gh failure / unresolvable related PR) —
#      surfaced, NEVER silently treated as clear (fail toward review, like the panel's
#      over-review bias). A caller that must not hard-block on an infra hiccup can map
#      3 to a warning, but 3 is distinct from 0 on purpose.
#
# Usage:
#   related-design-state.sh <repo> [--related N,N] [--self N] [--impl-ref ISO]
#                                  [--worktree DIR [--base REF]] [--evidence-file F]
#
# Test seam: GARDEN_GH overrides the gh binary (a stub), resolved with the same
# stale-override-is-non-fatal guard as ci-wait-merge.sh / ensure-pr.sh.

set -uo pipefail

log()  { echo "related-design-state: $*" >&2; }
die()  { log "$*"; exit 2; }

repo="${1:-}"
case "$repo" in ""|-*) die "usage: related-design-state.sh <repo> [options]";; esac
shift

related_csv=""
self=""
impl_ref=""
worktree=""
base=""
evidence_file=""
while [ $# -gt 0 ]; do
  case "$1" in
    --related)       related_csv="${2:?--related needs N,N}"; shift 2;;
    --self)          self="${2:?--self needs a PR number}"; shift 2;;
    --impl-ref)      impl_ref="${2:?--impl-ref needs an ISO instant}"; shift 2;;
    --worktree)      worktree="${2:?--worktree needs a dir}"; shift 2;;
    --base)          base="${2:?--base needs a ref}"; shift 2;;
    --evidence-file) evidence_file="${2:?--evidence-file needs a path}"; shift 2;;
    *) die "unknown option: '$1'";;
  esac
done

# --- resolve the gh binary (stale GARDEN_GH override is non-fatal) -----------
GH="gh"
if [ -n "${GARDEN_GH:-}" ]; then
  if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
    GH="$GARDEN_GH"
  else
    log "GARDEN_GH=$GARDEN_GH does not resolve; falling back to the PATH gh"
  fi
fi
command -v "$GH" >/dev/null 2>&1 || { log "gh not found — cannot determine related-design state"; exit 3; }
command -v jq  >/dev/null 2>&1 || { log "jq not found — cannot determine related-design state"; exit 3; }

# --- resolve the implementation reference instant ---------------------------
# Prefer an explicit --impl-ref. Else derive from the worktree: the FIRST commit on
# the branch (base..HEAD, reverse) is the implementation's inception — the instant
# the miss uses ("PR 48's first commit"). Fall back to HEAD's commit time, then to
# empty (unknown) when there is no git context. Empty impl_ref only makes
# newer_than_impl `unknown`; it never suppresses the attention trigger.
impl_ref_iso="$impl_ref"
if [ -z "$impl_ref_iso" ] && [ -n "$worktree" ] && [ -d "$worktree" ]; then
  if [ -n "$base" ]; then
    impl_ref_iso="$(git -C "$worktree" log --format=%cI --reverse "$base..HEAD" 2>/dev/null | head -1)"
  fi
  [ -n "$impl_ref_iso" ] || impl_ref_iso="$(git -C "$worktree" log -1 --format=%cI HEAD 2>/dev/null || true)"
fi
[ -n "$impl_ref_iso" ] || impl_ref_iso=""

# --- assemble the DECLARED related set --------------------------------------
# Numbers only, deduped, --self excluded. The union of --related and the self PR
# body's `garden-related-design:` marker.
declare -A seen=()
related=()
add_related() {  # add_related <n>
  local n="${1//[!0-9]/}"
  [ -n "$n" ] || return 0
  [ -n "$self" ] && [ "$n" = "${self//[!0-9]/}" ] && return 0
  [ -n "${seen[$n]:-}" ] && return 0
  seen[$n]=1; related+=("$n")
}

if [ -n "$related_csv" ]; then
  IFS=', ' read -r -a _explicit <<EOF
$related_csv
EOF
  for n in "${_explicit[@]}"; do add_related "$n"; done
fi

# Discover from --self's PR body marker (re-fetched live; the build embeds it so the
# panel rediscovers the declaration without carrying it in the gardener's memory).
if [ -n "$self" ]; then
  body="$("$GH" pr view "$self" -R "$repo" --json body --jq '.body' 2>/dev/null || true)"
  if [ -n "$body" ]; then
    # `<!-- garden-related-design: 47, 49 -->` (whitespace tolerant).
    marker="$(printf '%s\n' "$body" | sed -n 's/.*<!--[[:space:]]*garden-related-design:[[:space:]]*\([0-9, ]*\).*-->.*/\1/p' | head -1)"
    if [ -n "$marker" ]; then
      IFS=', ' read -r -a _marked <<EOF
$marker
EOF
      for n in "${_marked[@]}"; do add_related "$n"; done
    fi
  fi
fi

# --- write the evidence header (if requested) --------------------------------
emit() { printf '%s\n' "$1"; [ -n "$evidence_file" ] && printf '%s\n' "$1" >> "$evidence_file"; }
[ -n "$evidence_file" ] && : > "$evidence_file"

if [ "${#related[@]}" -eq 0 ]; then
  emit "related-design-verdict=clear"
  log "no related design PRs declared (via --related or a garden-related-design marker); nothing to reconcile"
  exit 0
fi

# --- classify each related design PR ----------------------------------------
attention=0
unresolved=0
for n in "${related[@]}"; do
  meta="$("$GH" pr view "$n" -R "$repo" --json number,title,isDraft,state,reviewDecision,latestReviews,headRefOid,updatedAt 2>/dev/null)" || meta=""
  if [ -z "$meta" ] || ! printf '%s' "$meta" | jq -e . >/dev/null 2>&1; then
    log "could not fetch related design PR #$n on $repo — surfacing as unresolved (not clear)"
    emit "related-design pr=$n decision=unknown relation=unknown changes_requested_at=- impl_ref=${impl_ref_iso:--} newer_than_impl=unknown title=\"(unresolved)\""
    unresolved=1
    continue
  fi
  title="$(printf '%s' "$meta" | jq -r '.title // ""' | tr '\n' ' ' | sed 's/"/'"'"'/g')"
  state="$(printf '%s' "$meta" | jq -r '.state // ""')"
  decision="$(printf '%s' "$meta" | jq -r '.reviewDecision // ""')"
  # The latest changes-requested review's timestamp (max submittedAt among the
  # per-user latestReviews whose state is CHANGES_REQUESTED).
  cr_at="$(printf '%s' "$meta" | jq -r '
    ([.latestReviews[]? | select(.state=="CHANGES_REQUESTED") | .submittedAt] | sort | last) // "" ')"
  # Derive the decision when the rollup is empty (a repo with no branch protection
  # returns "" even with a standing changes-requested review): a latest review of
  # CHANGES_REQUESTED not superseded by a later APPROVED from the same author.
  if [ -z "$decision" ]; then
    if [ -n "$cr_at" ]; then decision="CHANGES_REQUESTED"; fi
  fi

  relation="none"
  case "$decision" in
    CHANGES_REQUESTED) relation="outstanding" ;;
    APPROVED)          relation="satisfied" ;;
    *)                 relation="none" ;;
  esac
  # A merged/closed related design PR no longer carries live blocking direction:
  # its outcome has landed (or been abandoned). Only an OPEN related PR can hold an
  # outstanding direction the implementation must still reconcile with.
  if [ "$state" != "OPEN" ] && [ -n "$state" ]; then
    relation="satisfied"
  fi

  newer="unknown"
  if [ -n "$cr_at" ] && [ -n "$impl_ref_iso" ]; then
    a="$(date -d "$cr_at" +%s 2>/dev/null || true)"
    b="$(date -d "$impl_ref_iso" +%s 2>/dev/null || true)"
    if [ -n "$a" ] && [ -n "$b" ]; then
      if [ "$a" -gt "$b" ]; then newer="yes"; else newer="no"; fi
    fi
  fi

  emit "related-design pr=$n decision=${decision:-none} relation=$relation changes_requested_at=${cr_at:--} impl_ref=${impl_ref_iso:--} newer_than_impl=$newer title=\"$title\""
  [ "$relation" = "outstanding" ] && attention=1
done

if [ "$attention" -eq 1 ]; then
  emit "related-design-verdict=attention"
  exit 10
fi
if [ "$unresolved" -eq 1 ]; then
  emit "related-design-verdict=unresolved"
  exit 3
fi
emit "related-design-verdict=clear"
exit 0
