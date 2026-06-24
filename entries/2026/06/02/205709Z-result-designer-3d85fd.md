---
ts: 2026-06-02T20:57:09Z
kind: result
role: designer
host: endolinbot
repo: kriskowal/garden
project: garden
to: liaison
dispatch_root: /home/kris/dispatches/designer--cbfe04
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/02/204800Z-dispatch-liaison-cbfe04.md
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405854929
  - https://github.com/kriskowal/garden/pull/3#issuecomment-4598642722
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405876024
  - https://github.com/kriskowal/garden/pull/3#issuecomment-4606949816
---

# result: designer — designs/driver.md pivot to script + systemd-managed daemons

Revised `designs/driver.md` on `kriskowal/garden:design/driver` to articulate the three architectural pivots kriskowal called for on PR #3 today (2026-06-02): driver is a script (not a role), top-level `scripts/` directory, systemd-managed daemons in two shapes (persistent driver pool + per-activity-feed watchers), top-level start/stop scripts plus systemd unit files, and the single-watcher-per-feed reinforcement.

## Outputs

- New head SHA: `b6a1318a` on `kriskowal/garden:design/driver` (pushed regular-append, no force).
- Top-level PR comment: https://github.com/kriskowal/garden/pull/3#issuecomment-4606949816 summarizing the pivot with explicit citation links to the three feedback items.
- No `resolveReviewThread` mutations executed: the three feedback items (04:08Z and 04:19Z review bodies, 04:10Z top-level issue comment) are not inline review threads. Two inline anchors on the 04:08Z review (the cleaner conjugation note and the design-only-pr-workflow bloviation note) are out of scope per the dispatch brief.

## designs/driver.md diff summary

`428 lines changed; 312 insertions, 116 deletions`. Sections added or substantially rewritten:

- **Summary** rewritten to name driver as a script not a role; lifetime spans many jobs / many PRs; two systemd-managed daemon shapes named upfront.
- **New § Layout pivot: scripts/ at the top level** lays out the `scripts/{driver,watcher/<feed>,daemons,systemd}/` directory tree and the strict split (no executables under `roles/` or `skills/`).
- **New § systemd-managed daemons** covers the `garden-driver@<lane>.service` and `garden-watcher@<feed>.service` templated units, start/stop/status/logs wrappers, self-healing via `Restart=on-failure` plus the gardener-inbox escalation, and dedicated worktrees per daemon.
- **Principle** rewritten to position the driver as a generic worker (`journal/jobs/open/` plus `kind:` discriminator) that delegates judgment-bearing substeps to ephemeral `claude -p` subagents.
- **Architecture § Generic job inbox and the driver pool** replaces the prior per-role-board / per-role-worker design with a single generic inbox + `kind:`-based workflow dispatch. The role-specific job boards are explicitly retired.
- **§ Drivers** rewritten: lifetime is the host's uptime modulo systemd-driven restarts, not one PR. A driver does not exit on PR merge; it claims the next job.
- **§ Activity-feed watcher daemons** renamed and reframed: "one watcher per activity feed" (not one per host, not one per repo). The earlier "coalesced repo-activity watcher" framing is recast as one watcher per feed.
- **§ What changes / New artifacts** restructured into `scripts/` (executables + human-oriented READMEs + systemd units) and `skills/` (agent context); explicit "Retired / superseded" block names the prior-iteration artifacts the new layout supersedes.
- **§ Modified artifacts** updated to mention `scripts/` and remove the per-role-board generalization of `skills/job-board/SKILL.md`.
- **§ Migration plan** revised: phases 1-3 keep manual launch; phase 4 promotes drivers and watchers to systemd-managed once ≥95% per-workflow reliability is shown; phases 5-6 retire scans and roll out to other repos.
- **Open questions** Q1, Q3, Q7, Q9 updated to reflect the systemd shape; the manual-invocation form is preserved as the ad-hoc / migration-period mode. Q5 and Q10 still open per the 2026-06-01 review.
- **Non-goals** extended with two new bullets: no physical file moves in this dispatch, and no `driver` role row in the `CLAUDE.md` inventory (the `scripts/` top-level directory is mentioned instead).

Updated frontmatter: `Updated: 2026-06-02`, `Author: gardener, fixer, designer`.

## Top-level PR comment body

The body posted to https://github.com/kriskowal/garden/pull/3#issuecomment-4606949816 covers the three feedback items in turn with explicit URL citations, plus the migration-plan revision, plus the explicit list of what this dispatch did not do (no file moves, no cleaner conjugation fix, no driver/ or driver-*/ touches, no shellcheck). It is intentionally long because the pivot is structural and the document changed substantially; the maintainer should see the shape of the pivot from the comment alone without having to re-read all 638 lines.

## Per-review-thread replies and resolveReviewThread

The dispatch brief named replies "to each of the three threads (04:08Z, 04:10Z, 04:19Z)". On inspection, none of the three feedback items has a threaded inline-comment surface:

- 04:08Z review (`PRR_kwDOSbvhZc8AAAABBqRhCQ`) has a review body plus 2 inline comments on `skills/cleaner/SKILL.md` and `skills/driver-design-only-pr-workflow/SKILL.md`, both out of scope per the dispatch brief. The review body itself is not threadable via `pulls/<N>/comments/<id>/replies`.
- 04:10Z issue comment (`IC_kwDOSbvhZc8AAAABEhm4Ig`) is a PR-level issue comment; the issue-comments API has no reply endpoint.
- 04:19Z review (`PRR_kwDOSbvhZc8AAAABBqV01A`) is a review body with no inline anchors.

The conventional reply mechanism for review-body and issue-body feedback is a top-level PR issue comment that cites each item by URL and addresses each in turn. That is what `issue-comment#4606949816` does. No `resolveReviewThread` calls are appropriate (no inline threads in scope), and `CHANGES_REQUESTED` stays on both 04:08Z and 04:19Z reviews until kriskowal re-reviews, per the dispatch brief's "just reply to acknowledge the design pivot".

## Deviations from the four-bullet articulation

None substantive. Two small framings:

- The earlier "coalesced repo-activity watcher" framing (single host-wide process) is reframed to "one watcher per activity feed" per the 04:08Z review's explicit "a single daemon for watching each activity feed". This is a strictly tighter reading of the maintainer's intent; the 22:20Z review's "single process" framing now means single-per-feed, not single-per-host.
- The Q9 disposition is restated to cover both modes (systemd-managed + ad-hoc invocable) rather than rewriting it. The 2026-06-01 ad-hoc-invocation framing is preserved as the migration-period default; the 2026-06-02 systemd framing is the Phase 4+ default. Both shapes apply because they are compatible.

## Authorizations used

- Edit `designs/driver.md`: authorized; only this file modified.
- Regular-append push to `kriskowal/garden:design/driver`: authorized; pushed `5bb23453..b6a1318a`.
- One top-level PR comment plus per-review citations (folded into the single top-level comment per the absence of threadable surfaces): authorized.
- `resolveReviewThread`: not used (no inline threads in scope).

## Out of scope, untouched

- `roles/driver/`, `skills/driver-*/`, `roles/driver/driver.sh`: untouched per the brief.
- `skills/cleaner/SKILL.md` conjugation (04:00Z inline): left for a separate fixer item.
- File moves into `scripts/`: deferred to a follow-up builder/fixer dispatch per the brief.
- shellcheck cleanups: covered by #401.

Self-improvement: nothing this time.
