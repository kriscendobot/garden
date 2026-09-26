CI is green (rc 0). The fix is pushed and passing.

## Completion report

**Job:** Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #1151 (design: eliminate single-segment string paths).

**What I did:** Read the panel round-2 verdict (disposition: must-fix). The must-fix findings clustered on two contradictions in the design doc; I resolved both and addressed the entangled should-fix items, then pushed a single follow-up commit and watched CI to green.

**Must-fix items applied** (all edits in `designs/eliminate-single-segment-string-paths.md`):

1. **Guard `M.string()`-arm self-contradiction** (ergonomist #1, critic #2, decomplector #1). The "What Already Errors" section claimed the design *removes* the bare `M.string()` arm from every guard, while The Proposed Rule *keeps* it as a routing affordance. Reworded so the design removes the *coercion* (silent string-as-path) while deliberately retaining the runtime guard arm.
2. **Declared-type-vs-guard-shape gap** (critic #2, decomplector #1, ergonomist #2). Added a new "The Declared Type Versus the Guard Shape" subsection stating the deliberate wide-guard / narrow-declaration divergence and where it is compensated per consumer: hand-authored `types.d.ts` (narrowed, closing the previously-unrevisited second residual defect), generated code-mode declarations (narrowed independent of the guard), CapTP/`M.interface()` introspection (residual, deferred to new OQ7). Reworded Help-Text Requirements item 5 accordingly (declarations can't narrow "from the guards"). Strengthened Design Decision #1 to carry the narrowing.
3. **OQ4 registry-scope pre-emption** (critic #1). Scoped Proposed Rule step 2 to the mount only and deferred `namePathFrom` (registry) coercion to open question 4 rather than deciding it.

**Also addressed** (cheap, directly connected): OQ5 now carries a recommendation (ergonomist #3), added OQ7 for the guard-combinator alternative I referenced, and spelled out the undefined "OQ4" abbreviation (copyeditor #1).

**Not done:** remaining pure comment-only phrasing nits (pedant heading caps/number form, novice "earlier draft" framing, copyeditor tangled noun phrases) — left to keep the diff focused on the must-fix contradictions.

**Result:** Commit `b1c59ecc7` pushed to `origin/design/eliminate-single-segment-string-paths` (fast-forward advance over `c9be999a2`). CI terminal: 5/5 checks, 0 failed — **GREEN**. Per the staged-gauntlet contract I did not re-run the panel; the driver re-posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1151-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1384249 cached reads)
- Output: 19050 tokens
- Cost: $1.9301474999999995
- Wall-clock: 802s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
