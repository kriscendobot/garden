I applied all five must-fix items from the round-6 panel to PR #1390, and CI is green. All 33 checks pass at head `fa544951bc`, and `ci-wait-merge` returned rc 0.

**Commits pushed** to `endojs/endo-but-for-bots` `build/pet-name-path-only` (`93cbfe15fe..fa544951bc`, with `safe-push-pr-head.sh`; it only added commits):
1. **`88e41c8eeb` fix(spaces):** pet names in `send-form.js` (embedded names and a lone token) and in `space-chat/src/inbox.js` (endowment bindings) are now sent as one segment instead of being split on `/`. The recipient address in `send-form.js` is still split, as the panel said it should be. I added regression tests with `/` in the name to `send-form.test.js`, and the new send-form tests fail against the old `send-form.js`. A new `value-component.test.js` test checks that a renamed item stays in its directory.
2. **`a5a67de09c` fix(chat):** `mention-send.js` now numbers repeated edge names until each is unique (`-author`, `-author-2`, …). Before, three entries sharing a name made the daemon reject the send and the mention was dropped. A new test covers three colliding names.
3. **`2dcf789351` fix(daemon):** `namePathLabel` no longer throws on a valid name containing a lone surrogate; it writes it as `%uXXXX`, which keeps labels for different paths distinct. The property test now always includes such names, which removes the intermittent CI failure the panel flagged.
4. **`fa544951bc` docs(daemon):** removed the `NamePathArgumentShape` implementation-rationale sentence from `AGENTS.md`.

**Local checks:** the daemon `pet-name` tests (50) and the chat `mention-send`, `send-form` and `value-component` tests (26) pass. Prettier is clean and eslint shows no errors on the touched files. The repo-root `tsc` run reported no errors in them.

**CI:** the first run failed one leg, `test (24.x, macos-15)`, on `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. That test covers daemon shutdown, which this diff doesn't touch, so I reran the failed jobs once and the rerun passed. Treat it as a probable flake on that macOS leg.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (5561337 cached reads)
- Output: 23899 tokens
- Cost: $4.858352600000001
- Wall-clock: 6274s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
