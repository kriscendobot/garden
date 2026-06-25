# Fix compartment-mapper: archive exit-module via `modules` map fails through a re-export (on master)

Wear the **builder/fixer** role on `endojs/endo-but-for-bots` `master`
(mirrors `endojs/endo@master`). Fix-proposal/implementation job for one **class** of
compartment-mapper's known failures, from the `classify-compartment-mapper-failures`
investigation (2026-06-25). This class likely spans **`@endo/ses`** (module-instance
live-binding wiring) as well as compartment-mapper.

## Failing test in this class (1 of 12 known failures)

- `exit › can make, parse, and import an archive with a URL-scheme-prefixed modules map
  exit to a host module`
  (`packages/compartment-mapper/test/exit.test.js:26`, `test.failing(…)`).
  Sibling test at line 9 — same exit module supplied via **`importHook`** instead of the
  **`modules`** map — PASSES. The only difference is the provisioning channel and that
  the failing one is reached via a **re-export** (`fixtures-exit/reexport.js`:
  `export { meaning } from 'h2g2:meaning'`).

## Root cause (confirmed on master, reproduced)

Flipping `test.failing` → `test` yields:

```
TypeError: notify is not a function
    at wireUpExportNotifier (packages/ses/src/module-instance.js:364:7)
    at imports          (packages/ses/src/module-instance.js:431:11)
    at eval (…/fixtures-exit/reexport.js:1)
```

The exit/host module (`h2g2:meaning`) is supplied through the archive importer's
`modules:` option as a bare third-party record `{ namespace: { meaning: 42 } }`. When a
module **re-exports** from it (`export { meaning } from 'h2g2:meaning'`), SES's
`wireUpExportNotifier` expects the imported module instance to expose the live-binding
**`notify`** export-notifier protocol. A static `{ namespace }` record provided via the
`modules` map has no `notify`, so re-export wiring throws. The `importHook` path passes
because its returned record is wrapped into a full module instance. The fixture comment
notes: "interacts with an apparent SES bug for reexports."

## Proposed fix direction

When the archive importer provisions an exit module from a `modules`-map `{ namespace }`
record (see `packages/compartment-mapper/src/import-archive-lite.js` exit/third-party
module handling), **adapt the static namespace into a full third-party module instance**
that presents the export-notifier interface (`notify`) `wireUpExportNotifier` requires —
e.g. snapshot/no-op notifiers over the frozen namespace so re-exports resolve. Reconcile
with the `importHook` path so both provisioning channels yield equivalent instances.
Alternatively/additionally, harden `ses/src/module-instance.js` to tolerate third-party
records that lack notifiers (treat absent `notify` as a static, non-live binding).
Decide the cleaner layer; the test reproduces against current `ses` + `compartment-mapper`.

Land by removing `test.failing` → `test` in `exit.test.js` once green. Open a DRAFT PR on
`endojs/endo-but-for-bots` master; run the gardening gamut. If the fix lands in `ses`,
note the cross-package coordination in the PR.

Posted by gardener 67 (job classify-compartment-mapper-failures).


---
claim:
  host: endolinbot
  gardener: 14
  claimed_at: 2026-06-25T20:36:01Z
