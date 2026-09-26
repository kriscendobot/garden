# Completion report: ebfb-design-sturdyref-agent-surface

## What I did

**Authored `designs/sturdy-refs-agent-surface.md` (604 lines) and opened DRAFT PR [endojs/endo-but-for-bots#695](https://github.com/endojs/endo-but-for-bots/pull/695)** (branch `design/sturdy-refs-agent-surface` @ `619493db4d`, base `llm`). Grounded against live state: #521 @ `d3c68897b` (`packages/pass-style/src/sturdyref.js`), #541 @ `fab626e84` (`packages/daemon/src/sturdyref-resolution.js` and the widened `interfaces.js` guards, read-only), #539 @ `4537e4a5c`, plus a full survey of `packages/{lal,fae,genie,agent-tools}` and `daemon-locator-reference.md`. Neither build branch was touched.

**Token representation settled (job task 1):** a **daemon-minted, method-less remotable** (`SturdyRefToken`), minted fresh per grant, bound off-band in a module-private WeakMap (`tokenToId`, mirroring #541's `sturdyRefToId`). The deciding argument is identity across the daemon-worker CapTP boundary: resolution and unforgeability require the daemon to recover the very object it minted, which remotables get free from CapTP slot tables; a payload-free tagged shim (pre-#521 shape) loses identity at the first crossing, and a new pass-style category (or a location-less sturdyref form) repeats #521's full cross-cutting cost (marshal rank-order, slot machinery, wire codec) for a value whose essence is carrying nothing. A sealed-blob variant is considered and rejected. Guard admission is the **sum pattern** (`M.or(M.kind('sturdyref'), M.remotable('SturdyRefToken'))`), verified against `matchRemotableHelper` (label is documentation-only, so guards route and the WeakMap authenticates, same as #541). One design finding worth flagging: the token tier gets a **method mask** — admitted only by value-producing methods (`lookup`, `evaluate`/`makeUnconfined` slots, `list`), never `identify`/`locate`/`listIdentifiers`/`listLocators` — because `locate(token)` would put a locator in reach (invariant 1) and `identify(token)` would yield a stable correlatable id that outlives revocation via `lookupById`.

**Provide (task 2):** minting is daemon-side only; `makeRefToken` (shared name-hub), `makeSturdyRef` (host-only, tokens excluded from its guard), `adoptRefToken` (mail, namespace-free acceptance). The granter's facet decides the tier: guests can only mint tokens; hosts choose per recipient. **Accept (task 3):** the enlivenment table's read methods per the mask, plus mail widening (`send`/`reply`/`resolve` entries), `storeRef` for durable naming, and a **text-tier ref escrow** for the LLM boundary (the survey found no agent package passes capabilities as tool-call values today — lal's SmallCaps marshal has an always-empty slot table; fae/genie/agent-tools are plain JSON). Lal completes its slot converters restricted to the two ref tiers; agent-tools gains `makeRefEscrow` shared by fae/genie. **Confinement (task 4):** the three invariants restated as acceptance criteria with a per-artifact table (summary: token module → no-identification + unforgeable; method-less exo → no-location; guard sums → routing only, no authority; method mask → no-location + revocation effectiveness; daemon-side minting → no-location; sender-side mail resolution → fresh-per-grant unlinkability; escrow handles → locally-minted counters, no referent-derived content; lal slot restriction → boundary stays closed to arbitrary caps), plus the agent-surface confinement test plan the job required. **Cut table (task 6):** six independently mergeable cuts (A daemon token core, B daemon provide+mail, C agent-tools escrow, D lal, E fae, F genie) ready for per-cut builder jobs.

**#539 updated (task 5):** pushed `22923949b2` onto `design/sturdy-refs-endor-syscall-followup` (a commit on top; no rebase) marking the token-representation open question **Resolved:** with a pointer to #695, adding a Dependencies row; the enlivened-presence-lifetime question left open verbatim. Posted the standing-norm summary comment on #539 (comment `4948645763`).

## Verification

- Mermaid: the one diagram parse-validated per the mermaid-validation skill (`node check.mjs` → `OK sequence`).
- House style: grep sweeps for em-dashes, Latin shorthand, and non-ASCII code points all returned empty.
- PR state verified via `gh pr view`: #695 `{draft: true, state: OPEN, base: llm, head: 619493db4d}`; #539 `{draft: true, state: OPEN, head: 22923949b2}`.
- No test suite run: both changes are design-document-only edits with no runtime surface; nothing beyond the above is claimed verified.

## Follow-ups (inherited, not solved — noted in the design)

- `M.sturdyRef()` in `@endo/patterns` (blocked on `@endo/marshal` rank-order; tracking issue to be filed).
- OCapN-peer→daemon `internalizeLocator` bridge + wire codec for foreign SturdyRefs (tokens add nothing to this debt; they cross peers as ordinary handoff presences).
- Builder jobs per cut A–F can be posted once the maintainer accepts the design; cuts A–B depend on #541 landing.
- One open question deliberately surfaced for the maintainer: whether tokens should optionally be formula-backed to survive daemon restart (design recommends no; durable designation stays a name via `storeRef`).

Self-improvement: nothing this time.
