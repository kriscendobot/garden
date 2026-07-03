#!/bin/bash
# review-miss-record.sh — the deterministic writer for the review-miss store on
# journal2 (the second loop of the review-retrospective double loop, design
# designs/review-retrospective-loop.md). The LLM (the prosecutor role, skill
# skills/review-retrospective/SKILL.md) DECIDES — the verdict, the category, the
# cluster to join, the threshold call — and this script WRITES: the CAS push
# loop, the idempotency pre-check, the member append, the count bump, the prs
# set, and the cluster status guard. Keeping the mechanical half in plain code
# means two concurrent retros across hosts never corrupt the store.
#
# Store layout (journal2 top level):
#   review-misses/
#     README.md                    # abstract + layout (seeded here on first write)
#     misses/<primary-base>.md     # one confirmed miss per file
#     dismissed/<primary-base>.md  # one recorded non-miss per file
#     clusters/<slug>.md           # one pattern per file: members, count, status
#
# Subcommands:
#   record <record-file>
#       Place a prosecutor-authored miss/dismissal record (verbatim, bot-authored)
#       and, for a `miss`, join or mint its cluster. ONE CAS transaction. Reads
#       these frontmatter fields from <record-file>:
#         kind: review-miss | review-miss-dismissed   (informational)
#         primary_job: <base>       REQUIRED — the store key (idempotency)
#         verdict: miss | not-a-miss  REQUIRED
#         category: <cat>           REQUIRED
#         pr: <n>                    REQUIRED for a miss (the distinct-PR count)
#         cluster: <slug>           REQUIRED for a miss (join target / mint slug)
#         cluster_pattern: <line>   used ONLY when minting a new cluster
#       Idempotent on primary_job: if misses/<base>.md OR dismissed/<base>.md
#       already exists the call is a no-op success. On success prints a
#       machine-readable summary line the prosecutor parses:
#         recorded=<path> verdict=<v> [cluster=<slug> count=<n> status=<s> prs=<a,b> recurrence=<0|1>]
#
#   cluster-status <slug> <status> [--job B] [--rationale-file F] [--improved-by TEXT]
#       Advance a cluster's lifecycle (open|improvement-dispatched|closed) and set
#       the dispatch/closure bookkeeping fields. ONE CAS transaction. The cluster
#       must exist. Guards a double-dispatch: setting improvement-dispatched on a
#       cluster already past `open` is a no-op success (prints `already <status>`).
#
# Exit codes: 0 success (including idempotent no-op); non-zero on a usage or
# store-integrity error.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="review-miss"

STORE="review-misses"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"; }

# --- frontmatter readers -----------------------------------------------------
# Scalar field from a leading YAML frontmatter block (reuses plan_field's shape).
fm() { plan_field "$1" "$2"; }

# A YAML flow list `key: [a, b, c]` → space-separated tokens.
fm_flow_list() {  # fm_flow_list <file> <key>
  sed -n "s/^$2:[[:space:]]*\[\(.*\)\][[:space:]]*$/\1/p" "$1" 2>/dev/null | head -1 \
    | tr ',' ' ' | tr -s ' '
}

# A YAML block list under `key:` (subsequent `  - item` lines) → space-separated.
fm_block_list() {  # fm_block_list <file> <key>
  awk -v k="$2" '
    /^---[[:space:]]*$/ { fence++; next }
    fence==1 && $0 ~ "^"k":[[:space:]]*$" { grab=1; next }
    fence==1 && grab && /^[[:space:]]+-[[:space:]]*/ { sub(/^[[:space:]]+-[[:space:]]*/,""); print; next }
    fence==1 && grab && /^[^[:space:]]/ { grab=0 }
  ' "$1" 2>/dev/null | tr '\n' ' ' | tr -s ' '
}

# The body (everything after the second `---` fence).
fm_body() {  # fm_body <file>
  awk '/^---[[:space:]]*$/{f++; next} f>=2{print}' "$1" 2>/dev/null
}

# Add <item> to a space-separated set (no-op if present); prints the new set.
set_add() {  # set_add <set> <item>
  local s=" $1 "; case "$s" in *" $2 "*) printf '%s' "$1";; *) printf '%s' "${1:+$1 }$2";; esac
}

