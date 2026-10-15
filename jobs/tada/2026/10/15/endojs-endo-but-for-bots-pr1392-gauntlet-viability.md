PR #1392 should go ahead into the gauntlet (`viability=proceed`). It is still the live pass-style layer of the stack that was renamed to Parcel, and nothing else has replaced it.

**What I checked:** I fetched the PR, its comments and reviews, the related PRs in the stack, and the current `llm` branch. I spent no clean, panel, fix or CI budget.

**PR state:** Open, draft and not merged. The title is now "feat(pass-style): recognize Parcel as passable". The head branch `build/sturdyref-pass-style-recognition` is at `283927ab62`. The base is the frozen branch `build/parcel-ses-accommodation-0f9d0cd`, which comes from SES-layer PR #1391.

Deciding question: Is #1392 still the only live implementation of pass-style recognition in the Parcel stack, and does the Parcel design still call for a `"parcel"` pass style that is passable but not a key or pattern?

Evidence:
- **Design still wants it.** Design PR #1460 (2026-10-14, open) renames the SturdyRef stack to Parcel. It says it "preserves the literal `"parcel"` pass style" and "assigns the rename and behavior change to every layer".
- **The PR follows the design.** On 2026-10-14/15 it was moved from SturdyRef to Parcel: commits `09a1e687f4`, `baa3a4b176` and `283927ab62`, plus a comment confirming the move. The current head is from 2026-10-15.
- **Nothing replaces it.** Neither `packages/pass-style/src/parcel.js` nor `sturdyref.js` exists on `llm`, and `llm`'s `passStyleOf.js` never mentions parcel or sturdy. No other open or closed PR does pass-style Parcel recognition. The neighbouring layers are separate open PRs: #774, #1391, #1393, #1394 and #1396–#1399. The two older sturdyref pass-style attempts, #521 and #737, were closed in favour of this stack.
- **Why it exists still applies.** The maintainer's change request on #695 said sturdyrefs are a new kind of passable, not remotables. The PR description still answers that point.
- **Earlier gauntlet ended without a verdict.** It stopped at `review-budget-reached` after 6 rounds with CI green, on head `b39ee2bdec` on 2026-10-03. The Parcel rework pushed new commits after that, so the new head has never been reviewed.

Follow-up for the fix loop: the PR body still describes the old SturdyRef version (`'sturdyRef'`, `sturdyref.js`, `globalThis.SturdyRef`), so it needs rewriting in Parcel terms. The latest pivot comment also links to the old `sturdyref-agent-api` design rather than to #1460's `designs/parcel.md`.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241284 cached reads)
- Output: 2566 tokens
- Cost: $0.5024407999999999
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
