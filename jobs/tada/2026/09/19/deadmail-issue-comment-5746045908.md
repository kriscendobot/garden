Done. Inbox is empty; work is complete.

## Completion report

**Job:** issue follow-up on kriscendobot/garden#89 — maintainer comment "Please requeue all jobs that are parked waiting only for quota."

**What "parked waiting only for quota" resolves to, and what I found:**
- **Reaper quota-backoff holds** (jobs held in `jobs/doin/` under a `garden-provider-quota-backoff` marker): **none** — the reaper auto-requeues these at the recorded reset; the 2026-09-19 20:31Z weekly reset already released them.
- **`--budget-hold` plan jobs** (`budget_hold: true` + `park_reason: over-token-budget`, the machine-defined "parked purely for quota" set owned by the `budget-refresh` watcher): **none** — already auto-promoted at the reset.
- **Doomed jobs with an explicit `outage-attributed` (quota) annotation:** 3, each carrying its own "re-promote after the reset" recommendation.

**What I did:**
- Requeued the 3 machine-attributed quota-doomed jobs, plan → todo, via `promote-plan.sh` (all rc=0, all gone from `plan/`):
  - `build-kebab-case-lint-wildcard-test262-gauntlet-clean`
  - `kriscendobot-minion.town-pr78-gauntlet-clean` (PR still open/draft)
  - `kriscendobot-minion.town-pr80-gauntlet-clean` (PR still open/draft)
- Verified both minion.town PRs are still OPEN draft, so the gauntlet-clean jobs remain relevant (avoided requeuing stale work).
- Posted a reply on the issue thread: https://github.com/kriscendobot/garden/issues/89#issuecomment-5746109955 (posted via REST after `gh issue comment`'s GraphQL path hit a rate limit).

**Deliberately not done (surfaced as a scope question on the thread, not silently dropped):** 185 other doomed jobs sit under `gate: go-ahead`. The board can't mechanically separate "doomed purely by quota-brake retry-exhaustion" from "doomed by a real defect" (only the 3 above carry the attribution). Blanket-promoting all 185 would re-spend heavily and re-run superseded/failing work — against the quota being conserved — so I asked the maintainer for a bound (e.g. a date window) before going wider. Also confirmed endojs/endo-but-for-bots#1015 and #1226 stay behind their **content** go-ahead (they wait on review, not only quota) unless he says otherwise.

**Notes / follow-ups:**
- No garden-source (main2) changes — this was a journal/board operation; nothing to commit in the worktree.
- GitHub API is rate-limited fleet-wide right now (GraphQL bucket); the comment landed via the REST path.
- Follow-up depends on the maintainer's scope answer on the thread; if he names a window/list, a promoter (liaison or a gardener) should run `promote-plan.sh` over that set.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5746045908.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1836552 cached reads)
- Output: 23638 tokens
- Cost: $2.2678069999999995
- Wall-clock: 433s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
