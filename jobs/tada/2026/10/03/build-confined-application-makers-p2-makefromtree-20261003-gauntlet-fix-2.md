Fix round 2 on endojs/endo-but-for-bots#1419 is done: the panel's must-fix items are fixed and pushed, and CI is green (`ci-wait-merge` rc 0, 33 of 33 checks passed, 0 failed).

**Fixes applied (from the panel-2 review):**

1. **Captured archives no longer break XS (locked) workers (engine-realist).** `captureNodeModulesArchive` in `packages/daemon/src/capture-node-modules.js` was building archives with the archive-side parser set. That set turns `mjs` modules into `pre-mjs-json`, and the XS archive loader silently skips those. It now uses the import-side `defaultParserForLanguage`, which keeps the original source with parser `mjs`, `cjs` or `json`. I first tried a set limited to `{mjs, cjs, json}`, but compartment-mapper refused it because it also needs the `text` and `bytes` languages for its extension mapping. I added a short comment explaining the choice and dropped the unused `archive-parsers.js` import.
   - **New test** in `capture-node-modules.test.js`: it opens the produced archive and checks that every module's parser is `mjs`, `cjs` or `json`, and that the entry module's original source round-trips. With the old parsers the same test fails on `pre-mjs-json`.
2. **PR body (integrator):** added the missing `### Documentation Considerations` section between Scaling and Testing. It says no daemon or CLI docs describe `makeFromTree` (only `designs/` mention it), and that the changes are documented in the `EndoHost.makeFromTree` doc comment in `types.d.ts` and in the changeset. The Testing section now mentions the parser check.
3. **Fix-up commits folded (integrator):** `b36394cda7`, `eed5c72820` and this round's fix are folded into `feat(daemon): makeFromTree layout and entry options`, and `45c6d8cd73` into the changeset commit. The resulting code is byte-identical to before the fold plus this round's fix. The history is now: capture → canonical hook → layout/entry options → changeset → tree-layout tests → containment tests. I pushed with `safe-push-pr-head.sh --mode rewrite` (lease against a freshly fetched head), moving the head from `45c6d8cd73` to `241afb9f7c`.

**Checks run locally:** the `capture-node-modules` tests (14 passed), eslint on the changed files, and `yarn lint:types` in `packages/daemon` all pass. I did not rerun the full `endo.test.js` integration suite locally; CI covered it.

**Not done:** the panel's should-fix and comment-only items are left alone, since this stage applies must-fix items only:
- **purist:** drop the reserved `'package'` value from the enum and guard; narrow `treeKind`; tighten the types around the running-as layout; make `getTreeLayoutRunningAs` throw "not wired" like its siblings; share one entry-vs-layout check.
- **pruner:** shorten the Description bullets and the long docstrings.
- **engine-realist:** reduce the canonical hook's per-lookup allocation. Its locked-worker point is also open: no test runs these layouts on an XS worker yet. The new parser check covers the failure it described, but only on Node.
- **integrator:** the pnpm workspace-link test gap.

The next panel round can decide whether any of these should be required.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2443741 cached reads)
- Output: 14373 tokens
- Cost: $1.4139521999999998
- Wall-clock: 2521s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
