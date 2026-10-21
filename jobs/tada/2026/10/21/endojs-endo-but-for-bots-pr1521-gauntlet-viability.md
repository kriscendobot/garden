Viability is **proceed**: PR #1521 is open, still a draft and unmerged, and nothing has taken its place.

**Deciding question:** Does the current `llm` branch still lack `endor run <dir/>` support (nothing has replaced PR #1521), and is Phase 3 of `designs/endor-run-expanded.md` still the planned next step?

**Evidence:**
- **PR facts:** `gh pr view` returns state OPEN, isDraft true and mergedAt null. The base is `llm-f02cd81` (f02cd81b) and the head is `feat/endor-run-directory-input-v2` at 0300b55f. The PR was opened 2026-10-21T15:33Z and has no reviews or comments yet.
- **Not superseded:** #1521 is itself the replacement for #278. The older PR conflicted with current `llm` and stopped because its base was floating. A PR search for "endor run directory" finds only these two PRs; #279 is Phase 4 and depends on this one.
- **Base code still needs it:** on `llm`, `rust/endo/src/cas_archive.rs` has no `ingest_directory`. `rust/endo/src/run_input.rs` still has comments saying a `RunInput::Directory` variant will be added "when Phase 3 lands".
- **No newer base work:** comparing f02cd81 to `llm` shows `ahead_by` 0, so the pinned base has not fallen behind.

**Follow-up:** #278 is still open even though #1521 supersedes it. Someone could close it as superseded by #1521. I did not close it, because that is outside this gate's scope.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1521-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (105666 cached reads)
- Output: 1281 tokens
- Cost: $0.3376572
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
