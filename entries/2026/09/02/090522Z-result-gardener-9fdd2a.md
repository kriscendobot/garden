---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-02T09:05:24Z
---
---
kind: result
role: benchmarker
repo: kriscendobot/minion.town
project: minion-town
---

Panel seat `benchmarker` on kriscendobot/minion.town PR #79 (`feat/tool-name-reconciliation`, head 8617942, base origin/main), dispatched by the round-2 gauntlet panel.

### benchmarker (benchmark-closure on optimization claims)

**Verdict:** approve

Surfaces walked: PR body (What / Why / What to attend to / Out of scope), three commit messages (`1c92bb8`, `8cf0b50`, `8617942`), the round-1 panel review (the only review; 0 inline review comments, 0 issue comments), and the docs modified by the diff (`README.md` § Naming convention only — the diff adds or modifies no design document).

Optimization-claim inventory:

1. `src/endo/mcp-tool-names.ts:99-101`, `findDuplicateToolNames`'s O(n²) `names.indexOf` inside `filter` — raised by the round-1 assessor seat. **Closed by an explicit "not pursuing" rationale**: "its O(n²) `indexOf` is irrelevant at n=22 and off any hot path." Re-validated against the round-2 head, since a decline whose reason is a bound must still hold after the delta: `MAXIMAL_MCP_TOOL_NAMES` is 23 names (baseline 12, sites 4, baselineReserved 2, invitation 2, reminders 2, claudeForm 1); the sole production call site is the module-scope `assertNoDuplicateToolNames(MAXIMAL_MCP_TOOL_NAMES)` at `:113`, which runs once per module load — there is no per-request or per-registration invocation (`grep` over `src/`: the only other importer is `src/endo/guest-tools.ts:50`, which imports `MCP_TOOL_NAMES` alone). The bound the rationale rests on is intact.

2. No other optimization claim exists on any surface. The PR body, the README addition, and all three commit messages make correctness, coherence, and failure-timing claims ("throws on a collision the moment the manifest is imported", "surfaces at design time rather than as a boot crash", "drift in either direction now fails") — none is a performance claim, so none is owed a measurement. The round-2 fix commit's own additions (freezing the outer manifest, extracting `assertNoDuplicateToolNames`, the manifest-derived mounted-surface assertion) introduce no new optimization claim.

3. No `BENCH.md` is added or updated by the diff, and none is owed: nothing on the PR's surfaces claims a performance property that a benchmark would have to close.

**Findings:**

- **comment-only** — `src/endo/mcp-tool-names.ts:99`: the O(n²) decline is correctly closed *at this size*, but its rationale is a bound ("n=22", "off any hot path"), not a property of the code, and the manifest is designed to grow with every reserved facet name. Non-blocking today and no measurement is owed now; the note exists so the closure is not silently re-opened by growth. [rule: roles/jurors/benchmarker/AGENT.md § Operating norms]

Self-improvement: the leverage at this seat was treating a *bounded* decline rationale ("irrelevant at n=22") as closed-but-conditional and re-checking the bound against the new head, rather than reading the earlier round's decline as permanently closing the claim. Proposed for `roles/jurors/benchmarker/AGENT.md` § Operating norms: when a "not pursuing" rationale rests on an input bound rather than on the optimization being wrong, re-verify the bound against the head under review before accepting the closure, and record the measured bound in the finding.
