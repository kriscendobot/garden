---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
handler-timeout: 7200

Design the conductor as a MERGE QUEUE. The garden itself (design PR on the
roadmap branch; the eventual implementation lands on main2 per CLAUDE.md
Conventions).

MAINTAINER DIRECTIVE (kriskowal, 2026-08-17, liaison session), verbatim:

    We probably need to reprogram the conductor to serve as a merge queue, so
    once something has been handed off to the conductor, it attempts to rebase,
    shepherd, and merge each approved change serially, returning changes with
    nontrivial rebases to a weaver and maintainer for re-review.

THE PROBLEM THIS SOLVES. The conductor today is a per-PR one-shot, and its
merge-time freshness rebase invalidates the maintainer's approval signature.
Three instances in a single session on 2026-08-17:
- https://github.com/endojs/endo-but-for-bots/pull/856 — approved, freshness
  rebase moved the head 40af392 to 4e7b7f95, approval went stale, re-approved,
  merged. Two approvals for one merge.
- https://github.com/endojs/endo-but-for-bots/pull/1000 — approved at 04:11Z on
  head 4dad1282b, a weave rewrote the head to 692f4803 at 04:58Z, approval stale
  again. It was ultimately closed as superseded, so both approvals bought nothing.
- https://github.com/endojs/endo-but-for-bots/pull/282 — the approval predated
  recognition of a design collision, so it was void on arrival.

Each round-trip costs the maintainer attention and produces no new information,
because the rebase was mechanical. The maintainer is the fleet's scarcest
resource; spending their approvals on re-approving patch-identical rebases is the
waste to eliminate.

WHAT TO DESIGN. Serialization is the core idea: if approved changes are merged
one at a time against a trunk that only the queue advances, then each change's
rebase happens at a known point and the "trunk moved under me" churn collapses.
Work out at least:

1. **Handoff.** What it means for a change to be "handed off to the conductor",
   how it enters the queue, and what the queue's ordering discipline is. Consider
   whether ordering should respect existing stacked-PR relationships
   (skills/pr-dependency-topo-sort, skills/stacked-pr-build already model
   dependency order).

2. **The serial attempt loop.** Rebase, shepherd to green, merge, then advance to
   the next. Define what happens when shepherding cannot reach green: does the
   change leave the queue, block it, or get parked? A queue that stalls on one red
   change is worse than the status quo.

3. **The trivial / nontrivial rebase boundary.** This is the load-bearing
   definition and the design stands or falls on it. A trivial rebase preserves
   approval; a nontrivial one returns the change to a weaver and to the maintainer
   for re-review. Propose a concrete, mechanically checkable test. `git range-diff`
   patch-identity is the obvious candidate and has precedent in this fleet: the
   PR-806 merge used range-diff to establish that an approval on an earlier head
   applied to the final head. Say explicitly what counts as nontrivial (textual
   conflict resolution, semantic adaptation, any content change beyond context
   line shifts) and how the check is automated.

4. **The return path.** "Returning changes with nontrivial rebases to a weaver and
   maintainer for re-review" implies a defined handback: the weaver resolves, the
   maintainer re-reviews, and the change re-enters the queue. Design that cycle so
   it cannot loop indefinitely, and so the maintainer can see WHY re-review was
   demanded (a range-diff summary of what actually changed, not just "the head
   moved").

5. **Relationship to what exists.** The conductor role
   (`roles/conductor/AGENT.md`), the gardening state machine
   (`designs/gardening-state-machine.md`), `scripts/jobs/gardening/`, the
   approval-reconciler (`garden-approval-reconciler@`, which auto-posts conduct
   jobs on approval), and `ci-wait-merge.sh`. Say which of these the queue
   subsumes, which it composes with, and whether the queue is a new singleton
   daemon (leader-only, like the foreman and scheduler) or a reshaping of the
   existing conductor job. Note the singleton rule: nothing in the garden handles
   concurrent duplicates, and a merge queue is inherently a singleton per target
   branch.

6. **Failure and recovery.** What happens when the queue's own worker is reaped
   mid-merge. The fleet requeues jobs across hosts, and a half-merged queue state
   must be recoverable. Related in-flight work worth reading first:
   `garden-requeue-rediscover-prior-work` covers duplicated work arising from
   requeues, which a naive queue implementation would be prone to.

Deliverable: a design document opened as a DRAFT PR on the roadmap branch. Do not
implement. Be explicit about what the design does NOT cover, and flag anything
that needs a maintainer decision rather than deciding it yourself. In particular,
the trivial/nontrivial boundary has a policy component (how much change may ride
an old approval) that is the maintainer's call, so present the options with their
risk rather than picking one silently.
