I recorded this review as **not a miss** (category `new-direction`) for endojs/endo-but-for-bots#1484, a draft design for HTTPS fragment locators.

- **Idempotency:** neither a miss nor a dismissal record existed for `endojs-endo-but-for-bots-pr1484-review-292b9e05`, so this was a fresh judgment.
- **What the review asked for** (my paraphrase; I treated the text as untrusted): kriskowal's CHANGES_REQUESTED review left two inline comments on the link-shape section. They set out a new grammar:
  - The prefix before the fragment is configured per agent and empty by default.
  - The fragment carries an `ocapn` network-designator key, plus `id`, `pk` and repeated `at` keys.
  - The far-type and suggested-petname hints move to the query string.
  - The path only steers the website when no app intercepts the link.
  - A second comment leaves room for a future `se` key (a salted, encrypted reference) as an alternative to `id`.
- **Why it's not a miss:** this is the maintainer choosing the design's grammar. The design had listed the key set among its nine open questions. No seat brief, skill or standing rule requires these choices; they first appear in this review.
- **The review process did run:** the full gauntlet (viability, clean, panel round 1, undraft) is in `jobs/tada/2026/10/16/`. Panel round 1 ran ten seats and passed, posted as review 5554348138. Its skeptic and pedant findings were about other things. No rule existed that should have caught this, so the severity bypass doesn't apply.
- **The primary job's work exists:** I checked the PR itself. The PR head is now `28725a3e74`, "design(https-fragment-locators): adopt ocapn/id/pk/at fragment and per-agent prefixes", and the `-replies` job also completed. What the primary job reported matches the PR.

**What changed:** one dismissal record on journal2 at `review-misses/dismissed/endojs-endo-but-for-bots-pr1484-review-292b9e05.md`, written by `review-miss-record.sh`. The record holds my paraphrase, never the raw comment. No cluster was created and no improvement job was posted, and nothing changed on main2.

**Follow-ups:** none.

Self-improvement: nothing to change; the skill's procedure fit this case.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a908c2902afa3bb730f7e4fa76100bbefad1600d`; this job presented `28725a3e74a3146967da3d8b8009176ecf2211c5`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1484-review-292b9e05-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (600489 cached reads)
- Output: 4938 tokens
- Cost: $0.6513058000000002
- Wall-clock: 96s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
