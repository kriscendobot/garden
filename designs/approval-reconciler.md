# The approval reconciler — a periodic backstop for missed maintainer approvals

## The gap

The finalization trigger — un-draft + merge an approved bot PR — is **event-driven**.
`comment-watcher.sh`'s `[APPROVED]` path watches the PR comment/review feed: a
trusted maintainer approves, the watcher sees the review, probes mergeable/green
(`handlers/pr-mergeable-gh.sh`), and mints `<slug>-pr<N>-conduct` (or degrades to
`<slug>-pr<N>-shepherd` when approved-but-not-green). That path has one structural
blind spot: an **approval is a one-shot event with no re-poll**. An approval
submitted while the watcher is **down**, over a **cursor gap**, or during a
**rate-limit outage** is never re-seen, so an approved, green, mergeable PR can sit
forever with no conductor.

This is not hypothetical. On **2026-07-28** several maintainer approvals dispatched
no conductor and the maintainer had to request them by hand; the one-off manual
sweep that recovered them is `jobs/tada/ebfb-approved-pr-conductor-reconcile-20260730.md`
(#885, #880, #870, #848, #558, #556 → conductor; #836 → shepherd). The
investigation `jobs/tada/investigate-pr721-review-false-peer-resolution.md` §5 named
the fix precisely: *"Approval reconciler … a sweep for `pr-maintainer-approval-gh.sh
== 0` with no live conductor job … It is approval-anchored, so it can never merge
unapproved work."* This design is that backstop.

## Shape: a stateless, leader-only, no-LLM sweep

`scripts/jobs/approval-reconciler.sh <repo-slug>`, a sibling of `ci-watcher.sh`,
runs per authorized watched repo on a slow cadence. An **approval is a STATE, not an
event**, so — unlike the comment watcher — it needs **no cursor**: each tick
re-derives the world from the live board plus live PR/approval state, so a **missed
tick self-heals on the next one**.

```
enumerate the repo's OWN open PRs (authoritative paginated REST — the shared
  ci-pr-source-gh.sh, never a default gh page cap)
  → keep PRs AUTHORED by the bot whose head branch is bot-pushable
  → activity-bound: skip a PR untouched beyond the window BEFORE its (API-heavy)
    approval read — a fresh approval bumps updated_at, so newly-approved PRs are
    always in-window (steady-state API thrift)
  → board dedup FIRST (no API): a conductor already tracked for the PR → skip
  → require an EFFECTIVE trusted-MAINTAINER approval (pr-maintainer-approval-gh.sh)
    — a still-standing APPROVED, even on an earlier head (the exact-current-head
    freshness guard was removed 2026-08-28); dismissed, CHANGES_REQUESTED-superseded,
    and untrusted approvals do NOT count
  → reuse the event watcher's EXACT eligibility probe (pr-mergeable-gh.sh):
      rc 0  ready  → post <slug>-pr<N>-conduct (conductor un-drafts + merges)
      rc 2  merged/closed → nothing
      rc 1  approved but not green → post <slug>-pr<N>-shepherd (the finalize→
            shepherd degrade), deduped against any live/tracked shepherd
