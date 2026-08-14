---
role: builder
tier: mentor
handler-timeout: 14000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-14T22:25:06Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 14000
Repository: endojs/endo-but-for-bots. Work on the existing shared branch feat/ironhorse-262-language-completion (draft PR https://github.com/endojs/endo-but-for-bots/pull/970); do not create another branch/PR, merge, or undraft it. Obtain an isolated checkout with ensure-project-worktree.sh keyed by this child basename. Fetch first and preserve all commits; push bounded commits to the shared branch with a fetch/rebase/CAS loop.

Implement real XS-compatible RegExp Unicode (`u`) execution in ironhorse-regexp and its VM/compiler integration: astral code-point decoding and consumption, surrogate behavior, Unicode-aware atoms/classes/dot/quantifiers/backreferences, ignoreCase/canonicalization interactions, and correct flags/accessors. Remove the current `CompileError::Unsupported("u/v flag (unicode)")` path only where real execution is implemented; never relabel or suppress. Port behavior and metering from the pinned Moddable XS oracle (`c/moddable` at 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d). Test262 is pinned at be13516fb6441b950ba8a3df97eb34062c186972.

Add focused Rust unit/regression tests under rust/engine/ironhorse-262/tests/ plus lower-level parity tests as appropriate, all differential against the official XS oracle where applicable. Run focused official slices including built-ins/RegExp and language/literals plus any impacted Temporal cases, `cargo test --workspace --release`, and the proprietary exact-metering corpus (`ironhorse-xst --gate-meter-exact`) before push. Preserve exact computron expectations and every starting covered case. Report commands and before/after totals/reasons, head SHA, and PR URL. If completed but a gated outcome fails, end with the required orchestration-failure signal before the completion signal.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T22:27:17Z
