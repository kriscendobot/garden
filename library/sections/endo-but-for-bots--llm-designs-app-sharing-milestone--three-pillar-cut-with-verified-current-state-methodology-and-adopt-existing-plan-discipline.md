---
section: three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
source: endo-but-for-bots--llm-designs-app-sharing-milestone
topics: [daemon, agent-conventions, chat-ui]
status: current
---

# Three-pillar cut with verified-current-state methodology and adopt-existing-plan discipline

> *It is a cut, not a new bucket of unrelated work: it pulls
> forward and sequences slices that already live across
> Milestones 1–3, and adds three new design docs for the
> genuinely-missing connective tissue. The point is to reach
> an end-to-end "make a thing, send it to a friend, they run
> it" experience sooner than the linear M1→M2→M3 march would
> deliver it.*
>
> — `designs/app-sharing-milestone.md` §What is the Problem Being Solved

`app-sharing-milestone.md` (256 lines, *Proposed* status,
created 2026-06-01) is a **milestone design** by Aaron
*(prompted)* — third Aaron-authored design after cycle 143's
familiar-app-ui-hosting (Aaron's second authored design in the
library). This is a *coordination document*, not a primary
spec: it sequences existing slices and identifies *connective
tissue*.

## The §single most structurally interesting move — §milestone-not-bucket

The opening framing is explicit:

> *It is a cut, not a new bucket of unrelated work.*

The §milestone-not-bucket discipline distinguishes:

- **Bucket**: a category of related work items, tracked
  together because they share a theme.
- **Cut**: a *slice across multiple categories* selected to
  produce a shippable end-to-end experience.

The §end-to-end-make-a-thing-send-it-run-it framing is the
*product narrative* that makes the cut coherent. The cut
isn't *all of M1*, isn't *all of M2*, isn't *all of M3* — it
takes the *slice of each* needed for *one demonstrable
flow*.

The §coordination-doc-not-spec posture: this document
*doesn't* design new features (mostly). It *names which
features to do first, in what order, and what they compose
to*. Three new designs (`familiar-deep-link-invitations` +
`endo-app-sharing` + `familiar-app-ui-hosting`) carry the
*genuinely-missing connective tissue*; everything else is
either Complete or actively in flight.

## The §three-pillar enumeration

The cut's three pillars name the *user-experienced surfaces*:

1. **Distribute the chat app as a downloadable.** A real
   installer users can run without developer warnings.
2. **Connect to peers via a deep-link URL.** Click a link →
   confirmation screen → name the peer → bound.
3. **Make and share runnable apps.** Apps backed by an
   endo-fs source + endo-fs-exec, optionally cloneable, with
   partially-sandboxed UI.

The §user-experience-as-pillar-anchor discipline: pillars are
defined by *what the user does* (download, click, share), not
by what the engineering team builds. This forces the spec to
*end at the user's experience*, not at the last engineering
artifact produced.

## The §verified-current-state methodology

Each pillar's section opens with §verified-current-state —
*what's already shipped*. The audit precedes the gap analysis:

> *The substrate is far along; most pillars are connective
> tissue and UX over shipped primitives.*

The §audit-before-spec discipline. The §3-paragraph-form for
each pillar:

1. What's already Complete (with file paths + PR refs).
2. The single missing piece (with the design that owns it).
3. Optional: related in-flight work to reconcile against.

The §file-path-and-PR-citation density is striking — the
document reads as a *live map* of the codebase + tracker, not
a freestanding spec. The §map-the-territory-then-the-route
discipline.

## The §Pillar-1-adopts-familiar-release.md discipline

The most structurally interesting *governance* move:

