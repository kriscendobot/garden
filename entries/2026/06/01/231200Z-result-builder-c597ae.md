---
ts: 2026-06-01T23:12:00Z
kind: result
role: builder
host: endolinbot
repo: kriskowal/garden
project: garden
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/01/230000Z-dispatch-steward-c597ae.md
  - https://github.com/kriskowal/garden/pull/3
heads:
  - 661ad78a   # test(driver): mock-garden harness + design-only happy path end-to-end
  - 6267e3d8   # feat(driver): add driver role and driver.sh skeleton
  - b9000def   # feat(driver): add state-machine and error-reporting skills
---

# result: builder -- implement driver from designs/driver.md

## Status

Done. Three commits landed on `design/driver` between base
`4ed88c93` and head `661ad78a`. PR remains DRAFT; no PR comment
posted; no review thread resolved; no other PR or branch touched.

## Files created

```
roles/driver/AGENT.md
roles/driver/driver.sh                                  (executable)
skills/driver-state-machine/SKILL.md
skills/driver-design-only-pr-workflow/SKILL.md
skills/gardener-inbox-error-reporting/SKILL.md
skills/gardener-inbox-error-reporting/report-error.sh   (executable)
tests/driver/lib/mock-garden.sh                         (executable, sourced)
tests/driver/run.sh                                     (executable)
tests/driver/test_skeleton.sh                           (executable)
tests/driver/test_design_only_happy_path.sh             (executable)
tests/driver/test_trap_fires_on_error.sh                (executable)
```

No files modified. No `designs/driver.md` edits (questions surfaced
below rather than self-resolved).

## Test results

```
>>> Running test_design_only_happy_path.sh
=== test_design_only_happy_path: 17 passed, 0 failed ===

>>> Running test_skeleton.sh
=== test_skeleton: 20 passed, 0 failed ===

>>> Running test_trap_fires_on_error.sh
=== test_trap_fires_on_error: 4 passed, 0 failed ===

================================================================
Driver tests: 3 suite(s) passed, 0 failed
```

Total: 41 assertions across 3 suites, all passing.

- `test_skeleton.sh` covers argument validation (missing lane,
  non-integer lane), state-file bootstrap on first run, transcript
  hashing via `git hash-object`, and the gardener-inbox section
  format (lane, PR, state, context, SHA all present; transcript
  blob retrievable via `git cat-file blob`).
- `test_design_only_happy_path.sh` drives the design-only-pr state
  machine end-to-end through seven ticks: `initial -> build ->
  panel -> verdict -> un-draft -> await-maintainer ->
  approved+green -> merged`. Each tick stubs the `gh pr view` JSON
  response and verifies the state-file transition; the un-draft
  side effect is verified via the UN_DRAFT_STUB call log.
- `test_trap_fires_on_error.sh` triggers an unknown-workflow
  escalation and verifies the gardener-inbox section is written and
  the driver parks rather than crashing.

Nothing skipped. The harness is hermetic (uses a temp jail garden;
no real GitHub or origin push touched). To run locally from a
fresh worktree of `design/driver`:

```sh
bash tests/driver/run.sh
```

## Clarifying questions

The maintainer asked for these liberally. Each question names the
design-doc location it relates to.

1. **PR-creation workflow `[initial]` state and the "no PR yet"
   shape.** `designs/driver.md` § Architecture / Drivers (line ~99)
   and § States as predicates (line ~159) describe `[initial]` as
   "a design document exists; no PR yet" and the next step as
   "post `design` job (designer worker)". The Phase-2 simplification
   I shipped assumes the design *file* exists at the moment the
   driver is launched (the maintainer launched it after the design
   was authored), so the `[design]` state is short-circuited. **Is
   this the right shape for Phase 2, or should the driver actually
   post a `design` job and wait for a designer worker even when the
   design file already exists on the worktree?** I picked the
   short-circuit on the assumption that a Phase-2 driver is launched
   *after* a design exists, but that decision should be ratified.

