#!/bin/bash
# comment-latency-watch.sh — reactji-anchored comment-to-ack liveness checker.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=comment-classify.sh
source "$HERE/comment-classify.sh"

export GARDEN_TAG=comment-latency-watch
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_COMMENT_LATENCY_REACTIONS:=$HERE/handlers/comment-reactions-gh.sh}"
: "${GARDEN_COMMENT_LATENCY_NOTICE:=$HERE/watchdog-notice.sh}"
: "${GARDEN_COMMENT_LATENCY_STATE:=$GARDEN_STATE/comment-latency-watch}"
: "${GARDEN_COMMENT_LATENCY_LOOKBACK_SECS:=21600}"
: "${GARDEN_COMMENT_LATENCY_STUCK_SECS:=1200}"

mode="${1:-}"
report_only=0
[ "$mode" = --report-only ] && report_only=1

iso_epoch() { [ -n "${1:-}" ] && date -u -d "$1" +%s 2>/dev/null || printf '0\n'; }
field() { sed -n "s/^$2: *//p" "$1" 2>/dev/null | head -1 || true; }

classify_state() { # age latency-or-dash cadence hb-outcome hb-age outcome-age drained
  local age="$1" latency="$2" cadence="$3" outcome="$4"
  local hb_age="$5" outcome_age="$6" drained="$7"
  local on_time=$(( 2 * cadence + 60 )) never=$(( 10 * cadence ))
  [ "$never" -ge 900 ] || never=900
  if [ "$latency" != - ]; then
    [ "$latency" -le "$on_time" ] && printf 'acked-on-time\n' || printf 'acked-late\n'
    return
  fi
  [ "$age" -gt "$never" ] || { printf 'pending\n'; return; }
  [ "$drained" = 1 ] && { printf 'muted\n'; return; }
  case "$outcome" in
    drained|not-main-host) printf 'muted\n' ;;
    cooldown|offline-journal)
      if [ "$outcome_age" -le "$GARDEN_COMMENT_LATENCY_STUCK_SECS" ]; then
        printf 'muted\n'
      else
        printf 'never-acked:dead\n'
      fi
      ;;
    full-poll)
      if [ "$hb_age" -gt $(( 3 * cadence )) ]; then
        printf 'never-acked:dead\n'
      else
        printf 'never-acked:blind\n'
      fi
      ;;
    *) printf 'never-acked:dead\n' ;;
  esac
}

if [ "$mode" = --classify ]; then
  shift
  classify_state "$@"
  exit 0
fi

if [ "$report_only" -eq 0 ]; then
  mkdir -p "$GARDEN_COMMENT_LATENCY_STATE"/{resolved,samples,stats,alerts}
  watcher_heartbeat_write "$GARDEN_COMMENT_LATENCY_STATE/heartbeat" full-poll
fi

JOURNAL_VIEW="$GARDEN_COMMENT_LATENCY_STATE/journal"
load_journal() {
  ensure_clone "$JOURNAL_VIEW"
  sync_clone "$JOURNAL_VIEW"
}

