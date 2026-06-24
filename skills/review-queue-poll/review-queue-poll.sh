#!/bin/bash
# review-queue-poll.sh — poll unit for kriskowal's pending review-request queue
# across all repos visible to the bot's gh auth. In v2 this runs as a producer
# (a watchman/triager-style poll); the queue is trusted GitHub state, so it is
# safe to poll by construction.
#
# Usage: review-queue-poll.sh <state-dir> <cadence-seconds>
#   <state-dir> SHOULD live under $GARDEN_STATE (e.g. $GARDEN_STATE/review-queue),
#   never /tmp and never a reset-prone journal worktree, so a `git reset --hard`
#   on the journal never clobbers it.
#
# Polls `gh search prs --review-requested=kriskowal --state=open` on the
# given cadence. Atomically writes the canonical set to <state-dir>/current.json,
# rolls the previous snapshot to <state-dir>/prev.json before each write, and
# emits one stdout line per diff:
#
#   [HH:MM:SS] ADD <owner>/<name>#<n> draft=<bool> updated=<iso> '<title>'
#   [HH:MM:SS] REMOVE <owner>/<name>#<n>
#   [HH:MM:SS] unchanged n=<count>
#
# A consumer (a gardener claiming a posted review-queue job, or the liaison in
# session) reacts only when a non-`unchanged` line appears since the prior cycle.
#
# Search-rate-limit budget is 30/min for the authenticated user; default
# cadence of 120s burns 30/hr, comfortable.

set -uo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <state-dir> <cadence-seconds>" >&2
  exit 64
fi

STATE=$1
CADENCE=$2
mkdir -p "$STATE"

trap 'echo "[$(date -u +%H:%M:%S)] daemon stopping pid=$$"; exit 0' INT TERM

echo "[$(date -u +%H:%M:%S)] review-queue daemon starting state=$STATE cadence=${CADENCE}s pid=$$"

while true; do
  TMP_OUT=$(mktemp)
  TMP_ERR=$(mktemp)

  if gh search prs --review-requested=kriskowal --state=open --limit=1000 \
       --json number,repository,title,url,author,isDraft,updatedAt \
       > "$TMP_OUT" 2> "$TMP_ERR"; then

    python3 - "$TMP_OUT" "$STATE" <<'PY'
import json, sys, os, datetime, shutil, subprocess
src, state = sys.argv[1], sys.argv[2]
raw = json.load(open(src))
# Carry forward last cycle's baseRefName values so we only fetch the field
# for newly-arrived rows. Base branches rarely change after PR open; this
# keeps the per-cycle REST budget proportional to the daily ADD rate (~1
# per cycle in steady state) rather than to the queue size (~100 rows).
cur_path = os.path.join(state, 'current.json')
prev = []
if os.path.exists(cur_path):
    try:
        prev = json.load(open(cur_path))
    except Exception:
        prev = []
prev_base = {(r.get('repo'), r.get('number')): r.get('baseRefName','') for r in prev}
# Per-repo cache of GitHub's `isArchived` flag, keyed by `owner/name`. Archived
# state is a property of the repository, not the PR, and changes rarely; a
# 24-hour TTL keeps the per-cycle REST budget at zero in steady state and
# bounded by the number of distinct repos in the queue on first poll.
archived_path = os.path.join(state, 'archived.json')
archived_cache = {}
if os.path.exists(archived_path):
    try:
        archived_cache = json.load(open(archived_path))
    except Exception:
        archived_cache = {}
ARCHIVED_TTL_SECONDS = 24 * 60 * 60
now = datetime.datetime.utcnow()
def archived_for(repo):
    entry = archived_cache.get(repo)
    if entry and entry.get('fetchedAt'):
        try:
            fetched = datetime.datetime.strptime(entry['fetchedAt'], '%Y-%m-%dT%H:%M:%SZ')
            if (now - fetched).total_seconds() < ARCHIVED_TTL_SECONDS:
                return bool(entry.get('isArchived', False))
        except Exception:
            pass
    # Stale or missing: fetch. One REST call per cache miss; the daily miss
    # rate equals the count of distinct repos in the queue divided by 1 day.
    try:
        out = subprocess.check_output(
            ['gh', 'repo', 'view', repo, '--json', 'isArchived', '--jq', '.isArchived'],
            stderr=subprocess.DEVNULL,
            text=True, timeout=20,
        ).strip()
        is_archived = (out == 'true')
    except Exception:
        # On failure, preserve the prior known value if any; otherwise assume
        # not archived so the row stays visible until the next successful fetch.
        is_archived = bool((entry or {}).get('isArchived', False))
    archived_cache[repo] = {
        'isArchived': is_archived,
        'fetchedAt': now.strftime('%Y-%m-%dT%H:%M:%SZ'),
    }
    return is_archived
