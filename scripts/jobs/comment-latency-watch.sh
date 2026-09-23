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
# Storm guard: more than this many distinct keys of ONE class active in one tick
# collapse into a single summary notice (a shared cause, not N independent faults).
: "${GARDEN_COMMENT_LATENCY_STORM_MAX:=5}"

mode="${1:-}"
report_only=0
[ "$mode" = --report-only ] && report_only=1

iso_epoch() { [ -n "${1:-}" ] && date -u -d "$1" +%s 2>/dev/null || printf '0\n'; }
field() { sed -n "s/^$2: *//p" "$1" 2>/dev/null | head -1 || true; }

# age_since <now> <epoch> — seconds elapsed, 999999999 for an unreadable stamp, and
# CLAMPED at 0: a heartbeat written after the checker sampled its clock (the
# collection pass takes a while) or under small clock skew is fresh, never dead
# (2026-09-23: "age=-13s" paged all 16 repos as dead).
age_since() {
  local n="$1" e="$2"
  [ "$e" -gt 0 ] || { printf '999999999\n'; return; }
  e=$(( n - e )); [ "$e" -ge 0 ] || e=0
  printf '%s\n' "$e"
}

# heartbeat_class <cadence> <outcome> <hb-age> <outcome-age>
#   ok | stale | stuck. `stale` (the timer is not firing) is the only "dead".
#   A cooldown/offline-journal outcome is muted per the design (§ 2, § 4) until it
#   persists past the stuck bound; then it is `stuck`, its own class: the shared
#   latch is host-wide, so it is alerted once per host, never as N dead repos.
heartbeat_class() {
  local cadence="$1" outcome="$2" hb_age="$3" outcome_age="$4"
  [ "$hb_age" -ge 0 ] || hb_age=0
  [ "$outcome_age" -ge 0 ] || outcome_age=0
  case "$outcome" in drained|not-main-host) printf 'ok\n'; return ;; esac
  [ "$hb_age" -le $(( 3 * cadence )) ] || { printf 'stale\n'; return; }
  case "$outcome" in
    cooldown|offline-journal)
      [ "$outcome_age" -le "$GARDEN_COMMENT_LATENCY_STUCK_SECS" ] && printf 'ok\n' || printf 'stuck\n' ;;
    *) printf 'ok\n' ;;
  esac
}

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
  case "$(heartbeat_class "$cadence" "$outcome" "$hb_age" "$outcome_age")" in
    stale) printf 'never-acked:dead\n'; return ;;
    stuck) printf 'never-acked:stuck\n'; return ;;
  esac
  case "$outcome" in
    drained|not-main-host|cooldown|offline-journal) printf 'muted\n' ;;
    full-poll) printf 'never-acked:blind\n' ;;
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

declare -A SEEN=() LATE=() BLIND=() DEAD=() STUCK=() ACTIVE_SLUGS=() REPORTED_REPO=()
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
  hb_age="$(age_since "$now" "$tick_epoch")"; outcome_age="$(age_since "$now" "$since_epoch")"
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
    never-acked:stuck) STUCK[$slug]="${STUCK[$slug]:-}$detail\n" ;;
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
# The heartbeat pass re-reads the clock: the collection pass above can run for a
# minute, and heartbeats written meanwhile must not age against a stale `now`.
hb_now="${GARDEN_COMMENT_LATENCY_NOW_EPOCH:-$(date -u +%s)}"
check_quiet_heartbeat() { # source slug repo cadence
  local source="$1" slug="$2" repo="$3" cadence="$4" hb outcome tick outcome_since
  local tick_epoch since_epoch hb_age outcome_age
  ACTIVE_SLUGS[$slug]="$repo"
  hb="$(heartbeat_for "$source" "$slug")"
  outcome="$(field "$hb" outcome)"; tick="$(field "$hb" last_tick_at)"; outcome_since="$(field "$hb" outcome_since)"
  tick_epoch="$(iso_epoch "$tick")"; since_epoch="$(iso_epoch "$outcome_since")"
  hb_age="$(age_since "$hb_now" "$tick_epoch")"; outcome_age="$(age_since "$hb_now" "$since_epoch")"
  fleet_draining && return 0
  case "$(heartbeat_class "$cadence" "${outcome:-missing}" "$hb_age" "$outcome_age")" in
    stale) DEAD[$slug]="${DEAD[$slug]:-}watcher heartbeat stale (age=${hb_age}s > $(( 3 * cadence ))s; outcome=${outcome:-missing})\n" ;;
    stuck) STUCK[$slug]="${STUCK[$slug]:-}watcher ticking but ${outcome} for ${outcome_age}s (since ${outcome_since:-?})\n" ;;
  esac
}

