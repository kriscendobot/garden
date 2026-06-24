# tada: scholar-ingest-cask-3 — cask library ingest cycle 4

Ingested 5 `kriskowal/cask` `doc/design/` docs (19 sections), all at file-commit
`cdb975d8` (2026-02-14), each idempotency-checked (none previously ingested):

- `gc-and-retention.md` → 3 sections (the two retention regimes)
- `gc-concurrent-design.md` → 3 (snapshot GC + mandatory quarantine; 7 invariants; tests)
- `store-gc-design.md` → 4 (store-wrapper + cask/set mark/sweep; missing-link discipline)
- `dbstore-design.md` → 5 (caskdbstore flat-file store; on-disk alloc+hashmap; WAL-quarantine GC)
- `cryptography.md` → 4 (the Option A PSK / Option B DH minimal proposal)

Concepts: new `gc-quarantine-store` (the GC quarantine/retention concept the job asked for;
unifies all four GC-family docs incl. the `collectorstore`/`diskcollectorstore` wrappers and
caskdbstore's WAL quarantine). Updated `swap-to-end-allocation`, `content-addressed-block-store`,
`noise-ik-session-establishment`.

Reconciliation: `cryptography.md` kept `status: current` and flagged as the **design predecessor**
of `net-crypto.md` (Option A → superseded PSK handshake; Option B/DH → realized as Noise IK), with
bidirectional `notes:` lineage links; updated the `cask--net-crypto` source index's stale
"deferred" note.

Indexes: `sources/README.md` (+5 rows), `topics/README.md` (content-addressed-storage→30,
networking→18, data-structures→33 after union with a concurrent ingest, testing→20), the 4 touched
topic pages, `concepts/README.md`, and `keywords.md` (~70 lines, union-appended).

Deferred (budget): `trace2.md` (+ `cask--trace` supersession + `codel-send-buffer-shedding`
re-audit), the cell/entry family, the protocol family (`protocol.md`/`protocol2*.md`), the
data-structure design family, and the comment-fragment clusters. Posted follow-on
**`scholar-ingest-cask-4`** naming exactly what remains, trace2.md first.

CAS-pushed to `journal2` from an isolated worktree (commit `e556ac7c`); resolved the expected
`keywords.md` (union) and `topics/README.md` count conflicts on rebase.
