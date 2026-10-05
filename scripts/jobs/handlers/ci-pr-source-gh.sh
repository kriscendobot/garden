#!/bin/bash
# ci-pr-source-gh.sh — default open-PR source for ci-watcher.sh.
#
# Invoked as: ci-pr-source-gh.sh <owner/name> [<bot-login>]
#
# Emits one TSV line per OPEN pull request on the repo:
#
#   pr_number  author_login  head_repo_full_name  updated_at  title
#
# The watcher applies the author==bot and head-branch-pushable gates itself (kept
# in the watcher, not here, so the test exercises them directly against a fixture
# of mixed-author PRs). This handler only enumerates.
#
# The trailing `title` column is what lets the dependabot-watcher's supersession
# preflight know WHICH package a bump PR moves (`Bump <pkg> from <a> to <b>`) so
# two PRs on the same dependency can be reconciled before either buys a full
# review. It is LAST on the line on purpose: a consumer that only wants the first
# four columns keeps working unchanged, and jq's `@tsv` escapes any embedded tab
# or newline (to a literal `\t` / `\n`), so the title can never split a field or
# forge an extra record no matter what a PR author writes.
#
# AUTHORITATIVE enumeration, never a default page cap. `gh pr list` (no --limit)
# returns only the 30-most-recent open PRs via the search API — the #284 blindness
# where an older open PR is silently dropped from surveillance. We use the paginated
# REST list (`repos/<repo>/pulls?state=open --paginate`), which returns EVERY open
# PR. The result is small in practice (the watcher only acts on the bot's own open
# PRs), so no activity bound is needed; enumerating all open PRs each tick is cheap
# and lets the watcher's own idempotency (post-job basename) keep re-ticks a no-op.
#
# Monitoring safety: this handler reads only PR metadata (number, author, head repo,
# timestamp, title) — NEVER a PR body or comment — and none of it is fed to an LLM
# by this handler's consumers. The `title` column IS author-controlled text, so the
# consumer's contract is strict: a title may be MATCHED against a fixed pattern, and
# only the pattern's captured fields — a package name and two version strings, each
# re-validated against a narrow charset — may reach a job body. A title is never
# echoed verbatim and never reaches `claude -p`. Under that contract the watchers
# stay injection-safe by construction (see dependabot-watcher.sh § Monitoring safety
# and its `parse_bump_title`). Both watchers are still gated to the cleared
# comment-repos/ set for defence in depth (see ci-watcher.sh header).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary; a structural gh failure surfaces its stderr and exits
# nonzero so the watcher never mistakes a broken enumeration for "no open PRs".
# Every page must parse as a JSON array and at least one page must arrive; anything
# else is an incomplete enumeration and fails loud the same way.
#
# SHARED SNAPSHOT CACHE. The ci-, dependabot-, dependabotany-, approval- and audit
# consumers each enumerate the SAME complete open-PR list on their own timers; at
# 2026-10-05T03:54:21Z the ci- and dependabot-watcher enumerations both hit GitHub's
# primary quota for endojs/endo-but-for-bots. So the enumeration is single-flighted
# per repository behind an flock and its rendered TSV is kept for a short window
# (GARDEN_CI_PR_SOURCE_CACHE_SECS, default 60s, capped at 600s; 0 disables the
# cache). A consumer that arrives while another is enumerating waits on the lock
# and then reuses that result instead of issuing its own paginated walk.
#
# Only a VALIDATED SUCCESSFUL snapshot is ever written: gh_api_retry returned 0,
# every page was an array, and jq rendered the whole list. A failed, refused, or
# incomplete enumeration exits nonzero WITHOUT touching the cache, so the next
# consumer retries (behind gh_api_retry's quota latch) rather than reading a guess.
# The snapshot carries a header with its creation epoch, line count, and the body's
# sha256; a reader re-verifies all three and treats any mismatch, a future epoch,
# or an expired window as a miss. Writes go through a temp file and rename, so a
# reader never sees a partial file. If the lock cannot be taken within
# GARDEN_CI_PR_SOURCE_CACHE_LOCK_WAIT seconds (default 120) the handler enumerates
# uncached and leaves the cache alone.
#
# The cache lives under the rendered unit root's .garden-state, not GARDEN_STATE,
# for the same reason as the gh-api cooldown latch: independently namespaced units
# may override GARDEN_STATE, but every consumer on one host shares GARDEN_ROOT.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ci-pr-source"

repo="${1:?usage: ci-pr-source-gh.sh <owner/name> [<bot-login>]}"
# bot login is accepted for symmetry with the other sources but the author gate
# lives in the watcher; this handler emits every open PR's author for it to filter.
: "${2:-}"