# Armed sources for the quiet pass: "source<TAB>slug<TAB>repo<TAB>cadence" rows.
# GARDEN_COMMENT_LATENCY_ARMED (a file of such rows) is the test seam.
armed_sources() {
  local p slug repo
  if [ -n "${GARDEN_COMMENT_LATENCY_ARMED:-}" ]; then cat "$GARDEN_COMMENT_LATENCY_ARMED"; return; fi
  [ -d "$JOURNAL_VIEW/.git" ] || return 0
  while IFS= read -r p; do
    slug="${p#comment-repos/}"
    repo="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:$p" 2>/dev/null | sed -n 's/^repo: *//p' | head -1)"
    printf 'comment\t%s\t%s\t90\n' "$slug" "$repo"
  done < <(git -C "$JOURNAL_VIEW" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" comment-repos 2>/dev/null)
  repo="$(git -C "$JOURNAL_VIEW" show "origin/$JOURNAL_BRANCH:config/garden-repo" 2>/dev/null \
    | sed -e 's/#.*//' -e 's/[[:space:]]//g' | head -1)"
  if [ -n "$repo" ]; then
    printf 'issue-inbox\t%s\t%s\t120\n' "$(printf '%s' "$repo" | tr '/' '-')" "$repo"
  fi
  if [ -f "$(heartbeat_for mention mentions)" ]; then
    printf 'mention\tmentions\tgithub-wide-mentions\t90\n'
  fi
}
while IFS=$'\t' read -r a_source a_slug a_repo a_cadence; do
  [ -n "$a_slug" ] || continue
  check_quiet_heartbeat "$a_source" "$a_slug" "$a_repo" "$a_cadence"
done < <(armed_sources)

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

# Notice delivery is best-effort: watchdog-notice.sh pushes to the journal, and a
# journal/push outage must not abort the tick (set -e) before the liveness
# heartbeat below is written, or systemd restart-loops this service. A failed
# delivery is logged and the alert marker is kept so the next tick retries: a
# failed open still records the marker (a later clear is a no-op for a notice
# that never opened, per RECOVERY_IF_OPEN_ONLY), and a failed clear leaves it.
NOTICE_FAILURES=0
notice_set() { # key body
  local key="$1" body="$2" marker bf
  marker="$GARDEN_COMMENT_LATENCY_STATE/alerts/$key"
  bf="$(mktemp)"; printf '%b' "$body" > "$bf"
  if ! "$GARDEN_COMMENT_LATENCY_NOTICE" "$key" "$bf"; then
    log "WARN: watchdog notice for $key failed; will retry next tick"
    NOTICE_FAILURES=$(( NOTICE_FAILURES + 1 ))
  fi
  : > "$marker"; rm -f "$bf"
}
notice_clear() {
  local key="$1" marker bf
  marker="$GARDEN_COMMENT_LATENCY_STATE/alerts/$key"
  [ -e "$marker" ] || return 0
  bf="$(mktemp)"; printf 'Comment acknowledgment condition cleared.\n' > "$bf"
  if GARDEN_WATCHDOG_RECOVERY_IF_OPEN_ONLY=1 "$GARDEN_COMMENT_LATENCY_NOTICE" --recovered "$key" "$bf"; then
    rm -f "$marker"
  else
    log "WARN: watchdog recovery notice for $key failed; alert state kept for retry"
    NOTICE_FAILURES=$(( NOTICE_FAILURES + 1 ))
  fi
  rm -f "$bf"
}

# Per-repo classes, with the storm guard: when more than STORM_MAX repos carry the
# same class in one tick, ONE summary notice replaces them. Individual keys of a
# storming class are left as they are (neither opened nor falsely "recovered");
# individual keys whose condition cleared still close normally.
declare -A CLASS_COUNT=()
for slug in "${!ACTIVE_SLUGS[@]}"; do
  [ -n "${LATE[$slug]:-}" ] && CLASS_COUNT[latency]=$(( ${CLASS_COUNT[latency]:-0} + 1 ))
  [ -n "${BLIND[$slug]:-}" ] && CLASS_COUNT[blind]=$(( ${CLASS_COUNT[blind]:-0} + 1 ))
  [ -n "${DEAD[$slug]:-}" ] && CLASS_COUNT[dead]=$(( ${CLASS_COUNT[dead]:-0} + 1 ))
