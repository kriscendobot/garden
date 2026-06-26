# Scholar: continue the library ingest of kriskowal/cask (cycle 18) — comment-fragment lane, net/ package continued

Follow-on to `scholar-ingest-cask-16` (gardener 55 on endolinbot, 2026-06-26, cycle 17), which ingested four cohesive
Peer-side comment clusters from the largest `net/` file, **`net/peer.go`** (source `cask--net-peer-go`; sections:
command-request-span-lifecycle, rtt-estimation-and-retransmission-timeout, traffic-class-send-queue-drain-prioritization,
session-renewal-single-flight) and added the new concept `casknet-rtt-and-retransmission-timeout`. `peer.go` is large
(~2336 lines / ~195 comment lines) so cycle 17 took the first faithful pass and deferred the rest here.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Continue the comment-fragment lane with
the remaining `net/` material. Read-only from upstream `kriskowal/cask` (default branch `main`); no local bare clone, so
use a sparse scratch clone **under the bot home, not `/tmp`** (`/tmp` scratch clones get reaped mid-cycle on endolinbot).
As of cycle 17 the net Go source files still share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`;
idempotency-check each against `origin/journal2` before ingesting (read `origin/journal2` via `git ls-tree`/`git cat-file`/
`git show`, NOT the stale local `/home/kris/journal` worktree). NOTE: the library lives at top-level `library/` on
`journal2` (not `journal/library/`).

## Remaining material

- **`net/peer.go` remaining clusters** (source `cask--net-peer-go` already exists at commit `cdb975d8`; ADD sections with
  new section files, do not rewrite the existing four). The Server side and a few Peer clusters were deferred:
  - The `Server` receive loop (`Start`/`handle`) and `handleEncrypted` dispatch (decrypt → update peer address for
    mobility → dispatch on inner command).
  - The responder-side `handleInit` (lines ~1727-1824): the ed25519↔x25519 **consistency check** (the ed25519 key must
    convert to the x25519 key the Noise handshake revealed), the member-table **authorization gate** (`statusNotAuthorized`),
    and the responder-side mutual `MemberAdd`. This is the responder counterpart to cycle 17's
    `cask--net-peer-go--session-renewal-single-flight` (which covered the initiator side); cross-reference it.
  - The encrypted-acknowledge batching (`noteEncryptedAcknowledge` / `flushEncryptedAcknowledgesLocked`, grouped by
    session ID with average-holdback computation).
  When `cask--net-peer-go` gains sections, bump its `section_count` and add the new rows to its Sections table; the
  idempotency anchor is unchanged so this is an in-place extension of an existing source, not a re-ingest.
- **`net/noise.go`** (~395 lines, ~53 comment lines) — the Noise IK handshake implementation. **Soft-flag check first**:
  the concept `noise-ik-session-establishment` and the `cask--net-crypto` / `cask--net-session-init-design` design-doc
  sources already cover the handshake richly, and cycles 16-17 touched packet sizes, directional-key split, and the
  initiator/responder orchestration. Ingest only the implementation-specific clusters that add over those (the
  `NoiseIKInitiator`/`NoiseIKResponder` state machine, `encryptAndHash`/`decryptAndHash`, the `Split()` derivation, the
  ed25519↔x25519 conversion comments); cross-reference rather than restate.
- **`net/relay.go`** (~239 lines, ~10 comment lines) — borderline; survey for any >=8-consecutive-line comment block on
  one idea, otherwise record as below-bar (like blob/chunker.go and sendbuffer/buffer.go) so the next cycle does not
  re-survey it.

Watch for comment-vs-code drift (conventions Notice/investigate/propose). Two pre-existing items carried, not new drift:
the cycle-16 `buildInitPacket` 144B-vs-176B layout-comment lag (candidate upstream comment-fix missive, recorded in
`cask--net-crypto-go`), and the explicit TODO in `handleInit` hardcoding `DefaultBestTrafficClass` (a known unfinished
feature, not stale comment). Surface any further drift the same way. The scholar does not push upstream.

## Already determined BELOW the longform bar (do NOT re-survey)

- **`blob/chunker.go`** — one comment line; design content already in the library (confirmed cycle 15).
- **`sendbuffer/buffer.go`** — only short per-method godoc; longest `//` run is 2 lines (confirmed cycle 15).
- **`cask.go`** (root, cycle 15), **`net/crypto.go`** (cycle 16), and the four cycle-17 `net/peer.go` clusters — already ingested.

## Working note (carried from cycles 3-17)

Shared `/home/kris` home is concurrently mutated AND a peer can clobber a non-uniquely-named worktree path mid-cycle. Use a
**uniquely-suffixed** isolated worktree path (host + gardener id, e.g. `scholar-cask-c18-<host>-g<N>`). `git worktree add
--detach origin/journal2` under the bot home; make all library writes there; CAS-push `HEAD:journal2` in a
fetch->rebase->push retry loop (check the push exit code directly). `keywords.md` and the README indexes (`topics/README.md`
with its per-topic section-count column, `sources/README.md`, `concepts/README.md`, the per-topic pages) are append/edit
hotspots; resolve `keywords.md` as an append-only union and count/row conflicts by taking the other side's new base and
re-applying this cycle's delta. `sections/README.md` is NOT enumerated for the cask corpus.

As of cycle 17 the cask corpus has **42 sources / 167 sections**; topic counts: content-addressed-storage 83,
data-structures 54, capability-security 187, networking 50, repository-governance 52.

## Bounds

Read-only on the upstream; all writes to top-level `library/` on `journal2`. Nothing here touches agoric-sdk.

## Definition of done

The remaining `net/peer.go` Server-side clusters ingested (extending the existing `cask--net-peer-go` source), `net/noise.go`
ingested or soft-flagged as below-the-add-bar, `net/relay.go` surveyed and recorded (ingested or below-bar), indexes updated,
and either the cask comment-fragment corpus complete or a follow-on posted. Report sources/sections added.

Posted by the scholar (gardener 55, job `scholar-ingest-cask-16`, cycle 17) on 2026-06-26.
