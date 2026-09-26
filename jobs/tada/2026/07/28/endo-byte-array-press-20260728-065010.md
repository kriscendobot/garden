## Press report — passable/immutable byte arrays (endojs/endo-but-for-bots, dispatch claimed 2026-07-28T06:50Z)

**State of the arc: verifiably unchanged — the twelfth consecutive quiescent cycle. Both front PRs remain stalled solely on human re-review; nothing was unblocked, so nothing was pushed.**

**Evidence checked (commands and outputs cited):**

- **#475** (narrow byteArray to plain frozen Uint8Array — the design-#572 front carrying the finish-line shape): OPEN, MERGEABLE, head `1b1dc75ba9c9` unchanged (`gh pr view 475 --json headRefOid`), `updatedAt` still 2026-07-17T12:23:45Z. `gh api .../issues/475/comments?since=2026-07-27T17:50:00Z` → **0**; inline review comments since then → **0**. `CHANGES_REQUESTED` is still the stale pre-07-17 decision with all threads previously answered bot-side.
- **#503** (freezable-TypedArray emulation + byteArray brand check): OPEN, MERGEABLE, head `453f6ef0d4a3` unchanged, `updatedAt` still 2026-07-20T04:07:05Z — the last event remains the bot's Security-Considerations correction answering erights' "read delegate" question. **0** new issue comments and **0** new inline review comments since 17:50Z.
- **Redesign supremacy:** unchanged — #475 carries the frozen-Uint8Array-view shape that supersedes the immutable-ArrayBuffer approach; spike **#602** still DRAFT (`updatedAt` 2026-07-10), comparison-only. Design issue **#572**: **0** new comments.
- **Registry follow-up:** **#671** still OPEN (`updatedAt` 2026-07-18), **0** new comments; `registry-immutable-byte-array-followup.md` confirmed still parked in `jobs/plan/`. Not started, per the standing block — the unblock watcher owns its promotion when #671 lands.
- **Liveness:** my inbox was empty (`inbox-read.sh`); `jobs/doing/` holds no byte-array claim — no live peer to defer to.

**Anomaly noted:** the previous 6h dispatch, `endo-byte-array-press-20260728-004711`, left no tada report and is absent from the board (its inbox exists but is empty) — it appears to have died and been reaped rather than completing. The sibling 004711 presses (npm-cas-registry, xs2rust-endor) did report, so this looks like an isolated worker death, not an outage. No in-flight work was lost: the arc was already quiescent, and this dispatch's checks fully cover the gap.

**What changed this dispatch:** nothing, deliberately — any push to #475/#503 would invalidate their pending re-review state. The maintainer was already nudged (07-24/07-25) about the re-review stall and the cadence question; with zero new signal, another message would be noise.

**Follow-ups:**
- Next dispatch: check for fresh reviewer feedback on #475/#503 first; #671 landing arms the registry conversion automatically via the unblock watcher.
- Still open with the maintainer (already messaged, not re-sent): lengthen this press's 6h cadence or add a circuit-breaker while the arc is human-blocked — twelve consecutive no-op dispatches now.
