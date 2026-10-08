**PR #1379 viability: proceed. The gauntlet can begin.**

- **PR state:** open, still a draft, not merged. Head is `0cafbe11c5` on `llm-ironhorse-panic-host-call`. The base is the frozen `llm-1706e63`, which `origin/llm` is now 277 commits ahead of.

Deciding question: Is the host-call leg of `designs/ironhorse-panic.md` § "Host functions are messages too" (host calls as transcript events, logical handles, barriers) still unimplemented on `origin/llm`, with the design section unchanged and no other PR doing the same job?

Answer: yes.

Evidence:
- **Nothing on the base replaces it.** `rust/endo` on `llm` has no `slot-machine-transcript` crate. The only crates there are `ironhorse-store-sqlite`, `xsnap`, `src` and so on, and no commit on `llm` touches that path.
- **The design still asks for it.** The design section is still on `llm` at line 725, along with the `host_handle` table (line 526) and the barrier semantics. The design file was last changed on 2026-09-08 (a thixotrope consolidation), and nothing since has revised or dropped the host-call contract. Design #1018 and the FFI-abort guard #1150, which this PR builds on, are merged.
- **No competing PR.** Searching open PRs for "ironhorse panic" and "slot-machine transcript" turned up only this panic-recovery stack. Nothing else covers host-call transcripting.
- **Work stacked on it is waiting.** #1380, the live xsnap re-seat that lifts the suspend refusal, says it is "Stacked on #1379" and is open as a draft. #1385, terminate/restore/replay after a panic, belongs to the same open stack.
- **The PRs under it are still open.** #1376 (transcript) and #1377 (embargo) are open drafts. Their open drafts are why the diff against `llm-1706e63` also shows their changes.
- **The PR stays draft no matter what the gauntlet does.** It is gated on a maintainer review of #1370, the Q3/Q6/Q7 answers, which is an open draft with no review yet. That is a gate on leaving draft, not a sign the PR has been overtaken.
- **Last gauntlet round halted.** The previous gauntlet (`...-gauntlet-20261002`) halted after one round with CI red, because its fix stage declared the gated outcome failed. That is a quality problem for this gauntlet to work on, not a reason the PR is obsolete.

Changes: none. This stage only checks viability, so I spent no clean, panel, fix or CI budget and made no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1379-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (230949 cached reads)
- Output: 2361 tokens
- Cost: $0.4684738
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
