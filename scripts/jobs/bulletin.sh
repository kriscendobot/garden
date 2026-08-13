#!/bin/bash
# bulletin.sh — the continuous bulletin loop: keep journal/README.md current as
# the job board advances, augmenting the deterministic dashboard with a
# journalist's `## Latest` narrative. The journal's landing page IS the bulletin;
# the journal's design/layout narrative lives at journal/DESIGN.md.
#
# Usage: bulletin.sh
#
# A long-running systemd service (garden-bulletin.service), NOT a oneshot+timer.
# It debounces naturally by being busy: while one iteration regenerates and runs
# the journalist (seconds), the board advances; the next iteration coalesces
# whatever accumulated. The loop IS the watcher; no separate watcher unit exists.
#
# Each iteration:
#   1. draining check; sync the bulletin journal clone.
#   2. PUSH-GATE: read the durable cursor (the origin/journal2 SHA last reconciled
#      from). If the synced head equals the cursor, NOTHING has been pushed to
#      journal2 since the last reconcile — skip the entire tick (no compute, no
#      post). A journal2 push is the sole trigger for a bulletin update; external
#      GitHub drift (the parked-PR queue) alone never rewrites the bulletin.
#   3. compute the board transitions since the cursor.
#   4. compute the deterministic dashboard (the parked-for-maintainer PR queue,
#      board counts, watch set, hosts, maintainer inbox) — the always-works base.
#   5. if the dashboard changed since what is posted: drive the journalist
#      (claude -p via GARDEN_BULLETIN_HANDLER) with the dashboard + the
#      since-cursor transitions to produce `## Latest`; assemble it as the LEAD
#      (`## Latest` sits at the top, right after the freshness line, ahead of the
#      deterministic sections); write, commit, push (CAS); then advance the cursor
#      durably ONLY after the push is accepted (a crash mid-cycle re-processes,
#      never skips).
#   6. if nothing changed: advance the cursor to the synced head (so a transition
#      another host already posted is not re-narrated), short sleep, loop.
#
# Push-gate vs cost-gate: two layers keep idle ticks free. The PUSH-GATE (step 2)
# short-circuits the whole tick when journal2 has not advanced since the last
# reconcile — so an unchanged board does no work at all, and external GitHub drift
# (the parked-PR review queue) cannot rewrite the bulletin on its own. The COST-GATE
# (step 5) then runs claude -p ONLY when the dashboard changed since what is posted;
# never on an idle poll. The change-compare excludes the volatile `_As of`
# freshness line, the `## Latest` narrative (wherever it sits — it now leads), and
# the volatile "(waiting <age>)" suffix on parked-PR rows, so neither an advancing
# timestamp, non-deterministic narrative prose, nor a ticking PR age churns a
# commit on its own. A journal2 push that moves the parked-PR set (e.g. a roadmap
# record landing) still re-renders it as part of that push's dashboard recompute.
#
# Parked-PR throttle: the "## Parked for maintainer feedback" section is sourced
# from GitHub (gh search prs --review-requested kriskowal, scoped to the
# GARDEN_BULLETIN_PARKED_OWNERS owners so the off-limits agoric-sdk flood stays
# out). The loop runs continuously, so the gh query is throttled to at most once per
# GARDEN_BULLETIN_PARKED_TTL seconds (default 300) via a host-local cache+stamp in
# GARDEN_STATE; between refreshes the cached render is reused. A failed query
# degrades to the last cached set (or "(unavailable)") and never wedges the loop.
#
# Parked-PR fuzzy ranking: the cached set can hold ~35 review-requested PRs, some
# idle for hundreds of days — noise. Each PR is scored by a weighted sum of RECENCY
# (exponential decay on idle age, half-life GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS)
# and ROADMAP RELEVANCE (how high in the roadmap the PR's design sits, from the
# journal plan tree via roadmap_index — deterministic, NO claude). The list is
# sorted by score descending and capped at GARDEN_BULLETIN_PARKED_TOPN (~10), with
# a "showing N of M" note. When no roadmap data maps any PR, scoring degrades to
# recency-only. Scores are integers so a sub-day clock tick never reorders PRs that
# differ by days of age (keeps the idempotent change-compare stable).
#
# Graceful degradation: if claude is absent or the journalist fails/times out, the
# deterministic dashboard still ships (preserving the prior `## Latest` if present)
# and the cursor still advances. A journalist failure never wedges the loop.
#
# Multi-host safety: several hosts may run this service. The CAS push plus the
# idempotent compare make that safe — whoever posts the current state first
# advances the shared bulletin; the others recompute the same dashboard, see
# "unchanged", and skip, so concurrent loops neither corrupt nor ping-pong.
#
# Testability: GARDEN_BULLETIN_ONCE=1 runs a single pass and exits (or set
# GARDEN_BULLETIN_MAX_ITERS to a small integer). GARDEN_BULLETIN_HANDLER is the
# pluggable journalist hook (default handlers/bulletin-claude.sh); tests stub it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="bulletin"

