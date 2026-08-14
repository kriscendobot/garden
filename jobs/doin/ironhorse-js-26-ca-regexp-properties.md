---
role: builder
tier: mentor
handler-timeout: 14000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-14T22:55:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
Repository: endojs/endo-but-for-bots. Continue the existing shared branch feat/ironhorse-262-language-completion and draft PR https://github.com/endojs/endo-but-for-bots/pull/970 after predecessor ironhorse-js-26-ca-regexp-u-core. Use an isolated checkout keyed by this child, fetch/rebase the latest shared head, preserve all prior commits, and CAS-push back to that branch. Keep the PR draft/open.

Implement RegExp Unicode property escapes `\\p{...}` and `\\P{...}` with actual XS-compatible execution, including canonical property/value aliases, binary properties, general categories, scripts/script extensions, negation and ignoreCase behavior required by u/v modes. Port the pinned XS tables/algorithms or an equally deterministic pinned representation; do not skip, relabel, or paper over unsupported patterns. Pins: test262 be13516fb6441b950ba8a3df97eb34062c186972; Moddable XS 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d.

Add focused Rust tests under rust/engine/ironhorse-262/tests/ and lower-level oracle parity tests. Run relevant official RegExp/property-escape slices (and representative Temporal/Intl harness consumers), `cargo test --workspace --release`, and `ironhorse-xst --gate-meter-exact` before push. No baseline covered regression, new ironhorse-failure/infrastructure result, changed exact expectation, or generic unsupported/abort reason is acceptable in this feature scope. Report before/after totals/reasons, commands, head SHA, and PR URL; signal orchestration failure honestly if gates do not pass.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T22:57:07Z
