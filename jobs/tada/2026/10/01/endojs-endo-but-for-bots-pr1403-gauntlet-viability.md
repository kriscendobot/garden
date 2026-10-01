The gauntlet for PR #1403 can go ahead: nothing has replaced the PR, and the need it was opened for still holds. I rechecked just now and it is still open, still a draft, unmerged, with head `34a4a0bc`.

**Deciding question:** Does the current `llm` branch still call for the provider-neutral `@endo/inference` package (phase 1 of the merged design #1357), with no other version of it already landed or under review?

**Answer:** Yes.

**Evidence:**
- **PR state:** open draft that GitHub reports as mergeable. Base is the frozen `llm-80054c3`, head branch is `build/endo-inference-seam-1357`. It was opened 2026-10-01T05:01Z by job `build-endo-inference-seam-1357` and has no reviews or comments yet.
- **The design still asks for it:** `designs/endo-claude-inference-backends.md` on `llm` was last changed at 2026-10-01T02:57Z, during the #1357 panel rounds. That is before this PR was opened, so the PR follows the final design. The design's "Phased Implementation" item 1 still says `@endo/inference` should provide these pieces without depending on any provider package:
  - the guards
  - the `CredentialSource` and usage-record shapes
  - the limit enforcer and the pinned-table classifier
  - the prompt-origin gate and the usage recorder
- **Not on `llm` yet:** `packages/inference` does not exist there (the contents API returns 404), and none of the 40 most recent `llm` commits adds it.
- **No newer replacement:**
  - #1371, which landed today, only touches `@endo/claude` (the guest stdio MCP server and 401 handling), not this package.
  - #1369 is an open draft prototype from before the design was revised. #1403 says it follows the merged design instead.
  - No other PR with "inference" in its title implements this package.

Phases 2–6 of the design, starting with moving `@endo/claude` onto this package, are meant to build on #1403. This stage only read from GitHub: it ran no review, fix or CI work, committed nothing, and opened no PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (295471 cached reads)
- Output: 2771 tokens
- Cost: $0.9696364000000002
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
