---
created: 2026-05-15
updated: 2026-06-24
author: gardener
---

# Skill: gap-revealing-build

A build job whose primary deliverable is a structured inventory of gaps in a
tentative design, not a feature implementation. The verb is the maintainer's:
*"probe #N"*. The build attempts to implement the design, stops at every
ambiguity, documents what is missing, and opens a DRAFT PR whose body is the gap
report. The PR stays draft pending design revision; the standard panel / cleaner
/ un-draft gauntlet does **not** run.

In v2 a `probe #N` directive becomes a job a gardener claims (a triager posts it
from the directive); the gardener runs the build under this skill instead of the
normal gardening gauntlet. On a normal `build #N` job the gardener follows
[pr-creation-flow] instead.

The verb's distinct semantics vs *build #N*: `build` produces a mergeable feature
PR (cleaner / panel / fixer-loop / un-draft chain follows); `probe` produces a
DRAFT PR that carries a gap report (no chain follows; the maintainer reads the
report and revises the design).

## When to use

- A maintainer prompt says *"probe #N"*, *"probe the design at #N"*, or *"have a
  builder attempt #N to reveal gaps"*. The verb names this procedure.
- A design PR (or design document) has tentative status. The maintainer wants to
  know whether the design holds up under contact with code, without committing to
  merge an implementation.
- A design names a mechanism that the maintainer suspects is under-specified, and
  an enumerated gap report is more valuable than a polished implementation.

Pre-conditions:

- The design is **reachable in the worktree**. A design PR's branch must be
  checked out (the implementation is stacked on that branch); a design that lives
  only on the project's roadmap branch must be referenced from its file path on
  that branch.
- The job names the base branch. Default base for a probe is the design PR's head
  (stacked PR); the job body may override.
- The job names the verb explicitly. The gardener does not infer probe semantics
  from a design-shaped target; the job must say *probe* (or equivalent) for this
  skill to apply.

## Inputs

