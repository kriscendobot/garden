---
posted_at: 2026-10-31T04:59:57Z
role: fixer
arc: endo-ocapn-background
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Fix: ironhorse oracle `stage3-math/054,055` last-digit mismatch reds every PR on endojs/endo-but-for-bots

Repo: endojs/endo-but-for-bots (target base `llm`).

CI job `test-ironhorse-oracle` (step "Test oracle-linked engine crates (rust/engine workspace)")
fails in `ironhorse-262/tests/corpus_conversion_equivalence.rs` `generated_cases_reproduce_corpus_coverage`:

```
FAIL .../packages/test262-runner/test262/test/ironhorse/built-ins/stage3-math/054.js
  over-acceptance: ironhorse completed a source the oracle rejected: Test262Error: Expected SameValue(«1.300820426840647», «1.3008204268406467») to be true
FAIL .../stage3-math/055.js
  over-acceptance: ... Expected SameValue(«1.475044781241425», «1.4750447812414251») to be true
```

This is NOT caused by any PR diff. It failed 3 out of 3 times on #1117 (run 41161499650, 2026-10-31,
head 4f7cb6bb8, base llm-9a14ddf whose own CI passed 2026-10-28). It also fails on #1501, which has no rust or
test262 changes (job 124422390712). On 2026-10-25 (#1504) it was intermittent; now it fails every time. The likely cause is a 1-ulp
libm difference between the XS oracle and the runner image (the Math fn under test computes differently
on current ubuntu runners). Find where the expected value comes from (the oracle build vs the
generated corpus pin), then make the check deterministic across libm builds. Options: a correctly rounded implementation
in the engine/oracle, regenerated corpus pins, or a documented tolerance/skip with rationale. Do not just
weaken the gate silently. Open a PR against `llm`. Once it lands, PR gauntlets that halted on this
(e.g. #1117 clean stage) can be re-run.

<!-- garden-productive-cycle -->
<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-31T05:00:32Z
