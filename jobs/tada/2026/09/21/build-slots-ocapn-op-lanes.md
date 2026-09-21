The work is complete. All verification passed and PR #990 is updated and left as an open draft per the manual-gauntlet regime.

## Completion report

**Job:** `build-slots-ocapn-op-lanes` — implement accepted design `designs/slots-ocapn-op-lanes.md` on `endojs/endo-but-for-bots`, reconciling draft PR #990's candidate.

**What I found.** The candidate already on #990's head (commit `964275b3`) had promoted `get`/`index`/`untag` to first-class verbs and added the Eventual Send surface (`E.index`/`E.untag`, `HandledPromise.index`/`untag`, local handler checks) — that part matched the design and I kept it. But it had **diverged** from the settled acceptance boundary in exactly the way the design's "Alternatives Considered" rejects: it carried the data lanes in the **opaque `deliver` payload** (JS `flip.js`/`client.js` reused `DeliverPayload`; Rust routed all four verbs through `translate_deliver`), added **no** dedicated payloads or `translate.rs` functions, and **swallowed** translate errors (`if let Ok`) instead of failing closed.

**What I changed (commit `86d91b3762`, 13 files):**
- **JS `@endo/slots`** — dedicated compact canonical-CBOR payloads `GetPayload`/`IndexPayload`/`UntagPayload` (`[target, scalar, reply]`) in `payload.js` with strict UTF-8, `index` bound `0 ≤ i < 2**32−1`, required-Promise `reply`, non-Device `target`; codec `encodeGet/decodeGet` (+index/untag) threading only target+reply through the c-list; `client.js` send/receipt split onto the dedicated codecs; `flip.js` flips the dedicated payloads; new `index.js` exports.
- **Rust `rust/endo/slots`** — `GetPayload`/`IndexPayload`/`UntagPayload` with matching canonicality/bounds/kind checks and a strict-consume decoder; `translate_get/index/untag`; `mod.rs` exports.
- **Rust supervisor** — routes each data verb through its own decoder+translator and **fails closed** (tears the edge's sessions down, drops the message) on malformed payloads; `deliver`/`resolve` keep legacy pass-through.
- **Parity** — pinned hex fixtures duplicated JS↔Rust, plus round-trip, malformed, out-of-range, wrong-descriptor-kind, and trailing-byte tests both sides. README + changeset updated.

**Verification (all green):** slots JS 100, slots Rust 59, eventual-send 65, ocapn 534, capn-web 185; `cargo test -p endo` green; `cargo build -p endo` compiles supervisor.rs (after generating the gitignored XS bundles + initing the `c/moddable` submodule locally — pre-existing env setup, not code); slots+eventual-send `tsc`/`eslint` clean.

**Delivery.** Reconciled in place on #990's branch (`endojs:bot/slots-ocapn-deliver-convention`, fast-forward `617cb45..86d91b3`), title/body updated to the seven-verb reality, **left as an open DRAFT** (base `llm-a54c3ad`). Both the original and my `<!-- garden-job -->` markers are in the body for requeue adoption.

**Follow-ups for the maintainer:** promote with **run the gauntlet #990** when ready. Note #990's base is the frozen `llm-a54c3ad` (the established slot-machine stack base), not live `llm`; the design doc still lives on design PR #1285 (approved, unmerged) and is referenced as source of truth.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-slots-ocapn-op-lanes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 236 tokens (16399845 cached reads)
- Output: 90345 tokens
- Cost: $12.472858500000001
- Wall-clock: 1638s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
