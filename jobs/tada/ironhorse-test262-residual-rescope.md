Inbox empty. This was a proposal-only job — no children posted, no code changed, no branch touched. My deliverable (the re-scoping proposal) is delivered to the maintainer and reproduced in full below.

---

## Completion report — ironhorse-test262-residual-rescope

**Repository measured:** `endojs/endo-but-for-bots` · **Branch/PR:** `feat/ironhorse-262-language-completion` → endojs/endo-but-for-bots#970 (OPEN, draft, head `b3c3ae93b8`) · **Pins:** test262 `be13516fb`, XS oracle `23b4d6b0`. I made **zero code commits, posted zero children, relaunched nothing** — this is a re-scoping proposal for the maintainer, delivered via `message-user.sh` (`20260816T043249Z-9fac1a`).

### Evidence read
- `jobs/tada/ironhorse-js-26-residual-gap-closure.md` (the residual-gap-closure handoff)
- `docs/reports/ironhorse-test262/20260814-b3c3ae93b8/report.json` (the authoritative full-suite report, 51,976 cases, run at the required pins) — I re-derived every histogram below from it directly.
- The js-26-residual-closure orchestration (HALTED at child 9/15), js-25, js-27, and all 58 parked `jobs/plan/` frontmatters.

### The premise is disproven by the campaign's own report
Baseline 08-08 → head `b3c3ae93`: covered 4,740 → **23,496** (×5), but **23,427 actionable cases remain** (23,233 unsupported + 194 ironhorse-failure). The decisive fact: **41% of the residual (9,510 cases) is generic `ironhorse-aborted`**, plus 1,825 `abort-value-differs` — these are not independent gaps, they are the *downstream shadow* of a few missing prerequisites (u/v regexp flag, `with`, exotic-object MOP, TypedArray core, eval). The "one handler closes one cluster" model can't touch them because the aborts are entangled with the prerequisites. Every child posted at the 2400s default hit rc=124 and got reaped — 58 parked jobs, dozens of halt/doom notices, no landed work. Honest campaign spend is already **3,307,979 tokens vs the 2,080,000 approved**.

### Answer 1 — Closeable inside the ~3.98h (14,328s) claim cap
Rewrite each to `handler-timeout: 14000` (they carry the 2400s default today):
| Work | Actionable | Why it fits | Timeout |
|---|---|---|---|
| 9 `ironhorse-intl-*` ECMA-402 formatter families | ~2,179 (Intl total) | Proven host-only-exclusion pattern (child-20 ListFormat/PluralRules, js-25 Temporal); one constructor family per handler | 14000 each |
| **Branch-regression fixer** (see item 3) | 6 + 185 | Bounded defect fix, not a cluster closure | 7200 |
| Date | 586 | Self-contained builtin family | 10800 |
| DataView / Atomics / resizable-ArrayBuffer | ~450 / 156 / ~290 | Bounded once TypedArray core lands | 10800–14000 |

### Answer 2 — Multi-day; need decomposition into landable increments or a different vehicle (NOT a handler)
Grouped actionable counts (path-based) from the report:
| Cluster | Actionable | Note |
|---|---|---|
| language expr/stmt/eval-code/args | 5,474 | ~2,056 are `ironhorse-aborted`; broad language semantics |
| Object/Array/Reflect/Proxy MOP | 3,589 | exotic-object MOP + defineProperty/gopd |
| TypedArray/ArrayBuffer/DataView/Atomics | 3,109 | 1,194 aborts in TypedArray alone → missing core prerequisite |
| RegExp u/v/unicode | 1,316 by path, **but u/v flag reason = 2,870 cross-cutting** | u/v flag also gates Temporal/String/language aborts — a whole Unicode-aware regexp engine |
| eval/Function/dynamic-import | 1,945 (`eval` 664 + `module` 361 + dynamic-import) | needs runtime compile + module loader; architectural |

These are **prerequisite-first**: fix the prerequisite, a cascade of aborts clears. Recommendation: run each as a **standing milestone PR** that commits partial coverage gains incrementally, rather than a handler that must fully close a cluster in one wall.

### Answer 3 — The 58 parked `ironhorse-*` jobs
- **DROP — 11 doomed (no residual value):** 8 stale gauntlet review artifacts (`js-00..05-gauntlet-panel-*` ×6, `ca-regexp-*-gauntlet-clean` ×2 — their implementation already landed) + 3 deadline-overrun causal children (`cc-mop-gopd-keys`, `ce-toprimitive-coercion`, `ch-async-fromasync-a-asyncfromsync`).
- **KEEP + rebudget — 9 intl families:** rewrite to 14000 (best-scoped work in the queue).
- **CONSOLIDATE — ~37 over-fragmented js-26 causal sub-children** (cf-ta split into 13, cc-mop into 6, cb-with into 3, ch-async into 5, plus cj/ck/cl/cm/cn/cz/eval/iterator/map-set): collapse each family back to ONE per-family milestone job with a real budget targeting the prerequisite; they fragmented but still inherited 2400s and still share a missing-prerequisite root.
- **DROP — `ironhorse-resume-3-launch`:** it launches the disproven 21-child (js-08..js-28) one-arc campaign that produced this loop.

### The three js-26 open items
1. **js-27/js-28 ordering:** js-27 correctly signalled `orchestration-failed` (zero-everything gate unreachable mid-flight); the interim report *is published and adequate* for this scope decision. Recommendation: block only the *final* refresh (and js-28 summary) on the specific milestones the maintainer picks — not on the whole residual.
2. **js-25 death:** **already reconciled** — `ironhorse-js-25-temporal-integration` is in `jobs/tada/` (out of doin), its commits `a30cceaf30` + `b3c3ae93b8` are on the branch, `cargo test --workspace --release` passed. No action needed.
3. **Branch regressions:** 6 baseline-covered paths regressed to `unsupported` (`Set.prototype.keys`, `trimLeft`/`trimRight` Annex-B refs, 3 strict `abort-value-differs`) + 185 RegExp negative over-acceptances (missing regex early-error validation). These put the branch **below baseline** → highest-priority dedicated **fixer** (7200s), not folded into a multi-day cluster.

### Follow-ups (maintainer decisions before anything is promoted)
- Approve the scope split (milestone PRs vs handler campaign) and a budget figure.
- Approve the parked-job dispositions (drop 11 doomed + resume-3-launch; rebudget 9 intl; consolidate ~37 causal children).
- On approval, a producer promotes the intl families + the regression fixer with real budgets; the multi-day clusters get milestone-PR vehicles.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-residual-rescope.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1278822 cached reads)
- Output: 19095 tokens
- Cost: $1.763703
- Wall-clock: 317s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
