**Verdict: PR #1380 passes the viability gate (`viability=proceed`).** It is still needed and nothing has replaced it.

**PR facts:** endojs/endo-but-for-bots#1380, "feat(xsnap): re-seat native handles through the host transcript and lift the suspend refusal". It is OPEN, a draft and not merged. It was opened 2026-09-29T18:33Z with head `93e73e1caa` on branch `llm-ironhorse-panic-live-handle-reseat` and base `llm-1706e63`. It has no reviews or comments yet.

Deciding question: Does current `origin/llm` (or another open PR) already re-seat native handles through a host transcript and lift the suspend refusal from #1150, or has the design dropped host-handle reconstruction?

Answer: no to both.

Evidence:
- **Nothing newer replaces it.** `origin/llm` (`7ff30afbce`) is 6 commits past the pinned base. All six are ReadableBlob and platform work (#1097), and none touches xsnap, slot-machine, the panic work or transcripts. `git grep` finds no `reseat`, `host-transcript` or `fn host_call` under `rust/` on `origin/llm`.
- **No other PR does this work.** The other open panic-recovery PRs cover different pieces: #1372 probe, #1370 design Q&A, #1373 lint, #1374 aborts→Panicked, #1375 `<panic>` wire message, #1376 WAL transcript, #1377 outbound embargo, #1379 host-call transcript. #1380 sits on top of #1379 and #1374, which are both still open drafts on the same base.
- **The design still calls for it.** The merged design #1018 (`designs/ironhorse-panic.md` on `origin/llm`) still requires this work:
  - Line ~201: the suspend request with open native handles is refused only until reconstruction exists.
  - Line ~526: the `host_handle` contract with a logical id and a durable reconstruction descriptor.
  - Line ~758–760: the host re-seats each logical id before replay reaches its first use.

  This PR delivers exactly that.

**Caveat:** #1380 contains all of #1379 and #1374 and only its last commit is new. If either of those is reworked, #1380 will need a restack. That doesn't stop the gauntlet from starting.

The REST API hit its rate limit partway through, so I read the code from `origin/llm` with git instead. No clean, panel, fix, CI-wait or un-draft budget was spent, and no garden changes were committed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (270021 cached reads)
- Output: 2882 tokens
- Cost: $0.46796419999999994
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
