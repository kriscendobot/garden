#!/bin/bash
# pr-receipt.sh — generate, post, and archive a PR COMPLETION RECEIPT for one PR the
# garden finished (merged OR closed). Deterministic, plain code, NO `claude -p`.
# Design: designs/pr-completion-receipts.md.
#
# Usage: pr-receipt.sh <owner/repo> <pr-number> [--no-post] [--dir <journal-clone>]
#                      [--closed-outcome <class> --outcome-evidence <url>
#                       --outcome-note <text> [--successor <owner/repo#N>]]
#   --no-post   generate + archive only; never post the PR comment. Used to backfill
#               demonstration receipts from historical PRs without commenting on them.
#   --force     overwrite an existing journal archive (default: idempotent no-op if
#               present). For regenerating receipts after a generator change.
#   --backfill-rollup  append ONLY the rollup row (receipts/rollup.jsonl) for an
#               already-archived receipt, once; never rewrites the archive markdown
#               and never posts. Old archives keep their retired MRE section.
#   --dir       reuse an already-synced journal clone (git-log runs against it — never
#               the deployed root repo). Default: a private clone under $GARDEN_STATE.
#
# WHAT IT PRODUCES
#   1. A table of per-ENGAGEMENT rows (one per usage/<base>.jsonl result row): role,
#      harness, model, billable tokens, notional $ — grouped by base with a ∑ subtotal
#      row carrying the base's CALIBRATED (true-cost) dollars, then a PR grand total.
#   2. A per-PR measurement ROLLUP: token cost, wall-clock (first claim -> close), Σ job
#      duration, WORDS of human feedback (maintainer vs other), review/verdict counts,
#      gauntlet/fix rounds, tokens by model, and the repo's quality-bar class. Raw
#      numbers only: NO human-effort minutes or dollars (retired 2026-11-05).
#   3. A PR comment (unless --no-post), via the fleet's identity-pinned `gh` wrapper.
#   4. A journal archive at receipts/<repo-slug>/<YYYY>/<MM>/pr<N>.md (full receipt),
#      plus one JSON row in receipts/rollup.jsonl (append-only, `schema` versioned).
#
# COMPOSITION, NOT INVENTION. The base->PR join and the true-cost pricing are reused
# from cost-by-pr.sh --base-map (which this extends rather than duplicates). The
# per-engagement token/notional detail comes from usage/<base>.jsonl. The feedback
# counts come from three `gh api` review/comment endpoints, filtered to HUMAN authors
# by a fixed login test (no LLM ever reads a comment body — plain code counts its
# words). Posting rides the same identity-pinned gh wrapper and the same
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
# This receipt is composed in plain code — NO `claude -p` in this process. Declare it
# machine-authored so the fleet gh wrapper's provenance footer renders `model automatic`
# rather than treating the (absent) model/harness as an instrumentation gap
# (comment-provenance.sh § AUTOMATIC).
export GARDEN_NO_LLM=1

repo="" pr="" no_post=0 dir="" force=0 backfill=0
ROLLUP_REL="receipts/rollup.jsonl"
closed_outcome="" outcome_evidence="" outcome_note="" successor=""
while [ $# -gt 0 ]; do
  case "$1" in
    --no-post) no_post=1; shift ;;
    --force)   force=1; shift ;;
    --backfill-rollup) backfill=1; no_post=1; shift ;;
    --dir)     dir="${2:?}"; shift 2 ;;
    --closed-outcome) closed_outcome="${2:?}"; shift 2 ;;
    --outcome-evidence) outcome_evidence="${2:?}"; shift 2 ;;
    --outcome-note) outcome_note="${2:?}"; shift 2 ;;
    --successor) successor="${2:?}"; shift 2 ;;
    -h|--help) sed -n '2,52p' "${BASH_SOURCE[0]}"; exit 0 ;;
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

