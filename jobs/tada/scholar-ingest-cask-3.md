Everything is verified and complete. The follow-on `scholar-ingest-cask-4` was posted and has already been claimed by a gardener (now in `jobs/doin/`).

---

## Completion report — `scholar-ingest-cask-3` (cask library ingest, cycle 4)

**What I did:** Wore the scholar role and continued the `kriskowal/cask` `doc/design/` library ingest. Worked read-only against a scratch clone of `kriskowal/cask@main` and wrote to `journal/library/` on `journal2` from an isolated `git worktree add --detach origin/journal2` (per the cycle-3 working note). All five target docs still shared file-commit `cdb975d8` (2026-02-14); idempotency-checked each — none were previously ingested.

**Sources ingested — 5 docs, 19 sections** (each with a `sources/cask--<slug>.md` index):
- `gc-and-retention.md` → 3 (the two retention regimes: pinned-roots hash-trie vs deadline min-heap)
- `gc-concurrent-design.md` → 3 (snapshot GC + mandatory quarantine; the 7 invariants; the test plan)
- `store-gc-design.md` → 4 (store-wrapper + cask/set mark/sweep; missing-link / insertion-order discipline; root-set self-retention)
- `dbstore-design.md` → 5 (caskdbstore flat-file store; on-disk alloc + Robin-Hood hashmap; flock+WAL concurrency; WAL-quarantine GC)
- `cryptography.md` → 4 (the Option A PSK / Option B one-way-DH "minimal proposal")

**Concepts:** Added the new **`gc-quarantine-store`** concept the job asked for — it unifies all four GC-family docs (snapshot-mark-sweep + install-after-store + write quarantine, realized as the in-memory `collectorstore`/`diskcollectorstore` wrappers and caskdbstore's WAL quarantine). Updated `swap-to-end-allocation` (the on-disk `alloc` file), `content-addressed-block-store` (caskdbstore), and `noise-ik-session-establishment` (cryptography.md cross-links).

**Reconciliation (cryptography.md ↔ net-crypto.md):** Kept cryptography.md `status: current` and flagged it as the **design predecessor** — Option A is the origin of the now-superseded PSK handshake; Option B (DH) is the direction net-crypto.md realizes as the authoritative Noise IK handshake. Added bidirectional `notes:` lineage links and updated the `cask--net-crypto` source index's stale "deferred to follow-on" note to point at the ingested sections.

**Indexes updated:** `sources/README.md` (+5 rows), `topics/README.md` (content-addressed-storage 15→30, networking 14→18, data-structures→33 after a union with a concurrent ingest, testing 19→20), the 4 touched topic pages, `concepts/README.md`, and `keywords.md` (~70 lines, union-appended).

**Push:** CAS-pushed to `journal2` (commit `e556ac7c`). Hit and resolved the expected race conflicts — `keywords.md` as a union append, and `topics/README.md`'s data-structures count by taking the concurrent ingest's new base (32) and re-applying my +1. Verified clean on origin (no markers; concept file present).

**Follow-ups:** Posted **`scholar-ingest-cask-4`** naming exactly what remains — `trace2.md` first (full cycle: ingest + supersede the `cask--trace` sketch + re-audit `codel-send-buffer-shedding`), then the cell/entry family (`cell-capabilities.md` is the 35 KB largest), the protocol family (`protocol.md`/`protocol2*.md`), the data-structure design family, and the comment-fragment clusters. It has already been claimed by another gardener (now in `jobs/doin/`).

**Job state:** `scholar-ingest-cask-3` completed (doin → tada). Isolated worktree and scratch clone cleaned up.

Self-improvement: the isolated-worktree + union-merge-keywords discipline from cycle 3 held; I extended it with a count-conflict resolution recipe (take the other side's new base count, re-apply your delta) and a lineage-vs-supersession distinction (predecessor→realization gets `status: current` + bidirectional `notes:`, not a supersession flip) — both carried verbatim into the cask-4 follow-on note so the pattern keeps propagating.
