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
#   3. compute the deterministic dashboard (board counts, watch set, hosts,
#      maintainer inbox, recent progress) — the always-works base.
#   4. if the dashboard changed since what is posted: drive the journalist
#      (claude -p via GARDEN_BULLETIN_HANDLER) with the dashboard + the
#      since-cursor transitions to produce `## Latest`; assemble dashboard +
#      `## Latest`; write, commit, push (CAS); then advance the cursor durably
#      ONLY after the push is accepted (a crash mid-cycle re-processes, never
#      skips).
#   5. if nothing changed: advance the cursor to the synced head (so a transition
#      another host already posted is not re-narrated), short sleep, loop.
#
# Cost gate: claude -p runs ONLY when the dashboard changed since what is posted;
# never on an idle poll. The change-compare excludes the volatile `_As of`
# freshness line and the `## Latest` narrative, so neither an advancing timestamp
# nor non-deterministic narrative prose churns a commit on its own.
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

# Compute the deterministic dashboard for the current synced state of $DIR and
# print it to stdout. This is the always-works base; it reuses the v1 board logic.
compute_dashboard() {
  local watch hosts_block h g maint m mf rt frm link recent f first now board
  board=$(render_board)
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

  recent=""
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    first=$(awk 'c>=2 && NF{print; exit} /^---$/{c++}' "$f")
    recent+="- ${f##*/}: ${first}"$'\n'
  done < <(find "$DIR/entries" -type f -name '*.md' 2>/dev/null | sort | tail -15)
  [ -n "$recent" ] || recent="(no progress entries yet)"$'\n'

  # Freshness stamp. The bulletin now updates continuously as the board advances
  # (garden-bulletin.service), rewritten only when the dashboard changes, so this
  # marks the last change, not the last check. It is excluded from the change
  # comparison below, so an advancing timestamp never causes a commit on its own.
  now=$(date -u +%FT%TZ)

  cat <<EOF
# Garden bulletin

_As of ${now} · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

${maint}
## Board
${board}

## Watch set
$watch

## Hosts
${hosts_block}
## Recent progress
${recent}
EOF
}

# Everything in $1 (a full bulletin) up to but not including the `## Latest` line.
dashboard_part() { awk '/^## Latest$/{exit} {print}' <<<"$1"; }
# The `## Latest` section (heading + body) of $1, empty if absent.
latest_part()    { awk '/^## Latest$/{f=1} f{print}'   <<<"$1"; }
# Strip the volatile freshness line so the compare is stable.
stable()         { grep -vE '^_As of ' <<<"$1" || true; }

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

  # The board changed. Narrate the delta and assemble the full bulletin.
  prior_latest="$(latest_part "$old_full")"
  latest="$(narrate "$dashboard" "$cursor" "$head" "$prior_latest")"
  if [ -n "$latest" ]; then content="$dashboard"$'\n'"$latest"; else content="$dashboard"; fi

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
