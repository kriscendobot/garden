## Panel round 4: endojs/endo-but-for-bots PR #258 (gauntlet `endojs-endo-but-for-bots-pr258-gauntlet-20261007`)

The panel's verdict is **must-fix**. `panel.sh` exited 0, and I posted the verdict on the PR as a review.

**What ran:** one single-round panel on head `91f69ecd6a` (branch `ci/ocapn-guile-interop-resilience-iii`, in an isolated project worktree). I reviewed against the PR's frozen base `master-46d4edf` (`46d4edf317`). All 34 seats returned: 1 request-changes, 14 comment-only, 19 approve. The run is recorded at `panel-runs/endojs-endo-but-for-bots-258/00d24ed43bd5.md`. Before the seats ran, the panel flagged the PR description as too long and noted a repeated must-fix on the same mechanism, so it pointed the pruner at the description and asked the decomplector whether that mechanism is needed at all.

**Findings (all from the decomplector seat):**
- **Must-fix:** the self-healing for a corrupt cache entry (`zstd -t`, `discard()`, `gh cache delete`, and the job's `actions: write` permission) repeats integrity checks that `actions/cache` already does. Fix: write the staging tarball uncompressed, remove that self-healing code, and drop the write-scoped token.
- **Should-fix:** build the cache key from `GUIX_VERSION` and `GUIX_GUILE_PACKAGES` instead of `hashFiles(<workflow file>)`. That would also let the `hashFiles != ''` guards go.
- **Comment-only:** `guix archive --export/--import` is a possible alternative. The PR body should say why it wasn't used.

**Posted:** the review is on the PR, submitted 2026-10-08T12:24:53Z, with the same "Panel verdict — round 4: **must-fix**" heading as rounds 1–3. It is a COMMENTED review because GitHub won't accept request-changes on the bot's own PR.
- **Shortened for length:** the full aggregate is about 80KB, over GitHub's review size limit. The posted review keeps the request-changes and comment-only seat blocks in full; the 13 approve-only blocks are listed by name and point to the panel record.
- **Wording change:** the posting check rejected a bare `#474` in one seat's text because the review also names another repo. I put it in backticks so it doesn't link to the wrong PR.

**Follow-ups:** nothing beyond the next gauntlet stage. As in rounds 1–3, the verdict is must-fix, this time on the cache self-healing mechanism.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1232094 cached reads)
- Output: 6106 tokens
- Cost: $0.8392187999999999
- Wall-clock: 309s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
