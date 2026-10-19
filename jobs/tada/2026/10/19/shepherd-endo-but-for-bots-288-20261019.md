---
handed-off: retarget-endo-but-for-bots-288-base-20261019
deliverable-complete: false
---
# Shepherd report: endojs/endo-but-for-bots#288 (`@endo/cbor-frame`)

**CI is green on the new head `3ee08149e`:** 24 checks passed, 10 skipped, 0 failed. That includes the previously red `test (24.x, ubuntu-latest)`, now passing: https://github.com/endojs/endo-but-for-bots/actions/runs/39264227991/job/118099684464

The PR's base is still `llm`, not the frozen `llm-330cf99`. This host's bot token got a 403 when editing the PR, so I posted a job to the endolin host to make that change.

## What I did
- **Rebased onto the current `llm` tip.** The branch was about 2600 commits behind; I rebased `feat/cbors-package` onto `330cf996c` (merge base was `071b102f8`).
  - There were no content conflicts.
  - I dropped the old `chore: Update yarn.lock` commit, ran `yarn install` to regenerate the lockfile, and committed it again as a separate `chore: Update yarn.lock` commit at the tip.
  - The force-push used `--force-with-lease` against the old head `152ecdac1`.
- **Fixed one real failure.** `packages/ocapn/test/netlayer-tcp-cbor.test.js` failed `lint:types` with TS2339 (`echo` does not exist on `EMethods<Required<unknown>>`). Since the PR was written, `llm`'s commit `abb37decc` added typing for remote session presences and moved the sibling syrup and websocket tests onto the typed `makeTestOcapn` helper. I made the same change in the CBOR test, as the commit `fix(ocapn): type cbor netlayer test clients with makeTestOcapn`.
- **Checked locally before pushing:**
  - `cbor-frame` tests: 34 passed.
  - `ocapn` tests: 562 passed in one full run. A second, parallel run of the same command had worker exits in `cryptography.test.js` and `codecs/components.test.js`, files this PR doesn't touch. Those two files passed in all three configs when run alone, and CI is green, so I believe it was local load, though I didn't rerun the full suite to confirm.
  - Lint: no errors. Prettier: clean.

## Follow-ups
- **`retarget-endo-but-for-bots-288-base-20261019`** (pinned to host `endolin-garden-ece02cb4`) runs `gh pr edit 288 --base llm-330cf99`. The frozen branch `llm-330cf99` already exists and points at the tip I rebased onto. Until that job runs, the PR is still based on the moving `llm` branch.
- I didn't post a green-CI summary comment on the PR, for the same 403 reason.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endo-but-for-bots-288-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (1969654 cached reads)
- Output: 11249 tokens
- Cost: $1.1421987999999996
- Wall-clock: 2915s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
