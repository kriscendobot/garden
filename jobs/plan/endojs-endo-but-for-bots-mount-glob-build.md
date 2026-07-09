---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-mount-ext-rebuild-orch-127
priority: normal
posted_by: producer
posted_at: 2026-07-09T18:51:19Z
---

---
role: builder
---

# Build: mount glob (PR B of the #127 reconstruction)

Repo: endojs/endo-but-for-bots. Spec: `designs/mount-extensions-reconstruction.md`
§ "PR B — glob" and § "Test strategy" on design PR
https://github.com/endojs/endo-but-for-bots/pull/648 (read from branch
`design/mount-extensions-reconstruction` if not yet merged).

Implement `EndoMount.glob(pattern)` per the design's normative pattern
semantics (only `*` and `**` are metacharacters; deny-filtered; confined;
final code-unit sort; 10k cap with silent truncation). This PR also lands the
shared fixture manifest (`mount-fixture-manifest.json`), the Node fixture
builder (`_mount-fixture.js`), and the full glob variant case table
(`mount-glob-cases.json`) — the review's emphasis is comprehensive glob
coverage for Rust/Node parity. Head branch `feat/mount-glob`, base = head of
`feat/mount-revocation` (stacked; PR A must be open first). Run the standard
PR-creation chain. File the Rust/XS-side case-table runner follow-up the
design names.
