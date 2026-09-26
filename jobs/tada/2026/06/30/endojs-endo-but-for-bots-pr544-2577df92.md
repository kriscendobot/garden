Completion report:

## Job complete: attention directive on endojs/endo-but-for-bots PR #544

**Directive (erights, top-level comment):** "may be worth amending the design's 'examples in the current tree'. @kriscendobot, please do." — a "please do" on kriscendobot's own #570 note that the design's named corollary-1 reach-back examples don't actually need repointing.

**What I verified against the current tree (PR head `42d0057`):**
- `genie`'s `package.json` `"exports"` names only `"." → ./src/index.js` — so `agent/index.js` is an **internal** module, not a declared export.
- `ChatEvent` is `@typedef`'d in `packages/genie/src/agent/index.js` (line ~230).
- `tool-gate.js` does `@import { ChatEvent } from './index.js'`, and that `./index.js` resolves to `agent/index.js` — the **defining** module. So it is **not** a reach-back; nothing to repoint.
- No sibling imports any name through the package root barrel `src/index.js` — `genie` has no genuine reach-back. The design's claim that `tool-gate.js` "reaches back to `./index.js` ... the repoint targets the module that defines the type" was false.

**Change:** `designs/intra-package-plain-re-exports.md`, *Examples in the current tree* (commit `20c3375ab`, pushed to `design/intra-package-plain-re-exports`):
- Rewrote the **Declared-export reach-back** bullet to describe the pattern abstractly (a module importing through any `"exports"` entry instead of from the defining sibling), firing a repoint only when the import truly routes through a non-defining re-exporter.
- Repurposed the `genie`/`tool-gate.js` candidate to illustrate the **resolve-to-the-defining-module check** the pass runs first — a candidate that *looks* like a reach-back but resolves away (defined in the very `agent/index.js` it imports from, which isn't even a declared export). Kept sentences short per erights' earlier readability notes.
- Left the `evasive-transform/src/visitor.js` example untouched (settled in prior review, not flagged).

**Comms:** posted a top-level summary comment to PR #544 (`#issuecomment-4839948242`) crediting the #570 finding and detailing the correction.

**Follow-ups:** none. Design-only change, no source modules move; PR remains DRAFT pending erights' review. Inbox was empty; project worktree torn down.
