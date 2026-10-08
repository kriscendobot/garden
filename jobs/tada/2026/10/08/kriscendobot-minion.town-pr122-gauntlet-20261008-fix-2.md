# Gauntlet FIX round 2: kriscendobot/minion.town#122

I fixed both blocking items from the round-2 panel verdict (review 5451705069, against head `2fde356`) and pushed. CI is green on the new head `83af6e1`.

**1. The signature check could be fooled by a fake key's user ID (saboteur).** Fixed in commit `83af6e1`, pushed with `safe-push-pr-head.sh` in advance mode.
- Before, the check looked for the text `[GNUPG:] VALIDSIG <fingerprint>` anywhere in gpg's combined output. A second key added to `claude-code.asc` could carry that text in its user ID and pass.
- `release-verifier.mjs` now has two shared checks:
  - `checkSigningKeyring` lists the keys with `--with-colons --list-keys`. It fails unless the key file holds exactly one public key with the pinned fingerprint.
  - `checkValidSignature` matches each status line whole against `^\[GNUPG:\] VALIDSIG ([0-9A-F]{40}) …`. It requires at least one such line, and every one must name the pinned key as its primary-key fingerprint.
- `check.mjs` and `refresh.mjs` both use these checks now, and their `runGpg` reads only gpg's standard output.
- I added 6 unit tests to `release-verifier.test.mjs`. They cover an extra key added to the key file, a wrong fingerprint, the `VALIDSIG` text hidden in a user ID, and a matching subkey under a different primary key. `node --test` passes 41 of 41, and `node check.mjs` exits 0.
- I also re-ran the saboteur's attack with real gpg 2.4.4, using a key whose user ID contains the `VALIDSIG` text:
  - Adding that key to the key file, with or without a forged signature: rejected with "must hold exactly one public key, found 2".
  - A forged signature with the genuine key file: gpg itself fails, so the check stops.

**2. The title didn't mention the Node tarball checksum change (packager, integrator).** I chose to retitle rather than split the PR. The new title is `fix(security): verify signed Claude manifest and Node tarball checksum`. The PR description now marks the Node checksum as a separate hardening on a different trust path, and adds a bullet for the gpg fix.

**CI:** `ci-wait-merge.sh --no-merge` returned 0, with all 3 checks passing after about 4 minutes.

**Not done (should-fix items from the panel, not blocking):**
- `runGpg` is still duplicated between `check.mjs` and `refresh.mjs`, though the two signature checks are now shared.
- `refresh.mjs` does not call `checkReleaseAgainstUpstreamManifest`.
- There is still no clear error telling the user to install gpg when it is missing.
- The signature check still runs only in CI, not when the pinned release is installed or deployed.

I did not re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1248750 cached reads)
- Output: 10533 tokens
- Cost: $0.9890740000000001
- Wall-clock: 420s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
