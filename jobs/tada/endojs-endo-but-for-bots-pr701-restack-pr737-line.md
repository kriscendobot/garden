Restacked PR #701 onto bridge-2 `0a2d989961`; pushed `ff9f25c73a` with force-with-lease. PR remains draft with unchanged base.

Preserved cut-3 mint/export behavior and aligned it with the standalone sturdyref shim, camel-case discriminator, opaque locator handling, and bridge-2 APIs. Commented evidence on PR #701.

Passed: daemon TypeScript check; sturdyref-store AVA suite (6 tests). Full daemon/OCapN integration suites blocked by missing linked dependencies (`better-sqlite3`, `@endo/eventual-send`).
