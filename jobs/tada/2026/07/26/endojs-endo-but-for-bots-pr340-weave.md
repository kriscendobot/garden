<<<GARDEN-JOB-COMPLETE>>> — wait, let me first present the report.

## Completion report — weaver, endojs/endo-but-for-bots PR #340

**Task:** rebase `claude/endo-daemon-ocapn-FkmHO` onto the current `llm` tip, resolve conflicts preferring merged #806 semantics on overlap, keep the stack coherent, comment with the resulting head.

**Done:**
- **Rebased** onto `llm` tip `2b4a01e7b` (was 26 commits ahead / 182 behind). New head: **`83f55ea93`**, force-with-lease pushed to the PR branch.
- **Conflicts resolved** (both sides read, no `--ours`/`--theirs`):
  - `designs/README.md` — Mermaid graph + status table; wove both the base's `oortho` node/edges and this PR's `docapn` node/edges together.
  - `packages/daemon/test/invite-retention.test.js` — header `process`-global hunk.
  - `yarn.lock` — dropped the old lockfile commit and regenerated against the new base; the surviving `chore: Update yarn.lock` commit is now immutable-clean.
- **#806 coherence:** #806 landed in `packages/ocapn-noise/src/network.js`; this branch only touches `packages/ocapn-noise/src/transports/tcp.js` — no textual overlap, and the merged `network.js` is preserved verbatim. Verified at runtime: full `@endo/ocapn-noise` suite **56/56 green** across lockdown/unsafe/endo configs, including `late crossed hello …` (the #806 behavior) and the `network-tcp` framing tests that exercise this branch's graceful-reader change.
- **Rebase-induced lint fix** (new commit `83f55ea93`): the base migrated to flat ESLint config, which grants `globals.node` to `packages/*/test/**`, turning the four pre-existing `/* global process|setTimeout|Buffer */` directives into `no-redeclare` errors. Removed them; the base config now supplies the globals. This subsumes the earlier "declare Buffer global" commit's intent.
- **Enforcement clean:** `@endo/daemon` `tsc` typecheck ✓, ESLint 0 errors across all changed files ✓, `build:types:gen` no composite-tsconfig drift ✓, `yarn install --immutable` clean ✓.
- **Commented** on #340 with the head SHA, conflict resolutions, #806 coherence, and test status: https://github.com/endojs/endo-but-for-bots/pull/340#issuecomment-5084695102

**Notes / follow-ups:**
- PR base is the natural `llm` branch (not a frozen `<base>-<sha>`), so no base-field update was required.
- The stacked PRs **#684 → #688 → #693** base on this head — rebase them onto `83f55ea93` to keep the stack coherent.
- Daemon OCapN **integration** tests need built worker binaries (native `better-sqlite3` build fails in this sandbox) and were not run; the #806 overlap zone (`@endo/ocapn-noise`) was fully exercised instead.
