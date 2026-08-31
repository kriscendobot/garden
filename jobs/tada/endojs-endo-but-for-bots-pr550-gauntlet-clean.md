This PR is docs-only — it modifies only `designs/README.md` and `designs/formula-inspector.md` (design markdown), touching no package source or tests. CI is terminal GREEN across all checks (build, lint, test, browser-tests, zizmor). There is no code coverage pass applicable to a design-doc change and nothing to orphan. This stage is a no-op.

## Completion report

**Stage:** clean — endojs/endo-but-for-bots PR #550 ("docs(designs): host-side getFormulaPath addressing of deeply nested formula values")

**Idempotence check:** `gh pr view` shows the PR touches only two design markdown files (`designs/README.md`, `designs/formula-inspector.md`; +211/−9), no packages. All status checks are terminal SUCCESS at the current head (build, lint, test, browser-tests, zizmor).

**Action taken:** None required. Coverage-driven testing applies to touched *packages*; this change touches no package source or tests, so there is no coverage to add and no dead code to orphan. CI is already GREEN, so no follow-up push and no CI wait were needed.

**Changes pushed:** none. **Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr550-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91495 cached reads)
- Output: 1250 tokens
- Cost: $0.39567149999999995
- Wall-clock: 22s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
