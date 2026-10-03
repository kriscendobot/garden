I ran panel round 2 on endojs/endo-but-for-bots#1397 and the verdict is **must-fix**.

**What I did**
- Checked out the PR head (`endojs/endo-but-for-bots`, branch `build/sturdyref-ocapn-enliven`, commit `376a462af4`) in an isolated worktree at `scratch/project-wt-ebfb-st-534ae0fdbbac-b429abf3`.
- Ran `panel.sh` in single-round mode against the PR's exact base commit (`b0778fab75`), not the branch name `origin/build/sturdyref-captp-construct-b0778fa`. All 33 seat runs finished with status `ok`, the decision step had no errors, and the script ended with exit 0 and disposition `must-fix`. The run record is at `panel-runs/endojs-endo-but-for-bots-1397/4e404e2591c2.md`.
- Posted the result as a review on the PR (22.6 KB; the full aggregate was 77 KB, over GitHub's ~65 KB limit for a review body). The review contains the full reports from the four seats that requested changes and the four comment-only seats (typist, purist, gateway, fast-checker), plus a list of the seats that approved. GitHub won't let the bot request changes on its own PR, so it posted as `COMMENTED` (the bot's own-PR panel reviews always land that way) at 2026-10-03T06:08:11Z. The body starts with a `garden-panel-verdict: must-fix` header.

**Seats that requested changes**
- **prover:** the `thawedBytes` wrap in `lookupSecretBytes` (from `376a462af4`) has no test that would fail without it. No test sends non-ASCII bytes over the wire and back to the home path.
- **corner-prober:** the byte-passthrough fallback in `lookupSecretBytes` (`sturdyrefs.js:184-195`) may break identity: the locator is no longer called with the same object it was before. No test covers this.
- **scribe:** asks for the round-1 panel review to be closed out properly. The responding commit `376a462af4` says it addresses that review, so this probably means replying on the threads.
- **pruner:** two PR-description problems: an empty "Documentation Considerations" section and an overly long test tally under "Testing Considerations".

Of the comment-only seats, typist suggests a should-fix: use the shared `NonceLocator` typedef instead of repeating an inline locator type, and widen that typedef to accept `Uint8Array`.

I did no fixing and didn't take the PR out of draft. The next gauntlet stage (fix-loop) picks it up from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (696103 cached reads)
- Output: 4382 tokens
- Cost: $0.6716526
- Wall-clock: 648s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
