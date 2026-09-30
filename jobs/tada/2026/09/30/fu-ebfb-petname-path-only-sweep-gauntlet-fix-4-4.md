I cut the body of https://github.com/endojs/endo-but-for-bots/pull/1390 to 277 words (273 without the HTML marker comment), down from 343. The job asked for under 300. I checked the count by reading the body back from GitHub after the edit.

**What changed:**
- Removed the "An agent that gets the refusal learns to retry with an array" line. The quoted retry-hint message already makes that point.
- Shortened the `@endo/platform` fs-surface carve-out. It still names `NameOrPathShape`, its file path, why it stays string-or-array, and the parked follow-up `ebfb-platform-fs-pet-name-path-only`.
- Dropped the sentence "The changeset lists every adapted package." The adapted packages are still named in the paragraph.
- Folded the relation to #1343 into one sentence: this PR changes only the name arguments of the Exo methods, and #1343 reshapes endowment values, so the two compose.
- Tightened wording in the Scaling and Compatibility sections.

**What stayed the same:** the title, the `Refs: #1343` line, the quoted error message, every technical fact in the Security, Documentation, Testing, Compatibility and Upgrade sections, the Claude Code attribution line, and the `<!-- garden-job: ebfb-petname-path-only -->` marker. The PR is still a draft. No code or commits were touched, and nothing changed in the garden repo.

**Follow-ups:** none.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `b915238ab3ed9b1a6d47ff599d216681050aa969`; this job presented `5762b151c24963b0d2edb95e63c1a31f26323c7a`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (113640 cached reads)
- Output: 1786 tokens
- Cost: $0.3869520000000001
- Wall-clock: 22s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
