Fix round 3 for kriscendobot/minion.town PR #122 is pushed and CI is green.

**Must-fix from the panel (integrator):** I squashed the six commits into three. Unlike the order the panel suggested, the manifest commit lands first, because the check needs those files to exist:
1. `247ddd6` chore(claude-harness): add the signed `manifest.json` and `.sig`.
2. `4dfdf64` fix(security): tie the Claude pin to Anthropic's signed manifest. This holds the gpg parsers, tests, README and one DEPLOYMENT.md bullet, and has a full commit message.
3. `d582a38` fix(deploy): check the downloaded Node tarball against its digest in `SHASUMS256.txt`, plus its DEPLOYMENT.md bullet.

`node check.mjs` and all 42 tests pass at each of the three commits, so no single commit breaks the build. That was the problem with the old `d884cf4`, which made `deploy-app.sh` always fail on its own. The literal `\n\n` and the empty commit message are gone.

**Also fixed (stylist must-fix):** renamed the test parameter `fpr` to `fingerprint` and the constant `pinned` to `pinnedFingerprint`.

**Should-fix items, all applied:**
- `check.mjs` and `refresh.mjs` now call one shared `verifySignedManifest({ manifestPath, signaturePath })` in `release-verifier.mjs`, which handles the whole temporary-keyring setup and cleanup. The two copies of `runGpg` are gone.
- The key-listing call now passes `--with-fingerprint`, which gpg 1.x needs.
- `checkValidSignature` now rejects `BADSIG`, `EXPKEYSIG` and `REVKEYSIG`, with a new test.
- The README now says `refresh` copies the signed files into the tree unchanged, rather than regenerating them.
- DEPLOYMENT.md has one bullet for each new failure mode.
- I posted a PR comment summarising the regrouping and what the folded-in fixups had addressed: https://github.com/kriscendobot/minion.town/pull/122#issuecomment-6053064562

**Checks:**
- Real gpg verification passes with both file paths and URLs, and a tampered manifest is rejected.
- The new awk extraction finds the right file and digest in the live Node `SHASUMS256.txt`.
- `refresh.mjs` was only syntax-checked. I didn't run it end to end because that downloads both release binaries.

**Push and CI:** I force-pushed with `safe-push-pr-head.sh --mode rewrite`, moving the head from `83af6e1` to `d582a38`. `ci-wait-merge.sh` returned 0 with all 3 checks green.

**Follow-up:** none from this stage; the driver posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1009828 cached reads)
- Output: 12040 tokens
- Cost: $0.9996535999999999
- Wall-clock: 365s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
