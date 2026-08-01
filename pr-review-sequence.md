# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-08-01 (15:20 UTC), refreshed from the API. **286 open** (was 295 on
07-29, 300 on 07-28, 256 on 07-16); 154 draft, 51 changes-requested; **16 merged since the
prior snapshot** — the largest landing window yet. Read "Awaiting your decision" first — it
is the only section that cannot advance without you — then "Review now", then the per-arc
state._

_Mergeability caveat: GitHub computes `mergeable` lazily, and 154 of the 286 open PRs
report `UNKNOWN` in a bulk scan. The conflict counts below are **floors** drawn from PRs
this refresh probed individually, not a full census. The 07-29 snapshot's "109 conflicting"
and this one's numbers are not comparable._

## Awaiting your decision

Work that is **finished or green and cannot move without a maintainer act**. This is
the shortest path from held work to landed work.

### Five approved PRs are one merge away

This is the highest-yield section of the document. Every one is APPROVED and MERGEABLE.

| PR | Subject | CI | Note |
| --- | --- | --- | --- |
| [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) | OCapN-Noise daemon transport | 25/25 | **Approved at the current head** `83f55ea93`; non-draft. Unblocks the whole OCapN arc. |
| [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) | EndoRegistry capability + `@registry` | 24/24 | Approved 07-29; **carried unmerged for three days**. |
| [`#836`](https://github.com/endojs/endo-but-for-bots/pull/836) | platform-neutral `@endo/sha256` | 23/23 | Approved — but on the **frozen base** `llm-bfc91f5`; see the succession note below. |
| [`#621`](https://github.com/endojs/endo-but-for-bots/pull/621) | endoclaw-oauth connector credential | 5/9 | Approved; on **frozen base** `llm-28dffa9`. The 4 non-green checks are `CANCELLED`, not failing — an artifact of the frozen base. Gates Phase-3 OAuth implementation. |
| [`#89`](https://github.com/endojs/endo-but-for-bots/pull/89) | genie-integration design | 4/4 | Approved; long-carried (last touched 07-10). |

**`@endo/sha256` succession — needs a call.** [`#836`](https://github.com/endojs/endo-but-for-bots/pull/836) is
approved but frozen-based; [`#903`](https://github.com/endojs/endo-but-for-bots/pull/903)
("platform-neutral SHA-256, unblocking the XS daemon", 25/25, base `llm`) is its live-base
successor and is currently **CONFLICTING**. Decide which one lands: rebase-and-merge the
approved [`#836`](https://github.com/endojs/endo-but-for-bots/pull/836), or review
[`#903`](https://github.com/endojs/endo-but-for-bots/pull/903) and close the other.

### The compartment-mapper redirect — an architecture ruling that gates four PRs

**New since the prior snapshot, and now the npm-CAS arc's binding constraint.** On 07-29
you left the same review on two PRs **two minutes apart**:

- [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) (23:54) — _"Please consider solving this problem in JS using the compartment mapper rather than duplicating the logic in Rust."_
- [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) (23:56) — _"defer as much of this logic to the existing JavaScript implementation in compartment-mapper rather than duplicating it in Rust."_

That is a coordinated cross-PR direction, not a per-PR nit. What investigation established:

- `endor run` resolves subpath exports/imports **at run time**, via hand-written JS embedded
  in Rust string constants (`EXPORTS_RESOLVER_JS`/`CJS_RUNTIME_JS` in `archive.rs`,
  `__matchExports`/`__resolveImports`/`__matchSubpathMap`) eval'd into the XS machine.
- `@endo/compartment-mapper` resolves the same things **at map-build time** and bakes
  concrete `{compartment, module}` edges into the map — a mapper-produced map needs no
  runtime resolver at all.
- endor's assembly (`assemble.rs`) is **pure Rust and never runs the mapper JS**. Satisfying
  the review means assembly emits a mapper-resolved map and the embedded resolver is
  deleted — which implicates the **already-merged** exports ([`#802`](https://github.com/endojs/endo-but-for-bots/pull/802))
  and CJS-require ([`#818`](https://github.com/endojs/endo-but-for-bots/pull/818)) work, not just these two PRs.
- endor's own design doc (`endor-npm-registry-proxy.md:397-406`) **originally envisioned an
  XS-hosted compartment mapper**; the shipped code diverged. The review reads as realigning
  with the original intent.
- It also runs **against** the xs2rust-endor direction of moving logic *into* Rust.

**Three options, as put by the two gardeners that examined it independently:**

1. **Full realignment** — design endor consuming a mapper-resolved map (run compartment-mapper
   under embedded XS at assembly), retire the runtime resolver, fold [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875)/[`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) into it. Large, cross-cutting, reopens merged work.
2. **Dismiss the change request** — if the runtime resolver must stay for thin-map/CAS-determinism
   reasons, land [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875)/[`#876`](https://github.com/endojs/endo-but-for-bots/pull/876) as focused features.
3. **Narrow** — keep runtime resolution but vendor compartment-mapper's `pattern-replacement.js`
   verbatim into the embedded runtime, so subpath-pattern logic is shared rather than
   reimplemented. Partial answer; smallest change.

Nothing proceeds on these PRs until this is ruled.

### [`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) runtime-identity policy — design-only, awaiting you for 3 press ticks

_Which runtime identity does the endor archive claim when an npm package asks?_ — the
default `exports` condition set, and whether to endow a `Buffer` global. Reconfirmed live
on current HEAD: `endor run nanoid@5.1.16` dies with **`import webcrypto not found`** (it
resolves to the `node:crypto` build; no builtin).

Its proposal: default set = flavor + `endo` + `default`; endow `Buffer`; run a corpus
experiment before making `browser` a default. The press offers to drive that corpus
experiment if you want empirical data first.

This ruling and the compartment-mapper question are **entangled** — the condition-default
and builtin-shim choices in [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876)/[`#877`](https://github.com/endojs/endo-but-for-bots/pull/877)/[`#878`](https://github.com/endojs/endo-but-for-bots/pull/878)
cannot finalize until both are settled.

### Stale approvals — re-approval needed after a head moved

The fleet will not merge on an approval that does not point at the current head. Three
PRs are otherwise finished and blocked only on a fresh stamp:

- [`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) `provideSubMount` (Phase 4) — **recovered from CONFLICTING**, now MERGEABLE 25/25 non-draft. Head moved `76e6800ee5` → `d74caef78c`; your APPROVED review points at the old commit. Its conduct job is parked at `jobs/plan/endojs-endo-but-for-bots-pr656-conduct.md` awaiting promotion.
- [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) / [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) — see the byteArray arc; both carry CHANGES_REQUESTED with fixes already pushed.

### One-vs-other decisions still unresolved

Both carried across **three** snapshots now.

- [`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) hardened URL `%URL%`/`%SharedURL%` split (changes-requested, 15/15) **vs** [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263) universal-intrinsic URL (clean 18/18, no review). Close one in favour of the other.
- [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) Docker on the frozen `master` lane (15/15) **vs** the remote-gateway line in [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) (23/23).

## Review now (cross-arc priority queue)

**The prior queue moved substantially.** Of the five numbered 07-29 entries,
[`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) **merged**,
[`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) and
[`#875`](https://github.com/endojs/endo-but-for-bots/pull/875) resolved (merged / redirected
above), and [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) regressed to
CONFLICTING. What remains, plus what is newly ready:

1. [`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) — **new**: [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) panel must-fix + summary-fix bundle (`maxResults`). 24/25. Directly follows the merged mount work. _(vfs-parity)_
2. [`#885`](https://github.com/endojs/endo-but-for-bots/pull/885) — **new**: adopt `@endo/cbor` for the OCapN codec primitives. 25/25.
3. [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) — Docker self-hosting with authenticated remote gateway (M3). 23/23. (Also one half of the [`#608`](https://github.com/endojs/endo-but-for-bots/pull/608)-vs decision above.)
4. [`#898`](https://github.com/endojs/endo-but-for-bots/pull/898) — **new**: addresses the panel verdict on the merged [`#848`](https://github.com/endojs/endo-but-for-bots/pull/848) Pi bump. 24/24.
5. [`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) — mount `deniedSegments` via `--deny`/`--no-deny`. 23/25. _(vfs-parity)_

Also green and non-draft, carried unreviewed:
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) unbounded stream buffer 23/23,
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent collection stores 21/21,
[`#760`](https://github.com/endojs/endo-but-for-bots/pull/760) Cap'n Web RPC 15/15,
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics caching 15/15,
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star export 15/15,
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere pin in eval fixture 22/22,
[`#867`](https://github.com/endojs/endo-but-for-bots/pull/867) `@noble/curves` 2.2.0 25/25 (**back out of draft** since 07-29),
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887) designs Summary recount 5/5,
[`#847`](https://github.com/endojs/endo-but-for-bots/pull/847) master CI baseline 14/14.

**Regressed since 07-29 — no longer review-ready:**
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) endor-run dependency walk is now **CONFLICTING** (26/26 green) — it was the prior snapshot's "rebased and green again" entry, so this is a second round-trip.
[`#856`](https://github.com/endojs/endo-but-for-bots/pull/856) ESM entry disambiguation is now **CONFLICTING** (24/24).
[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) xs2rust is **CONFLICTING** again with no checks reporting (0/0).
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) attenuated Sheets facets remains **CONFLICTING** (23/23 green), stacked on [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874).

## Arcs in progress

### OCapN-over-Noise ([kriscendobot/garden#49](https://github.com/kriscendobot/garden/issues/49)) — **one merge from unblocking**
[`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) transport is **approved at its
current head** `83f55ea93` (25/25, non-draft) — merging it is the single act that releases
this arc. The rest stays green:
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) two-peer demo 25/25 draft ·
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) WS+Noise 23/23 draft, changes-requested ·
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) forked two-daemon M5 23/23 draft ·
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) cross-host Pet-Daemon M5 23/23 draft.
M1–M5 are demonstrated including pure-CLI cross-host invite/accept; the remaining work is
**review, revision on [`#684`](https://github.com/endojs/endo-but-for-bots/pull/684), and un-draft**, not engineering.
[`#886`](https://github.com/endojs/endo-but-for-bots/pull/886) multi-transport listeners design merged 07-30.

### npm-via-CAS registry proxy ([kriscendobot/garden#56](https://github.com/kriscendobot/garden/issues/56)) — **half the stack landed**
**Four of the eight gap PRs merged in this window:** [`#857`](https://github.com/endojs/endo-but-for-bots/pull/857) peer/optional deps,
[`#859`](https://github.com/endojs/endo-but-for-bots/pull/859) process shim, [`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) `.npmrc` auth (all 07-30),
and [`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) workspace-protocol resolution (08-01). The load-bearing
[`#882`](https://github.com/endojs/endo-but-for-bots/pull/882) XS worker/SES boot bundle generators also merged 08-01 —
without it `rust/endo` did not build standalone at `llm` HEAD, and **no CI job builds the
xsnap crate**, so that gap regressed silently. Worth a follow-up CI proposal.

**The finish line is MET and demonstrated on fresh state**: cold resolve of `is-odd@3.0.1` +
`is-number@6.0.0` from registry.npmjs.org into a from-scratch `registry.db`, content-addressed
in the CAS, executed in XS, then replayed identically under `--offline` with zero network —
no `node_modules`, no lockfile.

The remaining four ([`#875`](https://github.com/endojs/endo-but-for-bots/pull/875), [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876), [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877), [`#878`](https://github.com/endojs/endo-but-for-bots/pull/878)) are
blocked on the **compartment-mapper ruling** and [`#879`](https://github.com/endojs/endo-but-for-bots/pull/879), both above. The frontier
is now real-world package hardening, not core capability.

### Passable byte arrays ([kriscendobot/garden#48](https://github.com/kriscendobot/garden/issues/48)) — complete-and-green, gated on re-review
- [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) immutable-arraybuffer shim + byteArray brand — 15/15, MERGEABLE/CLEAN, changes-requested with only 2 unresolved threads, both OUTDATED/trivial.
- [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) narrow byteArray to a plain frozen `Uint8Array` view — 17/17, MERGEABLE/CLEAN, all 5 current threads have fixes/answers pushed.
- **These two are complementary layers, not competing**: they share `.changeset/freezable-typedarray-emulation.md`, and the view redesign *refines* the immutable-arraybuffer emulation, which remains the substrate XS needs.
- [`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) RegistryInterface.resolve → immutable bytes — new draft, 23/23, MERGEABLE, no review yet. Auto-promoted after [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) merged.
- **Landing caveat:** [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) and [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) sit on frozen snapshot bases (`master-a7ff191`, `master-2708cac`) and will need a restack onto current `llm`.

### Git integration + endor bindings ([kriscendobot/garden#52](https://github.com/kriscendobot/garden/issues/52)) — **arc complete**
[`#691`](https://github.com/endojs/endo-but-for-bots/pull/691) merged 07-30, the last tracked item.
Every tracked artifact is now resolved ([`#706`](https://github.com/endojs/endo-but-for-bots/pull/706), [`#645`](https://github.com/endojs/endo-but-for-bots/pull/645),
[`#740`](https://github.com/endojs/endo-but-for-bots/pull/740), [`#708`](https://github.com/endojs/endo-but-for-bots/pull/708), [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705),
[`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) all merged; M3 closed 07-29).
[`#835`](https://github.com/endojs/endo-but-for-bots/pull/835) Git authority postures also merged 08-01.
The only remaining thread is [`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) (Phase-5 stack-surgery eval, OPEN/DRAFT
22/22 at unchanged head `8e29c292`) — a deliberate parked draft, not active work.
**The recurring `endo-git-integration-press` schedule is PAUSED** pending your call: retire it,
or re-scope it to guard [`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) and watch for post-M3 work (e.g. the endor CAS
bindings implementation — [`#740`](https://github.com/endojs/endo-but-for-bots/pull/740)'s design is merged; implement only on directive).

### VFS tool-call parity ([kriscendobot/garden#53](https://github.com/kriscendobot/garden/issues/53))
[`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) `EndoMount.glorp` **merged**, and its panel must-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is the top review-now entry.
[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) **recovered** from CONFLICTING and needs only a fresh approval
(above). [`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) remains review-ready.
Note [`#127`](https://github.com/endojs/endo-but-for-bots/pull/127) (the original mount extensions PR) is **CLOSED not merged**, which
strands [`#654`](https://github.com/endojs/endo-but-for-bots/pull/654) (Rust mount-parity runner, 23/46) on a closed branch.

### SturdyRef system ([kriscendobot/garden#47](https://github.com/kriscendobot/garden/issues/47)) — **paused pending maintainer discussion**
Unchanged in shape: bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) 24/24, [`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) 24/24,
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) 21/21 remain clean drafts; [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) and the agent
provide/accept designs [`#695`](https://github.com/endojs/endo-but-for-bots/pull/695)/[`#697`](https://github.com/endojs/endo-but-for-bots/pull/697) carry changes-requested.
[`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) is green (21 SUCCESS) with **zero reviews and no panel run**.
**The recurring `endo-sturdyref-press` schedule is PAUSED** — reviews here are blocked on
maintainer discussion, and the press was re-reporting the same block every 6h.
Its gauntlet job (`endo-sturdyref-agent-surface-build-gauntlet`) **cannot be fixed by raising
a budget**: it already declares `handler-timeout: 14000` against a ceiling of ≈14339s. It
needs splitting.

### Endor xs2rust ([kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51))
[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) is **CONFLICTING** again with no checks reporting (0/0) — a
regression from the prior snapshot's 23/24. The press driver rebases-on-dirty; no review
action until it surfaces a bar. Note this arc's direction (move logic **into** Rust) is in
tension with the compartment-mapper redirect above; ruling on one should acknowledge the other.

### Google Sheets
[`#874`](https://github.com/endojs/endo-but-for-bots/pull/874) portable Sheets client — green draft (25/25), iterating on
dckc's `_Power`-suffix naming feedback. [`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) attenuated facets — draft,
**CONFLICTING**, stacked on [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874); needs a rebase once that lands.
The network floor is operational: [`#723`](https://github.com/endojs/endo-but-for-bots/pull/723) `@endo/fetch` **merged 07-30**
on top of [`#566`](https://github.com/endojs/endo-but-for-bots/pull/566). Phase-3 OAuth waits on approved-but-frozen
[`#621`](https://github.com/endojs/endo-but-for-bots/pull/621).

## Blocked on the garden, not on review

A distinct class: PRs whose CI is green and whose review is not the obstacle.

**Resolved this window — the handler-budget class.** `role: builder` and `role: web-builder`
now default to a **2h** handler budget (`GARDEN_BUILD_HANDLER_TIMEOUT=7200`, deployed
`dc18efaf50`) instead of the 2400s fleet default. The commit names the failure that
prompted it: `ebfb-pr882-bootstrap-generators` died at rc=124/2401s and poisoned, and "the
fleet was learning this one poisoned job at a time." An explicit `handler-timeout:` header
still wins in either direction. **Shepherd jobs are NOT covered** — `GARDEN_SHEPHERD_HANDLER_TIMEOUT`
is 7200 but two shepherd jobs reached the board with no stamp and died at 2400s; the
producer that skips the stamp is unfixed.

**New this window — a Claude usage-cap cascade.** Between 11:00 and 13:00 UTC on 08-01 the
fleet recorded **41 cap-classified handler deaths**: handlers died in 1–2s on an explicit
session/usage-cap rejection, were classified transient, requeued, and poisoned. The window
produced **0 completions and ~20 poisoned jobs** across both hosts (they share one
subscription). Recovered by 14:30. Every affected job is preserved in `jobs/plan/` at
`gate: go-ahead` and needs deliberate promotion — including
`finbot-pr5-panel-20260801`, whose "undiagnosed worker death" is **fully explained by this
cap** (5 claim-and-die cycles, 0 deadline overruns, poisoned 11:33Z) and which should
simply be re-posted.

The lesson worth carrying: ~10 concurrent mentor-tier gardeners exhaust the session cap in
roughly two hours, and the failure mode is a poison cascade rather than graceful
degradation. The foreman's token-quota back-off (`GARDEN_TOKEN_WEEKLY_QUOTA`) is unset, and
would not gate gardener claiming even if set.

**Do not read any of these as review-stalled.**

## Newly landed since the prior snapshot

**16 merged since 2026-07-29 (evening):**
[`#864`](https://github.com/endojs/endo-but-for-bots/pull/864) per-machine xsnap quiesce flag,
[`#848`](https://github.com/endojs/endo-but-for-bots/pull/848) Pi 0.81.1,
[`#857`](https://github.com/endojs/endo-but-for-bots/pull/857) peer/optional dependencies,
[`#860`](https://github.com/endojs/endo-but-for-bots/pull/860) `.npmrc` basic auth + `${VAR}`,
[`#859`](https://github.com/endojs/endo-but-for-bots/pull/859) frozen process shim,
[`#869`](https://github.com/endojs/endo-but-for-bots/pull/869) happy-dom 20.11.0 (closes GHSA-37j7-fg3j-429f, CRITICAL),
[`#870`](https://github.com/endojs/endo-but-for-bots/pull/870) openai 6.48.0,
[`#886`](https://github.com/endojs/endo-but-for-bots/pull/886) multi-transport listeners design,
[`#844`](https://github.com/endojs/endo-but-for-bots/pull/844) contract fixtures → expect-type,
[`#846`](https://github.com/endojs/endo-but-for-bots/pull/846) collection/bare-return inference,
[`#845`](https://github.com/endojs/endo-but-for-bots/pull/845) decoded roots safe by default,
[`#901`](https://github.com/endojs/endo-but-for-bots/pull/901) retire tsd,
[`#882`](https://github.com/endojs/endo-but-for-bots/pull/882) XS worker/SES boot bundle generators,
[`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) workspace-protocol resolution,
[`#835`](https://github.com/endojs/endo-but-for-bots/pull/835) Git authority postures,
[`#751`](https://github.com/endojs/endo-but-for-bots/pull/751) conditional `resultName` with named-result store.

Also merged just before the window closed on 07-29: [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713), [`#691`](https://github.com/endojs/endo-but-for-bots/pull/691), [`#723`](https://github.com/endojs/endo-but-for-bots/pull/723).

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17) —
still open, MERGEABLE, no review, carried across three snapshots. Larger runners for the
resource-heavy multichain legs, make them non-required on the fork, or a dedicated
infra-tuning pass.

dckc's [kriscendobot/garden#67](https://github.com/kriscendobot/garden/issues/67) remains
**closed as completed**. Upstream `agoric/agoric-sdk` stays comment-and-link-free;
experimentation is confined to the `kriscendobot/agoric-sdk` fork.

## Scope

**286 open pull requests.** This is the curated maintainer sequence for current
milestone/arc work and garden-unblocking edges, not an assertion that the remaining long
tail is review-ready.

The headline this refresh: **the queue converted at an unprecedented rate — 16 merges,
including half the npm-CAS gap stack and the whole git-integration arc — and the bottleneck
moved from _promotion_ to _rulings_.** The prior snapshot's binding constraint (six held
drafts awaiting promotion) is gone: they landed. What replaced it is narrower and heavier —
**five approved PRs nobody has merged**, one **architecture ruling** (compartment-mapper vs
runtime resolver) that gates four PRs and touches already-merged work, and one **policy
ruling** ([`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) runtime identity) that gates the same set.

Two structural notes for the next refresh: several arcs now carry **frozen-base drift**
([`#836`](https://github.com/endojs/endo-but-for-bots/pull/836), [`#621`](https://github.com/endojs/endo-but-for-bots/pull/621), [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503), [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475)),
where an approval or a green run refers to a snapshot base rather than `llm`; and the
**stale-approval pattern** ([`#656`](https://github.com/endojs/endo-but-for-bots/pull/656), [`#873`](https://github.com/endojs/endo-but-for-bots/pull/873) before it merged) recurs often
enough to be worth a convention — the fleet correctly refuses to merge on an approval that
does not name the current head, so every rebase costs a round trip through you.
