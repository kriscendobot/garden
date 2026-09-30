**PR #1402 viability check: proceed.** The PR is open and unmerged. Nothing newer has replaced it, and the maintainer request behind it still stands.

- **PR facts:** The PR is open, unmerged and still a draft. It adds one file, `designs/daemon-mount-visible-roots.md` (+264 lines), on head `d74b65365c`. It was opened 2026-09-30T23:28Z.
- **Base:** The base is the frozen branch `llm-825c598bc`. A compare against `llm` returns `ahead_by 0`, so `llm` has no commits past the base and nothing newer there can have replaced it.
- **Deciding question:** Does `llm`, or another open or merged PR, already contain a mount attenuation with several visible roots and a controller facet to add and remove them, or has kriskowal withdrawn the request for one? **No.**
- **Evidence:**
  - **The request still stands.** kriskowal's review comment on #1340 (discussion_r4149165593) asks for "a full filesystem mount attenuation that comes with a controller facet to add and remove roots". It was posted as a way to avoid requiring hoisted mode. #1340 is still an open draft, so the need it depends on is live.
  - **No competing design on `llm`.** The `llm` tree has no `mount-view` or visible-roots design. The mount designs it does have (`daemon-mount.md`, `daemon-mount-capabilities.md` and the others) cover a single mount root.
  - **No implementation anywhere.** A code search for `provideMountView` finds 0 hits.
  - **No competing PR.** A PR search for "mount view" finds only #1402 itself on this topic.
  - **No pushback yet.** The PR has no reviews or comments.

Nothing was changed; no clean, panel, fix or CI budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1402-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168235 cached reads)
- Output: 1459 tokens
- Cost: $0.39840299999999995
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
