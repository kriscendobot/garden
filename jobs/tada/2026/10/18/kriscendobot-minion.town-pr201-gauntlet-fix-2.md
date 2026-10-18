Round 2 fix stage is finished. A prior claimant of this job had already pushed the fixes, so I pushed nothing new. CI on the current head `d260d188` is green. `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing and 0 failed.

**Must-fix items from the round-2 panel (head `b17d11d3`), checked against the code at `d260d188`:**
- **Check-then-write race on `room()` (saboteur, breaker):** `dbfb622e` replaces it with a promise-chain mutex (`serially`). Every capacity check now runs atomically with the write it gates.
- **No total bound on the space (saboteur, breaker):** `dbfb622e` adds space-wide caps. `NEW_CLIP_MAX_SPACE_ENTRIES` is 4096 and `NEW_CLIP_MAX_SPACE_TEXT` is 1 MiB.
- **`importLocator` accepting foreign or `at=` locators (wire-watcher):** `dbfb622e` adds `checkLocalLocator`. It requires the locator's host to match the space's own node and rejects `at=` peer hints.
- **Related should-fix items also fixed in `dbfb622e`:**
  - `metamorphose` now runs through the same capacity check and only works on an app.
  - `makeApp` refuses an existing name, so its rollback can no longer remove pre-existing data.
- **Pruner cuts:** `d260d188` removes the comments that restate the code below them, and the PR body is trimmed to 124 words.

I did not re-run the panel, as the job says. The next panel round is where any remaining should-fix items will show, such as narrowing the `kindOf` try/catch and the 503 status mapping in `guest-self-endpoint.ts`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 96 tokens (3951792 cached reads)
- Output: 29551 tokens
- Cost: $2.3599334
- Wall-clock: 4000s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
