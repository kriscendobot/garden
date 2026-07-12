Completion report:

**Job `ebfb-124-daemon-cbor-frame` complete.** Designed the daemon's migration from netstring framing to cbor-frame, as requested by kriskowal's inline review comment on endojs/endo-but-for-bots PR #124.

**What I did**
- Authored `designs/daemon-cbor-frame-migration.md` (slug: `daemon-cbor-frame-migration`) following the project's design conventions (metadata table, problem statement, dependencies, phased implementation, numbered decisions, open questions, prompt capture). Key content:
  - **Call-site inventory** across five surfaces with version coupling: private Unix socket (`servePrivatePath` / `makeEndoClient` / Rust `socket.rs`), worker fd 3/4 pipes, engo tunnel, public networks (`tcp+netstring+json+captp0`, ws-relay/iroh/libp2p adapters), and the endor slot-machine external transport. OCapN-noise and the `@endo/netstring` package itself are explicitly out of scope.
  - **Wire-compatibility story**: netstring frames open with ASCII digits (0x30-0x39) while cbor-frame heads open with 0x40-0x5b or 0xd8 — disjoint sets, so the accept side sniffs one byte and mirrors the initiator (writer gated on classification to make the ordering assumption safe), while same-install edges flip atomically. Public networks get a new protocol identifier instead of an in-place flip.
  - **Slot-machine/CapTP interaction**: a framing seam (`framing.js`) makes framing orthogonal to the session-protocol fork, honoring the maintainer's "equal in stature" directive; tag-24 frames only for slots (real CBOR payloads), untagged for JSON CapTP.
  - **Five-phase rollout**: package lands (PR #288) → seam + bilingual accept → tight-edge flips → client default flip behind `ENDO_CBOR_FRAME` → sibling TCP network module → netstring retirement.
- Synced `designs/README.md`: summary-table row, M4 (Networking) bucket row, new Framing subgraph in the dependency graph, per-design estimate (M, 1 week), milestone counts/totals, and the header/recently-added log. All mermaid fences parse-validated per the mermaid-validation skill.
- Opened **draft PR #711** against `llm` (branch `design/daemon-cbor-frame-migration`, commit `554a2427ac`): https://github.com/endojs/endo-but-for-bots/pull/711
- Replied on the originating PR #124 review thread with the design link, under the repo's standing comment authorization; journaled the result entry with both URLs.

**Notable finding**: the maintainer's term "cbor-frame" is the implemented package name from open PR #288 (`@endo/cbor-frame`), which supersedes the `@endo/cbors` name proposed in `designs/cbors.md`; the design records that supersession.

**Follow-ups**: PR #288 is the phase-0 prerequisite and is still open; Phase 1 should sequence after PR #124 merges to avoid a conflict-heavy weave (both stated in the design). Five open questions are surfaced for maintainer decision, including the protocol-identifier spelling and the sniffing-accept retirement.

Self-improvement: routed a message to the liaison — `roles/COMMON.md` § Reporting references `skills/journal-sync/SKILL.md`, which no longer exists in the v2 library.
