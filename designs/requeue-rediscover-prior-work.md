---
created: 2026-08-17
updated: 2026-08-17
author: gardener
---

# Rediscover prior work before a requeued job opens a second PR

| Created | 2026-08-17 |
| Author  | gardener |
| Status  | Stage 1 implemented (marker injection + spine prompt); Stage 2 proposed |

## The incident (2026-08-16)

A requeued job re-opened a pull request that an earlier claimant of the **same
job** had already opened, producing two identical PRs —
`endojs/endo-but-for-bots#999` and `#1000`, both `+28/-4` in one file, both green.
`#999` was closed by hand.

The journal records the exact sequence for job base
`endo-but-for-bots-pin-node-24x-ci`:

```
151da0477f  todo   posted by endolin-garden2-5bcdff64
7c65ae7ae6  claim  endolin-garden-ece02cb4/gardener-2
4611c2ca4a  usage  requeue
2ab03880f4  reap   "transient handler kill" by endolin-garden-ece02cb4
3f25779a52  claim  endolin-garden2-5bcdff64/gardener-1
ea37b5deb3  tada   done endolin-garden2-5bcdff64/gardener-1
```

The claim CAS behaved **correctly** throughout: there was never a double claim,
only a sequential requeue. The first claimant (`ece02cb4/gardener-2`) opened `#999`
and was then reaped ("transient handler kill") before it could complete — it wrote
no `tada`. The requeue re-claimed on a **different host** (`garden2`), which had no
session transcript to `--resume`, so it started clean and opened `#1000`.

Same-host requeue is already covered: `handlers/monk-claude.sh` derives a
deterministic session id from the base and `--resume`s the interrupted transcript
(and the stable per-base worktree carries the uncommitted work forward). A
**cross-host** requeue has neither the transcript nor the worktree, so the
re-claiming worker must re-derive where the job stands from durable state alone.

## The mechanism that already exists (and why it did not fire)

The garden already has a deterministic duplicate-PR converger:
[`scripts/jobs/gardening/ensure-pr.sh`](../scripts/jobs/gardening/ensure-pr.sh).
Before it creates anything it queries open bot-authored PRs two ways — by head
branch, and by a durable body marker `<!-- garden-job: <base> -->` — and adopts a
match instead of opening a second PR. The marker survives a requeue, a different
head branch, and a worker that lost every scrap of local state (it was built for
exactly the earlier `#865`/`#871` duplicate). The `fallback` worker prompt
(`worker-common.sh`) likewise already tells a cross-host re-claim to "inspect
committed history, any PR, and the journal … before redoing it."

So why did `#999`/`#1000` still happen? Because that converger has **one
precondition the incident did not meet: the prior PR must actually carry the
marker.** The marker is written only by `ensure-pr.sh`. A worker that opens its PR
with a bare `gh pr create` — still a documented path for follow-up and stacked PRs
(`skills/frozen-base-branch`, `skills/stacked-pr-build`, `skills/pre-pr-checklist`),
and evidently how the node-24x-ci job opened `#999` — writes **no marker**. Then:

- nothing downstream can rediscover `#999` by marker, and
- the reaper **deletes `work/<base>`** on requeue
  (`reaper.sh:1001`), so the journal PR record (`pr_number:`/`pr_url:`, written by
  `ensure-pr.sh`) does not survive across incarnations either. Across incarnations
  the durable converger is the **on-GitHub marker**, not the journal record — and
  the bare create wrote neither.

The gap is therefore narrower than "add a rediscovery step." A robust rediscovery
step already exists; the defect is that **PR creation is not universally funneled
through it**, so the rediscovery key is missing on the very PRs that need it.

## The fix

Two layers, both at the **worker spine** so every role inherits them, mirroring how
the fleet already moves a "remember to do X" responsibility off the agent and into
the one PATH chokepoint every `gh` call crosses (the identity pin and the
comment-provenance footer both live in `scripts/jobs/bin/gh`).

### Stage 1 — stamp the marker on every `gh pr create` (implemented)

