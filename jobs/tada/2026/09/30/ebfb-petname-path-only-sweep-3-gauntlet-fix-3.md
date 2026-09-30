**Fix round 3 for endojs/endo-but-for-bots#1390 is pushed, but CI was still running when the one-hour wait ran out** (`ci-wait-merge` returned rc 4). At the deadline, two jobs were still pending, `test (22.x, ubuntu-latest)` and `test (22.x, macos-15)`, and none had failed.

I applied all five must-fix items from the round-3 panel review (5372566187). They went up as seven follow-up commits, pushed with `safe-push-pr-head.sh` (`5762b151c2` → `082a97a1ee`):

1. **`lal` `evaluate` `workerName` (typist):** it is now typed as a pet-name path and guarded the same way as `resultName`. The literal `"undefined"` value an agent may send still works, and the tool summary says the argument is a path. A new `packages/lal/test/evaluate-dispatch.test.js` covers it.
2. **`packages/daemon/AGENTS.md` (archivist, surfacer):** added a section explaining that daemon methods take only pet-name paths. The `string | string[]` rule is now limited to the Mount surface, which still accepts a string. The `form`, `lookup`, `has` and mount-provider examples are corrected.
3. **Changeset (migrator):** I bumped `@endo/lal` from patch to minor and noted the `workerName` change. A peer has since raised it to major.
4. **Scratch-name collision (saboteur):**
   - **Encoding:** a new `namePathLabel` helper percent-encodes each path segment and joins them with `%2F`. So `['team-a','bob']` and `['team','a-bob']` no longer both map to `scratch-team-a-bob`.
   - **Compatibility:** an ordinary one-segment name keeps its old `scratch-<name>` form.
   - **Tests:** unit and property tests, plus a daemon test that runs both colliding paths.
5. **Parameter names (stylist):** every `NamePath` parameter the panel listed in `host.js` and `guest.js` is renamed `…NamePath`. I also renamed `endow`'s parameters and guest `form`'s `recipientName`, which weren't on the list. Worker labels built from these paths used to come out comma-joined; they are now joined with `/`.

I also did two of the smaller should-fix items: the two inline `import()` type references in `manager.js`, and the `chat` mock's `cancel` parameter.

**Local checks:**
- The `lal` tests passed (34), as did the pet-name tests (49) and 75 related daemon tests, including the new collision test.
- 47 `chat` component tests passed.
- `tsc` is clean for `daemon` and `lal`, and so is the repo-root check over the test files I touched.
- eslint shows no errors and prettier is clean.

**Peer pushes after mine:** other agents pushed on top of my commits, and the head is now `15f46bb218`. My commits are all still in it; CI on my own push was cancelled when theirs superseded it, so the pending run is on their head. One peer commit (`d7a227c8eb`) fixed two `...workerNamePath` spreads that my scripted rename missed. They behaved the same, since the path is unchanged after validation, and I found no other misses.

**Should-fix items left:**
- A shared validated parser for the inline `split('/')` sites.
- Folding the integrator's scope-less commits into package-scoped ones.
- Trimming the PR body.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 166 tokens (9497365 cached reads)
- Output: 37973 tokens
- Cost: $3.8747410000000015
- Wall-clock: 4247s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
