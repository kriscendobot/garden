**Viability report: endojs/endo-but-for-bots#1592**, "feat(daemon): snapshot mount imports for caplet lifetime"

The PR is open, unmerged and still a draft. It was opened 2026-10-31T14:12Z, about a minute before this job was posted. Its head is `efdbdc4cd9`. Its base is `daemon-worker-import-from-mount-phase-three-9f0a7a6`, a frozen snapshot of the head of #1590.

Deciding question: Is Phase 4 of `designs/daemon-worker-import-from-mount.md` (snapshotting a live mount before `makeFromPackage` resolves packages, kept alive for the caplet's lifetime) still unimplemented on `llm` and in every other open PR, with the stack it builds on still in progress? Yes.

Evidence:
- **The stack below it is still open.** Phase 2 is #1559 (`makeFromPackage`, open) and Phase 3 is #1590 (`makeFromMount` / `--mount`, open draft). #1592 builds on #1590's frozen head, and that frozen base is 6 commits ahead of `llm` and 0 behind, so the stack is current.
- **Nothing newer replaces it.** `packages/daemon/src/host.js` on `llm` has no `makeFromPackage` or `makeFromMount` at all. Its only `snapshot()` call (around line 2189) is in a different, existing code path, not this phase. A search of PRs for `daemon-worker-import-from-mount` found no other PR covering Phase 4.
- **The reason for the PR still holds.** The design document on `llm` was last changed on 2026-07-13 and still describes the integration layer as "snapshot the source, call into `mapSnapshot`". The race between package resolution and edits to a live mount, which this PR closes, exists as soon as Phase 3 lands.
- **No discussion yet.** There are no comments or reviews, so there is no maintainer objection or redirect.

What happens next: the gauntlet may begin. #1592 can't merge until #1590 lands, and #1590 can't merge until #1559 lands, so the later stages need to be ordered behind those two PRs.

I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing in either repository.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1592-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181809 cached reads)
- Output: 1812 tokens
- Cost: $0.4509058
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
