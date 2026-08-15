---
role: builder
tier: mentor
handler-timeout: 14000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T00:10:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
Repository: endojs/endo-but-for-bots. Continue shared branch feat/ironhorse-262-language-completion / draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after the Unicode children. Work in an isolated checkout keyed by this child and use fetch/rebase/CAS pushes; preserve all earlier commits and keep the PR open/draft.

Close RegExp named-group/backreference and modifier gaps with real XS-compatible execution: inline modifiers `(?ims-ims:...)`, scoped flag restoration, named capture parsing and duplicate-name/disjunction rules, forward and named backreferences, groups/indices.groups result objects, replacement named captures, and constructor/literal early-error consistency across u/v/non-Unicode modes. Do not merely change reasons or suppress cases. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; Moddable XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d.

Add focused Rust regression tests under rust/engine/ironhorse-262/tests/ plus lower-level oracle parity tests. Run affected official named-groups/modifiers/RegExpStringIterator/String slices, `cargo test --workspace --release`, and `ironhorse-xst --gate-meter-exact` before push. Preserve baseline and predecessor coverage with unchanged exact computron expectations. Report before/after totals/reasons, commands, head SHA, and PR URL; signal orchestration failure if the gated outcome is not achieved.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-15T00:10:24Z
