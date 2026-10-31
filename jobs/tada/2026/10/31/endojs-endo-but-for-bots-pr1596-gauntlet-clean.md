The clean stage for endojs/endo-but-for-bots#1596 found nothing to change, and CI is green. I pushed nothing to the PR.

- **PR:** "fix(exo-npm): preserve minimum version selection". It is still a draft, and its head is `d652db3faa` on the `build/m3-mvs-resolver-reference` branch, against base `llm-9a14ddf`. It changes two files: `packages/exo-npm/src/mvs-resolver.js` and its test file.
- **Coverage:** I ran the resolver's test file under c8 in an isolated checkout of the PR head, and all 14 tests passed. Every line and branch the PR adds or changes is covered, including the new range-matching code and the error for requirements that can't be met. The parts the tests never reach are in older code the PR didn't touch, such as the optional-dependency and offline paths.
- **Dead code:** The PR removes `selectGreatestSatisfying`, and nothing still calls it. `compareVersions` and `parseVersion` are still in use by range matching and the new selection function. I left the doc comments alone: "greatest mentioned minor" is still the correct way to describe this kind of resolver.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0, with all 35 checks finished and none failed.

The local `yarn install` changed only the file mode of `packages/relay-server/src/index.js`. I reverted it, so the checkout has no stray changes.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (896937 cached reads)
- Output: 4744 tokens
- Cost: $0.7327074
- Wall-clock: 222s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
