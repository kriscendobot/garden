---
ts: 2026-06-01T22:38:08Z
kind: result
role: fixer
host: endolinbot
repo: kriskowal/garden
project: garden
dispatch_root: /home/kris/dispatches/fixer--f6ddb6
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/01/223200Z-dispatch-steward-f6ddb6.md
  - https://github.com/kriskowal/garden/pull/3
---

# result: fixer — kriskowal/garden#3 driver design review feedback

Amended `designs/driver.md` on the `design/driver` branch of
`kriskowal/garden` to incorporate kriskowal's 2026-06-01 review feedback
on PR #3. PR remains DRAFT. No PR comments posted. No review threads
resolved (per dispatch: thread resolution is for a follow-up maintainer
pass).

## Push

- New head SHA: `4ed88c938091109776aecfecea4d8b08ec0d582d`
- Prior head SHA: `d6efe0d3a0519b9b5a5e9b575e369373fd01c98c`
- Branch: `design/driver` (regular append push, no rewrite, no force).
- Bot identity: `endolinbot` (pinned via worktree-local config).

## Diff stat

```
 designs/driver.md | 191 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 174 insertions(+), 17 deletions(-)
```

`designs/README.md` was not modified. Its index row for `driver.md`
already reads "Proposed"; no cross-reference update was needed because
the design is still the only listed garden meta-design.

## Mapping: comment line → resolution

All eight inline comments by kriskowal converted to verbatim
`**Disposition:**` sub-blocks in the *Open questions* section:

| Comment line | Question | Disposition (verbatim) |
| --- | --- | --- |
| 260 | Q1 Worker pool sizing | "I will manually scale the pool of concurrent drivers." |
| 262 | Q2 Failure modes for LLM | "Exponential backoff with full jitter." |
| 264 | Q3 Observability / per-lane discrimination | "I will manually scale the driver pool. Each driver should be given a lane number when invoking the shell script." |
| 266 | Q4 Credentials and identity | "Nothing to change here." |
| 270 | Q6 State machine determinism | "Fine." |
| 272 | Q7 Relationship to standing monitors (now: standing monitors and coalesced watcher) | "This new workflow is experimental and existing systems should be preserved." |
| 274 | Q8 Liaison and steward retention | "We will keep these for now and dispatch through the drivers manually until that system is reliable." |
| 276 | Q9 Driver supervisor | "I am going to invoke the driver manually, like `roles/driver/driver.sh 1` for driver one. It should be bot supervised in the sense that it will trap all errors and report them to the gardener, with a transcript of the failure. This may require subshelling with `-x` so that there's an artifact to submit to the gardener." |

Q5 (Tooling boundaries) and Q10 (Capture blob lifecycle) had no
disposition in the review; both are explicitly labeled `**Status:**
Open.` in the document.

## Top-level review themes folded in

All seven top-level themes from kriskowal's COMMENTED review body
(submitted 2026-06-01T22:20:01Z, review id 4405013425) landed as new
H3 design sections under *Architecture*:

1. **Errors → gardener inbox.** New section *Error reporting to the
   gardener inbox*: uniform trap pattern, per-lane discrimination via
   message header, transcript SHA via `git hash-object -w --stdin`,
   `inbox-drain` skill drains.
2. **Coalesce repo activity watcher.** New section *Coalesced
   repo-activity watcher*: single per-host process reading union of
   driver subscriptions (`journal/drivers/<host>/<lane>.subscriptions`),
   appending events to per-PR event logs.
3. **Multi-job-kind drivers.** New section *Multi-job-kind drivers*:
   six job kinds enumerated (PR-creation, observed-error response,
   issue response, build request, design request, retcon / rebase).
4. **Deterministic reactji posting.** New section *Deterministic
   reactji posting*: coalesced watcher owns the eyes reactji
   immediately on new comments, records reaction SHA to prevent
   double-posting.
5. **Deterministic worktree lifecycle.** New section *Deterministic
   worktree lifecycle*: prepare and teardown scripts called directly
   by driver / worker bash, not from inside an Agent LLM context.
6. **Driver-run pre-CI validation.** New section *Driver-run pre-CI
   validation*: deterministic six-step gauntlet (`yarn format`,
   targeted tests, `yarn build:types:check`, `yarn lint`, full
   tests, docs generation) before push.
7. **Role-specific driver workflows.** New section *Role-specific
   driver workflows*: per-workflow state machine fragments
   (PR-creation, issue-response, build-request, design-request,
   retcon / rebase) referenced via per-workflow skill files;
   classification by inference where deterministic predicate is
   infeasible.

## Migration plan changes

Rewritten preamble names the migration as experimental with existing
systems (steward scan, contractor slots, standing monitors) preserved
throughout. Drivers run alongside, not instead of. Five-phase plan
replaced by six-phase plan with explicit ≥95% per-workflow reliability
gate plus explicit maintainer sign-off before any system retires.
Reversibility is explicit: existing systems remain authoritative so
absorbing a failed phase requires no per-PR coordination. Modified
artifacts section reframed: steward / contractor / monitor preserved
through migration; retirement deferred to per-system maintainer
decisions in Phase 5+.

## Q9 (driver supervisor) tightening

The *Drivers* architecture subsection now names the manual
`roles/driver/driver.sh <lane>` invocation pattern (kriskowal verbatim).
Q9 disposition spells out:

- Subshell run with `-x` so every command and argument lands in a
  transcript file.
- `trap ... ERR EXIT` with discrimination on `$?`.
- Trap captures transcript via `git hash-object -w --stdin` then
  appends a section to `journal/inboxes/<host>/gardener.md` with
  lane header, PR, state, transcript SHA, one-paragraph context.
- Manual restart policy (no supervisor process).

New artifact `roles/driver/driver.sh` lands in the *New artifacts*
list.

## Local verification

- File parses as markdown (no broken fences, code blocks balanced,
  list nesting consistent).
- Open-questions section reads coherently: Q1 through Q4, Q6 through
  Q9 carry verbatim disposition sub-blocks; Q5 and Q10 carry explicit
  `**Status:** Open.` markers.
- All eight inline-comment dispositions cite the
  `kriskowal, 2026-06-01` provenance.
- Em-dash count unchanged (single pre-existing instance at line 41;
  no new em-dashes in fixer-authored prose, per
  `garden/skills/em-dash-style/SKILL.md`).
- Frontmatter updated: `updated: 2026-06-01`, `author: gardener, fixer`.

## PR-side confirmation

- No comment posted on PR #3 (per dispatch's *Not authorized*).
- No review thread resolved (per dispatch's *Not authorized*).
- PR remains DRAFT (per dispatch's *Not authorized*).
- No other PR or branch touched.

## Authorization scope adherence

- `designs/driver.md` edit: within scope.
- Commit + regular append push under bot identity (`endolinbot`):
  within scope.
- No `roles/`, `skills/`, or `journal/` source modifications: within
  scope.

Self-improvement: nothing this time. The dispatch brief was explicit
about the inline comments, the top-level themes, and the migration-plan
direction, so the fixer's work translated the brief into the document
without scope ambiguity.
