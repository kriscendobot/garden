---
role: fixer
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---
# Post the e2e-probe gap-report addendum on endojs/endo-but-for-bots#1372

Repo: endojs/endo-but-for-bots. The probe job endojs-endo-but-for-bots-ironhorse-panic-e2e-probe ran on a host whose PAT cannot comment on endojs PRs. Your only task: if https://github.com/endojs/endo-but-for-bots/pull/1372 has no comment with the marker `garden-probe-gap-report-addendum`, post the comment below, verbatim, with `gh pr comment 1372 -R endojs/endo-but-for-bots --body-file <file>`. Change no code. The PR stays draft.

----- COMMENT BODY -----
<!-- garden-probe-gap-report-addendum: endojs-endo-but-for-bots-ironhorse-panic-e2e-probe -->
**Addendum: gap report reconciled with the open-questions answers** ([#1018 answers](https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5886418488), design amendment #1370).

The mentat answers landed after this probe ran, so the "open-question decisions" review items in the PR body were written against the design's earlier leanings. Here is where each gap now stands:

| Gap | Status after #1370 | Owner |
|---|---|---|
| 1 FFI panic lets the guest run on to the crank boundary | **Still open.** #1370 describes the #1150 guard (poison, block further guarded effects, return `Panicked` at a safe Rust boundary). That amounts to candidate B, but #1370 never says the guest may run pure JS past the panic site, and it doesn't say where the debugger stops for this source. | design call → `ironhorse-panic-cxs-panicked-adapter`, `ironhorse-panic-debugger-panic-break` |
| 2 every `fxAbort` exit is reported as metering "terminated" | Unchanged (implementation choice) | `ironhorse-panic-cxs-panicked-adapter` |
| 3 seven C-XS `fxAbort` exits unclassified | **Partly answered.** Q1 settles `is_panic()` membership (Decode, StepLimit, ReentryLimit, HeapExhausted, and the rest), and Q8 adopts payload-preserving `PanicKind` nesting. The C-XS mapping of `NOT_ENOUGH_MEMORY`, `NO_MORE_KEYS`, `NATIVE_STACK_OVERFLOW`, and `UNHANDLED_*` is still unstated. | `ironhorse-panic-cxs-panicked-adapter` (+ `-halt-shape-unification` for Q8) |
| 4 no embargo | Unchanged. Q3/#989 scope-split: #989 keeps admission/quiescence, and this design owns durable release. | `ironhorse-panic-outbound-embargo` |
| 5 no Slot Machine home / which side writes | **Answered in part.** The supervisor owns records and the store implements persistence (Q6 boundary table). The module home for in-process workers is still unnamed. | `ironhorse-panic-transcript` |
| 6 a crank spans several envelopes | **Answered.** The XS loop needs #989's one-delivery admission before its crank markers can delimit the protocol. | `ironhorse-panic-transcript` (depends on #989) |
| 7 no replay mode | Unchanged | `ironhorse-panic-retry-replay` |
| 8 unclassified host callbacks | Unchanged | `ironhorse-panic-host-call-transcript` |
| 9 no restore point with open handles | Unchanged. Q3 adds transcript-first watermark publication with directory sync. | `-host-call-transcript` + `-retry-replay` |
| 10 no `<panic>` | Unchanged. The FFI case still depends on Gap 1. | `ironhorse-panic-debugger-panic-break` |
| 11 uncaught throw | **Answered (Q5).** CapTP rejections commit and continue. A throw that escapes the delivery adapter terminates and discards, which changes XS's current trace-and-continue behavior. The probe's `Mode::Throw` case can now be written. | `ironhorse-panic-retry-replay` |
| 12 Ironhorse not on the delivery path | **Filed (Q4)** in `ironhorse-engine.md` § Endor integration. It is still outside this orchestration. | unowned (stage 8/9 integration) |

The probe head `db4c6fd77b` is green on CI. The PR stays draft.
----- END COMMENT BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T09:55:41Z
