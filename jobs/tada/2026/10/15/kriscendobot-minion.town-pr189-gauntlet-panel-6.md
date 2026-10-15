Panel round 6 on kriscendobot/minion.town PR #189 ("design(shell): narrow clip iframe embedding to Minion Town") came back **must-fix**.

- **Run:** I ran `panel.sh` in single-round mode against an isolated checkout of `design/clip-iframe-embedding` at head `09624c4`, with base `main-ad0257e`. It exited 0 with disposition `must-fix`. The ownership-map pre-pass flagged ATTENTION, so the decomplector seat was forced on. All nine seats returned a verdict and none errored. The run is recorded at `panel-runs/kriscendobot-minion.town-189/7e5e76fbf219.md`.
- **Seat verdicts:**
  - **Request-changes (2):** critic and copyeditor.
  - **Comment-only (5):** skeptic, decomplector, ergonomist, pedant and novice.
  - **Approve (2):** orthographer and thesaurus.
- **Must-fix items:**
  - **Critic:**
    - §3.6 should cost the alternative of dropping `allow-same-origin` (what breaks: opaque origin, no `localStorage`, WSS `'self'`).
    - The design should name where the clip headers are emitted, so a shared helper can't add both CSP policies to one origin.
    - It should say in advance what happens if a browser honors the old X-Frame-Options `DENY` header over CSP: drop it.
  - **Copyeditor:**
    - Split §3.1 into labelled subsections.
    - Define XFO, COEP, CORP, COOP and "precedence gate" at first use.
    - Make clear what is shipped today versus proposed.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/189#pullrequestreview-5537707539. GitHub refuses request-changes on the bot's own PR, so it went up as a COMMENT review headed "Panel verdict - gauntlet round 6 / Disposition: must-fix", the same shape as earlier rounds.

I made no fixes and did not un-draft the PR. The next fix-loop stage is up to the gauntlet driver.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (463919 cached reads)
- Output: 2223 tokens
- Cost: $0.5294918
- Wall-clock: 137s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
