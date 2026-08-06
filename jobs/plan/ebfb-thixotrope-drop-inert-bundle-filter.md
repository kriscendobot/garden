---
gate: deferred
priority: normal
posted_by: fixer
posted_at: 2026-08-06T06:58:34Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

One-line cleanup in `endojs/endo-but-for-bots`: remove the inert
`packageDependenciesHook` / `EXCLUDED_PACKAGES` pair from
`packages/thixotrope/scripts/bundle-xs-worker.mjs`.

Provenance: kriskowal on endojs/endo-but-for-bots#124, comment
https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3726273534
-- "The extra -and-braces do not pay for themselves given the cost to
upkeep this arbitrary list of exclusions. Please remove the package
filter hook and validate. It is a deception if this expedient appears
to be necessary. ... This is generally good advice when employing
`makeBundle` and could be triggered with a grep for `makeBundle` over
future diffs."

PR #124 removed its own copy (in
`packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`) after
measuring it to be a no-op. The thixotrope copy is the second
instance -- its own comment says "Mirrors the exclusion convention of
bundle-bus-daemon-rust-xs.mjs" -- and it is inert for the same reason.
Measured 2026-08-06: its list is `['ses', '@endo/init',
'@endo/lockdown']`, and bundling `worker-peer-xs.js` fires the hook's
exclusion log **zero times**. `makeBundle` retains only the modules
the entry point's import graph reaches, so an unreached package costs
nothing whether or not the compartment map lists it.

Not done on #124 because that pull request does not otherwise touch
`@endo/thixotrope` and widening it was not worth the review surface.

Do:

1. Delete `EXCLUDED_PACKAGES`, `packageDependenciesHook`, and the
   `packageDependenciesHook,` line in the `makeBundle` options for the
   worker-peer bundle. Keep `commonjsLanguageForExtension`.
2. Validate byte-identity, not just success:

       cd packages/thixotrope
       node scripts/bundle-xs-worker.mjs && md5sum dist-xs/worker-peer.js
       # then apply the edit and re-run; the md5 must not change.

   Baseline on `slot-machine` at `6dd56bdf5`:
   `ec4c742ea085ccb66dd5500102158d0c` (983779 bytes). Recompute your
   own baseline on whatever base you branch from rather than trusting
   that digest.
3. If a future entry point ever DOES reach a Node-only module, the
   remedy kriskowal names is to parameterize the package's `exports`
   for the `xs` / `endor` build condition, not to reintroduce a
   dependency filter. Pruning a reached dependency does not work at
   all: it converts the static import into an unresolvable specifier.
4. Consider the grep kriskowal suggests -- flag any new
   `packageDependenciesHook` next to a `makeBundle` in review. That is
   a jury-seat or pre-push-gate concern; if you add it, wire it where
   the other mechanized Endo conventions live rather than as a
   one-off.

Note: `bundle-xs-worker.mjs` also writes THROWING STUBS for any absent
`include_str!` input of the xsnap crate (`ses_boot.js`,
`worker_bootstrap.js`, `daemon_bootstrap.js`). Leave that alone in this
job -- it is load-bearing for `ci.yml`'s `build-xsnap`, and it is the
subject of the separate parked job
`ebfb-llm-xs-daemon-bundle-reconcile`.
