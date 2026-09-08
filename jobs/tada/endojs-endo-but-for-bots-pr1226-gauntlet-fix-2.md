CI is GREEN (rc 0, 7 checks, 0 failed). The fix stage succeeded.

## Completion report

**Job:** Gauntlet FIX round 2 for endojs/endo-but-for-bots PR #1226 (`docs(designs): a stdio MCP server scoped to one guest's tool surface`).

Applied the panel-2 request-changes must-fix items to `designs/endo-guest-stdio-mcp.md`, pushed one follow-up commit to the PR head (`design/endo-guest-stdio-mcp` on endojs), and watched CI to green. Did **not** re-run the panel (driver re-posts panel-3).

**Must-fix items applied:**
1. **Abstract-UDS cross-guest discovery gap** (critic/skeptic/decomplector converged). Ruled out the abstract namespace (enumerable host-wide via `/proc/net/unix`), switched the broker↔adapter channel to a **filesystem-path UDS inside the guest's own `@endo/claude-sandbox` mount namespace** (0700 per-guest dir) plus a **`SO_PEERCRED` peer-credential check at `accept`**. Added a dedicated "socket-discovery boundary" subsection naming the concrete OS primitive rather than resting on an unguessable address; updated Design Decisions 1–2 accordingly.
2. **Fail-closed construction keyed on an unmerged external manifest** (decomplector/skeptic/critic). Decoupled it: the construction throw now enforces only *this catalog's own well-formedness* (no `__`/dunder/code-eval/internal-duplicate/case-confusable/malformed names), and a bare-name collision against minion.town PR #79's reserved list is demoted to an advisory **warning** (server-scoping `mcp__endo__` already prevents wire collisions). Rewrote the Naming section, Design Decisions 4–5, the Dependencies row, and the open question.
3. **Missing test/acceptance-criteria section** for the security centerpiece (skeptic). Added a "## Test plan (acceptance criteria)" section with positive (real tools invoke, catalog parity) and negative (cross-guest reach impossible, name/argument-scope rejection, fail-closed construction, fail-closed on broker death) cases.
4. **Em-dash sweep** (pedant). Rewrote all 17 em-dashes to periods/colons/parentheses via judgment, not mechanical strip.

Also folded in cheap should-fix/comment-only copyedits: `serverInfo` parity in `initialize`, intransitive "invoke" → "can be invoked", the reject-only fragment, the imperative mood-shift on the `\n`-split sentence, and the missing article in the stopgap sentence.

**Push:** `c270f2875 → ecff9f749` on `endojs/design/endo-guest-stdio-mcp`.
**CI:** GREEN — 7 checks, 0 failed (rc 0).

**Follow-ups:** none required for this stage; the PR remains DRAFT pending the driver's panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3567065 cached reads)
- Output: 24810 tokens
- Cost: $3.235525499999999
- Wall-clock: 951s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
