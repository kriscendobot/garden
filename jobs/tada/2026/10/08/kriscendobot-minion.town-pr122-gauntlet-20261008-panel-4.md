Round-4 panel on kriscendobot/minion.town PR #122: the verdict is **must-fix**, posted to the PR as a review.

**What I ran:** I used an isolated checkout of the PR head (`d582a38`) and ran `panel.sh` in single-round mode against the PR's actual base commit (`d750b09`), with `GARDEN_YARN=npm`. I launched it detached so a reap couldn't kill it. It exited 0 with disposition `must-fix`. All 33 seats ran without error.

**Seat tally:**
- **request-changes (3):** stylist, archivist, decomplector.
- **comment-only:** 16 seats.
- **approve:** 14 seats.
- The round-3 blockers did not come back.

**Blockers for the fixer:**
- **stylist (must-fix):**
  - In `runGpg` in `release-verifier.mjs`, rename `argumentsArray` to `gpgArguments` and `home` to `homeDirectory`.
  - Should-fix: `checkReleaseAgainstUpstreamManifest` calls the signed manifest "upstream", unlike the rest of the PR; use one name for it.
  - Should-fix: rename the test helper `validSig` to `validSignatureStatus`.
- **archivist (must-fix): a false positive.** It says `signingKeyFingerprintCompact` is undefined, but it is defined and exported at `tools/claude-harness/release-verifier.mjs:28`. I said so in the review header so the fixer can dismiss it.
- **decomplector (should-fix):**
  - `deploy-app.sh` now has a third, differently shaped copy of the Node 22 resolve-and-checksum code.
  - `deploy-endo-daemon.sh` still installs Node without a checksum check.
  - Suggested fix: one shared `resolve_node22_arm64` helper in `common.sh`, used by all three deploy scripts.

**How it was posted:** GitHub refuses a request-changes review from the bot on its own PR, so the review went up as a comment, the same as rounds 1–3: https://github.com/kriscendobot/minion.town/pull/122#pullrequestreview-5452127651. The full aggregate was 86 KB, over GitHub's 65,536-character limit, so I cut it to 63.9 KB with the blocker summary at the top.

**Follow-ups:** none from this stage. The next fix round should handle the stylist and decomplector items and skip the archivist one. No garden files changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr122-gauntlet-20261008-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (744456 cached reads)
- Output: 4724 tokens
- Cost: $0.6651312
- Wall-clock: 223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