: "${GARDEN_BULLETIN_HANDLER:=$HERE/handlers/bulletin-claude.sh}"
: "${GARDEN_BULLETIN_IDLE_SLEEP:=5}"
: "${GARDEN_BULLETIN_ONCE:=0}"
: "${GARDEN_BULLETIN_MAX_ITERS:=0}"   # 0 = unbounded
: "${GARDEN_BULLETIN_TADA_DAYS:=7}"   # date shards considered recent
: "${GARDEN_BULLETIN_PARKED_TTL:=300}"   # seconds between parked-PR gh refreshes
# Owners to scope the parked-PR query to (space-separated). Restricting by owner
# keeps the "parked for kriskowal" board to the garden's domain and EXCLUDES the
# off-limits Agoric/agoric-sdk flood of stale dependabot review-requests, which
# would otherwise drown the high-value human queue. Default: the endojs org and
# kriskowal's own repos (covers the watched endo-but-for-bots + garden).
: "${GARDEN_BULLETIN_PARKED_OWNERS:=endojs kriskowal}"
# Test/override hook: a command emitting parked-PR rows as TSV
# (repo<TAB>number<TAB>url<TAB>updatedAt<TAB>title), one per open non-draft PR
# awaiting kriskowal's review. Empty stdout + success = no parked PRs; non-zero
# exit = query failure (degrade to cache). Empty default = use the real gh query.
: "${GARDEN_BULLETIN_PARKED_CMD:=}"
# Fuzzy-ranking knobs for the parked-PR queue. The queue can hold ~35 review-
# requested PRs, some idle for hundreds of days — noise. We score each by a
# weighted sum of (1) RECENCY (exponential decay on idle age) and (2) ROADMAP
# RELEVANCE (how high in the roadmap the PR's design sits), then show only the
# top N with a "showing N of M" note. Both factors are heavily weighted so a
# stale-but-on-critical-path PR and a fresh-but-peripheral PR both surface, while
# ancient peripheral PRs drop off. Scores are integers (0..100 per factor) so a
# sub-day tick of the clock cannot reorder PRs that differ by days of idle age.
: "${GARDEN_BULLETIN_PARKED_TOPN:=10}"               # cap the rendered queue at N
: "${GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS:=14}"      # recency half-life in days
: "${GARDEN_BULLETIN_PARKED_WEIGHT_RECENCY:=50}"     # weight on the recency factor
: "${GARDEN_BULLETIN_PARKED_WEIGHT_ROADMAP:=50}"     # weight on the roadmap factor
# Roadmap-relevance source (deterministic; NO claude). Override hook for tests and
# for a future deterministic mapping: a command emitting one TSV line per known
# PR→roadmap mapping as repo<TAB>number<TAB>relevance, where relevance is 0..100
# (higher = higher in the roadmap). Empty default = derive from the journal plan
# tree (journal/plan/designs/**/*.md frontmatter, the source of truth being built
# by implement-plan-in-journal). When NO mapping is available for any PR, scoring
# degrades to recency-only — never wedges.
: "${GARDEN_BULLETIN_PARKED_ROADMAP_CMD:=}"

# Base URL for the journal2 blob links that make every bulletin bullet a
# follow-up link the maintainer can click through to the source (a job file, a
# host record, a message). Overridable for a fork; defaults to this repo's
# journal2 branch.
: "${GARDEN_BLOB_BASE:=https://github.com/$GARDEN_PRODUCTION_JOURNAL_REPO/blob/$JOURNAL_BRANCH}"

# Where the garden's bare fork clones live (worktrees/<owner>-<repo>.git). Used to
# resolve a maintainer message's originating project repo so a bare `#N` in the
# body links to that project, not the garden. Overridable for tests; defaults to
# the garden root's worktrees/ (this script sits at scripts/jobs/).
: "${GARDEN_WORKTREES:=$HERE/../../worktrees}"

DIR="${GARDEN_BULLETIN_CLONE:-$GARDEN_STATE/bulletin/journal}"
ensure_clone "$DIR"

# The durable cursor: the origin/journal2 commit SHA the bulletin was last
# reconciled from. Host-local on purpose (it is THIS loop's resume point), kept
# outside any reset-prone worktree. Written only after a post is accepted (or a
# reconcile that found nothing to post), so a crash re-processes rather than skips.
CURSOR="$GARDEN_STATE/bulletin/cursor"
mkdir -p "$(dirname "$CURSOR")"

read_cursor()  { [ -f "$CURSOR" ] && head -1 "$CURSOR" 2>/dev/null; return 0; }
write_cursor() { printf '%s\n' "$1" > "$CURSOR"; }

# --- plan reconciler (folded into the bulletin loop) -------------------------
#
# The plan lives in journal2 under plan/ (per designs/plan-in-journal.md, garden#4):
# per-design records are the source of truth; plan/README.md is a GENERATED
# aggregation of them. Re-rendering rides on this loop the same way the dashboard
# does: render.sh is deterministic (no clock, no network), so the regenerated view
# is byte-identical across hosts and only differs from what is committed when a
# record actually changed. We stage+commit it on its own (cheap, no journalist) so
# a plan-only change is reconciled even on a tick where the dashboard is unchanged.
# The full status/pr drift reconcile (gh merge detection, the automatic Complete
# flip) runs on the weekly Sunday recalibration job; folding it continuously into
# this loop is a tracked follow-on, pending a weekly pass proving the auto-flip on
# the freshly imported data.
PLAN_RENDER="${GARDEN_PLAN_RENDER:-$HERE/plan/render.sh}"
render_plan() {
  [ -d "$DIR/plan/designs" ] || return 0
  [ -x "$PLAN_RENDER" ] || return 0
  local out; out="$("$PLAN_RENDER" "$DIR/plan" 2>/dev/null)" || return 0
  [ -n "$out" ] || return 0
  printf '%s\n' "$out" > "$DIR/plan/README.md"
  git -C "$DIR" add plan/README.md 2>/dev/null || true
  if ! git -C "$DIR" diff --cached --quiet -- plan/README.md 2>/dev/null; then
    commit_and_push "$DIR" "plan: re-render roadmap view from records" || true
  fi
}

# Extract a one-line description from a job file: its first Markdown heading
# (`# …`) if present, else its first non-empty line. Strip leading `#`/whitespace,
# collapse internal whitespace, drop characters that could break the bulletin's
# Markdown (backticks and control chars; grep -m1 already guarantees no embedded
# newline), and truncate to ~80 chars. Cheap: reads only until the first match.
job_desc() {
  local f="$1" line
  line=$(grep -m1 -E '^#+[[:space:]]' "$f" 2>/dev/null || true)
  [ -n "$line" ] || line=$(grep -m1 -E '[^[:space:]]' "$f" 2>/dev/null || true)
  line=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*#+[[:space:]]*//; s/^[[:space:]]+//')
  line=$(printf '%s' "$line" | tr -d '`\r' | tr '\t' ' ' | tr -s ' ')
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [ -n "$line" ] || line="(no description)"
  if [ "${#line}" -gt 80 ]; then line="${line:0:77}..."; fi
  printf '%s' "$line"
}

