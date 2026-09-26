# Completion report — classify-compartment-mapper-failures

**What I did.** Set up `packages/compartment-mapper` on `endojs/endo-but-for-bots` `origin/master` (@`7c259920e`) in a disposable worktree and ran its full test suite under ses-ava (both the default and node-condition AVA configs). Confirmed the package is **byte-identical to `endojs/endo@master`** — the 31-commit bot-master drift is entirely pass-style / immutable-arraybuffer work and touches no compartment-mapper file, so **no bot-master reset was needed**.

**Count.** The known-failure set is **exactly 12**, unchanged on master: default config reports `902 passed + 12 known failures` (914 total), node-condition config `1 passed`. The 12 are AVA `[expected fail]` tests from `test.failing` and the scaffold's `knownArchiveFailure` wrapper.

**Classification — 3 root-cause classes (each reproduced by flipping the known-failure marker and capturing the live error/stack):**

1. **ESM dynamic `import()` not traced during archival** — 10/12. `dynamic-import-esm` ×5 + `optionalDependencies/esm` ×5, all archive-only combos (live paths pass). Archiver follows only static bindings; dynamically-imported modules are absent from the archive → `Cannot find external module "./foo.js" … in archive` at `import-archive-lite.js:75`. CJS variant passes, so it's ESM-dynamic-import-specific.
2. **CJS bundler aborts on missing/optional internal modules** — 1/12. `bundle cjs-compat`. Importer tolerates a missing `require('./spam')` as a deferredError (throws only if evaluated); `src/bundle.js` `recur`/`sortedModules` treats it as fatal and aborts the whole bundle.
3. **Archive exit-module via `modules` map fails through a re-export** — 1/12. `exit` URL-scheme case. A `{ namespace }` record supplied through the `modules:` map lacks the `notify` export-notifier; a re-export trips `TypeError: notify is not a function` at `ses/src/module-instance.js:364`. Likely spans `@endo/ses` + compartment-mapper (the `importHook` sibling passes).

**Jobs posted (one per class, on master):**
- `fix-compartment-mapper-esm-dynamic-import-archival`
- `fix-compartment-mapper-bundle-missing-deps`
- `fix-compartment-mapper-archive-exit-reexport`

Each names its failing tests, the reproduced root cause + error, and a concrete fix direction. All three pushed to the board successfully and are already being claimed by gardeners (now in `doin`).

**Surfaced.** Full classification (per-test mapping, reproduced errors, fix directions) written to the journal as a `result` entry (`entries/2026/06/25/175905Z-result-…`); a summary delivered to the maintainer inbox via `message-user` for the bulletin.

**Follow-ups / caveats.** No failure left unexplained. One judgment call worth flagging: Class 1 collapses two scenario files into one class/job because they share an identical root cause (one job, not two, to avoid flooding — per the job's "one per class" instruction). Class 3's fix may need to land in `@endo/ses` rather than compartment-mapper; the job notes the cross-package coordination. Disposable investigation worktree (`cm-investigate-c67`) torn down and pruned.
