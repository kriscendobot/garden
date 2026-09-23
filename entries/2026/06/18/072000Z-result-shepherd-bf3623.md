---
ts: 2026-06-18T07:20:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/dispatch-shepherd-70a4b9.md
---

## PR #461 — exo-stream mirror + chat/agent migration CI fix

**Pre-head SHA**: 93fa0d144  
**Post-head SHA**: d74d38265 (two commits)

### Failure classification (run 27735265214, head 93fa0d144)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | sandbox-drivers | TypeError: target has no method "next", has [readReturnPattern, streamBase64] | fixed: podman.test.js drainReader migrated to iterateBytesReader |
| C | test (all 4 matrix variants) | TypeError: target has no method "stream", has [next, return, throw] | fixed: mock-powers.js followMessages() wrapped with readerFromIterator |
| C | cover (22.x, 24.x) | same mock-provider-fixtures TypeError as test | fixed: same root cause, same fix |
| C | lint | Prettier drift in 8 files | fixed: prettier --write on the 8 files |

### Fix substance

**Commit f46d21701** — fix(sandbox,lal): migrate test consumers to exo-stream PassableReader API

- `packages/sandbox/test/podman.test.js`: `drainReader` called `E(reader).next()` directly on a `PassableBytesReader` exo (which only has `readReturnPattern` and `streamBase64`). Imported `iterateBytesReader` from `@endo/exo-stream/iterate-bytes-reader.js` and threaded the local iterator instead.
- `packages/lal/tools/mock-powers.js`: `followMessages()` returned a raw async generator. `agent.js` calls `iterateReader(E(powers).followMessages())` which calls `.stream()` on the result; a plain generator only has `next/return/throw`. Wrapped with `readerFromIterator()` to produce a proper `PassableReader` exo.

**Commit d74d38265** — chore: format (Prettier)

- 8 files: `packages/chat/token-autocomplete.js`, `packages/daemon/src/daemon.js`, `packages/daemon/src/directory.js`, `packages/daemon/test/content-store-gc-invariants.test.js`, `packages/daemon/test/content-store-gc.test.js`, `packages/daemon/test/endo.test.js`, `packages/daemon/test/mount.test.js`, `packages/fae/endo-skill.js`.

### Pre-push-gates

Yarn not installed in dispatch worktree; format/lint auto-fix stages skipped (yarn format would have caught the Prettier drift). Prettier was run directly via `npx prettier --write`. Garden-specific probes show many pre-existing failures across the repo (filename-no-stutter, no-ascii-banners, no-inline-import-jsdoc, no-non-ascii-in-source) all pre-dating this PR; not in scope.

### PR comment

https://github.com/endojs/endo-but-for-bots/pull/461#issuecomment-4739207679

### CI new run

Run 27743930294 is in progress (all jobs pending at shepherd exit time).

### Recommended next stage

next: conductor — pending CI green on run 27743930294. If any job still red (unexpected secondary failure unmasked by this round), next: fixer.

Self-improvement: The sandbox-drivers test pattern (drainReader calling .next() directly) is the mirror of the daemon/channel.js pattern (readerFromIterator on the producer side). Both were caught in one pass because the dispatch hint named the Exo method set. A note worth encoding: when a test helper calls E(ref).next() on a process stdout/stderr ref, the first question is "what Exo interface does that ref implement?" — iterateBytesReader() is the consumer-side adapter for PassableBytesReader.
