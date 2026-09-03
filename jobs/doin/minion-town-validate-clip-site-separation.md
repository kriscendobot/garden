---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
project: minion-town

Empirically validate, against the **live production** `minion.town` deployment, that two clips with byte-identical `front` content but distinct `back` capabilities get distinct, non-colliding origins. Maintainer directive (dckc), 2026-09-03, split out from the broader `minion-town-clip-formula-id-origin-gc` design job (which now cites this job for the live-evidence step rather than owning it).

## Why this matters

`designs/clip-ocap-synthesis.md` § 3.4 and `src/endo/gateway/site-registry-exo.ts`'s module comment both claim clip identity is keyed to the registered directory's own fresh formula id (`hash := base32(directoryFormulaId)`, minted per `publish` via `freshDirectoryFormulaId`) — **never** a digest of `front`'s bytes — specifically so that two different publishes of identical content never share an origin, local storage, or CapTP routing to `back`. Both `designs/clip-ocap-synthesis.md` (§ 9) and `DEPLOYMENT.md` (§ "Live `@sites` registry") are explicit that this has been **"verified in-process against fakes only"** and is **"not proven live"** — restart durability, the cross-agent directory pin, and guest-side `sites` resolution are called out by name as untested against the running daemon. `CLIP_SITES_LIVE=1` is on in production today (`deploy/aws/systemd/minion-mcp.service`), so this is directly testable now.

## What to do

1. Read `src/endo/gateway/{publish.ts,site-registry.ts,site-registry-exo.ts,daemon-site-registry.ts}` first so you know exactly which code path you're exercising and what `freshDirectoryFormulaId`/`idToLabel` are supposed to guarantee.
2. Using the live `mcp__minion-town__*` MCP tool surface if your environment has it wired in, otherwise the repo's own PKCE MCP client harness already documented at `DEPLOYMENT.md` § "Edge verification (Increment-4 DoD)" (the same pattern used for prior production verification):
   - Publish **two clips** whose `front` file set is deliberately **byte-identical** (same paths, same exact bytes — diff them locally before publishing to be certain) but bound to **different** `back` powers (two distinct pet names in your guest, or two distinct guests if you can provision a second one — note in your report whether a second-guest test was in scope/possible; the single-guest two-publish case alone already exercises the core `freshDirectoryFormulaId`-per-publish mechanism).
   - Confirm the two `publish` calls return **distinct** `hash`/`url` values.
   - Confirm each origin's `.well-known/endo-captp` WebSocket bootstraps **only its own** `back` — no cross-talk (e.g., call a method on each `back` that reveals its identity/state, and confirm origin A never sees origin B's state or vice versa).
   - Call `upgrade` (or re-publish equivalent) on one of the two clips, changing `front` content, and confirm its `hash`/`url` are **unchanged** after the rewrite (§ 3.2's "upgrade in place, no re-mint" claim) — this is the flip side of the same identity guarantee and is easy to check in the same session.
3. Record the **actual evidence**: the two hashes/URLs, the timestamps, the exact MCP calls or PKCE-client transcript, and the cross-talk check's result. Do not summarize away a negative result — if either clip's origin turns out to depend on content, or `back` leaks between origins, or `upgrade` re-mints the hash, **stop, do not paper over it**, and instead open a plainly-titled follow-up fix job describing exactly what you observed; say so in your completion report.
4. If everything checks out clean: land a small doc-only commit (direct to `main` per this project's convention for changes that don't need pre-deploy review) updating `designs/clip-ocap-synthesis.md` § 9 and/or `DEPLOYMENT.md`'s "not proven live" / "verification caveat" language to record that this specific claim is now proven live, dated, with a one-line pointer to where the fuller evidence lives (your completion report, or a short `## Live verification` addendum in the design doc itself — match this repo's existing `daemon-site-registry.ts` "Verification status" style).

## Deliverable

A completion report with the concrete evidence (hashes/URLs/timestamps/transcript) and, if clean, the doc-update commit reference. If a real gap is found, the completion report names it precisely and points to the follow-up job you opened for it — do not attempt the fix in this job.


<!-- garden-reaped: 1 -->

<!-- garden-transient-elapsed: kind=signature through=1 values=2,2 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T21:35:15Z