# A closed PR is not automatically a failed design.  Classification is deliberately
# evidence-gated: the generator never infers causality from a title or a close event.
# Backfills (or a future classifier) may provide the result after reading the closing
# reason, successor citation, and material approach.  Absent that evidence we say
# unresolved instead of manufacturing a verdict.
if [ "$disposition" = closed ]; then
  closed_outcome="${closed_outcome:-unresolved}"
  case "$closed_outcome" in
    roll-forward|productive-redirect|administrative-continuation|unresolved) ;;
    *) die "invalid --closed-outcome '$closed_outcome'" ;;
  esac
  if [ "$closed_outcome" != unresolved ]; then
    [ -n "$outcome_evidence" ] || die "$closed_outcome requires --outcome-evidence"
    [ -n "$outcome_note" ] || die "$closed_outcome requires --outcome-note"
  fi
else
  [ -z "$closed_outcome$outcome_evidence$outcome_note$successor" ] || \
    die "closed-outcome fields apply only to closed-without-merge PRs"
fi

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
    # jq emits a "-" sentinel for empty/null string fields. This is load-bearing: a
    # truly empty field between two tabs would be SWALLOWED by `read` (tab is IFS
    # whitespace, so consecutive tabs collapse), shifting every later column — the
    # sentinel keeps every field non-empty so the split stays aligned.
    while IFS=$'\t' read -r role prov model itok otok ctok crtok notional; do
      [ -n "$role$prov$model" ] || continue
      [ "$role" != - ] || role="${rep_kind:-—}"
      [ "$prov" != - ] || prov="$rep_prov"
      [ -n "$prov" ] && [ "$prov" != - ] || prov="$(receipt_provider_of_model "$model")"
      [ "$model" != - ] || model="—"
      harness="$(receipt_harness "$prov")"
      billable="$(awk -v a="$itok" -v b="$otok" -v c="$ctok" 'BEGIN{printf "%d", (a+0)+(b+0)+(c+0)}')"
      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$base" "$role" "$harness" "$model" "$billable" "$crtok" "$notional" >> "$TMP/eng.tsv"
      b_tok=$((b_tok + billable))
      b_notional="$(awk -v x="$b_notional" -v y="$notional" 'BEGIN{printf "%.6f", x+y}')"
      n_eng=$((n_eng+1))
    done < <(jq -r 'select(.source=="result")
        | def z: if (.==null or .=="") then "-" else . end;
          [ (.role|z), (.provider|z), (.model|z),
            (.input_tokens//0), (.output_tokens//0), (.cache_creation_tokens//0),
            (.cache_read_tokens//0), (.total_cost_usd//0) ] | @tsv' "$usage" 2>/dev/null)
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

# --- 4. human-feedback MEASUREMENT (no effort estimate) ----------------------
# Human-effort ESTIMATION (minutes/dollars/ratio) was retired 2026-11-05: the receipt
# records raw counts only. Human-author filter: drop the fleet bot, its fork-owner
# logins, Copilot, and any login ending [bot]. Maintainers are the journal
# maintainers/allowlist; every other human is "other". Plain code counts WORDS of each
# body (awk NF) — no LLM ever reads a comment body.
: > "$TMP/botlogins"
{ echo "${GARDEN_BOT_LOGIN:-kriscendobot}"; echo Copilot
  [ -d "$dir/config" ] && [ -f "$dir/config/fork-owners" ] && cat "$dir/config/fork-owners" 2>/dev/null
} | tr '[:upper:]' '[:lower:]' | tr -d '[:blank:]\r' | sed '/^$/d' | sort -u > "$TMP/botlogins" || true
{ [ -f "$dir/maintainers/allowlist" ] && sed 's/#.*//' "$dir/maintainers/allowlist"; } 2>/dev/null \
  | tr '[:upper:]' '[:lower:]' | tr -d '[:blank:]\r' | sed '/^$/d' | sort -u > "$TMP/maintainers" || true
is_bot_login() {  # is_bot_login <login>
  local l; l="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$l" in *'[bot]') return 0 ;; esac
  grep -qxF "$l" "$TMP/botlogins" 2>/dev/null && return 0
  return 1
}
# One TSV row per feedback item: stream login ts state is_thread_root words.
# stream = review | inline | issue. Bodies are reduced to a word count inside jq/awk
# and never leave this process.
gh_stream() {  # gh_stream <stream> <api-path> <ts-field>
  gh api --paginate "$2" 2>/dev/null \
    | jq -r --arg s "$1" --arg tf "$3" '
        ( if type=="array" then .[] else . end )
        | select(.user and .user.login)
        | [ $s, .user.login, (.[$tf] // "-"), (.state // "-"),
            (if .in_reply_to_id == null then 1 else 0 end),
            ((.body // "") | [scan("[^[:space:]]+")] | length) ] | @tsv' 2>/dev/null || true
}
{
  gh_stream review "repos/$repo/pulls/$pr/reviews"   submitted_at
  gh_stream inline "repos/$repo/pulls/$pr/comments"  created_at
  gh_stream issue  "repos/$repo/issues/$pr/comments" created_at
} > "$TMP/feedback.tsv"

words_maint=0; words_other=0; human_reviews=0; human_threads=0; human_comments=0
n_changes=0; n_approved=0; n_commented=0
: > "$TMP/authors.tsv"; : > "$TMP/verdicts.tsv"
while IFS=$'\t' read -r stream login ts rstate root words; do
  [ -n "$login" ] || continue
  is_bot_login "$login" && continue
  lc="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"
  cls=other; grep -qxF "$lc" "$TMP/maintainers" 2>/dev/null && cls=maintainer
  words="${words:-0}"; case "$words" in *[!0-9]*) words=0 ;; esac
  if [ "$cls" = maintainer ]; then words_maint=$((words_maint+words)); else words_other=$((words_other+words)); fi
  printf '%s\t%s\t%s\n' "$lc" "$cls" "$words" >> "$TMP/authors.tsv"
  case "$stream" in
    review)
      human_reviews=$((human_reviews+1))
      printf '%s\t%s\n' "$ts" "$rstate" >> "$TMP/verdicts.tsv"
      case "$rstate" in
        CHANGES_REQUESTED) n_changes=$((n_changes+1)) ;;
        APPROVED) n_approved=$((n_approved+1)) ;;
        COMMENTED) n_commented=$((n_commented+1)) ;;
      esac ;;
    inline) [ "$root" = 1 ] && human_threads=$((human_threads+1)); human_comments=$((human_comments+1)) ;;
    issue)  human_comments=$((human_comments+1)) ;;
  esac
