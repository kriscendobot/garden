#!/bin/bash
# review-docket.sh — deterministic maintainer-review queue and PRIORITIES.md renderer.
#
# Usage:
#   review-docket.sh upsert <PR-URL> <request.json>
#   review-docket.sh retire-review <PR-URL> <author> <state> <submitted-at> [review-id]
#   review-docket.sh retire-terminal <PR-URL> <MERGED|CLOSED> [completed-at]
#   review-docket.sh reenter <PR-URL> <source-id>
#   review-docket.sh reconcile [PR-URL...]
#   review-docket.sh render
#
# All mutations, the root view, and its daily archive land in one journal CAS.
# Producers must use this command rather than writing review-docket/open directly.
#
# A bare `reconcile` is the periodic recovery sweep. It is bounded: it visits at
# most GARDEN_REVIEW_DOCKET_RECONCILE_BATCH open records per run, starting after
# a host-local resumable cursor (wrapping around), gives each GitHub metadata
# request GARDEN_REVIEW_DOCKET_METADATA_TIMEOUT seconds, and stops fetching once
# GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET seconds have elapsed since startup, so a
# slow or large docket advances over several ticks instead of failing whole.
# `reconcile <PR-URL>...` reconciles exactly those records and ignores the cursor.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="review-docket"

command -v jq >/dev/null 2>&1 || die "review-docket.sh needs jq"
: "${GARDEN_REVIEW_DOCKET_CLONE:=$GARDEN_STATE/review-docket/journal}"
: "${GARDEN_REVIEW_DOCKET_METADATA:=$HERE/handlers/review-docket-pr-gh.sh}"
: "${GARDEN_REVIEW_DOCKET_ATTEMPTS:=50}"
: "${GARDEN_REVIEW_DOCKET_NOW:=$(date -u +%FT%TZ)}"
: "${GARDEN_REVIEW_DOCKET_RECONCILE_BATCH:=25}"
: "${GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET:=600}"
: "${GARDEN_REVIEW_DOCKET_METADATA_TIMEOUT:=45}"
: "${GARDEN_REVIEW_DOCKET_CURSOR:=$GARDEN_STATE/review-docket/reconcile-cursor}"
RECONCILE_DEADLINE=$(( $(date +%s) + GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET ))
RECONCILE_CACHE=""
RECONCILE_LAST=""
DOCKET_LOCKED=0
cleanup() {
  [ -z "$RECONCILE_CACHE" ] || rm -rf "$RECONCILE_CACHE"
  [ "$DOCKET_LOCKED" -eq 0 ] || garden_repo_unlock "$DIR"
}
trap cleanup EXIT

operation="${1:-}"; shift || true
case "$operation" in upsert|retire-review|retire-terminal|reenter|reconcile|render) :;;
  *) die "usage: review-docket.sh {upsert|retire-review|retire-terminal|reenter|reconcile|render} ...";;
esac

