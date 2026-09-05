CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #695 gauntlet — FIX round 6 (design PR, `design/sturdy-refs-agent-surface`).

I read the panel-6 request-changes verdict (7 seats), verified every load-bearing code citation against the worktree, applied the fixes as review-feedback follow-up commits, pushed, and watched CI to green.

**Must-fix items applied (all verified against code):**
- **Fae turn-boundary inversion** (critic + skeptic): the per-activation unit is `runAgenticLoop` (`fae/agent.js:308`), not the process-lifetime `runAgent` `while(true)` loop (`:416`, single call site `:552`). Corrected in Tool-layer escrow, Acceptance Criteria, and Phase 4. Also moved the render map to a **per-activation** lifecycle in `@endo/agent-tools` so a forgotten wrap fails closed (no map), addressing the decomplector's by-construction finding.
- **`storeValue` cross-turn channel** (critic): added its admission-table deny row (`interfaces.js:221`, `M.call(M.any(), …)`, live on the guest `guest.js:311`, model-facing `tool-makers.js:613`), a single-slot handle-redemption rule (only `lookupBySturdyRef`'s argument redeems a handle), and corrected the false "no path from a sturdyref to a pet name" premise.
- **Daemon method turn-scoping** (decomplector): scoped "single-turn only" to the model-mediated handle surface; `lookupBySturdyRef` itself has no turn concept.
- **Metadata sync** (pedant): README date 2026-09-04 → 2026-09-05.
- **Buried problem statement** (novice): section now leads with the problem and its concrete cost, then definitions.

**Should-fix items applied:** wrong-interface admission citations fixed to `readableNameHubMethodGuards` (`platform/src/fs/interfaces.js:50`) vs `MountInterface`; Genie's third dispatch branch (`specials.dispatch`) and async-iterable completion point; `enlivenSturdyRef` full 4-arity with `provideSession`/remote branch as attenuation targets; `swissNumber`→`secret` spelling; reserved handle grammar changed from `@:` to an embedded-`@` form (`ref@…`) that doesn't resemble the `@self`/`@host` family the model composes; pinned unknown/stale failure messages and rendered handle shape; introduced Lal/Fae/Genie, pass style, and mediator; worked example added; Open Questions numbered; Status moved after metadata; Prompt made a cited blockquote; several prose clarity fixes. Kept the doc pure ASCII (converted introduced em-dashes).

**Pushed:** `b4a30778e → 160463cbe` on `endojs/design/sturdy-refs-agent-surface` (advance mode).
**CI:** GREEN (5/5 checks, 0 failed).

I did not re-run the panel; the driver re-posts panel-7. Left unaddressed (lowest-value taste-only): full defined-term emphasis normalization (P5) and Phase/step/case capitalization downstyle (P6).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6072479 cached reads)
- Output: 60754 tokens
- Cost: $6.0394415
- Wall-clock: 1338s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
