Panel round 5 complete. Verdict posted.

## Report

**Job:** Gauntlet PANEL round 5 — endojs/endo-but-for-bots PR #995 (`design(endo-claude): confined claude -p inference for one guest facet`), base ref `origin/llm`.

**What I did:**
1. Resolved PR head (`endojs:design/endo-claude`, head `43efff8271`, which includes round-4 must-fix commits) and got an isolated project worktree.
2. Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode. All 7 design-panel seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) ran clean (status `ok`) and each returned **request-changes**. Panel disposition: **must-fix**.
3. Posted the aggregate to PR #995 as a `gh pr review`. Request-changes was rejected (GitHub blocks requesting changes on your own PR — the head is bot-authored), so, consistent with prior rounds on this PR, it landed as a **COMMENTED** review carrying the full must-fix aggregate.

**Substance of the verdict (recurring must-fixes across seats):**
- The `evaluate`/`eval`/`define` code-eval deny is applied only at the client-side allow-list generator, not at the bridge's pinned-snapshot enforcement boundary the design itself declares authoritative — a leak past the client list reaches arbitrary code execution (critic, decomplector).
- DD2's fail-closed membership rule is unsatisfiable against the only live tool surface the design names (facet methods vs. dispatch tool names).
- Enumeration/version findings: `--tools` (variadic, fail-closed baseline) omitted from the argv-boundary list; confinement is a measurement with no pinned-version spawn assertion (skeptic).
- Markdown break: `README.md:9` wrapped line begins with `+ ` (a block marker that splits the paragraph and unbalances emphasis) — flagged must-fix by both copyeditor and pedant.
- Process-topology ambiguity around the two-shim confinement boundary; DD1 title/count mismatch (novice).

**Follow-ups:** None for this stage — it runs exactly one round and stops. The next gauntlet stage (fix-loop) owns applying the must-fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (647972 cached reads)
- Output: 4678 tokens
- Cost: $0.881479
- Wall-clock: 327s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
