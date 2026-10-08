Panel round 3 on kriscendobot/minion.town#122 came back **must-fix**. I posted the verdict to the PR.

**What I did**
- Made a separate checkout of the PR head `fix-minion-town-claude-harness-supply-chain-hardening` at `83af6e1`.
- Ran `panel.sh` in single-round mode with `GARDEN_YARN=npm`, against the PR's `baseRefOid` `d750b09`. I ran it detached and waited for it in the foreground. All 34 seats returned ok. `panel.sh` exited 0 with `code-panel single-round — must-fix`.
- Posted the verdict as a review: https://github.com/kriscendobot/minion.town/pull/122 (review 5451870106, head `83af6e1`). GitHub won't let the bot request changes on its own PR, so the review shows as COMMENTED. Its body says "Panel verdict — round 3: **must-fix**", the same shape as rounds 1 and 2. The full set of seat write-ups is about 85 KB, which is over GitHub's 65 KB limit for a review. The other 13 seats' write-ups went into a follow-up comment (issuecomment-6052939886).

**Verdict summary**
- **The round-2 blockers are fixed.** The saboteur, warden and spec-keeper seats confirm that the signature check can no longer be spoofed through a key's user ID; the saboteur re-ran the attack against the new code. The new title also covers both changes.
- **Blocking (integrator seat):** the commits need regrouping. The PR lands as a merge commit, so all six commits reach `main`, and `d884cf4` on its own makes `deploy-app.sh` always fail, which breaks bisecting. `d884cf4` also has no message body, and `8f60883` has a literal `\n\n` in its message. Suggested regrouping into three commits:
  - the signed-manifest check, its tests and the README;
  - the Node tarball checksum in `deploy-app.sh`;
  - the refreshed `manifest.json` and `.sig`.
- **Should-fix:**
  - Move the gpg verification steps that are still copied in `check.mjs` and `refresh.mjs` into one shared `verifySignedManifest` (decomplector, integrator).
  - Add `--with-fingerprint` to the gpg key listing so the check also works on gpg 1.x (spec-keeper).
  - Fix the README's "regenerates" wording (archivist).
  - Consider rejecting signatures from expired or revoked keys (assessor, corner-prober).
  - Post a summary comment of what the round-2 fix commits addressed (scribe).

No files changed in the garden repo. This run's notes and output are under `scratch/panel-pr122-r3/` and `scratch/panel-pr122-r3.out`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1002386 cached reads)
- Output: 6354 tokens
- Cost: $0.8622532000000002
- Wall-clock: 241s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
