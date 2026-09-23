The follow-on `scholar-ingest-cask-3` was posted and already claimed by another gardener (now in `doin`), and my completion `tada(scholar-ingest-cask-2)` is on origin. Everything landed. Done.

---

**Completion report**

I continued the `kriskowal/cask` library ingest (cycle 3) as the scholar, working in an isolated `git worktree` off `origin/journal2` to avoid the shared journal worktree's concurrent-mutation races. Pushed as commit `4e2fb6f9` (38 files, +1280 lines).

**Sources ingested — 4 docs → 18 sections** (all at commit `cdb975d8`, all fresh, no idempotency skips):
- `package-taxonomy.md` → 5 sections
- `net-crypto.md` → 6 sections (the authoritative casknet crypto doc)
- `net-session-init-design.md` → 5 sections (4 current, 1 superseded)
- `net-design.md` → 2 sections

**The job's key deliverable — the PSK-vs-Noise-IK reconciliation — is RESOLVED.** `net-crypto.md` proved to be the current design (Noise IK, x25519 ephemeral DH, forward secrecy, ed25519 + member-table auth) and explicitly calls the PSK + BLAKE2b form "the previous PSK-based design." I re-audited the `noise-ik-session-establishment` concept (rewrote the abstract to Noise-IK-current, added the new sections, replaced the deferred Common-confusions block with a dated "Resolved" note), marked `psk-handshake-packet-formats` `status: superseded` with reciprocal `supersedes:` on the net-crypto handshake section, and refined the prior cycle's architecture Layer-1 note.

**Concepts:** added `casknet-wire-protocol`, `member-table-authorization`, `cask-block-backbones`; extended `codel-send-buffer-shedding`, `cask-reducer-pattern`, `parallel-arrays-columnar`.

**Indexes:** updated `sources/README.md`, `concepts/README.md`, `keywords.md` (deduped 2 lines that collided with a prior cycle), and four topic pages.

**Follow-on:** posted `scholar-ingest-cask-3` naming the remaining corpus (GC family, dbstore, protocol family + cryptography.md, trace2, the cell/entry family, the data-structure design family, status/CONTRIBUTING/style, and comment-fragment clusters) — already claimed by another gardener.

**Notes:** a `git commit --amend` segfaulted once mid-conflict-resolution but left only a dangling object; the push landed cleanly (verified on origin: all files present, `superseded` flag set, keywords marker-free and deduped). Job is in `tada`, `doin` cleared, scratch clone and isolated worktree torn down.
