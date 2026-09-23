---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:40:46Z
---
Assessed the byte-array front with real-execution evidence (not just remote-status inspection).

**Front PRs (both reviewer-stalled, unchanged):**
- #475 (view-based finish-line shape, head `1b1dc75ba9`): OPEN, CHANGES_REQUESTED, 13 days parked, 0 new comments since 07-17. All 12 unresolved review threads are answered (last comment is kriscendobot's fix/benchmark or an erights ack); the two non-outdated open threads (compare.js reject-emulated-input, genuine-uint8-array.js shim-order test) were fixed in `4f5192232` and `1b6df4a9b`. The ball is in the reviewer's court.
- #503 (obsolete bare-buffer approach, head `453f6ef0`): CHANGES_REQUESTED, 10 days parked, awaiting the maintainer's disposition (close-as-superseded-by-#475 vs narrow). Untouched per the standing promise.
- #602: DRAFT comparison spike, not the landing path.

**Registry follow-up advanced (no longer blocked):** #671 merged 07-29; the unblock watcher auto-promoted `registry-immutable-byte-array-followup`, which completed (PR #888, DRAFT, head `12059c0d`). Its gauntlet panel round 1 is now queued in `todo/` (unclaimed). Per the job spec I did not take it over — it is the pool's gauntlet job.

**Real-execution evidence (the gap prior dispatches could not close):** checked out #475's branch `feat/narrow-bytearray-to-uint8` (warm-cache hit, deps linked) and installed node-tool-shims so `ses-ava` could spawn `ava`. Ran the three byte-array-critical suites:
- `@endo/pass-style`: 59 tests passed, including all 25 byteArray passStyle admission cases (rejects bare immutable ArrayBuffer, accepts whole-buffer frozen Uint8Array view, rejects sub-views, rejects mutable backing buffer, rejects shadowing/agreed/out-of-range/non-canonical own indices).
- `@endo/bytes`: 25 tests passed, including `compareBytes`/`bytesEqual`/`concatBytes` reject emulated arguments, and the genuine-uint8-array shim-order test.
- `@endo/marshal`: 92 passed + 1 skipped, including "compareRank orders byteArrays by shortlex, reading bytes correctly" and encodePassable round-trips.
- `@endo/captp`: 11 passed (loopback boundary parity).

**`llm` gap confirmed:** `llm`'s `packages/marshal/src/encodePassable.js` still throws `encodePassable(byteArray) not yet implemented` (line 482); #475 implements it as `a<length>:<hex>` with a matching `decodeByteArray`. So byteArray marshalling across the CapTP boundary is NOT yet on `llm`; #475 is the implementation that lands it.

**Next unblocked artifact:** #475 is idle (no live agent, no doin claim) and is the complete, green implementation. A retarget to `llm` is a 2437-commit rebase and would invalidate the pending re-review state, so I did not force it. The arc is reviewer-blocked: #475 needs a re-review/merge decision, #503 needs a disposition. No code changes or pushes made.

Follow-up: re-review on #475 and disposition on #503 remain the maintainer gates; the #888 gauntlet panel is the pool's next claim.