> *This pillar is already an active workstream — defer to it,
> do not restate. The gap analysis and release plan live in
> `familiar-release.md` (PR #231)...*
>
> *This milestone adopts `familiar-release.md`'s plan for
> Pillar 1 rather than offering a competing one.*

The §adopt-existing-plan-don't-compete-with-it discipline.
This document *refuses* to re-spec what another design owns.
The §two-designs-must-not-define-the-same-thing-twice
invariant: if Pillar 1 has an owner-design, this milestone
defers; it doesn't *re-enumerate* the sixteen gaps G1-G16, it
*cites* them.

The §named-deferral move: the document explicitly names what
it's *not* covering and where to look. Readers can follow the
trail to `familiar-release.md` (PR #231) for the actual
release plan; this milestone provides *only* the framing that
ties Pillar 1 to Pillars 2 and 3.

The §macOS-arm64-first MVR scope (inherited from
`familiar-release.md`):

> *...importantly — scopes the MVR to macOS arm64 only (the
> maintainer's primary platform), deferring Linux/Windows to
> followups.*

The §narrow-MVR-scope discipline: rather than ship-everywhere-
or-don't-ship, the plan ships *first* on the maintainer's
primary platform. Linux/Windows are explicitly *MVR
followups*, not blockers. The §maintainer-platform-first
ordering.

The §swarm-of-G-item-PRs catalog (lines 67-79) lists ten
named PRs implementing specific G-items: CI build pipeline
(G1, PR #318), arm64+x64 matrix (G15, #321), icon projection
(G7, #319), Node LTS pin (G5, #316), stop/purge (G8, #320),
LICENSE aggregation (G14, #323), Primer-CAS smoke (G16,
#324), Flatpak (#322), telemetry (#317), packaging lanes
(#360). The §workstream-already-in-flight observation.

## The §Pillar-2-daemon-ready-shell-missing decomposition

Pillar 2 is the §peer-deep-link mechanism. The §three-Complete
+ §one-Missing structure:

- **Complete**: Locator format + `host.invite(name)` +
  `host.accept(locator, petName)` (`packages/daemon/src/
  locator.js` + `host.js`) — accept parses, registers via
  `addPeerInfo`, binds a pet name.
- **Complete**: OCapN-Noise transport (PR #137).
- **Complete**: Familiar registers privileged custom scheme
  `localhttp://` — *a working template* for the planned
  `endo://`.
- **Missing**: `endo://` deep-link capture in the shell, a
  confirmation screen, and a naming prompt → owned by
  `familiar-deep-link-invitations.md`.

The §template-for-the-missing-piece observation:
`localhttp://` registration *already works* in Familiar; the
new scheme is the *same pattern applied to `endo://`*. The
§similar-shape-as-precedent discipline reduces design risk.

## The §Pillar-3-run-and-serialise-exist-transfer-and-UI-missing decomposition

Pillar 3 is the *richest pillar*. §two-Complete-and-two-
Missing:

- **Complete**: `@endo/endo-fs` Filesystem caps + FsBackend
  seam; `@endo/endo-fs-exec` `tree-view-module.js` →
  `make-from-tree` formula → compartment-mapped
  `make(powers, context, { env }) => exo`. **This is the run
  mechanism.**
- **Complete**: `readable-tree` / `readable-blob` formulas;
  `endo checkin` / `endo checkout` (tree ⇄ fs, zip via
  `-z`). Per-app origin isolation + CSP in Familiar.
- **Missing**: An app handle bundling source + exec + UI.
- **Missing**: Cross-daemon clone (remote-ref vs independent
  copy, shipped as one streamed tree-archive into a pluggable
  durable backing).
- **Missing**: The app-facing partially-sandboxed UI layer.

The three missing pieces are owned by the §new designs
[endo-app-sharing](endo-app-sharing.md),
[familiar-app-ui-hosting](familiar-app-ui-hosting.md)
(= cycle 143's design), and the underlying weblet-hosting
substrate (familiar-unified-weblet-server / familiar-chat-
weblet-hosting / daemon-weblet-application).

## The §reconcile-don't-duplicate posture for in-flight work

Pillar 3's *Related in-flight work* paragraph (lines 119-128)
names *parallel-angle* designs that must be *reconciled*, not
duplicated:

- `familiar-run-apps-vfs.md` (PR #241) — *a different angle
  on running apps from a VFS*, using `endor` + `Mount` caps +
  sqlite module store.
- exo-zip / exo-unzip (PR #160) — durable zip backing for
  clones.
- exo-stream (PR #330) — the streaming substrate the clone
  tree-stream rides.
- daemon git-tree `archive` (PR #367) — tree-as-archive prior
  art.

The §reconcile-don't-duplicate discipline: rather than ignore
parallel angles or insist on one design winning, the
milestone *acknowledges* the in-flight alternatives and
*positions* this milestone's pieces relative to them.

The §parallel-substrate-acknowledgment move is the cousin of
the §adopt-existing-plan move (Pillar 1) — both recognize
that *other people are doing related work* and the milestone
must position itself with respect to that work, not pretend
it doesn't exist.

## The §four-phase plan with §explicit-exit-criteria

The Phased Plan section gives **four phases** with
*per-phase exit criteria*:

| Phase | Pillar | Exit |
|-------|--------|------|
| **P0** | 1 (installer) | non-developer downloads/installs/launches a signed/notarized Familiar on macOS arm64 without Gatekeeper warnings |
| **P1** | 2 (deep-link) | clicking `endo://invite/…` in another app opens Familiar, shows who is being added, asks for pet name, binds the peer |
| **P2** | 3a + 3b (app handle + sandboxed UI) | user runs an endo-fs/`make-from-tree` app, opens its partially-sandboxed UI in a Chat pane, and shares a remote reference to a peer who opens the same UI |
| **P3** | 3c (clone & share) | peer receiving a cloneable app chooses "Make my own copy", gets an independent local instance under their own powers, that keeps working after the author disconnects |

The §exit-criterion-per-phase discipline: each phase is *done
when the user can do the exit action*, not when some
engineering metric is satisfied. The §user-flow-as-completion-
gate.

The §P3-honors-cloneable-policy detail: *no per-blob hashing;
integrity is the transport's job*. The §transport-handles-
integrity discipline keeps clone simple — the OCapN-Noise
transport (cycle 41-49's earlier ocapn-noise-network design)
already provides cryptographic integrity at the wire layer;
the clone-protocol doesn't reinvent it.

## The §Exit-Criterion ties pillars to one flow

The unified Exit Criterion is the §end-to-end-product-
narrative:

> *A non-developer installs a signed Familiar build, clicks
> an `endo://` invite from a friend, confirms and names that
> peer, then receives a shared app — opening it either as a
> live remote reference or, when the author marked it
> cloneable, as their own independent copy — with the app's
> UI running in a partial sandbox.*

The §one-paragraph-tells-the-whole-story discipline: a
non-technical reader can understand the milestone's outcome
in one paragraph. All four phases produce *one demonstrable
flow*.

## The §Related-in-flight-PRs snapshot — §genuinely-net-new-vs-substrate

The Related in-flight PRs section closes the document with a
*20+ PR catalog* organized by pillar. The §opening-caveat
distinguishes:

> *The two genuinely net-new pieces — `endo://` deep-link
> invites and the streaming clone helper + zip-backed
> receiver — have **no** open PR; everything else below is
> substrate to reconcile against rather than re-invent.*

The §genuinely-net-new-vs-substrate distinction: most of the
catalog is *substrate-in-flight*; only two pieces are
*genuinely new work this milestone introduces*. The §minimize-
new-work-maximize-leverage observation: the milestone is
*mostly orchestration*, not invention.

## The §raw-doc-URLs-not-durable caveat

> *Note on the raw-doc URLs: they point at the PR head
> branches as they stand on 2026-06-01; if a branch is
> rebased or merged the link may move. The PR link is the
> durable anchor.*

The §raw-URLs-are-transient-PR-links-are-durable discipline.
A milestone document that *cites in-flight PRs* must
acknowledge that the cited content can move; the §two-anchor-
policy (PR link as durable; raw-doc URL as convenience)
keeps the document robust against PR head movement.

## The §Aaron-authored-design cluster

Cycle 143 ingested `familiar-app-ui-hosting.md` — the first
Aaron-authored design. This cycle's `app-sharing-milestone.md`
is **the second Aaron-authored design** ingested. The §non-
Kris-Kowal-design cluster now has three distinct attributions:

- **Kris Kowal *(prompted)*** — the dominant pattern.
- **Joshua T Corbin *(evoked)*** — cycle 137's daemon-message-
  streaming.
- **Aaron *(prompted)*** — cycle 143's familiar-app-ui-hosting
  and this cycle 151's app-sharing-milestone.

The §Aaron-authored-pair observation: both Aaron designs
touch *Pillar 3* — UI sandboxing (cycle 143) + the milestone
that coordinates Pillar 3 with the other two pillars (this).
This suggests Aaron's domain is *app-sharing + UI hosting*,
mirrored in the §three-Aaron-files locality across these
adjacent designs.

## How this design fits the broader cluster

The milestone *cites* most of the previously-ingested designs:

- **Cycle 109** (`familiar-electron-shell`) — Complete; the
  shell being distributed.
- **Cycle 110+** (`familiar-daemon-bundling`) — Complete;
  bundled daemon/Node.
- **Cycle 41-49** (`ocapn-noise-network`) — Complete; secure
  transport.
- **Cycle 60+** (`daemon-agent-network-identity`) — per-agent
  keypairs.
- **Cycle 143** (`familiar-app-ui-hosting`) — the sandboxed-
  UI layer this milestone names.
- **Cycle 145 + 147** (formula-inspector + workers-panel) —
  the daemon-observability pair that *isn't part of this
  milestone* but lives in the same Aaron-and-Kris cycle.

The §milestone-as-clustering-event observation: this single
document touches *dozens* of prior cycles' work. It's the
clearest example of the §coordination-doc-as-graph-edge role
— the design has more *outbound references* than original
content.

## Related sections

- cycle 143
  [[endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule]]
  — Aaron's other authored design (the sandboxed-UI layer
  this milestone P2 depends on).
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — sister non-Kris-Kowal design (Joshua T Corbin / jcorbin
  *evoked*).
- cycle 109
  (familiar-electron-shell) — the shell being distributed in
  Pillar 1.
- cycle 145
  [[endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal]]
  — same-week design (2026-02-14 vs this design's 2026-06-01;
  both Aaron and Kris explore the daemon's observability +
  app-sharing surface in parallel).