```

Every gate is the **same code the event path already trusts** — no weaker gate is
invented:

- `is_bot_repo` (denylist-by-default; agoric/agoric-sdk and endojs/endo upstream
  denied, the garden's own repo denied ahead of the bot-fork rule). The reconciler
  **never** interacts with or links to upstream `agoric/agoric-sdk`.
- `pr-maintainer-approval-gh.sh` — the same **effective-maintainer-approval** authority
  the merge spine `ci-wait-merge.sh` independently requires. Anchoring here (on
  `maintainers/allowlist`, stricter than the comment watcher's broader `is_trusted`
  trigger) guarantees a conductor the reconciler posts can **actually merge** — it
  never mints a job that would stall at the merge gate. The looser trusted-sender
  approvals stay the event path's job, live.
- `pr-mergeable-gh.sh` — the same draft/mergeable/CI/approval rollup
  `GARDEN_PR_MERGEABLE` points at, so a draft is finalized (the conductor un-drafts)
  and a not-green PR degrades to a shepherd exactly as the event path does.

## Dedup: restart / overlap / event-plus-sweep races

Two layers, both reading only **trusted journal job files** (never a PR body, so no
injection surface):

1. **Deterministic base** — the reconciler mints the SAME basenames the event path
   does (`<slug>-pr<N>-conduct` / `-shepherd`), and `post-job.sh` is idempotent by
   basename across plan/todo/doin/tada. A concurrent event-post and sweep-post
   collapse to one. The script also pre-checks those bases, and re-checks on a fresh
   board read immediately before the post to tighten the race window.
2. **Content scan** — because a maintainer may **hand-name** a conductor/shepherd
   job (the 07-28 manual requests, e.g. `conduct-ebfb-805-tla`), the sweep also
   `git grep`s every lifecycle lane (todo/doin/tada/plan/orch/gauntlet) for jobs
   that reference the PR's URL and classify (by basename token or `role:`
   frontmatter) as conductor/shepherd work, and suppresses a duplicate. A tracked
   **conductor** suppresses both a conductor and a shepherd (finalization handled);
   a tracked **shepherd** suppresses only a duplicate shepherd (a later green tick
   still posts the conductor).

**Regression evidence (read-only).** For every PR the 07-30 manual sweep recovered
(#885, #880, #870, #848, #558, #556, #836), a `-conduct` (or, for #836, `-shepherd`)
job is present on the board today, so the reconciler's `conductor_tracked()` /
`shepherd_tracked()` return true and it posts **nothing** — the manual requests are
suppressed, exactly the "do not duplicate" requirement. At approval time each would
have been recovered: approved + `pr-mergeable` rc 0 → conductor (rc 1 for #836's red
CI → shepherd), matching the manual sweep step for step.

## Leader-only, cadence-bounded, observable

`garden-approval-reconciler@.service` carries the `is-main-host.sh` `ExecCondition`
(the primary leader gate), and the script **also** checks `is_main_host` in-process
as defence in depth (and for the leader/follower test). The `@.timer` runs a slow,
API-thrifty cadence (`OnUnitActiveSec=15min`) — it is a backstop **behind** the
real-time 90s comment/CI watchers, not a replacement; each tick reads ~2 API calls
per **approved** PR (few), the rest gated out for free. Armed per repo by
`repo-watcher.sh` from the cleared `comment-repos/` set (`reconcile_set comment-repos
garden-approval-reconciler`), the same monitoring-safety-authorized set the
comment/CI/dependabot watchers ride. Each tick logs a one-line summary
(open/bot-authored/stale-skipped/already-tracked/approved/merged-closed/conductors/
shepherds). A transient source failure skips the tick (never guesses); a definitive
repo-gone error deactivates gracefully with one maintainer alert, mirroring
`ci-watcher.sh`.

## Tests

`scripts/jobs/test/approval-reconciler-test.sh` is hermetic (no GitHub; the PR
source, approval gate, and mergeable probe are stubbed) and covers: missed event →
conductor; a refused approval (approval gate nonzero: dismissed/CHANGES_REQUESTED/
untrusted) → no job; event/sweep race; manual job under a
different basename; red CI → shepherd; draft PR → conductor; untrusted approver;
non-bot PR; merged/closed; shepherd dedup; leader/follower gating; non-bot repo slug.

## Files

- `scripts/jobs/approval-reconciler.sh` — the reconciler.
- `scripts/systemd/garden-approval-reconciler@.{service,timer}` — leader-only,
  per-repo, 15-minute cadence.
- `scripts/jobs/repo-watcher.sh` — arms the unit from `comment-repos/`.
- `scripts/jobs/test/approval-reconciler-test.sh` — hermetic suite.
- Reused unchanged: `handlers/ci-pr-source-gh.sh`, `handlers/pr-maintainer-approval-gh.sh`,
  `handlers/pr-mergeable-gh.sh`, `post-job.sh`.
