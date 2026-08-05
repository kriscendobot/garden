---
created: 2026-08-05
updated: 2026-08-05
author: gardener
---

# Design: make gauntlet coverage a property of the PR

| Created | 2026-08-05 |
| Author | gardener |
| Status | Proposed |

## Summary

The auto-gauntlet invariant is currently attached to one producer's completion
path. `gardener.sh` calls `auto-gauntlet-handoff.sh` only after a successful job
whose frontmatter says `role: builder`. The hook then discovers a PR URL by
scraping the completion report. A draft PR opened by any other path has no
automatic edge into the gauntlet. A builder can also open a PR hours before its
job completes, leaving a window in which the PR can reach human review before the
completion hook runs.

Add a deterministic, leader-only **PR lifecycle reconciler** over every watched
bot repository. It enumerates open bot-authored, bot-pushable PRs and ensures that
each new draft PR has exactly one per-PR lifecycle record. A feature or design PR
without a record gets a staged gauntlet. A probe gets an explicit exemption
record. `auto-gauntlet-handoff.sh` remains as a fast path and source-provenance
writer, but it is no longer the only enforcement point.

The resulting invariant is:

> Every open PR authored by the garden on a repository and branch it may drive has
> one durable lifecycle record keyed by repository and PR number. The record is
> either an active or completed gauntlet, or an explicit exemption with a reason.

## Evidence from the retrospective set

The consolidated retrospective's phrase "no build/gauntlet/panel job" compresses
different histories. The journal and GitHub timelines show the common failure is
the missing PR-to-gauntlet edge:

