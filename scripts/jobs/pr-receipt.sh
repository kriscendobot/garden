#!/bin/bash
# pr-receipt.sh — generate, post, and archive a PR COMPLETION RECEIPT for one PR the
# garden finished (merged OR closed). Deterministic, plain code, NO `claude -p`.
# Design: designs/pr-completion-receipts.md.
#
# Usage: pr-receipt.sh <owner/repo> <pr-number> [--no-post] [--dir <journal-clone>]
#   --no-post   generate + archive only; never post the PR comment. Used to backfill
#               demonstration receipts from historical PRs without commenting on them.
#   --dir       reuse an already-synced journal clone (git-log runs against it — never
#               the deployed root repo). Default: a private clone under $GARDEN_STATE.
#
# WHAT IT PRODUCES
#   1. A table of per-ENGAGEMENT rows (one per usage/<base>.jsonl result row): role,
#      harness, model, billable tokens, notional $ — grouped by base with a ∑ subtotal
#      row carrying the base's CALIBRATED (true-cost) dollars, then a PR grand total.
#   2. One per-PR MAINTAINER-REVIEW-EFFORT figure (minutes + dollars + ratio to the
#      machine calibrated cost) from the human feedback the PR drew (§ MRE below).
#   3. A PR comment (unless --no-post), via the fleet's identity-pinned `gh` wrapper.
#   4. A journal archive at receipts/<repo-slug>/<YYYY>/<MM>/pr<N>.md (full receipt).
#
# COMPOSITION, NOT INVENTION. The base->PR join and the true-cost pricing are reused
# from cost-by-pr.sh --base-map (which this extends rather than duplicates). The
# per-engagement token/notional detail comes from usage/<base>.jsonl. The MRE inputs
# come from three `gh api` review/comment endpoints, filtered to HUMAN authors by a
# fixed login/association test (no LLM ever reads a comment body — only counts and
# measures its length). Posting rides the same identity-pinned gh wrapper and the same
# maintainer-cleared comment-repos/ set the comment/CI watchers use; it widens the
# monitoring surface by nothing.
#
# IDEMPOTENT. Three independent guards (any one sufficient): the journal archive file,
# the PR-body/comment <!-- garden-receipt: repo#N --> marker, and post-job.sh basename
# CAS upstream. A crashed retry re-runs both steps, each skipped if its own marker is
# already satisfied — never a double post.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=receipt-defaults.sh
source "$HERE/receipt-defaults.sh"
export GARDEN_TAG="pr-receipt"

repo="" pr="" no_post=0 dir=""
while [ $# -gt 0 ]; do
  case "$1" in
    --no-post) no_post=1; shift ;;
    --dir)     dir="${2:?}"; shift 2 ;;
    -h|--help) sed -n '2,45p' "${BASH_SOURCE[0]}"; exit 0 ;;
    -*)        die "unknown argument: $1" ;;
    *) if [ -z "$repo" ]; then repo="$1"; elif [ -z "$pr" ]; then pr="$1"; else die "extra argument: $1"; fi; shift ;;
  esac
done
[ -n "$repo" ] && [ -n "$pr" ] || die "usage: pr-receipt.sh <owner/repo> <pr-number> [--no-post] [--dir <clone>]"
case "$pr" in ''|*[!0-9]*) die "pr-number must be numeric, got '$pr'";; esac
case "$repo" in */*) : ;; *) die "repo must be owner/name, got '$repo'";; esac
command -v jq >/dev/null 2>&1 || die "pr-receipt.sh needs jq"
command -v gh >/dev/null 2>&1 || die "pr-receipt.sh needs gh"

owner="${repo%%/*}"; name="${repo#*/}"
slug="$owner-$name"                       # archive top dir; matches the watcher slug
marker="<!-- garden-receipt: $repo#$pr -->"

# --- journal clone (read for ledgers, write for the archive) ------------------
if [ -z "$dir" ]; then
  dir="${GARDEN_RECEIPT_CLONE:-$GARDEN_STATE/receipts/journal}"
  ensure_clone "$dir"; sync_clone "$dir" || die "could not sync journal clone $dir"
fi
[ -d "$dir/reputation/events" ] || die "no reputation/events under $dir (nothing to price)"

TMP="$(mktemp -d "${TMPDIR:-/tmp}/pr-receipt.XXXXXX")"; trap 'rm -rf "$TMP"' EXIT

