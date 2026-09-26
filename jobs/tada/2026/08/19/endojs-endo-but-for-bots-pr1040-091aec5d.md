All CI checks pass — **0 failing, 0 pending**. Both deliverables of the "Gauntlet and shepherd" directive are satisfied.

## Completion report

**Directive** (endojs/endo-but-for-bots PR #1040, kriskowal): "Gauntlet and shepherd." Preflight returned exit 2 (HINT); I corroborated per-ask and found no peer resolution — the PR still had a single commit, was draft, and had red CI — so I treated it as PROCEED and did the work.

**Shepherd — CI driven to green.** The PR's `lint` and `test` jobs were red. Root cause: the mirror commit excluded `packages/hardened262`'s borrowed test262 `harness/`/`test/` trees and generated `tmp/` prelude from eslint+prettier, but **not** from the two whole-repo TypeScript *programs*. So the generated `tmp/ses-xs-prelude.js` (thousands of type errors) broke "Check the root TypeScript program", and the harness's `$ERROR` test262 global + the same prelude broke `typedoc` ("build API docs" and "Build TypeDoc site").

- Fix (commit `53e694691`): added `packages/hardened262` to the `exclude` lists in `tsconfig.json` and `tsconfig.typedoc.json` — exactly where the sibling borrowed-corpus package `packages/test262-runner` is already excluded. The package keeps its own type coverage via its package-local tsconfig (`lint:workspaces:types`, already green).
- Verified locally: `tsc -p tsconfig.json --noEmit` exit 0 (0 hardened262 files in the program), `typedoc` exit 0.
- Pushed to PR head `kriskowal-hardened262` via `safe-push-pr-head.sh --mode advance`.
- **Confirmed in CI**: heavy `lint` (9m23s) and `test` (6m24s) now pass; **all checks green, none failing, none pending**.

**Gauntlet — routed to its deterministic driver.** No gauntlet record existed for #1040. Posted a staged gauntlet record `endojs-endo-but-for-bots-pr1040-gauntlet` (`post-gauntlet.sh`, feature kind) over the PR. This host is the leader; its `garden-gauntlet` driver (active timer) has begun walking the record — currently `stage: clean`, `current_child: endojs-endo-but-for-bots-pr1040-gauntlet-clean` (running on the board). The driver will carry it clean → panel → fix-loop → un-draft, each stage its own budgeted job (the staged-gauntlet architecture; a single handler must not span the loop).

**Follow-ups / ownership.** The remaining gauntlet stages (panel review, any fix rounds, un-draft) are owned by the durable gauntlet record + driver + future stage gardeners — they will proceed asynchronously and un-draft the PR when the panel passes on green CI. Nothing further is owed from this attention-directive handler.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-091aec5d.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 117 tokens (5758796 cached reads)
- Output: 34935 tokens
- Cost: $4.861052
- Wall-clock: 1211s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