seed_readme() {  # seed_readme <clone-dir>
  local r="$1/$STORE/README.md"
  [ -e "$r" ] && return 0
  mkdir -p "$1/$STORE/misses" "$1/$STORE/dismissed" "$1/$STORE/clusters"
  cat > "$r" <<'EOF'
# review-misses — the review-process miss store

The second loop of the review-retrospective double loop (design
`designs/review-retrospective-loop.md`, skill
`skills/review-retrospective/SKILL.md`). Machine-appended structured evidence,
written by the prosecutor role via `scripts/jobs/review-miss-record.sh`. This is
journal state (high-churn, CAS-appended by many concurrent retro jobs across
hosts), NOT curated `library/` prose.

## Layout

- `misses/<primary-base>.md` — one confirmed review-process miss per file, keyed
  on the primary job base for idempotency.
- `dismissed/<primary-base>.md` — one recorded non-miss (new direction, taste,
  scope) per file. As durable as a miss so a comment is never re-litigated.
- `clusters/<slug>.md` — one recurring pattern per file: members, count, prs,
  status (`open` | `improvement-dispatched` | `closed`).

## Bodies are bot-authored paraphrase, never the raw comment

The comment is untrusted input. Every record body is the prosecutor's own
paraphrase plus a `comment_url` to re-fetch the verbatim text if needed, so
untrusted prose never propagates through the learning loop.

## Failure-category taxonomy

See `skills/review-retrospective/SKILL.md` § Taxonomy. Each category maps to the
review surface (juror seat, gate, or standing instruction) that should have
caught it; a new category is minted by adding a row to that table in the same
push that first uses it.
EOF
  git -C "$1" add "$STORE/README.md"
}

# --- record ------------------------------------------------------------------
cmd_record() {
  local rec="${1:?usage: review-miss-record.sh record <record-file>}"
  [ -f "$rec" ] || die "record file '$rec' is not readable"
  local base verdict category pr cluster pattern
  base="$(fm "$rec" primary_job)"
  verdict="$(fm "$rec" verdict)"
  category="$(fm "$rec" category)"
  pr="$(fm "$rec" pr)"
  cluster="$(fm "$rec" cluster)"
  pattern="$(fm "$rec" cluster_pattern)"
  [ -n "$base" ] || die "record file is missing required frontmatter: primary_job"
  case "$base" in */*|.*|-*) die "illegal primary_job '$base'";; esac
  case "$verdict" in miss|not-a-miss) : ;; *) die "verdict must be 'miss' or 'not-a-miss' (got '$verdict')";; esac
  [ -n "$category" ] || die "record file is missing required frontmatter: category"
  if [ "$verdict" = miss ]; then
    [ -n "$cluster" ] || die "a miss must name its cluster (frontmatter: cluster)"
    [ -n "$pr" ]      || die "a miss must name its pr (frontmatter: pr)"
    case "$cluster" in */*|.*|-*) die "illegal cluster slug '$cluster'";; esac
  fi
  local content; content="$(cat "$rec")"

  ensure_clone "$DIR"
  local attempt
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$DIR"
    # Idempotency: a prior tick or a requeued retro already recorded this primary.
    if [ -e "$DIR/$STORE/misses/$base.md" ]; then
      log "review-miss for '$base' already recorded (miss); idempotent no-op"
      printf 'recorded=%s verdict=already\n' "$STORE/misses/$base.md"; return 0
    fi
    if [ -e "$DIR/$STORE/dismissed/$base.md" ]; then
      log "review-miss for '$base' already recorded (dismissed); idempotent no-op"
      printf 'recorded=%s verdict=already\n' "$STORE/dismissed/$base.md"; return 0
    fi
    seed_readme "$DIR"

    local dest recurrence=0 count status prs
    if [ "$verdict" = not-a-miss ]; then
      dest="$STORE/dismissed/$base.md"
      mkdir -p "$DIR/$STORE/dismissed"
      printf '%s\n' "$content" > "$DIR/$dest"
      git -C "$DIR" add "$dest"
    else
      dest="$STORE/misses/$base.md"
      mkdir -p "$DIR/$STORE/misses" "$DIR/$STORE/clusters"
      printf '%s\n' "$content" > "$DIR/$dest"
      git -C "$DIR" add "$dest"
      # Join or mint the cluster.
      local cf="$DIR/$STORE/clusters/$cluster.md"
      if [ -e "$cf" ]; then
        local members oldstatus
        members="$(fm_block_list "$cf" members)"
        prs="$(fm_flow_list "$cf" prs)"
        oldstatus="$(fm "$cf" status)"
        members="$(set_add "$members" "$base")"
        prs="$(set_add "$prs" "$pr")"
        status="$oldstatus"
        # Recurrence: a new miss joining a CLOSED cluster reopens it (the
        # improvement did not take — the prosecutor escalates to the maintainer).
        if [ "$oldstatus" = closed ]; then status=open; recurrence=1; fi
        count="$(printf '%s\n' $members | grep -c .)"
        write_cluster "$cf" "$cluster" "$category" "$status" "$count" "$members" "$prs" \
          "$(fm "$cf" improvement_job)" "$(fm "$cf" improved_by)" "$(fm_body "$cf")"
      else
        status=open; count=1; members="$base"; prs="$pr"
        write_cluster "$cf" "$cluster" "$category" "$status" "$count" "$members" "$prs" \
          "" "" "${pattern:-A recurring $category the review keeps missing.}"
      fi
      git -C "$DIR" add "$STORE/clusters/$cluster.md"
    fi

    if commit_and_push "$DIR" "review-miss($base) $verdict${cluster:+ → cluster $cluster} by $GARDEN"; then
      if [ "$verdict" = miss ]; then
        log "recorded review-miss '$base' → cluster '$cluster' (count=$count status=$status recurrence=$recurrence)"
        printf 'recorded=%s verdict=miss cluster=%s count=%s status=%s prs=%s recurrence=%s\n' \
          "$dest" "$cluster" "$count" "$status" "$(printf '%s' "$prs" | tr ' ' ',')" "$recurrence"
      else
        log "recorded review-miss dismissal '$base' (not-a-miss)"
        printf 'recorded=%s verdict=not-a-miss\n' "$dest"
      fi
      return 0
    fi
    log "review-miss record of '$base' lost a push race (attempt $attempt); re-syncing"
    backoff "$attempt"
  done
  die "could not record review-miss '$base' after retries"
}

