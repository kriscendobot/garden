Clean stage for endojs/endo-but-for-bots PR #356: no changes were needed, and CI is green at head `18b52cac`.

- **PR state:** open, not a draft. The head branch is `design/gateway-packaging-aws-stack` on the `endojs` repo itself, not a fork. The base is the frozen branch `llm-b1c3f4d`.
- **Idempotence check:** all 26 status checks at the current head completed successfully. `ci-wait-merge.sh --no-merge` returned rc 0 ("CI GREEN", 0 failed).
- **Coverage and dead code:** the PR adds no production source.
  - The diff is mostly design docs under `designs/`.
  - The rest is fixes inherited from the base branch: workflow pin comments, a Node 24 test-runtime pin, `tsconfig.composite.json` files, and a `SECURITY.md` normalization.
  - The one JavaScript change ports a test (`packages/ocapn/test/netlayer-tcp-syrup.test.js`) from `makeClient` to `makeOcapn`.
  - There was nothing new to cover and no dead code orphaned. I made no project checkout and pushed nothing.
- **Follow-ups:** none for this stage. The gauntlet can go on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155171 cached reads)
- Output: 1539 tokens
- Cost: $0.36292620000000003
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
