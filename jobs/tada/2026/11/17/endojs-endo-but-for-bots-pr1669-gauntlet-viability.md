PR #1669 can go ahead into the gauntlet. I spent no clean, panel, fix, CI-wait or un-draft budget on it.

**Facts:**
- The PR is open, still a draft and not merged.
- It changes one file, `designs/endopi-jsonl-transcript-format.md`: 209 lines added, 113 removed.
- It was opened today, 2026-11-17 at 05:24Z, by job `design-endopi-jsonl-transcript-format`.
- Its base is the frozen snapshot `llm-0368767` (0368767778). Comparing that against `llm` shows `llm` is 0 commits ahead, so the base is current.
- There are no reviews or comments yet.

Deciding question: Is it still true that no newer design or code on `llm` settles how the `@endo/jsonl-transcript` library connects to Chat, the Familiar and the Gateway?

Evidence:
- The question this PR answers comes from the 2026-07-15 review on #669: how the transcript format fits into an app like Chat, Familiar or Gateway. #669 merged the format library on 2026-07-29 and left that question open.
- On `llm`, the design file was last changed in f4a9dc6d13 on 2026-05-15, which is older than the review question. No later commit to it answers the question.
- GitHub code search finds no `transcripts-for` anywhere in the repo. That search may only index the default branch, not `llm`.
- The same search finds `jsonl-transcript` only in the package itself, a changeset and design docs. No Lal or Fae agent code takes it as a dependency, so nothing already built replaces this design.
- `provideScratchMount`, which the design relies on, still exists in `packages/daemon/src/host.js`, so the design's premise holds.
- No newer PR on the same topic exists. The only other one, #692, is older (2026-07-11), still open, and is the duplicate this design records as superseded.

Follow-up: #692 is still open while this design calls it a superseded duplicate of #669. The maintainer may want to close it on its own track.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1669-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (187791 cached reads)
- Output: 1725 tokens
- Cost: $0.45096220000000004
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
