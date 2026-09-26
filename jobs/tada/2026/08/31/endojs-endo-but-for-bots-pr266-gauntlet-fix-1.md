All panel must-fix items applied, pushed, and CI is terminal-green (checkless). Here is the completion report.

---

## FIX round 1 — endojs/endo-but-for-bots PR #266 (endopen design raft)

**What I did.** Read the design-panel round-1 request-changes verdict (7 juror blocks) and applied its must-fix items across the five `designs/endopen*.md` files, then pushed as a follow-up commit (`c2ccb0ef0`) to the PR head `endojs:design/endopen` and watched CI to terminal.

**Changes (one commit, `c2ccb0ef0`, 5 files):**
- **ACP auth (critic + skeptic + decomplector + ergonomist + novice — the dominant finding).** Stopped reusing the guest **formula ID as the ACP bearer token**. A formula ID is a public addressing handle; the adapter now **mints a distinct, independently revocable per-session token** bound server-side to the formula ID. Rewrote § Authentication and multiplexing, Design Decisions 4/5, the wire diagram (added the `authenticate` step + minted-token flow), and the lifecycle table; separated the `adapter→daemon` (gateway token) and `ACP-client→adapter` (minted token) surfaces, which also resolves the novice "authenticate before the guest exists" confusion.
- **Guest interface / silent degradation (ergonomist).** New Design Decision 9 + lifecycle rows: guest agent modules **must** implement `cancel()`/`fork()`; no `session/cancel`/`session/fork` "if implemented, else best-effort" branch — advertise a missing capability instead of degrading silently.
- **Concurrency overstatement (critic).** Qualified the "genuinely parallel / no shared event loop" claims in `endopen.md` and `endopen-concurrent-subagents.md`: per-guest worker isolation is a **formulation choice** (guest eval falls back to a shared `mainWorkerId`), not automatic; the `deliberate()` sketch now pins each panel member to its own worker.
- **Persistence (skeptic).** Corrected "content-addressed by its formula ID" — only content stores are content-addressed; most formula IDs (guest/worker/host/…) are random 256-bit, with the secrecy implication spelled out.
- **OpenRouter (skeptic + ergonomist).** Fixed the `detectProviderKind` snippet to the shipped `'openai-compatible'` spelling and `.includes('/v1')` predicate (was `'llamacpp'` / `.endsWith`), fixed the Phase 2 enum spelling, and reconciled the `createProvider` wire-in with the existing branch.
- **Broken links (pedant).** Rewrote all ~23 `../../external/opencode/…` links and the cross-repo `../../../garden/roles/judge/…` link as absolute upstream URLs (`github.com/anomalyco/opencode@d59d9966`) / prose; also reframed the retired-`judge`-stub citation as the garden's scripted review panel.
- **Prose + glyphs (copyeditor + pedant).** Parallel structure, comma splice, verbatim maintainer quote ("space that is more like…"), missing article, "walked"→"examined"; replaced typist-hostile `→` / `≥` / `…`; sentence-cased `endopen.md`'s `###` headings to match the four spin-outs.
- **Verification gap (skeptic).** Added `## Verification` sections (falsifiable checks) to the two empirically-checkable designs — acp-server (capability preservation, credential hygiene, durability, no-silent-degradation) and concurrent-subagents (parallelism barrier test, worker isolation, capability containment).

Reverted an unrelated `packages/hex-test/package.json` reformatting that the warm-cache `yarn install` left in the tree; only the 5 design files were committed.

**CI.** No checks attach to this PR: `ci.yml` only produces `pull_request` runs against a computable merge ref, and the PR is `mergeStateStatus: DIRTY` (conflicts with base `llm`), so GitHub creates no run — the head commit (and the prior head) have zero check-runs. Design-only PR, checkless. `ci-wait-merge.sh … --no-merge` returns **rc 0 (GREEN)**: `rollup-terminal … total=0 failed=0 → CI GREEN`.

**Per stage instructions, I stopped here — did not re-run the panel** (the driver re-posts panel-2).

**Follow-up (out of scope for this fix stage):** the PR is conflicted against its base `llm` (`DIRTY`); it needs a **weave/rebase #266** before it can merge. The design panel did not flag this and it is separate from the review must-fixes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr266-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 136 tokens (8023031 cached reads)
- Output: 51807 tokens
- Cost: $6.839830499999998
- Wall-clock: 1003s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
