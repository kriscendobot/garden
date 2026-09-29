**Gauntlet viability for endojs/endo-but-for-bots PR #1379: proceed.** The gauntlet can start on this PR.

**What I did:** read-only checks only. I read the PR, its stack parents and the related design/refusal PRs, fetched `llm` and compared it to the PR's frozen base, and searched the repo's PRs for any competing slot-machine host-call work. No clean, panel, fix, CI or un-draft budget was spent.

**PR facts:**
- **State:** open, draft, mergeable, not merged.
- **Title:** "feat(slot-machine): host calls as transcript events, logical handles, and barriers".
- **Branches:** head `llm-ironhorse-panic-host-call` @ 5989fe4a; base is the frozen `llm-1706e63`.
- **Age:** opened 2026-09-29T18:13Z, about 20 minutes before this check.
- **Discussion:** no comments or reviews yet.

**Deciding question:** Is the host-call leg of `designs/ironhorse-panic.md` (host calls as transcript events, logical handles, barriers in `slot-machine-transcript`) still missing from `llm` and wanted by nothing newer than #1379?

**Evidence (the answer is yes):**
- **The motivating design still stands.** The design PR #1018 is merged into `llm`. PR #1150 (the live refusal to suspend while native handles are open) is also merged, and #1379 is the transcript side that lifting that refusal needs.
- **Nothing newer has displaced it.** `llm` is only 6 commits past the frozen base 1706e63, and all of them are platform, exo-stream and ReadableBlob work (#1097). None touches slot-machine.
- **No competing implementation exists.** Searching the repo's PRs turns up only this stack: #1376 (transcript) → #1377 (outbound embargo) → #1379. All three are open drafts on `llm-1706e63`.
- **Other work builds on it.** #1380 ("re-seat native handles through the host transcript and lift the suspend refusal") is the live-wiring follow-up that the PR body names, so it confirms the need is still current. #1372 is a separate gap-revealing probe (a prototype that reports gaps and stays draft), not a replacement.

**Follow-ups:** none from this stage. This PR is stacked on #1377 and #1376, so its diff also shows those two commits until they merge.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (166475 cached reads)
- Output: 1811 tokens
- Cost: $0.418067
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
