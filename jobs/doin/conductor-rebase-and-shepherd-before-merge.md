---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# designer+builder: the conductor must REBASE and SHEPHERD before every merge

Maintainer directive (kriskowal, 2026-08-12): **the conductor should be rebasing
all changes and shepherding before merge.** Encode it so it holds for the
deterministic spine, not only for an agent reading doctrine.

## Where the gap actually is

`roles/conductor/AGENT.md` ALREADY says this. Step 1 surveys behind/ahead, step 2
rebases onto the current base, step 4 stalls `ci red: needs shepherd`. The doctrine
is not missing.

What is missing is that the **deterministic merge spine does none of it.**
`scripts/jobs/gardening/ci-wait-merge.sh` waits for CI on the head **as it stands**,
unfreezes a frozen-base snapshot, and merges. It never rebases onto the live base
and never re-validates after a rebase. Every caller that uses the spine instead of
hand-driving the loop — including the botanist's new `--dependabot-auto-merge`
path — merges whatever green CI it found on a possibly ancient head.

The evidence is today's dependabot set on `endojs/endo-but-for-bots`: seven PRs
sitting **118–287 commits behind `llm`**, every one CI-terminal-green at its own
head, and `#868` needed a hand rebase before it could be conducted at all. Green at
a stale head says the change worked against a three-week-old trunk.

This matters more as of today: `--dependabot-auto-merge` removed the maintainer
signature from that path. The human who might have noticed "this is 200 commits
behind" is no longer in the loop, so the staleness check has to be mechanical.

`scripts/jobs/gardening/safe-rebase.sh` (commit `b63befa87e`, deployed) already
implements the hard part: fresh base/head ancestry check, replay of reviewed commits
onto the fresh base, the one deterministic lockfile-conflict recovery, and **fail
closed (rc 3)** on any other conflict for a weaver/fixer. It is wired into
`garden-pr.sh`, NOT into the merge spine. Reuse it; do not write a second rebaser.

## THE TRAP — resolve this before writing code

**A rebase changes the head SHA, and `pr-maintainer-approval-gh.sh` requires an
`APPROVED` review on the *current head*.** So "always rebase before merge" as
stated will invalidate the approval it is about to check, and the ordinary
(human-authored) path deadlocks: rebase → approval now stale → merge blocked →
re-request approval → rebase again on the next tick.

This is the crux of the design and it must be settled deliberately, not discovered
mid-implementation. Options to weigh (choose and argue, do not just pick):

- Rebase only when the head is actually behind by more than some threshold, and
  accept a re-approval round-trip when it is.
- Treat a *clean, no-conflict* replay as approval-preserving (the reviewed diff is
  unchanged) and re-verify approval against the pre-rebase head; state precisely why
  that is safe and what it would miss.
- Rebase-then-merge only on paths where no signature is required (the dependabot
  auto-conduct path), and keep the human path stall-and-report.
- Merge-queue semantics: let GitHub do the base-update.

Whatever you choose, the approval invariant must not silently weaken. The whole
point of `pr-maintainer-approval-gh.sh` is that a push supersedes a review; a
mechanism that lets an agent's own rebase preserve a signature is a way to get code
merged under a review that never saw it. Say plainly how your choice avoids that.

## Requirements

1. Before merging, the spine establishes the head is current with the live base —
   rebasing via `safe-rebase.sh` when it is not, failing closed on conflict
   (`needs weave`) rather than resolving on agent discretion.
2. After a rebase, CI is **re-validated on the rebased head**. Merging on a green
   from the pre-rebase head is the exact defect being fixed; a rebase invalidates
   the prior run.
3. Red CI after rebase routes to a shepherd, as red CI does today.
4. The behavior must hold for the botanist `--dependabot-auto-merge` path and the
   ordinary conductor path alike, per whatever the trap resolution allows.
5. Preserve everything the spine already guarantees: the CHANGES_REQUESTED veto,
   unfreeze-to-live, the shared-stack refusal, the stacked-PR branch-retention
   guard, and post-merge state verification.
6. `roles/conductor/AGENT.md` updated so doctrine and spine agree, and
   `designs/gardening-state-machine.md` updated for the new stage ordering.

## Shape of the work

Deliver the DESIGN first (`designs/…md`) covering the trap resolution and the stage
ordering, then implement it. If the design concludes the directive should be scoped
narrower than "all changes" (for instance, exempting a PR already at base tip, or
one whose rebase would require re-approval), say so explicitly and carry the
argument — that is a legitimate outcome, but it is the maintainer's call to accept,
so state it as a recommendation rather than quietly shipping a narrower rule.

## Definition of done

- Design doc written and linked from `designs/README.md`.
- Implementation reusing `safe-rebase.sh`, with regression tests covering: a
  behind-but-clean head, a conflicting head (fail closed), a rebased head whose CI
  goes red, and the approval interaction chosen above.
- Conductor role + state-machine design updated.
- Full test suite green; pushed to `main2`. Note the deploy requirement in the report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T21:18:27Z
