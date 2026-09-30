**Gauntlet FIX round 1: endojs/endo-but-for-bots#1357 (design: provider-neutral inference and Claude backends)**

I applied the panel's round-1 must-fix item and most of the should-fix items in one follow-up commit. CI is green: all 28 checks passed, `ci-wait-merge.sh` returned rc 0.

**What changed:** commit `3d8974353d`, pushed to `design/endo-claude-inference-backends` with `safe-push-pr-head.sh --mode advance` (7a6d4259cf → 3d8974353d). The edits are all in `designs/endo-claude-inference-backends.md`:
- **critic #1 (the blocking item):** the `ANTHROPIC_API_KEY` row in § Subscription credentials under `--bare` now says it was invalid input. The probe put an OAuth access token in the API-key slot, so the row tells us nothing about how a real API key behaves. Known Gaps now has an item saying a genuine API key under `--bare` is untested. The CLI-vs-SDK table now marks the API-key path as "documented; no genuine key has been tried."
- **critic #2:** the conclusion that "a subscription does not force an unconfined configuration" is now limited to the flags the probe actually used. It names the parts of Decision 3's recipe that were not tested, and notes that no long-lived `setup-token` was tried; gate 6 covers both. The "fully flagged" wording in the Observed-versus-documented table is corrected to match.
- **skeptic #1:** Decision 5's interim delivery now says it was observed only with a short-lived access token, and that the stored `setup-token` has not yet been run through `--bare`.
- **decomplector #2:** the "Persistent state" ownership summary now lists the factory's retained-child ledger.
- **copyeditor #1 and #2:** the ambiguous "they" now reads "the experiments", and "(closure)" is spelled out as a probe showing the model reaches nothing beyond the guest's tools.

**Left unchanged:**
- **pedant:** I declined both heading-case findings. The title-case H2s ("What is the Problem Being Solved?", "Design Decisions", "Known Gaps and TODOs") come from the repo's design template; "Known Gaps and TODOs" appears in 19 design docs. Sentence-case H3s follow the same repo convention.
- **Not taken this round (all should-fix or comment-only):**
  - decomplector #1: move `formulaIdentifier` out of `GuestToolProjection`.
  - skeptic #2: add a verification gate that exercises `cancelled`.
  - ergonomist: move `budget` out from under `limit-exceeded`, and name an `Enricher` type.
  - novice: forward references in § Status.
  - decomplector #3: justify the claim that enrichers compose in any order.

  Panel-2 can raise any of these again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (977803 cached reads)
- Output: 6299 tokens
- Cost: $0.8581645999999999
- Wall-clock: 749s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
