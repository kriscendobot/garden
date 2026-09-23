The spec is posted with the provenance footer, reply marker, and durable job marker intact, from the bot identity. I did not resolve any conversation (per erights' policy). Job complete.

## Completion report

**Job:** Spec the provider-side genuine-vs-emulated predicate for endojs/endo-but-for-bots PR #475, and post it to the thread for erights to read/decide on.

**State re-derived (clean requeue):** No spec had been posted. The only comment carrying the `garden-reply:5348069925` marker was the *"On it"* ack (5348085320) — no substantive reply existed. No prior re-run had posted under this job's marker.

**What I did:**
- Read the driving comments (kriscendobot's proposal 5347727749, erights' "Yes, please spec that" 5348069925) and inspected the real PR-head code: `immutable-arraybuffer/src/{bytes.js,lib.js}` (the `hiddenTypedArrays` brand WeakMap and the emulated-wrapper mint in `makePseudoTypedArrayConstructor`), `pass-style/src/{byteArray.js,passStyle-helpers.js}`, and the `isView` client sites in `@endo/bytes`, `@endo/base64`, `@endo/hex`, `@endo/ocapn`.
- Wrote the spec for a single hardened export `isEmulatedView(value)` from `@endo/immutable-arraybuffer`: exact contract (six-row return-value table incl. the load-bearing genuine native-immutable-on-XS case → `false`); brand-WeakMap implementation basis with the committed equivalence `isEmulatedView(v) === !ArrayBuffer.isView(v)` over byteArray inputs (why `isView` is the memorable basis but the brand is stronger/total); five provider pinning tests (category table, the equivalence, native-immutable non-conflation, spoof-resistance, and a golden "the loss is real" test that fails loudly if a shim change decouples the brand from `isView` — the silent-break guard erights flagged); per-client consumption; and an explicit "stays separate" section (the `.immutable`-accessor immutable-vs-mutable axis + `toDecodable`; and the DataView-inclusive harden/`passStyleOf` `%TypedArray%`-toStringTag getter sites that must not fold in).
- Posted it as a reply on the #475 thread: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5349227927 (bot identity, provenance footer + reply marker + durable job marker). No conversation resolved.

**Posting-path note:** the garden `comment-reply-gh.sh` handler no-op'd because the *"On it"* ack comment carries the same `garden-reply:<cid>` marker as a substantive reply, so its idempotency grep can't tell the ack apart from the answer — it suppressed the real reply. I bypassed it by posting directly via the fleet `gh` wrapper, keyed on this job's own durable marker for re-run idempotency.

**Follow-up (garden-automation, out of scope here):** the ack/substantive-reply marker collision above is a latent defect — an acknowledged comment whose ack fired will have its later substantive reply silently swallowed by the handler. Worth a distinct garden fix (e.g. give the ack a separate marker namespace).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-spec-genuine-predicate-20260819.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 41 tokens (1344152 cached reads)
- Output: 17638 tokens
- Cost: $1.788786 (3 engagement(s) unpriced)
- Wall-clock: 375s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
