Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1046 against frozen base `llm-e22e67a`.

Implemented:
- Added `ironhorse` and `ironhorse+ses` hardened262 agents using the shared Ironhorse/XS differential.
- Reused the existing assembled harness and preserved separate mode-specific baselines.
- Added CI submodule initialization, documentation, Rust/JS tests, and compact differential reasons.

Matrix behavior:
- Before: 3 agents; 10 zero-coverage tests.
- After: 5 agents; 2 zero-coverage tests.
- New script matrix: 406 outcomes—bare Ironhorse has 2 parity failures and 201 named skips; Ironhorse+SES has 203 named skips. Unsupported module/compartment modes remain explicit skips.

Verification passed: 28 JS tests, targeted ESLint/TypeScript, Rust release build and differential test, Ironhorse baseline comparison, focused local verification, regression fail/pass proof, and pre-push probes. The full local five-agent comparison differed only on one existing local-XST result; the pinned baseline was retained. CI had seven successes and no failures, with remaining checks queued/running at completion.

Follow-up: root-wide local lint scans the initialized Moddable submodule and fails because its standalone ESLint dependency is unavailable; changed files lint cleanly.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-coverage-matrix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 6835s

<!-- garden-usage-end -->
