from_host: endolin-garden2-5bcdff64
from: gardener:triage-halted-gauntlets-20260916
reply_to: triage-halted-gauntlets-20260916
msg_key: msg-triage-halted-gauntlets-20260916-d6b4e6e396b6
notice_count: 1
first_seen: 2026-09-16T05:48:41Z
last_seen: 2026-09-16T05:48:45Z
sent_at: 2026-09-16T05:48:45Z
---
# Triage: five halted gauntlets/orchestrations (parked early Sept)

Per-item disposition below. I checked each PR's live state + CI *now* and the actual
stage records; I did **not** re-post anything. TL;DR: items 1 & 2 were transient
(capacity-crunch) halts on now-green PRs — cheap re-posts; items 3 & 4 are real
non-transient failures that must be **re-scoped**, not retried; item 5 has already
partly landed and needs re-anchoring, not a restart.

Common context: items 1 & 2 both doomed 2026-09-03/04 with
`doom_signature=requeue-exhausted`, `requeue_cycles=5`, `deadline_overruns=0`,
`elapsed_constancy_confirmations=1` — i.e. the handler never overran its own
deadline; it was requeued 5x without progress and exhausted. That window is the
known capacity/quota outage (temp API key ~1 day around 09-04). `deadline_overruns=0`
plus that window means these are **transient infra** halts, not work failures — the
`failure_classification=unknown` only means the reaper couldn't *prove* it at the time.

---

## 1. sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean — endojs/endo-but-for-bots#1013
- **Premise: LIVE.** endojs/endo-but-for-bots#1013 (`design: relative routing…`, head
  `design/relative-routing`) is OPEN, not merged, not superseded. **CI is now ALL GREEN**
  (build/lint/test/browser-tests/zizmor).
- **Halt: TRANSIENT** (capacity crunch, see common context; no deadline overrun).
- The `clean` stage is idempotent — step 1 short-circuits to `clean=done` when CI is
  green at head, and this is a design-doc PR so the coverage pass is a no-op anyway.
- **→ RE-POST as-is** (no header change). It will idempotently no-op and let the sweep
  gauntlet advance. Near-zero cost.

