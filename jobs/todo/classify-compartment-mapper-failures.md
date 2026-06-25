# Classify & investigate compartment-mapper's known test failures, then fan out per-class fix jobs (on master)

Wear the **assayer/investigator** role. The `@endo/compartment-mapper` test suite has **known
failures** (recent reports cite "917 pass, **12 known failures** unchanged"). Classify and
investigate them, then **post a job per failure CLASS proposing changes to fix it** — all based
on the **`master`** branch.

## Task

1. **On `master`** (`endojs/endo-but-for-bots` `master`, which mirrors `endojs/endo@master`; sync
   bot-master to upstream master first if drifted), set up `packages/compartment-mapper` and run
   its full test suite. Identify the **known failures** (the ~12 failing/skipped-as-known tests —
   look for `test.failing`, `test.skip` with a known-issue note, or a documented known-failures
   list).
2. **Investigate each failure**: read the test and the code under test, determine the **root
   cause**, and confirm it reproduces on master.
3. **Classify** the failures into **classes** grouped by root cause / category (e.g. "policy
   enforcement edge case", "ESM/CJS interop", "language-for-extension resolution", "archive
   determinism", etc. — derive the real classes from the actual failures, do not invent).
4. **Post a per-class job** (`post-job.sh`, deterministic basenames e.g.
   `fix-compartment-mapper-<class-slug>`) that **proposes changes to fix that class** of failure
   on master — each job naming the failing tests in the class, the shared root cause, and the
   proposed fix direction. These are fix-proposal jobs for other gardeners to claim.
5. Write a **classification report** (the classes, which tests fall in each, root cause, proposed
   fix) — to the journal, and surface a summary through the bulletin (`message-user`).

## Bounds

- Scope to bot repos (endo-but-for-bots master); this is bot-fork work. Investigation is read-heavy;
  the per-class fix jobs are where changes get proposed (one job per class, not per test, to avoid
  flooding). Ground every classification in the actual test/code; do not guess a root cause.

## Definition of done

A classification of compartment-mapper's known failures on master (classes + per-test mapping +
root cause), one fix-proposal job posted per class, and a report surfaced to the bulletin. Report
the classes found, the per-class jobs posted, and any failure whose root cause you could not pin
down. If the "known failures" set differs from ~12, report the actual count.

Posted by the liaison on behalf of the maintainer.
