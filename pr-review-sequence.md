# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-07-28 (evening), refreshed from the API. **300 open** (was 256 on
07-16); 160 draft, 53 changes-requested, 112 conflicting; **53 merged since the prior
snapshot**. Read "Awaiting your decision" first — it is the only section that cannot
advance without you — then "Review now", then the per-arc state._

## Awaiting your decision

Work that is **finished or green and cannot move without a maintainer act**. This is
the shortest path from held work to landed work.

### The npm-CAS gap-draft stack — 8 green drafts held for promotion

Every one is **draft, MERGEABLE, 24/24 green**. They are held deliberately, not stuck.

| PR | Subject |
| --- | --- |
| [`#857`](https://github.com/endojs/endo-but-for-bots/pull/857) | peer/optional dependencies |
| [`#859`](https://github.com/endojs/endo-but-for-bots/pull/859) | endow archive compartments (process shim) |
| [`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) | `.npmrc` basic auth + `${VAR}` expansion |
| [`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) | workspace-protocol resolution |
| [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) | package `imports` field (`#`-prefixed) |
| [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) | `endor run --conditions` flag |
| [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) | dual-build npm packages |
| [`#878`](https://github.com/endojs/endo-but-for-bots/pull/878) | WHATWG `URL`/`URLSearchParams` endowment |

**Three pairwise ordering constraints** — in each pair the PR that lands **second**
takes a rebase:

- `#875` / `#876` — both touch `EXPORTS_RESOLVER_JS`
- `#876` / `#877` — both touch `__archiveEndowments`
- `#857` / `#873` — the adaptation must be folded into whichever lands later; **which
  one absorbs it is an open maintainer call**

**Blocking policy question:** `#876` needs the **default-condition-set** decision —
browser-by-default vs opt-in vs node-shims. It also governs the remaining web-global
gaps (`crypto.subtle`, streaming/`fatal` `TextDecoder` fidelity, `encodeInto`), so it
gates more than one PR. A design note on the `node:crypto`/webcrypto case has been
commissioned to inform it.

### Approvals pending

- [`#869`](https://github.com/endojs/endo-but-for-bots/pull/869) — complete except for
  **one approval** (22/22 green). The fleet will not self-approve.
- The rest of the green dependabot/chore set is equally one-click:
  [`#870`](https://github.com/endojs/endo-but-for-bots/pull/870) 22/22,
  [`#868`](https://github.com/endojs/endo-but-for-bots/pull/868) 24/24,
  [`#867`](https://github.com/endojs/endo-but-for-bots/pull/867) 23/23,
  [`#880`](https://github.com/endojs/endo-but-for-bots/pull/880) 22/22 (form-data floor),
  [`#848`](https://github.com/endojs/endo-but-for-bots/pull/848) 22/22 (Pi 0.81.1),
  [`#558`](https://github.com/endojs/endo-but-for-bots/pull/558) / [`#556`](https://github.com/endojs/endo-but-for-bots/pull/556) 22/22 (action bumps).

### One-vs-other decisions still unresolved

- [`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) hardened URL
  `%URL%`/`%SharedURL%` split (changes-requested, 15/15) **vs**
  [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263) universal-intrinsic URL
  (clean 18/18, no review). Close one in favour of the other; carried unresolved from
  the prior snapshot.
- [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) Docker on the frozen
  `master` lane (15/15) vs the remote-gateway line in
  [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694). Also carried.

## Review now (cross-arc priority queue)

**The prior snapshot's queue was not consumed.** Every entry below except `#656` was on
the 07-16 list and is still open, still green, twelve days later. Nothing has regressed;
nothing has been reviewed. That is the single clearest signal in this refresh.

1. [`#708`](https://github.com/endojs/endo-but-for-bots/pull/708) — content-address QID/hash in `@endo/exo-git`. 26/26. _(git-integration)_
2. [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) — capability-based workspace provisioning + worked VCS loop. 23/23. _(git-integration)_
3. [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) — `EndoMount.glorp` fused glob+grep. 24/24. _(vfs-parity)_
4. [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) — mount grep (PR C of #127). 23/23. _(vfs-parity)_
5. [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) — mount JSON read/write (PR D of #127). 23/23. _(vfs-parity)_
6. [`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) — `provideSubMount` (Phase 4). 24/24. **Recompute resolved — now confirmed ready.** _(vfs-parity)_
7. [`#669`](https://github.com/endojs/endo-but-for-bots/pull/669) — Pi-compatible JSONL transcript projection. 23/23.
8. [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) — Docker self-hosting with authenticated remote gateway (M3). 23/23.
9. [`#259`](https://github.com/endojs/endo-but-for-bots/pull/259) — `TextEncoder`/`TextDecoder` as universal intrinsics. 15/15.

Also newly green and non-draft since the prior snapshot:
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) unbounded stream buffer 23/23,
[`#856`](https://github.com/endojs/endo-but-for-bots/pull/856) ESM entry disambiguation 24/24,
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent collection stores 21/21,
[`#723`](https://github.com/endojs/endo-but-for-bots/pull/723) `@endo/fetch` confined outbound HTTP 24/24 (**CI now green** — was 3 failing),
[`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) mount `deniedSegments` 23/23,
[`#760`](https://github.com/endojs/endo-but-for-bots/pull/760) Cap'n Web RPC 15/15,
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics caching 15/15,
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star export 15/15,
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere pin in eval fixture 22/22.

**Regressed since 07-16 — no longer review-ready:**
[`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) git remote push tier is now
`CHANGES_REQUESTED` (24/24), and [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282)
endor-run dependency walk is now `CONFLICTING` (25/25) — needs a rebase.

## Arcs in progress

### OCapN-over-Noise (#49) — **the stack is now fully green**
The prior snapshot's blocking edge is **cleared**: `#684`, `#688`, `#693` were each
`UNSTABLE` 21/23; all three are now green. The crossed-hello race fix
[`#806`](https://github.com/endojs/endo-but-for-bots/pull/806) merged 07-26.
- [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) transport 25/25 · [`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) two-peer demo 24/24 · [`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) WS+Noise 23/23 · [`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) forked two-daemon M5 23/23 · [`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) cross-host Pet-Daemon M5 23/23.
- **All still draft.** M1–M5 are demonstrated including pure-CLI cross-host
  invite/accept. The remaining work is **maintainer review and un-draft**, not
  engineering. This arc is the largest block of finished, green, unreviewed work.

### npm-via-CAS registry proxy (#56)
The gap-draft stack above is this arc's live edge; the arc is **review-blocked, not
build-blocked** — the stack can reach the finish line as-is.
- **Merged since:** [`#862`](https://github.com/endojs/endo-but-for-bots/pull/862) registry maintenance CLI (07-27), [`#854`](https://github.com/endojs/endo-but-for-bots/pull/854) CJS named-export synthesis, [`#821`](https://github.com/endojs/endo-but-for-bots/pull/821) entry-rejection message.
- **Shared registry plumbing, still blocked:** [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) EndoRegistry (changes-requested, 25/25); [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) daemon `@registry` host name (**now CONFLICTING** + changes-requested) — landing these unblocks the parked `registry-immutable-byte-array-followup`.

### Passable byte arrays (#48)
- [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) passable byte arrays — changes-requested, 15/15 green. Address review.
- [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) narrow byteArray to frozen `Uint8Array` — changes-requested, **CI recovered to 17/17** (was 6 failing).
- Registry dependency `#671` is shared with npm-CAS and has gone conflicting.

### Git integration + endor bindings (#52)
- **Review-now:** `#708`, `#707` (above). `#691` accept/sequence the git-capability stack is non-draft and 5/5.
- [`#740`](https://github.com/endojs/endo-but-for-bots/pull/740) in-process Git CAS bindings **merged** 07-26.
- `#705` remote push tier regressed to changes-requested.

### VFS tool-call parity (#53)
`#713`, `#655`, `#657`, `#656`, `#652` all non-draft and green — the whole #127 mount
split is review-ready simultaneously. This arc has the most work sitting one review away.

### SturdyRef system (#47)
Unchanged in shape: bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698), [`#700`](https://github.com/endojs/endo-but-for-bots/pull/700), [`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) remain clean drafts; [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) and the agent provide/accept designs [`#695`](https://github.com/endojs/endo-but-for-bots/pull/695)/[`#697`](https://github.com/endojs/endo-but-for-bots/pull/697) need revision.

### Daemon data plane (#50)
[`#585`](https://github.com/endojs/endo-but-for-bots/pull/585) content-store powers, [`#739`](https://github.com/endojs/endo-but-for-bots/pull/739), [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) — unchanged. [`#786`](https://github.com/endojs/endo-but-for-bots/pull/786) thixotrope OCapN orthogonal persistence merged 07-25.

### Endor xs2rust (#51)
[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) still draft and **CONFLICTING** (24/24). The press driver rebases-on-dirty; no review action until it surfaces a bar. Note the garden-side `xs2rust-endor-press` job family is repeatedly poisoning (see below).

### Google Sheets (new since prior snapshot)
[`#874`](https://github.com/endojs/endo-but-for-bots/pull/874) portable Sheets client (24/24) and
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) attenuated Sheets facets (23/23) —
both **green drafts**. Two thin follow-on layers (`SheetsService`, `SpreadsheetStructure`)
are designed but unbuilt, deliberately deferred until these land.

## Blocked on the garden, not on review

A distinct class: PRs whose CI is green and whose review is not the obstacle, but whose
**gauntlet cannot complete** because the job exceeds the fleet's claim-scoped handler
budget (default 2400s; the ceiling is bounded by
`GARDEN_HANDLER_TIMEOUT + KILL_AFTER < GARDEN_CLAIM_TTL`).

On 2026-07-28 this poisoned gauntlet/review/panel jobs for **#874, #881, #848, #705,
#867, #755 (first attempt)**, plus the finbot panel series and several garden-internal
jobs. `#755` landed only because a re-dispatch at `handler-timeout: 14000` finished with
minutes to spare; `endo-sturdyref-agent-surface-build-gauntlet` had the *same* budget and
poisoned anyway.

**Do not read these as review-stalled.** They need the garden's staged-gauntlet work
(`split-gauntlet-into-claim-sized-stages`), not maintainer attention.

## Newly landed since the prior snapshot

**53 merged since 2026-07-16.** Most notable:
[`#755`](https://github.com/endojs/endo-but-for-bots/pull/755) `@endo/cbor` canonical CBOR primitives phase 1 (**merged 07-28**),
[`#862`](https://github.com/endojs/endo-but-for-bots/pull/862) endor registry maintenance CLI,
[`#806`](https://github.com/endojs/endo-but-for-bots/pull/806) crossed-hello SYN fix (unblocked the whole OCapN stack),
[`#786`](https://github.com/endojs/endo-but-for-bots/pull/786) thixotrope OCapN orthogonal persistence,
[`#777`](https://github.com/endojs/endo-but-for-bots/pull/777) iroh 1.0 QUIC netlayer,
[`#854`](https://github.com/endojs/endo-but-for-bots/pull/854) CJS named-export synthesis,
[`#850`](https://github.com/endojs/endo-but-for-bots/pull/850) floot × Claude Code CLI sandbox,
[`#740`](https://github.com/endojs/endo-but-for-bots/pull/740) in-process Git CAS bindings design.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17) —
unchanged and still open. Larger runners for the resource-heavy multichain legs, make
them non-required on the fork, or a dedicated infra-tuning pass.

Separately, dckc's [kriskowal/garden#67](https://github.com/kriscendobot/garden/issues/67)
proposes two agoric-sdk follow-ups (ERC4626/Morpho vault registration for Ymax: a phase-0
fork PR, and an attestation drill-down). Fork experimentation is pre-authorized; upstream
`agoric/agoric-sdk` stays comment-and-link-free. Awaiting a go/no-go.

## Scope

**300 open pull requests.** This is the curated maintainer sequence for current
milestone/arc work and garden-unblocking edges, not an assertion that the remaining long
tail is review-ready. The headline this refresh: **the review queue is not the
bottleneck's cause — it is the bottleneck.** Nine PRs carried over unreviewed for twelve
days, the OCapN stack went fully green with no reviewer, and eight npm-CAS drafts sit
finished awaiting promotion decisions.
