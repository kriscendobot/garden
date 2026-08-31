Deterministically confirmed: **CI GREEN** (rc 0, 5/5 checks pass, 0 failed).

## Completion report — Gauntlet FIX round 1, endojs/endo-but-for-bots PR #1013

**Applied the panel's round-1 must-fix items** to `designs/relative-routing.md`:
- Removed the leaked tool-call markup (`</content>`, `</invoke>`) at the file tail.
- Replaced all em-dashes (U+2014) and Unicode ellipses (U+2026) with ASCII per project style (`em-dash-style`, `typist-friendly-code-points`).
- Resolved the critic's case-6 vs `selectRoutes` self-contradiction: a `via=` gateway-relay hint's `scope=gateway:<G>` now explicitly names the *destination* boundary (not a receiver-held filter tag), so `selectRoutes` always keeps it (ranked at gateway cost) and filters the embedded gateway locator's hints recursively. Reconciled the case table row, the § 3 encoding text, and the § 4 pseudocode.
- Made `LocalScope.tags` an unordered `Set` (membership-only) and added `makeLocalScope`'s signature/role, dropping the unused "innermost-first" ordering claim (decomplector + ergonomist).
- Softened the § 4 "ring" prose to per-tag set membership (novice); fixed the pedant citation comma.

**Unblocked CI.** After pushing the fix, no `github-actions` check-suite would form: the PR was `mergeable: false` / `dirty` — a merge conflict with the fast-moving `llm` base blocked GitHub from computing the merge ref, so `pull_request` workflows never triggered. The only conflict was `designs/README.md` (the design index). I rebased the PR head onto current `origin/llm` (`--onto origin/llm eb6da1602`, replaying only the 2 PR commits), resolved the index conflict by keeping both `llm`'s new rows and the PR's `relative-routing` additions (index row, dependency graph node, effort row, and M4 milestone count bumped 9→10), and force-pushed the rebased head.

**Result.** PR head `ec41044a8`; final diff vs `llm` is exactly the new design doc + index additions. CI is **GREEN**: `browser-tests`, `build`, `lint`, `test`, `zizmor` all pass (rollup total=5, failed=0, rc 0).

**Follow-up:** `mergeable` briefly reads `unknown`/`null` as GitHub recomputes against an advancing `llm`; CI already passed on this head. If `llm` re-conflicts before merge, a fresh rebase/weave will be needed, but that's outside this stage. Panel-2 is the driver's next step (not re-run here).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 158 tokens (6398294 cached reads)
- Output: 45112 tokens
- Cost: $7.425439999999999
- Wall-clock: 1423s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
