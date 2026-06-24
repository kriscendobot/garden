---
created: 2026-05-12
updated: 2026-06-24
author: gardener, liaison
---

# Skill: review-queue-poll

Poll the GitHub search API for the set of open pull requests on which `kriskowal` is a requested reviewer, persist the canonical set atomically, and emit one log line per add/remove since the previous tick.

In v2 this is a **producer**: a [watchman](../job-board/SKILL.md)/triager-style poll unit that watches kriskowal's pending-review set (trusted GitHub state, not arbitrary repo bodies — safe to poll by construction) and surfaces motion. When a new PR enters the queue, the producer posts a `review-queue` job to the board (or appends to the pending-reviews bulletin section); a gardener or the liaison reacts. This skill is the operational contract the sibling poll script `review-queue-poll.sh` implements; the LLM side reads the script's outputs, it does not call the search itself.

## Inputs

- `state_dir`: the poll unit's state directory. Default: `$GARDEN_STATE/review-queue/`. Standing state lives under `GARDEN_STATE` (never `/tmp`, never a reset-prone journal worktree) so a `git reset --hard` on the journal never clobbers it, consistent with all v2 standing markers.
- `cadence_seconds`: seconds between polls. Default: 120. `gh search prs` costs against the authenticated user's search rate limit (30/min), so cadences faster than 30s are wasteful; 120s gives ample headroom.

## State files

Inside `state_dir`, atomic via `*.tmp` + `mv`:

- `current.json`: canonical snapshot of the queue. One object per pending PR with at least `repo`, `number`, `title`, `url`, `isDraft`, `updatedAt`, `author`, `baseRefName`, `isArchived`, `requestedAt` (best-effort). `baseRefName` is the upstream branch the PR targets (`master`, `llm`, `main`); consumers partition rows by target branch before any milestone-bin pass. The poll fetches `baseRefName` via a per-row REST call and reuses the prior cycle's value to keep the per-cycle REST budget proportional to the ADD rate, not the queue size. `isArchived` is the GitHub `isArchived` flag for the row's repository, replayed onto every row from the per-repo cache (`archived.json`); a renderer drops `isArchived: true` rows before classification.
- `prev.json`: the previous tick's snapshot, used to compute the diff. Rolled forward atomically before `current.json` is replaced.
- `archived.json`: per-repo cache of `isArchived`, keyed by `owner/name`: `{"<repo>": {"isArchived": <bool>, "fetchedAt": "<UTC-iso>"}, ...}`. TTL 24 hours; archived state changes rarely, so the steady-state per-cycle REST cost for this field is zero. On cache miss, fetch via `gh repo view <owner>/<repo> --json isArchived --jq .isArchived`. The cache retains entries for repos that have left the queue, and a fetch failure preserves the prior known value.
- `etag.txt`: present only if the unit switches to a conditional-fetch transport later; not used by the search API today.

## Procedure (poll unit)

1. `gh search prs --review-requested=kriskowal --state=open --limit=1000 --json number,repository,title,url,author,isDraft,updatedAt`. `gh search` paginates transparently up to `--limit`; 1000 is the CLI's hard cap and the GitHub search API's practical max, so a queue larger than that is undetectable — if the count ever hits 1000, that itself is the signal to raise a message to the liaison (via the [message-bus](../message-bus/SKILL.md)) about refining the filter.
2. Normalize each row into the canonical-set shape:

   ```json
   {
     "repo": "<owner>/<name>", "number": 123, "title": "...",
     "url": "https://github.com/.../pull/123", "isDraft": false,
     "updatedAt": "2026-05-12T20:00:00Z", "author": "<login>",
     "baseRefName": "master", "isArchived": false, "requestedAt": null
   }
   ```

   `requestedAt` is left `null` until the per-PR timeline query is added (see *Notes*). `baseRefName` is not a `gh search prs --json` field; the unit fetches it per row with `gh api repos/<repo>/pulls/<n> --jq .base.ref` and caches by `(repo, number)` from the previous `current.json` (steady-state cost: one REST call per ADD line, not per row). `isArchived` is fetched per repo with `gh repo view <repo> --json isArchived --jq .isArchived` and cached in `archived.json` with a 24-hour TTL (steady-state cost: zero; worst case, one REST call per distinct repo on first poll after restart).
