Done. All work landed on `journal2` and the job is completed.

## Completion report

**Job `scholar-ingest-cask-13` (cask library ingest, cycle 14) — complete.** Landed on `journal2` at commit `3c24728f`; result entry `entries/2026/06/25/152946Z-result-scholar-e7f75d.md`.

**Sources ingested — 5 sources / 8 sections** (all at file-commit `cdb975d8`, idempotency-checked against `origin/journal2` first; none previously ingested):
- `doc/design/nursery.md` → 3 sections, new concept **`cask-nursery`** — the exploratory block-staging / deferred-write design (packet-TTL vs command-TTL), the proposed `cask`/`verb` packet commands + CBOR body, tempstore/recvbuffer consolidation, three eviction approaches, deadline clamping. Filed under content-addressed-storage + networking.
- `doc/design/verbs.md` → 2 sections, new concept **`cask-verb-catalog`** — the four-letter verb vocabulary (10 reads + 17 reduces, 27 total) over a 32-byte root hash, plus dispatch via out-of-band mode + in-band schema designators. Consolidated to 2 sections per the reference-doc rule.
- `doc/design/status.md` → 1 section — captured as **shape, not rows** (the Implemented/In Progress/Planned structure, casknet/casksock opcode lists, the stable Go interface set), live inventory deferred to upstream.
- `doc/design/style.md` + repo-root `CONTRIBUTING.md` → 1 section each, new concept **`cask-doc-conventions`** (one-sentence-per-line wrap, tables/Mermaid, regular English plurals).

**Deliberate skip:** `doc/design/todo.md` (95-byte scratch checklist, no library value).

**Indexes updated:** content-addressed-storage (72→77), networking (39→41), repository-governance (49→52) topic pages + counts; `sources/README.md` (+5), `concepts/README.md` (+3), `keywords.md` (+1 keyword block).

**Corpus now 39 sources / 155 sections.** With this cycle, **all `doc/design/*.md` and `CONTRIBUTING.md` are ingested — the design-document ingest of cask is complete.**

**Follow-on posted:** **`scholar-ingest-cask-14`** for the remaining comment-fragment lane (`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, `net/`). It has already been claimed (now in `doin`).

**Operating note / follow-up:** the shared `/home/kris` home is concurrently mutated, and this cycle a peer process clobbered my first worktree path (`scholar-cask-c14`) mid-run by cloning cask into it. Recovered by re-creating the worktree under a uniquely-suffixed path. I folded the lesson (use host+gardener-id-suffixed worktree paths, not bare cycle-numbered ones) into the follow-on job's working note and flagged it for the scholar job template. I left the peer's clobbered directory untouched (it holds their `ebfb-pr96` work).

Self-improvement: nothing structural beyond the worktree-naming note already carried into the follow-on and result entry.
