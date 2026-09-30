I ran round 2 of the review panel on endojs/endo-but-for-bots PR #1360 and posted the verdict. The result is **must-fix**.

- **Checkout:** I made an isolated checkout of the PR head, `endojs/endo-but-for-bots` branch `design/capability-url-locators` at `f52acf66`. It changes one file, `designs/capability-url-locators.md` (+617 lines).
- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's base commit `47f6965d`. It ended with `design-panel single-round — must-fix`. I ran it detached, so I did not capture its exit code; that it printed a disposition line means it finished normally. All 10 reviewer seats returned `ok` and the decision step logged no errors.
- **Checks before the seats ran:**
  - The ownership-map check flagged the design for attention, which put the decomplector seat on it.
  - The PR description is 556 words, over the 300-word limit, which put the pruner seat on it.
  - The PR description matches the repo's template.
  - The related-design check was clear.
- **Seat verdicts:**
  - Request-changes: decomplector, pedant, pruner.
  - Comment-only: critic, skeptic, ergonomist, copyeditor, novice.
  - Approve: orthographer, thesaurus.
- **Main findings:**
  - The design says the https form of the URL needs one less encoding layer, but its own worked example shows the same encoding in both forms.
  - `isCapabilityUrl` returns false for envelope links, which the design itself calls capability URLs. This mixes deciding what kind of URL it is with deciding whether a daemon can adopt it.
  - The design says the fragment is parsed as form-urlencoded, which turns `+` into a space, and elsewhere says only `%XX` escapes are decoded.
  - The `view` field has no length or character limits, and it is counted when comparing two locators for equality.
  - `storeLocator` is widened to accept https URLs, though no trusted caller needs that; it is the path that skips verification.
  - The PR description is too long.
- **Posted review:** GitHub refuses a request-changes review on the bot's own PR, so I posted the full panel output as a COMMENTED review, the same way round 1 was posted. It was submitted at 2026-09-30T12:56:59Z and starts with `## Panel review — round 2 (single-round): **must-fix**`.

I did not fix anything or change the PR's draft status. That is left to the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (689636 cached reads)
- Output: 3344 tokens
- Cost: $0.6348232
- Wall-clock: 231s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
