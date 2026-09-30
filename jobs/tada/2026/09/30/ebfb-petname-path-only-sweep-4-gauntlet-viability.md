**Viability report: endojs/endo-but-for-bots PR #1390**

The gauntlet can go ahead. The PR hasn't been superseded, and the reason for it still stands.

PR facts: the PR is OPEN, a draft, and unmerged. Its title is "feat(daemon)!: accept only pet-name paths, reject bare pet-name strings". It merges head `build/pet-name-path-only` at `065f1344ea` into base `llm-8e53cc0` at `8e53cc0f89`. It has no reviews yet. The latest bot comment reports the part-5 downstream sweep complete, with every CI check green at `065f1344ea`.

Deciding question: Does current `origin/llm`, or any other merged or open PR, already make the daemon reject bare pet-name strings in favor of pet-name path arrays? That is, has anything overtaken #1390, and does the string-coercion behavior that kriskowal objected to still exist?

Evidence:
- **The motivating behavior is still in the base.** On current `origin/llm`, `namePathFrom` in `packages/daemon/src/pet-name.js:148-152` still does `typeof nameOrPath === 'string' ? [nameOrPath] : nameOrPath`, which silently turns a string into a one-component path. This PR removes exactly that.
- **Nothing newer has touched these files.** The most recent `llm` commits to `pet-name.js` and `type-guards.js` are from 2026-06-23 (`35d7554672` added the `petNamePathFrom` helper, `2dec167d50` exported the shapes). Both are older than this PR's work. `origin/llm` is only 4 commits ahead of the frozen base `8e53cc0`.
- **No competing implementation exists.** A search of PR titles for "pet-name path" returns only #1390 and #1144. #1144 is MERGED and was an earlier, narrower change (send to a pet-name path). #1343, the coordinating PR, is still OPEN and covers a different part: the endowment value side. #1390 says explicitly that it doesn't duplicate #1343.
- **The reason for the change still holds.** The PR implements kriskowal's review request on #1343 (review 5360774903): agents shouldn't be handed a string that might or might not be a delimited path. Nothing has overridden that request.

Nothing was changed in the garden repo or the project repo. Next, the gauntlet runs the clean, panel, fix-loop and un-draft stages.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (110617 cached reads)
- Output: 1753 tokens
- Cost: $0.39536740000000004
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
