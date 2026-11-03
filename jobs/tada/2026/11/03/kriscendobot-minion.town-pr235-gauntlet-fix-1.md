I fixed both failing stages from the style prepass and pushed the fix to PR #235 (kriscendobot/minion.town). CI is green.

**What changed** (one commit, `0b0d7d8a`, on top of `16dad025`):
- **Abbreviated names (`spell-out-identifiers`):**
  - `src/resources.ts`: the `MCP_RESOURCES_DIR` environment variable is now `MCP_RESOURCES_DIRECTORY`. Nothing else in the repo set the old name, but any deployment that sets it outside the repo needs the new name.
  - `test/guide-recipes-daemon.test.ts`: `args` is now `toolArguments`. `makeDaemonTmp` comes from the shared test helper, so I left the name and added a `spell-out-exempt` marker at the top of the file. Two other test files already use the same marker for this helper.
  - `tools/guide-recipes/verify-production.ts`: `args` is now `toolArguments` and `commandArguments`.
  - `tools/guide-recipes/recipes.ts`: `args` is now `filled`.
  - `tools/guide-recipes/gen-facet-reference.mjs`: `outDir` is now `outputDirectory` and `args` is now `parameters`. `argGuards`, `optionalArgGuards` and `restArgGuard` are field names in Endo's method-guard data, so I kept them and added a `spell-out-exempt` marker on the line after the shebang. The exemption covers the whole file.
- **Ellipsis (`typist-friendly-code-points`):** in `resources/guide/invitations.md` line 24, both `…` characters in the locator example are now `...`.
- I left the optional note about the long comment at the top of `src/resources.ts` alone, because it explains the per-session snapshot and why there is no separate access check.

**Checks:**
- Both probes now pass against the base `origin/main-3f6c2b2`.
- The type check (`tsc --noEmit`) passes.
- `test/resources.test.ts` passes (21 tests).
- I did not run `test/guide-recipes-daemon.test.ts` locally; it needs a real daemon.
- `ci-wait-merge.sh` returned 0 after about 3 minutes: 4 checks, none failed.

No follow-ups. The driver posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1018274 cached reads)
- Output: 5731 tokens
- Cost: $0.7642028
- Wall-clock: 324s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
