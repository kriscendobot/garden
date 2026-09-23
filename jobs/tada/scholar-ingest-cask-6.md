Cycle complete. Report follows.

---

# scholar-ingest-cask-6 (cask cycle 7) — completion report

**What I did:** Ingested the cask `doc/design/` corpus's largest document, `cell-capabilities.md` (906 lines, "Entry Type Capabilities"), as a full cycle on its own, continuing the cell/entry lineage after `cells.md` and `cells-and-entries.md`.

**Idempotency:** The file sits at the corpus-wide file-commit `cdb975d8` (file-modified 2026-02-17, Kris Kowal), not previously ingested. Read read-only from a sparse scratch clone of `kriskowal/cask@main`.

**Sources ingested:** 1 (`cell-capabilities.md` → 11 sections):
overview-and-background, information-hiding-and-honest-attenuations, cas-couples-read-and-write, entry-type-is-the-capability, cell-path-descriptor-format, blob-and-directory-types, cell-types-direct-and-indirect, content-model-changes, command-vocabulary-and-examples, relationship-to-capability-map, implementation-plan-and-open-questions.

**Concepts added:** 2
- `cask-entry-type-capability` — the directory entry *type* as ocap facet; information hiding (transparent content hash vs opaque cell ID/descriptor) fixes honest attenuations; write-implies-read (CAS) makes read-only the only direction; the nine types, the attenuation lattice, `cask mkroot`/`typeof`.
- `cask-cell-path-descriptor` — the indirect-reference Merkle tree (cell ID as first-leaf link + CBOR path; link-not-CBOR for GC retention).

**Lineage judgment:** Lineage, not supersession, as directed. The doc's *Relationship to the Capability Map* section is the hinge — entry types are the structural+local capability layer, `cells.md`/`ocaps.md`'s capability tokens are the cryptographic+network layer, and they compose as an intersection. All three docs kept co-`current` with bidirectional cross-links to `cask-cell-bank` and `cask-named-typed-pointer`. No `status:` flips.

**Indexes updated:** `sources/README.md` (+1), `topics/content-addressed-storage.md` (+8), `topics/capability-security.md` (+9), `topics/data-structures.md` (+2), `concepts/README.md` (+2), `keywords.md` (+26). `sections/README.md` left untouched per prior cask-cycle convention.

**Pushed:** all library writes + the `result` entry CAS-pushed to `journal2` (commit `093a76d3`, confirmed in history). Job completed `doin → tada` (`jobs/tada/scholar-ingest-cask-6.md`).

**Follow-up:** posted `scholar-ingest-cask-7` (next pick: `ocaps.md` 385 lines + `caskroot-design.md` 193 lines, completing the capability-token/network half of the model) — already claimed by another gardener (now in `jobs/doin/`).

**Self-improvement:** nothing structural. Two sandbox notes carried into the follow-on: `gh repo clone --no-checkout` failed to init `.git/config` here, so `git clone --no-checkout --filter=blob:none` is the reliable sparse-scratch recipe; and check the `git push` exit code directly rather than piping through `tail`, which masks a `remote rejected`.
