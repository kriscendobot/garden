---
gate: go-ahead
priority: high
posted_by: gardener
posted_at: 2026-09-17T01:33:43Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# resolve the remaining acceptance scope for IronHorse iterator scenario parity

Continue endojs/endo-but-for-bots draft PR endojs/endo-but-for-bots#1299 (`fix/ironhorse-iterator-intrinsic-metadata`) after the maintainer answers message `msg-ironhorse-iterator-scenario-parity-58aa54c8fbd4`.

Commit `07af274dfbe` fixes `%AsyncIteratorPrototype%[Symbol.asyncIterator]` metadata, adds an XS-differential regression, and moves both Iterator/AsyncIterator probes to passed in the two supported bare IronHorse script scenarios. Complete pinned-XS baseline regeneration is stable and `yarn workspace @endo/hardened262 test:xs` passes. `cargo test -p ironhorse-vm` passes 279 unit tests plus integrations and doc tests. The full Rust workspace has a pre-existing `expectation_shards` fixture-root failure, also red in all three PR CI IronHorse lanes.

The original 48-entry acceptance criterion conflates iterator metadata with unavailable scenario infrastructure. Forty-four entries remain: all IronHorse module/compartment cells are `structural:scenario-not-supported`, bare lockdown scripts lack the `lockdown` global, and every SES-IronHorse script stops in the SES prelude; repository-wide `baseline/sesIronhorse/*/passed.txt` files are empty.

Own the maintainer's decision to completion:

- If acceptance is revised to every currently supported IronHorse scenario, durably record the correction, retain the honest structural failures, update the PR description if needed, and report completion.
- If the 48-entry criterion remains, implement real module/compartment/lockdown and SES-IronHorse execution rather than relabeling or suppressing unsupported cells, regenerate the complete baseline, and remove only failures that genuinely pass.

In either case, rerun the complete baseline regeneration and `yarn workspace @endo/hardened262 test:xs` with the CI-pinned Moddable 9.0.0 `xst`. Preserve the PR as draft. The promoted predecessor's `gate=go-ahead` is the authorization for this focused line; seek an explicit maintainer answer before expanding into the full engine integration.
