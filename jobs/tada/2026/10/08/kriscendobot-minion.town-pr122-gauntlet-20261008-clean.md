# Clean stage: kriscendobot/minion.town PR #122 ("fix(security): bind Claude pin to signed manifest")

**Result:** nothing needed changing and nothing was pushed. CI is green at head `8f60883b60f4`.

- **PR state:** draft and open, with base `main-d750b09` and head `kriscendobot:fix-minion-town-claude-harness-supply-chain-hardening`. All 3 checks pass: test, Claude harness (amd64) and Claude harness (arm64).
- **Coverage on the changed code** (isolated checkout `scratch/project-wt-kriscen-d63c9683e74e-932d4dd1`):
  - **`release-verifier.mjs`:** the new `checkReleaseAgainstUpstreamManifest` has a test for every check it makes. Covered cases are a successful match, a wrong version, commit or build date, a missing platform (including `platforms` being undefined), and a wrong checksum or size. `node --test`: 35 of 35 pass.
  - **`check.mjs`:** the new code imports the signing key, checks its fingerprint and verifies the manifest signature with gpg. It runs end to end through `node check.mjs`, which passes locally and in the Claude harness CI jobs.
  - **`refresh.mjs`:** the change only adds copying of the signed manifest and its signature. It runs only when someone refreshes the pin by hand, and it has no logic that could be tested separately.
  - **`deploy-app.sh`:** the Node tarball is now matched with a regex that treats the dots literally, and its sha256 checksum is checked before install. This is a deploy-time shell path with nothing new to unit-test.
- **Dead code:** none. Nothing that existed before became unused, and all the new imports are used.
- **CI wait:** `ci-wait-merge.sh kriscendobot/minion.town 122 --no-merge` returned rc 0 with 3 checks and 0 failed.

There are no follow-ups. The gauntlet moves on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (279893 cached reads)
- Output: 2261 tokens
- Cost: $0.47341459999999996
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
