The work is complete and verified. PR #656 is open against `llm`, base confirmed, inbox empty.

## Completion Report

**Job:** Build the Phase 4 `provideSubMount` sub-mount primitive for the daemon-mount capability in `endojs/endo-but-for-bots`.

**Delivered:** [PR #656](https://github.com/endojs/endo-but-for-bots/pull/656) — `feat(daemon): provideSubMount sub-mount primitive (Phase 4)`, base `llm`, not a draft.

**What I implemented** (`packages/daemon/`):
- **`host.js`** — `provideSubMount(mountName, subpath, newName, options?)`: resolves the parent mount's pet name to a formula id, then formulates the child under `newName` in a single deferred-task critical section (host-only, avoiding the GC race the design calls out). Wired into the `makeHostMaker` deps and the returned host method table.
- **`daemon.js`** — new `formulateSubMount(parentMountId, subpath, readOnly, tasks)`: derives the child root from the parent's host path via the existing `getMountHostPath` (which already rejects non-mount ids), **clamps `subpath` at the parent root** with `resolveSegments` so it can never traverse above the parent, plus a defense-in-depth realpath containment check against a symlinked subpath. The `mount` maker now honors `parent` (`context.thisDiesIfThatDies`), and `extractLabeledDeps` records the `parent` dependency edge.
- **`mount.js`** — exported `resolveSegments` (the existing `..`-clamping resolver) for reuse.
- **`types.d.ts`** — `MountFormula.parent?`, `DaemonCore.formulateSubMount`, `EndoHost.provideSubMount`.
- **`interfaces.js`** — `HostInterface.provideSubMount` method guard.

**Isolation design:** two independent boundaries — the child's own confinement root bounds all runtime operations (mount ops already clamp `..`), and the creation-time subpath clamp prevents escaping the parent at mint time. So `/project/src` cannot reach `/project/.env`, and a malicious `['..','..','etc']` subpath is clamped back to the parent root. This complements the already-landed transient `Mount.subView()` with the persistent, formula-minting variant.

**Tests** (3 new integration tests in `test/endo.test.js`): read-only attenuation (per-formula, not inherited, with disk cross-reference), sibling isolation (the canonical `/project/src` vs `.env` case), and subpath `..`-clamping.

**Verification:** all 37 `*mount*` tests pass (including the 3 new ones); `tsc` clean; `eslint` 0 errors (only pre-existing repo-wide `jsdoc/any` + `await-separator` warnings, none from new code). Running the suite required a workaround for a Unix-socket path-length limit (161 > 108 chars) caused by the long worktree path — I ran the tests from a short-path git worktree at the same commit — and building `better-sqlite3`'s native binding via `prebuild-install`, which the sandbox initially blocked.

**Follow-ups:** none blocking. Phase 4's `snapshot()` and snapshot-round-trip already shipped separately (PR #339); the remaining daemon-mount roadmap items (Phase 6 CLI `endo ls`/`cat`/`write`, scratch-mount GC) are out of scope for this job and tracked in the design.
