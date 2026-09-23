---
ts: 2026-06-17T20:36:17Z
kind: dispatch
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/designer--bacf49
short_id: bacf49
refs:
  - entries/2026/06/17/203002Z-dispatch-researcher-4151cb.md
  - entries/2026/06/17/203500Z-result-researcher-4151cb.md
---

# dispatch: designer — presence-severance-observation (researcher-refined)

Researcher precedence honored. Designer reads the inlined
refinement (researcher 4151cb's `## Library and project
references` block) before drafting.

Researcher's headline findings:
- Existing concept page `captp-bounded-transient-pin` is the
  closest prior art (different vocabulary: "partition" / "abort").
- `release-exo-lifetime-and-captp-partition` section EXPLICITLY
  flags this API gap and prescribes the fix — the proposed
  design picks up that thread.
- The local presence is already a discrete object at the
  value of the `presenceToHandler` WeakMap; severance hook
  attaches there.
- `makeCapTP` returns `{dispatch, getBootstrap, abort}` —
  the canonical local tear-down entry; `op:abort` is the
  peer-side wire signal.
- `cancellation-promise-as-platform-neutral-interface
  (Promise<never>)` is the candidate Observer API shape.

Base `llm` (HEAD 9a3b5e97f). DRAFT PR.
