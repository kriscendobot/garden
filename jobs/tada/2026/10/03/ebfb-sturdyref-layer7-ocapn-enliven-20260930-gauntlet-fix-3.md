Round-3 fixes for endojs/endo-but-for-bots PR #1397 are pushed (head `7af07e2320`) and CI is green: all 33 checks finished with 0 failures (`ci-wait-merge` rc 0).

**What I fixed from the round-3 panel:**
- **integrator (the one blocking item):** I rewrote the PR body. It now has every heading from the PR template, including the missing **Documentation Considerations**.
- **pruner:** the body is down to 295 words, under the 300-word guideline. I removed the full tour of all nine layers and kept only the neighboring ones.
- **assessor:** I moved the home-path lookup into a new `enlivenAtHome` helper in `packages/ocapn/src/client/sturdyrefs.js`. The `@jessie.js/safe-await-separator` warning is gone. Just putting the result in a local variable first did not clear it, because the `await` was still inside an `if` block.
- **typist:** the four repeated inline locator types are now one local `SecretLocator` typedef.
- **corner-prober:** I added a test that builds `SturdyRefData` with a `Uint8Array` `objectId` and enlivens it both at the peer and at home. I also added a home case for a secret containing `0x00`.

Locally, all 574 `@endo/ocapn` tests pass, and `tsc`, `eslint` and `prettier` are clean on the changed files. I posted a round-3 response comment on the PR mapping each item to the change.

**Not done:** corner-prober's mutate-the-secret-after-minting test. `makeSturdyRef` keeps the caller's byte array by reference, and this PR doesn't change that. A test would lock in that existing behavior rather than decide whether it is right, so I left it for a separate change and explained why in the PR comment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1818990 cached reads)
- Output: 10057 tokens
- Cost: $1.175714
- Wall-clock: 2233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