# --- 1. resolve PR terminal state --------------------------------------------
pr_json="$(gh api "repos/$repo/pulls/$pr" 2>/dev/null)" || die "could not read repos/$repo/pulls/$pr"
merged_at="$(printf '%s' "$pr_json" | jq -r '.merged_at // empty')"
closed_at="$(printf '%s' "$pr_json" | jq -r '.closed_at // empty')"
state="$(printf '%s' "$pr_json" | jq -r '.state // "unknown"')"
title="$(printf '%s' "$pr_json" | jq -r '.title // ""')"
if [ -n "$merged_at" ]; then
  disposition="merged"; completed_at="$merged_at"
elif [ -n "$closed_at" ]; then
  disposition="closed"; completed_at="$closed_at"
else
  die "$repo#$pr is not in a terminal state (state=$state) — receipts are for completed PRs only"
fi
comp_year="${completed_at:0:4}"; comp_month="${completed_at:5:2}"
archive_rel="receipts/$slug/$comp_year/$comp_month/pr$pr.md"

# --- 2. resolve the bases joined to this PR (reuse cost-by-pr.sh's join) ------
# A one-line pr-cache lets cost-by-pr.sh validate base-name edges for THIS PR without
# the slow full-repo `gh pr list`; jobs/index edges resolve regardless of the cache.
printf '%s\t%s\t%s\n' "$repo" "$pr" "$disposition" > "$TMP/prcache.tsv"
# GARDEN_RECEIPT_BASEMAP: reuse a pre-computed cost-by-pr.sh --base-map dump (the full
# base->PR join priced once) instead of re-pricing the whole ledger per PR. The pricing
# pass is O(all reputation events); a batch backfill (or a future caching layer) sets
# this to run it once and filter per PR. Unset ⇒ the self-contained single-PR path.
if [ -n "${GARDEN_RECEIPT_BASEMAP:-}" ] && [ -f "$GARDEN_RECEIPT_BASEMAP" ]; then
  cp "$GARDEN_RECEIPT_BASEMAP" "$TMP/basemap.tsv"
else
  "$HERE/cost-by-pr.sh" --base-map --dir "$dir" --pr-cache "$TMP/prcache.tsv" > "$TMP/basemap.tsv" 2>/dev/null \
    || die "cost-by-pr.sh --base-map failed"
fi
# keep only the bases that joined to THIS PR: columns = base pr state ceil calibrated
awk -F'\t' -v want="$repo#$pr" '$2==want{print}' "$TMP/basemap.tsv" > "$TMP/bases.tsv" || true
n_bases="$(wc -l < "$TMP/bases.tsv" | tr -d ' ')"

# --- 3. per-engagement rows from usage/<base>.jsonl --------------------------
# ENG rows:  base role harness model billable cache_read notional
# BASE rows: base tok_sum notional_sum calibrated ceil_flag  (∑ subtotal per base)
: > "$TMP/eng.tsv"; : > "$TMP/basesum.tsv"
pr_tok=0; pr_notional=0; pr_calib=0; pr_ceil=0; n_eng=0
rep_field() { sed -n "s/^$2:[[:space:]]*//p" "$1" 2>/dev/null | head -1; }
while IFS=$'\t' read -r base _pr _state ceil calib; do
  [ -n "$base" ] || continue
  ev="$dir/reputation/events/$base.md"
  rep_prov="$(rep_field "$ev" provider)"
  rep_kind="$(rep_field "$ev" kind)"
  usage="$dir/usage/$base.jsonl"
  b_tok=0; b_notional=0
  if [ -f "$usage" ]; then
    while IFS=$'\t' read -r role prov model itok otok ctok crtok notional; do
      [ -n "$model$role$prov" ] || continue
      [ "$role" = "null" ] || [ -n "$role" ] || role=""
      [ -n "$role" ] && [ "$role" != "null" ] || role="${rep_kind:-—}"
      [ -n "$prov" ] && [ "$prov" != "null" ] || prov="$rep_prov"
      [ -n "$prov" ] && [ "$prov" != "null" ] || prov="$(receipt_provider_of_model "$model")"
      harness="$(receipt_harness "$prov")"
      billable="$(awk -v a="$itok" -v b="$otok" -v c="$ctok" 'BEGIN{printf "%d", (a+0)+(b+0)+(c+0)}')"
      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$base" "$role" "$harness" "${model:-—}" "$billable" "${crtok:-0}" "${notional:-0}" >> "$TMP/eng.tsv"
      b_tok=$((b_tok + billable))
      b_notional="$(awk -v x="$b_notional" -v y="${notional:-0}" 'BEGIN{printf "%.6f", x+y}')"
      n_eng=$((n_eng+1))
    done < <(jq -r 'select(.source=="result") | [(.role//""),(.provider//""),(.model//""),(.input_tokens//0),(.output_tokens//0),(.cache_creation_tokens//0),(.cache_read_tokens//0),(.total_cost_usd//0)] | @tsv' "$usage" 2>/dev/null)
  fi
  # calibrated: the cost-by-pr true-cost figure. ceil=1 is a modelling ceiling
  # (openai/unmeasured arm), NOT money — excluded from the measured calibrated total.
  printf '%s\t%s\t%s\t%s\t%s\n' "$base" "$b_tok" "$b_notional" "${calib:-0}" "${ceil:-0}" >> "$TMP/basesum.tsv"
  pr_tok=$((pr_tok + b_tok))
  pr_notional="$(awk -v x="$pr_notional" -v y="$b_notional" 'BEGIN{printf "%.6f", x+y}')"
  if [ "${ceil:-0}" = "1" ]; then
    pr_ceil="$(awk -v x="$pr_ceil" -v y="${calib:-0}" 'BEGIN{printf "%.6f", x+y}')"
  else
    pr_calib="$(awk -v x="$pr_calib" -v y="${calib:-0}" 'BEGIN{printf "%.6f", x+y}')"
  fi
