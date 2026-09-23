Review posted as a COMMENTED review (request-changes is disallowed on the bot's own PR), with a clear `disposition: must-fix` header. The panel stage is complete.

## Completion report

**Stage:** PANEL round 2 (gauntlet `build-ocapn-nonce-locator-endo-mechanism-gauntlet`) — endojs/endo-but-for-bots PR #1124 (`feat(daemon,ocapn): OCapN formula nonce locator mechanism`).

**What I did:**
- Resolved the PR head (`kriscendobot:build/ocapn-nonce-locator-mechanism`, base `llm`) and took an isolated project worktree keyed to this job's base.
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1124 llm`). It sensed a **code** panel, fanned **29 seats**, aggregated, and decided disposition: **must-fix** (exit 0). Run recorded at `panel-runs/kriscendobot-endo-but-for-bots-1124/711996d1d7a2.md`.
- The full aggregate (`round-1.md`, 117 KB) exceeds GitHub's 65 KB review-body cap, so I posted a faithful digest of the blocking set. `--request-changes` is rejected on the bot's own PR, so I posted it as a **COMMENTED** review whose header states `disposition: must-fix`.

**Blocking findings surfaced (must-fix):** (1) pipelined `fetch` frames bypass the miss bound (increment happens after `await`; PoC 100 lookups / 1 abort); (2) the one-turn abort deferral does not flush the uniform rejection — the bound-crossing miss is peer-distinguishable (`Session disconnected` vs `secret not found`), falsifying the stated non-oracularity property; (3) branded `NodeNumber` laundered by unchecked cast; (4) declared return type narrower than impl/doc (`get` pinned to `string`, not `string | Uint8Array`); (5) `EndoMountControl` named by a public signature but unexported; (6) bare `catch {}` over a five-statement try swallows internal defects; (7) stale `spell-out-exempt: swissNum` whole-file marker; (8) the session-severance security property is unpinned by any test; (9) two related design PRs carry outstanding `CHANGES_REQUESTED`, unreconciled.

**Stopped here per stage contract** — no fix, no un-draft, no loop.

**Follow-up:** the next gauntlet stage (fix-loop) owns remediation of the must-fix set above.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (1601671 cached reads)
- Output: 14651 tokens
- Cost: $1.5886332500000002
- Wall-clock: 1263s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