done < "$TMP/feedback.tsv"
words_human=$((words_maint + words_other))
verdict_seq="$(sort "$TMP/verdicts.tsv" | awk -F'\t' '$2=="CHANGES_REQUESTED"||$2=="APPROVED"{printf "%s%s", (n++?">":""), $2}')"
verdict_seq="${verdict_seq:--}"
# per-author words: login<TAB>class<TAB>words, summed
awk -F'\t' '{w[$1]+=$3; c[$1]=$2} END{for (l in w) printf "%s\t%s\t%d\n", l, c[l], w[l]}' \
  "$TMP/authors.tsv" | sort > "$TMP/byauthor.tsv"

# --- 4b. time + job measurements ----------------------------------------------
# Job duration = Σ elapsed_s over every result row of every joined base. Wall-clock =
# earliest engagement start (ts − elapsed_s, the first claim of any job for this PR)
# to merge/close. Both are measurements, not estimates.
job_s=0; first_start=""
while IFS=$'\t' read -r base _r; do
  [ -f "$dir/usage/$base.jsonl" ] || continue
  jq -r 'select(.source=="result") | [ (.ts // ""), (.elapsed_s // 0) ] | @tsv' \
    "$dir/usage/$base.jsonl" 2>/dev/null
done < "$TMP/bases.tsv" > "$TMP/runs.tsv" || true
while IFS=$'\t' read -r ts el; do
  el="${el%%.*}"; case "$el" in ''|*[!0-9]*) el=0 ;; esac
  job_s=$((job_s + el))
  e="$(date -u -d "$ts" +%s 2>/dev/null)" || continue
  st=$((e - el)); if [ -z "$first_start" ] || [ "$st" -lt "$first_start" ]; then first_start="$st"; fi
