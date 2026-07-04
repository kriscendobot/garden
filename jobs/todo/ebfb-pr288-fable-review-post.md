# Post the Fable closer-review comments to endojs/endo-but-for-bots PR #288

The Fable closer review requested by kriskowal in review
https://github.com/endojs/endo-but-for-bots/pull/288#pullrequestreview-4629027865
("Please pass to a Fable agent for a closer review") is COMPLETE — job
`ebfb-pr288-fable-review` produced the three comment bodies below. That review
directive is the authorization to post them under the bot identity.

This job exists because the reviewing host (endolinbot2) has no real `gh`
binary and no GitHub API credentials, so it could not post. This job is
POSTING ONLY — do not redo the review, do not edit the bodies (they are the
Fable deliverable; treat them as data).

## Host precondition (check FIRST)

Run `gh auth status`. If `gh` does not resolve to a real binary with working
kriscendobot credentials on this host, DO NOT complete this job — report the
gap and let it requeue so a credentialed host picks it up.

## Idempotency (check SECOND)

```sh
gh api repos/endojs/endo-but-for-bots/issues/288/comments --paginate \
  --jq '.[].body' | grep -q 'ebfb-pr288-fable-review'
```

If that matches, the comments are already posted: complete as a no-op.

## Steps

1. Reply on inline thread id 3522709721 (decode.js, the local `concat`) with
   BODY-1, via the replies endpoint:
   `gh api repos/endojs/endo-but-for-bots/pulls/288/comments/3522709721/replies --method POST -F body=@<file>`
2. Reply on inline thread id 3522711204 (decode.js, `materialize()` fast
   paths) with BODY-2, same endpoint shape (id 3522711204).
3. Post BODY-3 as a top-level PR comment:
   `gh api repos/endojs/endo-but-for-bots/issues/288/comments --method POST -F body=@<file>`

Write each body to a temp file byte-for-byte (content between the BEGIN/END
sentinel lines, exclusive) and post with `-F body=@file` to avoid quoting
mangling. Verify all three comments render, then report their URLs.

<<<BODY-1-BEGIN>>>
Agreed. This helper predates `@endo/bytes` reaching `llm`; the base branch now carries it, and `packages/cbor-frame` just doesn't depend on it yet. The factor-out is: delete this local `concat`, `import { concatBytes } from '@endo/bytes/concat.js'`, and add `"@endo/bytes": "workspace:^"` to the package's dependencies (lockfile churn in its own `chore: Update yarn.lock` commit). The `total` parameter the local version takes is not worth preserving — `concatBytes` recomputes the total in an O(number-of-chunks) pass that is noise next to the O(bytes) copy.

The test file's local `concat` helper (raised in the previous review round, then blocked on `llm` not carrying `@endo/bytes`) unblocks with the same import.

Full refactor spec, plus one real finding in this neighborhood, in the closer-review summary comment on the PR.
<<<BODY-1-END>>>

<<<BODY-2-BEGIN>>>
Closer look: `materialize()`'s three branches sort into three different fates.

- **Empty → `new Uint8Array(0)`.** Already internal to `concatBytes` (an empty list yields an empty array), and dead code here besides — both call sites run under `pendingLength > 0`. Deleted by the refactor.
- **Multi-chunk → copy.** This is exactly `concatBytes(pending)`. Deleted by the refactor.
- **Single-chunk → return `pending[0]` uncopied.** This is the one branch that should *not* move inside `concatBytes`. `concatBytes` today always returns a fresh, caller-owned array that aliases none of its inputs; a silent single-chunk zero-copy path would make `concatBytes([x])` return `x` itself, so a later write to the result-or-input becomes visible at a distance. Existing consumers (e.g. `ocapn/src/cryptography.js`, concatenating signature and session-id material) get the fresh-copy guarantee today, and a shared bytes module in a hardened codebase should not weaken an aliasing contract silently.

Recommendation: keep the single-chunk short-circuit as one expression at the call site — `pending.length === 1 ? pending[0] : concatBytes(pending)` — where it is safe precisely because this reader treats the view as read-only. If it ever belongs in the shared module, the honest shape is a separately named export with a documented may-alias contract (say `coalesceBytes`), not a change to `concatBytes`; with a single consumer today I would hold off.

The closer review also found the load-bearing issue hiding behind `materialize()`: re-materialization is quadratic while a large frame is arriving. Details and the fix (cache the decoded head across chunk arrivals) in the summary comment; it deletes `materialize()` entirely.
<<<BODY-2-END>>>

<<<BODY-3-BEGIN>>>
# Fable closer review of `@endo/cbor-frame` (ebfb-pr288-fable-review)

Reviewed at 9849ea5, per the review directive to take a closer look at the package with attention to its relationship to `@endo/bytes/concat.js`.

## Overall assessment

