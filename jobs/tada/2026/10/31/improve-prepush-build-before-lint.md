Completion report: improve-prepush-build-before-lint

The pre-push gate now runs the project's build before lint. The change is pushed to `main2` as commit `bc4384edd84`.

**What changed**
- **`scripts/jobs/gardening/pre-push-gates.sh`:** in auto-fix mode, the order is now format → build → lint-fix → probes → typecheck.
  - The build step picks the first script that exists out of `build`, `compile` and `build:js`, the same order `local-verify.sh` uses.
  - It runs under the same wall-clock and memory limits as the other project-script stages.
  - If the build fails, that is reported and lint still runs, so both results show up in one pass.
- **Build output stays out of the commit:** lint is still the stage that edits files. But the gate re-stages fixes with `git add -A`, which would have picked up anything the build wrote that isn't gitignored. A new `stage_fixes` helper records which paths the build changed (compared with before it ran) and unstages them after each re-stage.
- **Regression fixture** in `scripts/jobs/test/pre-push-gates-test.sh`: a fake runner whose `lint` fails with `Parsing error: generated/types.ts was not found by the project service` until `build` has created that file. The test checks four things:
  - the fake lint really fails on an unbuilt tree;
  - the gate passes;
  - build runs before `lint --fix`;
  - the generated file is not staged.
- **`skills/pre-push-gates/SKILL.md`:** added a "Build before lint" procedure step, renumbered the sections after it, listed build among the resource-bounded stages, and added a 2026-10-31 changelog entry.

**Verification**
- The whole `pre-push-gates-test.sh` suite passes.
- Against the old driver, the new fixture fails with exactly the project-service lint error, so it does catch the bug.
- `shellcheck` is clean on both scripts.

**Follow-ups:** none required. One side effect: build outputs are left in the project working tree, unstaged, after the gate runs. `local-verify` builds the same tree anyway.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-prepush-build-before-lint.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (727715 cached reads)
- Output: 7778 tokens
- Cost: $0.8297110000000001
- Wall-clock: 248s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