declare -a TRUSTED=() MAINTAINERS=()
declare -A ORG_TRUST=() OPEN_STATE=()
load_names() { # ref:path array-name
  local path="$1" line
  local -n dest_ref="$2"
  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(printf '%s' "$line" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
    [ -n "$line" ] && dest_ref+=("$line")
  done < <(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:$path" 2>/dev/null || true)
}
name_in() { # login array values...
  local login="$1" value; shift
  login="$(printf '%s' "$login" | tr '[:upper:]' '[:lower:]')"
  for value in "$@"; do [ "$login" = "$value" ] && return 0; done
  return 1
}

comment_classify_armed() { return 0; } # the collector emits only armed sources
comment_classify_open() {
  local repo="$1" surface="$4" number="$5" key state
  [ "${GARDEN_COMMENT_LATENCY_ASSUME_OPEN:-0}" = 1 ] && return 0
  [ "$COMMENT_CLASSIFY_SOURCE" = issue-inbox ] && return 0
  case "$surface" in issue|issue-body|issue-comment) ;; *) return 0 ;; esac
  key="$repo#$number"
  if [ -n "${OPEN_STATE[$key]+x}" ]; then [ "${OPEN_STATE[$key]}" = open ]; return; fi
  state="$(gh_api_retry "repos/$repo/issues/$number" --jq .state 2>/dev/null || true)"
  OPEN_STATE[$key]="${state:-unknown}"
  [ "$state" = open ]
}
comment_classify_trusted() {
  local author="$3"
  if [ "$COMMENT_CLASSIFY_SOURCE" = issue-inbox ]; then
    name_in "$author" "${MAINTAINERS[@]}"
    return
  fi
  name_in "$author" "${TRUSTED[@]}" && return 0
  name_in "$author" "${MAINTAINERS[@]}" && return 0
  if [ -n "${ORG_TRUST[$author]+x}" ]; then [ "${ORG_TRUST[$author]}" = y ]; return; fi
  if "$HERE/handlers/mention-trust-gh.sh" "$author" >/dev/null 2>&1; then
    ORG_TRUST[$author]=y; return 0
  fi
  ORG_TRUST[$author]=n
  return 1
}

# Unified rows:
# created source cadence repo slug surface id number author url body
collect_sources() {
  local since="$1" p slug repo created surface id number author url body source_file armed pr_only
  if [ -n "${GARDEN_COMMENT_LATENCY_SOURCE:-}" ]; then
    if [ -n "${GARDEN_COMMENT_LATENCY_TRUSTED_FILE:-}" ]; then
      while IFS= read -r author; do
        author="${author%%#*}"; author="$(printf '%s' "$author" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
        [ -n "$author" ] && TRUSTED+=("$author")
      done < "$GARDEN_COMMENT_LATENCY_TRUSTED_FILE"
    fi
    if [ -n "${GARDEN_COMMENT_LATENCY_MAINTAINERS_FILE:-}" ]; then
      while IFS= read -r author; do
        author="${author%%#*}"; author="$(printf '%s' "$author" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
        [ -n "$author" ] && MAINTAINERS+=("$author")
      done < "$GARDEN_COMMENT_LATENCY_MAINTAINERS_FILE"
    fi
    "$GARDEN_COMMENT_LATENCY_SOURCE" "$since"
    return
  fi
  load_journal
  load_names trusted-senders/allowlist TRUSTED
  load_names maintainers/allowlist MAINTAINERS
  while IFS= read -r p; do
    slug="${p#comment-repos/}"
    armed="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:$p" 2>/dev/null || true)"
    repo="$(printf '%s\n' "$armed" | sed -n 's/^repo: *//p' | head -1)"
    [ -n "$repo" ] || continue
    pr_only=0
    printf '%s\n' "$armed" | grep -Eqi '^[[:space:]]*surfaces:[[:space:]]*pr-only[[:space:]]*$' && pr_only=1
    ACTIVE_SLUGS[$slug]="$repo"
    source_file="$(mktemp)"
    if "$HERE/handlers/comment-source-gh.sh" "$repo" "$since" "$GARDEN_BOT_LOGIN" > "$source_file"; then
      while IFS=$'\t' read -r created surface id number author url body _review_id; do
        [ "$pr_only" -eq 1 ] && [ "$surface" = issue-comment ] && continue
        printf '%s\tcomment\t90\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
          "$created" "$repo" "$slug" "$surface" "$id" "$number" "$author" "$url" "$body"
      done < "$source_file"
    else
      log "WARN: latency source failed for $repo; heartbeat checks still run"
    fi
    rm -f "$source_file"
  done < <(git -C "$JOURNAL_VIEW" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" comment-repos 2>/dev/null)

  repo="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:config/garden-repo" 2>/dev/null \
    | sed -e 's/#.*//' -e 's/[[:space:]]//g' | head -1)"
  if [ -n "$repo" ]; then
    slug="$(printf '%s' "$repo" | tr '/' '-')"; source_file="$(mktemp)"
    ACTIVE_SLUGS[$slug]="$repo"
    if "$HERE/handlers/issue-source-gh.sh" "$repo" "$since" > "$source_file"; then
      while IFS=$'\t' read -r kind created id number author _submitter state _closed_by closed_at url body; do
        [ "$state" = open ] || { [ "$kind" = issue-comment ] && [ "$created" \> "$closed_at" ]; } || continue
        printf '%s\tissue-inbox\t120\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
          "$created" "$repo" "$slug" "$kind" "$id" "$number" "$author" "$url" "$body"
      done < "$source_file"
    fi
    rm -f "$source_file"
  fi

  source_file="$(mktemp)"
  if "$HERE/handlers/mention-source-gh.sh" "$since" "$GARDEN_BOT_LOGIN" > "$source_file"; then
    while IFS=$'\t' read -r created surface id repo number author url body; do
      slug="$(printf '%s' "$repo" | tr '/' '-')"
      printf '%s\tmention\t90\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$created" "$repo" "$slug" "$surface" "$id" "$number" "$author" "$url" "$body"
    done < "$source_file"
  fi
  rm -f "$source_file"
}