| PR | Creation path | What the current edge missed |
| --- | --- | --- |
| [#684](https://github.com/endojs/endo-but-for-bots/pull/684) | `build-endo-daemon-ocapn-ws-transport` pushed a branch and explicitly opened no PR. The PR appeared later. | The build completed on 2026-07-11, before the completion hook landed on 2026-07-18. No later process adopted the PR into a gauntlet. |
| [#806](https://github.com/endojs/endo-but-for-bots/pull/806) | An `ocapn-noise-press-*` job opened the draft PR while repairing a flaky stack. | The job was not `role: builder`, so the role gate in `auto-gauntlet-handoff.sh` excluded it. It was approved and merged with no recorded panel. |
| [#836](https://github.com/endojs/endo-but-for-bots/pull/836) | The implementation PR followed the platform-neutral-hash design, but no build completion report in the journal owns its creation. | Nothing invoked the builder-only completion edge. A later maintainer review had to ask explicitly to run the gauntlet. |
| [#881](https://github.com/endojs/endo-but-for-bots/pull/881) | `build-exo-google-sheets-facets` did own the PR. | The PR opened at 08:02 UTC, human review began at 15:43 UTC, and the build reached `tada` at 17:30 UTC. The completion edge was structurally too late. A gauntlet was posted later, after the missed review opportunity. |

The existing `garden-design-pr-gauntlet-bypass` cluster is one instance of the
same producer-coupling defect. A designer, press driver, fixer, migration job, or
human-assisted recovery can all create a garden-owned PR. The required panel kind
differs, but the obligation to register the PR does not.

## Current failure boundary

The current path is:

```text
builder job succeeds
  -> gardener.sh sees role: builder
  -> auto-gauntlet-handoff.sh scrapes the completion report
  -> the first accepted PR URL passes author and state checks
  -> post-gauntlet.sh creates a record
```

Four properties make it incomplete:

1. **Producer coupling.** Only a `role: builder` completion enters the path.
2. **Completion timing.** PR creation and job completion are separate events. The
   interval can include CI, requeues, review responses, and human review.
3. **Report coupling.** Discovery depends on prose containing one unambiguous PR
   URL. `ensure-pr.sh` already writes a durable `garden-job` marker, but the handoff
   does not use it.
4. **Base-keyed idempotence.** `post-gauntlet.sh` deduplicates on the caller's
   gauntlet basename. Two producers can choose different bases for one PR and
   create two runs, while a PR with no producer creates none.

Draft state is not a sufficient record. It says the PR has not been made ready,
but it cannot distinguish a newly opened feature, a deliberate probe, a halted
gauntlet, and a forgotten PR.

## Proposed model

### One lifecycle index per PR

Add `jobs/pr-lifecycle/<repo-key>/<number>.md` on `journal2`. This is outside the
claim lifecycle, like `jobs/gauntlet/`. Its frontmatter is machine-owned:

```yaml
---
pr: https://github.com/owner/repo/pull/123
repo: owner/repo
pr_number: 123
kind: feature | probe
state: registered | gauntlet-active | gauntlet-complete | exempt | halted
gauntlet: owner-repo-pr123-gauntlet
source_job: optional-job-base
opened_head: full-sha
reviewed_head: full-sha
exemption_reason: probe | imported-before-watermark | maintainer
created_at: 2026-08-05T00:00:00Z
updated_at: 2026-08-05T00:00:00Z
---
```

The repository and PR number are the identity. A CAS add wins registration; a
losing producer reads the existing record and converges on its gauntlet base.
`post-gauntlet.sh` must accept or create this identity record before adding a
gauntlet record. Basename idempotence remains useful for stage jobs, but per-PR
identity becomes authoritative for whether the chain exists.

The gauntlet driver updates `state`, `reviewed_head`, and terminal status when it
advances or finishes. A completed `jobs/tada/<gauntlet>.md` remains the human
report. The lifecycle index is the cheap deterministic lookup that proves which
PR and head the report covers.

### Explicit lifecycle kind at PR creation

Extend `ensure-pr.sh` with `--lifecycle feature|probe`, defaulting to `feature`.
It writes a second body marker next to `garden-job` and registers the lifecycle
record immediately after it finds or creates the PR:

```html
<!-- garden-lifecycle: feature -->
```

Design PRs use `feature`. `panel.sh` already selects a design panel from the diff,
so the lifecycle layer does not need a separate design kind. Probes pass
`--lifecycle probe`; registration writes `state: exempt` and
`exemption_reason: probe`. Dependabot PRs are not authored by the garden and stay
on the botanist path.

Registration failure is a PR-opening failure. The creating job must remain
unfinished so a retry can register the already-open PR through `ensure-pr.sh`'s
find-or-create behavior. This closes the gap before CI or review can consume the
new review surface.

### A reconciler for every creation path

Add `pr-lifecycle-reconciler.sh <repo-slug>` and a leader-only timer beside the CI
and approval reconcilers. Add a metadata-only source handler that uses the same
authoritative paginated REST enumeration pattern as
`handlers/ci-pr-source-gh.sh`, returning number, author, head repository, creation
time, draft flag, and head SHA. Keep it separate from the shared CI source so its
TSV contract does not change under the CI and Dependabot watchers. The reconciler
reads metadata only and sends no external text to an LLM. It may recognize the
exact `garden-lifecycle` marker deterministically; it never copies PR prose into a
job body.

For each PR, apply these gates in order:

1. The base repository is in the existing bot-repository allowlist.
2. The author is `GARDEN_BOT_LOGIN`.
3. The head repository is bot-pushable.
4. A lifecycle record exists, or the PR was created after the rollout watermark.

Then reconcile:

| PR state | Lifecycle state | Action |
| --- | --- | --- |
| draft | absent, post-watermark | register `feature` and post one staged gauntlet |
| draft | registered | post the named gauntlet if it is absent |
| draft | gauntlet-active | no action; `gauntlet.sh` owns progress |
| draft | halted | no action; the halt already alerts the maintainer |
| draft | exempt probe | no action |
| ready | gauntlet-complete | no action; keep `reviewed_head` as audit evidence |
| ready | absent or incomplete | alert and quarantine; do not silently call this covered |
| closed or merged | any | mark terminal on the next reconciliation or retain the completed index as audit evidence |

The reconciler should normally see a new draft after `ensure-pr.sh` has already
registered it. Its value is recovery: same-repo press branches, legacy callers of
`gh pr create`, a creator killed between GitHub creation and journal registration,
and future producer types all converge without each learning the gauntlet handoff.

Do not apply the CI watcher's three-day activity cutoff. An old forgotten draft is
the exact object this watcher exists to find. One paginated REST enumeration plus
local index checks is bounded; only uncovered PRs need further calls or writes.

### Ready PRs fail closed without unsafe bulk re-drafting

The reconciler must not automatically re-draft every ready PR that lacks history.
The garden previously force-drafted PRs #671 and #867 after mistaking citations
for build artifacts. Enumeration fixes the identity error, but a ready PR may
already be under maintainer review or approved. Changing that state behind another
worker remains a coordination hazard.

For a post-watermark ready PR with no completed gauntlet, write `state: halted`,
send one deduplicated maintainer alert, and post no conductor path. A narrow repair
command can then re-draft and resume the recorded gauntlet after checking current
review and worker state. The ordinary path never reaches this branch because new
PRs open draft and register before returning from `ensure-pr.sh`.

`approval-reconciler.sh` and conductor producers must consult the lifecycle index.
An approval does not erase missing gauntlet evidence. They may advance only a PR
whose record says `gauntlet-complete`, or whose explicit maintainer exemption is
recorded. This makes the invariant a gate at both entry to and exit from the review
queue.

## Migration

Roll out without turning the historical open-PR backlog into hundreds of surprise
panels:

1. Land the lifecycle record helpers, `ensure-pr.sh --lifecycle`, and tests.
2. Record a UTC rollout watermark in journal configuration.
3. Start the reconciler in audit mode. Pre-watermark PRs without records get
   `exempt: imported-before-watermark` plus a report, not an automatic gauntlet.
4. Backfill known active gauntlets and probes into the index.
5. Enable enforcement for post-watermark PRs.
6. Make approval and conductor reconciliation require terminal lifecycle evidence.
7. Retain `auto-gauntlet-handoff.sh` for provenance and compatibility, changing it
   to register by PR identity rather than inventing `<build-base>-gauntlet` as the
   authority.

Known uncovered historical PRs, including #684, #806, #836, and the early review
window on #881, should be reported by the audit. Their current state and maintainer
history decide whether to run a fresh gauntlet. Migration must not change them in
bulk.

## Verification plan

Hermetic tests should cover:

- a builder-created draft is registered at PR creation, before job completion;
- a press-created and a designer-created draft receive the same record and
  gauntlet despite having no builder completion;
- two producers racing with different proposed bases create one per-PR record and
  one gauntlet;
- a killed creator is healed by the next reconciler tick;
- a probe receives an exemption and is never un-drafted;
- a design-only diff reaches the design panel through the ordinary feature record;
- a ready uncovered PR alerts once and is not automatically re-drafted;
- an approved uncovered PR cannot produce a conductor job;
- pre-watermark PRs are audited without mutation;
- a completed gauntlet records the reviewed head and satisfies the approval gate;
- transient or partial GitHub enumeration causes a skipped tick, never an empty
  authoritative result.

An integration fixture should create a draft through a non-builder job, run one
reconciler tick, and assert the journal sequence:

```text
jobs/pr-lifecycle/<repo>/<pr>.md
jobs/gauntlet/<repo>-pr<pr>-gauntlet.md
jobs/todo/<repo>-pr<pr>-gauntlet-clean.md
```

No human comment or builder completion should be required.

## Consequences

- Gauntlet coverage follows the artifact that needs review, not the role that
  happened to create it.
- Design PRs, press repairs, migration PRs, recovered branches, and ordinary builds
  share one enforcement path.
- A PR cannot reach conductor merely because it is ready and approved. The journal
  must carry terminal review evidence or a maintainer exemption.
- Probes remain draft by an explicit, auditable exemption rather than a title/body
  heuristic.
- The existing build completion hook becomes a low-latency optimization and
  provenance source. Losing that edge no longer loses the invariant.

The cost is one additional per-repository metadata poller and a durable index entry
per garden-authored PR. That is smaller than repeatedly asking retrospective agents
which seat missed an issue when no panel ran.