3. Atomically write `current.json.tmp` → `current.json`. Before the rename, copy the previous `current.json` to `prev.json` (also atomic).
4. Diff `prev.json` vs `current.json` by `(repo, number)`. Emit:
   - `[HH:MM:SS] ADD <repo>#<n> draft=<bool> updated=<iso> '<title>'` for each new key.
   - `[HH:MM:SS] REMOVE <repo>#<n>` for each missing key.
   - else `[HH:MM:SS] unchanged n=<count>`.

   `unchanged` is the steady state and is what a consumer filters out before reacting.
5. On 401 / 403 / 5xx from `gh search`, write `[HH:MM:SS] HTTP <code> search rate-limited or error` to stderr and back off: 401 → exit (token gone; respawn after auth is fixed); 403/429 → fixed 5-minute back-off; 5xx → 60-second back-off then retry.
6. Sleep `cadence_seconds` and loop.

## Procedure (consumer reaction)

A consumer (a gardener claiming a posted `review-queue` job, or the liaison reacting in-session) reads the producer's outputs:

1. `tail -200 $GARDEN_STATE/review-queue.log` and find lines newer than the prior cycle's close. Note the ADD/REMOVE set as the cycle's delta.
2. Read `$GARDEN_STATE/review-queue/current.json` (the source of truth for what is currently pending).
3. Sort the set per the priority rule the consuming role carries. With today's data, every item is tier (3) (fresh request); draft items group at the bottom.
4. Rewrite the *Pending kriskowal reviews* section of the pending-reviews bulletin between the section's delimiters. Each item is one line:

   ```
   - [<repo>#<n>](<url>) <title> — <author>, requested <relative-time>[, draft]
   ```

   Trim the title to ~60 chars if needed; the URL is the canonical link.
5. Commit the bulletin change and record a short summary of the deltas. (When the producer posts a job rather than the consumer rendering in-session, the posting itself carries the delta and the gardening completion records the outcome per [job-board](../job-board/SKILL.md).)

## Monitoring safety

This poll watches kriskowal's pending-review set, which is **trusted GitHub state** — not arbitrary repo bodies or comment text an untrusted contributor can write. It is therefore safe to poll by construction and does not fall under the content-injection constraint that gates which repos may be monitored at event level. The producer never feeds PR bodies or comment text into an LLM; it only surfaces the `(repo, number, title)` tuple set.

## Notes from the field

- _2026-06-24_: migrated to v2. The poll script is a self-contained `gh search`/REST poll with atomic state-file writes and no v1 daemon-management or driver plumbing, so it is reproduced verbatim alongside this skill with two changes: the default `state_dir` moves from `/tmp/garden-review-queue/` to `$GARDEN_STATE/review-queue/`, and the consumer side is reframed from a steward/journalist render to a producer-posts-job / consumer-reacts split. The script's internals (canonical-set normalization, baseRefName + isArchived caching, atomic writes, back-off) are unchanged.
- _2026-05-12_: `gh search prs --review-requested=USERNAME` returns PRs across all visible repos in one call (one search-rate-limit point; 30/min budget). 120s cadence ≈ 30/hr.
- _2026-05-12_: `gh search`'s `--limit` is the hard page-walk ceiling, not the per-call cap. The GitHub search API stops responding past 1000 results, so a queue larger than 1000 is invisible to this skill.
- _2026-05-12_: the search endpoint does not include `requestedAt` or per-PR review history. To populate tiers (1) (`CHANGES_REQUESTED` then pushed) and (2) (explicit re-request), the unit needs a follow-up `gh api repos/<repo>/pulls/<n>/timeline` per PR (one REST call per PR per tick; the 5000/hr REST budget absorbs it). Land as a follow-up; until then every item is tier (3).
- _2026-05-12_: `gh search prs --json updatedAt` returns the *PR's* last-update timestamp, not the last *review-request* timestamp. For tier (3) sort, `updatedAt` is a usable proxy when the PR was just opened, but not when an old PR re-requests review. The timeline query is the right fix.
