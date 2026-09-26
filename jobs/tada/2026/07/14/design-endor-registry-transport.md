The design is complete and delivered. Let me write the completion report.

Job complete. Summary follows.

---

## Completion report

**Job:** Design an Endor/XS registry transport power for `endojs/endo-but-for-bots` PR #671.

**What I did.** Studied PR #671 (`refactor(daemon): inject registry backend powers`, head `endo-registry-capability`) without modifying its branch: the `RegistryBackend` shape and failure taxonomy in `registry.js`, the platform-neutral `makeRegistryBackend` in `registry-node.js`, the `makeRegistryNodePowers`/`makeRegistryStubPowers` perimeter, and the Endor/XS side (`bus-daemon-rust-xs.js` wiring the stub; `makeXsCryptoPowers` offering sha256/hex only; `bus-xs-host-globals.d.ts`; the `host_aliases.js` + `rust/endo/xsnap/src/powers/*.rs` host-function registration; the worker-spawn envelope/nonce async pattern; `tokio` already a Rust dep, no HTTP/gzip crate yet). Cross-referenced the related designs (`registry-capability` § Two backends, `endor-npm-registry-proxy`, `daemon-endor-architecture`, `worker-rust-xs`).

**What changed** (draft PR **#730** against `llm`, branch `design/endor-registry-transport`, bot identity):
- **`designs/endor-registry-transport.md`** (new, Proposed, M11) — a concrete implementation design:
  - **Reuse-the-JS-backend** architecture: `makeRegistryBackend` is already platform-neutral, so the XS lane injects only the three missing primitives → parity is structural, not a second implementation. (`endor-npm-registry-proxy`'s all-Rust path is handled under Alternatives.)
  - **Rust host API**: `hostRegistryFetch(url, nonce)` **async** via the existing spawn-envelope/nonce pattern (`registry-response`/`registry-error` verbs, tokio task off the XS thread) so the CapTP reactor never blocks; synchronous `hostGunzip` (`flate2`); one-shot `hostHashDigest(algorithm, bytes)` → base64 for sha512/sha256/sha1.
  - **JS adapter** `makeRegistryXsPowers` (new `registry-xs-powers.js`) replacing `makeRegistryStubPowers` on `bus-daemon-rust-xs.js`, with an extracted shared `verifyIntegrity`.
  - **Network error mapping** table into the existing taxonomy (transport reject → `RegistryNetworkError`; 404 → `RegistryMissingPackageError`; integrity → `RegistryTamperedError` un-wrapped; gunzip corruption → network), plus host-offline vs caller-`offline` distinction.
  - **XS parity test plan**: adapter-parity matrix on the Node `ava` lane (mock host globals, per the `mount-platform-fs-conformance` shim technique) + live fixture-registry integration on the `test:rust` lane; phases, decisions, alternatives, open questions.
  - Both mermaid diagrams parse-validated (parse-only, no browser).
- **`designs/README.md`** synced per convention: summary-table row, M11 milestone table + count (2→3), dependency-graph node/edge, per-design estimate, totals (147→148), and header prose.

**Verification.** Mermaid fences validated via `mermaid.parse()` (design: flowchart + sequence OK; README: flowchart + gantt OK). PR confirmed `isDraft: true`, base `llm`. I did **not** run `tsc`/`eslint` — this is a docs-only design change with no code surface to build.

**Follow-ups** (named in the design): choose the Rust HTTP crate (`reqwest` default, filed against M11); optional host-offline signal (open question); `.npmrc` auth / scoped registries deferred to `endor-npm-registry-proxy` § Known gaps. The design is implementable by a future builder as stated; the open questions are non-blocking.
