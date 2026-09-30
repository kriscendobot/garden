I pushed the round-1 fixes to PR #1390, and CI is now green: all 33 checks pass with 0 failures on the current head `257db20fe5`, which contains my commits. My first wait's "green" was false, read from a 7-check rollup while the head was moving; this one covers the full set.

**My three commits (head `09350117e6` → `dbf3a3fd2b`, pushed with `safe-push-pr-head.sh`):**
- **`e405bbe6cd`** passes pet-name paths at six call sites that still passed bare strings, which the daemon now rejects:
  - the fae adopt tool
  - jaine's mention pre-adopt
  - chat's `onAdopt` and `onJoin` (plus their type casts)
  - both of whylip's `send` calls to fae
  - the file explorer's composed-view `evaluate`
- **`6d65d5d1e7`** brings types, names and docs into line with array-only paths:
  - `ReadableNameHub.lookup` and `maybeLookup` are narrowed to `readonly string[]`; `help.md` is updated and the help data regenerated.
  - The `…OrPath` parameters in `types.d.ts` are renamed, and `assertPowersNameOrPath` becomes `assertPowersNamePath`.
  - Stale JSDoc is fixed in `host.js`, `add-space-modal.js` and `claude-sandbox-factory.js`; comments in `interfaces.js` are corrected.
  - The `NamePathArgumentShape` and `toPetNamePath` comments are trimmed.
  - The daemon package typechecks cleanly (`tsc --noEmit`).
- **`dbf3a3fd2b`** changes the changeset: `@endo/sandbox` and `@endo/agentry` go from minor to major, and `@endo/space-whylip` is added.

**Pushed by other workers while CI ran:**
- `e8f163e01f`: renames the test's `db` local and switches to ASCII arrows.
- `9d3fb4f125`, `abaf878461`, `257db20fe5`: rename the lal `petNameOrPath` argument, sweep the remaining daemon parameter names, and add a test pinning `makeUnconfinedFromTree`'s rejection of a bare-string worker name.

**Not addressed** (the verdict marks these should-fix or comment-only):
- condensing the 35-commit history
- stating why the mount/platform-fs carve-out exists and how the PR relates to #1343
- `@endo/platform` trees still accepting bare strings
- a table-driven test of every guard position
- the wording in lal's `primer/tools.md`
- a new summary comment on the PR

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3679698 cached reads)
- Output: 16340 tokens
- Cost: $3.3813251999999996
- Wall-clock: 7104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
