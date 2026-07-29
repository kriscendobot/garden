# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-07-29 (evening UTC), refreshed from the API. **295 open** (was 300 on
07-28, 256 on 07-16); 158 draft, 52 changes-requested, 109 conflicting; **7 merged since the
prior snapshot**. Read "Awaiting your decision" first — it is the only section that cannot
advance without you — then "Review now", then the per-arc state._

## Awaiting your decision

Work that is **finished or green and cannot move without a maintainer act**. This is
the shortest path from held work to landed work.

### The npm-CAS gap-draft stack — 8 green PRs, 6 still held as drafts

Every one is **MERGEABLE and 24/24 green**. Two were marked ready for review since the
prior snapshot; the remaining six are held deliberately, not stuck.

| PR | Subject | State |
| --- | --- | --- |
| [`#857`](https://github.com/endojs/endo-but-for-bots/pull/857) | peer/optional dependencies | draft |
| [`#859`](https://github.com/endojs/endo-but-for-bots/pull/859) | endow archive compartments (process shim) | draft |
| [`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) | `.npmrc` basic auth + `${VAR}` expansion | **ready for review** since 07-29 |
| [`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) | workspace-protocol resolution | draft |
| [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) | package `imports` field (`#`-prefixed) | **ready for review** since 07-29 |
| [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) | `endor run --conditions` flag | draft — blocked on policy question below |
| [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) | dual-build npm packages | draft |
| [`#878`](https://github.com/endojs/endo-but-for-bots/pull/878) | WHATWG `URL`/`URLSearchParams` endowment | draft |

**Three pairwise ordering constraints** — in each pair the PR that lands **second**
takes a rebase:

- [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) / [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) — both touch `EXPORTS_RESOLVER_JS`
- [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) / [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) — both touch `__archiveEndowments`
- [`#857`](https://github.com/endojs/endo-but-for-bots/pull/857) / [`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) — the adaptation must be folded into whichever lands later; **which
  one absorbs it is an open maintainer call**

**Blocking policy question:** [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) needs the **default-condition-set** decision —
browser-by-default vs opt-in vs node-shims. It also governs the remaining web-global
gaps (`crypto.subtle`, streaming/`fatal` `TextDecoder` fidelity, `encodeInto`), so it
gates more than one PR. A design note on the `node:crypto`/webcrypto case has been
commissioned to inform it.

### Approved — one merge away

- [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) — EndoRegistry capability + `@registry` special
  name. **Approved 07-29** (was changes-requested in the prior snapshot), 26/26 green,
  MERGEABLE. Landing it unblocks more of the npm-CAS stack's shared plumbing.

### Approvals pending

- [`#869`](https://github.com/endojs/endo-but-for-bots/pull/869) — complete except for
  **one approval** (22/22 green). The fleet will not self-approve.
- The rest of the green dependabot/chore set is equally one-click:
  [`#870`](https://github.com/endojs/endo-but-for-bots/pull/870) 22/22,
  [`#868`](https://github.com/endojs/endo-but-for-bots/pull/868) 24/24,
  [`#880`](https://github.com/endojs/endo-but-for-bots/pull/880) 22/22 (form-data floor),
  [`#848`](https://github.com/endojs/endo-but-for-bots/pull/848) 22/22 (Pi 0.81.1),
  [`#558`](https://github.com/endojs/endo-but-for-bots/pull/558) / [`#556`](https://github.com/endojs/endo-but-for-bots/pull/556) 22/22 (action bumps).
- [`#867`](https://github.com/endojs/endo-but-for-bots/pull/867) 25/25 **returned to draft** since the
  prior snapshot (was listed here as one-click); no longer approval-ready.

### One-vs-other decisions still unresolved

- [`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) hardened URL
  `%URL%`/`%SharedURL%` split (changes-requested, 15/15) **vs**
  [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263) universal-intrinsic URL
  (clean 18/18, no review). Close one in favour of the other; carried unresolved across
  two snapshots now. (The sibling universal-intrinsics PR
  [`#259`](https://github.com/endojs/endo-but-for-bots/pull/259), TextEncoder/TextDecoder, closed 07-29 —
  fully merged upstream via [endojs/endo#3322](https://github.com/endojs/endo/pull/3322), nothing remained.)
- [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) Docker on the frozen
  `master` lane (15/15) vs the remote-gateway line in
  [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694). Also carried.

## Review now (cross-arc priority queue)

**The prior snapshot's queue was consumed.** Of the nine entries on the 07-28 list, six
resolved on 07-29: [`#708`](https://github.com/endojs/endo-but-for-bots/pull/708), [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707), [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) (approved),
and [`#669`](https://github.com/endojs/endo-but-for-bots/pull/669) **merged**; [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) closed as subsumed by
[`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) (maintainer directive, verified artifact-by-artifact); [`#259`](https://github.com/endojs/endo-but-for-bots/pull/259)
closed as fully merged upstream. The twelve-day starvation signal from the prior snapshot
is answered; what remains in the queue is below.

1. [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) — `EndoMount.glorp` fused glob+grep (now also subsumes the closed [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) mount grep). 24/24. _(vfs-parity)_
2. [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) — Docker self-hosting with authenticated remote gateway (M3). 23/23. (Also one half of the [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608)-vs decision above.)
3. [`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) — mount `deniedSegments` via `--deny`/`--no-deny`. 23/23. _(vfs-parity)_
4. [`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) / [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) — newly non-draft members of the npm-CAS stack (24/24 each); see the ordering constraints there.
5. [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) — endor-run dependency walk. **Rebased and green again** — was CONFLICTING in the prior snapshot, now MERGEABLE 26/26.

Also green and non-draft, carried from the prior snapshot unreviewed:
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) unbounded stream buffer 23/23,
[`#856`](https://github.com/endojs/endo-but-for-bots/pull/856) ESM entry disambiguation 24/24,
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent collection stores 21/21,
[`#723`](https://github.com/endojs/endo-but-for-bots/pull/723) `@endo/fetch` confined outbound HTTP 24/24,
[`#760`](https://github.com/endojs/endo-but-for-bots/pull/760) Cap'n Web RPC 15/15,
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics caching 15/15,
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star export 15/15,
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere pin in eval fixture 22/22.

**Regressed since 07-28 — no longer review-ready:**
[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) `provideSubMount` (Phase 4) is now **CONFLICTING** (24/24 green)
— it needs a rebase, most plausibly over [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657), which merged underneath it
on 07-29. [`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) attenuated Sheets facets is now **CONFLICTING** with one
failing check (`cover`, 22/23). [`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) xs2rust traded its conflict for a
failing `lint` check (23/24). [`#867`](https://github.com/endojs/endo-but-for-bots/pull/867) went back to draft (above).

## Arcs in progress

### OCapN-over-Noise ([kriscendobot/garden#49](https://github.com/kriscendobot/garden/issues/49)) — **first maintainer review landed**
The stack stays fully green, and it is no longer unreviewed:
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) WS+Noise received a **changes-requested review on 07-29** (23/23 green) —
the arc's first maintainer pass — and [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) transport (25/25) has been **marked
ready for review** (non-draft). The crossed-hello race fix
[`#806`](https://github.com/endojs/endo-but-for-bots/pull/806) merged 07-26.
- [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) transport 25/25 **non-draft** · [`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) two-peer demo 25/25 draft · [`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) WS+Noise 23/23 draft, changes-requested · [`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) forked two-daemon M5 23/23 draft · [`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) cross-host Pet-Daemon M5 23/23 draft.
- M1–M5 are demonstrated including pure-CLI cross-host invite/accept. The remaining
  work is **review, revision on [`#684`](https://github.com/endojs/endo-but-for-bots/pull/684), and un-draft**, not engineering.

### npm-via-CAS registry proxy ([kriscendobot/garden#56](https://github.com/kriscendobot/garden/issues/56))
The gap stack above is this arc's live edge; the arc is **review-blocked, not
build-blocked** — the stack can reach the finish line as-is.
- **Landed since the prior snapshot:** [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) daemon `@registry` host name
  (**merged 07-29** — was CONFLICTING + changes-requested). Its landing releases the
  parked `registry-immutable-byte-array-followup`.
- **Approved, awaiting merge:** [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) EndoRegistry (26/26) — see above.
- **Merged earlier in the window:** [`#862`](https://github.com/endojs/endo-but-for-bots/pull/862) registry maintenance CLI (07-27), [`#854`](https://github.com/endojs/endo-but-for-bots/pull/854) CJS named-export synthesis, [`#821`](https://github.com/endojs/endo-but-for-bots/pull/821) entry-rejection message.

### Passable byte arrays ([kriscendobot/garden#48](https://github.com/kriscendobot/garden/issues/48))
- [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) passable byte arrays — changes-requested, 15/15 green. Address review.
- [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) narrow byteArray to frozen `Uint8Array` — changes-requested, 17/17.
- The shared registry dependency [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) is **resolved** — it merged 07-29
  (the prior snapshot's "gone conflicting" note no longer applies).

### Git integration + endor bindings ([kriscendobot/garden#52](https://github.com/kriscendobot/garden/issues/52))
- **The review-now pair landed:** [`#708`](https://github.com/endojs/endo-but-for-bots/pull/708) content-address QID/hash and [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707)
  capability-based workspace provisioning both **merged 07-29**.
- [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) remote push tier also **merged 07-29** — its changes-requested
  regression (flagged in the prior snapshot) was addressed.
- [`#691`](https://github.com/endojs/endo-but-for-bots/pull/691) accept/sequence the git-capability stack remains open, non-draft, 5/5.
- [`#740`](https://github.com/endojs/endo-but-for-bots/pull/740) in-process Git CAS bindings **merged** 07-26.

### VFS tool-call parity ([kriscendobot/garden#53](https://github.com/kriscendobot/garden/issues/53))
The [`#127`](https://github.com/endojs/endo-but-for-bots/pull/127) mount split is converging:
[`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) mount JSON **merged 07-29** (approved); [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) mount grep **closed 07-29**,
subsumed by [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713). Still review-ready: [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) (24/24) and
[`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) (23/23). [`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) went CONFLICTING and needs a rebase before it
rejoins them.

### SturdyRef system ([kriscendobot/garden#47](https://github.com/kriscendobot/garden/issues/47))
Unchanged in shape: bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698), [`#700`](https://github.com/endojs/endo-but-for-bots/pull/700), [`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) remain clean drafts; [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) and the agent provide/accept designs [`#695`](https://github.com/endojs/endo-but-for-bots/pull/695)/[`#697`](https://github.com/endojs/endo-but-for-bots/pull/697) need revision.

### Daemon data plane ([kriscendobot/garden#50](https://github.com/kriscendobot/garden/issues/50))
Correcting the prior snapshot: [`#585`](https://github.com/endojs/endo-but-for-bots/pull/585) content-store powers **merged 07-21** and
[`#739`](https://github.com/endojs/endo-but-for-bots/pull/739) store-drives-writeFile design **merged 07-17** — both were listed as
unchanged/open but had already landed before 07-28. [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) streaming mount
search design remains draft, changes-requested (5/5). [`#786`](https://github.com/endojs/endo-but-for-bots/pull/786) thixotrope OCapN
orthogonal persistence merged 07-25.

### Endor xs2rust ([kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51))
[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) still draft. It is **no longer CONFLICTING**, but CI is now 23/24 with the
`lint` check failing — the press driver rebases-on-dirty; no review action until it
surfaces a bar. The garden-side `xs2rust-endor-press` job family is repeatedly
poisoning (see below).

### Google Sheets
[`#874`](https://github.com/endojs/endo-but-for-bots/pull/874) portable Sheets client remains a **green draft** (24/24).
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) attenuated Sheets facets **regressed** — now CONFLICTING with the
`cover` check failing (22/23). Two thin follow-on layers (`SheetsService`,
`SpreadsheetStructure`) are designed but unbuilt, deliberately deferred until these land.

## Blocked on the garden, not on review

A distinct class: PRs whose CI is green and whose review is not the obstacle, but whose
**gauntlet cannot complete** because the job exceeds the fleet's claim-scoped handler
budget (default 2400s; the ceiling is bounded by
`GARDEN_HANDLER_TIMEOUT + KILL_AFTER < GARDEN_CLAIM_TTL`).

On 2026-07-28 this poisoned gauntlet/review/panel jobs for
[`#874`](https://github.com/endojs/endo-but-for-bots/pull/874), [`#881`](https://github.com/endojs/endo-but-for-bots/pull/881), [`#848`](https://github.com/endojs/endo-but-for-bots/pull/848), [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705),
[`#867`](https://github.com/endojs/endo-but-for-bots/pull/867), [`#755`](https://github.com/endojs/endo-but-for-bots/pull/755), plus the finbot panel series and several
garden-internal jobs. Since then [`#755`](https://github.com/endojs/endo-but-for-bots/pull/755) and [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) have landed and
[`#867`](https://github.com/endojs/endo-but-for-bots/pull/867) went back to draft — but the poisoning itself continues (the journal
carries a fresh requeue-exhausted poison notice from 07-29).

**Do not read these as review-stalled.** They need the garden's staged-gauntlet work
(`split-gauntlet-into-claim-sized-stages`), not maintainer attention.

## Newly landed since the prior snapshot

**7 merged since 2026-07-28 (evening), all on 07-29:**
[`#708`](https://github.com/endojs/endo-but-for-bots/pull/708) content-address QID/hash in `@endo/exo-git`,
[`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) capability-based workspace provisioning + worked VCS loop,
[`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) git remote push tier with force-with-lease,
[`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) daemon `@registry` host name,
[`#669`](https://github.com/endojs/endo-but-for-bots/pull/669) Pi-compatible JSONL transcript projection,
[`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) mount JSON read/write,
[`#169`](https://github.com/endojs/endo-but-for-bots/pull/169) pass-style promise design.

Also closed 07-29 without merging: [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) (subsumed by [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713)) and
[`#259`](https://github.com/endojs/endo-but-for-bots/pull/259) (fully merged upstream via [endojs/endo#3322](https://github.com/endojs/endo/pull/3322)).

Landed earlier in the 07-16→07-28 window (carried from the prior snapshot for context):
[`#755`](https://github.com/endojs/endo-but-for-bots/pull/755) `@endo/cbor` canonical CBOR primitives phase 1 (07-28),
[`#862`](https://github.com/endojs/endo-but-for-bots/pull/862) endor registry maintenance CLI,
[`#806`](https://github.com/endojs/endo-but-for-bots/pull/806) crossed-hello SYN fix,
[`#786`](https://github.com/endojs/endo-but-for-bots/pull/786) thixotrope OCapN orthogonal persistence,
[`#777`](https://github.com/endojs/endo-but-for-bots/pull/777) iroh 1.0 QUIC netlayer,
[`#854`](https://github.com/endojs/endo-but-for-bots/pull/854) CJS named-export synthesis,
[`#850`](https://github.com/endojs/endo-but-for-bots/pull/850) floot × Claude Code CLI sandbox,
[`#740`](https://github.com/endojs/endo-but-for-bots/pull/740) in-process Git CAS bindings design,
[`#585`](https://github.com/endojs/endo-but-for-bots/pull/585) content-store powers,
[`#739`](https://github.com/endojs/endo-but-for-bots/pull/739) store-drives-writeFile design.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17) —
still open, MERGEABLE, no review. Larger runners for the resource-heavy multichain legs,
make them non-required on the fork, or a dedicated infra-tuning pass.

dckc's [kriscendobot/garden#67](https://github.com/kriscendobot/garden/issues/67)
(two agoric-sdk follow-ups: ERC4626/Morpho vault registration for Ymax, and an
attestation drill-down) is now **closed as completed** (07-28) — the go/no-go this
section was waiting on is resolved. (Link corrected: the issue lives in
`kriscendobot/garden`; the prior snapshot's `kriskowal/garden` text redirects there.)
Upstream `agoric/agoric-sdk` stays comment-and-link-free.

## Scope

**295 open pull requests.** This is the curated maintainer sequence for current
milestone/arc work and garden-unblocking edges, not an assertion that the remaining long
tail is review-ready. The headline this refresh: **the queue moved.** Six of the nine
review-now entries from 07-28 landed or closed within a day, the OCapN stack received its
first maintainer review, and the shared registry PR [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) is approved and one
merge away. The live bottleneck is now the held npm-CAS promotion decision (six drafts
plus the [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) condition-set policy question) and the two long-carried
either/or calls ([`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) vs [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263), [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) vs [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694)).
