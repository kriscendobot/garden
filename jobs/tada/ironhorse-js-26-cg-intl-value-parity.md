---
handed-off: ironhorse-intl-value-parity-orch
deliverable-complete: false
---
Inbox is empty. The work is complete as a declared handoff. Here is my report.

---

## Completion report — `ironhorse-js-26-cg-intl-value-parity`

**Outcome: diagnosed + durably decomposed and handed off.** No code landed this pass (correctly — the cluster requires real engine implementation that would be unsafe to half-land against the regression invariant).

### What I did
- Built the release runner (`ironhorse-xst`, `ironhorse-262-report`), inited the pinned `c/moddable` oracle submodule, and ran the real XS differential on a representative slice (`intl402/DisplayNames`, via `full-run.sh`): 45 `abort-value-differs`, 6 `unsupported-opcode`, 6 `oracle-host-missing-intl`.
- Wrote throwaway `dual_run` diagnostics to get the exact per-case failure mode across all ten families (deleted before finishing; tree left clean).

### Root cause (measured at engine head `cf9247cd0`, oracle `23b4d6b0a6`)
- **The pinned Moddable XS oracle has no ECMA-402 host** — `Intl` is an undefined global, so for every Intl-host case the oracle throws `ReferenceError: get Intl: undefined variable`. These cases can therefore never be "covered" in the both-engines-agree sense; the **accepted terminal is `oracle-host-missing-intl`**, reached only when Ironhorse runs the case to completion with the correct value (the exact host-only-exclusion pattern child-20 established for ListFormat/PluralRules in `tests/intl_formatters.rs`).
- The `abort-value-differs` (804) reasons are **Ironhorse throwing `TypeError` where it must complete**, because **four constructors are entirely unimplemented** — `Intl.NumberFormat`, `Intl.DisplayNames`, `Intl.DurationFormat`, `Intl.RelativeTimeFormat` (all `typeof === 'undefined'`; not registered in `create_intl`) — and **five are partial** (`DateTimeFormat`, `Locale`, `Collator`, `ListFormat`, `Segmenter`). The `Collator` sort cases hit a cross-cutting `Array.prototype.sort:data-dependent-comparison-metering` unsupported stop. The `Number/Array/BigInt.prototype.toLocaleString` bridges are `ironhorse-aborted`/unsupported where **XS itself completes** — genuine `covered` opportunities.

### What changed (durable continuation)
Rather than relabel or weaken the classifier (explicitly forbidden), I posted a **nested serial halt-on-failure orchestration `ironhorse-intl-value-parity-orch`** with **10 per-family children** (each carries the full pins, acceptance bar, regression invariant, shared-branch rules, and its measured causal diagnosis + repro):

`numberformat` (first — foundational) → `core-tolocalestring` → `displaynames` → `relativetimeformat` → `durationformat` → `datetimeformat` → `locale` → `collator` → `listformat` → `segmenter`.

Verified on the board: `jobs/orch/ironhorse-intl-value-parity-orch.md` + all 10 children parked (gate `orchestrated`) in `jobs/plan/`.

### Notes / follow-ups
- Messaged the maintainer (`inbox/maintainer` 20260815T012602Z): flagged the standards reframing (host-only-exclusion, not "covered") and the **fleet-cost implication** — 10 builder-grade (Opus) engine-implementation children — given the gardener-pool quota throttle; suggested gating promotion cadence.
- PR endojs/endo-but-for-bots#970 left OPEN/draft; nothing merged. Shared branch head unchanged at `cf9247cd0`.
- The `Array.prototype.sort` data-dependent-comparison metering blocker (in the `collator` child) is cross-cutting with the general-engine metering backlog and may share a root fix.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-cg-intl-value-parity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (5269791 cached reads)
- Output: 50443 tokens
- Cost: $5.1047545
- Wall-clock: 798s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