done < "$TMP/bases.tsv"

# --- 4. maintainer-review-effort (MRE) heuristic ------------------------------
# Human-author filter: drop the fleet bot, its fork-owner logins, Copilot, and any
# login ending [bot]. Everything else is treated as human maintainer feedback.
: > "$TMP/botlogins"
{ echo "${GARDEN_BOT_LOGIN:-kriscendobot}"; echo Copilot
  [ -d "$dir/config" ] && [ -f "$dir/config/fork-owners" ] && cat "$dir/config/fork-owners" 2>/dev/null
} | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]' | sed '/^$/d' | sort -u > "$TMP/botlogins" || true
is_bot_login() {  # is_bot_login <login>
  local l; l="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$l" in *'[bot]') return 0 ;; esac
  grep -qxF "$l" "$TMP/botlogins" 2>/dev/null && return 0
  return 1
}
# Gather all three human-feedback streams into one TSV: login ts bodylen counts_comment
# reviews (submitted_at, body may be empty — still a sitting), pull inline comments and
# issue comments (created_at, always a comment). Paginated authoritative reads.
gh_stream() {  # gh_stream <api-path> <ts-field> <count-as-comment 0|1>
  gh api --paginate "$1" 2>/dev/null \
    | jq -r --arg tf "$2" --argjson cc "$3" '
        ( if type=="array" then .[] else . end )
        | select(.user and .user.login)
        | [ .user.login, (.[$tf] // ""), ((.body // "") | length),
            (if $cc==1 or ((.body // "")|length)>0 then 1 else 0 end) ] | @tsv' 2>/dev/null || true
}
{
  gh_stream "repos/$repo/pulls/$pr/reviews"   submitted_at 0
  gh_stream "repos/$repo/pulls/$pr/comments"  created_at   1
  gh_stream "repos/$repo/issues/$pr/comments" created_at   1
} > "$TMP/feedback.tsv"

S_pairs="$TMP/sittings"; : > "$S_pairs"
C=0; L=0
while IFS=$'\t' read -r login ts blen iscomment; do
  [ -n "$login" ] || continue
  is_bot_login "$login" && continue
  day="${ts:0:10}"
  [ -n "$day" ] && printf '%s\t%s\n' "$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')" "$day" >> "$S_pairs"
  if [ "${iscomment:-0}" = "1" ] && [ "${blen:-0}" -gt 0 ]; then
    C=$((C+1)); L=$((L + blen))
  fi
done < "$TMP/feedback.tsv"
S="$(sort -u "$S_pairs" 2>/dev/null | grep -c . || true)"; S="${S:-0}"
[ "$S" -lt 1 ] && S=1                     # floor: even a silent merge/close is one glance

a="$(receipt_config "$dir" mre-a-min-per-sitting "$GARDEN_RECEIPT_MRE_A")"
b="$(receipt_config "$dir" mre-b-min-per-comment "$GARDEN_RECEIPT_MRE_B")"
r="$(receipt_config "$dir" mre-r-chars-per-min "$GARDEN_RECEIPT_MRE_R")"
H="$(receipt_config "$dir" maintainer-hourly-usd "$GARDEN_RECEIPT_HOURLY_USD")"
mre_min="$(awk -v s="$S" -v c="$C" -v l="$L" -v a="$a" -v b="$b" -v r="$r" \
  'BEGIN{ if (r<=0) r=750; printf "%.0f", s*a + c*b + l/r }')"
mre_usd="$(awk -v m="$mre_min" -v h="$H" 'BEGIN{ printf "%.2f", (m/60.0)*h }')"
ratio="$(awk -v mu="$mre_usd" -v cc="$pr_calib" 'BEGIN{ if ((cc+0)>0) printf "%.0f", mu/cc; else printf "n/a" }')"

# machine review context (panel rounds for this PR), best-effort. Never clobbers the
# MRE `r` constant — uses its own locals. fix_iters is left 0 (no per-PR fix-loop
# counter is reliably keyed by <slug>-<pr> in the journal today; context-only field).
panel_rounds=0; fix_iters=0
for prd in "$dir/panel-runs/$slug-$pr" "$dir/panel-runs/$slug-pr$pr"; do
  [ -d "$prd" ] || continue
  for pmd in "$prd"/*.md; do
    [ -f "$pmd" ] || continue
    prr="$(sed -n 's/^rounds:[[:space:]]*//p' "$pmd" | head -1)"
    case "$prr" in ''|*[!0-9]*) : ;; *) [ "$prr" -gt "$panel_rounds" ] && panel_rounds="$prr" ;; esac
  done
done

# --- 5. render the receipt ----------------------------------------------------
usd() { awk -v x="${1:-0}" 'BEGIN{ printf "%.2f", x+0 }'; }
dispo_note="merged"; [ "$disposition" = "closed" ] && dispo_note="closed, not merged"

render_table() {  # render_table <mode: full|distilled>
  local mode="$1"
  printf '| base | role | harness | model | tokens (billable) | notional \$ | calibrated \$ |\n'
  printf '|---|---|---|---:|---:|---:|---:|\n'
  local base
  while IFS=$'\t' read -r base b_tok b_notional calib ceil; do
    [ -n "$base" ] || continue
    if [ "$mode" = full ]; then
      # per-engagement rows for this base
      awk -F'\t' -v want="$base" '$1==want{ printf "| `%s` | %s | %s | `%s` | %s | %s | — |\n", $1, $2, $3, $4, $5, $7 }' "$TMP/eng.tsv"
    fi
    local calshow="—" has_cal
    has_cal="$(awk -v c="$calib" 'BEGIN{ print ((c+0)>0)?1:0 }')"
    if [ "$has_cal" = 1 ]; then
      if [ "$ceil" = "1" ]; then calshow="_(ceil $(usd "$calib"))_"; else calshow="**$(usd "$calib")**"; fi
    fi
    printf '| `%s` **∑** | | | | %s | %s | %s |\n' "$base" "$b_tok" "$(usd "$b_notional")" "$calshow"
  done < "$TMP/basesum.tsv"
  printf '| **PR total** | | | | **%s** | **%s** | **%s** |\n' "$pr_tok" "$(usd "$pr_notional")" "$(usd "$pr_calib")"
}

render_body() {  # render_body <mode>
  local mode="$1"
  printf '## 🧾 Garden completion receipt — %s#%s (%s)\n\n' "$repo" "$pr" "$dispo_note"
  printf 'Completed %s. %s engagement(s) across %s base(s). ' "$completed_at" "$n_eng" "$n_bases"
  printf 'Basis: **calibrated** = capped proxy-wallclock × `reputation/rate-card.md` '
  printf '(true cost); **notional** = usage-ledger list price (~8.7× high on a flat '
  printf 'subscription).\n\n'
  render_table "$mode"
  printf '\n'
  printf '**Maintainer review (heuristic): ~%s min ≈ $%s** — %s review sitting(s), ' "$mre_min" "$mre_usd" "$S"
  printf '%s human comment(s) (%s chars). ' "$C" "$L"
  if [ "$ratio" = "n/a" ]; then
    printf 'Machine calibrated cost is uncensored $0 for this PR, so no ratio is shown.\n'
  else
    printf 'That is **≈ %s×** the machine calibrated cost ($%s).\n' "$ratio" "$(usd "$pr_calib")"
  fi
  [ "$(awk -v c="$pr_ceil" 'BEGIN{print ((c+0)>0)?1:0}')" = 1 ] && \
    printf '\n<sub>Ceiling (unmeasured openai/unknown arms, a modelling bound not money): $%s.</sub>\n' "$(usd "$pr_ceil")"
  printf '\nMachine review context: %s panel round(s), %s fix iteration(s).\n\n' "$panel_rounds" "$fix_iters"
  printf '<sub>Receipt generated deterministically from the journal usage + reputation '
  printf 'ledgers and the PR'"'"'s human review threads. MRE constants a=%s b=%s r=%s H=%s ' "$a" "$b" "$r" "$H"
  printf '(journal-tunable). Archived at `%s`.</sub>\n' "$archive_rel"
  printf '%s\n' "$marker"
}

body="$(render_body full)"
# Size discipline: GitHub caps a comment body at ~65 KB. If the full per-engagement
# table blows past a safe bound, distill to per-base ∑ rows only (the archive keeps
# the full table). Mirrors panel.sh's foreperson-distillation precedent.
if [ "${#body}" -gt 60000 ]; then
  body="$(render_body distilled)"
  body="$(printf '%s' "$body" | sed 's|Archived at|Per-engagement rows distilled for size; full table archived at|')"
fi

# --- 6. write the journal archive (full receipt, CAS) ------------------------
archive_body="$(render_body full)"
write_archive() {
  local attempt rc
  ensure_clone "$dir"
  for attempt in $(seq 1 50); do
    sync_clone "$dir"
    if [ -f "$dir/$archive_rel" ]; then log "archive $archive_rel already present — leaving it"; return 0; fi
    mkdir -p "$(dirname "$dir/$archive_rel")"
    {
      printf -- '---\n'
      printf 'repo: %s\n' "$repo"
      printf 'pr: %s\n' "$pr"
      printf 'title: %s\n' "$(printf '%s' "$title" | tr '\n' ' ')"
      printf 'completed_at: %s\n' "$completed_at"
      printf 'disposition: %s\n' "$disposition"
      printf 'engagements: %s\n' "$n_eng"
      printf 'bases: %s\n' "$n_bases"
      printf 'tokens_billable: %s\n' "$pr_tok"
      printf 'notional_usd: %s\n' "$(usd "$pr_notional")"
      printf 'calibrated_usd: %s\n' "$(usd "$pr_calib")"
      printf 'maintainer_review_minutes: %s\n' "$mre_min"
      printf 'maintainer_review_usd: %s\n' "$mre_usd"
      printf 'maintainer_dominance_ratio: %s\n' "$ratio"
      printf 'generated_at: %s\n' "$(date -u +%FT%TZ)"
      printf 'generated_by: %s\n' "${GARDEN:-unknown}"
      printf -- '---\n\n'
      printf '%s\n' "$archive_body"
    } > "$dir/$archive_rel"
    git -C "$dir" add "$archive_rel"
    rc=0; commit_and_push "$dir" "receipt($slug#$pr): archive completion receipt" || rc=$?
    [ "$rc" -eq 0 ] && { log "archived $archive_rel"; return 0; }
    [ "$rc" -eq 2 ] && { log "archive $archive_rel already committed"; return 0; }
    log "archive push lost a race (attempt $attempt); re-syncing"; backoff "$attempt"
  done
  die "could not write archive $archive_rel after retries"
}
write_archive

# --- 7. post the PR comment (unless --no-post) -------------------------------
if [ "$no_post" -eq 1 ]; then
  log "generated + archived receipt for $repo#$pr (--no-post: NOT posting a comment)"
  printf '%s\n' "$dir/$archive_rel"
  exit 0
fi

# Monitoring-safety: post ONLY on the maintainer-cleared comment-repos/ set.
if [ ! -f "$dir/comment-repos/$slug" ]; then
  log "WARN: $repo not on comment-repos/ set — archived only, NOT posting (monitoring-safety constraint)"
  printf '%s\n' "$dir/$archive_rel"
  exit 0
fi
# Idempotency: skip the post if a receipt comment marker already exists on the PR.
if gh api --paginate "repos/$repo/issues/$pr/comments" 2>/dev/null \
     | jq -r '.[]?.body // empty' 2>/dev/null | grep -qF "$marker"; then
  log "receipt comment already present on $repo#$pr — idempotent skip of the post"
  printf '%s\n' "$dir/$archive_rel"
  exit 0
fi
bf="$TMP/comment.md"; printf '%s\n' "$body" > "$bf"
if gh pr comment "$pr" -R "$repo" --body-file "$bf" >/dev/null 2>&1; then
  log "posted completion receipt comment on $repo#$pr"
else
  log "WARN: could not post receipt comment on $repo#$pr (archive is written; a retry will re-post)"
fi
printf '%s\n' "$dir/$archive_rel"
