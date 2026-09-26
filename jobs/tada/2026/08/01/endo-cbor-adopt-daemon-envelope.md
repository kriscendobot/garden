Everything is finalized and verified. PR #894 is open as a clean draft with correct base and head. The job is complete.

## Completion report

**Job:** Adopt `@endo/cbor` in `packages/daemon/src/envelope.js` (cbor-codec design, phase 4) — endojs/endo-but-for-bots.

**Outcome:** Draft **PR #894** open against frozen base `llm-e9564f0` (snapshot of `llm` containing phase-1 `@endo/cbor`, merge `3b21299`), head `6dc98ae30a`, clean 3-commit history. This resumed a requeued session whose prior work was intact; I verified it end-to-end, cleaned up an unsquashed `fixup!` commit, and confirmed all gates.

**What changed:**
- `packages/daemon/src/envelope.js` — the ~130-line hand-rolled CBOR codec (third in-repo copy of the canonical head grammar) replaced with `@endo/cbor` imports: `makeCborWriter`/`writeArrayHeader`/`writeInt`/`writeByteString`/`writeTextString`/`cborWriterBytes` on the write side, `makeCborReader`/`readArrayHeader`/`readInt`/`readByteString`/`readTextString` on the read side. Envelope framing and the `[handle, verb, payload, nonce]` shape stay behind; `readFrameFromStream` keeps its one incremental byte-string head parse (streaming, can't use a whole-buffer reader).
- **Number domain:** `handle`/`nonce` stay `number` in the public API (every rider uses them as Map keys / `> 0` comparisons); converted to/from bigint only at the codec edge (`BigInt(env.handle)` / `Number(readInt(...))`).
- `packages/daemon/package.json` — added `@endo/cbor` dep; `yarn.lock` updated in its own `chore:` commit; `tsconfig.composite.json` — added the `../cbor` project reference.
- `packages/daemon/test/envelope.test.js` — added a golden-vector test (RFC-8949-derived canonical bytes, codec-independent) and a strict-reader regression test.
- `.changeset/daemon-adopt-endo-cbor.md` — patch bump for `@endo/daemon`.
- `designs/cbors.md` § Dependencies — supersession note recorded (per the standing caveat): the duplication decision governed the three *framing peers*, not the daemon envelope; supersession confirmed, framing peers' independence unaffected. No maintainer stop was required.

**Evidence (real-execution):**
- **Byte-identity:** hex diff of every envelope/frame fixture across all argument-width boundaries, old vs new encoder — **empty** (864 local fixtures; golden vectors `8400604000`, `84016568656c6c6f4301020307`, `8420604000`, `8419ffff6464617461401903e7`, `440a141e28` lock the format).
- **Strict-reader tightening confirmed safe:** the Rust peer's `cbor_append_head` (`rust/endo/xsnap/src/envelope.rs`) writes minimal heads, so no live traffic hits the stricter path — only malformed input is now rejected (a test pins it).
- **All 23 PR CI checks pass**, including `test-xs` (XS lane), `test` on 22.x/24.x ubuntu+macos (daemon suites green in real CI — confirming my sandbox's `endo.sock` failures were purely a local unix-socket limitation, identical on base and branch), `lint`, `test-ocapn-python`, `test262`, `cover`.
- **Local gates:** envelope test 15/15, `eslint` clean, `tsc` clean.

**Follow-ups:**
- The draft auto-runs the gauntlet under the supervising gardener; no separate gauntlet job posted (per norms).
- Orchestration ordering note: the predecessor `endo-cbor-adopt-ocapn` (PR #885) is still DRAFT/unmerged. This PR touches a different package (daemon vs ocapn) with no code dependency, so it stands independently on the frozen `llm` snapshot; the orchestrator may sequence merges as it sees fit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-cbor-adopt-daemon-envelope.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 25 tokens (2559896 cached reads)
- Output: 15404 tokens
- Cost: $3.597133 (2 engagement(s) unpriced)
- Wall-clock: 2702s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
