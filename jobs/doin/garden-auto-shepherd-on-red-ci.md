# Auto-dispatch a shepherd when a bot-authored PR's CI goes red after a push

**Origin:** maintainer (kriskowal) directive on endojs/endo-but-for-bots PR #58,
[comment](https://github.com/endojs/endo-but-for-bots/pull/58#issuecomment-4852704825):

> post a job to fix the gardener process. This should have been handed off to a
> shepherd automatically when changes were proposed and pushed.

## The gap

The garden already knows how to shepherd a PR to green, but nothing triggers it
autonomously on a CI failure. The only path today is a maintainer typing
"Shepherd" in a PR comment: `scripts/jobs/triager.sh` watches **pull-request
comments** and maps a `shepherd #N` directive to a `shepherd` job
(`roles/triager/AGENT.md` § directive table). There is **no producer that watches
CI status** on the garden's own open PRs. So when a gardener (or the maintainer)
pushes changes to an open bot-authored PR and CI goes red — as happened on #58,
where a lint/prettier failure sat red until the maintainer manually asked for a
shepherd — the failure sits unattended until a human notices.

## The work

Add a **deterministic CI-status producer** that closes this loop:

- Enumerate the garden's **own open PRs** on watched, injection-safe repos
  (author is the bot identity; head branch lives on a repo the bot can push).
  Enumerate authoritatively (paginated REST, activity-bounded) — never a default
  `gh pr list` page cap (see the "default list limit silently drops surveillance"
  lesson from #284).
- For each, read the check-suite rollup. When the rollup is a **completed
  FAILURE** (not in-progress, not a flake-retry window) and no shepherd job for
  that PR is already live on the board, post a `shepherd` job via
  `post-job.sh`, with a basename derived deterministically from the PR identity
  (e.g. `<owner>-<repo>-pr<N>-shepherd`) so re-ticks are idempotent and do not
  duplicate (matches `post-job.sh`'s basename idempotency and the existing
  manual-shepherd job naming).
- Decide the home: extend `scripts/jobs/triager.sh` with a CI-status pass, or add
  a sibling `ci-watcher` producer + timer unit. Prefer reusing the triager's
  per-repo watch set (journal `repos/`) and its injection-safe repo gating so the
  monitoring-safety constraint (CLAUDE.md § Monitoring safety) is honored — only
  repos already cleared for surveillance.
- **Leader-only singleton** (like the other watchers): a new/extended producer
  must carry the `is-main-host.sh` `ExecCondition=` gate so followers skip it and
  it does not double-post (CLAUDE.md § Leader and follower hosts).
- Avoid thrash: do not re-post while a shepherd for that PR is in
  `todo/doin`, and back off on a rollup that is still `IN_PROGRESS`/`QUEUED`.

## Definition of done

A red CI on an open bot-authored PR autonomously yields exactly one `shepherd`
job on the board without any maintainer comment, deduped across ticks and across
hosts, gated to injection-safe repos and the leader host. Land the producer
logic + systemd timer/unit + the role/doc note (triager role file or a new
role brief) on `main2`. Verify by pointing it at a repo with a known-red bot PR
and confirming a single idempotent post.

## Notes

- This is the general fix; the specific #58 lint failure that surfaced it has
  already been shepherded to green by the job that filed this.
- Keep the trigger deterministic (plain-code status read, fixed mapping), in the
  triager's low-discretion spirit — no LLM reasoning over CI logs to decide
  whether to dispatch.

---
claim:
  host: endolinbot2
  gardener: 18
  claimed_at: 2026-07-01T09:30:23Z