parse_url() { # <url> -> repo<TAB>number
  local url="$1"
  if [[ "$url" =~ ^https://github\.com/([A-Za-z0-9._-]+/[A-Za-z0-9._-]+)/pull/([1-9][0-9]*)/?$ ]]; then
    printf '%s\t%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
  else
    die "not a canonical GitHub pull-request URL: '$url'"
  fi
}

slug_for() { printf '%s-pr%s\n' "${1//\//-}" "$2"; }
iso_epoch() { date -u -d "$1" +%s 2>/dev/null; }
valid_iso() { iso_epoch "$1" >/dev/null; }

metadata() { # authoritative GitHub metadata; JSON or nonzero, never guessed
  "$GARDEN_REVIEW_DOCKET_METADATA" "$1"
}

# Reconcile metadata is memoized per run, failures included, so a CAS retry
# re-applies against what was already fetched instead of re-paying the network.
reconcile_metadata() { # <url> <slug>; JSON or nonzero
  local url="$1" slug="$2" remaining limit rc=0
  if [ -z "$RECONCILE_CACHE" ]; then
    RECONCILE_CACHE="$(mktemp -d "${TMPDIR:-/tmp}/review-docket-reconcile.XXXXXX")"
  fi
  if [ -f "$RECONCILE_CACHE/$slug.json" ]; then cat "$RECONCILE_CACHE/$slug.json"; return 0; fi
  [ ! -f "$RECONCILE_CACHE/$slug.failed" ] || return 1
  remaining=$(( RECONCILE_DEADLINE - $(date +%s) ))
  [ "$remaining" -gt 0 ] || return 124
  limit="$GARDEN_REVIEW_DOCKET_METADATA_TIMEOUT"
  [ "$remaining" -ge "$limit" ] || limit="$remaining"
  timeout --kill-after=5 "${limit}s" "$GARDEN_REVIEW_DOCKET_METADATA" "$url" \
    > "$RECONCILE_CACHE/$slug.tmp" 2>/dev/null || rc=$?
  if [ "$rc" -ne 0 ]; then
    rm -f "$RECONCILE_CACHE/$slug.tmp"; : > "$RECONCILE_CACHE/$slug.failed"
    [ "$rc" -ne 124 ] || log "metadata for $url timed out after ${limit}s; leaving its docket entry for a later sweep"
    return 1
  fi
  mv "$RECONCILE_CACHE/$slug.tmp" "$RECONCILE_CACHE/$slug.json"
  cat "$RECONCILE_CACHE/$slug.json"
}

reconcile_targets() { # <root>; open-record paths for this run, one per line
  local root="$1" url repo number cursor
  if [ "${#ARGS[@]}" -gt 0 ]; then
    for url in "${ARGS[@]}"; do
      IFS=$'\t' read -r repo number < <(parse_url "$url")
      printf '%s\n' "$root/review-docket/open/$(slug_for "$repo" "$number").json"
    done
    return 0
  fi
  cursor="$(cat "$GARDEN_REVIEW_DOCKET_CURSOR" 2>/dev/null || true)"
  find "$root/review-docket/open" -maxdepth 1 -type f -name '*.json' -printf '%f\n' 2>/dev/null \
    | sed 's/\.json$//' | LC_ALL=C sort \
    | awk -v c="$cursor" '{ if (c != "" && $0 <= c) wrapped[++w]=$0; else print } END { for (i=1;i<=w;i++) print wrapped[i] }' \
    | head -n "$GARDEN_REVIEW_DOCKET_RECONCILE_BATCH" \
    | sed "s#^#$root/review-docket/open/#; s#\$#.json#"
}

save_reconcile_cursor() {
  [ "$operation" = reconcile ] && [ "${#ARGS[@]}" -eq 0 ] && [ -n "$RECONCILE_LAST" ] || return 0
  mkdir -p "$(dirname "$GARDEN_REVIEW_DOCKET_CURSOR")"
  printf '%s\n' "$RECONCILE_LAST" > "$GARDEN_REVIEW_DOCKET_CURSOR.tmp"
  mv "$GARDEN_REVIEW_DOCKET_CURSOR.tmp" "$GARDEN_REVIEW_DOCKET_CURSOR"
}

valid_metadata() {
  jq -e 'type=="object"
    and ((.head_oid // "") | type=="string" and test("^[0-9a-fA-F]{7,64}$"))
    and ((.ci.state // "unknown") | IN("green","red","pending","unknown"))' \
    >/dev/null 2>&1 <<<"$1"
}

sanitize_record() { # <input> <url> <repo> <number> <metadata> <prior-or-null>
  local input="$1" url="$2" repo="$3" number="$4" meta="$5" prior="$6"
  jq -cn --slurpfile request "$input" --arg url "$url" --arg repo "$repo" \
    --argjson pr "$number" --argjson metadata "$meta" --argjson prior "$prior" \
    --arg now "$GARDEN_REVIEW_DOCKET_NOW" '
      def line:
        if type != "string" then error("rendered fields must be strings") else
          gsub("[\u0000-\u001f\u007f]"; " ") | gsub("[[:space:]]+"; " ")
          | sub("^[[:space:]]+"; "") | sub("[[:space:]]+$"; "")
        end;
      ($request[0]) as $r
      | if ($r|type) != "object" then error("request must be an object") else . end
      | if ($r.schema // 1) != 1 then error("schema must be 1") else . end
      | if ($r.repo // $repo) != $repo or (($r.pr // $pr)|tonumber) != $pr
        or ($r.url // $url) != $url then error("record repo/pr/url disagree") else . end
      | ($r.ask // "") as $ask
      | if (["approve","decide","re-review"] | index($ask)) == null
        then error("ask must be approve, decide, or re-review") else . end
      | (($r.arc // "unallocated")|line) as $arc
      | if (($arc|test("^[a-z0-9][a-z0-9-]*$"))|not) then error("invalid arc") else . end
      | (($r.milestone // "-")|line) as $milestone
      | if ($milestone != "-" and (($milestone|test("^M[1-9][0-9]*$"))|not))
        then error("milestone must be M<N> or -") else . end
      | (($r.summary // "")|line) as $summary
      | if $summary == "" then error("summary is required") else . end
      | (($r.source // "")|line) as $source
      | if ($source == "" or (($source|test("^[A-Za-z0-9._:-]+$"))|not))
        then error("source is required and must be a stable identifier") else . end
      | [($r.unblocks // [])[] |
          {kind: ((.kind // "")|line), ref: ((.ref // "")|line),
           summary: ((.summary // "")|line)}
          | .kind as $kind
          | if (["job","plan","blocked-job","milestone-gate","dependent-stack","dependent-pr","pr"] | index($kind)) == null
            then error("unsupported unblock kind")
            elif .ref == "" or .summary == ""
            then error("each unblock needs kind, ref, and summary") else . end] as $unblocks
      | ($metadata.head_oid // "") as $head
      | if (($head|test("^[0-9a-fA-F]{7,64}$"))|not) then error("GitHub returned no valid head oid") else . end
      | (($r.requested_at // $now)|line) as $requested
      | (($r.first_requested_at // $requested)|line) as $first
      | (($prior // null)) as $p
      | ($p != null and $p.source == $source and $p.head_oid == $head and $p.ask == $ask) as $same
      | {same:$same, record:
          {schema:1, repo:$repo, pr:$pr, url:$url, head_oid:$head, ask:$ask,
           arc:$arc, milestone:$milestone, summary:$summary, unblocks:$unblocks,
           source:$source,
           requested_at:(if $p != null and $same then $p.requested_at else $requested end),
           first_requested_at:(if $p != null then $p.first_requested_at else $first end),
           generation:(if $p != null then (if $same then $p.generation else $p.generation+1 end) else 1 end),
           ci:($metadata.ci // {state:"unknown",observed_at:$now})}}
    '
}

markdown_escape() {
  printf '%s' "$1" | tr '\r\n\t' '   ' \
    | sed -E 's/[[:space:]]+/ /g; s/\\/\\\\/g; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/\[/\\[/g; s/\]/\\]/g; s/\|/\\|/g; s/`/\\`/g'
}

human_tokens() {
  awk -v n="${1:-0}" 'BEGIN { if (n>=1000000000) printf "%.1fG",n/1000000000; else if (n>=1000000) printf "%.1fM",n/1000000; else if (n>=1000) printf "%.1fK",n/1000; else printf "%d",n }' | sed 's/\.0\([KMG]\)$/\1/'
}

impact_for() { # <root> <record> -> class<TAB>count<TAB>display
  local root="$1" rec="$2" best=4 count=0 text="—" kind ref summary live class n
  while IFS=$'\t' read -r kind ref summary; do
    [ -n "$kind" ] || continue
    live=0; class=4; n=0
    case "$kind" in
      job|plan|blocked-job)
        if find "$root/jobs/plan" "$root/jobs/todo" "$root/jobs/doin" -type f -name "$ref.md" -print -quit 2>/dev/null | grep -q .; then live=1; class=1; fi ;;
      milestone-gate) live=1; class=2 ;;
      dependent-stack|dependent-pr|pr)
        class=3
        if [ -e "$root/pr-deps/$ref" ] || rg -l -F "$ref" "$root/pr-deps" >/dev/null 2>&1; then
          live=1; n="$(rg -l -F "$ref" "$root/pr-deps" 2>/dev/null | wc -l)"
        fi ;;
    esac
    if [ "$live" -eq 1 ]; then
      [ "$class" -gt "$best" ] || { best="$class"; count="$n"; text="$summary"; }
    elif [ "$best" -eq 4 ]; then
      text="$summary (stale: $ref)"
    fi
  done < <(jq -r '.unblocks[]? | [.kind,.ref,.summary] | @tsv' "$rec")
  printf '%s\t%s\t%s\n' "$best" "$count" "$text"
}

render_all() { # <journal-root>
  local root="$1"
  local output="$root/PRIORITIES.md" now="$GARDEN_REVIEW_DOCKET_NOW"
  local apportion="$root/config/apportionment" week="not apportioned" total=0
  [ -f "$apportion" ] && { week="$(jq -r '.week_start // "unknown"' "$apportion")"; total="$(jq -r '.total_tokens // 0' "$apportion")"; }
  {
    printf '<!-- generated by scripts/jobs/review-docket.sh; do not hand-edit -->\n'
    printf '# Garden priorities and maintainer review docket\n\n'
    printf '_Generated %s from accountant-owned allocation policy and the clerk review queue._\n\n' "$now"
    printf '## Current allocation\n\n'
    printf 'Week: `%s` · total: %s tokens\n\n' "$week" "$(human_tokens "$total")"
    printf '| Rank | Arc | Summary | Slice | Spend | Headroom | Review milestones |\n'
    printf '| ---: | --- | --- | ---: | ---: | ---: | --- |\n'
    if [ -f "$apportion" ]; then
      while IFS=$'\t' read -r rank arc summary cap; do
        spend=0; remain="$cap"
        spend_json="$("$HERE/arc-spend.sh" --dir "$root" "$arc" 2>/dev/null || true)"
        if [ -n "$spend_json" ]; then spend="$(jq -r '.spend_tokens' <<<"$spend_json")"; remain="$(jq -r '.remaining_tokens' <<<"$spend_json")"; fi
        milestones="$(jq -rs --arg arc "$arc" '[.[]|select(.arc==$arc)|.milestone]|unique|sort|join(", ")' "$root"/review-docket/open/*.json 2>/dev/null || echo '')"
        [ -n "$milestones" ] || milestones="—"
        printf '| %s | `%s` | %s | %s | %s | %s | %s |\n' "$rank" "$arc" "$(markdown_escape "$summary")" "$(human_tokens "$cap")" "$(human_tokens "$spend")" "$(human_tokens "$remain")" "$milestones"
      done < <(jq -r '.slate[] | [.rank,.arc,.summary,.token_cap] | @tsv' "$apportion")
      reserve="$(jq -r '.unallocated_tokens // 0' "$apportion")"
      printf '| — | `unallocated` | Reserve | %s | — | %s | — |\n' "$(human_tokens "$reserve")" "$(human_tokens "$reserve")"
    else
      printf '| — | `unallocated` | No accountant apportionment is recorded | — | — | — | — |\n'
    fi
    printf '\n## Maintainer review docket\n\n'
    printf '| PR | Arc | Milestone | Unblocks | Ask | CI | Summary | Age |\n'
    printf '| --- | --- | --- | --- | --- | --- | --- | ---: |\n'
  } > "$output"

  local rows="$root/.review-docket-rows.$$" rank milestone_num impact count requested repo pr
  : > "$rows"
  for rec in "$root"/review-docket/open/*.json; do
    [ -f "$rec" ] || continue
    arc="$(jq -r .arc "$rec")"
    rank="$(jq -r --arg arc "$arc" '([.slate[]?|select(.arc==$arc)|.rank][0] // 999999)' "$apportion" 2>/dev/null || echo 999999)"
    milestone="$(jq -r .milestone "$rec")"; milestone_num=999999
    [[ "$milestone" =~ ^M([0-9]+)$ ]] && milestone_num="${BASH_REMATCH[1]}"
    IFS=$'\t' read -r impact count unblock < <(impact_for "$root" "$rec")
    requested="$(jq -r .requested_at "$rec")"; repo="$(jq -r .repo "$rec")"; pr="$(jq -r .pr "$rec")"
    printf '%09d\t%09d\t%s\t%09d\t%s\t%s\t%09d\t%s\t%s\n' "$rank" "$milestone_num" "$impact" "$((999999-count))" "$requested" "$repo" "$pr" "$unblock" "$rec" >> "$rows"
  done
  if [ -s "$rows" ]; then
    sort -t$'\t' -k1,1n -k2,2n -k3,3n -k4,4n -k5,5 -k6,6 -k7,7n "$rows" |
    while IFS=$'\t' read -r _ _ _ _ _ _ _ unblock rec; do
      url="$(jq -r .url "$rec")"; repo="$(jq -r .repo "$rec")"; pr="$(jq -r .pr "$rec")"
      arc="$(jq -r .arc "$rec")"; milestone="$(jq -r .milestone "$rec")"; ask="$(jq -r .ask "$rec")"
      ci="$(jq -r '.ci.state + " @ " + (.ci.observed_at // "unknown")' "$rec")"
      summary="$(jq -r .summary "$rec")"; requested="$(jq -r .requested_at "$rec")"
      req_epoch="$(iso_epoch "$requested" || echo 0)"; now_epoch="$(iso_epoch "$now" || date -u +%s)"
      age_days=$(( (now_epoch-req_epoch) / 86400 )); [ "$age_days" -ge 0 ] || age_days=0
      printf '| [%s#%s](%s) | `%s` | %s | %s | %s | %s | %s | %sd |\n' "$repo" "$pr" "$url" "$arc" "$milestone" "$(markdown_escape "$unblock")" "$ask" "$(markdown_escape "$ci")" "$(markdown_escape "$summary")" "$age_days" >> "$output"
    done
  else
    printf '| _No open review requests._ | — | — | — | — | — | — | — |\n' >> "$output"
  fi
  rm -f "$rows"
  printf '\n[Priorities archive](priorities-archive/README.md)\n' >> "$output"

  local day="${now%%T*}"
  local archive="$root/priorities-archive/$day.md"
  local appendix=""
  mkdir -p "$root/priorities-archive"
  # The migration child appends its path-labelled legacy inventory below this
  # marker. Same-day regeneration replaces the generated snapshot but preserves
  # that audit appendix byte-for-byte.
  if [ -f "$archive" ] && grep -q '^<!-- review-docket-migration-appendix -->$' "$archive"; then
    appendix="$(sed -n '/^<!-- review-docket-migration-appendix -->$/,$p' "$archive")"
  fi
  cp "$output" "$archive"
  [ -z "$appendix" ] || printf '\n%s\n' "$appendix" >> "$archive"
  {
    printf '# Priorities archive\n\n'
    printf 'Daily generated snapshots; git history retains same-day revisions.\n\n'
    for f in "$root"/priorities-archive/????-??-??.md; do [ -f "$f" ] && printf -- '- [%s](%s)\n' "$(basename "$f" .md)" "$(basename "$f")"; done | sort -r
  } > "$root/priorities-archive/README.md"
  if [ -f "$root/README.md" ] && ! grep -q '](PRIORITIES.md)' "$root/README.md"; then
    awk 'BEGIN{added=0} {print} !added && /^# / {print "\n[Current priorities and maintainer review docket](PRIORITIES.md)"; added=1}' \
      "$root/README.md" > "$root/README.md.tmp"
    mv "$root/README.md.tmp" "$root/README.md"
  fi
}

retire_file() { # <root> <open-file> <evidence-json>
  local root="$1" open="$2" evidence="$3" date repo pr generation destination
  date="$(jq -r '.at[0:10]' <<<"$evidence")"; repo="$(jq -r .repo "$open")"
  pr="$(jq -r .pr "$open")"; generation="$(jq -r .generation "$open")"
  destination="$root/review-docket/retired/${date:0:4}/${date:5:2}/${date:8:2}/$(slug_for "$repo" "$pr")-g$generation.json"
  mkdir -p "$(dirname "$destination")"
  jq --argjson evidence "$evidence" '. + {retirement:$evidence}' "$open" > "$destination"
  rm -f "$open"
}

apply_operation() { # <root>; rc 2 means no mutation
  local root="$1" url repo number slug open meta prior normalized same author author_lc state at review_id req_epoch event_epoch rc
  mkdir -p "$root/review-docket/open" "$root/review-docket/retired"
  case "$operation" in
    upsert)
      [ "$#" -ge 1 ]; url="${ARGS[0]:-}"; request="${ARGS[1]:-}"
      [ -f "$request" ] || die "upsert needs a request JSON file"
      IFS=$'\t' read -r repo number < <(parse_url "$url"); slug="$(slug_for "$repo" "$number")"; open="$root/review-docket/open/$slug.json"
      meta="$(metadata "$url")" || die "GitHub metadata unavailable for $url; leaving docket unchanged"
      valid_metadata "$meta" || die "metadata handler returned invalid or incomplete JSON"
      prior=null
      if [ -f "$open" ]; then
        prior="$(cat "$open")"
      else
        latest="$(find "$root/review-docket/retired" -type f -name "$slug-g*.json" -print 2>/dev/null | sort -V | tail -1)"
        # A retired generation supplies lineage, but never makes a fresh explicit
        # request a no-op even when source/head/ask happen to repeat.
        [ -z "$latest" ] || prior="$(jq '.source="__retired__"' "$latest")"
      fi
      normalized="$(sanitize_record "$request" "$url" "$repo" "$number" "$meta" "$prior")" || die "review request rejected"
      valid_iso "$(jq -r '.record.requested_at' <<<"$normalized")" || die "requested_at is not ISO-8601"
      valid_iso "$(jq -r '.record.first_requested_at' <<<"$normalized")" || die "first_requested_at is not ISO-8601"
      same="$(jq -r .same <<<"$normalized")"; [ "$same" = false ] || return 2
      jq '.record' <<<"$normalized" > "$open"
      ;;
    reenter)
      url="${ARGS[0]:-}"; source_id="${ARGS[1]:-}"
      [[ "$source_id" =~ ^[A-Za-z0-9._:-]+$ ]] || die "reenter needs a stable source id"
      IFS=$'\t' read -r repo number < <(parse_url "$url"); slug="$(slug_for "$repo" "$number")"; open="$root/review-docket/open/$slug.json"
      meta="$(metadata "$url")" || die "GitHub metadata unavailable for $url; leaving docket unchanged"
      valid_metadata "$meta" || die "metadata handler returned invalid or incomplete JSON"
      [ "$(jq -r '.ci.state // "unknown"' <<<"$meta")" = green ] || { log "$url is not green; refusing fixer re-entry"; return 3; }
      latest="$(find "$root/review-docket/retired" -type f -name "$slug-g*.json" -print 2>/dev/null | sort -V | tail -1)"
      [ -n "$latest" ] || { log "$url has no retired request to inherit"; return 2; }
      if [ -f "$open" ] && [ "$(jq -r .head_oid "$open")" = "$(jq -r .head_oid <<<"$meta")" ] \
         && [ "$(jq -r .ask "$open")" = re-review ]; then return 2; fi
      jq --argjson metadata "$meta" --arg source "$source_id" --arg now "$GARDEN_REVIEW_DOCKET_NOW" '
        del(.retirement) | .head_oid=$metadata.head_oid | .ask="re-review" | .source=$source
        | .requested_at=$now | .generation=(.generation+1) | .ci=$metadata.ci
      ' "$latest" > "$open"
      ;;
    retire-review)
      url="${ARGS[0]:-}"; author="${ARGS[1]:-}"; state="${ARGS[2]:-}"; at="${ARGS[3]:-}"; review_id="${ARGS[4]:--}"
      case "$state" in APPROVED|CHANGES_REQUESTED|COMMENTED) :;; *) die "unsupported review state '$state'";; esac
      valid_iso "$at" || die "review time is not ISO-8601"
      author_lc="$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')"
      grep -Ev '^[[:space:]]*(#|$)' "$root/maintainers/allowlist" 2>/dev/null \
        | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | grep -qxF "$author_lc" || return 2
      IFS=$'\t' read -r repo number < <(parse_url "$url"); open="$root/review-docket/open/$(slug_for "$repo" "$number").json"; [ -f "$open" ] || return 2
      req_epoch="$(iso_epoch "$(jq -r .requested_at "$open")")"; event_epoch="$(iso_epoch "$at")"; [ "$event_epoch" -ge "$req_epoch" ] || return 2
      retire_file "$root" "$open" "$(jq -cn --arg repo "$repo" --arg at "$at" --arg state "$state" --arg author "$author" --arg id "$review_id" '{kind:"review",repo:$repo,at:$at,state:$state,author:$author,review_id:$id}')"
      ;;
    retire-terminal)
      url="${ARGS[0]:-}"; state="${ARGS[1]:-}"; at="${ARGS[2]:-$GARDEN_REVIEW_DOCKET_NOW}"
      case "$state" in MERGED|CLOSED) :;; *) die "terminal state must be MERGED or CLOSED";; esac
      valid_iso "$at" || die "terminal time is not ISO-8601"
      IFS=$'\t' read -r repo number < <(parse_url "$url"); open="$root/review-docket/open/$(slug_for "$repo" "$number").json"; [ -f "$open" ] || return 2
      retire_file "$root" "$open" "$(jq -cn --arg repo "$repo" --arg at "$at" --arg state "$state" '{kind:"terminal",repo:$repo,at:$at,state:$state}')"
      ;;
    reconcile)
      changed=0; RECONCILE_LAST=""
      while IFS= read -r open; do
        [ -f "$open" ] || continue; url="$(jq -r .url "$open")"; slug="$(basename "$open" .json)"
        rc=0; meta="$(reconcile_metadata "$url" "$slug")" || rc=$?
        if [ "$rc" -eq 124 ]; then
          log "reconcile budget (${GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET}s) spent; the next run resumes from the cursor"
          break
        fi
        RECONCILE_LAST="$slug"
        [ "$rc" -eq 0 ] || continue
        valid_metadata "$meta" || { log "invalid metadata for $url; leaving its docket entry visible"; continue; }
        state="$(jq -r '.state // "UNKNOWN"' <<<"$meta")"
        if [ "$state" = MERGED ] || [ "$state" = CLOSED ]; then
          retire_file "$root" "$open" "$(jq -cn --arg at "$(jq -r '.completed_at // .observed_at // empty' <<<"$meta")" --arg state "$state" '{kind:"terminal",at:$at,state:$state}')"; changed=1; continue
        fi
        requested="$(jq -r .requested_at "$open")"
        reviews="$(jq -c --arg at "$requested" '
          [.reviews[]? | select(.state=="APPROVED" or .state=="CHANGES_REQUESTED" or .state=="COMMENTED")
           | select(.submitted_at >= $at)] | sort_by(.submitted_at) | reverse | .[]' <<<"$meta" 2>/dev/null || true)"
        review=""
        while IFS= read -r candidate; do
          [ -n "$candidate" ] || continue
          if grep -Ev '^[[:space:]]*(#|$)' "$root/maintainers/allowlist" 2>/dev/null \
             | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' \
             | grep -qixF "$(jq -r .author <<<"$candidate")"; then
            review="$candidate"; break
          fi
        done <<<"$reviews"
        if [ -n "$review" ]; then
          retire_file "$root" "$open" "$(jq -c '. + {kind:"review",at:.submitted_at}' <<<"$review")"; changed=1; continue
        fi
        updated="$(jq --argjson metadata "$meta" '.head_oid=$metadata.head_oid | .ci=$metadata.ci' "$open")"
        if ! cmp -s "$open" <(printf '%s\n' "$updated"); then printf '%s\n' "$updated" > "$open"; changed=1; fi
      done < <(reconcile_targets "$root")
      [ "$changed" -eq 1 ] || return 2
      ;;
    render) : ;;
  esac
  render_all "$root"
}

ARGS=("$@")
DIR="$GARDEN_REVIEW_DOCKET_CLONE"
if [ "${GARDEN_REVIEW_DOCKET_NO_PUSH:-0}" = 1 ]; then
  mkdir -p "$DIR"; apply_operation "$DIR" || [ "$?" -eq 2 ]; save_reconcile_cursor; exit 0
fi
# A journal CAS can legitimately span more than the repository-wide 10-second
# soft-skip default. Queue producers must wait for the preceding clerk
# transaction instead of dropping intake merely because its push is in flight.
GARDEN_REPO_LOCK_WAIT="${GARDEN_REVIEW_DOCKET_LOCK_WAIT:-180}"
# This clone is deliberately shared by all intake producers on a host. Serialize
# before ensure_clone: its internal order is clone-lock then repository-lock,
# while a peer already past it owns the repository lock and sync_clone next wants
# the clone lock. Entering concurrently would deadlock those opposite orders.
transaction_lock="${GARDEN_REVIEW_DOCKET_TRANSACTION_LOCK:-$GARDEN_STATE/review-docket/transaction.lock}"
mkdir -p "$(dirname "$transaction_lock")"
exec {transaction_fd}>"$transaction_lock"
flock -w "$GARDEN_REPO_LOCK_WAIT" "$transaction_fd" \
  || die "timed out waiting for the review-docket transaction lock"
ensure_clone "$DIR"
garden_repo_lock "$DIR" exclusive || die "could not lock the shared review-docket journal clone"
DOCKET_LOCKED=1
for attempt in $(seq 1 "$GARDEN_REVIEW_DOCKET_ATTEMPTS"); do
  sync_clone "$DIR"
  rc=0; apply_operation "$DIR" || rc=$?
  [ "$rc" -eq 2 ] && { log "$operation is an idempotent no-op"; save_reconcile_cursor; exit 0; }
  [ "$rc" -eq 0 ] || exit "$rc"
  git -C "$DIR" add -A review-docket PRIORITIES.md priorities-archive
  [ ! -f "$DIR/README.md" ] || git -C "$DIR" add README.md
  rc=0; commit_and_push "$DIR" "review-docket: $operation" || rc=$?
  [ "$rc" -eq 0 ] && { log "$operation committed with regenerated PRIORITIES.md"; save_reconcile_cursor; exit 0; }
  [ "$rc" -eq 2 ] && { save_reconcile_cursor; exit 0; }
  backoff "$attempt"
done
die "review docket $operation could not win the journal CAS"
