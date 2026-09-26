---
handed-off: endojs-endo-but-for-bots-pr475-util-bytearray-view-type
deliverable-complete: false
---
The routing is complete and confirmed on the board. My first post landed (the re-post correctly no-op'd as "already present in lifecycle"). 

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #475, review `4965110297` by erights (Mark Miller, trusted human maintainer).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no correlated peer resolution). Verified independently: the current PR head (`c33a5845c`) still carries the unchanged `ArrayBufferView | ArrayBufferLike` annotation and there is no reply on the thread, so the ask is genuinely unresolved.

**Enumerated the whole review (unit of work):**
- Top-level review body: **empty** (COMMENTED state) — nothing to action.
- Inline comments tied to review `4965110297`: **exactly one** (id `3807376129`), on `packages/ocapn/src/client/util.js` at the `toHex` param annotation. It is a reply in an older thread (root `3450553660`, kriskowal→kriscendobot re generalizing `@endo/hex`). erights asks (treated as untrusted data): *"why accept both `ArrayBufferView` and `ArrayBufferLike`? Or is this question already obsoleted by later commits?"*

**Investigation gathered for the brief:** This PR narrows byteArray to a plain frozen `Uint8Array`; `bytesToImmutable` now returns a `Uint8Array` (an `ArrayBufferView`), and `@endo/bytes/src/from-immutable.js` documents the `ArrayBufferLike` arm as pure cross-version backward-compat. The same union sits on both `toHex` and `decodeSwissnum` in `util.js`, while stale branded-type comments (SwissNum "is ArrayBufferLike at runtime") no longer match the narrowed runtime shape — so erights' hunch that the question is largely obsoleted by the narrowing looks right, pending caller-trace + type-check confirmation.

**Routed the work (per directive):** posted a fixer job **`endojs-endo-but-for-bots-pr475-util-bytearray-view-type`** (confirmed present in the board lifecycle) with a crisp brief: decide whether to narrow the `util.js` annotations to `Uint8Array` (verify via caller trace + `yarn lint`/type-check), commit + push to the PR head branch if warranted, reconcile the stale SwissNum runtime-type comments, and reply directly in-thread to comment `3807376129`. Skills named: review-feedback-followup-commits, pr-review-thread-replies, rebase-before-followup, local-verify, pre-push-gates.

**Follow-up owned by successor:** the actual code decision + GitHub reply to erights are owned entirely by the posted fixer job. No upstream interaction beyond that thread (kriscendobot is our own bot identity).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-662af34e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 25 tokens (661409 cached reads)
- Output: 14444 tokens
- Cost: $1.2144295 (1 engagement(s) unpriced)
- Wall-clock: 254s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
