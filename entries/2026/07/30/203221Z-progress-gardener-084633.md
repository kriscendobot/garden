---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:32:23Z
---
---
project: endo-but-for-bots
prs: [475, 503, 602, 888]
job: endo-byte-array-press-20260730-082002
---

# Press assessment — passable/immutable byte arrays (dispatch 20260730-082002)

**Front PRs unchanged and stalled on human re-review. The byteArray-view
redesign (#475) has fully replaced the immutable-ArrayBuffer approach (#503).
Registry follow-up (#888) is in-flight via gauntlet (pool-owned). No unblocked
code work for the press driver this dispatch.**

## Evidence (commands and outputs cited)

**#475** (feat: narrow byteArray to plain frozen Uint8Array — the design-#572
finish-line shape): OPEN, CLEAN, CHANGES_REQUESTED, head `1b1dc75b` unchanged
since 2026-07-17 (`gh pr view 475` → `updatedAt 2026-07-17T12:23:45Z`). 117
ahead / 2437 behind `llm` but mergeable (CLEAN). CI 16/16 SUCCESS including
`test-xs` (`gh pr checks 475`). No new comments or reviews since 2026-06-23
(`gh api .../issues/475/comments?since=2026-07-29` → 0).

All 12 review threads accounted for (GraphQL `reviewThreads`): 7 outdated
(addressed in code, GitHub auto-marked), 5 unresolved-but-answered. Every
unresolved thread has a substantive kriscendobot response, and erights
acknowledged satisfaction on the two threads he drove hardest (shortlex
decision: "That makes sense to me, thanks"; byteArray.js staging: "that new
wording is fine. Thanks"). The remaining three (compareBytes genuine-input
rejection fixed in `4f5192232`; genuine-uint8-array shim init order answered
with a test in `1b6df4a9b`; protocol-versioning moved to issue #584 as
requested) are answered and await reviewer thread-resolution, which is a human
action. **#475 is stalled on kriskowal re-review, not on outstanding code work.**

**Real local-execution verification** (isolated project checkout at head
`1b1dc75b`, lockdown config unless noted):
- `@endo/bytes`: 25 passed (incl. assertGenuineUint8Array rejection + shim
  init-order tests that answer erights' threads)
- `@endo/pass-style`: 59 passed
- `@endo/marshal`: 92 passed, 1 skipped (lockdown AND lockdown-unsafe configs)
- `@endo/ocapn`: 261 passed (the Syrup/OCapN wire interop points erights'
  bytewise-vs-shortlex thread concerns)

Run via `node ../../node_modules/ava/entrypoints/cli.js --config
../../ava-endo-lockdown.config.mjs` from each package (the pnpm-linked
node_modules lacks `.bin` symlinks, so `ses-ava`/`ava` are not on PATH; direct
cli.js invocation works around it — a local-verify gap worth noting).

**#503** (freezable-TypedArray emulation, the obsolete bare-ArrayBuffer arm):
OPEN, CLEAN, CHANGES_REQUESTED, head `453f6ef0` unchanged since 2026-07-20. 0
unresolved non-outdated threads (both remaining are outdated/addressed).
Superseded by #475. Disposition question (close-as-superseded vs narrow)
remains unanswered by the maintainer; deliberately untouched.

**#602** (Proxy-based emulation spike): DRAFT, unchanged since 2026-07-10.
Comparison-only, not the landing path.

**#888** (registry follow-up — feat: resolve registry package JSON from
immutable bytes): DRAFT, CLEAN, head `12059c0d`, no review decision yet.
Implementation done; gauntlet-clean stage done (CapData round-trip coverage).
Gauntlet **halted** at panel-1 (stage failed/vanished), then re-promoted to
`todo/` at 2026-07-30T16:18:15Z. Panel-1 is unclaimed in `todo/` — pool-owned,
not started per the job spec's registry-follow-up reservation.

**#671** (EndoRegistry capability): merged 2026-07-29. Registry follow-up
unblocked and in-flight.

**Liveness:** `doin/` empty — no byte-array or registry worker active. Inbox
empty at start and finish.

## What I did

Assessed all artifacts, verified #475 with real local test execution across
four packages and two configs, and recorded this observation. No pushes to any
PR (would invalidate pending re-review state). No execution of the registry
follow-up (pool-owned via gauntlet).

## Follow-ups

- #475 awaits kriskowal re-review; all feedback addressed, erights satisfied,
  CI and local tests green. A maintainer nudge to re-review is the unblock.
- Registry gauntlet panel-1 (`registry-immutable-byte-array-followup-gauntlet-panel-1`)
  is unclaimed in `todo/`; a pool gardener should claim it to advance #888.
- #503 disposition (close-as-superseded vs narrow) awaits maintainer decision.
- Local-verify gap: the pnpm-linked checkout lacks `node_modules/.bin` symlinks,
  so `ses-ava` is "permission denied"; direct `ava` cli.js invocation is the
  workaround. Worth a local-verify skill note so the next dispatch does not
  repeat the dead-end.

Self-improvement: the `node_modules/.bin` gap under the pnpm linker is a
recurring local-verify obstacle (three prior dispatches hit "permission denied:
ses-ava" and stopped). Routed here as a follow-up, not a structural lesson
needing a skill edit yet.
