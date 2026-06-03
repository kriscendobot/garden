---
created: 2026-06-01
updated: 2026-06-02
author: builder
---

# Skill: driver-pr-creation-state-machine

The PR-creation workflow's states and transition predicates. The driver
loads this skill on entry to a PR-creation-bound subscription (or when
it claims a job whose `kind:` is `pr-creation`). Each state is a
predicate the driver evaluates against live GitHub state plus its
per-lane state file; each transition is either a deterministic action
(run in-process) or a job-board post (delegated to a role-specific
worker).

This file was renamed from `skills/driver-state-machine/SKILL.md` on
2026-06-02 to fit the per-workflow naming convention introduced by the
[scripts/ layout pivot](../../designs/driver.md) (every workflow lives
at `skills/driver-<kind>-state-machine/SKILL.md`).

For the smaller design-only PR variant (Phase 2 of the migration), see
the sibling skill at
[`skills/driver-design-only-pr-workflow/SKILL.md`](../driver-design-only-pr-workflow/SKILL.md).
This skill defines the larger PR-creation flow; the design-only flow is
a strict subset.

## States

| State                | Meaning                                                                 | Next step                                    |
| -------------------- | ----------------------------------------------------------------------- | -------------------------------------------- |
| `initial`            | A design document exists; no PR yet.                                    | post `design` job (designer worker)          |
| `design`             | Designer worker is in flight on the design doc.                         | wait for designer result; transition `build` |
| `build`              | Builder worker is in flight opening the DRAFT PR.                       | wait for builder result; transition `clean`  |
| `clean`              | PR is OPEN + DRAFT; cleaner worker pending or in flight.                | post `clean` job; on result, `panel`         |
| `panel`              | Cleaner pushed; CI is green; judge worker pending or in flight.         | post `panel` job (barrister/solicitor/justice); on result, `verdict` |
| `verdict`            | A `kriscendobot` review was posted; classify it.                        | classify body → `fixer` or `appellate` or `un-draft` |
| `fixer`              | Verdict has `must-fix-loop` items; fixer worker pending or in flight.   | post `fixer` job; on push, `justice`         |
| `justice`            | Fixer pushed since last panel; justice worker pending or in flight.     | post `justice` job; on result, `verdict`     |
| `appellate`          | Terminating verdict; appellate worker considers promotions.             | post `appellate` job; on result, `un-draft`  |
| `un-draft`           | Run `gh pr ready <n>` deterministically.                                | transition `await-maintainer`                |
| `await-maintainer`   | PR is OPEN + not-DRAFT; wait for a maintainer review event.             | watch reviews; route to `changes-requested` or `approved+green` |
| `changes-requested`  | Maintainer review carries `CHANGES_REQUESTED` or substantive `COMMENTED`. | post `fixer` (source) or `designer` (design-only) job; on push, return to `await-maintainer` |
| `approved+green`     | Maintainer review `APPROVED` and CI is green.                           | post `conductor` job; on merge, `merged`     |
| `merged`             | Terminal.                                                               | exit                                         |
| `closed`             | Terminal (PR closed without merging).                                   | exit                                         |
| `abandoned`          | Terminal (driver was signalled or the workflow gave up).                | exit                                         |

## Transition predicates

Each predicate is a function `predicate_<state>(pr_json, state_file) →
{advance, wait, escalate}`. The driver runs the predicate after every
event tick. Three outcomes:

- **`advance`**: return the next state name plus any side-effect the
  driver should run (in-process action or job post). The driver
  performs the side-effect, persists the new state, and continues.
- **`wait`**: the predicate's preconditions are not yet met. The driver
  persists no state change and continues to the next tick.
- **`escalate`**: the predicate cannot resolve deterministically. The
  driver captures the relevant slice of state via `git hash-object`,
  builds a prompt-on-failure prompt, and pipes it to claude. The
  response is applied; the state machine advances.

### Deterministic predicates

These predicates are pure functions of GitHub state and the state file;
no LLM is involved:

- `initial → design`: a design file exists at `designs/<slug>.md` on the
  fork's design branch; no PR with title matching the design's title is
  open; the `awaits` field is empty.
- `build → clean`: a DRAFT PR exists matching the design's title and
  branch; `awaits` is empty.
- `clean → panel`: the cleaner's result entry has landed; the cleaner's
  push exists on the PR branch; CI is green or the PR is design-only.
- `un-draft → await-maintainer`: `gh pr view <n> --json isDraft` is
  `false` and the un-draft action ran successfully.
- `approved+green → merged`: `gh pr view <n> --json state` is `MERGED`.

### Escalation predicates

These predicates have inputs the LLM is better positioned to classify
than a regex:

- `verdict` classification: the judge's review body is read in full; the
  classification is into `must-fix-loop`, `appeal-ok`, or `approve`. The
  driver captures the body via `git hash-object`, prompts claude with
  the four-slot brief, and applies the returned classification.
- `await-maintainer` event classification: a `COMMENTED` review needs
  judging substantive vs. chatter. The driver captures the body and
  prompts claude.
- Conflict resolution during a `weaver` job: the conflicted-merge state
  is captured; claude is asked for a resolution patch or an escalation
  to maintainer.

The capture-by-SHA pattern means identical bodies hash to the same SHA
and reuse the prior classification. The driver keeps a small lookup
table from SHA to classification under `journal/drivers/<host>/<lane>.classifications`.

## Side effects per state

When a transition fires, the driver performs one of:

| Side effect          | When                                              | How                                          |
| -------------------- | ------------------------------------------------- | -------------------------------------------- |
| Post a job           | `clean`, `panel`, `fixer`, `justice`, `appellate`, `changes-requested`, `approved+green` | `skills/job-board/post-job.sh` with the role-specific verb |
| Run a command        | `un-draft`                                        | `gh pr ready <n>`                            |
| Read a result        | After any posted job lands in `done/`             | Read the worker's `result` entry, extract the result fields, advance |
| Watch for events     | `await-maintainer`                                | The coalesced repo-activity watcher feeds `journal/events/<repo>--<pr>.log` |

## State file shape

`journal/drivers/<host>/<lane>.md`:

```yaml
---
host: <hostname>
lane: <n>
workflow: pr-creation
pr: <owner>/<repo>#<n>
state: <state-name>
awaits: <role>:<job-slug>          # optional; null when none
last_tick: <ISO timestamp>
last_event_sha: <transcript-sha>   # optional; the most recent escalation capture
---

# driver lane <n> state

One paragraph of human-readable context for the maintainer. The driver
updates this body on every state transition.
```

## Pitfalls

- **Predicate evaluated on stale `gh pr view`.** The driver caches the
  PR JSON for the duration of one tick; the next tick re-fetches. A
  predicate that needs fresh JSON mid-tick (rare) calls
  `refresh_pr_json` to force a re-fetch.
- **Job-board lost-race.** The driver may post a job and immediately see
  it claimed by an unrelated consumer. The `awaits: <role>:<job-slug>`
  field is keyed on the job's short-id, which is unique per post; the
  driver's tracking is robust against unrelated claims.
- **Terminal-state thrash.** A PR reopen after `closed` is a separate
  PR-creation event; the driver does not auto-recover. The maintainer
  launches a fresh driver if the work resumes.
