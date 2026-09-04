---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
project: minion-town

Investigate and, if warranted, fix a possible clip-identity security discrepancy in `kriscendobot/minion.town`, and design the missing garbage collector for accumulated clip static content. Maintainer directive (dckc), 2026-09-03.

## The reported concern

A guest publishing a clip via the `publish` MCP tool gets back a `<hash>.ocap.site` origin. If that origin were derived from a **digest of the published content** (`front`), two different guests publishing byte-identical front content would collide on the *same* origin — and since a clip's origin is also the unique CapTP endpoint for its `back` live capability and the unique local-storage partition for its frontend, a later publisher would subvert an earlier publisher's `back` association (or at minimum share storage/connection routing with a stranger). The fix the maintainer wants, if the discrepancy is confirmed: **the origin must be keyed to a formula id unique to that specific (front, back) pair**, never to a digest of momentary content, so the URL is itself an unguessable capability with its own guaranteed local storage and CapTP routing to its own `back`.

This report traces back to this session's own primer artifact (published as an `ocap.site` clip while building CLIPOMETER, a live visit-counter clip), which described `front` as simply "content-addressed and immutable" without distinguishing storage-layer content-addressing from site-identity derivation — read that wording as a symptom to correct, not as source-of-truth for how the system actually behaves.

## What's already on record — read this first

