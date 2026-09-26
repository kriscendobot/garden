Done. Worktree torn down, draft PR verified (DRAFT, base `llm`, open). Writing my completion report.

---

## Completion report — `design-endo-absorb-pi-harness-layers`

**Deliverable:** `designs/endopi-harness-consolidation.md` on `endojs/endo-but-for-bots`, opened as **DRAFT PR #552** (base `llm`, the agent-harness line where this material lives). Design-only, no code changes. Fork-scope, no upstream interaction.

**What I did**
- Read `designs/endopi.md` (the Reference comparative analysis) in full and built *on* it rather than redoing it, per the job.
- Dispatched two parallel deep-research passes: one mapping the actual source wiring of `packages/{lal,fae,genie}`, one mapping the daemon-agent + `endopi-*` design clusters. Verified the two shared-seam packages (`@endo/agentry`, `@endo/agent-tools`) directly.
- Wrote the design doc with the five required sections: layer map (side-by-side), duplication+coordination cost, per-layer ABSORB/KEEP-DEPENDING/UNIFY recommendation, a Phase 0–5 consolidation path, and risks/open questions. Cross-linked `endopi.md`, `agentry-agent-builder.md`, `endo-agent-tools.md`, the daemon-agent cluster, the `endopi-*` gap spinouts, and PR #265 for reviewer context.

**Key finding that shaped the recommendation (drift since endopi.md):** the tree has moved past what endopi.md describes. The Pi packages were renamed to the `@earendil-works/*` scope; **`lal` now embeds Pi too** (not just genie); and Endo has **already begun coordinating** via `@endo/agentry` (shared harness seam over `@earendil-works/pi-*`) and `@endo/agent-tools` (canonical provider-independent `ToolRecord` catalog). But the consolidation is half-finished — genie reimplements what agentry centralizes (`resolveModel`, `runAgentRound`, the ollama adaptor), fae runs a third, Pi-free custom loop, and a legacy `lal/providers` layer survives with three consumers (fae, jaine, lal tests). Five package.jsons are pinned in lockstep to `pi-agent-core ^0.79.0`.

**Recommendation delivered:** **Do not absorb Pi** — keep depending on `@earendil-works/pi-agent-core`/`pi-ai` (the loop/registry layers are where Endo's CapTP/capability differentiators add no leverage and churn is highest). Instead **UNIFY internally**: finish routing all surfaces through agentry (loop/model) and agent-tools (tools), retire the duplicate wrappers and `lal/providers`, converge persistence onto one substrate with a pi-compatible JSONL projection. ABSORB only the *format* layers (transcript/skills/prompts) as Endo-owned, pi-compatible projections.

**Follow-ups flagged for the maintainer (in the doc's §5):** retire-vs-refactor `fae`/`jaine`; choice of canonical transcript substrate (conversation-tree vs genie's markdown+FTS5); sandbox-driver coupling (vfs-endo vs 9p, carried from endopi.md); and that this doc takes a position (option a/c) on the open "Lal vs Genie consolidation" question in `endopi-provider-registry-and-oauth.md`. Also a low-cost interop idea: upstream a native ollama entry into `pi-ai` to delete the duplicated shim.

**Housekeeping:** committed under the bot identity (`endolinbot`); created and then tore down the `wt-endopi-absorb` worktree off the bare clone. Inbox was empty at the checkpoint.