2. **Per-lane state-file location: per-host directory vs. flat.**
   Design § Q3 disposition (line ~327): "The driver's state file
   path: `journal/drivers/<host>/<lane>.md`." I implemented this
   shape. But the PR-tracking state files described elsewhere in
   the doc (§ Architecture, line ~104, "writes its state to
   `journal/drivers/<repo>--<pr>.md`") use a different naming
   convention. **The two coexist (`<host>/<lane>.md` is the
   lane-discrimination file; `<repo>--<pr>.md` is the per-PR file)
   - or one supersedes the other?** I shipped per-lane only; the
   per-PR file is not yet written. Clarification: the per-PR file
   could be a duplicate of the per-lane file (cheap), or a
   different shape (per-PR cross-lane summary).

3. **Workflow inference when `DRIVER_PR` is unset.** Design §
   Multi-job-kind drivers (line ~283) says "When the driver has no
   subscribed PR (a generic worker driver), the entire body is
   job-board-driven." But the Phase-2 plan focuses on the
   PR-subscribed shape only. **For a generic worker driver (no
   `DRIVER_PR`), should it iterate `journal/jobs/*/open/` to find
   eligible work, or should it park silently in Phase 2?** I
   defaulted to `design-only-pr` workflow and a stub job-post on
   no-DRIVER_PR; this is almost certainly wrong for the generic
   worker case, but the design's Phase-2 boundary is fuzzy on
   whether generic workers exist yet.

4. **Phase-2 escalation default behavior.** Design §
   Prompt-on-failure capture pattern (line ~179) and the workflow's
   `escalate:*` directive say claude is invoked with a four-slot
   brief, applies the response, and resumes. But the
   prompt-on-failure-capture skill is named as a separate
   deliverable (Design § New artifacts, line ~239: it's a
   separately-landing skill file). **In the absence of that skill,
   what should the driver do on an `escalate:*` directive?** I
   implemented a placeholder that writes a gardener-inbox section
   and returns "park"; the driver does not advance state and does
   not crash. The unit tests verify this behavior. But it does mean
   a real Phase-2 driver would park indefinitely on any
   non-deterministic verdict (e.g., the first time a real solicitor
   submits a body that does not contain `verdict: approve`). The
   placeholder is testable; the production behavior is not yet
   defined.

5. **Predicate matching against PR JSON: string-grep vs. JSON
   parse.** Design § States as predicates (line ~159) does not
   prescribe an implementation; I used `grep` on the raw JSON
   string for Phase-2 simplicity (e.g., `grep -c 'kriscendobot'`,
   `grep -c 'verdict: approve'`, `grep -c 'APPROVED'`). **Should
   Phase 2 use `jq` for structured parsing instead?** The grep
   approach is fragile (a comment containing the word "APPROVED"
   would false-positive), but the design also says "verdict body's
   content is LLM-classified" so the grep is meant as a fast-path,
   not the authoritative classifier. Confirming the intent: the
   grep is the deterministic short-circuit; the LLM is the actual
   classifier. Clarifying that the grep heuristic is acceptable
   for Phase 2 would be useful.

6. **State-file `last_event_sha` field.** Design § State file
   shape (line ~190 in the state-machine section I just wrote):
   "`last_event_sha: <transcript-sha>   # optional; the most recent
   escalation capture`". I did not implement this field in the
   driver yet; the state file omits it. **Should the driver track
   the last escalation SHA, and if so, where does the SHA come
   from?** Plausible sources: the transcript SHA from the
   gardener-inbox report; the capture SHA from a (future) claude
   escalation. I left it out because the prompt-on-failure-capture
   skill is not yet landed; the field's source is unclear without
   that skill.

7. **State-file `classifications` lookup table.** Design §
   Escalation predicates (`skills/driver-state-machine/SKILL.md`,
   line ~92 of the file I wrote): "the driver keeps a small lookup
   table from SHA to classification under
   `journal/drivers/<host>/<lane>.classifications`." **Confirm the
   file shape and persistence semantics.** Is it a flat key:value
   text file, a SQLite db, an awk-friendly TSV? When is it pruned?
   The design says "identical bodies (identical SHA) reuse the
   prior classification without re-invoking the LLM" but does not
   say how the lookup is encoded. I deferred this to a sibling
   skill PR; the Phase-2 driver does not yet write or read it.

8. **The driver's PATH and binary dependencies.** Design §
   Tooling boundaries (Q5, still open in the doc): "The driver
   invokes `gh`, `git`, `yarn`, etc. directly." The driver as
   shipped invokes `gh` (stubbable via `GH_STUB`), `git` (via
   `git -C "$GARDEN_JOURNAL"`), `sed`, `awk`, `grep`, `openssl`
   (via `post-job.sh`), `mktemp`. **Should `yarn` invocations be
   in the driver itself, or only in `skills/<role>/<role>.sh`
   worker scripts called from the driver?** Phase 2 has no yarn
   call from the driver; the design § Driver-run pre-CI validation
   suggests yarn is run by the driver before push. But pre-CI
   validation is a separate skill (named in § New artifacts), so
   the driver only calls that skill, never yarn directly. I assume
   the latter shape but the boundary is unclear.

9. **Concurrent same-lane re-launch.** What if the maintainer
   launches `roles/driver/driver.sh 1` twice on the same host?
   Both processes will try to write to the same state file
   (`journal/drivers/<host>/1.md`) and to the same subscriptions
   file. **Should the driver acquire a lock (via `flock` on a
   per-lane lock file) at startup and refuse to start if another
   driver holds the lane?** The design § Q1 disposition says "I
   will manually scale the pool of concurrent drivers" but does
   not say how to prevent accidental double-launch. I did not
   implement a lock; the second driver would race the first on
   every state-file write. Should the driver refuse, or should it
   trust the maintainer's discipline?

10. **`journal/drivers/<host>/` initialization.** The directory
    `journal/drivers/` does not exist in the current journal layout
    (verified: `ls journal/drivers/` returns "No such file or
    directory"). My driver auto-creates `journal/drivers/<host>/`
    via `mkdir -p`. **Should the driver commit this directory
    creation back to origin/journal in its first state-file
    write, or should a sibling PR (or a `journal/drivers/README.md`
    landing as part of the next dispatch) initialize the directory
    so the driver's commit is a normal append?** The design does
    not address bootstrap. The mock-garden harness creates the
    directory in jail, so tests do not exercise the
    real-journal-bootstrap case.

11. **Workflow inference when `DRIVER_WORKFLOW` is unset.** The
    `select_workflow` function in `driver.sh` defaults to
    `design-only-pr` when neither the env var nor the state file
    names a workflow. **Is that the right Phase-2 default, or
    should the driver refuse to start without an explicit workflow
    selection?** Refusing would be safer (no risk of running the
    wrong workflow against a source-touching PR) but would require
    the maintainer to always set the env var or pre-seed the state
    file. The Phase-2 simplification I made is probably wrong for
    a real driver; the design § Phase 2 says "Implement the driver
    for design-only PRs" but is silent on what happens when a
    driver is launched against a non-design-only PR.

12. **Test reliability under host-config drift.** The tests pin
    `GARDEN_HOST=mock-host` and use a temp-dir mock journal. They
    do not run against the real garden, so they cannot regress on
    a real driver behavior change. **Should a smoke test be added
    that does run the driver against the real `GARDEN_ROOT` (with
    an explicit `DRIVER_ONESHOT=1` and a dry-run-style flag)?**
    Phase 2 punts; the mock-garden tests are the entire test
    surface. A real-driver smoke test would catch issues the mock
    cannot, but it would write to the real journal.

## Confirmation: no PR-side actions taken

- No PR comment posted on kriskowal/garden#3 or anywhere else.
- No review thread resolved on kriskowal/garden#3 or anywhere else.
- PR #3 remains DRAFT.
- No other PR opened, edited, or closed.
- No other branch touched (only `design/driver` advanced from
  `4ed88c93` to `661ad78a`).
- The push was a regular fast-forward append; no force, no
  rewrite, no `--force-with-lease`.
- No `roles/<other-role>/AGENT.md` was modified.
- No GitHub Actions workflow was touched.

Self-improvement: nothing this time. The dispatch brief was crisp,
the design was well-organized, the test harness shape followed
naturally from the "mock garden" suggestion in the brief, and the
state-machine implementation tracked the design's tables directly.
The clarifying questions above are the meat of the engagement's
deliverable; no procedural improvement to flag.
