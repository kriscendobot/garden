Both review asks were resolved by a peer's work already on the PR HEAD; I corroborated each against its artifact and closed the loop with an acknowledgment on the top-level ask.

## Completion report — PR #1227 review 5273072032 (kriskowal, CHANGES_REQUESTED)

**Directive scope** — the review had exactly two asks:
1. **Top-level body:** "revise this to reflect the features landed in Endo for provisioning wake-on-message pins for guests."
2. **Inline** (`designs/daemon-guest-bot-incarnation.md`): "more precise to say append-only rather than immutable... graph can grow and collect unreachable nodes, and is mutable to that extent."

**Preflight** returned exit 2 (HINT: a peer reply exists on the inline thread). Per directive I corroborated each ask against a named artifact rather than closing on the hint.

**Corroboration — both asks already satisfied by peer commit `ae0929f48d` (the current PR HEAD, `head_sha ae0929f48d36...`):**
- **Ask 1** → `ae0929f48d` "docs(daemon): align guest bot design with landed pins (#1227)" rewrites the design (244 add / 848 del) to reflect the generic mechanism landed in **#1306** (`provideGuest(..., { pins })` → `@pins` directory; per-delivery best-effort pin reincarnation). It adds a **Status: Implemented** section, retires the `GuestFormula.bot`/`EndoBot`/supervisor proposal in favor of the pinned-responder pattern, and updates three `designs/README.md` roadmap rows (status → Implemented, milestone/total counts).
- **Ask 2** → the same commit's Background now reads: *"Endo's persistent state is an append-only formula graph. A formula, once written, cannot be modified. The graph itself can grow as formulas are added, and unreachable formulas can be collected, so describing the graph as immutable would be too strong."* — matches the requested wording. Inline reply `id 4067898149` already cites `ae0929f48`.

**Action taken** — the inline thread already had a reply; the top-level ask had none, so I posted one concise acknowledgment comment (`#issuecomment-5770735904`) naming `ae0929f48d`, the #1306 mechanism, and the append-only edit. No garden repo changes; no new commits to the PR (work was already complete and pushed).

**Follow-ups** — none. PR remains an open draft (`mergeable: true`); un-drafting/gauntlet is a separate maintainer trigger.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-review-5194e7b0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (1 unmetered)
- Input: 74 tokens (1718415 cached reads)
- Output: 25514 tokens
- Cost: $4.0779155 (1 engagement(s) unpriced)
- Wall-clock: 6692s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
