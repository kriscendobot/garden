The round-3 panel verdict is posted. Panel disposition was **must-fix**, and I posted it as a COMMENTED review (matching rounds 1–2; a request-changes review is impossible on a self-authored PR).

## Completion report

**Job:** Gauntlet stage PANEL round 3 for endojs/endo-but-for-bots PR #1013 (`design: relative routing for CapTP/OCapN locator hints`).

**What I did:**
1. Resolved PR head: `endojs/endo-but-for-bots` @ `design/relative-routing`; base `llm` (merge-base SHA `ccdc0b2eb65f`).
2. Created isolated project worktree at HEAD `ce8b06152` (which already carried round-1 and round-2 must-fix fixups).
3. Ran the panel single-round: `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <worktree> 1013 ccdc0b2eb65f…`. Terminal disposition: **must-fix** (record-meta `disposition=must-fix`, `related-design-verdict=clear`).
4. Posted the aggregate as a `gh pr review --comment` on PR #1013 (request-changes rejected by GitHub on an own-authored PR, so I mirrored the prior rounds' COMMENTED shape).

**Verdict summary (still open must-fixes):**
- **pedant/copyeditor:** em-dashes throughout `designs/relative-routing.md` (lines 54, 75, 132…236) and a typographic ellipsis at line 171 — violate `em-dash-style` / `typist-friendly-code-points`. These persist despite two prior fix rounds.
- **critic:** `selectRoutes` cost function hardcodes `costOf("gateway")` for every `via=` hint, inconsistent with the general `dest=<kind>:<id>` encoding; plus an unaddressed async discovery/selection race for `lan`/`hub`/`gateway` tags feeding a synchronous decision.
- **skeptic:** no Test Plan section (unlike sibling designs); empty-`selectRoutes` failure mode unspecified; producer-side "omit out-of-boundary hints" SHOULD contradicts the receiver-private scope-membership premise.
- **ergonomist:** naming (`selectRoutes` returns `ConnectionHint[]`, not `Route[]`), no hint-level cost accessor, "configurable" order with no carrying parameter.

**Stage stop:** Per stage contract I ran exactly one round, posted the verdict, and stopped — no fix, no un-draft, no loop. The gauntlet's next stage (fix-loop) owns remediation.

**Follow-ups:** The recurring em-dash/ellipsis must-fixes have now survived three panel rounds; the fixer stage should treat the code-point sweep as a hard gate before the next panel.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (675227 cached reads)
- Output: 4382 tokens
- Cost: $0.9027324999999999
- Wall-clock: 404s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