# Render the active job board: list every todo and doin job with a one-line
# description (grouped under counted sub-headings), then a bounded tada section
# (count + the few most-recently-modified completions), so a large tada set never
# bloats the bulletin. Print to stdout.
render_board() {
  local todo_n doin_n tada_n j desc label
  todo_n=$(list_jobs "$DIR" jobs/todo | grep -c . || true)
  doin_n=$(list_jobs "$DIR" jobs/doin | grep -c . || true)
  tada_n=$(list_jobs "$DIR" jobs/tada | grep -c . || true)

  printf '### todo (%s)\n' "$todo_n"
  if [ "$todo_n" -gt 0 ]; then
    while IFS= read -r j; do
      [ -n "$j" ] || continue
      desc=$(job_desc "$DIR/jobs/todo/$j")
      printf -- '- [`%s`](%s/jobs/todo/%s) — %s\n' "${j%.md}" "$GARDEN_BLOB_BASE" "$j" "$desc"
    done < <(list_jobs "$DIR" jobs/todo)
  else
    printf '(none)\n'
  fi

  printf '\n### doin (%s)\n' "$doin_n"
  if [ "$doin_n" -gt 0 ]; then
    while IFS= read -r j; do
      [ -n "$j" ] || continue
      desc=$(job_desc "$DIR/jobs/doin/$j")
      printf -- '- [`%s`](%s/jobs/doin/%s) — %s\n' "${j%.md}" "$GARDEN_BLOB_BASE" "$j" "$desc"
    done < <(list_jobs "$DIR" jobs/doin)
  else
    printf '(none)\n'
  fi

  # tada can hold hundreds of completed jobs; never list them all. Show the count
  # and at most the 5 most-recently-modified, with descriptions.
  printf '\n### tada (%s)\n' "$tada_n"
  if [ "$tada_n" -gt 0 ]; then
    while IFS= read -r j; do
      [ -n "$j" ] || continue
      desc=$(job_desc "$DIR/$j")
      label="$(basename "$j" .md)"
      printf -- '- [`%s`](%s/%s) — %s\n' "$label" "$GARDEN_BLOB_BASE" "$j" "$desc"
    done < <(
      # `sort | head -5`: head closes the pipe after 5 lines, so on a large tada
      # `sort` can be SIGPIPE-killed mid-write (a benign "sort: write error" /
      # "fflush failed: Broken pipe"). Keep that off the fatal path — silence
      # sort's stderr and ABSORB its status with `|| true` so the limited
      # pipeline never trips `pipefail`/`set -e`. A broken pipe from a head/limit
      # is normal, not a failure. (Root cause of the 2026-06-25 ~2h dark window:
      # a sort broken-pipe took down the loop, then rapid restarts hit the
      # systemd start-limit and the dashboard stayed dark.)
      { tada_recent "$DIR" "$GARDEN_BULLETIN_TADA_DAYS" || true; } | head -5
    )
    if [ "$tada_n" -gt 5 ]; then printf -- '- … and %s more\n' "$((tada_n - 5))"; fi
  else
    printf '(none)\n'
  fi
}

# Render the PLAN queue: parked jobs that gardeners never claim. Three groups:
#   - awaiting go-ahead: gate=go-ahead jobs needing maintainer AUTHORIZATION
#     before any work runs (so the maintainer sees what to act on);
#   - deferred (top by priority): gate=deferred jobs the foreman may auto-promote
#     when the board is idle, shown highest-priority first;
#   - blocked (awaiting <artifact>): gate=blocked jobs parked behind a PR or
#     another job, auto-promoted ONLY by the unblock watcher when the blocker
#     completes — so the maintainer sees what is parked-blocked and on what.
# Each row carries its gate reason + priority (and, for blocked, its blocker).
# Print to stdout. (Named *_queue to avoid colliding with render_plan, the
# roadmap-view re-renderer above, which writes plan/README.md from the per-design
# records.)
render_plan_queue() {
  local j f desc prio art goahead deferred blocked
  goahead=""
  while IFS= read -r j; do
    [ -n "$j" ] || continue
    f="$DIR/jobs/plan/$j"; [ -f "$f" ] || continue
    [ "$(plan_gate "$f")" = "go-ahead" ] || continue
    desc=$(job_desc "$f"); prio=$(plan_priority "$f")
    goahead+="$(printf -- '- [`%s`](%s/jobs/plan/%s) — _%s_ · %s' "${j%.md}" "$GARDEN_BLOB_BASE" "$j" "$prio" "$desc")"$'\n'
  done < <(list_jobs "$DIR" jobs/plan)

  # deferred, ranked highest-priority-first by the shared selector
  deferred=""
  while IFS= read -r j; do
    [ -n "$j" ] || continue
    f="$DIR/jobs/plan/$j.md"; [ -f "$f" ] || continue
    desc=$(job_desc "$f"); prio=$(plan_priority "$f")
    deferred+="$(printf -- '- [`%s`](%s/jobs/plan/%s.md) — _%s_ · %s' "$j" "$GARDEN_BLOB_BASE" "$j" "$prio" "$desc")"$'\n'
  done < <(plan_deferred_ranked "$DIR")

  # blocked, each row naming the blocker artifact it is awaiting
  blocked=""
  while IFS= read -r j; do
    [ -n "$j" ] || continue
    f="$DIR/jobs/plan/$j"; [ -f "$f" ] || continue
    [ "$(plan_gate "$f")" = "blocked" ] || continue
    desc=$(job_desc "$f"); art=$(plan_blocked_on "$f")
    blocked+="$(printf -- '- [`%s`](%s/jobs/plan/%s) — awaiting `%s` · %s' "${j%.md}" "$GARDEN_BLOB_BASE" "$j" "${art:-?}" "$desc")"$'\n'
  done < <(list_jobs "$DIR" jobs/plan)

  printf '### awaiting go-ahead (maintainer authorization)\n'
  if [ -n "$goahead" ]; then printf '%s' "$goahead"; else printf '(none)\n'; fi
  printf '\n### deferred (top by priority; foreman auto-promotes when idle)\n'
  if [ -n "$deferred" ]; then printf '%s' "$deferred"; else printf '(none)\n'; fi
  printf '\n### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)\n'
  if [ -n "$blocked" ]; then printf '%s' "$blocked"; else printf '(none)\n'; fi
}