canon = []
for row in raw:
    repo_obj = row.get('repository') or {}
    repo = repo_obj.get('nameWithOwner') or f"{repo_obj.get('owner','?')}/{repo_obj.get('name','?')}"
    number = row.get('number')
    base = prev_base.get((repo, number), '')
    if not base:
        # New row this cycle, or first-ever poll: fetch the base ref. Cost
        # is one REST call per ADD; the daily ADD rate (5 to 20) is well
        # under the 5000/hr REST budget.
        try:
            base = subprocess.check_output(
                ['gh', 'api', f'repos/{repo}/pulls/{number}', '--jq', '.base.ref'],
                stderr=subprocess.DEVNULL,
                text=True, timeout=20,
            ).strip()
        except Exception:
            base = ''
    canon.append({
        "repo": repo,
        "number": number,
        "title": row.get('title',''),
        "url": row.get('url',''),
        "isDraft": bool(row.get('isDraft', False)),
        "updatedAt": row.get('updatedAt',''),
        "author": (row.get('author') or {}).get('login','?'),
        "baseRefName": base,
        "isArchived": archived_for(repo),
        "requestedAt": None,
    })
canon.sort(key=lambda r: (r['repo'], r['number']))
prev_path = os.path.join(state, 'prev.json')
def key(r): return (r['repo'], r['number'])
prev_keys = {key(r): r for r in prev}
cur_keys  = {key(r): r for r in canon}
added   = [cur_keys[k] for k in cur_keys if k not in prev_keys]
removed = [prev_keys[k] for k in prev_keys if k not in cur_keys]
ts = datetime.datetime.utcnow().strftime('%H:%M:%S')
if added or removed:
    for r in added:
        title = r['title'].replace("'", "\\'")
        if len(title) > 80: title = title[:77] + '...'
        print(f"[{ts}] ADD {r['repo']}#{r['number']} draft={str(r['isDraft']).lower()} updated={r['updatedAt']} '{title}'", flush=True)
    for r in removed:
        print(f"[{ts}] REMOVE {r['repo']}#{r['number']}", flush=True)
else:
    print(f"[{ts}] unchanged n={len(canon)}", flush=True)
# Roll prev, then atomic write current.
if os.path.exists(cur_path):
    shutil.copyfile(cur_path, prev_path + '.tmp')
    os.replace(prev_path + '.tmp', prev_path)
tmp = cur_path + '.tmp'
with open(tmp, 'w') as f:
    json.dump(canon, f, indent=2)
    f.write('\n')
os.replace(tmp, cur_path)
# Persist the archived cache (atomic). Entries for repos no longer in the
# queue are kept; they may return on a future poll, and a stale entry simply
# refreshes on its next TTL boundary.
atmp = archived_path + '.tmp'
with open(atmp, 'w') as f:
    json.dump(archived_cache, f, indent=2, sort_keys=True)
    f.write('\n')
os.replace(atmp, archived_path)
PY

  else
    echo "[$(date -u +%H:%M:%S)] gh search failed:" >&2
    head -c 500 "$TMP_ERR" >&2
    echo "" >&2
    # If auth failed (401-ish), gh prints an explicit message; back off long.
    if grep -q -i 'authentication\|not authenticated\|HTTP 401' "$TMP_ERR"; then
      echo "[$(date -u +%H:%M:%S)] auth failed; daemon stopping" >&2
      rm -f "$TMP_OUT" "$TMP_ERR"
      exit 1
    fi
    # Otherwise back off 60s and retry.
    sleep 60
  fi

  rm -f "$TMP_OUT" "$TMP_ERR"
  sleep "$CADENCE"
done
