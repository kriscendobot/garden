## Completion report: build-daemon-worker-import-from-mount

I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1559**, "feat(daemon): makeFromPackage runs package.json-rooted trees". It targets the pinned base `llm-d5ac419` from head `daemon-worker-import-from-mount` and touches `@endo/daemon` and `@endo/spaces-util`. All new tests pass locally on the Node daemon supervisor; CI on the PR had not been checked when I finished.

**What it does**
- `EndoHost.makeFromPackage(workerName, sourceName, { entry, registryName, offline, …caplet options })` runs a confined caplet from a readable tree or mount whose root holds a `package.json`. No `node_modules` directory is needed.
- There is a new `make-from-package` formula with slots for the worker, powers, source and registry. I wired it through every place `make-from-tree` appears: formula type, labeled dependencies, cancel-with-worker, `getFormulaEnvironment`, the formula record, and the spaces-util view registry.
- **The daemon resolves the dependencies.** It reads `package.json` from the source and calls `@registry` (or the `registryName` option) with `offline` passed through. Only the finished resolution goes to the worker; the worker never holds the registry.
- **The worker** (new `src/package-read-powers.js`) lets compartment-mapper's normal dependency walk run over a synthetic file tree:
  - the source is at `file:///entry/`;
  - each resolved package is at `file:///packages/<name>@<version>/`;
  - each package root has a virtual `node_modules/<name>` only for the names that package declares, pointing at the resolved version that satisfies its range. So several major versions of one dependency can coexist.
  - Without `entry`, the package's own `exports`/`main` module runs.
- XS workers refuse the method with a clear error.

**Differences from the design sketch** (explained in the PR body and in a status note in the design)
- The sketch resolves inside the worker through `mapSnapshot`. I resolve in the daemon instead, because the open #1117 amendment and the design that replaced the registry capability require it.
- The formula keeps its `registry` slot so a restarted caplet re-resolves against the same registry. That amendment text says to drop the slot; I kept it because the daemon needs to know the registry when it rebuilds the caplet after a restart.
- `mapSnapshot` produces empty module tables and `importLocation` takes no `compartmentMap` option, so I used compartment-mapper's own walk. No compartment-mapper extension point was needed.

**Tests**
- 7 unit tests drive the real compartment-mapper over in-memory trees: multi-major linking, a real `node_modules` being ignored, undeclared dependencies being absent, `canonical`, directory probes, an explicit entry, and an entry outside the package root. Making selection ignore the declared range fails 4 of them.
- 4 daemon tests use a registry served on loopback by the test: a full run (including two majors at once), restart and rebuild, an offline miss, and a source with no `package.json`.
- The existing `makeFromTree`, `makeArchive`, `getFormulaEnvironment`, formula, XS-facet and help tests still pass. The daemon type check is clean, and the root type check reports nothing in the changed files. The pre-push gates pass and the related-design gate for #1117 is clear.

**Not built (later phases):** `makeFromMount`, the `endo run/make <mount>` CLI with `--offline`/`--registry` (Phase 3), and snapshotting a live mount before import with lifetime coupling (Phase 4). A live mount is read in place, as `makeFromTree` does. The ledger marks Phases 3–6 not-applicable to this Phase 2 delivery and cites the integration tests as acceptance.

**Garden fix pushed to `main2` (commit `863da8d4a68`):** the `spell-out-identifiers` pre-push check read a JSDoc line like ` * @param … args.x` as code and flagged the existing `args` parameter. Lines starting with `*` are now treated as comments; abbreviations in real code still fail. I added a regression test and confirmed it fails without the fix.

**Notes**
- To run the daemon locally I swapped in a Node 22 build of `better_sqlite3.node` in this job's project worktree only. The cached build was for a different Node version, so the daemon would not start.
- The gates' auto-fix rewrote typographic characters (`…`, `’`) on unrelated lines of `designs/README.md`. I reverted that so the PR only changes the status row.
- Possible follow-up: the old pet-inspector lookup lists no `make-from-tree` type, so its `make-from-tree` branch is never reached. I didn't add `make-from-package` there either. `getFormula`'s formula record covers the new type.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-worker-import-from-mount.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 236 tokens (23635221 cached reads)
- Output: 85472 tokens
- Cost: $8.739468200000003
- Wall-clock: 1468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
