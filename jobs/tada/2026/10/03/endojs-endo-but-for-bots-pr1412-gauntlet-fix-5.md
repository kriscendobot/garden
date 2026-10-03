Round-5 fixes are pushed to PR #1412 and CI is green. The first CI run went red on one cell; the rerun passed. One thing needs action: nothing will stop the gauntlet from taking #1412 out of draft before #1403 lands (details at the end).

**What changed.** The PR head moved from `b1dd5c8a71` to `0674323ba9` in three follow-up commits, pushed with `safe-push-pr-head.sh`:

- **`0739751d0f` fix(inference)** (to settle at the weave once #1403 lands):
  - The limit enforcer now refuses a fractional or infinite `maxTurns` / `maxOutputBytes` as a caller defect, before any credential is acquired. Before, `1.5` was reported as a backend outage (saboteur, breaker, purist).
  - A turn that has stopped no longer stays referenced from a long-lived `cancelled` promise shared across turns (engine-realist).
- **`273c339109` fix(claude)**:
  - **Turns can't hang any more.** A new `src/turn-guard.js` lets both backends start the wall clock before their first wait. Every wait in a turn now ends when the wall clock or cancellation fires: the version check, the credential `acquire()`, the guest projection, the scratch setup, the CLI exit, and each Agent SDK message. A binary, broker, guest or SDK that never answers no longer holds the turn (or its credential) open. Everything after `acquire()` sits inside the block that releases the credential. A credential or scratch directory that arrives after the turn ended is released or removed. (assessor, saboteur, breaker, engine-realist)
  - **Credentials stay out of failure details.** Once a credential is in scope, the detail names an error by its code or class (`ENOENT`, `Error`), never by its message. The Agent SDK's thrown message is still used to classify the failure, but no longer appears in the detail. A credential containing a NUL byte is now refused without quoting it. (breaker, purist)
  - `lang` is renamed to `language` (stylist). The old `child-env.js` still uses `lang`; I left it alone because this PR doesn't touch that file.
  - New tests cover: a query that ignores abort, a guest projection, version check or credential wait that never settles, a NUL credential, and credential text in thrown messages.
- **`0674323ba9` docs(claude)**: documentation fixes for the archivist, integrator and changeset findings: JSDoc, the design's Status line and #1102 text, README line wrapping, and a new changeset sentence.

**Also done on the PR:**
- Posted the benchmark the benchmarker asked for (issuecomment-5967362935). On one long line with no newline, delivered in 64 KiB chunks, the old decoder's time grows quadratically and the new one's linearly. The new one is 12× faster at 1 MiB and 449× faster at 64 MiB.
- Added two sentences to the PR body:
  - keep the PR in draft until #1403 merges and a weave flattens the stack;
  - #1102 being closed doesn't affect the `InferenceBackend` interface this PR builds on.

**Not changed:** the `acknowledgement` spelling in `packages/inference/SECURITY.md`. That file was deliberately restored word for word from the template in an earlier round. The other comment-only suggestions (property tests, deduplicating tag lists, `E()` consistency, `test:xs`) are also left for later.

**Tests:** `@endo/claude` 151/151 and `@endo/inference` 52/52 pass locally. `tsc`, eslint (warnings only) and prettier are clean.

**CI:** The first run failed one cell, test (22.x, ubuntu). The failure was an unhandled "Termination requested" rejection in `packages/daemon/test/endo.test.js`. `@endo/daemon` doesn't depend on `@endo/claude` or `@endo/inference`, so I treated it as an unrelated flake and reran that job. The rerun passed, and `ci-wait-merge` returned rc 0 with 0 of 33 checks failed.

**Decision needed: keeping #1412 in draft.** The integrator's must-fix is that #1412 stay in draft until #1403 merges. The gauntlet's undraft stage has no way to wait for that, so it will take #1412 out of draft once the panel passes. I asked the maintainer. The proxy's tentative answer is to halt the gauntlet after the panel passes, skip the undraft stage, leave #1412 in draft, and resume once #1403 merges. `gauntlet.sh` has no halt-before-undraft option, so someone has to stop it by hand before that stage runs. A draft hold tied to an open blocking PR is a gap worth tracking separately.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 160 tokens (9891020 cached reads)
- Output: 44420 tokens
- Cost: $4.120332
- Wall-clock: 5356s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
