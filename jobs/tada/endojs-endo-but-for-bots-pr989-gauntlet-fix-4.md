CI is GREEN. All must-fix items applied and pushed as a follow-up commit; CI passed.

## Completion report

**Job:** Gauntlet FIX round 4 for endojs/endo-but-for-bots PR #989 (`design(worker): embargo outbound until a worker quiesces after delivery`) — a design-only PR editing `designs/worker-quiescence-embargo.md`.

**What I did:** Read the panel-4 request-changes verdict and applied all **eight must-fix items** across seven seats in one follow-up commit (`6a6c4d50c3`):

1. **critic** — Added a *Control envelope* class (`debug*`/`suspend`/`meter-config`) to the Definitions taxonomy and a new Decision 10, exempt from crank exclusivity, so moving the `try_recv_raw_envelope` drain past the flush no longer starves mid-crank debug-resume/suspend.
2. **critic** — Scoped Decision 9's "XS is bounded" premise to *compute-divergent* cranks; a crank blocked on a sync ancestor reply or a blocking host power burns no computrons, so the stuck-crank observability mitigation now applies to **both** supervisors.
3. **skeptic** — Restated the failure-atomicity property as "a failed crank emits nothing" (no redelivery exists; abort is fatal), and named the peer-hang consequence as out of scope.
4. **skeptic** — Scoped timers out (Decision 4 rewrite): the supervised pump fires none (`fxRunLoop` is non-supervised only; Node's `check`-before-`timers` phase order makes the divergence structural), with timer support named as a follow-up.
5. **decomplector** — Sited the Node turn barrier only on the worker-facing pump, gated by `pumpOptions`; the shared `makeMessageCapTP`'s non-worker callers (gateway, p2p) are explicitly unchanged.
6. **ergonomist** — Prescribed a single `pumpOptions` bag `{ bufferOutboundUntilQuiescence, stuckCrankThreshold }` on both `makeMessageCapTP` and `makeMessageSlots` instead of an 8th positional parameter.
7. **novice** (×2) — Reconciled Decision 1 "worker-side, not supervisor-side" with `connection.js` as the Node emission seam; made § Design step 1 admit exactly one *protocol* envelope, consistent with the timer scope-out.
8. **copyeditor/pedant** — Replaced the U+2192 arrows in prose with `->` at the event-loop phase line.

**What changed:** `designs/worker-quiescence-embargo.md` only. Pushed via `safe-push-pr-head.sh --mode advance` (`0ef115678d..6a6c4d50c3`). Did **not** re-run the panel (the driver re-posts panel-5).

**CI:** Watched bounded — GREEN (5/5 checks, 0 failed, rc 0).

**Follow-ups (named in the doc, not this job's work):** timer support in the supervised pump (pump change on both sides + shared deterministic clock) and a real Node/XS liveness bound for blocked cranks, both filed against the metering design.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4236347 cached reads)
- Output: 39105 tokens
- Cost: $4.140141500000001
- Wall-clock: 948s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
