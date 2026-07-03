Inbox empty. Work is complete.

## Completion report

**Job:** Give mentor-emitted jobs a stable directive identity so re-detections of the same recurring failure collapse onto one open job instead of piling up under fresh LLM-chosen slugs.

**What I did:**
1. **`roles/mentor/AGENT.md`** — Added an operating norm requiring the **first body line of every JOB block to be the single repo-relative implicated script path**, alone on that line, so the identity is derivable deterministically. Documented that the handler parses it into `mentor:<path>` for dedup.
2. **`scripts/jobs/handlers/mentor-claude.sh`** — Updated the mentor prompt to instruct the same first-line-is-the-script-path contract, and added a `post_mentor_job` helper that parses the first non-blank body line, tolerates leading list/quote/backtick decoration and a `./` prefix, and posts with `post-job.sh --identity "mentor:<path>"`. A first line that isn't a lone script path falls back to a plain post (prior behavior). Since `post-job.sh` already dedups on `--identity` via the `jobs/index/<hash>` map, the same recurring failure now maps to at most one live job.

**Design choice:** used the full normalized path (not just the basename) as the identity, so two distinct scripts sharing a basename (e.g. `common.sh`) never wrongly fold onto one job — the identity-collision direction that would drop a directive.

**Verification:** Ran the parse loop against five JOB-block shapes (plain path, `./`-prefixed, list-marker+backtick-decorated, prose-only malformed, blank-then-path) with a stub `post-job.sh` — all derived the correct `mentor:<path>` identity or correctly fell back. `bash -n` clean.

**Merge note:** A concurrent commit landed on `main2` adding an `already_fixed_pending_deploy` deterministic pre-filter to the same handler. I resolved the rebase conflict by keeping both — the pre-filter still gates each block, and surviving blocks flow through `post_mentor_job`. Pushed to `main2` as `3563d6c87`.

**Follow-ups:** None required. The 129 existing `improve-*` duplicates already in `jobs/tada/` are historical and untouched by this change; going forward, new mentor emissions dedup. Existing improve jobs authored before this change carry no first-line path and would post without identity if re-emitted, but the new prompt makes fresh emissions compliant.
