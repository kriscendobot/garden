I applied the round-2 panel fixes to PR #201 and pushed them, but CI never ran. `ci-wait-merge.sh` gave up at the 3600 s deadline with rc 4, so this round ends as **still-pending**: no fix=done.

**Why CI is pending:** Actions run 39081797561 for head `d260d18` sat in `queued` the whole hour. None of its 3 jobs (`test` and the two Claude harness builds, all labelled `self-hosted, ci-minion-town`) started. Nothing is running anywhere on `kriscendobot/minion.town`, and queued runs go back to 2026-10-17T17:26Z (`main`, `feat/guest-coupons`, `feat/chat-clip`, and others). The self-hosted runner pool looks down or not picking up jobs. That is a fleet-wide problem outside this PR, and this host has no AWS access to look into it.

**Pushed** with `safe-push-pr-head.sh` (`b17d11d..d260d18`), in two follow-up commits:

1. **`dbfb622` fix(new-clip)** — the must-fix items from saboteur, breaker and wire-watcher, all in `src/endo/gateway/new-clip.ts`:
   - **Write race:** the power now runs its writes one at a time, so the 256-name directory limit holds when many calls arrive at once.
   - **No limit on the whole space:** the space is now capped at 4096 names and 1 Mi characters of text. Usage is measured on the first write after each restart, and removing or replacing a name gives its share back.
   - **`importLocator` could make the owner's daemon dial an arbitrary peer:** it now accepts only a locator whose node matches the owner's own node, with no `at=` peer hints.
   - **Should-fix items also done:**
     - `makeApp` refuses a name that already exists, so its rollback can no longer delete someone's existing entry.
     - `metamorphose` only accepts a directory that has an `inventory`, and its `form` write counts toward the limits.
     - The text-limit error now says "65536 characters" instead of the wrong "64 KiB".
     - `list` looks up entries in parallel.
     - `kindOf`'s `try` now wraps only `locate`.
   - **New test, `test/new-clip-power.test.ts` (6 tests):** it runs the power in a compartment over an in-memory space that yields between calls. It covers:
     - a burst of 300 concurrent writes that stops at exactly 256;
     - hitting the whole-space name and text caps, and the room coming back after a remove;
     - rejection of foreign-node, `at=`, and `https:` locators;
     - `makeApp` over an existing name;
     - `metamorphose` on a plain directory.
   - **Daemon test:** the error-message check is updated, and a new case rejects a locator from another node.
   - **`designs/new-clip.md`:** updated for the new limits.
2. **`d260d18` chore(new-clip)** — the pruner's cuts: comments that restated the code below them, the numbered step list in the browser-demo header, and two sentences in the design doc.

I also cut the PR body from about 358 words to about 120, linking to the design doc and the code header, and kept the `garden-job` marker.

**Local checks:** `npm run typecheck` is clean, and `vitest run test/new-clip*` passes 21 tests. The 2 daemon tests skipped because there is no Endo checkout here, so those and the browser demo only run in CI, which has not run yet.

**Not done:** the remaining should-fix items:
- the silent `.catch` calls in `list` and `main.js`;
- the 503/409 error mapping;
- extra `Sec-Fetch-Site` tests for `same-site` and `none`.

**Follow-up:** someone needs to restore the `ci-minion-town` runners. After that the driver can re-post this stage to collect the CI result before panel-3.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3574322 cached reads)
- Output: 27306 tokens
- Cost: $2.0704644
- Wall-clock: 3972s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
