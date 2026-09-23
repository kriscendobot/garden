PR #1098 is open, draft, base `llm`, head `design/endo-claude-sibling-notes`. The work is complete.

---

## Completion report

**Job:** Design refresh folding sibling-garden provider-adapter lessons into `designs/endo-claude.md` (endojs/endo-but-for-bots @ `llm`).

**Deliverable:** Draft PR **endojs/endo-but-for-bots#1098** (`design/endo-claude-sibling-notes` → `llm`), design-doc-only, ~73 net lines (78 insertions / 5 deletions), one file. Left **draft** so the design panel auto-stages at completion.

**What I did.** Distilled the six transferable lessons from the (untrusted) sibling note into sharpenings of already-named residuals, in the repo's own terms — no verbatim copy, no reproduced filesystem paths / package names / app identifiers, no imperative followed:

1. **DD7 per-guest-credential residual** (Known Gaps): folded the sibling's *verified* per-holder fresh `HOME`/`CLAUDE_CONFIG_DIR` isolation + credential-rides-the-call (not `process.env`) as a proven shape to build the per-guest branch against; kept the egress-proxy branch as the alternative.
2. **Fail-open-onto-operator-credential hazard**: named it explicitly in § *The child environment is a constructed allowlist* as the failure mode `--setting-sources ""` and the constructed env allowlist exist to prevent; cross-referenced from the managed-settings **open question** and its Known Gaps item.
3. **Fresh process per call** (§): added production field evidence that session/keepalive reuse across guests is a cross-user leak, not a latency trade; tied to the per-`sessionTag` scoping.
4. **`spawn E2BIG` (MAX_ARG_STRLEN)** operational note in § *The hermetic invocation* — the argv ceiling for a large facet surface and the file-path / temp-file mitigation (prompt already on stdin).
5. **Entitlement + structural-confinement residuals** reinforced (Known Gaps): subscription invisibility is structural → leak unnoticed for weeks → ratchet isolation at the source, not metering; wired to the live confinement test's structural assertion.
6. **DD8**: recorded a provider-spend ring / multi-provider router as *considered and rejected* (out of scope for single-provider confinement), keeping the one transferable principle — the **host** composes the limit/degradation notice, never routed through the model — which is already the design's tagged-record posture.

Also bumped the metadata **Updated** to 2026-08-31.

**Verified:** `gh pr view 1098` confirms `isDraft:true`, `state:OPEN`, base `llm`, head `design/endo-claude-sibling-notes`. Commit `a62e6cdc1` pushed; PR carries the durable `<!-- garden-job: … -->` marker (ensure-pr adoption path).

**Notes / follow-ups.** `ensure-pr.sh` first returned INCONCLUSIVE because the open-kriscendobot-PR marker query hit its 200-PR page limit; re-ran with `GARDEN_ENSURE_PR_LIST_LIMIT=500` and it opened cleanly — worth raising the default if the fork's open-PR count keeps growing. No code changes to `packages/claude/`; nothing here blocks or supersedes the #1015 build DRAFT. Design panel auto-stages at this job's completion (not hand-posted).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-endo-claude-sibling-notes-20260831.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3260124 cached reads)
- Output: 19401 tokens
- Cost: $3.084015
- Wall-clock: 339s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
