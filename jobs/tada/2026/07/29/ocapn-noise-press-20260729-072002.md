## Press dispatch 24 — completion report (ocapn-noise-press-20260729-072002)

**State assessed:** M1–M5 remain fully proven; the arc is in a coherent wait state with two external unblocks pending: the merge word for #340 (APPROVED by kriskowal 2026-07-29 00:09Z, un-drafted; prior maintainer message unanswered, not re-sent) and kriskowal's review of design draft #886.

**What changed since the last press (found, not done by me):** kriskowal requested changes on #684 at 02:05Z — defer the WebSocket transport work until `.np` is refactored to provide multi-transport connection hints with separate WS and TCP+CBOR listeners. A peer job already dispositioned that review and delivered the prerequisite design as draft PR #886 (`design/ocapn-network-transport-separation`). Nothing there needed action from this dispatch.

**What I did:**
1. **Confirmed CI on every head** — the item dispatch 23 left pending. All five PRs zero non-passing checks, all MERGEABLE: #340 `83f55ea9` 25/25, #683 `a1abe571` 25/25 (post-rebase), #684 `b18eee0c`, #688 `a137a121`, #693 `803ef977` 23/23 each. No flake reruns needed. `llm` unmoved at `bfc91f558` — no restack per settled policy.
2. **Re-proved the cross-host round-trip live over BOTH transports** at #693 head `803ef977f` from a fresh project worktree: TCP+CBOR direct to `minion.town:8929` → `RESULT {"ok":true,…}` with `getNodeId()` matching designator `c1ac846d…` (reverse peer auth); WS via `wss://minion.town/ocapn` → `RESULT ok`, designator `fe2017c4…`. Endpoint probes: both wss routes 426, tcp/8929 accepting.
3. **Posted the evidence comment**: endojs/endo-but-for-bots#693 issuecomment-5120568245.
4. **Updated the arc memory** (`ocapn-over-noise-goal.md`): the #684 deferral + #886 design, dispatch-24 CI/live-proof state, and a new operational gotcha — the WS toy's designator rotates per container restart (`563ce21f` → `fe2017c4`), so always SSM-fetch the current location JSON before a wss dial.

**Follow-ups for the next dispatch:** watch for the #340 merge word (a conductor job, not a press action) and for kriskowal's #886 review — when that refactor arc opens, expect it to reshape #684's transport wiring and possibly the stack above it. No garden main2 changes were needed; nothing to push.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-noise-press-20260729-072002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 49 tokens (1591492 cached reads)
- Output: 18881 tokens
- Cost: $3.8532230000000007
- Wall-clock: 353s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
