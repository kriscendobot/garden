# Gauntlet CLEAN stage: endojs/endo-but-for-bots#1642 (`feat/lal-model-command`)

The clean stage is done: I added two tests to cover the paths the PR left untested, and CI is green on the new head.

**Coverage pass (`packages/lal`):**
- The PR adds `model-switch.js` and changes `agent.js` and `inbox-loop.js`. Its own `test/model-switch.test.js` already covered parsing, keeping the auth token with its configured endpoint, host-only recognition, rejected switches, the bare `/model` report, and a real-HTTP `spawnWorkerLoop` run.
- Two paths had no test, so I added one for each:
  - **A failing `/model` command:** when the handler throws, the worker replies `/model failed: …`, dismisses the message, skips the LLM round and keeps the current model.
  - **A provider with only an ambient credential:** `hasAmbientKey` accepts the switch, which also sets `thinkingLevel` to `medium` for a reasoning model.
- **Dead code:** none was orphaned. The `makeWorkerGetApiKey` import that `agent.js` dropped is still used by `model-switch.js`, and the inline `isOllama` was moved into `isOllamaModel` rather than left behind.
- **Local checks:** all 11 ava tests pass, eslint and prettier are clean, and `tsc` for the `lal` package passes.

**Push:** commit `2fc3559056` ("test(lal): cover a failing /model and an ambient-only credential") went to the PR head with `safe-push-pr-head.sh` as a fast-forward from `379dd71d92`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with all 35 checks finished and none failed. The two macOS test legs waited about 40 minutes for runners but passed.

**Follow-ups:** none. The PR is still a draft, and the next gauntlet stage (panel review) picks it up from here.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1642-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1326544 cached reads)
- Output: 6454 tokens
- Cost: $0.9050767999999999
- Wall-clock: 2878s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
