Both hand-offs are delivered. The shepherd job is complete: this is a hard-escalation impasse (repo-wide lint-infra, out of scope for the refactor), surfaced with a clear hand-off and a concrete follow-up job. I did not touch #590's branch and did not comment on the PR (no authorization in the job).

---

## Completion report — shepherd on endojs/endo-but-for-bots PR #590

**Live CI state:** One failing check — root `lint` (`eslint .`). All other 20+ checks (build, tests across Node 22/24, xs, hermes, browser, coverage, etc.) pass. PR is `MERGEABLE`, not conflicting.

**Diagnosis:** The `lint` failure is 9 parsing errors, all on the alphabetically-last packages `packages/where/**` and `packages/zip/**`:
> `Parsing error: ESLint was configured to run on <...>/packages/where/... using parserOptions.project: ... none of those TSConfigs include this file.`

This is the known **typescript-eslint program/projectService scaling ceiling**, not a defect in #590's diff:
- **Deterministic** across 2 lint re-runs (I re-ran the failed job — not a flake).
- `where`/`zip` are **not in #590's 100-file diff**; the PR touches no tsconfig/eslint config.
- Base `master@eecc68` whole-repo lint is **green**; #590 (based on it) fails.
- The **identical** `where`/`zip` tail-drop hit #581 yesterday with a completely different big diff — size-driven, matching `reference_endo_lint_projectservice_scaling_ceiling`.
- `tsconfig.eslint-full.json` globs `**/*.js|ts` (covers where/zip) — so it's not a glob gap; the whole-repo TS program just fails to hold the entire file set and drops the tail.

**Action taken (no changes to #590):** Per the maintainer norm (lint-infra scope, don't bundle into a refactor) and changeset discipline, I did **not** modify #590's branch and did **not** comment on the PR (job carried no comment authorization). I:
1. Posted a dedicated lint-infra fix job: **`endo-but-for-bots-lint-projectservice-ceiling`** (candidate remedies: switch to `projectService` with adequate `maximumDefaultProjectFileMatchCount`, or shard the whole-repo lint, or raise the program-size limit; acceptance = `eslint .` parses all packages incl. where/zip).
2. Delivered an escalation to the maintainer inbox via the liaison.

**Classification:** `next: liaison` — repo-wide lint-infra / structural decision; the gardener must **not** auto-advance to a fixer on #590's branch (the fix does not belong there).

**Follow-up:** Once the infra fix lands on master, #590 (and #581 if still open) go green on rebase. No further shepherd action is possible on #590 until then.