heartbeat_for() { # source slug
  case "$1" in
    comment) printf '%s/comment-watcher/heartbeat/%s\n' "$GARDEN_STATE" "$2" ;;
    issue-inbox) printf '%s/issue-inbox-watcher/heartbeat/garden\n' "$GARDEN_STATE" ;;
    mention) printf '%s/mention-watcher/heartbeat/github-wide\n' "$GARDEN_STATE" ;;
  esac
}

declare -A SEEN=() LATE=() BLIND=() DEAD=() ACTIVE_SLUGS=() REPORTED_REPO=()
muted_count=0
now="${GARDEN_COMMENT_LATENCY_NOW_EPOCH:-$(date -u +%s)}"
since="$(date -u -d "@$(( now - GARDEN_COMMENT_LATENCY_LOOKBACK_SECS ))" +%FT%TZ)"
rows="$(mktemp)"; trap 'rm -f "$rows"' EXIT
collect_sources "$since" > "$rows"

while IFS=$'\t' read -r created source cadence repo slug surface id number author url body; do
  [ -n "$created" ] || continue
  created_epoch="$(iso_epoch "$created")"; [ "$created_epoch" -gt 0 ] || continue
  age=$(( now - created_epoch )); [ "$age" -ge 0 ] || age=0
  [ "$age" -le "$GARDEN_COMMENT_LATENCY_LOOKBACK_SECS" ] || continue
  key="$repo|$surface|$id"
  [ -z "${SEEN[$key]+x}" ] || continue
  SEEN[$key]=1; ACTIVE_SLUGS[$slug]="$repo"
  bf="$(mktemp)"; printf '%s\n' "$body" > "$bf"
  COMMENT_CLASSIFY_SOURCE="$source"
  if ! comment_should_ack "$repo" "$slug" "$author" "$surface" "$number" "$bf"; then
    rm -f "$bf"; continue
  fi
  rm -f "$bf"

  resolved="$GARDEN_COMMENT_LATENCY_STATE/resolved/$slug/${source}-${surface}-${id}"
  if [ "$report_only" -eq 0 ] && [ -f "$resolved" ]; then continue; fi

  reaction="$("$GARDEN_COMMENT_LATENCY_REACTIONS" "$repo" "$surface" "$id" "$number" "$GARDEN_BOT_LOGIN" 2>/dev/null || true)"
  latency=-
  if [ -n "$reaction" ]; then
    reaction_epoch="$(iso_epoch "$reaction")"
    [ "$reaction_epoch" -gt 0 ] && latency=$(( reaction_epoch - created_epoch ))
  fi
  hb="$(heartbeat_for "$source" "$slug")"
  outcome="$(field "$hb" outcome)"; tick="$(field "$hb" last_tick_at)"; outcome_since="$(field "$hb" outcome_since)"
  tick_epoch="$(iso_epoch "$tick")"; since_epoch="$(iso_epoch "$outcome_since")"
  [ "$tick_epoch" -gt 0 ] && hb_age=$(( now - tick_epoch )) || hb_age=999999999
  [ "$since_epoch" -gt 0 ] && outcome_age=$(( now - since_epoch )) || outcome_age=999999999
  drained=0; fleet_draining && drained=1
  state="$(classify_state "$age" "$latency" "$cadence" "${outcome:-missing}" "$hb_age" "$outcome_age" "$drained")"

  if [ "$report_only" -eq 1 ]; then
    REPORTED_REPO[$repo]=1
    printf '%s\t%s\t%s\t%s\t%s\n' "$repo" "$state" "$latency" "$age" "$url"
    continue
  fi
  if [ "$latency" = - ]; then
    detail="$url (age=${age}s; heartbeat=${outcome:-missing})"
  else
    detail="$url (latency=${latency}s; heartbeat=${outcome:-missing})"
  fi
  case "$state" in
    acked-on-time|acked-late)
      mkdir -p "$(dirname "$resolved")" "$GARDEN_COMMENT_LATENCY_STATE/samples/$slug"
      printf 'state: %s\nlatency: %s\nreaction_created_at: %s\nurl: %s\n' \
        "$state" "$latency" "$reaction" "$url" > "$resolved"
      printf '%s %s\n' "$latency" "$reaction" > "$GARDEN_COMMENT_LATENCY_STATE/samples/$slug/${source}-${surface}-${id}"
      [ "$state" = acked-late ] && LATE[$slug]="${LATE[$slug]:-}$detail\n"
      ;;
    never-acked:blind) BLIND[$slug]="${BLIND[$slug]:-}$detail\n" ;;
    never-acked:dead) DEAD[$slug]="${DEAD[$slug]:-}$detail\n" ;;
    muted) muted_count=$(( muted_count + 1 )) ;;
  esac
