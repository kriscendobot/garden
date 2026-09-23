Work complete. Report follows.

---

## Completion report — `garden-approval-reconciler-build`

**Landed:** `84a3671cce` on `main2` (direct, no PR — garden's own repo). Files:
- `scripts/jobs/approval-reconciler.sh` (new, the reconciler)
- `scripts/systemd/garden-approval-reconciler@.{service,timer}` (new, leader-only per-repo units)
- `scripts/jobs/repo-watcher.sh` (arm from `comment-repos/`)
- `scripts/jobs/test/approval-reconciler-test.sh` (new, hermetic, 12 cases)
- `designs/approval-reconciler.md` (new) + `context/operations/leader-follower.md` (singleton set)

### What it does
A deterministic, **no-LLM, leader-only** periodic sweep per authorized bot-repo (armed from the same cleared `comment-repos/` set the comment/CI/dependabot watchers ride). It closes the gap the investigation named (`investigate-pr721-review-false-peer-resolution.md` §5): the finalization trigger is event-driven off the comment/review feed, so an approval submitted while the watcher is down / over a cursor gap / rate-limited is never re-seen. An approval is a **state, not an event**, so the reconciler needs no cursor — each tick re-derives the world, and a missed tick self-heals on the next.

Per tick: enumerate open PRs (shared `ci-pr-source-gh.sh`) → bot-authored + head-pushable → activity-bound the expensive reads → **board dedup first (no API)** → require a **current trusted-maintainer approval on the exact head** (`pr-maintainer-approval-gh.sh` — the same authority the merge spine requires; stale/untrusted approvals fail) → reuse the event watcher's **exact** eligibility probe (`pr-mergeable-gh.sh`): rc 0 → `<slug>-pr<N>-conduct`, rc 1 (approved-not-green) → `<slug>-pr<N>-shepherd`, rc 2 → nothing. No weaker gate is invented; `is_bot_repo` denies agoric-sdk/endojs-endo upstream and the garden's own repo — it never touches or links to upstream.

**Dedup** (against restart / overlap / event-plus-sweep races) is two layers reading only trusted journal files: deterministic bases (`post-job.sh` is idempotent by basename, re-checked fresh right before posting) plus a `git grep` content scan of every lifecycle lane (todo/doin/tada/plan/orch/gauntlet) that catches hand-named manual conductor/shepherd jobs and orchestration children. A tracked conductor suppresses both a conductor and a shepherd; a tracked shepherd suppresses only a duplicate shepherd.

Units: `ExecCondition=is-main-host.sh` (primary leader gate) + an in-process `is_main_host` check (defence-in-depth + testable), `OnUnitActiveSec=15min` (a backstop behind the 90s real-time watchers), transient-failure skip and repo-gone graceful deactivation mirroring `ci-watcher.sh`.

### Regression audit (read-only)
For every PR the 07-30 manual sweep recovered — #885, #880, #870, #848, #558, #556 (conductor) and #836 (shepherd) — a matching `-conduct`/`-shepherd` job is present on the board today, so the reconciler's `conductor_tracked()`/`shepherd_tracked()` return true and it posts **nothing**: the manual requests are suppressed exactly as required. At approval time each would have been recovered (approved + `pr-mergeable` rc 0 → conductor; #836's red CI → shepherd), matching the manual sweep step for step.

### Tests (all green)
- `approval-reconciler-test.sh`: **12/12** — missed event, stale-approval-after-head-movement, event/sweep race, manual different-basename, red CI, draft PR, untrusted approver, non-bot PR, merged/closed, shepherd dedup, leader/follower gating, non-bot repo slug.
- `ci-watcher-test.sh`: **49/0**; full `run-test.sh`: **368/0** (incl. REPO WATCHER subtest self-heal-rendering the new template). `shellcheck -S warning` clean (only the pre-existing `GARDEN_TAG` SC2034 shared with `ci-watcher.sh`).

### Rollout requirements
On the next deploy (`deploy-garden.sh`), `install-units.sh install` renders the new template and `repo-watcher.sh` arms `garden-approval-reconciler@<slug>` for each `comment-repos/` entry on the **leader** host; followers skip via the ExecCondition. No journal data or new authorization is needed — it rides the existing cleared watch set. No manual steps.

### Follow-ups
- None blocking. Optional: the separate "ready-for-approval notice" (surface green/mergeable bot PRs that have *no* approval to the maintainer) from the same investigation §5 remains unbuilt — a distinct producer, out of this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-approval-reconciler-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 138 tokens (9379680 cached reads)
- Output: 71734 tokens
- Cost: $8.180387000000001 (2 engagement(s) unpriced)
- Wall-clock: 1532s
- Model(s): kimi-k3 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
