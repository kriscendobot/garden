## Fix round 1 — endojs/endo-but-for-bots#1408

I applied all nine must-fix seats' findings from panel review 5380069986. They went out as three follow-up commits on top of `2d05ca3ef2` (new head `1e58ba5d9b`), pushed with `safe-push-pr-head.sh`. CI is green: 35 checks, 0 failed (`ci-wait-merge` rc 0).

**What I fixed:**
- **assessor + purist (symlinked `claudePath`, an unneeded mount):**
  - Inside the slice, `claude` now runs by its real path. Only that real path's installation directory is mounted read-only, and the separate `claudePath` mount is gone. A global npm install's `bin` symlink now resolves its sibling files correctly.
  - A new test covers a symlinked `claudePath`. It checks that the real path is what gets run and that the link itself is not mounted.
- **purist (state kept in two places):** I removed the `spawnDirectoryByTag` map and the `prepareSpawnFiles` wrapper. The sandboxed `launch` now reads each spawn's files directory from its own `--settings` argument.
- **surfacer:** `index.js` now exports the slice's building blocks (`makeBwrapSpawn`, `assembleBwrapArgv`, `resolveSystemMounts`, `SYSTEM_DIRECTORIES`, `SYSTEM_ETC_ENTRIES`, `DEFAULT_SCRATCH_HOME`). `SliceMount` moved into `src/claude.types.d.ts` and is exported from the package's public types file.
- **curator + integrator:**
  - The README and a comment in `bwrap-slice.js` now say why `@endo/sandbox`'s `bwrap` driver isn't reused: its argv builder isn't exported, and it takes capability-shaped mounts while this harness runs host paths in place.
  - `designs/endo-claude.md`, `endo-claude-inference-backends.md` and `endo-guest-stdio-mcp.md` now note that the filesystem half of DD6 is this in-package `bwrap` slice. The network half is still open.
- **migrator, changeset-auditor, releaser:**
  - Added `.changeset/endo-claude-bwrap-slice.md` (`@endo/claude` minor) for the `sandbox` option and `--bwrap` flag.
  - Changed the out-of-date "DD6 `@endo/sandbox` slice" prerequisite line in `.changeset/add-endo-claude.md`.
- **pruner:**
  - Removed the README paragraph about how the tests and CI work.
  - Cut the PR body's Scaling Considerations to "None." and the line about local test results.
  - Replaced the Documentation Considerations tour with what actually changed in the designs and changesets. I kept all seven template headings, since the integrator seat confirmed the body follows the template.

**Checks:**
- Locally, all 87 package tests pass, and `tsc` is clean for the package and for the repo root.
- `eslint` reports no errors. One warning remains in `test/fixtures/fake-claude.mjs`, which this fix didn't touch.
- This host has no `bwrap`, so the live-slice test skipped locally. CI's `sandbox-drivers` job requires that test to run and was green.

**Not addressed:** curator's should-fix about the `--bwrap` flag being a second way into confinement alongside `@endo/claude-sandbox`. It's a design-level point, not a must-fix. Comment-only seats were not actioned.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3663839 cached reads)
- Output: 17236 tokens
- Cost: $1.9019038
- Wall-clock: 2967s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