require_tools gh jq

: "${GARDEN_CI_PR_SOURCE_CACHE_DIR:=$GARDEN_ROOT/.garden-state/ci-pr-source-cache}"
CACHE_MAGIC="ci-pr-source-cache-v1"

cache_secs() {
  local v="${GARDEN_CI_PR_SOURCE_CACHE_SECS:-60}"
  case "$v" in ''|*[!0-9]*) v=60 ;; esac
  [ "$v" -le 600 ] || v=600
  printf '%s' "$v"
}

# enumerate <out-file> — write the complete open-PR TSV to <out-file>. A structural
# failure here must NOT be swallowed into an empty list (which would read as "no
# open PRs" and silently stop every shepherd): surface gh's stderr and return
# nonzero so the watcher dies loud.
enumerate() {
  local out="$1" raw rc=0
  raw="$(mktemp)"
  gh_api_retry --paginate "repos/$repo/pulls?state=open&per_page=100" >"$raw" || rc=$?
  if [ "$rc" -ne 0 ]; then rm -f "$raw"; return "$rc"; fi
  if ! jq -e -s 'length > 0 and all(.[]; type == "array")' "$raw" >/dev/null 2>&1; then
    log "WARN: gh api repos/$repo/pulls returned an incomplete or malformed enumeration; refusing it"
    rm -f "$raw"
    return 1
  fi
  jq -r '.[]
      | [ (.number|tostring),
          (.user.login // ""),
          (.head.repo.full_name // ""),
          (.updated_at // ""),
          (.title // "") ]
      | @tsv' "$raw" >"$out" || rc=$?
  rm -f "$raw"
  return "$rc"
}

# cache_read <file> <ttl> — print the snapshot body and return 0 only when the
# header is intact, the window is live, and the body matches its line count + hash.
cache_read() {
  local f="$1" ttl="$2" magic epoch lines sum now body
  [ -f "$f" ] || return 1
  read -r magic epoch lines sum < "$f" || return 1
  [ "$magic" = "$CACHE_MAGIC" ] || return 1
  case "$epoch$lines" in ''|*[!0-9]*) return 1 ;; esac
  now="$(date +%s)"
  [ "$epoch" -le "$now" ] && [ $((now - epoch)) -lt "$ttl" ] || return 1
  body="$(mktemp)"
  tail -n +2 "$f" > "$body" || { rm -f "$body"; return 1; }
  if [ "$(wc -l < "$body")" -ne "$lines" ] \
     || [ "$(sha256sum < "$body" | cut -d' ' -f1)" != "$sum" ]; then
    rm -f "$body"; return 1
  fi
  cat "$body"
  rm -f "$body"
}

# cache_write <file> <body-file> — atomically publish a validated snapshot.
cache_write() {
  local f="$1" body="$2" tmp
  tmp="$(mktemp "$f.tmp.XXXXXX")" || return 1
  if printf '%s %s %s %s\n' "$CACHE_MAGIC" "$(date +%s)" "$(wc -l < "$body")" \
       "$(sha256sum < "$body" | cut -d' ' -f1)" > "$tmp" \
     && cat "$body" >> "$tmp" && mv -f "$tmp" "$f"; then
    return 0
  fi
  rm -f "$tmp"
  return 1
}

ttl="$(cache_secs)"
out="$(mktemp)"
trap 'rm -f "$out"' EXIT

if [ "$ttl" -eq 0 ] || ! mkdir -p "$GARDEN_CI_PR_SOURCE_CACHE_DIR" 2>/dev/null; then
  enumerate "$out"
  cat "$out"
  exit 0
fi

key="$(printf '%s' "$repo" | tr '[:upper:]' '[:lower:]' | sha256sum | cut -d' ' -f1)"
snap="$GARDEN_CI_PR_SOURCE_CACHE_DIR/$key.tsv"
lock_wait="${GARDEN_CI_PR_SOURCE_CACHE_LOCK_WAIT:-120}"
case "$lock_wait" in ''|*[!0-9]*) lock_wait=120 ;; esac

exec {lockfd}>>"$GARDEN_CI_PR_SOURCE_CACHE_DIR/$key.lock"
if ! flock -w "$lock_wait" "$lockfd"; then
  exec {lockfd}>&-
  log "WARN: open-PR cache lock for $repo busy for ${lock_wait}s; enumerating uncached"
  enumerate "$out"
  cat "$out"
  exit 0
fi

if cache_read "$snap" "$ttl"; then
  exit 0
fi
enumerate "$out"
cache_write "$snap" "$out" || log "WARN: could not write open-PR cache for $repo; continuing uncached"
exec {lockfd}>&-
cat "$out"
