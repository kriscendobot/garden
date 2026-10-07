**Gauntlet stage PANEL, round 3: kriscendobot/minion.town PR #167** ("design: non-interactive root MCP principal for the kriscendobot canary"). The verdict is **must-fix** and is posted to the PR.

**What I did**
- Made an isolated project checkout of the PR head (`kriscendobot/minion.town` `design/root-canary-principal` @ `63ffda6`) at `scratch/project-wt-kriscen-020f70c83ed1-b940c1ca`.
- Ran the panel against the PR's real base commit (`d750b09`, branch `main-d750b09`). The diff changes one file, `designs/root-canary-principal.md`, so the panel chose the design panel (9 seats). I ran it detached with `GARDEN_YARN=npm GARDEN_PANEL_SINGLE_ROUND=1`. It finished with exit 0 and printed `design-panel single-round — must-fix`.
- All 9 seats returned ok: 2 request-changes (skeptic, pedant), 4 comment-only (critic, ergonomist, copyeditor, novice) and 3 approve (decomplector, orthographer, thesaurus).
- Posted the aggregate as review 5449732560 in the same shape as rounds 1 and 2: the header `## Garden panel — round 3 (single-round) — disposition: must-fix` plus the marker `<!-- garden-panel: kriscendobot-minion.town-pr167-gauntlet round=3 disposition=must-fix -->`. GitHub refuses request-changes on the bot's own PR, so it went in as a COMMENTED review, as earlier rounds did.

**Main findings for the fix stage**
- **Skeptic (must-fix):** The recommendation depends on assumption A2, that a second app client on the same Cognito pool and identity provider gets the same `sub` (user ID). If A2 fails, the design only says "return to design", yet § 4 has already rejected every alternative. It needs a fallback decided in advance, for example the attenuated-capability path or a claim-based pre-token-generation approach. The critic raised the same point as should-fix.
- **Critic (should-fix):**
  - Make the refresh-token and scope question a named assumption (A8).
  - Make the revocation drill a gate before arming, not a one-time drill.
  - Have the spike decode a refreshed token, not just the first one, to confirm the 15-minute bound.
- **Pedant (should-fix):**
  - `###` heading capitalization is inconsistent.
  - The "Reachable with this bearer" column in § 2.2 mixes plain yes/no with explanations.
  - Terminal punctuation in the § 2.8 runbook table is inconsistent.

**Changes:** none to the garden repo. The only output is the review on the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (699518 cached reads)
- Output: 3759 tokens
- Cost: $0.6285076
- Wall-clock: 202s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