done < "$rows"

if [ "$report_only" -eq 1 ]; then
  for slug in "${!ACTIVE_SLUGS[@]}"; do
    repo="${ACTIVE_SLUGS[$slug]}"
    [ -n "${REPORTED_REPO[$repo]+x}" ] || printf '%s\tno-samples\t-\t-\t-\n' "$repo"
  done
  exit 0
fi

# Quiet repositories still get liveness coverage from their per-tick heartbeat.
check_quiet_heartbeat() { # source slug repo cadence
  local source="$1" slug="$2" repo="$3" cadence="$4" hb outcome tick outcome_since
  local tick_epoch since_epoch hb_age outcome_age
  ACTIVE_SLUGS[$slug]="$repo"
  hb="$(heartbeat_for "$source" "$slug")"
  outcome="$(field "$hb" outcome)"; tick="$(field "$hb" last_tick_at)"; outcome_since="$(field "$hb" outcome_since)"
  tick_epoch="$(iso_epoch "$tick")"; since_epoch="$(iso_epoch "$outcome_since")"
  [ "$tick_epoch" -gt 0 ] && hb_age=$(( now - tick_epoch )) || hb_age=999999999
  [ "$since_epoch" -gt 0 ] && outcome_age=$(( now - since_epoch )) || outcome_age=999999999
  if ! fleet_draining; then
    if [ "$hb_age" -gt $(( 3 * cadence )) ] \
      || { { [ "$outcome" = cooldown ] || [ "$outcome" = offline-journal ]; } \
        && [ "$outcome_age" -gt "$GARDEN_COMMENT_LATENCY_STUCK_SECS" ]; }; then
      DEAD[$slug]="${DEAD[$slug]:-}watcher heartbeat (age=${hb_age}s outcome=${outcome:-missing})\n"
    fi
  fi
}

if [ -d "$JOURNAL_VIEW/.git" ]; then
  while IFS= read -r p; do
    slug="${p#comment-repos/}"
    repo="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:$p" 2>/dev/null | sed -n 's/^repo: *//p' | head -1)"
    check_quiet_heartbeat comment "$slug" "$repo" 90
  done < <(git -C "$JOURNAL_VIEW" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" comment-repos 2>/dev/null)
  repo="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:config/garden-repo" 2>/dev/null \
    | sed -e 's/#.*//' -e 's/[[:space:]]//g' | head -1)"
  if [ -n "$repo" ]; then
    slug="$(printf '%s' "$repo" | tr '/' '-')"
    check_quiet_heartbeat issue-inbox "$slug" "$repo" 120
  fi
  if [ -f "$(heartbeat_for mention mentions)" ]; then
    check_quiet_heartbeat mention mentions github-wide-mentions 90
  fi
