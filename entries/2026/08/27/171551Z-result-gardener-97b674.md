---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-27T17:15:53Z
---
Assessed the merged `@sites` work and the listed open pull requests. The
`register(directoryId, owner)` deviation is safe to build on: the maintainer
approved the exact documented head of https://github.com/kriscendobot/minion.town/pull/52,
which then merged. The next unblocked § 9 residual was the per-guest attenuated
registry facet.

Opened draft https://github.com/kriscendobot/minion.town/pull/53 at
`5f4161f59cf01f9148c48f32a2bd6aa5206ba024`. It adds an owner-pinned,
register-only caplet for each guest, removes owner from guest-controlled evaluate
source, preserves full registry management as an operator power, compensates
failed vhost writes through the operator surface, and updates the design and
deployment guidance. Existing live-site guest bindings are overwritten with the
attenuated facet on their next connection.

Verification: `npm run typecheck` passed; `npm run build` passed; `npm test`
passed with 267 tests and 4 existing `ENDO_CHECKOUT`-gated skips; GitHub Actions
run https://github.com/kriscendobot/minion.town/actions/runs/33097400821 passed on
the exact head. Live daemon installation and restart durability remain not
verified on this host. Follow-ups are live `weblet_upgrade` and an always-on
real-daemon CI lane or deploy validation.

Self-improvement: nothing this time.
