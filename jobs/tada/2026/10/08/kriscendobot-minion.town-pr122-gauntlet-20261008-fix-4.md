# Gauntlet fix round 4 — kriscendobot/minion.town PR #122

I applied the round-4 panel's fixes and pushed them. CI is green on the new head `bd10084` (3 of 3 checks).

**What I changed** (two follow-up commits on top of `d582a38`, pushed with `safe-push-pr-head.sh --mode advance`):

1. **`7d23bf5` refactor(claude-harness): spell out gpg and signed-manifest names** (stylist)
   - **Must-fix:** in `runGpg`, renamed `home` to `homeDirectory` and `argumentsArray` to `gpgArguments`.
   - **Should-fix:** renamed `checkReleaseAgainstUpstreamManifest({ release, upstream })` to `checkReleaseAgainstSignedManifest({ release, signedManifest })`. The rename covers `release-verifier.mjs`, `check.mjs` and the tests, plus the comment wording.
   - **Test helpers:** `validSig` became `validSignatureStatus` and `makeUpstreamManifest` became `makeSignedManifest`.
   - I did not rename `parseArguments(argumentsArray)`. That code existed before this PR, and the stylist said so.
   - `node --test`: 42/42 pass. `check.mjs` passes.
2. **`bd10084` refactor(deploy): share Node 22 tarball and checksum resolution** (decomplector should-fix)
   - Added one `resolve_node22_arm64` helper to `deploy/aws/scripts/common.sh`. It sets `NODE_FILE`, `NODE_URL` and `NODE_SHA256` from one strictly matched `SHASUMS256.txt` line.
   - `deploy-app.sh`, `deploy-npm-registry.sh` and `deploy-endo-daemon.sh` now all call it instead of keeping three different copies.
   - `deploy-endo-daemon.sh` now checks the Node download with `sha256sum -c` before unpacking it as root, as the other two scripts already did. This changes how the endo daemon deploys Node.
   - `bash -n` passes on all four scripts. The helper resolved `node-v22.23.3-linux-arm64.tar.xz` and its digest when I ran it against nodejs.org. Shellcheck shows only the "variable appears unused" warning (SC2034) on the helper's exported variables, the same warning `common.sh` already gets for its other shared variables. I have not run a real deploy with the helper.

**Not changed:** the archivist must-fix is a false positive, as triage said. `signingKeyFingerprintCompact` is defined and exported at `release-verifier.mjs:28`.

**Follow-ups:** none from this stage. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (985571 cached reads)
- Output: 6966 tokens
- Cost: $0.8844902
- Wall-clock: 379s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