done < "$TMP/runs.tsv"
first_claim_at="-"; wall_s="-"
if [ -n "$first_start" ]; then
  first_claim_at="$(date -u -d "@$first_start" +%FT%TZ)"
  ce="$(date -u -d "$completed_at" +%s 2>/dev/null || echo "")"
  [ -n "$ce" ] && wall_s=$((ce - first_start))
fi
dur() { case "$1" in ''|-|*[!0-9-]*) printf '—' ;; *) awk -v s="$1" 'BEGIN{ printf "%.1f h", s/3600 }' ;; esac; }

# fix rounds = joined bases whose role is fixer (or a fixer variant)
fix_rounds="$(awk -F'\t' '$2 ~ /^(fixer|americanizer|deslopper)$/{print $1}' "$TMP/eng.tsv" | sort -u | grep -c . || true)"
fix_rounds="${fix_rounds:-0}"
# tokens by model (tier names are not on the ledger rows; the model is the tier proxy)
tok_by_model_json="$(awk -F'\t' '{t[$4]+=$5} END{for (m in t) printf "%s\t%d\n", m, t[m]}' "$TMP/eng.tsv" \
  | jq -Rn '[inputs | split("\t") | {key: .[0], value: (.[1]|tonumber)}] | from_entries')"

# quality bar: ordered class table (rank 1 = highest bar). Journal config/quality-bar
# outranks the tracked seed scripts/jobs/quality-bar-defaults.tsv; unlisted => unknown.
qb_rank="-"; qb_class="unknown"
for qbf in "$dir/config/quality-bar" "$HERE/quality-bar-defaults.tsv"; do
  [ -f "$qbf" ] || continue
  qbl="$(awk -F'\t' -v r="$(printf '%s' "$repo" | tr '[:upper:]' '[:lower:]')" \
    '!/^#/ && tolower($1)==r {print $2"\t"$3; exit}' "$qbf")"
  if [ -n "$qbl" ]; then qb_rank="${qbl%%$'\t'*}"; qb_class="${qbl#*$'\t'}"; break; fi
done

# gauntlet context: panel runs + max rounds recorded for this PR, best-effort.
panel_rounds=0; panel_runs=0
for prd in "$dir/panel-runs/$slug-$pr" "$dir/panel-runs/$slug-pr$pr"; do
  [ -d "$prd" ] || continue
  for pmd in "$prd"/*.md; do
    [ -f "$pmd" ] || continue
    panel_runs=$((panel_runs+1))
    prr="$(sed -n 's/^rounds:[[:space:]]*//p' "$pmd" | head -1)"
    case "$prr" in ''|*[!0-9]*) : ;; *) panel_rounds=$((panel_rounds + prr)) ;; esac
  done
done

