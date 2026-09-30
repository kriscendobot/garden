Panel round 4 on endojs/endo-but-for-bots#1379 came back **must-fix**. `panel.sh` exited 0; this was the head at `42d86c65e6`, compared against the frozen base `llm-1706e63` (`1706e63247fb`).

- **Run:** single-round mode, 30 seats (13 approve, 9 comment-only, 8 request-changes). It ran in an isolated checkout (`scratch/project-wt-endojs--4d1e6bc14543-d8811a34`). I used the PR's real base SHA from the GitHub API.
- **Posted:** review 5362519226, a COMMENTED review on head `42d86c65e6`. It has the same shape as rounds 1–3: a must-fix header saying "treat as request-changes" (GitHub refuses request-changes on the bot's own PR), an itemized summary, and the full text of every non-approving seat. The raw aggregate was about 80 KB, over GitHub's review-body limit, so I left out the approving seats' full text to get it to about 54 KB.
- **Must-fix items for the next fixer:**
  - **Unbounded host-call reply (breaker, saboteur and engine-realist all found this):** `check_host_call_bounds` limits only the request. The reply from the last host call in a crank is staged and committed without any size check.
  - **Leaked resource on misclassification (assessor):** the adapter runs before the `Pure` check. When that check fails, the resources the adapter opened or closed are dropped from the handle log instead of being recorded.
  - **Temp-name collision (curator):** `write_blob` duplicates xsnap's `suspend_to_cas` and uses the same temp-file name pattern with its own counter, so two writers on one store can pick the same name.
  - **Unreviewed design basis (integrator):** the uncaught-`Throw` / `EscapedBarrier` behavior rests on draft design amendment #1370, which has no reviews.
  - **PR body (integrator, deterministic check):** it replaces all seven template headings with its own.
- **Other items:**
  - **stylist:** spell out abbreviated names (`Seq`, `tx`, `conn`, `stmt`, `st`, `pg`/`pgsz`).
  - **corner-prober:** add missing tests for `CasError::Corrupt`, the edge cases of `reclaim`, a 65-character blob name, and registering the same callback name twice.
  - **breaker (should-fix):** document or assert that `DuplicateSuppressor` expects frames in order.
  - **scribe:** the completion summary says "Declined: none", but round 1's item that `compact()` never prunes `host_handle` is still open.
  - **pruner:** remove or link the line listing test counts in the PR body.
- **Not done, per the stage contract:** no fixes, no un-draft, no loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (907793 cached reads)
- Output: 5654 tokens
- Cost: $0.8527666
- Wall-clock: 615s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
