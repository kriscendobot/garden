Round 4 of the review panel on kriscendobot/minion.town PR #167 is done. The verdict is **must-fix**, and it is posted to the PR.

- **Run:** The panel ran in single-round mode on its own checkout of the PR head (`design/root-canary-principal`, `3760c2b`). I compared it against the PR's actual base commit `d750b09` (base branch `main-d750b09`). The only changed file is `designs/root-canary-principal.md`, so the design panel ran (9 seats). `panel.sh` exited 0 with all 9 seats ok: 2 request-changes, 4 comment-only, 3 approve.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/167#pullrequestreview-5449891675. It is headed "Garden panel — round 4 (single-round) — disposition: must-fix", matching the format of rounds 1–3. GitHub records it as COMMENTED rather than request-changes because the bot opened the PR and can't request changes on its own PR. The next stage reads the "disposition: must-fix" header line.
- **Must-fix items:**
  - **Decomplector:** the token helper in § 2.6 caches the token across calls, but § 2.3 says the token never enters a file and the job side keeps no state. A cache that survives between runs has to live somewhere. The suggested fix is to drop the cache and request a fresh token on every call, or else say where the cache lives and change § 2.3.
  - **Pedant:** two consistency fixes. `DEPLOYMENT.md` should be a relative link like the other references, and the inline subtopic labels should use one style (some are bold, some plain with a colon).
- **Worth addressing in the same fix pass:**
  - Simplify the exit-75 / status-file contract for reporting "auth unavailable". Three seats raised this.
  - Make the token-lifetime premise (A2) a must-pass spike step and say plainly that the fallback doesn't meet the goal. Also check that `AdminLinkProviderForUser` actually covers the failure it's listed as repairing.
  - Back up the 15-minute revocation bound, or lower it to 5 minutes.
  - Split `root-canary-revoke.sh --status` into its own script, so a status check isn't one typo away from revoking the token.
  - Define the jargon in § 1 that the novice seat flagged.

Nothing was fixed or un-drafted in this stage, as the job specified.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (592496 cached reads)
- Output: 3639 tokens
- Cost: $0.6442312
- Wall-clock: 183s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
