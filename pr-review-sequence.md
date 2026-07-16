# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-07-16 (evening). Refreshed from the API and reorganized around
the **major review arcs now in progress** (each has a standing press-driver +
kriskowal/garden tracker). Read "Review now" for the cross-arc priority queue, then
the per-arc sections for each effort's state and its next reviewable/blocking edge.
`UNKNOWN` mergeability means GitHub had not recomputed the merge graph at snapshot._

## Review now (cross-arc priority queue)

Non-draft, `MERGEABLE/CLEAN`, no `CHANGES_REQUESTED`, all checks green — review top to
bottom; arc tagged.

1. [`#708`](https://github.com/endojs/endo-but-for-bots/pull/708) — restore content-address QID/hash in `@endo/exo-git`. 23/23. _(git-integration)_
2. [`#707`](https://github.com/endojs/endo-but-for-bots/pull/707) — capability-based workspace provisioning + the worked VCS loop (git stack Phase 3). 23/23. **Recovered to CLEAN** (was UNSTABLE); its predecessor `#706` just merged. _(git-integration)_
3. [`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) — `EndoMount.glorp` fused glob+grep. 23/23. _(vfs-parity)_
4. [`#655`](https://github.com/endojs/endo-but-for-bots/pull/655) — mount grep (PR C of #127). 23/23. _(vfs-parity)_
5. [`#657`](https://github.com/endojs/endo-but-for-bots/pull/657) — mount JSON read/write (PR D of #127). 23/23. _(vfs-parity)_
6. [`#669`](https://github.com/endojs/endo-but-for-bots/pull/669) — Pi-compatible JSONL transcript projection. 23/23.
7. [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) — Docker self-hosting with authenticated remote gateway (M3). 23/23.
8. [`#259`](https://github.com/endojs/endo-but-for-bots/pull/259) — `TextEncoder`/`TextDecoder` as universal intrinsics. 18/18.

**Ready pending a mergeability recompute** (non-draft, green, no changes-requested, but
`UNKNOWN` at snapshot — re-check then review): [`#705`](https://github.com/endojs/endo-but-for-bots/pull/705) git remote push tier _(git)_, [`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) `provideSubMount` _(vfs)_, [`#585`](https://github.com/endojs/endo-but-for-bots/pull/585) content-store powers for node fs _(data-plane)_, [`#276`](https://github.com/endojs/endo-but-for-bots/pull/276) npm-registry HTTP fetch _(npm-CAS)_, [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) endor-run dependency walk _(npm-CAS)_.

### Separate `master` Docker lane
[`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) — earlier local/headless Docker image, `MERGEABLE/CLEAN` 15/15 but based on frozen `master`. Decide whether it still lands on the `master` lane or is superseded by the remote-gateway line in `#694`.

## Arcs in progress

Each arc has a standing press-driver and a kriskowal/garden tracker issue (in parens).

### SturdyRef system (#47)
Design `#510` **merged**; the effort is implementation-in-flight through numbered cuts.
- **Bridge cuts, clean drafts (next edge):** [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) bytes-preserving wire read (cut 1), 24/24; [`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) URI codec + closely-held reveal (cut 2), 24/24. [`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) read-side facet threading (cuts 3–4), 22/22. All draft/clean — the press should drive these toward un-draft.
- **Designs needing revision:** [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) on-demand enlivenment (`CHANGES_REQUESTED`); [`#511`](https://github.com/endojs/endo-but-for-bots/pull/511) pass-style + FinalizationRegistry retention (clean draft).
- **Agent provide/accept surface (design, changes-requested):** [`#695`](https://github.com/endojs/endo-but-for-bots/pull/695), [`#697`](https://github.com/endojs/endo-but-for-bots/pull/697) — revise, don't treat as first-review.

### Passable byte arrays (#48)
- **Front (changes-requested):** [`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) passable byte arrays (freezable TypedArray + brand check), CLEAN 15/15 — address review. [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) narrow byteArray to plain frozen `Uint8Array`, **UNSTABLE 11/17 (6 failing)** — fix CI + review.
- **Design (needs rebase):** [`#572`](https://github.com/endojs/endo-but-for-bots/pull/572) frozen-Uint8Array-view byteArray, `DIRTY` — rebase.
- **Spike:** [`#602`](https://github.com/endojs/endo-but-for-bots/pull/602) Proxy-based emulation w/ Node·XS parity (draft, for comparison).
- Registry dependency [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) is shared with the npm-CAS arc (see below).

### OCapN-over-Noise (#49)
All milestones M1–M5 demonstrated (cross-host invite/accept), stack rebased onto `llm`. All PRs draft; the remaining work is driving CI green on the M5 demos.
- [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) transport 25/25; [`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) two-peer demo + crossed-hellos fix 24/24. Both green drafts.
- **CI to fix (next edge):** [`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) WS+Noise, [`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) forked two-daemon M5, [`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) cross-host Pet-Daemon M5 — each `UNSTABLE` 21/23 (2 failing). Drive green, then surface the stack for review.

### Daemon data plane (#50)
**Design `#662` (magnet-URN content locators) merged** — the arc moves from design-first toward implementation.
- **Implementation edge:** [`#585`](https://github.com/endojs/endo-but-for-bots/pull/585) content-store powers for node fs, non-draft 25/25 (see Review-now pending list).
- **Designs (draft):** [`#739`](https://github.com/endojs/endo-but-for-bots/pull/739) store drives `writeFile` on `EndoDirectory`; [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) streaming mount search.

### Endor xs2rust (#51)
[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) — draft, `DIRTY` (needs rebase on `llm`). The hourly press-driver now rebases-on-dirty and presses by default; no review action until it surfaces a bar.

### Git integration + endor bindings (#52)
**Strong progress: `#706` (commit-identity boundary, M3 Phase 2) merged**, and `#643` (mount+Git contract consolidation) merged.
- **Review-now:** `#708`, `#707` (both clean, above). `#705` remote push tier ready pending recompute.
- **Designs (draft):** [`#740`](https://github.com/endojs/endo-but-for-bots/pull/740) in-process Git CAS bindings (endor); [`#691`](https://github.com/endojs/endo-but-for-bots/pull/691) accept/sequence the git-capability stack (M3).

### VFS tool-call parity (#53)
**`#714` (listTree/rangeRead/rangeReadText consolidation) merged.**
- **Review-now:** `#713`, `#655`, `#657` (all clean, above); `#656` provideSubMount ready pending recompute. The mount extension split (#127) is landing steadily.

### Finbot (#54)
Driven off `kriscendobot/finbot`, not tracked here. Note: a scholar literature-review job (`scholar-financial-forecasting-literature`) is in flight to feed the finbot effort a backtesting/anti-overfitting synthesis.

### npm-via-CAS registry proxy (#56)
Design `endor-npm-registry-proxy.md`, phases 1+3 done.
- **Implementation edge:** [`#276`](https://github.com/endojs/endo-but-for-bots/pull/276) Phase-2 HTTP fetch (24/24, ready pending recompute); [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) endor-run dependency walk (25/25).
- **Design:** [`#241`](https://github.com/endojs/endo-but-for-bots/pull/241) familiar/host run over VFS (npm-to-sqlite); [`#331`](https://github.com/endojs/endo-but-for-bots/pull/331) npm registry capability (`BLOCKED`, changes-requested); [`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) Endor/XS registry transport power (draft).
- **Shared registry-capability plumbing (changes-requested):** [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) EndoRegistry + `@registry` (CLEAN 25/25, changes-requested); [`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) daemon `@registry` host name (21/24, 3 failing); [`#563`](https://github.com/endojs/endo-but-for-bots/pull/563) registry host slot (`DIRTY`, draft). Landing `#671`/`#403` unblocks the parked `registry-immutable-byte-array-followup`.

## Other tracked PRs (not in an arc)

- **Needs review addressed (changes-requested, otherwise mergeable):** [`#598`](https://github.com/endojs/endo-but-for-bots/pull/598) daemon→manager rename phase 1 (23/23; releases the parked phase-2/3 chain); [`#594`](https://github.com/endojs/endo-but-for-bots/pull/594) per-package lint (16/16; releases `resume-lint-ceiling-shepherds`); [`#667`](https://github.com/endojs/endo-but-for-bots/pull/667) stdio JSONL RPC bridge (25/25); [`#670`](https://github.com/endojs/endo-but-for-bots/pull/670) subscription OAuth (23/23); [`#721`](https://github.com/endojs/endo-but-for-bots/pull/721) `@endo/reminder` impl (23/23 — its design `#682` merged, so the hold is lifted); [`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) hardened URL `%URL%`/`%SharedURL%` split (18/18) — prefer over the older universal-intrinsic [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263) (clean 18/18, no review); close #263 in favor of #719 or vice-versa.
- **Draft designs awaiting go/no-go:** [`#676`](https://github.com/endojs/endo-but-for-bots/pull/676) `@endo/regexp` subset (releases `build-endo-regexp-conservative-subset`); [`#715`](https://github.com/endojs/endo-but-for-bots/pull/715) `@endo/inspect` (releases `build-endo-inspect`).
- **Needs engineering:** [`#723`](https://github.com/endojs/endo-but-for-bots/pull/723) `@endo/fetch` confined outbound HTTP (draft, 22/25, 3 failing) — align with merged split-plugin design `#722`, fix CI.

## Newly landed or retired since the prior snapshot

- Merged (tracked): **`#662`** (data-plane magnet-URN design), **`#706`** (git commit-identity M3 Phase 2), **`#714`** (VFS listTree/rangeRead), **`#643`** (mount+Git contract consolidation).
- Merged (adjacent): `#745`, `#744`, `#728`, `#687`, `#526` (agentry/exo-stream containment + git eval scenario).
- Earlier window: `#682`/`#722`/`#661` merged, `#658` closed, `#710` merged (the `@endo/cbor` design now being ported to `llm` under the `build-endo-cbor-package` job).

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17) remains open, non-draft, `MERGEABLE/UNSTABLE`: 73 of 87 checks pass, 2 failing. Maintainer decision unchanged — larger runners for the resource-heavy multichain legs, make them non-required on the fork, or a dedicated infra-tuning pass.

## Scope

**256 open pull requests** in `endojs/endo-but-for-bots`. This is the curated maintainer
sequence for current milestone/arc work and garden-unblocking edges, not an assertion
that the remaining long tail is review-ready.
