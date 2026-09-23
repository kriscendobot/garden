Verified: the fix commit `a048d30002ea` is the PR head, and all 5 CI checks pass (build, lint, browser-tests, test, zizmor). The work was already done and durably pushed; this requeue only interrupted the final signal.

## Completion report

**Job:** FIX round 1 — endojs/endo-but-for-bots PR #1098 gauntlet (prose-only design PR to `designs/endo-claude.md`).

The deliverable was fully applied in the prior session and survives the requeue: commit **`a048d30002ea`** is the live PR head on `design/endo-claude-sibling-notes`, and CI is **GREEN** (5/5: build, lint, browser-tests, test, zizmor all pass).

Panel round-1 (posted as an issue comment; disposition *must-fix*, aggregating critic/skeptic/decomplector/ergonomist/copyeditor/pedant/novice) items applied in one follow-up commit:

- **Undefined "sibling agent fleet" term** — replaced with a single defined referent, "a peer provider adapter," introduced once at first use and reused consistently, no longer colliding with the doc's existing "sibling" (= `@endo/claude-sandbox`) and "agent fleet" (= authoring garden) terms.
- **em-dash rule** — removed all 9 em-dashes from the added prose (lint CI confirms).
- **argv-ceiling paragraph** — corrected `MAX_ARG_STRLEN` (per-argument) vs `ARG_MAX` framing; stated fail-closed disposition for an over-cap `--allowedTools` (refuse to spawn, not silent truncation); cross-linked the `--mcp-config` table row; fixed two non-parsing clauses.
- **Fresh-process rationale** — named the latency cost before dismissing it; hedged "field evidence."
- **Per-guest Known-Gap** — distinguished the adapter's per-holder (subscription-owner) isolation axis from per-guest; dropped the unbacked "verified shape" claim.
- **Entitlement gap** — removed the uncitable "leak went unnoticed for weeks" incident, reframed as a structural metering-invisibility hazard.

Stopped without re-running the panel per the gauntlet contract; the driver re-posts panel-2. No follow-ups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1098-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 6 tokens (199106 cached reads)
- Output: 1230 tokens
- Cost: $3.8866744999999994
- Wall-clock: 838s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