[`scripts/jobs/pr-job-marker.sh`](../scripts/jobs/pr-job-marker.sh), sourced by the
gh wrapper, rewrites a `gh pr create` argv so the created body carries
`<!-- garden-job: $GARDEN_JOB_BASE -->` — byte-identical to `ensure-pr.sh`'s marker,
so `ensure-pr.sh`'s discovery finds it. `$GARDEN_JOB_BASE` is exported by the
handler (`monk-claude.sh:227`), so the chokepoint always knows the base.

This is **add-only and cannot regress any flow**: it injects an invisible HTML
comment, never blocks a create, never changes a rendered byte, and touches only
`pr create`. It is **fail-open** — a non-create, an absent/invalid base, a bodyless
(`--fill`/editor) create, an unreadable `--body-file`, or a body already marked all
pass through unchanged. `ensure-pr.sh`'s own create already embeds the marker, so
the wrapper sees it present and does not double it.

The effect: **every** fleet-opened PR — bare `gh pr create` included — is now
rediscoverable by the mechanism that already exists. This is the enabling
precondition for any rediscovery: you cannot rediscover a PR that was never marked.
It closes the "first PR has no marker" half of the `#999`/`#1000` failure directly.

Alongside it, the shared `worker_worktree_note` (spine, byte-identical across
backends) now tells any PR-opening job to open **only** through `ensure-pr.sh`
(never a bare `gh pr create`), naming the requeue-rediscovery rationale and the
`#999`/`#1000` defect. Prompt guidance is weaker than deterministic enforcement —
which is exactly why Stage 1's marker injection does not depend on it — but it
steers the re-claiming worker to run the discovery half.

Tests: [`scripts/jobs/test/pr-job-marker-test.sh`](../scripts/jobs/test/pr-job-marker-test.sh)
(14 cases: every body form marked exactly once, source `--body-file` never mutated,
idempotent on an already-marked body, fail-open passthroughs, and an end-to-end run
through the real wrapper). Existing wrapper tests (comment-provenance, fail-closed)
still pass unchanged.

### Stage 2 — discover-and-adopt at create time (proposed)

Stage 1 guarantees the marker is **present**; it does not by itself guarantee the
re-claiming worker **queries** for it. If both attempts use a bare `gh pr create`
that skips discovery, Stage 1 makes the duplicate rediscoverable after the fact but
does not prevent it. The complete deterministic prevention is to run the discovery
at the chokepoint too: on a `gh pr create` with a valid `$GARDEN_JOB_BASE`, the
wrapper (or a thin shim it delegates to) runs `ensure-pr.sh`'s marker query first
and, on a hit, **surfaces the existing PR and refuses the create** — "a prior PR
exists, here it is," which is the behavior this defect's brief prefers over silent
duplication.

Stage 2 is left as a proposal rather than built now because it carries real
tradeoffs that Stage 1 does not:

- **False positives.** A job legitimately re-run to open a *second* PR (a follow-up,
  a stacked increment) must not be blocked. Adoption must key on head branch as well
  as base, and needs an explicit escape (e.g. the worker calling `ensure-pr.sh`
  directly with the follow-up's own head, or an opt-out env the wrapper honors).
- **Cost and contract.** It adds a GitHub round-trip to every `pr create` and must
  reproduce `ensure-pr.sh`'s exit-code contract (ambiguous → never guess;
  inconclusive → fail-open to a retry, never fail-closed into a stuck job).
- **Surface, don't refuse silently.** The refusal must print the adopted PR so the
  worker continues against it, not error opaquely.

The cleanest form is to have the wrapper **delegate** to `ensure-pr.sh` (deriving
repo/head/base from the create argv) rather than re-implement its discovery, so
there is one converger. That is a contained follow-up once Stage 1 has been running
long enough to confirm the marker is now universally present.

## Why the spine, not a role playbook

The duplicate can originate from any role that opens a PR (builder, fixer, weaver,
boatman, an ad-hoc gardener). Putting the marker at the gh chokepoint and the
guidance in the shared worker note means every current and future role inherits the
fix with nothing to remember — the same reasoning that put the identity pin and the
provenance footer there.
