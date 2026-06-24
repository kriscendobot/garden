---
created: 2026-05-12
updated: 2026-06-24
author: liaison, gardener
---

# Skill: github-activity-poll

Poll a GitHub repository's public events feed efficiently using conditional HTTP
requests. When nothing has changed, the response is 304 Not Modified and does
**not** count against the primary REST rate limit, so 1/minute polling is
sustainable indefinitely. In v2 this is a **producer** primitive: the
[triager](../../roles/triager/AGENT.md) (per-repo PR-comment watch) and the
[watchman](../../roles/watchman/AGENT.md) (library evolution) run on a timer and
use this conditional-GET pattern to decide whether a tick has new activity to
react to.

## Inputs

- `repo`: `owner/name` (e.g. `anthropics/claude-code`).
- `state_dir`: directory to read/write polling state. In v2 the standing markers
  live under `GARDEN_STATE` (never a shared journal worktree, which a
  `reset --hard` would clobber). Default:
  `$GARDEN_STATE/activity-poll/<owner>-<repo>/`.
- `auth_token` (optional): a GitHub token. Read from `$GITHUB_TOKEN` if not
  passed. Required for private repos; raises rate limit from 60/hr to 5000/hr
  otherwise.

## State files

Inside `state_dir`:

- `etag.txt`: value of the previous response's `ETag` header.
- `last_modified.txt`: value of the previous response's `Last-Modified` header.
- `last_event_id.txt`: id of the highest event seen so far. Used to dedupe within
  a single 200 response, and as the producer's last-seen marker (advanced only
  after the tick's events are successfully posted/broadcast).

All three are written atomically (write to `*.tmp`, then `mv`) so a crash
mid-write cannot corrupt state. Because they live under `GARDEN_STATE` rather than
the journal, the journal's CAS push model never touches them.

## Procedure

1. `mkdir -p <state_dir>`.
2. Read `etag.txt` and `last_modified.txt` if present.
3. Issue:

   ```
   GET https://api.github.com/repos/<repo>/events
   Accept: application/vnd.github+json
   X-GitHub-Api-Version: 2022-11-28
   If-None-Match: <etag>            # if known
   If-Modified-Since: <last_modified> # if known
   Authorization: Bearer <token>    # if a token is configured
   ```

4. Branch on status:

   - **304 Not Modified**: no new events. Touch nothing on disk. Output:
     `unchanged repo=<repo> last_modified=<ts>`.
   - **200 OK**: parse the JSON array (newest first). Drop events with
     `id <= last_event_id`. For each remaining event capture: `id`, `type`,
     `actor.login`, `created_at`, and a payload-specific link (PR number, issue
     number, push ref, comment URL). Then atomically update `etag.txt`,
     `last_modified.txt`, and `last_event_id.txt` (set to the max id seen) —
     **after** the producer has acted on the events (posted jobs / broadcast), so
     a failure mid-tick re-surfaces the events next tick rather than dropping
     them.
   - **403 / 429**, or `X-RateLimit-Remaining: 0`: stop. Report the limit and
     `X-RateLimit-Reset` (epoch seconds).
   - **404**: repo is missing, private, or the token lacks access. Stop and
     report.
   - **Anything else**: stop and report status + body excerpt.

## Output shape

Unchanged:

```
unchanged repo=<repo> last_modified=<ts>
```

Changed:

```
changed repo=<repo> new_events=<n>
  <created_at> <type> by <actor> -> <link>
  ...
```

If `n > 10`, group by `(type, actor)` and emit one line per group with a count
instead of one line per event.

## Notes

- The `/events` endpoint is server-cached by GitHub for ~60 seconds. Polling
  faster than 1/min wastes calls and may return stale data.
- The events feed only surfaces public activity. For private repos, or for
  activity not on the events feed (discussions, security advisories), use the
  equivalent typed endpoint (`/issues`, `/pulls`, `/discussions`) with the same
  conditional-request pattern. The triager's PR-comment watch uses the typed
  `/issues/comments` and `/pulls/comments` endpoints (see
  [activity-feed-watcher](../activity-feed-watcher/SKILL.md)
  and [at-mention-surveillance](../at-mention-surveillance/SKILL.md)).
- `ETag` is the more reliable validator; `If-Modified-Since` is a fallback.
  Always send both when both are known. GitHub will honor whichever matches.
- **Monitoring safety.** A producer feeds event metadata — and, on the typed
  comment endpoints, comment bodies — into context. Only watch repos gated
  against untrusted contributors (our forks and `endojs/endo-but-for-bots`), per
  `roles/triager/AGENT.md` § Monitoring safety.

## Notes from the field

- _2026-05-12_: `check_run` and `check_suite` activity does **not** appear on
  this endpoint. To watch CI on a specific PR, use [pr-ci-watch](../pr-ci-watch/SKILL.md), which polls the
  PR's status check rollup directly. This skill is still useful alongside it for
  repo-wide situational awareness (new pushes to base, branch creations, etc.).
- _2026-06-24_: migrated into v2. Re-homed the consumer from the v1 standing
  monitor daemon to the triager/watchman producers; moved the last-seen / ETag
  caches from `<worktree>/.garden-monitor/` and `/tmp` to `GARDEN_STATE`, and tied
  the marker advance to a successful post/broadcast (job-board producer
  discipline).
