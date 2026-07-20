Implemented and pushed `8ec780c5ac` to `main2`.

- Added builder guidance for agoric-sdk exo guards, citing `CONTRIBUTING` § TypedPatterns.
- Added spec-keeper’s argument/return guard-tightness check.
- Extended its panel probe for loose `M.any()`/`M.record()` in exo/interface guard diffs.
- Verified shell syntax, whitespace, and panel firing on PR #15’s original guard diff (`57db88..98be847`): `spec-keeper` fired.
- Re-litigation: the same seat check and probe cover 396a141c (arguments), 63f630f8 (returns), and 9a12af5e (`withdrawHandler.handle` return).
- Closed journal cluster `exo-guard-matches-static-type`.

Follow-ups: none.
