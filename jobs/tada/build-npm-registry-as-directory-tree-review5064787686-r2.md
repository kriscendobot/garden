Implemented the approved npm registry directory-tree design and opened draft PR:

https://github.com/endojs/endo-but-for-bots/pull/1117

Changes include shared platform tree guards, Node and Endor registry adapters, resolver/mapper migration, compatibility adapter, structured errors, read-consistency/integrity contracts, CAS-backed leaves, and cross-backend conformance tests. Existing fetch, SQLite, MVS, workspace, peer, optional-dependency, and multi-major behavior remains behind the adapters.

Pushed commit `8004180e4336b461a959514fbb1aa04161077277`; remote SHA matches and the worktree is clean.

Verification executed:

- `yarn install --immutable` — passed with workspace-local `TMPDIR`.
- Affected AVA suites — 27 passed.
- `packages/exo-npm` — 52 passed.
- `packages/platform` — 336 passed.
- Real Endor registry integration — 5 passed.
- Generated declaration checks — 5 passed.
- TypeScript checks for platform, exo-npm, and daemon — passed.
- `cargo check -p endo -p xsnap` — passed.
- `cargo test -p endo registry_tree --lib` — 4 passed.
- Changed-file ESLint, Prettier, rustfmt, and `git diff --check` — passed.
- Repository pre-push probes — 5/5 passed.
- Regression proof: deliberately removing the guard failed its test; restoring it passed.
- Repository-local verifier build passed. Its aggregate lint/test stages also exposed environment-only failures: lint traversed the Moddable submodule without its `@eslint/js` dependency, and Node 24 could not load the locally installed Node 22 `better-sqlite3` ABI. Targeted checks under the supported environment passed.

Self-improvement: pre-push probes caught inline JSDoc imports and ambient text-codec usage; both were corrected before the final push.

Follow-up: allow draft PR CI and maintainer review to complete. No upstream repository was mutated or merged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-npm-registry-as-directory-tree-review5064787686-r2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 7076s

<!-- garden-usage-end -->