- The design's file path on the worktree (e.g. `designs/<slug>.md`).
- The base branch the implementation PR branches off (typically the design PR's
  head; sometimes the project's implementation base on a stacked-PR setup).
- The pre-flight gap list the job body may carry (treat as gap #1, #2, ... in the
  report; the poster's pre-flight observations are part of the deliverable, not
  separate from it).

## Procedure

### 1. Read the design fully

Read the full design file (and any documents it references that the job makes
reachable). Note every place the design says **TBD**, **future**, **open
question**, **hand-waves**, **for further consideration**, or otherwise defers a
mechanism. Each such place is a candidate gap.

Read the design's dependency graph and acceptance criteria sections, if any. A
criterion the design states without naming the mechanism that satisfies it is a
gap.

### 2. Stop at every ambiguity (load-bearing rule)

This is the discipline that distinguishes a probe from a normal build. On a
`build #N` job the gardener makes pragmatic choices and proceeds; on a `probe #N`
job the gardener **stops at every ambiguity** and documents the gap instead of
guessing. The deliverable is the gap inventory; choosing one interpretation and
proceeding past it destroys the very signal the maintainer asked for.

An ambiguity is anything where the implementation cannot be written without
making a load-bearing choice the design does not name:

- The design says "the proxy decides X" but does not say how.
- The design enumerates values for a field but does not name the validation site.
- The design names a policy but does not say what failure mode applies when the
  policy rejects.
- The design names a coexistence behavior with a sibling mechanism but does not
  name the dispatch order.
- Two design sentences imply contradictory shapes for the same mechanism.

When you encounter an ambiguity, do **not** pick one interpretation and proceed.
Write the gap entry (next section) and either:

- Skip the affected code path (leave a `// gap: see PR body §X.Y` comment and
  continue with what is clear), or
- Stop the implementation at that line if the ambiguity is so structural that
  nothing downstream can be written without resolving it.

The job's purpose is to surface the ambiguity, not to resolve it. Resolution
belongs to the design author.

### 3. Write each gap as a structured entry

Each gap takes a fixed four-field shape. Number them sequentially in the order
you encounter them while implementing:

```
### Gap N: <one-line summary>

**Where in the design.** <file:line range, or section heading, or both>.

**Verbatim quote.** > <the design's own words, copied exactly>.

**What's needed to implement.** <one or two sentences naming the load-bearing
fact the design does not provide>.

**Candidate resolutions.**
- **A.** <one-sentence proposal>. Trade-off: <one sentence>.
- **B.** <one-sentence proposal>. Trade-off: <one sentence>.
- **C.** <one-sentence proposal>. Trade-off: <one sentence>.

**Maintainer's call:** design revision | implementation-time choice | needs
broader review.
```

The four fields are load-bearing. The verbatim quote anchors the gap to design
prose the author can search for; *what's needed* lets the author re-read the
design with a specific question; *candidate resolutions* gives the author drafted
alternatives rather than asking them to invent from scratch; *maintainer's call*
tells the author whether the gap blocks the design or the implementation.

Two or three candidate resolutions per gap is the target. One is acceptable when
the design's structure rules out alternatives; four or more is a sign the gap is
actually two gaps and should be split.

### 4. Implement the skeleton where the design is clear

Where the design is unambiguous, write the skeleton: the exo interfaces, the
type-checked function signatures, the wired imports, the package layout, the CLI
verb shape. The point is to *demonstrate* that the parts of the design that are
clear actually compose; this is the second-most-valuable signal after the gap
report itself, because it tells the maintainer "the X part of the design holds
up; only the gaps need revision."

Lockfile churn, conventional-commit messages, and
[pre-pr-checklist](../pre-pr-checklist/SKILL.md) apply normally. The skeleton is real code; treat it that way.

A gap that the job instructed you to *attempt past* (rare, and only when the job
body explicitly named the gap as out-of-scope for this probe) is implemented with
a stub plus a `// gap: ...` comment. The default is to stop at every ambiguity
per § 2.

### 5. Open the DRAFT PR with the four-section body

Open the PR with `gh pr create --draft` against the named base. The title is the
project's conventional-commit shape with the probe nature annotated:

```
<type>(<scope>): <one-line summary> (gap-revealing prototype of #<design-PR>)
```

The body **must** carry four sections in this order. Each section is required
even when empty (write "None." rather than omitting):

```markdown
## Gaps surfaced

<numbered list of structured gap entries per § 3 above>

## Skeleton implemented

<bullet list naming what compiled, passed tests, typechecked: package by
package, exo by exo, function by function. Cite specific commits where useful.>

## Skeleton not implemented

<bullet list naming what was abandoned at first ambiguity. Cross-reference the
gap that blocked each item.>

## Recommendations to design author

<one or two paragraphs naming which gaps the design author should resolve before
implementation can proceed, and which gaps the implementation can resolve at
implementation time once the maintainer authorizes the choice. Treat the
four-field "Maintainer's call" labels as the source of truth and group
accordingly.>
```

Cross-link the design PR (or design document) from the PR body's first line so
the maintainer can navigate between the two.

### 6. The PR stays DRAFT

This is the second load-bearing rule. The probe PR is **not** un-drafted. The
panel, cleaner, fixer-loop, and un-draft chain in [pr-creation-flow] does **not**
apply to a probe. The PR exists as a discussion artifact, not a feature; the
maintainer reads the gap report, revises the design, and either authorizes a
follow-up `build #N` job (which goes through the normal gauntlet) or closes the
probe PR as superseded.

The probe job completes (doin→tada) with a report pointing the maintainer at the
*Gaps surfaced* section; it does not queue a cleaner or a panel step.

### 7. Report back

The job's `tada/<base>` report (≤ 600 words): the PR URL + head SHA, the count of
gaps surfaced (one-line each), the count of skeleton-implemented items, the count
of skeleton-abandoned items. If the build evolved a fixable failure in the
gardening script, note it so the supervising gardener can edit and re-run.

## Output shape

- A draft PR on the named base, titled with the
  `gap-revealing prototype of #<design-PR>` annotation.
- A PR body with the four required sections in order: *Gaps surfaced*, *Skeleton
  implemented*, *Skeleton not implemented*, *Recommendations to design author*.
- One commit per affected package per [retcon](../retcon/SKILL.md)'s grouping
  discipline (the probe's
  commits are not retconed at write time; the implementation is small enough that
  the grouping discipline applies naturally).
- A separate `chore: Update yarn.lock` commit per [yarn-lock-separate-commit]
  when dependencies changed.
- A `tada/<base>` completion report naming the PR number and the count of gaps
  surfaced.

The PR's net diff is *not* the deliverable; the gap report is. A probe whose body
has zero gaps in its *Gaps surfaced* section is a finding in its own right (the
design held up under contact with code); the completion report notes that
explicitly.

## Notes

- A probe is a one-shot job. A second probe on the same design (after revision)
  is a fresh job with a fresh PR, not a fixer round on the prior probe's PR.
- The probe does **not** run the regression-evidence skill against the skeleton.
  The skeleton is not a feature; tests against it pin a contract the design has
  not finalized. If the skeleton has tests at all, they are smoke-level (does it
  import, does it construct) and the gap report explicitly names the testing
  strategy as a future implementation concern.
- The probe is the right shape when the maintainer is choosing between two design
  directions and wants the gap profile of each before committing. Two probes (one
  per direction) is a legitimate use, with the maintainer reading both gap reports
  side by side.
- A normal `build #N` job should *not* opportunistically slip into probe
  semantics when the design feels under-specified. A gardener on a build job
  surfaces impasses via the message bus (to the maintainer or via a posted
  follow-up job) and lets the maintainer decide whether to re-issue as a probe;
  flipping disciplines mid-job destroys the maintainer's signal of which
  deliverable they were getting.

## Notes from the field

- _2026-05-15_: the verb landed when kriskowal asked for a builder to attempt a
  tentative design to reveal gaps, and named both the skill and the orchestrator
  verb in one motion. The companion worked example was a builder attempting an
  OCapN/Daemon-integration design's PR; its pre-flight gap list is the worked
  example of how the gaps are surfaced upfront and folded into the numbered
  inventory.
- _2026-06-24_: migrated into v2. Rewired the dispatch framing: a `probe #N`
  directive is a triager-posted job a gardener claims; the deliverable and the
  draft-stays-draft discipline are unchanged.
