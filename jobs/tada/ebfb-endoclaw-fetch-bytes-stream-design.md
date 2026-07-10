Completion report:

**Job:** ebfb-endoclaw-fetch-bytes-stream-design (designer)
**Deliverable:** Draft PR [endojs/endo-but-for-bots#673](https://github.com/endojs/endo-but-for-bots/pull/673) against `llm`, carrying `designs/endoclaw-fetch-bytes-stream.md` (new) and the `designs/README.md` plan sync. Design slug: `endoclaw-fetch-bytes-stream`.

**What the design says:**
- Adds `bytes()` and `stream()` accessors to `FetchResponse` (and the realized `HttpResponse` exo of `@endo/exo-http-client`), plus `ByteArray` request bodies on `FetchOptions`, with streaming upload as a deferred phase 4. Additive; breaks nothing.
- The surface is expressed in **passable byte arrays** (pass style `byteArray`, an immutable ArrayBuffer) from day one — no bespoke transfer type. Investigation of the `llm` tree established the exact gate state: construction is available everywhere (`ses` lockdown arms the `@endo/immutable-arraybuffer` shim), pass-style and `M.byteArray()` patterns support are landed, but marshal throws "not yet implemented" on `byteArray`, so nothing crosses CapTP yet (upstream tracking: endojs/endo#2248).
- Gate rule derived from that: phases 1–2 do **not** wait, because the #621 Connector Contract composes connectors same-vat (no marshal hop), so Drive/Gmail media connectors are buildable now; only the remote CapTP surface rides endo#2248, with the existing `@endo/exo-stream` base64 bytes-reader idiom as the documented interim and a zero-signature-change flip when marshal lands.
- Key semantics pinned: buffered mode keeps one capped accumulation buffer (`bytes()` is one `transferToImmutable`, coexists with `text()`/`json()`, no one-shot state); streaming is chosen at fetch time (`stream: true`) with cumulative byte-cap accounting that breaks the stream with a structured error rather than silently truncating; OAuth-layer path/method/header checks unchanged.
- README plan sync: added to M7 (Weblets & Integrations, 12→13), summary table, dependency graph (`enetfetch → ebytes → eoauth`), per-design estimate (S-M, 2–3 days), last-updated and recently-revised heads.

**Follow-ups:** (1) The `FetchOptions`/`FetchResponse` widening should be folded into `designs/endoclaw-oauth.md` once PR #621 (still open) lands — the new design flags this as phase 2. (2) Three open questions left for the maintainer: chunk-size normalization policy, the undici `duplex: 'half'` gate for streaming upload, and how `llm` adopts endo#2248 when it lands.

**Verification:** design-stage only; no code built. Both files committed (`0ddcfa1007`) and pushed; PR #673 opened draft per designer norms, body citing the originating inline comment on #621. Inbox drained; empty.

Self-improvement: nothing this time.