usd() { awk -v x="${1:-0}" 'BEGIN{ printf "%.2f", x+0 }'; }
# --- 4c. the machine-readable rollup row (receipts/rollup.jsonl) --------------
rollup_json="$(jq -cn \
  --arg repo "$repo" --argjson pr "$pr" --arg disposition "$disposition" \
  --arg completed_at "$completed_at" --arg first_claim_at "$first_claim_at" \
  --arg wall_s "$wall_s" --argjson job_s "$job_s" \
  --argjson jobs "$n_bases" --argjson engagements "$n_eng" \
  --argjson tokens "$pr_tok" --arg calib "$(usd "$pr_calib")" --arg notional "$(usd "$pr_notional")" --arg ceil "$(usd "$pr_ceil")" \
  --argjson tok_by_model "$tok_by_model_json" \
  --argjson wm "$words_maint" --argjson wo "$words_other" \
  --rawfile byauthor "$TMP/byauthor.tsv" \
  --argjson reviews "$human_reviews" --argjson threads "$human_threads" --argjson comments "$human_comments" \
  --argjson cr "$n_changes" --argjson ap "$n_approved" --argjson co "$n_commented" --arg seq "$verdict_seq" \
  --arg qb_class "$qb_class" --arg qb_rank "$qb_rank" \
  --argjson panel_runs "$panel_runs" --argjson panel_rounds "$panel_rounds" --argjson fix_rounds "$fix_rounds" \
  --arg generated_at "$(date -u +%FT%TZ)" --arg generated_by "${GARDEN:-unknown}" '
  def num: if . == "-" or . == "" then null else tonumber end;
  { schema: 1, repo: $repo, pr: $pr, disposition: $disposition,
    completed_at: $completed_at, first_claim_at: (if $first_claim_at=="-" then null else $first_claim_at end),
    wall_clock_s: ($wall_s|num), job_duration_s: $job_s, jobs: $jobs, engagements: $engagements,
    tokens_billable: $tokens, tokens_by_model: $tok_by_model,
    calibrated_usd: ($calib|tonumber), notional_usd: ($notional|tonumber), ceiling_usd: ($ceil|tonumber),
    human_words: ($wm + $wo), human_words_maintainer: $wm, human_words_other: $wo,
    human_words_by_author: ([ $byauthor | split("\n")[] | select(length>0) | split("\t")
                              | {key: .[0], value: {class: .[1], words: (.[2]|tonumber)}} ] | from_entries),
    human_reviews: $reviews, human_inline_threads: $threads, human_comments: $comments,
    verdicts: {changes_requested: $cr, approved: $ap, commented: $co}, verdict_sequence: $seq,
    quality_bar_class: $qb_class, quality_bar_rank: ($qb_rank|num),
    panel_runs: $panel_runs, panel_rounds: $panel_rounds, fix_rounds: $fix_rounds,
    generated_at: $generated_at, generated_by: $generated_by }')" \
  || die "could not build rollup row"

