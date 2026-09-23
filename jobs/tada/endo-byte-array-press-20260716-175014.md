**Press report — endo-byte-array-press (first dispatch of this schedule)**

**Assessment (baseline established):**
- The byteArray-view redesign has fully replaced the immutable-ArrayBuffer approach: design #572 is the design of record, and both bare-buffer PRs (#429 llm-base, #57 master-base) are CLOSED.
- **#503** (freezable TypedArray emulation): CHANGES_REQUESTED but both review threads are outdated — the `set`-memcopy and banner fixes landed and were retconned on 2026-06-25 per kriskowal's request. It is idle awaiting kriskowal's re-review; nothing for a worker to do.
- **#602** (Proxy emulation spike): draft-by-design comparison artifact; no action.
- **#475** (narrow byteArray to plain frozen Uint8Array — the fresh implementation PR of record): CHANGES_REQUESTED with two **live** threads — kriskowal's Node/XS benchmark request on `packages/ascii` encode/decode, previously deflected as "a follow-up for a separate PR." No live agent was on it (checked `inbox-list` and the board). This was the next unblocked artifact, so I took the wheel.
- Registry follow-up: left parked, blocked on #671 (still OPEN, CHANGES_REQUESTED) per charter.

**Work done on #475:**
- Ran the requested benchmark: 4 encode and 4 decode variants at 16 B / 1 KiB / 64 KiB, on Node v22.23.1 and XS (`bin/xst`, Moddable 5.0.0, matching CI). Decisive: on XS the current concat-loop decode is quadratic (209 ms for 64 KiB) and TextDecoder is ~1,700× faster; TextEncoder-then-length-check encode is ~280× faster than the charCode loop. The elegant result: no separate verification pass is needed — UTF-8 output length equals string length iff all code units ≤ 127, so the length check *is* the range check.
- Landed the winner as `d6149e7232` on `feat/narrow-bytearray-to-uint8` (pushed clean, no CAS race): native single-pass fast paths with fallback to the original loops, preserving exact observable semantics (detailed RangeError with offending index; documented >127 pass-through, guarded by length + U+FFFD checks whose soundness I probe-verified in both runtimes) and platforms without the globals. Updated the changeset's now-stale "without relying on TextEncoder/TextDecoder" rationale; added 2 tests pinning the fallback contracts.
- Evidence: `ava --config ava-endo-lockdown.config.mjs` → **8 tests passed**; identical assertions against the shipped logic under `xst` → PASS; prettier, eslint, tsc all exit 0.
- Replied to both threads with the tables and trade-offs: [r3597833660](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3597833660) (decode), [r3597835410](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3597835410) (encode), noting the one honest regression (~0.3 µs/op TextEncoder call overhead on Node 16 B inputs) with an offered cutover if unwanted.

**Not verified:** PR CI on `d6149e7232` was still pending at completion (all checks queued/running); the repo's CI watcher and the next 6h dispatch cover it.

**Follow-ups for the next dispatch:** confirm CI green on `d6149e7232`; check whether kriskowal resolves the two threads or re-reviews (both #475 and the long-idle #503); keep waiting on #671 for the registry follow-up (auto-promoted by the unblock watcher).

Project worktree torn down; inbox drained (empty).
