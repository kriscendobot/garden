Both asks in review 5273072032 on endojs/endo-but-for-bots#1227 were already resolved on the PR branch; I corroborated each against its concrete artifact before completing as a no-op.

## What the review asked (2 items)

1. **Review body (CHANGES_REQUESTED, @kriscendobot):** "Please revise this to reflect the features landed in Endo for provisioning wake-on-message pins for guests."
2. **Inline comment** on `designs/daemon-guest-bot-incarnation.md` (id 4067487699): "It would be more precise to say append-only rather than immutable. A formula, once written, cannot be modified. The graph can grow and collect unreachable nodes, and is mutable to that extent."

## Corroboration (each ask → artifact)

- **Ask 1 → commit `ae0929f48d`** ("docs(daemon): align guest bot design with landed pins (#1227)"), the current PR HEAD (`head_sha` = ae0929f48d…). It is a 1078-line rewrite that replaces the speculative `bot`-binding design with the landed pin mechanism: `provideGuest(..., { pins })`, the `guestPins`/`hostPins` formula fields, `reincarnateMailboxPins`, and a "Wake on every mailbox delivery" section (file lines 17–217). `designs/README.md` status for this design flipped `Not Started` → **Implemented**. This directly reflects the wake-on-message pin features the review asked to be documented.
- **Ask 2 → commit `ae0929f48d` (Background, lines 46–49) + reply comment 4067898149.** The Background now reads: "Endo's persistent state is an append-only **formula graph**. A formula, once written, cannot be modified. The graph itself can grow as formulas are added, and unreachable formulas can be collected, so describing the graph as immutable would be too strong." This matches the reviewer's requested precision verbatim in intent, and the peer posted an inline reply (id 4067898149) pointing to the same commit.

Both artifacts are committed to and pushed on the PR head branch `design/endo-daemon-guest-bot-incarnation` (`garden-fork/…` ref == PR head_sha). No inline comment other than the one above is tied to this review. Nothing left to change, so no new commit or push was warranted.

## Follow-ups
None. The PR remains an open design PR carrying the `<!-- garden-job: design-endo-daemon-guest-bot-incarnation -->` marker; it is up to the maintainer to re-review / merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-review-5194e7b0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 38 tokens (850888 cached reads)
- Output: 11932 tokens
- Cost: $1.934373 (1 engagement(s) unpriced)
- Wall-clock: 6443s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
