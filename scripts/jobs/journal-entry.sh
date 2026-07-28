#!/bin/bash
# journal-entry.sh — post a progress/communication entry to the journal.
#
# Usage: journal-entry.sh [--allow-duplicate] <kind> [<body-file>]
#   <kind>  e.g. progress, claim, result, message
#   body    from <body-file>, else stdin, else a placeholder.
#   --allow-duplicate  post even if an identical entry landed moments ago
#                      (the legitimate identical-heartbeat case).
#
# Adopts the garden's practice of agents narrating their work into the journal.
# Entries live under entries/<YYYY>/<MM>/<DD>/<HHMMSSZ>-<kind>-<role>-<id>.md
# and are add-only, so a rejected push just re-syncs and retries.
#
# DUPLICATE SUPPRESSION. An agent that invokes this script twice for the same
# report writes two PERMANENT entries into an append-only journal (observed
# 2026-07-28: entries/2026/07/28/071837Z-result-botanist-e4bedc.md and
# 071905Z-result-botanist-71442a.md, byte-identical results for the same PR from
# the same host 38s apart). That is not the retry loop below — `rel` is computed
# once before it, so a retry after a landed push is a no-op commit; the differing
# stamps and random ids prove two separate invocations. Duplicates inflate every
# downstream consumer that scans new entries (the bulletin, the journalist, the
# mentor tick), and no amount of role-prompt discipline makes an agent reliably
# remember it already posted. So the guard lives HERE: before committing, scan
# the recently landed entries for one with the same kind, role and host whose
# BODY is byte-identical (frontmatter is excluded, so the differing `at:` stamp
# cannot defeat the match); within the suppression window that is a re-post, and
# we log `duplicate of <path>, not posting` and exit 0.
#
# Knobs:
#   GARDEN_ENTRY_DUP_WINDOW    suppression window in seconds (default 900 = 15m).
#                              0 disables suppression entirely.
#   GARDEN_ENTRY_DUP_MAX_DAYS  hard cap on how many UTC day directories the scan
#                              may walk back (default 2 — today and, for a post
#                              near midnight, yesterday), so an over-large window
#                              can never turn the scan into a full-journal walk.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="entry"

# Print the leading comment block as usage (mirrors land-journal-edit.sh).
usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"; }

# Strip the one recognized option out of the positionals BEFORE the kind guard,
# so `--allow-duplicate` may sit anywhere in argv and every OTHER dash-led token
# still hits the malformed-kind refusal below (the --help-as-kind class).
allow_duplicate=0
_args=()
for _a in "$@"; do
  case "$_a" in
    --allow-duplicate) allow_duplicate=1 ;;
    *) _args+=("$_a") ;;
  esac
done
set -- ${_args[@]+"${_args[@]}"}

# -h/--help is a query, not an entry: print usage and exit without writing or
# pushing. Before this guard, `journal-entry.sh --help` wrote a permanent
# append-only entry with `kind: --help` (the stray 115515Z---help-* entry).
case "${1:-}" in -h|--help) usage; exit 0 ;; esac

kind="${1:?usage: journal-entry.sh <kind> [body-file]}"
# Reject a malformed kind before the clone/push loop so a typo or stray flag
# fails fast instead of polluting the append-only journal. A real kind is a
# lowercase-letter-led token (progress, claim, result, message, dispatch, error,
# tick, worktree, …); anything dash-led, uppercase, or otherwise shaped is a
# mistake.
case "$kind" in
  [a-z]*) : ;;
  *) die "unknown kind: '$kind' (a kind is a lowercase-letter-led token like progress, result, message; try --help)" ;;
esac
case "$kind" in
  *[!a-z0-9_-]*) die "unknown kind: '$kind' (a kind may contain only lowercase letters, digits, '_' and '-')" ;;
esac

body_src="${2:-}"
role="${GARDEN_ROLE:-gardener}"

# Body source guard: a non-empty $2 that is not a readable file is almost always
# a mistake (an inline body string passed where a body-FILE path is expected).
# Without this, the script silently falls through to reading stdin — and with a
# non-tty stdin it blocks on `cat` forever (the inline-body stdin hang, the same
# unguarded-argv class as garden-harden-producer-body-read-hang). Fail fast.
if [ -n "$body_src" ] && [ ! -f "$body_src" ]; then
  die "body source '$body_src' is not a readable file (pass a body FILE path, or feed the body on stdin / leave \$2 empty for a placeholder)"
