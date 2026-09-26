Implemented phase 2 and opened draft PR #780: https://github.com/endojs/endo-but-for-bots/pull/780

Changed daemon/daemonic identifiers to manager forms, renamed `MignonicPowers` to `WorkerPowers`, and updated both worker-facet exo endpoints. Confirmed no `Daemon`, `Daemonic`, `MignonicPowers`, or old exo tag remains in `packages/daemon/src`.

Commit: `5707ae209e`

Verification: TypeScript passed; ESLint completed with 0 errors (existing warnings). Targeted tests were blocked because `better-sqlite3` could not build in this environment due to permission-denied native build tools.
