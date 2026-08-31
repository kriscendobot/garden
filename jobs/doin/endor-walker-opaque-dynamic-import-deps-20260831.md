---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restore the compartment-mapper fixture-parity ratchet to 32 exercised / 0 pending

Repo: `endojs/endo-but-for-bots`, base `llm`.

The merged fixture-parity campaign reached 32 exercised / 0 pending / 8 durable on PR #282, but current `llm` has an honest correction that reclassified `fixtures-dynamic-import-esm` to `PendingExclude`: compartment-mapper links all declared runtime dependencies when a package contains an opaque `import(specifier)`, while Endor's walker drops the declared `dep` compartment.

Build the missing opaque-dynamic-import declared-dependency inclusion capability in `rust/endo/src/entry_walk.rs`, graduate `fixtures-dynamic-import-esm` back to `Exercise`, and ratchet `EXERCISED_FLOOR` from 31 to 32. Preserve the corrected Node-oracle golden; do not mask the gap by changing the oracle. Add focused regression and break-target evidence, run the fixture parity test and golden drift check, run the relevant Endor/Rust gates, open the PR through the normal builder workflow, and drive its gauntlet.

Fresh regression evidence from `llm` head `12acf72927e148ba86b1f02a617b9e1a2d0000b8` on 2026-08-31:

`cargo test -p endo --test compartment_mapper_fixture_parity -- --nocapture`

passed 5/5 but printed `31 exercised / 1 pending / 8 durable`; the sole pending manifest entry is `fixtures-dynamic-import-esm` with capability `opaque-dynamic-import declared-dependency inclusion (Group B follow-up)`.

Local build setup requires `git submodule update --init c/moddable` plus gitignored empty `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` stubs when generated bundles are absent. Never commit those build-only inputs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-31T18:58:51Z