# write_cluster <path> <slug> <cat> <status> <count> <members-set> <prs-set> <job> <improved-by> <body>
write_cluster() {
  local path="$1" slug="$2" cat="$3" status="$4" count="$5" members="$6" prs="$7" job="$8" improved="$9" body="${10}"
  {
    printf -- '---\n'
    printf 'slug: %s\n' "$slug"
    printf 'category: %s\n' "$cat"
    printf 'status: %s\n' "$status"
    printf 'count: %s\n' "$count"
    printf 'members:\n'
    local m; for m in $members; do printf '  - %s\n' "$m"; done
    printf 'prs: [%s]\n' "$(printf '%s' "$prs" | sed 's/ /, /g')"
    [ -n "$job" ]      && printf 'improvement_job: %s\n' "$job"
    [ -n "$improved" ] && printf 'improved_by: %s\n' "$improved"
    printf -- '---\n\n'
    printf '%s\n' "$body"
  } > "$path"
}

# --- cluster-status ----------------------------------------------------------
cmd_cluster_status() {
  local slug="${1:?usage: review-miss-record.sh cluster-status <slug> <status> [...]}"
  local newstatus="${2:?usage: review-miss-record.sh cluster-status <slug> <status> [...]}"
  shift 2 || true
  case "$slug" in */*|.*|-*) die "illegal cluster slug '$slug'";; esac
  case "$newstatus" in open|improvement-dispatched|closed) : ;; *) die "illegal status '$newstatus'";; esac
  local job="" rationale_file="" improved=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --job)           job="${2:?--job needs a value}"; shift 2;;
      --rationale-file) rationale_file="${2:?--rationale-file needs a value}"; shift 2;;
      --improved-by)   improved="${2:?--improved-by needs a value}"; shift 2;;
      *) die "unknown option: '$1'";;
    esac
  done
  [ -z "$rationale_file" ] || [ -f "$rationale_file" ] || die "rationale file '$rationale_file' is not readable"

  ensure_clone "$DIR"
  local attempt
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$DIR"
    local cf="$DIR/$STORE/clusters/$slug.md"
    [ -e "$cf" ] || die "cluster '$slug' does not exist ($STORE/clusters/$slug.md)"
    local cur; cur="$(fm "$cf" status)"
    # Double-dispatch guard: only `open` → `improvement-dispatched` advances.
    if [ "$newstatus" = improvement-dispatched ] && [ "$cur" != open ]; then
      log "cluster '$slug' already $cur; not re-dispatching (idempotent)"
      printf 'already %s\n' "$cur"; return 0
    fi
    local cat count members prs body oldjob rationale
    cat="$(fm "$cf" category)"; count="$(fm "$cf" count)"
    members="$(fm_block_list "$cf" members)"; prs="$(fm_flow_list "$cf" prs)"
    body="$(fm_body "$cf")"; oldjob="$(fm "$cf" improvement_job)"
    [ -n "$job" ] || job="$oldjob"
    [ -z "$improved" ] && improved="$(fm "$cf" improved_by)"
    # A rationale file appends a `threshold_rationale:` folded scalar to the body.
    if [ -n "$rationale_file" ]; then
      rationale="$(cat "$rationale_file")"
      body="$body"$'\n\n'"**Threshold rationale:** $rationale"
    fi
    write_cluster "$cf" "$slug" "$cat" "$newstatus" "$count" "$members" "$prs" "$job" "$improved" "$body"
    git -C "$DIR" add "$STORE/clusters/$slug.md"
    if commit_and_push "$DIR" "review-cluster($slug) → $newstatus by $GARDEN"; then
      log "cluster '$slug' status → $newstatus${job:+ (job $job)}"
      printf 'status=%s\n' "$newstatus"; return 0
    fi
    log "cluster-status of '$slug' lost a push race (attempt $attempt); re-syncing"
    backoff "$attempt"
  done
  die "could not set cluster '$slug' status after retries"
}

case "${1:-}" in
  -h|--help)       usage; exit 0;;
  record)          shift; cmd_record "$@";;
  cluster-status)  shift; cmd_cluster_status "$@";;
  '')              usage; exit 2;;
  *)               die "unknown subcommand: '$1' (record | cluster-status; --help for usage)";;
esac