fi

if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ ! -t 0 ];                                then BODY="$(cat)"
else BODY="(no body)"; fi

day="$(date -u +%Y/%m/%d)"
stamp="$(date -u +%H%M%SZ)"
sid="$(od -An -N3 -tx1 /dev/urandom | tr -d ' \n')"
rel="entries/$day/${stamp}-${kind}-${role}-${sid}.md"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# Live-worktree refusal (the read-side guarantee, mirrored — same guard as
# land-journal-edit.sh). Entries MUST land through an isolated producer clone,
# never the shared $GARDEN_ROOT/journal read worktree: a write there dirties the
# tree the journal-worktree-keeper must keep clean and re-triggers its lossless
# self-heal (the stray `entries/…-result-gardener-*.md` this closes at the
# source). Even if a caller mis-sets GARDEN_PRODUCER_CLONE to the live tree,
# refuse loudly instead of silently dirtying it.
if [ -d "$GARDEN_ROOT/journal" ]; then
  live_abs="$(cd "$GARDEN_ROOT/journal" 2>/dev/null && pwd || printf '%s' "$GARDEN_ROOT/journal")"
  dir_abs="$(cd "$DIR" 2>/dev/null && pwd || printf '%s' "$DIR")"
  [ "$dir_abs" = "$live_abs" ] && die "refusing to write an entry into the live worktree ($live_abs); post through an isolated producer clone (set GARDEN_PRODUCER_CLONE), not the shared read tree"
fi

: "${GARDEN_ENTRY_DUP_WINDOW:=900}"
: "${GARDEN_ENTRY_DUP_MAX_DAYS:=2}"
# A non-numeric knob would blow up inside the arithmetic below, turning a
# mistyped env var into a lost entry. Refuse it up front instead.
case "$GARDEN_ENTRY_DUP_WINDOW$GARDEN_ENTRY_DUP_MAX_DAYS" in
  *[!0-9]*) die "GARDEN_ENTRY_DUP_WINDOW / GARDEN_ENTRY_DUP_MAX_DAYS must be non-negative integers (got '$GARDEN_ENTRY_DUP_WINDOW' / '$GARDEN_ENTRY_DUP_MAX_DAYS')" ;;
esac

# entry_matches <blob-text> — true when a landed entry is a re-post of the one we
# are about to write: same kind, role and host in the frontmatter, and a
# byte-identical BODY. The frontmatter is parsed and then DISCARDED, so the
# per-invocation `at:` stamp — the one field two invocations of the same report
# are guaranteed to disagree on — cannot defeat the match. Parsing in-shell
# (rather than piping to sed/awk) keeps the per-candidate cost to zero forks.
entry_matches() {
  local line n=0 fk="" fr="" fh="" body=""
  while IFS= read -r line; do
    if [ "$n" -lt 2 ]; then
      if [ "$line" = "---" ]; then n=$(( n + 1 )); continue; fi
      case "$line" in
        kind:*) [ -n "$fk" ] || { fk="${line#kind:}"; fk="${fk# }"; } ;;
        role:*) [ -n "$fr" ] || { fr="${line#role:}"; fr="${fr# }"; } ;;
        host:*) [ -n "$fh" ] || { fh="${line#host:}"; fh="${fh# }"; } ;;
      esac
      continue
    fi
    body+="$line"$'\n'
  done <<< "$1"
  [ "$fk" = "$kind" ] && [ "$fr" = "$role" ] && [ "$fh" = "$GARDEN" ] || return 1
  # `$(git cat-file …)` already stripped the blob's trailing newlines and so did
  # the `$(cat …)` that produced $BODY; drop the one newline the accumulation
  # above re-added so the two sides are comparable.
  [ "${body%$'\n'}" = "$BODY" ]
}