# Resolve the project repo a maintainer message came from, as "owner/repo", from
# the originating doer's base (the reply_to / from job base). A gardener's job base
# is "<owner>-<repo>-<slug>" and each fork has a bare clone worktrees/<owner>-<repo>.git,
# so we match the base against the known bare clones (longest wins) and split the
# clone name at its first "-" into owner/repo. Prints nothing when the base matches
# no known clone — the caller then leaves a bare `#N` as plain text rather than
# mislink it. A wrong link is worse than none.
resolve_doer_repo() {
  local base="$1" d name best=""
  base="${base#gardener:}"
  [ -n "$base" ] && [ -d "$GARDEN_WORKTREES" ] || return 0
  for d in "$GARDEN_WORKTREES"/*.git; do
    [ -d "$d" ] || continue
    name="$(basename "$d" .git)"
    if [ "$base" = "$name" ] || [ "${base#"$name"-}" != "$base" ]; then
      [ "${#name}" -gt "${#best}" ] && best="$name"
    fi
  done
  [ -n "$best" ] || return 0
  printf '%s/%s\n' "${best%%-*}" "${best#*-}"
}

# Render a maintainer message body as a Markdown blockquote so the bulletin is
# self-contained and followable: everything after the frontmatter delimiter, each
# line prefixed with "> " (blank lines become a bare ">"), with leading/trailing
# blank lines trimmed. Prefixing every body line keeps any fenced code block
# balanced inside the quote, so a Markdown- or fence-containing body cannot break
# the surrounding bulletin. An empty body renders as "> (empty message)".
#
# Issue/PR references in the body are turned into working Markdown links (both the
# GitHub-rendered journal2 README and the gh-pages client render [label](url)):
# full GitHub issue/PR URLs, "owner/repo#N", and — when the originating repo is
# passed as $2 — a bare "#N" pointing at that project. Linking is skipped inside
# fenced code blocks AND inline `code` spans, and formed links are held aside so
# nothing is double-linked. With no resolved repo ($2 empty), a bare "#N" is left
# as plain text.
msg_body_quote() {
  awk -v repo="${2:-}" '
    function linkify(s,   i) {
      # Protect already-formed links and each reference kind behind SOH/STX
      # sentinels so a later pass cannot re-link inside an earlier one.
      split("", store); nstore=0
      # 0) hold inline `code` spans verbatim so a `#N` / `owner/repo#N` inside a
      #    code span is never linkified (a link inside backticks renders literally)
      s = protect(s, "`[^`]*`", "code")
      # 1) full GitHub issue/PR URLs -> [url](url)
      s = protect(s, "https?://github\\.com/[A-Za-z0-9._-]+/[A-Za-z0-9._-]+/(issues|pull)/[0-9]+", "url")
      # 2) owner/repo#N -> [owner/repo#N](https://github.com/owner/repo/issues/N)
      s = protect(s, "[A-Za-z0-9][A-Za-z0-9._-]*/[A-Za-z0-9._-]+#[0-9]+", "slug")
      # 3) bare #N -> project link, only when the originating repo is known
      if (repo != "") s = protect(s, "#[0-9]+", "bare")
      # restore
      while (match(s, /\001[0-9]+\002/)) {
        i = substr(s, RSTART+1, RLENGTH-2) + 0
        s = substr(s, 1, RSTART-1) store[i] substr(s, RSTART+RLENGTH)
      }
      return s
    }
    function protect(s, re, kind,   out, matched, link, hp) {
      out = ""
      while (match(s, re)) {
        matched = substr(s, RSTART, RLENGTH)
        if (kind == "code") {
          link = matched
        } else if (kind == "url") {
          link = "[" matched "](" matched ")"
        } else if (kind == "slug") {
          hp = index(matched, "#")
          link = "[" matched "](https://github.com/" substr(matched, 1, hp-1) "/issues/" substr(matched, hp+1) ")"
        } else {
          link = "[" matched "](https://github.com/" repo "/issues/" substr(matched, 2) ")"
        }
        store[nstore] = link
        out = out substr(s, 1, RSTART-1) "\001" nstore "\002"
        nstore++
        s = substr(s, RSTART+RLENGTH)
      }
      return out s
    }
    b { body[++n] = $0 }
    /^---$/ { b=1 }
    END {
      s=1; while (s<=n && body[s] ~ /^[[:space:]]*$/) s++
      e=n; while (e>=s && body[e] ~ /^[[:space:]]*$/) e--
      if (s>e) { print "> (empty message)"; exit }
      fence=0
      for (i=s; i<=e; i++) {
        if (body[i] ~ /^[[:space:]]*```/) { fence = !fence; print "> " body[i]; continue }
        if (body[i] ~ /^[[:space:]]*$/) print ">"
        else if (fence) print "> " body[i]
        else print "> " linkify(body[i])
      }
    }
  ' "$1"
}

# Humanize an age, in seconds, into a compact "Nd"/"Nh"/"Nm"/"Ns" token. Used to
# render how long a parked PR has been waiting.
humanize_age() {
  local iso="$1" epoch now diff
  epoch=$(date -d "$iso" +%s 2>/dev/null) || { printf 'unknown'; return 0; }
  now=$(date +%s)
  diff=$(( now - epoch )); [ "$diff" -lt 0 ] && diff=0
  if   [ "$diff" -ge 86400 ]; then printf '%dd' "$(( diff / 86400 ))"
  elif [ "$diff" -ge 3600 ];  then printf '%dh' "$(( diff / 3600 ))"
  elif [ "$diff" -ge 60 ];    then printf '%dm' "$(( diff / 60 ))"
  else                              printf '%ds' "$diff"; fi
}

# Emit parked-PR rows as TSV: repo<TAB>number<TAB>url<TAB>updatedAt<TAB>title, one
# per OPEN, NON-DRAFT pull request on which kriskowal is a requested reviewer (the
# "parked for the maintainer" queue — trusted GitHub state, safe to poll by
# construction per skills/review-queue-poll). The override hook lets tests stub the
# query without emulating gh's --jq. Empty stdout + success = no parked PRs; a
# non-zero exit signals a query failure the caller degrades around. Uses gh's
# built-in --jq (never external jq) per the recent require_tools hardening.
fetch_parked_rows() {
  if [ -n "$GARDEN_BULLETIN_PARKED_CMD" ]; then
    $GARDEN_BULLETIN_PARKED_CMD
    return $?
  fi
  command -v gh >/dev/null 2>&1 || return 1
  local owner_args=() o
  for o in $GARDEN_BULLETIN_PARKED_OWNERS; do owner_args+=(--owner "$o"); done
  gh search prs --review-requested kriskowal --state open --draft=false \
     ${owner_args[@]+"${owner_args[@]}"} \
     --limit 100 --json number,repository,title,url,updatedAt \
     --jq '.[] | [.repository.nameWithOwner, (.number|tostring), .url, .updatedAt, .title] | @tsv'
}

# Emit the roadmap-relevance index as TSV lines: repo<TAB>number<TAB>relevance,
# where relevance is an integer 0..100 (higher = higher in the roadmap). This is
# the deterministic roadmap source for the parked-PR fuzzy score; it uses NO
# claude. Resolution order:
#   1. GARDEN_BULLETIN_PARKED_ROADMAP_CMD override (tests + future plug-in).
#   2. The journal plan tree at $DIR/plan/designs/**/*.md — the source of truth
#      being built by implement-plan-in-journal. Each per-design file carries
#      frontmatter; we read a `pr:` field (a PR number, an owner/repo#N, or a
#      .../pull/N URL) and a relevance signal, preferring an explicit numeric
#      `roadmap_relevance:` (0..100), else a `priority:` integer (1 = highest,
#      mapped to a relevance band), else a neutral 50 for a known-but-unranked
#      design. The `repository` for a bare `pr:` number is taken from a sibling
#      `repository:`/`repo:` frontmatter field when present.
# When neither source yields a mapping the function emits nothing, and the caller
# degrades to recency-only. Forgiving by construction: an unparseable file is
# skipped, never fatal.
roadmap_index() {
  if [ -n "$GARDEN_BULLETIN_PARKED_ROADMAP_CMD" ]; then
    $GARDEN_BULLETIN_PARKED_ROADMAP_CMD
    return 0
  fi
  local plan="$DIR/plan/designs" f
  [ -d "$plan" ] || return 0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    awk '
      # frontmatter only: the block between the first two "---" lines
      NR==1 && $0!="---" { exit }
      $0=="---" { d++; if (d>=2) exit; next }
      d==1 {
        line=$0
        if (match(line, /^[[:space:]]*pr[[:space:]]*:[[:space:]]*/))  { pr=substr(line, RLENGTH+1) }
        else if (match(line, /^[[:space:]]*(repository|repo)[[:space:]]*:[[:space:]]*/)) { repo=substr(line, RLENGTH+1) }
        else if (match(line, /^[[:space:]]*roadmap_relevance[[:space:]]*:[[:space:]]*/))  { rel=substr(line, RLENGTH+1) }
        else if (match(line, /^[[:space:]]*priority[[:space:]]*:[[:space:]]*/))           { prio=substr(line, RLENGTH+1) }
        else if (match(line, /^[[:space:]]*milestone[[:space:]]*:[[:space:]]*/))          { ms=substr(line, RLENGTH+1) }
      }
      END {
        gsub(/[[:space:]"\x27]/, "", pr); gsub(/[[:space:]"\x27]/, "", repo)
        gsub(/[^0-9]/, "", rel); gsub(/[^0-9]/, "", prio); gsub(/[^0-9]/, "", ms)
        if (pr=="") exit
        # Normalize pr into repo + number. Forms: 123 | owner/name#123 |
        # https://github.com/owner/name/pull/123 | owner/name/pull/123
        num=""; r=repo
        if (pr ~ /^[0-9]+$/) { num=pr }
        else if (match(pr, /pull\/[0-9]+/))   { num=substr(pr, RSTART+5); if (match(pr,/github\.com\/[^/]+\/[^/]+/)) { seg=substr(pr,RSTART+11); split(seg,a,"/"); r=a[1]"/"a[2] } }
        else if (match(pr, /#[0-9]+$/))       { num=substr(pr, RSTART+1); r=substr(pr,1,RSTART-1) }
        if (num=="") exit
        if (rel!="")       { v=rel+0 }
        else if (prio!="") { v=100-((prio+0-1)*15); }   # 1->100,2->85,...
        else if (ms!="")   { v=110-((ms+0)*10); }       # milestone M1->100, M2->90, ... earlier=higher
        else               { v=50 }
        if (v<0) v=0; if (v>100) v=100
        if (r=="") r="?"
        printf "%s\t%s\t%d\n", r, num, v
      }
    ' "$f"
  done < <(find "$plan" -type f -name '*.md' 2>/dev/null | LC_ALL=C sort)
}

# Render the parked-PR section body (markdown lines) from the TSV rows. Each PR is
# scored by a fuzzy combination of RECENCY (exponential decay on idle age) and
# ROADMAP RELEVANCE (roadmap_index lookup); the list is sorted by score descending
# and capped at GARDEN_BULLETIN_PARKED_TOPN, with a "showing N of M" note when the
# queue is longer. When the roadmap index is empty the score is recency-only (the
# graceful-degradation path). All math runs in a single awk pass (bash has no
# floats); scores are integers so a sub-day clock tick cannot reorder day-apart
# PRs. Echoes a "(no open PRs…)" placeholder when the queue is empty.
render_parked() {
  local rows="$1" topn="$GARDEN_BULLETIN_PARKED_TOPN"
  local wr="$GARDEN_BULLETIN_PARKED_WEIGHT_RECENCY" wm="$GARDEN_BULLETIN_PARKED_WEIGHT_ROADMAP"
  local hl="$GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS" now idx
  if [ -z "${rows//[$' \t\n']/}" ]; then
    printf '(no open PRs awaiting kriskowal review)\n'; return 0
  fi
  now=$(date +%s)
  idx="$(roadmap_index 2>/dev/null || true)"
  # awk: load the roadmap index, then score each tab-separated PR row from stdin.
  # Emit "score<TAB>repo<TAB>num<TAB>url<TAB>updated<TAB>title". -F'\t' is required
  # so a title's internal spaces are not split into separate fields.
  printf '%s\n' "$rows" \
  | awk -F'\t' -v now="$now" -v hl="$hl" -v wr="$wr" -v wm="$wm" \
        -v idxdata="$idx" '
    function epoch(iso,   c) { c="date -d \"" iso "\" +%s 2>/dev/null"; c | getline e; close(c); return e+0 }
    BEGIN {
      have_roadmap=0
      n=split(idxdata, lines, "\n")
      for (i=1;i<=n;i++) {
        if (lines[i]=="") continue
        split(lines[i], p, "\t")
        if (p[1]!="" && p[2]!="") { rel[p[1]"#"p[2]]=p[3]+0; have_roadmap=1 }
      }
      hls=hl*86400; if (hls<=0) hls=86400
    }
    {
      repo=$1; num=$2; url=$3; updated=$4
      title=$5; for (i=6;i<=NF;i++) title=title"\t"$i
      if (repo=="") next
      e=epoch(updated); age=now-e; if (age<0) age=0
      # exponential decay to half-life: 100 * 2^(-age/halflife)
      rec=100*exp(-0.6931471805599453*age/hls)
      reci=int(rec+0.5)
      if (have_roadmap) {
        rv=(rel[repo"#"num]!="" ? rel[repo"#"num] : 0)
        score=int((wr*reci + wm*rv)/(wr+wm) + 0.5)
      } else {
        score=reci   # recency-only fallback
      }
      printf "%d\t%s\t%s\t%s\t%s\t%s\n", score, repo, num, url, updated, title
    }
  ' \
  | LC_ALL=C sort -t$'\t' -k1,1nr -k2,2 -k3,3n \
  | cut -f2- \
  | {
      local total=0 shown=0 out="" repo num url updated title age
      while IFS=$'\t' read -r repo num url updated title; do
        [ -n "$repo" ] || continue
        total=$((total+1))
        if [ "$shown" -lt "$topn" ]; then
          age="$(humanize_age "$updated")"
          out+="- [${repo}#${num}](${url}) — ${title} (waiting ${age})"$'\n'
          shown=$((shown+1))
        fi
      done
      printf '%s' "$out"
      if [ "$total" -gt "$shown" ]; then
        printf '\n_Showing top %s of %s parked PRs (ranked by recency + roadmap relevance)._\n' "$shown" "$total"
      fi
    }
}

# The parked-PR section body, throttled: refresh from GitHub at most once per
# GARDEN_BULLETIN_PARKED_TTL seconds, reusing a host-local cache between refreshes
# so the continuous loop never hits the API per-tick. A failed refresh degrades to
# the last cached render (or "(unavailable)") and marks the attempt so failures are
# throttled too. State lives under GARDEN_STATE (never a reset-prone worktree).
parked_section() {
  local data="$GARDEN_STATE/bulletin/parked.md"
  local stamp="$GARDEN_STATE/bulletin/parked.stamp"
  local ttl="$GARDEN_BULLETIN_PARKED_TTL" now last age rows
  mkdir -p "$(dirname "$data")"
  now=$(date +%s)
  last=$(cat "$stamp" 2>/dev/null || echo 0)
  case "$last" in (*[!0-9]*|'') last=0 ;; esac
  age=$(( now - last ))
  if [ ! -f "$data" ] || [ "$age" -ge "$ttl" ]; then
    if rows="$(fetch_parked_rows 2>/dev/null)"; then
      render_parked "$rows" > "$data"
    fi
    printf '%s' "$now" > "$stamp"   # throttle attempts whether or not the query won
  fi
  if [ -f "$data" ]; then cat "$data"; else printf '(unavailable)\n'; fi
}

# Compute the deterministic dashboard for the current synced state of $DIR and
# print it to stdout. This is the always-works base; it reuses the v1 board logic.
compute_dashboard() {
  local watch hosts_block h g maint m mf rt frm repo link now board parked plan spend
  board=$(render_board)
  plan=$(render_plan_queue)
  parked=$(parked_section)
  # Per-provider spend & quota (deterministic; NO claude/codex in the render path;
  # each cell degrades to "unavailable"/"no quota set"/"n/a" — never a fake number).
  spend=$(render_quota_panel 2>/dev/null || printf '(spend panel unavailable)\n')
  watch=$(list_jobs "$DIR" repos | paste -sd' ' - 2>/dev/null); [ -n "$watch" ] || watch="(none)"

  hosts_block=""
  for h in $(list_jobs "$DIR" hosts); do
    g=$(sed -n 's/^gardeners:[[:space:]]*//p' "$DIR/hosts/$h" | head -1)
    hosts_block+="- [$h]($GARDEN_BLOB_BASE/hosts/$h): ${g:-?} gardeners"$'\n'
  done
  [ -n "$hosts_block" ] || hosts_block="(no hosts configured)"$'\n'

  # Aggregate the maintainer inbox: every unread message addressed to the user,
  # rendered to be *followable* rather than a teaser. Each entry keeps its header
  # line (id, sender, originating doer via reply_to) plus a link to the message
  # blob on the journal2 branch, then the full body inline as a Markdown
  # blockquote so the maintainer can act without leaving the bulletin.
  maint=""
  for m in $(list_jobs "$DIR" inbox/maintainer/unread); do
    mf="$DIR/inbox/maintainer/unread/$m"
    [ -f "$mf" ] || continue
    rt=$(sed -n 's/^reply_to:[[:space:]]*//p' "$mf" | head -1)
    frm=$(sed -n 's/^from:[[:space:]]*//p' "$mf" | head -1)
    link="$GARDEN_BLOB_BASE/inbox/maintainer/unread/$m"
    # Resolve the originating project repo so a bare `#N` in the body links to
    # that project (not the garden). Prefer reply_to (the clean job base); fall
    # back to the from field. Empty when unresolvable → bare `#N` stays plain.
    repo=$(resolve_doer_repo "${rt:-$frm}")
    maint+="- \`${m%.md}\` — from ${frm:-?}, reply_to \`${rt:-?}\` · [open message]($link)"$'\n\n'
    maint+="$(msg_body_quote "$mf" "$repo")"$'\n\n'
  done
  [ -n "$maint" ] || maint="(no pending maintainer messages)"$'\n'

  # Freshness stamp. The bulletin now updates continuously as the board advances
  # (garden-bulletin.service), rewritten only when the dashboard changes, so this
  # marks the last change, not the last check. It is excluded from the change
  # comparison below, so an advancing timestamp never causes a commit on its own.
  now=$(date -u +%FT%TZ)

  # What the bulletin IS (kept here as a comment, NOT rendered on the dashboard —
  # per maintainer 2026-06-27 these explanatory notes are script context, not
  # bulletin content): the maintainer dashboard — what needs a human first, then
  # the state of ongoing autonomous work. It is regenerated deterministically by
  # this script (scripts/jobs/bulletin.sh) and updated continuously as the job
  # board advances (garden-bulletin.service), rewritten only when the dashboard
  # changes — so the `_As of` line below marks the last CHANGE, not the last check.
  # The journalist's `## Latest` narrative leads, injected ahead of the first
  # deterministic section. The journal's README.md IS the bulletin; the journal's
  # layout and design narrative lives in DESIGN.md. The rendered freshness line is
  # now just the bare `_As of <ts>` marker; stable() still excludes it from the
  # change-compare so an advancing timestamp never churns a commit on its own.
  cat <<EOF
# Garden bulletin

_As of ${now}_

## Parked for maintainer feedback

${parked}
## Messages to the maintainer

${maint}
## Spend & quota
${spend}

## Board
${board}

## Plan queue (parked — not claimable until promoted)
${plan}

## Watch set
$watch

## Hosts
${hosts_block}
EOF
}

# The deterministic part of a full bulletin: everything EXCEPT the `## Latest`
# section (which now LEADS, sitting between the intro and the first deterministic
# section). Drops the `## Latest` heading and its body up to the next `## ` heading,
# so a freshly computed (Latest-free) dashboard and a posted bulletin compare on the
# same deterministic content regardless of where Latest sits.
dashboard_part() {
  awk '
    /^## Latest$/      { skip=1; next }
    skip && /^## /     { skip=0 }
    !skip              { print }
  ' <<<"$1"
}
# The `## Latest` section (heading + body up to the next `## ` heading) of $1, empty
# if absent. Used to preserve the prior narrative when the journalist degrades.
latest_part() {
  awk '
    /^## Latest$/                   { f=1; print; next }
    f && /^## / && !/^## Latest$/    { f=0 }
    f                               { print }
  ' <<<"$1"
}
# Strip the volatile lines so the compare is stable: the `_As of` freshness line,
# the ticking "(waiting <age>)" suffix on parked-PR rows (the PR set still differs
# when a PR enters/leaves the queue, so real motion is not masked), and the
# constantly-ticking Spend & quota panel rows + its window note. The spend numbers
# accrue on every local `claude`/`codex` turn, not on a journal2 push, so leaving
# them in the compare would post (and re-run the journalist) on every tick; instead
# the panel is always RENDERED fresh into a post that some real board change
# triggers, but its numbers never force a commit on their own (matching the
# token-cost-ledger cost-chip's "rides journal2 pushes" intent).
stable() {
  grep -vE '^_As of |^_Trailing [0-9]+d window|^\| (Claude|Codex) \|' <<<"$1" \
    | sed -E 's/ \(waiting [^)]*\)$//' || true
}

# Build the journalist's digest (dashboard + since-cursor transitions) into a temp
# file and echo its path. Caller removes it.
build_digest() {
  local dashboard="$1" since="$2" head="$3" d transitions
  d="$(mktemp "${TMPDIR:-/tmp}/garden-bulletin.XXXXXX")"
  {
    printf '===== DETERMINISTIC DASHBOARD =====\n%s\n\n' "$dashboard"
    printf '===== BOARD TRANSITIONS SINCE LAST BULLETIN =====\n'
    printf '(name-status over jobs/ and entries/: an add under jobs/todo is a post,\n'
    printf 'a move todo->doin is a claim, a move doin->tada is a completion; adds\n'
    printf 'under entries/ are new progress notes.)\n\n'
    if [ -n "$since" ] && git -C "$DIR" cat-file -e "${since}^{commit}" 2>/dev/null; then
      transitions="$(git -C "$DIR" diff --name-status "$since" "$head" -- jobs entries 2>/dev/null || true)"
    elif git -C "$DIR" rev-parse --verify -q "${head}~1" >/dev/null 2>&1; then
      transitions="$(git -C "$DIR" diff --name-status "${head}~1" "$head" -- jobs entries 2>/dev/null || true)"
    else
      transitions="$(git -C "$DIR" show --name-status --pretty=format: "$head" -- jobs entries 2>/dev/null || true)"
    fi
    [ -n "$transitions" ] && printf '%s\n' "$transitions" || printf '(no file-level transitions resolved)\n'
  } > "$d"
  printf '%s\n' "$d"
}

# Run the journalist for the narrative; on any failure fall back to the prior
# `## Latest` block so the deterministic dashboard still ships. Echoes the full
# `## Latest` section (heading + body), or nothing if neither is available.
narrate() {
  local dashboard="$1" since="$2" head="$3" prior_latest="$4" digest body
  digest="$(build_digest "$dashboard" "$since" "$head")"
  if body="$("$GARDEN_BULLETIN_HANDLER" "$digest" 2>/dev/null)" && [ -n "${body//[$' \t\n']/}" ]; then
    rm -f "$digest"
    printf '## Latest\n\n%s\n' "$body"
    return 0
  fi
  rm -f "$digest"
  log "journalist unavailable or empty; shipping deterministic bulletin"
  [ -n "$prior_latest" ] && printf '%s\n' "$prior_latest"
  return 0
}

# One bulletin tick: sync, reconcile the plan view, compute the dashboard, and
# post when it changed. All side effects are durable (the cursor file, the clone's
# README + git state), so it carries no shell state back to the loop except its
# return code:
#   0 = idle (dashboard unchanged) → the loop idle-sleeps before the next tick;
#   3 = active (the board advanced; we posted, found nothing-to-commit, or lost
#       the CAS) → the loop runs the next tick promptly (debounce by being busy).
# Any OTHER non-zero return is a FAILED tick: `set -e`/`pipefail` is active inside
# this function, so a transient git/sort/jq hiccup aborts THIS tick cleanly (no
# half-written bulletin) and surfaces as a non-zero status the loop logs and
# survives. A single bad tick must never take down the continuous service.
bulletin_tick() {
  local head cursor dashboard old_full prior_latest latest head_part sect_part content rc
  sync_clone "$DIR"

  head="$(git -C "$DIR" rev-parse HEAD)"
  cursor="$(read_cursor)"

  # Push-gate: skip the ENTIRE tick when journal2 has not advanced since the last
  # reconcile. The bulletin reconciles journal2 state, so when nothing has been
  # pushed to origin/journal2 since we last looked (the synced head equals the
  # durable cursor) there is nothing to update — do no plan re-render, no dashboard
  # compute, no journalist, no post. This makes a journal2 PUSH the sole trigger
  # for a bulletin update: external GitHub drift (the parked-PR review queue is the
  # one dashboard input sourced from `gh` rather than journal2) no longer rewrites
  # and re-narrates the bulletin on its own; it refreshes on the next real push.
  # The `-s README.md` guard keeps a cold start (no bulletin posted yet) producing
  # the first bulletin even when head already equals the cursor.
  if [ -n "$cursor" ] && [ "$head" = "$cursor" ] && [ -s "$DIR/README.md" ]; then
    return 0
  fi

  # Reconcile the generated plan view from the per-design records (cheap,
  # deterministic, change-gated). Done before the dashboard compute so a plan-only
  # commit lands even on ticks where the dashboard is unchanged.
  render_plan

  # render_plan may have advanced HEAD with a plan-view commit; re-read so the
  # transitions digest and cursor advance below reflect the post-render head.
  head="$(git -C "$DIR" rev-parse HEAD)"

  dashboard="$(compute_dashboard)"

  # Cost gate + multi-host safety: compare the deterministic dashboard (minus the
  # volatile freshness line) against the dashboard already posted. If they match,
  # the board has not advanced beyond what is published (or another host posted
  # the current state first), so we run no journalist and make no commit.
  old_full="$(cat "$DIR/README.md" 2>/dev/null || true)"
  if [ "$(stable "$dashboard")" = "$(stable "$(dashboard_part "$old_full")")" ]; then
    # Nothing to post. Advance the cursor to head so a transition another host
    # already narrated is not re-narrated by us on the next real change.
    [ "$cursor" != "$head" ] && write_cursor "$head"
    return 0
  fi

  # The board changed. Narrate the delta and assemble the full bulletin with the
  # `## Latest` narrative as the LEAD: inject it right after the intro (before the
  # first `## ` deterministic section). On no narrative, ship the dashboard alone.
  prior_latest="$(latest_part "$old_full")"
  latest="$(narrate "$dashboard" "$cursor" "$head" "$prior_latest")"
  if [ -n "$latest" ]; then
    head_part="$(awk '/^## /{exit} {print}' <<<"$dashboard")"
    sect_part="$(awk '/^## /{f=1} f{print}' <<<"$dashboard")"
    content="$head_part"$'\n\n'"$latest"$'\n\n'"$sect_part"
  else
    content="$dashboard"
  fi

  printf '%s\n' "$content" > "$DIR/README.md"
  git -C "$DIR" add README.md
  if commit_and_push "$DIR" "bulletin: narrate board advance"; then
    # Advance the cursor durably ONLY after the push is accepted, so a crash
    # between post and cursor-write re-processes rather than skips.
    write_cursor "$(git -C "$DIR" rev-parse HEAD)"
    log "bulletin posted"
  else
    rc=$?
    if [ "$rc" -eq 2 ]; then
      # Nothing to commit (dashboard differed only in the excluded lines). Treat
      # as reconciled: advance the cursor and move on.
      write_cursor "$head"
    else
      # Push rejected (another host advanced origin). Do NOT advance the cursor;
      # re-sync next iteration and re-evaluate. backoff to break lockstep.
      log "push rejected; re-syncing next iteration"
      backoff
    fi
  fi
  return 3
}

iters=0
while :; do
  if fleet_draining; then
    log "fleet draining; idling"
    [ "$GARDEN_BULLETIN_ONCE" = "1" ] && exit 0
    sleep "$GARDEN_BULLETIN_IDLE_SLEEP"; continue
  fi

  # Leader-only singleton: the bulletin is the maintainer's single dashboard, so
  # exactly ONE host posts it (two would double-post). On a FOLLOWER, idle without
  # posting. This in-loop gate — not a start-time ExecCondition — is the
  # continuous singleton's promote/demote-without-restart mechanism: the leader
  # marker is re-read each iteration (cached, GARDEN_LEADER_TTL), so a demoted
  # leader goes quiet and a promoted follower starts posting with NO restart.
  # Single-host stays unchanged (no marker → fail-open leader). See garden#11.
  if ! is_main_host; then
    log "follower host (journal leader marker names another leader); idling, not posting"
    [ "$GARDEN_BULLETIN_ONCE" = "1" ] && exit 0
    sleep "$GARDEN_BULLETIN_IDLE_SLEEP"; continue
  fi

  # Run the tick in ISOLATION so one bad tick can never kill the service. The tick
  # is a backgrounded subshell launched at top level (NOT inside an `if`/`||`
  # context — that would disable `set -e` inside it per bash's conditional rule),
  # so `set -e`/`pipefail` stay ACTIVE within the tick while the parent loop is
  # immune to its failure. `wait` harvests the status without tripping the loop's
  # own `set -e`. A failed tick is LOGGED and the loop CONTINUES to the next tick;
  # it is never fatal. (Before this, a transient `sort` broken-pipe / fetch `die`
  # exited the whole process; with Restart=always the rapid restarts then hit
  # systemd's start-limit and the dashboard went dark for ~2h on 2026-06-25.)
  ( bulletin_tick ) & tick_pid=$!
  tick_rc=0
  wait "$tick_pid" || tick_rc=$?

  case "$tick_rc" in
    0) idle=1 ;;                         # dashboard unchanged → idle-sleep
    3) idle=0 ;;                         # board advanced → loop promptly
    *) log "bulletin tick failed (rc=$tick_rc); logged, continuing to next tick"
       idle=1 ;;                         # transient hiccup → idle-sleep, survive
  esac

  iters=$((iters+1))
  { [ "$GARDEN_BULLETIN_ONCE" = "1" ] || { [ "$GARDEN_BULLETIN_MAX_ITERS" -gt 0 ] && [ "$iters" -ge "$GARDEN_BULLETIN_MAX_ITERS" ]; }; } && exit 0
  [ "$idle" = 1 ] && sleep "$GARDEN_BULLETIN_IDLE_SLEEP"
done