## 2. build-minion-town-invitation-only-guest-onboarding-gauntlet-panel-2 — kriscendobot/minion.town#81
- **Premise: LIVE but STALE.** kriscendobot/minion.town#81 (`Build: capability-first
  guest onboarding — browser core slice`) OPEN draft, CI `test` green, **not superseded**
  (its parent design kriscendobot/minion.town#56 merged 09-02; adjacent open work
  kriscendobot/minion.town#80 / kriscendobot/minion.town#82 / kriscendobot/minion.town#95
  doesn't replace it). But it's untouched since 2026-09-02 (~2 weeks) and the browser-core
  slice was noted as blocked on the Endo guest-native invite/accept dependency.
- **Halt: TRANSIENT** (same capacity crunch).
- Caution: this stage carries `handler-timeout=10800` (a full ~3h, 29-seat panel) —
  exactly the expensive-panel churn the credit investigation flagged.
- **→ RE-POST panel-2, but confirm the premise first.** Deciding question: *is the
  kriscendobot/minion.town#81 browser-core slice still the intended live path, or is it
  parked pending Endo guest-native invite/accept?* If still live → re-post
  (transient-safe). If it's waiting on that dependency → keep it parked (DROP the stage)
  rather than burn a 3h panel on a slice that can't merge yet.

## 3. ebfb-exo-stream-drop-base64-stream-methods-gauntlet — endojs/endo-but-for-bots#1100
- **Premise: LIVE** (OPEN draft, not merged, not superseded).
- **Halt: REAL failure, NOT transient.** fix-2 correctly declared `orchestration-failed`.
  CI is RED (confirmed still red now: lint + test FAILURE on every leg) from **base
  drift**: this PR migrated `@endo/exo-stream` `stringLengthLimit`→`byteLengthLimit`,
  but current `llm`'s `packages/9p-server/src/server.js` still calls the removed
  `stringLengthLimit` API (3 sites). GitHub tests the merge ref, so llm's stale call
  site + this PR's renamed type = tsc + runtime failures. A plain gauntlet re-post would
  re-fail identically.
- **→ RE-SCOPE: weave / pin-the-merge-base of endojs/endo-but-for-bots#1100 onto current
  `llm`**, resolving the `9p-server` `stringLengthLimit`→`byteLengthLimit` conflict
  (semantic port, not just a rename; branch was ~360 commits behind), *then* resume the
  gauntlet from fix. This is the successor fix-2 already named.

## 4. build-minion-town-claude-harness-provisioning-gauntlet — kriscendobot/minion.town#99
- **Premise: LIVE and healthy.** kriscendobot/minion.town#99 (`feat(deploy): provision
  pinned Claude harness`) OPEN draft, **mergeable=CLEAN, CI ALL GREEN** (Claude harness
  amd64/arm64 + test), updated 09-09.
- **Halt: NOT a work failure** — hit `max_iterations=6`. Every panel round 1–6 returned
  must-fix; fix-6 achieved green and folded polish (locksmith/saboteur should-fix). The
  29-seat panel structurally always surfaces fresh nits (and own-PR request-changes
  downgrades to a comment), so it never emits `pass`. This is precisely the "iteration
  6/6 churn" cost multiplier the credit investigation named.
- **→ RE-SCOPE: stop the panel loop.** The code is green + mergeable; another 6-round
  loop would just grind more nits and cap again. Deciding question: *are the recurring
  panel must-fixes real merge-blockers, or diminishing polish on already-green,
  mergeable code?* If diminishing (which the fix-6 folded items suggest), route to a
  final maintainer review → un-draft/merge rather than re-running the gauntlet.

## 5. minion-town-clipometer-esbuild-orchestration — HALTED, "0/4 children done"
- **The halt record is stale.** It recorded child 1 (`…-pipeline`) stalling 2501s vs
  `handler-timeout=2400s`. But child 1 **subsequently recovered on a reaper requeue and
  completed** — draft PR kriscendobot/minion.town#84 (`CLIPOMETER on real @endo/captp +
  esbuild pipeline`) is OPEN, CI green. Its own gauntlet reached panel-3 and was then
  **archived 09-05 by the liaison during a fleet drain** ("archive all scheduled
  gauntlets during the drain"), which is why kriscendobot/minion.town#84 never un-drafted.
  So the true state is: **child 1 done (PR kriscendobot/minion.town#84), children 2–4
  still parked.** This is drain-parked, not failed.
- The 2501s>2400s overrun is real but was non-fatal (requeue recovered it). Child 2
  (`…-validate`) is heavier than child 1 — it does a full build + **live publish to prod
  + two-window Playwright** validation — so the budget matters more there.
- **→ RE-SCOPE (do not restart from child 1):**
  1. Re-anchor the orchestration to **resume at child 2** (`minion-town-clipometer-esbuild-validate`);
     child 1's deliverable (PR kriscendobot/minion.town#84) already exists.
  2. Give child 2 a raised budget: **`handler-timeout: 3600`** (validate's build+publish+
     dual-browser run exceeds child 1's 2501s at the 2400 default).
  3. Note child 2 needs the **real guest MCP identity** (not the disposable
     `minion-mcp-test-cc`) for the canonical publish — child 1's report flags that if the
     job env lacks it, that publish step hands to the liaison/maintainer.
  - Deciding question: *is the live-CLIPOMETER-replacement still wanted (dckc's 09-03
    directive), and should kriscendobot/minion.town#84's archived gauntlet be un-archived
    to un-draft it?*
  - Also unresolved from child 1: the published `@endo/patterns@2.0.0` /
    `@endo/marshal@1.10.0` npm version inconsistency (worked around by vendoring
    `iterate-reader.js`) — child 2's live run is the checkpoint that confirms the vendored
    approach works against the real daemon.

---
**Summary:** 1 → RE-POST (no change). 2 → RE-POST panel-2 *iff* premise confirmed live,
else DROP the stage. 3 → RE-SCOPE to a weave/pin-merge-base then resume. 4 → RE-SCOPE:
stop the loop, human review → un-draft (green+mergeable). 5 → RE-SCOPE: resume at child 2
with `handler-timeout: 3600`, un-archive kriscendobot/minion.town#84's gauntlet. I
promoted/re-posted nothing.
