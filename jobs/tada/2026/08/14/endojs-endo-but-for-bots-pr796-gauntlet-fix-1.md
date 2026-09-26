FIX round 1 for endojs/endo-but-for-bots PR #796 (`feat/hashline-core`) complete. Applied the panel-1 must-fix items once, pushed as review-feedback follow-up commits, and CI is green.

**What I did**

Read the panel-1 verdict (a COMMENTED review — kriscendobot authors the PR, so GitHub blocks a request-changes on it; the juror blocks are the verdict) and applied the consensus must-fix items to `packages/daemon/src/hashline.js` + its test, in one commit (`f5854aa18a`):

- **Off-contract 3-char anchor width** (flagged by ~10 jurors incl. corner-prober must-fix-loop): tightened `validateAnchor` and the textual `parseAnchorToken` regexes from `{2,4}` to `{2}|{4}`; added rejection tests in both the JSON-envelope and textual paths.
- **Silent reapply relocation** (breaker must-fix + wire-watcher): added an optional `relocations: AnchorRelocation[]` to `EditResult` so a caller can tell a clean landing from a relocated (possibly colliding) 8-bit anchor; added assertions to the reapply tests + a no-relocation-omits-field test.
- **Style/doc**: `numWidth`→`numberWidth` (stylist); corrected the `SpliceAction` typedef and the "strictly inside range" wording (typist/assessor/prover/corner-prober); the inline `import()` JSDoc→`@import` in the test file (typist must-fix); reframed the changeset (releaser); flipped `designs/cli-edit-verb.md` Status to *In Progress* with landed-phase/deviation notes and corrected the stale `designs/README.md` rows (integrator).

**What changed**: 5 files, +128/−43. Local gates all clean: 41 tests pass (was 38), `tsc` + `test:types` 0, eslint 0 errors, prettier clean.

**CI**: pushed via `safe-push-pr-head.sh` (advance mode, `5fd12dd429→f5854aa18a`). First run hit an **unrelated flaky hang** in `@endo/genie`'s `petname-paths-autocomplete-confined` component test (Node-24-Ubuntu leg only, "Failed to exit"/SIGINT — nothing in `@endo/daemon`; the other three test legs were green first pass). Re-ran the failed job; it cleared. Final: **26/26 green** (independently confirmed by `ci-wait-merge.sh`: `failed=0 → CI GREEN`, rc 0). Posted a completion-summary comment (issuecomment-5291569169) naming the head SHA, the fixes, the regression evidence, and green CI.

**Follow-ups deferred** (noted in the PR comment, not must-fix): CRC32 hoist to share `@endo/zip`'s table (purist — needs a new zip subpath export); `TextEncoder` inject/guard for eventual XS bundling (engine-realist); property-based/edge-case test additions (fast-checker, corner-prober summary-fix items). The driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 171 tokens (10800263 cached reads)
- Output: 48258 tokens
- Cost: $8.106143499999996
- Wall-clock: 3574s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
