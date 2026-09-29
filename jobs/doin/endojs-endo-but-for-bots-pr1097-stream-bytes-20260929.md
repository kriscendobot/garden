---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T13:46:10Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# PR #1097: migrate streamBase64 usage to stream() with passable byte arrays

Repo endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1097
(head `fix/readableblob-byte-array-cleanup`; runs after the weave child re-pinned the base).
Ask 2 of kriskowal's APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1097#pullrequestreview-5348027197: "consider migrating the streamBase64 usage to
simply stream using our passable byte arrays, as the former is or will be deprecated."
(See packages/exo-stream/DESIGN.md § Migration Path for Bytes Streams: responders offer
`stream()` yielding Uint8Array/passable byte arrays; initiators move from
`iterateBytesReader` → `iterateReader`.)

Scope: the streamBase64 usage this PR touches — the `withCachedReads` (platform cached-fs)
miss path whose caller-drain + background-populate reads cross the wire as `streamBase64`,
and the PR's `canonicalizeStreamEventsRace` test helper + snapshot in
packages/platform/test/cached-fs.test.js that name `streamBase64`. Migrate the initiator
side to `stream()`/`iterateReader` where the responders (LocalBlob, SnapshotBlob, mount
files) already provide or can cheaply provide a byte-array `stream()`; update the helper,
its unit test, and the ava snapshot accordingly (note: ava snapshots may not round-trip under
the immutable-arraybuffer shim — see ebfb#1334). Keep `streamBase64` on responders for
compatibility. If the migration is infeasible or widens scope badly, reply on the review
explaining why (the ask says "consider") instead of forcing it. Push to the head; keep CI
green. Add a changeset if a public surface changes. No merge.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T14:20:23Z