# find_duplicate — echo the journal-relative path of a recently LANDED entry that
# is a re-post of the one we are about to write, or return 1. It reads
# origin/$JOURNAL_BRANCH (not the clone's working tree), which the caller has
# just synced: only entries that actually reached the remote can suppress a post,
# so an untracked leftover from a run that died between writing its file and
# committing can never silently swallow a real entry. It therefore also sees an
# entry a peer process on this host landed a moment ago, and our OWN entry when a
# push landed but we misread it as failed.
#
# The scan is bounded twice over, so it stays O(a handful of blobs) even on a
# busy journal day: by DAY (at most GARDEN_ENTRY_DUP_MAX_DAYS directories) and,
# within a day, by the HHMMSSZ stamp already encoded in the FILENAME — candidates
# older than the cutoff are discarded without reading their blob. Comparing
# stamps as YYYYMMDDHHMMSS integers keeps that filter fork-free; it is sound
# because we only ever match entries from this host, so no cross-host clock skew
# enters into it.
find_duplicate() {
  local ref="origin/$JOURNAL_BRANCH" now cutoff days off dayfmt daykey p base fstamp ck
  now="$(date -u +%s)"
  cutoff="$(date -u -d "@$(( now - GARDEN_ENTRY_DUP_WINDOW ))" +%Y%m%d%H%M%S)"
  # Exactly the UTC days the window spans — usually just today, and yesterday
  # only for a post within one window of midnight (UTC days align with
  # epoch/86400). Then capped, so an over-large window cannot walk the journal.
  days=$(( now / 86400 - (now - GARDEN_ENTRY_DUP_WINDOW) / 86400 + 1 ))
  [ "$days" -gt "$GARDEN_ENTRY_DUP_MAX_DAYS" ] && days="$GARDEN_ENTRY_DUP_MAX_DAYS"
  for (( off = 0; off < days; off++ )); do
    dayfmt="$(date -u -d "@$(( now - off * 86400 ))" +%Y/%m/%d)"
    daykey="$(date -u -d "@$(( now - off * 86400 ))" +%Y%m%d)"
    # Reverse-sorted, so the path we report is the most recent duplicate. The
    # name filter narrows to this kind+role, but a kind or role containing '-'
    # could make it ambiguous (kind=a role=b-c vs kind=a-b role=c), so it is the
    # frontmatter check in entry_matches — not the filename — that decides.
    while IFS= read -r p; do
      base="${p##*/}"
      case "$base" in *-"$kind"-"$role"-*.md) : ;; *) continue ;; esac
      fstamp="${base%%-*}"; fstamp="${fstamp%Z}"
      case "$fstamp" in [0-9][0-9][0-9][0-9][0-9][0-9]) ck="$daykey$fstamp" ;; *) continue ;; esac
      [ $(( 10#$ck )) -lt $(( 10#$cutoff )) ] && continue
      entry_matches "$(git -C "$DIR" cat-file -p "$ref:$p" 2>/dev/null)" || continue
      printf '%s\n' "$p"
      return 0
    done < <(git -C "$DIR" ls-tree -r --name-only "$ref" -- "entries/$dayfmt" 2>/dev/null | sort -r)
  done
  return 1
}

ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  # Suppression runs on every attempt, against the just-synced tip: the freshest
  # possible view, and on a retry it also catches the silent-loss case where our
  # own previous push landed after we judged it failed.
  if [ "$allow_duplicate" -eq 0 ] && [ "$GARDEN_ENTRY_DUP_WINDOW" -gt 0 ]; then
    if dup="$(find_duplicate)"; then
      log "duplicate of $dup, not posting (identical ${kind}/${role} body within ${GARDEN_ENTRY_DUP_WINDOW}s; pass --allow-duplicate to force)"
      exit 0
    fi
  fi
  mkdir -p "$DIR/$(dirname "$rel")"
  {
    printf -- '---\nkind: %s\nrole: %s\nhost: %s\nat: %s\n---\n' \
      "$kind" "$role" "$GARDEN" "$(date -u +%FT%TZ)"
    printf '%s\n' "$BODY"
  } > "$DIR/$rel"
  git -C "$DIR" add "$rel"
  if commit_and_push "$DIR" "$kind: $role on $GARDEN"; then
    log "posted $rel"; exit 0
  fi
  backoff "$attempt"
done
die "could not post journal entry after retries"
