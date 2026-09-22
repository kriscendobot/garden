All work is complete and verified. Here is my report.

---

## Completion report: Build hashline edit phase-2 + demonstration tests (endojs/endo-but-for-bots #256)

**Opened DRAFT PR: [endojs/endo-but-for-bots#1327](https://github.com/endojs/endo-but-for-bots/pull/1327)** — a linked implementation PR stacked on a **pinned frozen base** (`llm-c36b4249`, a snapshot of #256's head that carries the Phase-1 skeleton), so the review diff is only the Phase-2 work. Cross-referenced on #256 ([comment](https://github.com/endojs/endo-but-for-bots/pull/256#issuecomment-5770143634)).

### What I built (addresses every DoD item)

1. **Phase-2 splice** — `packages/daemon/src/hashline.js` no longer throws; it's now a pure, dependency-free module (CRC32 + SHA-256 implemented in-module so agent/daemon anchors agree byte-for-byte and it ports to XS): `splitLines`/`joinLines` (byte-preserving trailing-newline + CRLF-on-content), `computeLineHash` (CRC32, ws/CR normalization, blank-line seeding, 2/4-char width), `computeFileHash` (SHA-256 CAS), envelope/textual/JSON validators, `validateAnchors` (both widths), `applyPatch` (bottom-up splice with the insert-after > insert-before > replace/delete tiebreaker). Wired into `EndoMount.edit` (`mount.js`) running read → 16 MiB cap → SHA-256 CAS → per-line anchors → splice → write under a **per-mount-instance serial lock** (shared with sub-mounts/attenuations), returning the full `EditResult` taxonomy; mode bits preserved via truncate-and-rewrite; EACCES→`permission-denied`, EROFS/EIO/ENOSPC propagate. Added interface guards + `HashlineView` type.

2. **Unit tests** — 33 pure (`test/hashline.test.js`) + 11 mount-level over a real filesystem (`test/hashline-mount.test.js`): CAS success/conflict, `hash-mismatch`, CRLF round-trip, empty/absent, `patch-syntax`, read-only, **mode-bit preservation**, **over-cap**, **concurrent-edit serialization**. Verified load-bearing per regression-evidence (neutralizing CAS + anchor validation fails exactly the CAS/hash-mismatch/concurrency tests).

3. **Integration test through the guest surface** — 2 tests in `test/endo.test.js`: a guest holds a mount by name and, via its own surface, `readTextHashline`s a doc for attribution then `edit`s it with hashline commands (edit lands on disk); plus a stale-read CAS-rejection test. Confirmed passing through the full daemon + CapTP (booted via a short-path workaround, since this worktree's path exceeds the 104-char UNIX-socket limit — an environment limitation that fails *all* `endo.test.js` tests identically, not my code).

4. **grep/glorp** — none exist in this repo (`git grep glorp` empty; no daemon grep verb). The equivalent per-line anchor attribution is provided additively by the new `EndoMount.readTextHashline`; documented in the PR body with evidence.

### Gates
- eslint: **0 errors** (file-level `no-bitwise` disable for the hash algorithms, matching `envelope.js`/`base64`/`zip` precedent); prettier clean; `tsc` clean except one **pre-existing** `@libp2p/kad-dht` dependency-types error unrelated to my changes.
- `pre-push-gates.sh`: **pass (6 stages)**.
- 44 pure+mount tests pass; 2 guest tests pass.

### Named follow-ups (coherent slice per DoD item 1)
Reapply relocation (design Open Q#5 — option accepted, behaves as strict pending algorithm confirmation), `EndoGuest.edit` sugar, the CLI `endo edit` wrapper + secondary formats (Phase 3), and multi-file `editBatch` (Phase 4).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr256-hashline-phase2-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 236 tokens (20412650 cached reads)
- Output: 108083 tokens
- Cost: $15.39627299999999
- Wall-clock: 1836s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