done
declare -A STORM_BODY=()
for slug in "${!ACTIVE_SLUGS[@]}"; do
  repo="${ACTIVE_SLUGS[$slug]}"; write_stats "$slug" "$repo"
  for class in latency blind dead; do
    case "$class" in latency) key="comment-ack-latency-$slug"; body="${LATE[$slug]:-}" ;;
      blind) key="comment-ack-blind-$slug"; body="${BLIND[$slug]:-}" ;;
      dead) key="comment-watcher-dead-$slug"; body="${DEAD[$slug]:-}" ;; esac
    if [ -n "$body" ]; then
      if [ "${CLASS_COUNT[$class]:-0}" -gt "$GARDEN_COMMENT_LATENCY_STORM_MAX" ]; then
        STORM_BODY[$class]="${STORM_BODY[$class]:-}- $repo: ${body%%\\n*}\n"
      else
        notice_set "$key" "Comment acknowledgment $class anomaly for $repo:\n$body"
      fi
    else notice_clear "$key"; fi
  done
done
for class in latency blind dead; do
  if [ -n "${STORM_BODY[$class]:-}" ]; then
    notice_set "comment-latency-storm-$class" "Comment acknowledgment $class anomaly on ${CLASS_COUNT[$class]} repos at once on ${GARDEN:-this host} (storm guard > $GARDEN_COMMENT_LATENCY_STORM_MAX; one shared cause is likelier than ${CLASS_COUNT[$class]} independent faults):\n${STORM_BODY[$class]}"
  else
    notice_clear "comment-latency-storm-$class"
  fi
done

# A stuck cooldown/offline-journal outcome is a HOST-level condition: both latches
# (gh-api cooldown, journal-outage cooldown) are shared by every watcher on the
# host, so N wedged repos are one fault. Alert it once, naming the latch.
if [ "${#STUCK[@]}" -gt 0 ]; then
  stuck_body=""
  for slug in "${!STUCK[@]}"; do stuck_body="$stuck_body- ${ACTIVE_SLUGS[$slug]:-$slug}: ${STUCK[$slug]}"; done
  latch=""
  if [ -f "${GARDEN_API_COOLDOWN_MARKER:-}" ]; then
    latch="gh-api cooldown marker: expiry=$(sed -n 1p "$GARDEN_API_COOLDOWN_MARKER" 2>/dev/null) set-by=$(sed -n 2p "$GARDEN_API_COOLDOWN_MARKER" 2>/dev/null)\n"
  fi
  # The GraphQL-only latch no longer holds the REST comment watchers, but name it
  # when present: a stuck host-wide latch next to it is the pre-split signature.
  if [ -f "${GARDEN_API_COOLDOWN_GRAPHQL_MARKER:-}" ]; then
    latch="${latch}gh-api GraphQL-only marker: expiry=$(sed -n 1p "$GARDEN_API_COOLDOWN_GRAPHQL_MARKER" 2>/dev/null) set-by=$(sed -n 2p "$GARDEN_API_COOLDOWN_GRAPHQL_MARKER" 2>/dev/null)\n"
  fi
  if [ -f "${GARDEN_JOURNAL_OUTAGE_MARKER:-}" ]; then
    latch="${latch}journal-outage marker: $(head -2 "$GARDEN_JOURNAL_OUTAGE_MARKER" 2>/dev/null | tr '\n' ' ')\n"
  fi
  notice_set comment-watcher-stuck-cooldown-host "Comment watchers on ${GARDEN:-this host} are ticking but have been held in a shared cooldown/outage latch longer than ${GARDEN_COMMENT_LATENCY_STUCK_SECS}s on ${#STUCK[@]} source(s); they post no acknowledgments while it holds.\n${latch}${stuck_body}"
else
  notice_clear comment-watcher-stuck-cooldown-host
fi

if fleet_draining && [ "$muted_count" -gt 0 ]; then
  notice_set comment-ack-muted-drain "$muted_count should-ack comment(s) are awaiting acknowledgment while the fleet is deliberately drained. This is informational; the fleet is quiescent, not dead.\n"
else
  notice_clear comment-ack-muted-drain
fi
watcher_heartbeat_write "$GARDEN_COMMENT_LATENCY_STATE/heartbeat" full-poll
[ "$NOTICE_FAILURES" -eq 0 ] || log "WARN: $NOTICE_FAILURES watchdog notice delivery failure(s) this tick; heartbeat written, retrying next tick"
