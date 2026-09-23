# Open-PR survey — everything the garden is actively caring for

_Snapshot: 2026-09-18, rebuilt from live GitHub state. Author: gardener
(`open-pr-survey-20260918`)._

## Scope and how the set was discovered

This is **not** a census of every open pull request in every fork — it is the set
the garden is **actively caring for**, discovered rather than assumed. The method:
walk `journal/comment-repos/` and `journal/config/fork-owners` for the watched
set, intersect the live open-PR list of each repo with **PRs that had a garden
job touch them in the last ~14 days** (the real "actively caring for" signal), and
cross-check against the curated `journal/pr-review-sequence.md` arc snapshot and
the garden arc trackers (`kriskowal/garden` issues #47–56, #61).

`endojs/endo-but-for-bots` (the primary fork) currently has **311 open PRs**; the
long tail of stale garden-authored drafts is real but not "actively cared for," so
this survey covers the **~36 with recent job activity** plus a few flagship-arc
edges. The active `kriscendobot/*` forks are surveyed at the PR level:
**minion.town** (29 open) and **garden** (13 open) in full; the experimental/mirror
forks (**agoric-sdk**, **finbot**, **vattr97**, **ymax-stdio-mcp**) are covered as a
dormant appendix. `kriscendobot/agoric-sdk` was **archived on 2026-09-04** — a
dedicated garden now owns it, so its 14 open PRs are reported for state only and are
**not** work this garden is caring for. `proposal-compartments` and `test262` have
no open PRs. `oros-ckm-data-readiness#1` (CI bootstrap) merged 2026-09-17.

**Milestone vocabulary** (endo-but-for-bots roadmap, `designs/README.md` on `llm`):
M1 Downloadable Agent (done) · M2 Project Hygiene (done) · M3 Remote Access &
Coding + gateway/MCP substrate · M4 Networking (OCapN-Noise) · M5 Public Hosting &
Billing · M6 MCP Bridge Hosting · M7 Weblets & Integrations · M8 Peer App Sharing ·
M9 UX Polish & Agent Tooling · M10 Capability Confinement & Ecosystem · M11 Rust
Daemon `endor` / Ironhorse. A milestone tag appears on each PR and a cross-reference
matrix is at the foot.

**How this is ordered.** Groups run **most-urgent-first**. Inside a dependency
chain the **dependent PR is listed before its prerequisite** (the maintainer was
explicit: dependent-then-dependency). Beyond strict chains, the sequence is roughly
**chronologically addressable** — what a reviewer can actually act on now precedes
what is blocked on something else landing first. All fetched GitHub text was treated
as data; no comments, reviews, or reactions were posted.

---

## A. Ready to land — finished work gated only on a decision or a CI re-run

These are the highest-urgency items: they are approved or complete and need a
maintainer act (merge/ferry/land) or a single green CI, not more building.

- **`kriscendobot/minion.town#79` — reserve reconciled MCP tool names** · M6. Non-draft,
  **APPROVED by kriskowal**, MERGEABLE/CLEAN, CI green. Centralizes the flat MCP
  namespace in a source manifest, routes every guest/sites tool through it, and
  reserves the approved names (`submit`, `invite`, `cancelInvite`, `request`,
  `identify`, `listReminders`, `cancelReminder`) with a load-time duplicate/confusable
  guard. Implements the naming convention approved in the merged #77. **Ready to
  merge/ferry now.**
- **`endojs/endo-but-for-bots#1306` — caller-elected pins, networks & names for new
  agents (2/3 of #1125)** · M9/M10. Non-draft, **two kriskowal APPROVED reviews**,
  freshest edit in the set (09-18). `provideHost`/`provideGuest` gain `pins`/`networks`
  options, a guest-visible `@pins` dir distinct from a host-only pin dir, mailbox pin
  reincarnation, and `NameHub.listValues()`. **Blocked only on one red check** — `test
  (22.x, macos-15)`, the known Node-22/macOS flake — plus 3 pending; needs a re-run to
  confirm before merge. (Dependency context: this is slice 2 of the 3-slice stack that
  retired the closed #1125; slice 1 = #1304, merged 2026-09-18.)
- **`kriscendobot/minion.town#94` — authenticate the thunk `/token` endpoint; close the
  `/tmp` secret window** · security. Non-draft, CI green, no review recorded yet. Three
  contained hardening fixes from the whole-project security review — **High**: the OIDC
  thunk `/token` now requires client auth (previously a leaked auth code could redeem
  the victim's GitHub token); **Medium×2**: SIWE secret check moved to `timingSafeEqual`,
  and deploy scripts stop writing world-readable `/tmp` secrets. Small, contained, and
  security-relevant — **wants a fast gauntlet or a direct merge decision**.
- **`kriscendobot/minion.town#37` — design(mail): ocap mailboxes for bot accounts** · M7.
  Non-draft, **APPROVED**, MERGEABLE/CLEAN. Design of record for mail accounts as object
  capabilities (outbox/inbox/directory/admin facets over the daemon `mail.js` primitive,
  revocable recipient handles, metered router, body-free audit). Approved design doc —
  **ready to land**; it also underpins the Claude-agent reauth design (mt#96) and the
  guest-invite work.
- **`kriscendobot/garden#84` — the groom role (+ open questions)** · garden-infra.
  **APPROVED** design surface; the role brief already landed bare on `main2`. kriskowal
  approved with "address feedback and conduct, then dispatch a builder." **Awaiting the
  directed conduct + builder follow-through**, not more review. Three residual open
  questions (fold-or-mint v1 skills, per-role model pin, project-vs-garden scope).
- **`kriscendobot/garden#83` — detect & interpolate quota reset times** · garden-infra.
  **APPROVED**, base is live `main2`, tiny diff (+25/-6); design + implementation already
  on `main2` (detector, CAS ingestion, 10-assertion test). Effectively landed/closeable;
  residual open questions are non-blocking (a held 2026-09-01 reset-vs-artifact ambiguity,
  auto-release policy).
- **`kriscendobot/garden#81` — experimental pty context-introspection lane (opt-in)** ·
  garden-infra. **APPROVED**, opened at the maintainer's explicit request. A default-off
  `lane: pty` that measures the interactive-only statusLine context window per job.
  **Blocked on a merge conflict (CONFLICTING/DIRTY) — needs a rebase/weave** before it can
  land; CI also failing. Author flags honest limits (no large real-job `used_percentage`
  verified).

---

## B. Invitation & guest onboarding (minion.town web slice ⇄ Endo primitive)

The garden's near-term push: capability-first guest invite/accept on minion.town,
built on a new **guest-owned invitation primitive** in endo-but-for-bots. Per the
dependent-before-dependency rule, the **minion.town consumers come first**, their
**Endo prerequisite after**. Time-sensitive: the whole chain is gated on the Endo
primitive landing (the minion.town paths `503` until it exists).

- **`kriscendobot/minion.town#102` — guest-owned remote invitation via MCP** (author:
  **dckc**) · mail/ocap. Draft. Wires the `RemoteInviteFacet` into the guest+MCP surface
  so a minion.town guest (not the top host) mints a single-use `endo://` invitation
  redeemed by `endo accept`. Mint side works against a real daemon; **the redeem side is
  blocked by tcp-netstring caplet instability on the `pr1125` branch**, and CI `test` is
  red. Directly consumes the Endo invitation primitive below.
- **`kriscendobot/minion.town#81` — web bearer guest invite & accept workflow** · auth.
  Draft, large slice (+2955). Anonymous guest creation + bearer-authenticated
  resume/invite/accept/mail using the guest formula id as the credential; local pet-name
  exchange with no network, plus a remote path via `EndoGuest.invite().locate()` that
  **returns 503 while endo-but-for-bots#1125 is unavailable**. CONFLICTING/DIRTY — needs a
  rebase. Depends on the Endo primitive and on minion.town design #56.
- **`kriscendobot/minion.town#80` — pivot SIWE onto the invitation-only axis (design)** ·
  design. Draft, clean, no review yet. Recommends ADAPT-narrowly: SIWE moves from an
  authorization authority to an optional recovery-bond authenticator; wiring deferred until
  #56 lands. Awaiting a maintainer decision on its authorization-boundary open questions.
- **`kriscendobot/minion.town#78` — default primer readable tree for every guest (design)**
  · design. Draft, clean, untouched since creation, no review. Plans a `primer` readable
  tree endowing each guest with self-serve minion.town know-how (chiefly the clip
  static-frontend → live-backend recipe). Awaiting an initial read.
- _Endo prerequisite —_ **the guest-owned invitation primitive.** Originally
  `endojs/endo-but-for-bots#1125` ("guest-owned invitation primitive"), which was
  **closed 2026-09-18 and split into a 3-slice retirement stack**: slice 1 (read-only
  directory attenuation, **#1304, merged 09-18**), slice 2 (**#1306**, approved, in §A),
  and **slice 3 — the invitation primitive itself — still to come** (carries the combined
  tests). Until slice 3 lands, every minion.town invite consumer above stays blocked.

---

## C. Claude-on-minion.town agents (garden arc `kriskowal/garden#89`)

The seven-item arc to run a Claude agent as a confined minion.town guest. minion.town
wiring is the **dependent**; the Endo `@endo/claude` core + agent-tools + stdio-MCP
bridge are its **prerequisites**, listed after. Several designs are mid-fix-loop after a
round-6 design panel returned **must-fix**.

- **`kriscendobot/minion.town#87` — wire the Claude-agents capability behind
  `ENDO_CLAUDE_ENABLED`** · Claude-agents. Draft, CI green, CONFLICTING/DIRTY, no review.
  Ships the `@claude-account` concierge, an attenuated `@claude-agents` factory
  (never-reject sentinels), and a `submit(messageNumber, values)` verb, all flag-gated so
  absence is byte-for-byte today's deploy. **Note: design #97 corrects this build's
  unattenuated full-factory hand-off (a privilege escalation), so this build must be
  updated to match #97** — blocked on both the conflict and that reconciliation.
- **`kriscendobot/minion.town#97` — reconcile Claude-agents design to root-only endowment**
  · design. Draft, CONFLICTING/DIRTY. Narrows the endowment to the root account
  (`ENDO_CLAUDE_ROOT_SUBJECTS`, fail-closed empty) with a root-only `delegate()` minting
  attenuated sub-factories — fixing the #87 escalation. **Design panel round 6, disposition
  must-fix** (critic flags the CapTP inbox-watch spawn-trigger authority spend); in
  fix-loop plus a pending rebase.
- **`kriscendobot/minion.town#96` — credential-expiry detection & operator-mediated reauth
  (design)** · auth. Draft, clean. Turns the passive `needs-auth` drop into active
  escalation: a `usage-exhausted` sentinel splitting bad-credential from out-of-budget, an
  `@operator` binding, and a single-use 10-minute `ReauthTicket` mailed over the ocap-mailbox
  design (mt#37). **Panel round 6, must-fix** (critic questions the `usage-exhausted`
  distinction); in fix-loop.
- **`kriscendobot/minion.town#98` — design the Claude-on-minion.town end-to-end evaluation**
  · e2e-tests. Draft, clean. One shared scenario suite with two drivers (prompt-driven MCP +
  a deterministic Endo CLI/CapTP flow as the primary gate), each publishing a fresh challenge
  clip verified over plain HTTPS. **Panel round 6, must-fix**; awaiting fix-loop. Makes the
  guest-owned invitation primitive (§B) a hard dependency.
- _Endo prerequisites (endo-but-for-bots):_
  - **#1015 — `@endo/claude` confinement core** · M6. Draft, CI 26/26 green, **gap-revealing
    probe** — deliberately names its own unbuilt prerequisites (real `@endo/agent-tools`
    adapter, live confinement test, `--bare` credential path, egress attenuation) and is not
    meant to be promoted as-is. Implements the DI core per merged design #995.
  - **#1228 — finish the bare CLI caplet contract (design)** · M3. Draft, green, panel
    round 1. Refreshes `designs/endo-claude.md` against #1015 and the merged stdio-MCP bridge
    #1206; acceptance = successful local MCP invocation with built-ins denied. Arc item 4.
  - **#1226 — stdio MCP server scoped to one guest's tool surface (design)** · M6. Draft,
    **CHANGES_REQUESTED**, updated 09-17. A per-process (not per-bearer) broker resolving a
    64-hex formula id to one facet; fills the stdio gap the HTTP+OAuth MCP designs left out.
    Arc item 5; names endo-claude (#1228) as its consumer.
  - **#1227 — guest bot incarnation on mailbox delivery (design)** · M3. Draft, green, panel
    round 1. An optional `bot` binding on a guest formula + a mailbox post-commit hook that
    lazily (re)incarnates the bound bot with only the bound guest facet. Arc item 6.

---

## D. Clip publishing & the gateway content plane (minion.town)

The live weblet/clip surface. dckc is directing several of these. A recurring theme:
**most are CONFLICTING and need a rebase** before review, and the immutable-content
design (#88) is a deliberate redirection away from the in-place-upgrade line (#85).

- **`minion.town#100` — harden clip `@sites` publish (PR #69 deferred panel findings)** ·
  gateway. Draft, CONFLICTING/DIRTY, `test` red. Closes the type/test-hardening + defense-in-
  depth findings the round-7 29-seat panel deferred out of the merged #69; preserves the
  `confirmPublicBuiltIn` gate. Blocked on both conflicts and CI.
- **`minion.town#88` — immutable content, nonce-locator session, fresh-id-on-upgrade
  (design)** · gateway. Draft, clean. The "worthy first experiment" design expanding
  kriskowal's CHANGES_REQUESTED on #85: immutable clip content (unique URL cached forever),
  a formula-id-nonce CapTP session, upgrade = fresh id + redirect. **Panel round 6,
  must-fix**; in fix-loop. **Supersedes the direction of #85.**
- **`minion.town#85` — in-place front-content upgrade on the live `@sites` path** · gateway.
  Draft, **CHANGES_REQUESTED**, CONFLICTING/DIRTY. Re-points a clip's `contentRoot` while
  keeping id/hash/URL stable. Its stable-identity approach is the one #88 redirects away
  from — likely **superseded**; needs a maintainer call on whether to keep it.
- **`minion.town#93` — collect orphaned clip content (audit-by-default GC)** · gateway.
  Draft, CI green, CONFLICTING/DIRTY. Mark-and-sweep GC over the write-once content store,
  audit-only until an operator opts into `--delete`, isolated daily systemd timer. Four
  applied panel-fix rounds; **explicitly supersedes #92**. Blocked on rebase.
- **`minion.town#83` — garbage-collect the clip content store** · gateway. Draft, CI green,
  CONFLICTING/DIRTY, no maintainer review. An earlier mark-and-sweep GC rooted in the daemon
  formula graph (fails open on unreadable manifests, closed on a corrupt root set). Overlaps
  #93 — the two GC lines need de-duplicating.
- **`minion.town#84` — CLIPOMETER on real `@endo/captp` + esbuild pipeline** · gateway.
  Draft (+2577), CONFLICTING/DIRTY, self-review only. Rebuilds the CLIPOMETER browser bundle
  on real Endo libs (`@endo/captp` + eventual-send over SES) per dckc's directive, with an
  esbuild build+publish pipeline. Recently touched (09-17); needs rebase.
- **`minion.town#68` — `publishNamedContent` tool (publish a clip from guest-stored content)**
  (author: **dckc**) · gateway. Non-draft, **CHANGES_REQUESTED** despite two later kriskowal
  APPROVED reviews — outstanding kriscendobot CHANGES_REQUESTED reviews keep the aggregate red.
  CONFLICTING/DIRTY across a long thread. **Needs a rebase and reconciliation of the mixed
  review state** — a good candidate for a maintainer disposition since it is close.
- **`minion.town#86` — capability-addressed smart-HTTP git remote (increment 1)** ·
  git-remote. Draft, clean, CI green, no review, untouched since 09-03. A real HTTPS smart-Git
  remote where the capability URL is the authority and a push atomically advances served clip
  content via the CAS (implements merged design #41). Awaiting a gauntlet or stalled.

---

## E. minion.town platform: auth, deploy, billing, tests

- **`minion.town#82` — imply `mcp/guest` from `mcp/tools`** · auth. Draft, clean, CI green,
  no review. A standard MCP OAuth login now receives the caller's own guest-facet authority
  by default (token-layer widening only; least authority preserved). Awaiting an initial
  review round. Small and unblocked.
- **`minion.town#91` — default guest CLI env vars with `||`** · deploy. Non-draft, CI green,
  **CHANGES_REQUESTED** ("choose more transparent defaults"). A 10-line fix so an empty
  `GUEST_NAME=` resolves to the documented default instead of failing the wire schema. Blocked
  on a small maintainer-requested rework.
- **`minion.town#59` — document live WebSocket & pluribus TCP listeners** · deploy. Draft,
  clean, CI green, **CHANGES_REQUESTED**. Documents the two OCapN-over-Noise transports the live
  daemon exposes (wss over TLS + raw-TCP 3469). Blocked on addressing feedback.
- **`minion.town#32` — enforce & verify Endo daemon startup contract** · deploy. Non-draft on
  frozen base `main-b5bfb92`, clean, green, **CHANGES_REQUESTED**. Large B3 deploy-coherence
  refactor (+3325/-1456): daemon deploy fails unless a real CapTP round-trip completes,
  `Wants=`/`After=` ordering, supplementary-group verification. Blocked on feedback.
- **`minion.town#50` — `whoami` baseline tool** · auth. Draft, CONFLICTING/DIRTY,
  **CHANGES_REQUESTED**. A non-mutating diagnostic reporting the caller's OAuth subject/issuer/
  scopes. Blocked on feedback + rebase.
- **`minion.town#45` — provider-neutral resource ledger (billing)** · M5. Draft on frozen base
  `main-092f27e`, clean, green, **CHANGES_REQUESTED**. Large (+4129): a confined Endo
  `RequestLedger` exo with idempotent issue/transfer/reserve/settle/release/refund and an
  `@endo/ertp` integration proposal; DynamoDB client held outside confinement. Blocked on feedback.
- **`minion.town#58` — Playwright browser e2e suite** · e2e-tests. Draft, both CI jobs green,
  CONFLICTING/DIRTY, no formal review. The project's first browser tests (3 CI-safe suites vs
  in-process loopback). Needs a rebase and a review round.
- **`minion.town#95` — MCP guest-surface documentation contract (design)** · design. Draft,
  green. Synthesizes the terminal guest-surface evaluation into a documentation contract. Panel
  round 6, must-fix (critic returned comment-only should-fix). Awaiting fix-loop.
- **`minion.town#103` — dependabot: bump `@anthropic-ai/claude-code` 2.1.236→2.1.268**
  (author: **dependabot**) · deploy. Non-draft, opened 09-18, **`test` check red**. Pure dev-
  harness bump; a botanist job normally triages this. Blocked on the failing check.
- **`minion.town#101` — evaluate mecatl against the Endo ocap discipline (design)** (author:
  **kumavis**) · design. Draft, docs-only, CI green. Prices mecatl's token-engineering "bill"
  against what a CapTP reference gives free; six data-plane recommendations, explicit non-goals.
  kumavis is iterating on maintainer feedback (retracted a wrong "verbs missing" claim).

---

## F. Gateway package & hosting substrate (endo-but-for-bots, M3/M4/M5)

- **`#388` — gateway UDS bootstrap registrar + proof-of-possession (#343 phase 2)** · M4.
  Long-lived draft (opened June) on frozen base `llm-af12d7c`, **26/26 green**,
  **CHANGES_REQUESTED**. Lands the UDS/named-pipe bootstrap channel (`GatewayBootstrap`/
  `Registration` exos, 32-byte single-use PoP nonces, platform `CryptoPowers`); the socket
  listener + CapTP framing is deferred. **Stacked on #343 (phase 1)** — PRs above it rebase
  when it moves. Blocked on review resolution, not CI. _(Broader context per the arc snapshot:
  the gateway admin stack's approved #389 is stranded on a dead base, and the AWS/hosting
  designs #343/#356 remain the M5 substrate — a maintainer sequencing decision the
  review-sequence has flagged.)_

---

## G. OCapN / Noise networking (endo-but-for-bots, M4)

Arc `kriskowal/garden#49`: transport root landed; the protocol-hint implementation and its
cross-host demonstrations await repair. The **repair (#1072) is the prerequisite**; the
demos depend on it.

- **`#1072` — one hint per transport: TCP advertises a single `tcp:url`** · M4. Draft,
  **27/27 green**, **CHANGES_REQUESTED** (two recent kriskowal reviews). Collapses the TCP
  transport's `tcp:host`+`tcp:port` hints into one `tcp://host:port`, mirroring the WS
  transport. Raised by `kriscendobot/garden#58`. Blocked on maintainer review resolution.
- **`#990` — adopt the OCapN flat-argument deliver convention (`@endo/slots`)** · M4. Draft on
  frozen base `llm-a54c3ad`, **27/27 green incl. 43 Rust tests**, **CHANGES_REQUESTED**.
  Migrates `deliver` to one flat passable arg vector (replacing `[method,args]`+`__call__`),
  keeping the four-verb bus and the Rust supervisor untouched. Stacked on the slot-machine
  wire-protocol #124. Blocked on review.
- _Down-stack demonstrations (still open drafts, lower activity):_ **#684** (WebSocket+Noise
  daemon transport, MERGEABLE, CHANGES_REQUESTED), **#688** and **#693** (forked two-daemon /
  cross-host Pet-Daemon invite-accept demos, clean, 26/26 green), and **#683** (two-peer demo +
  crossed-hello, CONFLICTING). These demonstrate the transport once #1072 is resolved; per the
  arc snapshot they await the hint repair and maintainer discussion before another gauntlet.

---

## H. Daemon data plane, VFS/mount & storage capabilities (endo-but-for-bots, M3)

The largest design cluster, much of it seeded by review comments on the (now closed) #1125.
Implementations are ahead of their design reconciliations here.

- **`#1085` — streaming mount search (`streamGlob`/`streamGrep`)** · M3. Draft, **27/27 green**,
  **CHANGES_REQUESTED**, gauntlet fix round 2 active. Implements the accepted design:
  synchronous `PassableReader`s with no result cap, consumer-pull-bounded, decoupled grep. The
  most-advanced implementation in this cluster — blocked on the requested review repair, not CI.
- **`#1151` — eliminate single-segment string paths (design)** · M3. Draft, green, panel round
  1 (fix round 4 queued per the arc snapshot). Makes array-of-segments the sole path spelling
  (rejects bare-string path args at the exo boundary; glob/grep DSLs remain the flagged
  exception). Follow-up to #897 review.
- **`#1264` — daemon storage capability matrix (design)** · M3. Draft, green, CONFLICTING/DIRTY,
  panel round 1. Names every cell across data-shape × mutation-guarantee axes and makes
  `readOnly() != snapshot()` a type-level fact; proposes a backward-compatible
  `readable-* → snapshot-*` read-time alias. From a #1125 review comment. Has open questions.
- **`#1265` — mutable blob (block-storage) counterpart to readable-blob (design)** · M3. Draft,
  green. Proposes `block-storage`/`EndoBlockStorage` with separate ranged-read vs ranged-write
  powers and a `writeFileRange` primitive; bounded-overwrite/exact-append only. From a #1125
  review; naming pick is open.
- **`#1158` — portable passable databases `@endo/exo-db` (design)** · M3 (touches M5/DynamoDB).
  Draft, green. A capability-oriented DB/table abstraction for passable rows with a Node/Endor
  SQLite impl; three storage bands, ordered keys via `makeEncodePassable`, split read/write/admin
  authority. Implementation + DynamoDB adapter out of scope.
- **`#1227` — guest bot incarnation (design)** — listed in §C (arc #89 item 6).
- **`#832` — ReadableBlob `lines()` stream (design)** · M3. Non-draft, **5/5 green**,
  **CHANGES_REQUESTED**, CONFLICTING/DIRTY, multiple review rounds. A string exo stream with
  exact CR/LF/CRLF + final-unterminated-line behavior. From PR #826 review direction.
- **`#814` — mount denied-segment CLI flags (design)** · M3. Draft, green, CONFLICTING/DIRTY,
  lightly reviewed. Specifies the deferred CLI surface of #650's `deniedSegments` option; flag
  spellings are open questions. Closes issue #651.
- **`#807` — reconcile `tree(ref)` and `filesystemAt(ref)` (docs)** · M3. Draft, no CI (docs),
  CONFLICTING/DIRTY, stalest edit (08-20). Names one historical-read vocabulary across the git-
  capability corpus. Needs a rebase.

---

## I. pass-style, byte arrays & capability confinement (endo-but-for-bots, M10)

Arc `kriskowal/garden#48` (byte arrays) and the confinement-hardening line.

- **`#1099` — narrow `byteArray` to a frozen `Uint8Array`** · M10. Draft targeting **`master`**
  (upstream package set), **17/17 green**, **CHANGES_REQUESTED** (bot COMMENTED only, no
  maintainer verdict). The master-side implementation of the narrowed byte-array pass style
  (rejects mutable/subclassed/resizable/shared views); intentionally breaking, decoders-before-
  producers. **Supersedes upstream #3311.** The `llm` root (#475) already merged; this carries it
  to master.
- **`#1156` — Node-condition-gated reified-symbol variant (design)** · M10. Non-draft, 5/5 green,
  no verdict yet, panel round 2 active. A per-process `pass-style-symbol` Node resolution
  condition makes passable symbols hardened tagged objects instead of primitives, closing a
  memory-exhaustion vector (`Symbol.for` growing the global registry on untrusted decode). Wire
  format invariant. Detailed, empirically grounded.
- **`#695` — SturdyRef agent provide/accept surface (design)** · M10 (touches M4). Draft on
  frozen base `llm-387ea66`, design-only, **CHANGES_REQUESTED**, updated 09-17. A first-class
  `SturdyRef` pass-style value; the daemon holds the closely-held enlivenment cap while a confined
  worker cannot obtain the locator/formula-id/swiss number. Cross-turn retention explicitly NOT
  claimed solved. Arc `garden#47` (SturdyRef) is paused pending maintainer discussion.
- **`#891` — back-port portable `@endo/zone` (design)** · M10. Draft, 5/5 green,
  CONFLICTING/DIRTY, panel round 1. The portable allocation/collection contract `@endo/ertp`
  needs before durable state without SwingSet; API-compatible with `@agoric/zone` (one narrowing:
  `detach`). Prerequisite requested by #778 review; adapter leg deferred.

---

## J. Ironhorse / Rust engine `endor` (endo-but-for-bots, M11)

Arc `kriskowal/garden#51`. The Rust XS engine port and its test262/computron program.

- **`#1262` — intrinsic-global permits + production source bridge (W6 2D)** (author: **kumavis**)
  · M11. Draft, **36/36 green**, CONFLICTING/DIRTY, **CHANGES_REQUESTED**. Closes F144 (intrinsic-
  global attenuation seam), F160 (daemon `IronhorseSourceCompiler` so guest `eval`/`new Function`
  compile instead of aborting), and the documentary half of F033; does **not** add a `Realm` type
  (F059/F159 stay open). **Blocked on both the merge conflict and review** — the rebase is the
  first edge.
- **`#1283` — benchmark-established computron baseline regime (design)** · M11. Draft, green,
  CONFLICTING/DIRTY, no verdict. A per-load cost model `C_model(n)=coef·f(n)+b` with three derived
  gates (exact pins, growth-envelope PR gate, nightly wall-clock). Expands a maintainer directive
  on #1282's review; **revises #1282 in place, does not supersede.** Needs rebase.
- **`#996` — worker constraint model replacing the closed kind union (design)** · M11 (spans M3
  worker infra). Non-draft, 5/5 green, CONFLICTING/DIRTY, no verdict. Replaces `kind:
  'locked'|'node'` with an open multi-axis constraint (runtime incl. reserved `xs-in-rust`/#600 ·
  persistence · version · target); additive, zero persisted-formula churn. Reserves seams for
  thixotrope #786, quiescence #989, snapshot #281, retention #984. Needs rebase.

---

## K. Chat, weblets, reminders & agent tooling (endo-but-for-bots, M7/M9)

- **`#1306`** — see §A (approved).
- **`#935` — integrate `@endo/reminder` into Chat (design)** · M7. Draft, 5/5 green, ~10 review
  rounds. A reminder-courier caplet bridging the plugin's `notify` to `E(host).send('@host',…)`.
  The plugin (#721) already merged, so it no longer waits on it; only the native in-message snooze
  waits on reminder Phase 4. Deployment-ownership open questions remain.
- **`#735` — Chat HTTP controller UI (design)** · M9 (relates to M7). Draft, 5/5 green, no
  verdict. Makes the Chat Value modal a control surface for a detected `HttpClient`, with host-only
  steering. Requested in the APPROVED review of #661; primary open question is session-scoped live
  control edits.
- **`#1266` — guest-owned, creator-attenuated diagnostics (design)** · M9. Draft, green, no
  verdict. A guest `diagnostics()` attenuated to formulas that guest created (a `creator` store
  column + attribution at the `formulate` chokepoint, enforced in daemon core). From a #1125
  review; open questions for the maintainer.
- **`#1277` — invitation retention labels & pin lifecycle (design)** · M9. Draft, green,
  CONFLICTING/DIRTY. First-class retention-reason records carried through `listRetentionPaths`/
  `endo paths`/inspector, plus a host-only lifecycle surface with compare-and-remove pruning. From
  a #1125 review; needs rebase.
- **`#1260` — observe reader failures while consumers are idle (`exo-stream`)** (author: **Codex**)
  · M10. Non-draft but body says "remains draft pending investigation," zero reviews, CI green.
  Fixes an unhandled-rejection hazard when a reader iterator starts a remote request before the
  consumer pulls (repro matches a Node-22/macOS CI failure). Companion to #1259. Not yet picked up.

---

## L. SES core & Node-major hygiene (endo-but-for-bots, M2/M10)

- **`#1281` — silence lockdown intrinsics report for the WHATWG URL family** · M2 (SES core).
  Non-draft on frozen base `master-aaf9ea4`, **14/14 green**, **CHANGES_REQUESTED** (kriskowal,
  09-17). Adds explicit powerless permit exclusions for the URL family (a
  `fnWithUndeletablePrototype` permit + `inspect.custom` exclusions); finding: the report is
  identical on Node 22/24/26. Blocked on the requested changes; the upstream push is a separate
  maintainer-authorized step.
- **`#264` — compartment-mapper import-attributes propagation (design)** · M2 (module-loading
  substrate). Non-draft, 5/5 green, **CHANGES_REQUESTED**, CONFLICTING/DIRTY, the oldest PR in the
  active set (May), many review rounds. Traces `with {…}` attributes through the resolver/grapher
  into link.js. Sibling to #248 (SES surface) — meant to be reviewed as a pair. Needs rebase.
- **`#665` — release-automation notice for `.js` exports-key cleanup (design)** · M2. Draft,
  5/5 green, one panel round. A non-blocking CI notice flagging a `major` changeset for a package
  whose `exports` still carries `.js`-suffixed compat aliases. Follow-up #663 named; whichever of
  #663/#665 merges second needs a mechanical README M2-count reconcile.
- **`#666` — explode `@endo/platform` into per-dimension packages (design)** · M2. Draft,
  5/5 green, CONFLICTING/DIRTY, one panel round. Breaks the monolith into nine focused packages
  (fs/exo-fs/fs-node, CAS trio, proc) with zero-break re-export shims and a serial five-child
  orchestration. Needs rebase; un-draft is the maintainer's call.

---

## M. Garden meta-repo: design decisions awaiting the maintainer

The garden lands on `main2` directly; these PRs exist **only** because each is a design
carrying an `## Open questions` section that must be a review surface (or a review vessel).
The content is already on `main2` — each PR is an **answer surface**, blocked on a maintainer
decision, not on building. Ordered newest-first (freshest decisions on top).

- **`#102` — fully-qualified-reference enforcement lane (issue #89)** — 5 open questions
  (block-vs-warn residual, expansion form, whether to also build the committed-prose panel lane,
  same-repo bare `#nnnn` expansion, seat/role names). Newest (09-18).
- **`#100` — mirror operator-directed host state into the maintainer inbox** — 5 open questions;
  motivated by the 2026-09-17 oros-studio 13.5h-invisible-drain incident.
- **`#98` — legacy `host.registry` migration for the minion.town daemon revival** — 3 open
  questions (registry URL for migrated hosts, open the upstream endo-but-for-bots PR now vs after,
  whether pin `0eb88836` is still the right revival target given a 1317-commit gap). **Do not touch
  the live daemon.**
- **`#95` — re-export deprecation policy gate** — 5 open questions (barrel/index exemption,
  deprecation form, LLM-seat-vs-probe, Endo-only vs universal, type-only re-exports). Machinery
  @erights asked for on endo-but-for-bots #475.
- **`#88` — scaffolding-prefix caching + reaper session-summarization handoff** — the only
  all-green garden PR; headline finding: garden scaffolding is **not** prompt-cache-shared across
  jobs and structurally can't be as plumbed. 5 open questions.
- **`#86` — PR completion receipts** — per-PR cost/effort receipts + a maintainer-review-effort
  heuristic; open questions on the MRE constants and hourly rate. A follow-up build is parked
  blocked_on this.
- **`#85` — make gauntlet invocation explicit** — already reflected in CLAUDE.md's manual-gauntlet
  regime; 2 decisions (may an explicit `merge #N` bypass the gauntlet; alert-only vs force-to-draft
  on readiness drift).
- **`#82` — a Fable release supervisor (deterministic gates, human-only ferry)** —
  **CHANGES_REQUESTED**; revised head narrowed scope to minion.town and rooted approval in a
  recorded proxy delegation. The initial minion.town release-criteria predicate set is the open
  question. Blocked on re-review.
- **`#75` — American-English spelling seat + americanizer role** — **CHANGES_REQUESTED**, oldest
  in the batch; the design has since largely shipped (CLAUDE.md documents the orthographer seat +
  search-gated americanizer). Blocked on re-review to confirm the shipped search-gated form answers
  the feedback.
- **`#28` — main2 review vessel (feedback only, do not merge)** — a standing +286943/-4497 review
  surface for all of `main2`; CONFLICTING/DIRTY by design, never merges, no decision owed. Tracks
  `main2` as it grows (updated 09-18).

(`#84`, `#83`, `#81` are APPROVED and appear in §A.)

---

## N. Dormant & archived forks (state only — not active garden work)

- **`kriscendobot/agoric-sdk` (14 open) — ARCHIVED 2026-09-04.** A dedicated garden now owns this
  fork; no review or execution decision belongs to this garden. State for the record: the freshest
  are design surfaces **#18** (ERC-4626 vaults via ymax creatorFacet, commented 09-04) and **#10**
  (beans-v2 deflation, CHANGES_REQUESTED, touched 09-04, michaelfig+kriskowal thread). **#15**
  (portfolio exo guards) is clean/green awaiting a final pass. Two carry explicit maintainer
  dispositions: **#2** ("Please close") and **#1** (re-ferried upstream, spent). The xsnap/Moddable
  mirror line (**#11/#12/#13**) and the sqlite-migration pair (**#3/#4**) are stale, several
  CONFLICTING; **#8** (chain-info regen) and **#17** (fork CI off Depot) are stale housekeeping.
- **`kriscendobot/finbot` (3 open) — dormant experimental repo (arc `garden#54`).** All untouched
  since 2026-08-01, clean/green. **#7** (harness README sync) is a mergeable doc PR awaiting only a
  merge; **#6** (forecast data-sufficiency gate, +5089) and **#5** (inference-driven OBSERVE
  dispatch) are fork-original feature spikes awaiting promotion out of draft.
- **`kriscendobot/vattr97#1` — OpenCollective⟷ERTP integration (design of record)** · dormant.
  A fork-internal review home (garden#26); §8 open questions awaiting dckc. No upstream target.
- **`kriscendobot/ymax-stdio-mcp#1` — guarded PinchTab recording spike** · dormant. A
  review-surface for an already-landed 187-line spike (garden#57); awaiting line-by-line
  annotations that haven't come.

---

## Milestone cross-reference matrix

| Milestone | Surveyed open PRs |
|---|---|
| **M2 Project Hygiene** (done as a milestone; residual PRs) | ebfb #264, #665, #666, #1281 |
| **M3 Remote Access & Coding / gateway & MCP substrate** | ebfb #909, #1085, #1151, #1158, #1227, #1228, #1264, #1265, #832, #814, #807; mt#86 (git-remote) |
| **M4 Networking (OCapN-Noise)** | ebfb #388, #990, #1072, #683/#684/#688/#693 |
| **M5 Public Hosting & Billing** | ebfb #343/#356 line (via #388); mt#45 (ledger), mt#32 (deploy) |
| **M6 MCP Bridge Hosting** | ebfb #1015, #1226, #1228; mt#79 |
| **M7 Weblets & Integrations** | ebfb #935; mt#37, and the minion.town clip/gateway plane (mt#100/#93/#88/#85/#84/#83/#68) |
| **M8 Peer App Sharing** | ebfb #1157 (indelible registry); the invitation chain (mt#102/#81/#80/#78 + Endo #1125 slices) |
| **M9 UX Polish & Agent Tooling** | ebfb #1306, #735, #1266, #1277; mt#50 |
| **M10 Confinement & Ecosystem** | ebfb #1099, #1156, #695, #891, #1260 |
| **M11 Rust Daemon / Ironhorse** | ebfb #1262, #1283, #996 |
| **Garden infra** (own meta-repo) | garden #102/#100/#98/#95/#88/#86/#85/#84/#83/#82/#81/#75/#28 |
| **Cross-cutting / security** | mt#94, mt#82, mt#91, mt#59, mt#95, mt#98, mt#96, mt#97, mt#87 |

_Milestone tags are best-fit; several design PRs legitimately span two milestones and are
noted inline. M1 is complete. Arc-tracker cross-reference: SturdyRef `garden#47`, byte arrays
`#48`, OCapN-Noise `#49`, daemon data plane `#50`, Ironhorse `#51`, git integration `#52`,
VFS parity `#53`, finbot `#54`, npm-CAS registry `#56`, Compartments `#61`, Claude-on-minion.town
arc `#89`._
