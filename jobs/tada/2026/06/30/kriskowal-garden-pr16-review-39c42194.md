The peer confirmed comment 3 is done and stood down. All five review comments are resolved on the branch with inline replies, and the consolidating top-level summary is posted. The work is complete.

---

## Completion report

**Job:** Address kriskowal's CHANGES_REQUESTED review on kriskowal/garden PR #16 (review 4604702628, "Questions answered.") — the whole review: five inline comments, each a maintainer directive resolving a §9 open question in `designs/gardener-reputation-bootstrapping.md`.

**What I found:** This was a fan-out — multiple gardeners claimed sibling per-comment jobs concurrently with my whole-review job. I coordinated over the message bus to avoid double-edits, took the comments still unclaimed, and acted as the review's consolidator.

**What I did:**
- Resolved **comment #2 (duration)** myself: duration is taken **raw, not normalized by fleet load** (the garden is statistically equally busy for most jobs, so contention averages out). Edited the §9 bullet + the §10 measurement-model bullet. Pushed `d328ed0c8` to `design/gardener-bid-accept-market` (rebase-CAS loop through several lost races against peers), and posted the inline reply (`r3502396380`).
- Coordinated comments #1/#4/#5 with peers who had already landed them (`d1f97aa5` dollars, `1b16ac17` consolidator, `f216c5d8` synthetic-replay), and told the peer on **comment #3 (sunk costs)** to keep it — which they did (`fa6739100`, reply `r3502402509`).
- After all five commits + five inline replies were confirmed on the branch, posted the **single consolidating top-level summary** ([issuecomment-4848792153](https://github.com/kriskowal/garden/pull/16#issuecomment-4848792153)) — a table mapping each directive → resolution → commit. Peers explicitly deferred the umbrella summary to me to avoid near-duplicate top-levels.

**State:** All five §9 questions resolved in the design (§9 + §10 Decides/Defers updated); five inline replies posted; PR #16 remains **draft**, pending kriskowal's re-review.

**Follow-ups:** None required. Two small residual sub-questions are recorded in §9 as future tunables (the token-quota dollar-burn-down display; the "contemporary" replay-window width) — design-internal, not review asks. The PR is a design doc still in draft, so no un-draft/judge gamut was triggered.