`designs/clip-ocap-synthesis.md` (status: **units 1-2, + partial unit 3, landed in PR #52** — **"verified in-process against fakes only," explicitly "not proven live"**) already specifies exactly the fix the maintainer describes:

- § 3.4 **Clip identity**: `hash := base32(directoryFormulaId)` — identity keyed on the registered directory's own stable 256-bit formula id, explicitly **not** a content digest. The section calls out, by name, dropping "the earlier draft's cross-guest content-address dedup (two guests with byte-identical content sharing one hash)" as a deliberate, discussed decision.
- `front` and `back` are two entries of **one Endo directory** the guest owns; a fresh `publish` mints a fresh directory (`freshDirectoryFormulaId`, referenced from `src/endo/gateway/publish.ts`), so a fresh registration always gets a fresh origin regardless of content overlap with any other registration.
- `src/endo/gateway/site-registry-exo.ts`'s module doc states the landed exo "keys identity on the directory's OWN 256-bit formula id, per § 3.4 ... nothing is re-derived from momentary content, so a restart preserves every registration" — i.e., the code's own comments claim the fix already landed.
- `DEPLOYMENT.md` § "Live `@sites` registry" confirms `CLIP_SITES_LIVE=1` is **ON in production today** (`deploy/aws/systemd/minion-mcp.service`) — this is the exact code path this session's `mcp__minion-town__publish` calls exercised.
- **But**, both the design doc and `DEPLOYMENT.md` are explicit that the *live-daemon* semantics of this exact mechanism — durable install across a daemon restart, `identify` yielding the directory's own formula id, the cross-agent directory pin, guest-side resolution of the introduced `sites` name — run **only under a local `ENDO_CHECKOUT`** and are **not exercised in CI**, and durability across a daemon restart specifically "is not yet exercised." So the claim that origin is formula-id-keyed (not content-keyed) has apparently never been *proven* against the running production daemon, only asserted in design prose and code comments.

**So the first job is verification, not blind re-design**: determine, with direct evidence against the live production deployment (not fakes, not a re-read of the design doc), whether the deployed system already closes this gap as `clip-ocap-synthesis.md` § 3.4 / `site-registry-exo.ts` claim, or whether some path (a legacy/scaffold fallback, an unfinished unit-3 residual, a live/deployed-code divergence from what's on `main`) still lets content determine the origin. Concretely:

- Read `src/endo/gateway/{publish.ts,site-registry.ts,site-registry-exo.ts,daemon-site-registry.ts,daemon-clip-wiring.ts,clip-store.ts,content-store.ts}` end to end (already partially read this session — cite what's already known above, verify the rest) and confirm there is no path — the in-memory `makeSiteRegistry` scaffold's `"5".repeat(64)` placeholder, a legacy pre-`@sites` vhost record, an `upgrade` code path — where `hash` ever derives from `contentRoot`/`blobId` rather than the directory's own formula id.
- **Ad hoc validation directly against the live production `minion.town` MCP endpoint** (the same `mcp__minion-town__*` tool surface used this session, or the repo's own PKCE MCP client harness already documented at `DEPLOYMENT.md` § "Edge verification (Increment-4 DoD)" if MCP tool access isn't wired into the gardener's environment): publish two clips whose `front` content is deliberately byte-identical (same files, same bytes) but different `back` powers, and confirm they receive **distinct** hashes/origins/URLs and that each origin's CapTP endpoint boots only its own `back` (no cross-talk). Also check whether `upgrade`/re-publish-with-changed-content on one clip ever changes its hash (it should not, per § 3.2). Record the actual observed hashes, timestamps, and MCP call transcripts in the design doc's verification section — this is exactly the "not proven live" gap both source docs flag; closing it is the point of this job, independent of whether a code fix turns out to be needed.
- If the investigation finds the deployed mechanism is already sound: say so plainly, correct the misleading "content-addressed" framing in any garden-side documentation that echoes it (the CLIPOMETER primer clip this session published, if reachable/editable — otherwise flag it back), and land the live-verification evidence somewhere durable (this design doc's own verification section is enough, or an addendum to `clip-ocap-synthesis.md` closing its "not proven live" caveat).
- If the investigation finds a real gap (a fallback path, an untested restart-durability failure mode, a unit-3 residual that reintroduces content-keying under some condition): design the fix in the shape `clip-ocap-synthesis.md` already establishes (directory-formula-id identity, guest-side introduction, no gateway-authority resolution of caller-supplied names) and land it.

## The garbage-collection gap — confirmed, not yet addressed anywhere

Independent of the identity question above, this session confirmed a **second, definitely-real gap** the maintainer also asked about: `src/endo/gateway/content-store.ts` implements the clip content-addressed store (CAS) as strictly **write-once, sha-256-addressed, on-disk (`<root>/blobs/<ab>/<blobId>`)**, and a grep across every file in `src/endo/gateway/` for `evict|delete|prune|ttl|expire` returns **zero hits** outside of `ttl-cache.ts` (which is an in-memory read-side lookup cache, not storage retention). Nothing in the codebase or in `designs/clip-ocap-synthesis.md` ever reclaims a blob, a manifest, or (under the `@sites` model) a directory's own daemon-side formula once it is no longer referenced by any live registration. Every `publish`, every `upgrade`'s rewritten `front`, and every already-`unpublish`ed clip's blobs accumulate on disk **forever**, unbounded, with no reclaim path — confirmed by reading `unregister`'s implementation in `site-registry-exo.ts` (drops the id→name edge and the owner record in the `@sites` store; does **not** touch the CAS or the guest's own directory formula).

Design a garbage collector that reclaims:

1. **CAS blobs and manifests** (`content-store.ts`) no longer referenced by any *live* vhost record / registered directory's `front` entry — including blobs superseded by an `upgrade` that rewrote `front` in place, and blobs belonging to a directory that was `unregister`ed/`unpublish`ed.
2. Whatever daemon-side formula/store footprint (the guest's own directory formula, the `@sites` store's `owner-<hash>` record, any `clip-<n>-<rand>` guest directory per § 9 unit 1-2) is left stranded once a site is unregistered — confirm what, if anything, currently reclaims these (this session's reading suggests nothing does; verify).

The design must specify, at minimum:

- **Reference-counting or mark-and-sweep semantics** over the CAS: what "still live" means precisely (every manifest named by a current vhost record's `contentRoot`, transitively every blob that manifest names) and how to enumerate it without a stop-the-world lock on `publish`/`upgrade`.
- **Safety against the write side racing the sweep**: a blob interned mid-`publish` (charged, written, but not yet linked into a manifest/vhost record because the register call hasn't returned) must never be collected out from under an in-flight publish. State the exact interlock (a grace period keyed on intern timestamp, a two-phase mark, or equivalent) and justify it.
- **Trigger and cadence**: a periodic sweep (systemd timer, matching this project's existing `deploy/aws/systemd/` pattern) vs. an on-`unpublish`/on-`upgrade` incremental reclaim, or both — with a stated rationale.
- **A dry-run / audit mode** that reports what *would* be reclaimed without deleting, so the first production run can be validated before it's destructive — and an ad hoc validation plan for that dry run against the live deployment's actual accumulated blob store (do not just design this on paper; the maintainer's ask explicitly wants production validation, not only tests against fakes).
- Unit tests covering the reference-computation logic against fakes (matching this project's existing test conventions — see `packages/gateway/test/*.test.js` upstream and this repo's own `*.test.ts` layout), PLUS the live/production verification step above, both landing in the design's verification section per this project's existing `## Verification status` convention (see `daemon-site-registry.ts`'s own such section as the house style to match).

## Deliverables

1. A design doc at `designs/<slug>.md` (repo convention: `# Design: <title>` + bold `**Status:**` header block, per `journal/projects/minion-town/README.md` § Rules of engagement) covering both the identity-verification findings and the GC design, opened as a PR against `main` per the project's "Design delivery is PR review" rule (maintainer directive, kriskowal 2026-07-10) — reference and, where it deviates or closes a caveat, amend `designs/clip-ocap-synthesis.md` rather than duplicating it.
2. The identity question resolved with **live production evidence**, not just a re-read of existing design prose — record the actual verification transcript.
3. A GC design with a concrete test plan (fakes) and a production ad hoc validation plan (dry-run against the real accumulated store), per the maintainer's explicit ask.
4. If a real code gap is found on the identity side, propose (and, time permitting, implement) the fix in this same PR or a clearly-named follow-on `build` job — say which, and why, in the completion report.
5. If GC implementation is scoped as a follow-on rather than landed in this job, the design must be complete enough that a later `build` job can implement it without further clarification (role norm: "implementable by a future builder without further clarification, OR the report flags the unresolved questions that block implementation").



<!-- garden-transient-elapsed: kind=signature through=1 values=2,2 -->
<!-- garden-elapsed-constancy: 1 -->

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T04:29:49Z
