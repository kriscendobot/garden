The comment is posted. The job is complete.

## Completion report

**Task:** Answer @kumavis on kriskowal/garden#51 — the heap-snapshot-format and diffability question — grounded in the actual engine work, not generalities.

**What I did:**
- Traced the question to the endor XS→Rust engine port (PR endojs/endo-but-for-bots#600, branch `xs2rust-endor-engine`), fetched it into an isolated project worktree, and read the authoritative source: the `rust/engine/endor-snapshot` crate (`format.rs`, `atom.rs`, `image.rs`, `slot_codec.rs`, `sidetable.rs`), the `endor-vm` arena code (`value.rs` `SlotArena`/`ChunkArena`), and the `designs/xs2rust-endor-engine.md` § Snapshots + `designs/daemon-xs-worker-snapshot.md` design docs.
- Drafted and posted a technically-grounded reply as the bot, addressed to @kumavis: https://github.com/kriskowal/garden/issues/51#issuecomment-5024047118

**Substance of the answer:**
1. **Format:** a length-prefixed big-endian FourCC atom container (`XS_M` over `VERS SIGN CREA BLOC HEAP STAC KEYS NAME SYMB METR RELM`), same grammar as `xsSnapshot.c` with an `ENDR` discriminator; `HEAP` is a flat array of fixed 20-byte index-arena slot records, `BLOC` the length-headered chunk arena. Because the heap is already index-based, the writer is a *serializer, not a relocator* → byte-deterministic, position-independent, SHA-256 content-addressed.
2. **Diffs:** practical/dense for **temporal checkpoints of one live worker between GC compactions** (indices/free-list preserved → unchanged objects re-serialize identically); **not** efficient for **cross-run dedup** without a canonicalization pass, because GC free-list LIFO reuse + chunk slide-compaction make index/offset assignment history-dependent. No delta layer exists yet.
3. **Caveats named:** the side-table coverage ledger marks most rich state (Promises, Generators, TypedArrays, Proxies, Modules, Compartments…) `Pending`, so real-workload diff density is unmeasured; and what would settle it — finish the pending atoms, add a canonical heap walk if cross-run dedup is wanted, then measure.

**Changes to repos:** none committed (research/answer job; the draft lived only in the throwaway worktree). No follow-ups outstanding. Inbox was empty throughout.
