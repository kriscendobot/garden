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
#   1. killswitch check; sync the bulletin journal clone.
#   2. read the durable cursor (the origin/journal2 SHA last reconciled from) and
#      compute the board transitions since it.
#   3. compute the deterministic dashboard (the parked-for-maintainer PR queue,
#      board counts, watch set, hosts, maintainer inbox) — the always-works base.
#   4. if the dashboard changed since what is posted: drive the journalist
#      (claude -p via GARDEN_BULLETIN_HANDLER) with the dashboard + the
#      since-cursor transitions to produce `## Latest`; assemble it as the LEAD
#      (`## Latest` sits at the top, right after the freshness line, ahead of the
#      deterministic sections); write, commit, push (CAS); then advance the cursor
#      durably ONLY after the push is accepted (a crash mid-cycle re-processes,
#      never skips).
#   5. if nothing changed: advance the cursor to the synced head (so a transition
#      another host already posted is not re-narrated), short sleep, loop.
#
# Cost gate: claude -p runs ONLY when the dashboard changed since what is posted;
# never on an idle poll. The change-compare excludes the volatile `_As of`
# freshness line, the `## Latest` narrative (wherever it sits — it now leads), and
# the volatile "(waiting <age>)" suffix on parked-PR rows, so neither an advancing
# timestamp, non-deterministic narrative prose, nor a ticking PR age churns a
# commit on its own. The parked-PR set itself (a PR entering/leaving the
# review-requested queue) DOES change the dashboard and is news worth posting.
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
  local todo_n doin_n tada_n j desc
  todo_n=$(list_jobs "$DIR" jobs/todo | grep -c . || true)
  doin_n=$(list_jobs "$DIR" jobs/doin | grep -c . || true)
  tada_n=$(list_jobs "$DIR" jobs/tada | grep -c . || true)

  printf '### todo (%s)\n' "$todo_n"
  if [ "$todo_n" -gt 0 ]; then
    while IFS= read -r j; do
      [ -n "$j" ] || continue
      desc=$(job_desc "$DIR/jobs/todo/$j")
      printf -- '- `%s` — %s\n' "${j%.md}" "$desc"
    done < <(list_jobs "$DIR" jobs/todo)
  else
    printf '(none)\n'
  fi

  printf '\n### doin (%s)\n' "$doin_n"
  if [ "$doin_n" -gt 0 ]; then
    while IFS= read -r j; do
      [ -n "$j" ] || continue
      desc=$(job_desc "$DIR/jobs/doin/$j")
      printf -- '- `%s` — %s\n' "${j%.md}" "$desc"
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
      desc=$(job_desc "$DIR/jobs/tada/$j")
      printf -- '- `%s` — %s\n' "${j%.md}" "$desc"
    done < <(find "$DIR/jobs/tada" -maxdepth 1 -type f ! -name '.gitkeep' -printf '%T@ %f\n' 2>/dev/null | sort -rn | head -5 | cut -d' ' -f2-)
    if [ "$tada_n" -gt 5 ]; then printf -- '- … and %s more\n' "$((tada_n - 5))"; fi
  else
    printf '(none)\n'
  fi
}

# Render a maintainer message body as a Markdown blockquote so the bulletin is
# self-contained and followable: everything after the frontmatter delimiter, each
# line prefixed with "> " (blank lines become a bare ">"), with leading/trailing
# blank lines trimmed. Prefixing every body line keeps any fenced code block
# balanced inside the quote, so a Markdown- or fence-containing body cannot break
# the surrounding bulletin. An empty body renders as "> (empty message)".
msg_body_quote() {
  awk '
    b { body[++n] = $0 }
    /^---$/ { b=1 }
    END {
      s=1; while (s<=n && body[s] ~ /^[[:space:]]*$/) s++
      e=n; while (e>=s && body[e] ~ /^[[:space:]]*$/) e--
      if (s>e) { print "> (empty message)"; exit }
      for (i=s; i<=e; i++) {
        if (body[i] ~ /^[[:space:]]*$/) print ">"
        else print "> " body[i]
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
      }
      END {
        gsub(/[[:space:]"\x27]/, "", pr); gsub(/[[:space:]"\x27]/, "", repo)
        gsub(/[^0-9]/, "", rel); gsub(/[^0-9]/, "", prio)
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
  # awk: load the roadmap index (FNR==NR on the first file), then score each PR
  # row from stdin. Emit "score<TAB>repo<TAB>num<TAB>url<TAB>updated<TAB>title".
  printf '%s\n' "$rows" \
  | awk -v now="$now" -v hl="$hl" -v wr="$wr" -v wm="$wm" \
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
  local watch hosts_block h g maint m mf rt frm link now board parked
  board=$(render_board)
  parked=$(parked_section)
  watch=$(list_jobs "$DIR" repos | paste -sd' ' - 2>/dev/null); [ -n "$watch" ] || watch="(none)"

  hosts_block=""
  for h in $(list_jobs "$DIR" hosts); do
    g=$(sed -n 's/^gardeners:[[:space:]]*//p' "$DIR/hosts/$h" | head -1)
    hosts_block+="- $h: ${g:-?} gardeners"$'\n'
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
    link="https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/$m"
    maint+="- \`${m%.md}\` — from ${frm:-?}, reply_to \`${rt:-?}\` · [open message]($link)"$'\n\n'
    maint+="$(msg_body_quote "$mf")"$'\n\n'
  done
  [ -n "$maint" ] || maint="(no pending maintainer messages)"$'\n'

  # Freshness stamp. The bulletin now updates continuously as the board advances
  # (garden-bulletin.service), rewritten only when the dashboard changes, so this
  # marks the last change, not the last check. It is excluded from the change
  # comparison below, so an advancing timestamp never causes a commit on its own.
  now=$(date -u +%FT%TZ)

  cat <<EOF
# Garden bulletin

_As of ${now} · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Parked for maintainer feedback

${parked}
## Messages to the maintainer

${maint}
## Board
${board}

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
# Strip the volatile lines so the compare is stable: the `_As of` freshness line and
# the ticking "(waiting <age>)" suffix on parked-PR rows (the PR set still differs
# when a PR enters/leaves the queue, so real motion is not masked).
stable() {
  grep -vE '^_As of ' <<<"$1" | sed -E 's/ \(waiting [^)]*\)$//' || true
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

iters=0
while :; do
  if killswitch_engaged; then
    log "killswitch engaged; idling"
    [ "$GARDEN_BULLETIN_ONCE" = "1" ] && exit 0
    sleep "$GARDEN_BULLETIN_IDLE_SLEEP"; continue
  fi

  sync_clone "$DIR"
  head="$(git -C "$DIR" rev-parse HEAD)"
  cursor="$(read_cursor)"

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
    iters=$((iters+1))
    { [ "$GARDEN_BULLETIN_ONCE" = "1" ] || { [ "$GARDEN_BULLETIN_MAX_ITERS" -gt 0 ] && [ "$iters" -ge "$GARDEN_BULLETIN_MAX_ITERS" ]; }; } && exit 0
    sleep "$GARDEN_BULLETIN_IDLE_SLEEP"
    continue
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

  iters=$((iters+1))
  { [ "$GARDEN_BULLETIN_ONCE" = "1" ] || { [ "$GARDEN_BULLETIN_MAX_ITERS" -gt 0 ] && [ "$iters" -ge "$GARDEN_BULLETIN_MAX_ITERS" ]; }; } && exit 0
done
