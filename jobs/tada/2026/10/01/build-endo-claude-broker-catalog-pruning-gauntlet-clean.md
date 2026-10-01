Clean stage for endojs/endo-but-for-bots#1409 (prune the confined tool catalog at the guest broker): nothing needed changing, so this stage was a no-op. CI is green at head `32f76e46`.

- **CI:** `ci-wait-merge.sh --no-merge` returned 0 with 31 checks, none failed. Lint and all four test runs (Node 22 and 24, on Ubuntu and macOS) passed; the remaining checks were skipped by path detection.
- **Coverage:** I reviewed the PR diff instead of running a local coverage tool, and every new code path already has a test:
  - In `src/confined.js`, tests cover the allow-list being frozen, every allowed name being a declared tool, and every declared tool being either allowed or withheld, with none in both. Tests also cover the default and explicit allow-lists in `selectConfinedTools`, its keeping of declaration order, and its ignoring of names nobody declared.
  - For the `startGuestBroker` changes in `src/broker.js`, tests cover the default allow-list end to end. Withheld names are missing from `tools/list` and refused at `tools/call`, and none reached the guest. Narrowing with an explicit `allowedToolNames` is tested, and so is an allow-list that matches no declared tool failing closed.
  - The exports test includes the two new exports.
- **Dead code:** none. The broker now passes the selected subset everywhere it used to pass the full catalog, and nothing is left unused.
- **Changes:** no commits pushed and no project checkout created. The PR stays draft for the later gauntlet stages.

Follow-ups: none from this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-broker-catalog-pruning-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176129 cached reads)
- Output: 1398 tokens
- Cost: $0.4527218
- Wall-clock: 20s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
