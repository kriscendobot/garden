Panel round 5 on kriscendobot/minion.town#168 ("design: clarify, list, and remove a guest's OAuth bonds") came back **must-fix**.

**What I did**
- Made an isolated checkout of the PR head (`kriscendobot:design/guest-oauth-bonds` at `ebbaf22`) and ran `panel.sh` once in single-round mode, with `GARDEN_YARN=npm`, against the PR's base commit `d750b09b30e9`, not the branch name.
- I ran the panel detached from my shell, so I didn't capture its exit code. All 9 seats reported `ok`, the decider logged no errors, and the last line was `design-panel single-round — must-fix`, which only prints on a clean finish. The run is recorded at `panel-runs/kriscendobot-minion.town-168/cad7de572ec1.md`.
- Seat verdicts:
  - **Request changes:** skeptic, copyeditor.
  - **Comment only:** critic, decomplector, ergonomist, pedant, novice.
  - **Approve:** orthographer, thesaurus.
- Posted the full aggregate as a review on the PR: https://github.com/kriscendobot/minion.town/pull/168#pullrequestreview-5450411523. GitHub refused "request changes" because the bot can't request changes on its own PR, so it went up as **COMMENTED**. It has the same `## Garden panel — round N — disposition: must-fix` header as rounds 3 and 4, plus a round/head/disposition marker. It posted exactly once.

**For the next fix round**
- **The must-fix (skeptic #1):** the design only considers removal by someone who stole the bearer. It misses someone who got the bearer back through a compromised recovery sign-in. That person could then delete every other sign-in. The design should either accept this explicitly or restrict removing *other* sign-ins.
- **Should-fix:**
  - Critic:
    - Removal needs a stated compensating control.
    - The reason given for sharing one rate limit is circular.
    - The empty-list message is false while the migration is still running.
  - Skeptic:
    - Spot-check that stored fingerprints were made with the current key.
    - Drain old processes before migrating, or make the step-3 re-run required.
  - Decomplector: prevent the silent re-bond in the *add* flow (always ask which account), instead of the extra machinery in the remove flow.
  - Ergonomist: name the response fields in the UI's words (`addedAt`/`lastUsedAt`, not `bondedAt`).
  - Copyeditor: split the overlong sentences it flagged.

No garden or project files changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (644407 cached reads)
- Output: 4238 tokens
- Cost: $0.6898094
- Wall-clock: 170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