# --- 5. render the receipt ----------------------------------------------------
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
      awk -F'\t' -v want="$base" '$1==want{ printf "| `%s` | %s | %s | `%s` | %s | %.2f | — |\n", $1, $2, $3, $4, $5, $7+0 }' "$TMP/eng.tsv"
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
  printf '**Rollup (measurements, no human-cost estimate):**\n\n'
  printf -- '- Token cost: **$%s calibrated** (notional $%s); %s billable tokens.\n' "$(usd "$pr_calib")" "$(usd "$pr_notional")" "$pr_tok"
  printf -- '- Wall-clock (first claim %s → %s): %s. Job duration Σ: %s over %s job(s), %s engagement(s).\n' \
    "$first_claim_at" "$completed_at" "$(dur "$wall_s")" "$(dur "$job_s")" "$n_bases" "$n_eng"
  printf -- '- Human feedback: **%s word(s)** (maintainer %s, other %s); %s review(s), %s inline thread(s), %s comment(s).\n' \
    "$words_human" "$words_maint" "$words_other" "$human_reviews" "$human_threads" "$human_comments"
  printf -- '- Verdicts: %s CHANGES_REQUESTED, %s APPROVED (sequence `%s`).\n' "$n_changes" "$n_approved" "$verdict_seq"
  printf -- '- Quality bar: `%s` (rank %s). Gauntlet: %s panel run(s), %s panel round(s), %s fix round(s).\n' \
    "$qb_class" "$qb_rank" "$panel_runs" "$panel_rounds" "$fix_rounds"
  if [ "$disposition" = closed ]; then
    printf '\n**Closed-without-merge outcome: `%s`.**' "$closed_outcome"
    if [ "$closed_outcome" = unresolved ]; then
      printf ' No evidence-backed attribution has been recorded; do not treat this as either rolled-forward cost or productive learning.\n'
    else
      printf ' %s' "$outcome_note"
      [ -n "$successor" ] && printf ' Successor: `%s`.' "$successor"
      printf ' Evidence: %s\n' "$outcome_evidence"
    fi
  fi
  [ "$(awk -v c="$pr_ceil" 'BEGIN{print ((c+0)>0)?1:0}')" = 1 ] && \
    printf '\n<sub>Ceiling (unmeasured openai/unknown arms, a modelling bound not money): $%s.</sub>\n' "$(usd "$pr_ceil")"
  printf '\n'
  printf '<sub>Receipt generated deterministically from the journal usage + reputation '
  printf 'ledgers and word counts of the PR'"'"'s human review threads. '
  printf 'Archived at `%s`.</sub>\n' "$archive_rel"
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
    if [ -f "$dir/$archive_rel" ] && [ "$force" -eq 0 ]; then
      log "archive $archive_rel already present — leaving it"; return 0
    fi
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
      printf 'first_claim_at: %s\n' "$first_claim_at"
      printf 'wall_clock_s: %s\n' "$wall_s"
      printf 'job_duration_s: %s\n' "$job_s"
      printf 'human_words: %s\n' "$words_human"
      printf 'human_words_maintainer: %s\n' "$words_maint"
      printf 'human_words_other: %s\n' "$words_other"
      printf 'human_reviews: %s\n' "$human_reviews"
      printf 'human_inline_threads: %s\n' "$human_threads"
      printf 'verdicts_changes_requested: %s\n' "$n_changes"
      printf 'verdicts_approved: %s\n' "$n_approved"
      printf 'quality_bar_class: %s\n' "$qb_class"
      printf 'quality_bar_rank: %s\n' "$qb_rank"
      printf 'panel_runs: %s\n' "$panel_runs"
      printf 'panel_rounds: %s\n' "$panel_rounds"
      printf 'fix_rounds: %s\n' "$fix_rounds"
      printf 'rollup_schema: 1\n'
      if [ "$disposition" = closed ]; then
        printf 'closed_outcome: %s\n' "$closed_outcome"
        [ -z "$successor" ] || printf 'successor: %s\n' "$successor"
        [ -z "$outcome_evidence" ] || printf 'outcome_evidence: %s\n' "$outcome_evidence"
      fi
      printf 'generated_at: %s\n' "$(date -u +%FT%TZ)"
      printf 'generated_by: %s\n' "${GARDEN:-unknown}"
      printf -- '---\n\n'
      printf '%s\n' "$archive_body"
    } > "$dir/$archive_rel"
    printf '%s\n' "$rollup_json" >> "$dir/$ROLLUP_REL"
    git -C "$dir" add "$archive_rel" "$ROLLUP_REL"
    rc=0; commit_and_push "$dir" "receipt($slug#$pr): archive completion receipt" || rc=$?
    [ "$rc" -eq 0 ] && { log "archived $archive_rel"; return 0; }
    [ "$rc" -eq 2 ] && { log "archive $archive_rel already committed"; return 0; }
    log "archive push lost a race (attempt $attempt); re-syncing"; backoff "$attempt"
  done
  die "could not write archive $archive_rel after retries"
}
# --backfill-rollup: an ALREADY-archived receipt (possibly carrying the retired MRE
# section) keeps its markdown untouched; only its rollup row is appended, once.
backfill_rollup() {
  local attempt rc
  ensure_clone "$dir"
  for attempt in $(seq 1 50); do
    sync_clone "$dir"
    if [ -f "$dir/$ROLLUP_REL" ] && jq -e --arg r "$repo" --argjson p "$pr" \
         'select(.schema==1 and .repo==$r and .pr==$p)' "$dir/$ROLLUP_REL" >/dev/null 2>&1; then
      log "rollup row for $repo#$pr already present — leaving it"; return 0
    fi
    mkdir -p "$(dirname "$dir/$ROLLUP_REL")"
    printf '%s\n' "$rollup_json" >> "$dir/$ROLLUP_REL"
    git -C "$dir" add "$ROLLUP_REL"
    rc=0; commit_and_push "$dir" "receipt($slug#$pr): backfill rollup row" || rc=$?
    [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ] && return 0
    log "rollup push lost a race (attempt $attempt); re-syncing"; backoff "$attempt"
  done
  die "could not append rollup row for $repo#$pr after retries"
}
if [ "$backfill" -eq 1 ]; then
  backfill_rollup
  printf '%s\n' "$dir/$ROLLUP_REL"
  exit 0
fi
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
