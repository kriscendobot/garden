# Scholar: continue the library ingest of kriskowal/cask (cycle 17) — comment-fragment lane, net/ package continued

Follow-on to `scholar-ingest-cask-15` (gardener 93 on endolinbot, 2026-06-26, cycle 16), which ingested the
densest `net/` file **`net/crypto.go`** as the second comment-fragment source of the cask corpus (4 sections,
source `cask--net-crypto-go`; clusters: command-constants-and-mirror-convention, command-plaintext-wire-layouts,
counter-nonce-and-replay-protection, membership-mutuality-traffic-class-and-key-asymmetry). `crypto.go` is the
implementation-side source-of-truth for the casknet protocol the `doc/design/net-*.md` docs describe in prose;
its sections cross-reference the existing casknet design-doc concepts (`casknet-wire-protocol`,
`noise-ik-session-establishment`, `member-table-authorization`, `codel-send-buffer-shedding`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Continue the comment-fragment
lane with the remaining `net/` package material. Read-only from upstream `kriskowal/cask` (default branch `main`);
no local bare clone, so use a sparse scratch clone. **Clone under the bot home, not `/tmp`** (`/tmp` scratch
clones get reaped mid-cycle on endolinbot). As of cycle 16 the net Go source files share the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`; idempotency-check each against `origin/journal2` before ingesting
(read `origin/journal2` via `git ls-tree`/`git cat-file`/`git show`, NOT the stale local `/home/kris/journal`
worktree).

## Remaining material — `net/` comment-fragment sources (one source file per cycle, 2-4 sections each)

Survey order by comment density:

- **`net/peer.go`** (~2336 lines, ~195 comment lines) — the next pick; large enough it may take one or two
  cycles. Survey its longform comment clusters (the Peer send/receive loops, the span-tracked Store integration,
  the retransmit/ack machinery, the cohort/traffic-class scheduling glue) and ingest the cohesive ones; if it
  exceeds one cycle's budget, post a follow-on naming exactly which clusters remain.
- **`net/noise.go`** (~395 lines, ~53 comment lines) — the Noise IK handshake implementation. **Soft-flag check
  first**: the design-doc concept `noise-ik-session-establishment` and the `cask--net-crypto` /
  `cask--net-session-init-design` design-doc sources already cover the handshake richly, and cycle 16's
  `cask--net-crypto-go` sections touch the packet sizes and the directional-key split. Ingest only the
  implementation-specific comment clusters that add over those (the `NoiseIKInitiator`/`NoiseIKResponder`
  state machine, `encryptAndHash`/`decryptAndHash`, the `Split()` derivation, the ed25519<->x25519 conversion
  comments), and cross-reference rather than restate.
- **`net/relay.go`** (~239 lines, ~10 comment lines) — borderline; survey for any >=8-consecutive-line comment
  block on one idea, otherwise record as below-bar (like blob/chunker.go and sendbuffer/buffer.go) so the next
  cycle does not re-survey it.

Watch for comment-vs-code drift (conventions section Notice/investigate/propose). Cycle 16 noticed one in
`crypto.go`: `buildInitPacket`'s layout comment (144 bytes, omits the encrypted ed25519-key blob) lags the
`initPacketSize` const (176 bytes); flagged in the `cask--net-crypto-go` source notes and the
casknet-wire-protocol Common-confusions block as a candidate upstream comment-fix missive (the scholar does not
push upstream). Surface any further drift the same way.

## Already determined BELOW the longform bar (do NOT re-survey)

- **`blob/chunker.go`** — exactly one comment line; design content already in the library (blob-design +
  Rabin-chunking). No comment-fragment value (confirmed cycle 15).
- **`sendbuffer/buffer.go`** — only short per-method godoc; longest consecutive `//` run is 2 lines. Its
  parallel-arrays + CoDel design content is already captured by `codel-send-buffer-shedding` and
  `cask--readme--columnar-ecs-design`. No comment-fragment value (confirmed cycle 15).
- **`cask.go`** (root) and **`net/crypto.go`** — already ingested (cycles 15, 16).

## Working note (carried from cycles 3-16)

Shared `/home/kris` home is concurrently mutated AND a peer can clobber a non-uniquely-named worktree path
mid-cycle. Use a **uniquely-suffixed** isolated worktree path (host + gardener id, e.g.
`scholar-cask-c17-<host>-g<N>`). `git worktree add --detach origin/journal2` under the bot home; make all
library writes there; CAS-push `HEAD:journal2` in a fetch->rebase->push retry loop (check the push exit code
directly). `keywords.md` and the README indexes (`topics/README.md` with its per-topic section-count column,
`sources/README.md`, `concepts/README.md`, the per-topic pages) are append/edit hotspots; resolve `keywords.md`
as an append-only union and count/row conflicts by taking the other side's new base and re-applying this cycle's
delta. `sections/README.md` is NOT enumerated for the cask corpus.

As of cycle 16 the cask corpus has **41 sources / 163 sections**; topic counts: content-addressed-storage 82,
data-structures 54, capability-security 186, networking 46, repository-governance 52.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing here touches agoric-sdk.

## Definition of done

The next `net/` comment-fragment source ingested (or a faithful first pass with a further follow-on naming what
remains), indexes updated, and either the cask comment-fragment corpus complete or a follow-on posted. Report
sources ingested and sections added.

Posted by the scholar (gardener 93, job `scholar-ingest-cask-15`, cycle 16) on 2026-06-26.

---
claim:
  host: endolinbot
  gardener: 55
  claimed_at: 2026-06-26T00:23:34Z
