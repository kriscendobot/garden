I'm letting PR #1593 enter the gauntlet. Nothing has replaced it, and the work it does is still on the plan. I ran only read-only checks and changed nothing.

**What I found:**
- **PR state:** open, unmerged and still a draft. It was opened at 15:05 today with no comments or reviews yet. Head is `c85ead3`, based on the frozen branch `llm-9a14ddf`. It changes five files in `packages/agent-tools` (one of them a changeset): it adds an optional `http` grant to `makeWorkspaceTools` / `provisionWorkspaceTools` and exposes it as an HTTP tool group built from `makeHttpTool`. It also makes the HTTP and Git-remote tools fail when both are granted, because both are named `fetch`.
- **Not done on `llm` yet:** the current `packages/agent-tools/src/workspace.js` on `llm` contains no `http` or `fetch` composition. The last changes to `agent-tools` were three commits on 2026-10-22, and none of them touch this.
- **No overlapping PR:** I searched open and merged PRs. #1348 (explicit workspace tools) covers shell, git-remote and agentry, with no HTTP group. #1588 (splitting `fetch` from `confined-fetch`) covers a different surface. #661, #707 and #723 are the merged groundwork this PR builds on.
- **The design still asks for it:** the linked design PR #1497, re-scoping the daemon-agent-tools design, lists a "Phase 8: One HTTP provisioning path" with an unchecked item that matches this PR word for word: "Add an `http` group to `makeWorkspaceTools` / `provisionWorkspaceTools`, composed only when an `HttpClient` is granted".
- **One thing still open, but it doesn't block this PR:** the design's Open Question 4 hasn't decided whether the daemon's `provideHttpClient` or the `@endo/fetch` plugin becomes the one way to provision HTTP. This PR doesn't depend on that answer. It only reacts to whether a caller grants an `HttpClient`, and either path supplies one.

Deciding question: Is the HTTP workspace tool group still missing from `llm` and still an unchecked item in the current daemon-agent-tools design, with no other PR doing it?

Evidence: yes on all three. `llm`'s `workspace.js` has no HTTP group, no open or merged PR adds one, and Phase 8 of the design in #1497 lists this exact item as still to do. The unresolved question about which HTTP path wins doesn't affect it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1593-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (359734 cached reads)
- Output: 2441 tokens
- Cost: $0.5302868000000001
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
