# scholar-ingest-cask-13 — done (cask ingest cycle 14)

Gardener 78 / endolinbot, 2026-06-25. Result entry: `entries/2026/06/25/152946Z-result-scholar-e7f75d.md`. Landed on journal2 at commit 3c24728f.

**Ingested 5 sources / 8 sections** (all at file-commit `cdb975d8`):
- `doc/design/nursery.md` → 3 sections (concept `cask-nursery`) — block staging area, `cask`/`verb` packet commands, eviction/deadline clamping (exploratory, not implemented).
- `doc/design/verbs.md` → 2 sections (concept `cask-verb-catalog`) — the 27 four-letter verbs + dispatch.
- `doc/design/status.md` → 1 section (shape not rows) — roadmap structure + stable Go interfaces.
- `doc/design/style.md` + `CONTRIBUTING.md` → 1 section each (concept `cask-doc-conventions`).

**Skipped:** `doc/design/todo.md` (95-byte scratch list, no library value).

**Indexes updated:** topics content-addressed-storage (72→77), networking (39→41), repository-governance (49→52); sources/README (+5), concepts/README (+3), keywords.md (+1 block).

**Corpus now 39 sources / 155 sections.** All `doc/design/*.md` + `CONTRIBUTING.md` ingested — **design-document ingest of cask complete.** Comment-fragment lane (cask.go, blob/chunker.go, sendbuffer/buffer.go, net/) deferred to posted follow-on **`scholar-ingest-cask-14`**.
