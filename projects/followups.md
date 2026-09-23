# Follow-up ledger (cross-project index)

The follow-up ledger is the parking lot for jury findings the [judge](../../<garden-root>/roles/judge/AGENT.md) deferred at aggregation time with the `follow-up` disposition. Each ledger entry is one file per `(repo, pr_number)` pair under the relevant project directory:

```
projects/<slug>/followups/<repo-with-dash>--<pr-number>.md
```

The full contract (layout, frontmatter schema, producer rules for the judge, consumer rules for the steward, the merge-trigger rationale) lives on [`<garden-root>/skills/panel-review/SKILL.md`](../../<garden-root>/skills/panel-review/SKILL.md) § Follow-up ledger. This README is the cross-project index and the maintenance-and-curation discipline.

## Why merge is the trigger

A follow-up filed pre-merge is premature: the maintainer may close the PR, reshape it, or address the item directly. Filing on merge is precisely when the follow-up becomes load-bearing — the PR landed and the deferred items are now real debt rather than possible debt.

The maintainer's framing on 2026-05-19: *"Use the journal, but arrange for the follow-up to be revisited automatically by the steward when the PR is merged or its mirror is merged upstream."*

## Producer: the judge

Every panel round that produces any `follow-up`-disposition finding appends to the relevant ledger file. The judge creates the file on first append. The file's `status:` starts at `parked` and transitions to `actioned` (or `dropped`) when the steward picks it up at merge time.

Multiple panel rounds on the same PR all append to the same ledger file. The `last_appended_at:` field bumps on each append; the items list grows.

## Consumer: the steward

The steward's per-cycle survey (in [`<garden-root>/roles/steward/AGENT.md`](../../<garden-root>/roles/steward/AGENT.md) § Parked followup revisit) scans `projects/*/followups/*.md` for `status: parked` entries each cycle and polls each entry's PR (and, when set, its upstream mirror PR) for merge state. On merge:

1. Steward posts an `action-followups` job to `journal/jobs/open/` with the ledger's items inlined as the brief.
2. The job's `eligible_roles:` defaults to `[steward, liaison]`. The claimant dispatches the appropriate role per the recommended-action of each item (builder for follow-up PRs; liaison for issue-filing or design-doc amendments; etc.).
3. The steward updates the ledger to `status: actioned` (or `dropped` if the panel's deferral is no longer relevant), with `actioned_at:`, `merge_event:`, and `actioned_via:` populated.

## Per-project tenants

Each project that hosts garden-authored PRs has its own followups directory:

```
projects/endo-but-for-bots/followups/
projects/endo/followups/                  (created when first follow-up lands)
projects/agoric-sdk/followups/            (created when first follow-up lands)
projects/garden/followups/                (likely empty; the garden's own meta-evolution does not run the gamut)
```

A new project becomes a tenant the first time its judge dispatches produce a follow-up; the directory is created on first append.

## Curation

Ledger files in `status: actioned` or `status: dropped` are archive: they record what was deferred, what merged, and what work the deferral triggered. They are not garbage-collected; a future scholar or merged-PR-feedback-watch can grep them for patterns (e.g., "what kinds of items keep deferring to follow-up across the panel's history?").

Ledger files in `status: parked` for an indefinitely stale PR (one that was closed-not-merged, or that has not seen activity in months) are candidates for the steward to set to `status: dropped` with a reason: "PR closed without merge" or "PR stale for >6 months; deferred items no longer relevant". The dropped state preserves the audit trail without keeping the ledger in the parked-watchlist.

## Composition with the rest of the journal

- The followup ledger is **producer-consumer** between the judge and the steward, with merge as the trigger. The job board is the producer-consumer between any role and any consumer, with the bash poll daemon as the trigger. The two compose: the steward's act of actioning a ledger entry is to post a job; the job-board consumer does the actual work.
- The bulletin (`journal/README.md`) is **maintainer-facing**. The followup ledger is **agent-facing**. The maintainer reading the bulletin sees the PR's "Awaits maintainer review" row; the ledger is invisible until the steward actions it post-merge.
- The merged-PR feedback watch (`<garden-root>/skills/merged-pr-feedback-watch/SKILL.md`) is the gardener's weekly read of maintainer feedback patterns. The followup ledger is the judge's per-PR record of what the panel itself deferred. The two surfaces are distinct: the watch reads what the maintainer said after merge; the ledger records what the panel said before merge that did not get addressed in the PR. Both feed self-improvement, in different directions.
