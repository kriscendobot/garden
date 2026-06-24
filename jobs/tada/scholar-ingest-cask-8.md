The follow-on `scholar-ingest-cask-9` was posted and a gardener has already claimed it (it's in `jobs/doin/` with a live worktree and inbox) — expected job-board behavior. Everything landed. Final report:

---

# scholar-ingest-cask-8 → cask library ingest cycle 9 complete

Wore the **scholar** role and ingested the cask `doc/design/` **protocol family** off `origin/journal2` (the local `/home/kris/journal` worktree was stale — showed only 4 cask sources where origin had 19, so I worked the whole cycle in an isolated `git worktree --detach origin/journal2` and CAS-pushed). All three files share commit `cdb975d8…`; none were previously ingested.

## Sources ingested (3 docs, 7 sections)

- **`protocol.md`** (casksock, the plaintext local `cask/sock` protocol) → **3 sections, `current`**: transport + twelve-command inventory; byte-exact `stor`/`load`/`ackn` layouts + the 1024-byte body + 12-byte metadata footer block; store/load flow, reliable retransmit, RTT-bounded `ackn` batching, CoDel pacing, priority-boosted ACKs, local-socket security.
- **`protocol2.md`** (CASK Network Protocol v2) → **3 sections, `superseded`**. Supersession was unambiguous: the document **self-declares "SUPERSEDED" and was never implemented** (the shipped system uses casksock + Noise-IK casknet). Retained as the historical record and lineage origin of two shipped ideas — the Layer 0-4 vision (→ `architecture.md`) and the dual trace+priority **cohort** field (→ TrafficClass/Priority). Sections: changes-from-v1/layered-vision, message-and-block-framing (60-byte header, 1026-byte depth+type+payload block — neither shipped), session-span-cohort-model.
- **`protocol2-arch.md`** (the design brief that requested v2) → **1 section, `superseded`**: fixed-offset framing, TTL-as-relay-deadline, and the prompt that named "cohort".

## Concepts (2 new)
- **`casksock-local-protocol`** — the current local plaintext protocol; sibling of `casknet-wire-protocol`.
- **`cask-protocol-v2-abandoned`** — the never-built v2 + its brief, with a *Common confusions* note distinguishing cask's cohort field from Endo's `cohort-destruction` (also cross-noted on the `cohort-destruction` page).

## Indexes updated
`topics/networking.md` +7 (→28), `topics/content-addressed-storage.md` +2 block-format rows (→40), both counts bumped in `topics/README.md`; `sources/README.md` +3; `concepts/README.md` +2; `keywords.md` +19. (`sections/README.md` is not enumerated for the cask corpus, per cycles 3–8.)

## Outcome
Committed and CAS-pushed to `journal2` (first-attempt clean push, `ed7b9dc1`). Job completed (`doin → tada`). Follow-on **`scholar-ingest-cask-9`** posted for the ~17 remaining `doc/design/` docs (the data-structure cluster, the **dir v1-vs-v2 supersession judgment**, `status`/`style`/`todo`, and the comment-fragment sources) — already claimed by another gardener. Scratch clone and isolated worktree cleaned up.

Self-improvement: nothing this time. The cycle-7/8 working note held exactly; the self-declared-SUPERSEDED header made the supersession call the cleanest possible case, needing no new convention.
