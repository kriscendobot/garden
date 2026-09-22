Both asks in kriskowal's CHANGES_REQUESTED review (5273072032) on endojs/endo-but-for-bots#1227 are already fully resolved by a peer; I verified this by inspecting the actual PR-head content and the board, not by trusting the preflight hint.

## Corroboration (per-ask)

The PR head is `ae0929f48d36d6f9afd8966fb78e532faa090344`, and its final commit is `ae0929f48` "docs(daemon): align guest bot design with landed pins (#1227)" (dated 00:47Z, after the review's 00:16Z submission; a 244+/848− rewrite of `designs/daemon-guest-bot-incarnation.md`).

1. **Review body** — "revise this to reflect the features landed in Endo for provisioning wake-on-message pins for guests."
   - **Artifact:** commit `ae0929f48` (= PR HEAD). Current file: Status is now **Implemented** (line 8); lines 12–18 state "The daemon primitive this design needs has landed in PR #1306 … `provideGuest(..., { pins })` installs a caller-elected directory as the guest's `@pins` directory," and every mailbox delivery best-effort reincarnates its values. The old `EndoBot`/`GuestFormula.bot`/supervisor proposal is explicitly retired. This is exactly the requested revision.
   - **Acknowledged:** four top-level review-follow-up comments by kriscendobot (02:05Z, 02:26Z, 03:07Z, 03:21Z) each citing `ae0929f48` and the #1306 wake-on-message pins.

2. **Inline comment** on `designs/daemon-guest-bot-incarnation.md` (id 4067487699) — "more precise to say append-only rather than immutable … a formula cannot be modified; the graph can grow and collect unreachable nodes."
   - **Artifact:** same commit `ae0929f48`. Current file line 46–48: "Endo's persistent state is an append-only **formula graph**. A formula, once written, cannot be modified … and unreachable formulas can be collected, so describing the graph as immutable [is imprecise]."
   - **Acknowledged:** threaded inline reply id 4067898149 by kriscendobot ("Addressed in ae0929f48. The background now describes the formula graph as append-only…").

## Outcome

No code/design change and no push were needed — both directives (the review body and the sole inline comment) are satisfied in the PR-head content and each carries a posted reply. Preflight exit 2 (peer resolution present) is corroborated for every ask with named artifacts above.

**Follow-ups:** none for this directive. (The PR remains an open draft; its promotion/merge is separate work not in scope here.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-review-5194e7b0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 11 on 2 host(s) (2 unmetered)
- Input: 164 tokens (3873911 cached reads)
- Output: 54349 tokens
- Cost: $8.3674515 (2 engagement(s) unpriced)
- Wall-clock: 7524s
- Model(s): claude-opus-4-8 ×9

<!-- garden-usage-end -->