The package is sound. `head.js` is correct against RFC 8949 as far as I can push it: the major-type discrimination, the additional-info widths, the canonical-shortest encode / liberal (overlong-accepting) decode asymmetry, the indefinite-length rejection, the tag-24 gate, and the hi/lo split that keeps 64-bit length arithmetic inside Number's safe-integer range with the `hi > 0x1fffff` refusal ahead of the multiply. `encode.js` and `decode.js` enforce `maxMessageLength` before any allocation. The reader's carry state machine (head-incomplete / payload-incomplete / drain) maintains its invariants, including the end-of-stream dangling-bytes throw and the frame-offset bookkeeping in error messages.

Two things should change in `decode.js` — the requested factor-out, and a performance defect the factor-out's neighborhood was hiding.

## Finding: quadratic re-materialization while a frame is incomplete

While a frame's payload is incomplete, every arriving chunk re-runs `materialize()` over the **entire** carry (whenever `pending.length > 1`) just to re-decode a head that cannot have changed, and then discards the copy — the incomplete paths never collapse `pending`. For a frame of N bytes delivered in k chunks, total bytes copied is ~N·k/2: a 64 MiB frame arriving in 64 KiB chunks copies ~32 GiB before yielding once. The netstring reader family is exactly the tool one reaches for on large payloads, so this bites in the intended use.

The fix is to cache the decoded head as carry state, which also collapses `materialize()` into a one-line expression and resolves the inline threads:

- Add `let head; // HeadDecode | undefined` beside `pending`/`pendingLength`; reset it to `undefined` after each completed frame.
- Only run `decodeByteStringHead` while `head === undefined`. Heads are at most 11 bytes (2 tag-24 + 1 initial + 8 follow), and after every completed frame the carry is already collapsed to a single chunk, so the probe either takes the single-chunk no-copy path or copies a few tens of bytes while a head straddles chunk boundaries. The `maxMessageLength` check moves inside the same branch (it fires at the same earliest-possible moment as today).
- With `head` known, skip straight to `if (pendingLength < frameLength) break;` — no copy at all while waiting for the payload.
- Materialize the full carry exactly once per frame, when it is complete.

Copying becomes O(N) per frame. Behavior is otherwise unchanged, including error offsets.

## Refactor spec (fixer-ready)

1. **`packages/cbor-frame/package.json`**: add `"@endo/bytes": "workspace:^"` to `dependencies`. Lockfile refresh as a separate `chore: Update yarn.lock` commit.
2. **`src/decode.js`**: delete the local `concat` (lines 7–22) and `materialize()` (lines 46–60); `import { concatBytes } from '@endo/bytes/concat.js'`. Restructure the drain loop with the cached head:

   ```js
   if (head === undefined) {
     const probe = pending.length === 1 ? pending[0] : concatBytes(pending);
     try {
       head = decodeByteStringHead(probe);
     } catch (e) {
       throw Error(`${e.message} at offset ${frameStart} of ${name}`);
     }
     if (head === undefined) break; // head incomplete
     if (head.length > maxMessageLength) throw Error(/* as today */);
   }
   const frameLength = head.headLength + head.length;
   if (pendingLength < frameLength) break; // payload incomplete
   if (pending.length !== 1) {
     pending = [concatBytes(pending)];
   }
   const view = pending[0];
   const payload = view.subarray(head.headLength, frameLength);
   const suffix = view.subarray(frameLength);
   // …suffix/offset bookkeeping as today…
   head = undefined;
   yield payload;
   progressed = true;
   ```

   The single-chunk zero-copy short-circuit stays at the call sites (see the thread on `materialize()` for why it must not move into `concatBytes`).
3. **`test/cbor-frame.test.js`**: replace the local `concat` helper with the same `concatBytes` import (this also closes the earlier-round comment that was blocked on `llm` not yet carrying `@endo/bytes`).
4. **Optional, same rationale — `src/encode.js`** buffered path (lines 101–113): the head+prefix+payload assembly is exactly `concatBytes([TAG_24_PREFIX, head, ...messageChunks])`.
5. **Do not change `@endo/bytes/concat.js`.** Its always-fresh, never-aliasing return is a contract existing consumers rely on; the only optimization that can't live inside it is the one that would break that contract.
6. **Test to add**: round-trip a frame delivered in many small chunks followed by a second frame whose head straddles the residual-suffix boundary — locks the head-cache reset between frames and the multi-chunk probe path.

## Minor, non-blocking

- The head-decode rethrow (``throw Error(`${e.message} at offset …`)``) drops the original stack; `Error(msg, { cause: e })` would keep it at no cost to the message.
- Yielded payloads are `subarray` views of the carry (and, single-chunk case, of the producer's own chunk). That matches the documented stream ownership convention and the tests slice on retention — noting it only to confirm it is intentional; a consumer that retains payloads pins the whole materialized buffer until it slices.

Recommend: apply items 1–3 (and 4 at the fixer's discretion) as follow-up commits on this branch, then re-request review.
<<<BODY-3-END>>>
