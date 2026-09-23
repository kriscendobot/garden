PR: https://github.com/kriscendobot/endo-but-for-bots/pull/7 — open as DRAFT against pinned base `llm-67dfc18`; never merge.

PASS — Bare named re-export made the pre-push gate exit 1, blocking the normal push path. It was pushed only afterward as an intentional validation fixture.

PASS — Identical re-export beneath adjacent `@deprecated` JSDoc naming `./original.js` passed the probe.

PASS — Barrel `index.js` wildcard re-export was flagged under Decision 1.

PASS — Type-only re-export was not flagged under Decision 5.

PASS — Instrumented seat-gate execution made zero `claude` calls and approved the compliant state; with candidates, it made exactly one `claude -p` call and returned must-fix findings for both plain and barrel re-exports while explicitly clearing the compliant shim and type-only export.

Regression suites: `no-plain-reexport-probe-test.sh` 19/19 passed; `seat-gate-reexport-auditor-test.sh` 10/10 passed.

Changed: three synthetic fixture commits on `validation/reexport-policy-ebfb-20260923`; no garden source changes.

Follow-up: keep PR #7 draft and unmerged.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/validate-reexport-policy-ebfb-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 628s

<!-- garden-usage-end -->
