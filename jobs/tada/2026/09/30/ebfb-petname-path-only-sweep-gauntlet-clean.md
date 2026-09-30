The clean stage for PR #1390 is done: I pushed nothing, and CI is green at the current head `065f1344e`.

- **Starting state:** the PR is an open draft (`build/pet-name-path-only` → `llm-8e53cc0`, 178 files changed). When I first checked, the main CI workflow was still running, so this stage wasn't a no-op.
- **Coverage:** I didn't run the full coverage tooling on the touched packages. Given how large the diff is, I checked by hand that the new code paths have tests:
  - The new rejection of a bare string in `namePathFrom` (`packages/daemon/src/pet-name.js`) is tested in `packages/daemon/test/pet-name.test.js:198` and `packages/daemon/test/endo.test.js:8716`.
  - The new string-splitting helper `toPetNamePath` in `packages/agent-tools/src/code-mode/daemon.js` is tested for both its string and array inputs by the new test in `packages/agent-tools/test/daemon.test.js`.
- **Dead code:** none found. The old `NameOrPathShape` and `NamesOrPathsShape` have no references left in the daemon, cli or chat packages. The new argument shapes are used throughout `daemon/src` (77 references).
- **CI:** `ci-wait-merge.sh --no-merge` returned rc=0 with 33/33 checks passing and none failing.

Things for the review stage:
- In `packages/agent-tools/src/code-mode/daemon.js`, `toPetNamePath` splits a string on `/`. That goes against the PR's own rule that a string is "never split on a delimiter". It's a client-side adapter, but the panel should decide whether it's acceptable.
- Some names still use the old "name or path" wording but now take only paths, such as `assertPowersNameOrPath` and the `petNameOrPath` parameters in `packages/daemon/src/host.js`. It's cosmetic, and a rename is review territory rather than cleanup.
- `packages/daemon/src/mount.js:1505` (`listTree`) still turns a bare string into a one-segment path. The PR doesn't touch that file, and it belongs to the platform's readable-tree interface rather than the daemon's, so I left it alone.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 116 tokens (3996683 cached reads)
- Output: 20206 tokens
- Cost: $7.054029800000003
- Wall-clock: 3848s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