fi

write_stats() {
  local slug="$1" repo="$2" sample_dir
  sample_dir="$GARDEN_COMMENT_LATENCY_STATE/samples/$slug"
  local values count p50i p95i p50 p95 last_ack sample sample_at sample_epoch
  [ -d "$sample_dir" ] || return 0
  for sample in "$sample_dir"/*; do
    [ -f "$sample" ] || continue
    sample_at="$(awk '{print $2}' "$sample" | head -1)"
    sample_epoch="$(iso_epoch "$sample_at")"
    [ "$sample_epoch" -ge $(( now - GARDEN_COMMENT_LATENCY_LOOKBACK_SECS )) ] || rm -f "$sample"
  done
  values="$(awk '{print $1}' "$sample_dir"/* 2>/dev/null | sort -n)"; count="$(printf '%s\n' "$values" | grep -c . || true)"
  [ "$count" -gt 0 ] || return 0
  p50i=$(( (count + 1) / 2 )); p95i=$(( (95 * count + 99) / 100 ))
  p50="$(printf '%s\n' "$values" | sed -n "${p50i}p")"; p95="$(printf '%s\n' "$values" | sed -n "${p95i}p")"
  last_ack="$(awk '{print $2}' "$sample_dir"/* 2>/dev/null | sort | tail -1)"
  {
    printf 'repo: %s\n' "$repo"; printf 'p50: %s\n' "$p50"; printf 'p95: %s\n' "$p95"
    printf 'sample_count: %s\n' "$count"; printf 'last_ack_at: %s\n' "$last_ack"
  } > "$GARDEN_COMMENT_LATENCY_STATE/stats/$slug"
}

notice_set() { # key body
  local key="$1" body="$2" marker bf
  marker="$GARDEN_COMMENT_LATENCY_STATE/alerts/$key"
  bf="$(mktemp)"; printf '%b' "$body" > "$bf"
  "$GARDEN_COMMENT_LATENCY_NOTICE" "$key" "$bf"
  : > "$marker"; rm -f "$bf"
}
notice_clear() {
  local key="$1" marker bf
  marker="$GARDEN_COMMENT_LATENCY_STATE/alerts/$key"
  [ -e "$marker" ] || return 0
  bf="$(mktemp)"; printf 'Comment acknowledgment condition cleared.\n' > "$bf"
  GARDEN_WATCHDOG_RECOVERY_IF_OPEN_ONLY=1 "$GARDEN_COMMENT_LATENCY_NOTICE" --recovered "$key" "$bf"
  rm -f "$marker" "$bf"
}

for slug in "${!ACTIVE_SLUGS[@]}"; do
  repo="${ACTIVE_SLUGS[$slug]}"; write_stats "$slug" "$repo"
  for class in latency blind dead; do
    case "$class" in latency) key="comment-ack-latency-$slug"; body="${LATE[$slug]:-}" ;;
      blind) key="comment-ack-blind-$slug"; body="${BLIND[$slug]:-}" ;;
      dead) key="comment-watcher-dead-$slug"; body="${DEAD[$slug]:-}" ;; esac
    if [ -n "$body" ]; then notice_set "$key" "Comment acknowledgment $class anomaly for $repo:\n$body"
    else notice_clear "$key"; fi
  done
done

if fleet_draining && [ "$muted_count" -gt 0 ]; then
  notice_set comment-ack-muted-drain "$muted_count should-ack comment(s) are awaiting acknowledgment while the fleet is deliberately drained. This is informational; the fleet is quiescent, not dead.\n"
else
  notice_clear comment-ack-muted-drain
fi
watcher_heartbeat_write "$GARDEN_COMMENT_LATENCY_STATE/heartbeat" full-poll
