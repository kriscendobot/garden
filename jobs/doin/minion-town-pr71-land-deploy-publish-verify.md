---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Own every remaining step from `minion-town-fix-publish-invalid-main-pet-name`.

The source diagnosis is confirmed: production's pinned Endo daemon rejects the application compatibility probe `guest.has("@main")`; it does not indicate a missing guest provisioning step. Draft https://github.com/kriscendobot/minion.town/pull/71 at `79c04305743b286ff91e565d2c90cc7df7cd85b2` implements the fallback to legacy `MAIN` and has regression coverage. CI passes. A second independent local run on 2026-09-01 observed `npm test` (290 passed, 5 skipped) and `npm run typecheck` passing after a clean `npm ci`.

Complete all of the following:

1. Put PR 71 through the repository's required review/gauntlet and land it safely; do not open a duplicate PR.
2. Deploy the landed main commit to production using the repository's established deployment procedure.
3. On the affected MCP guest, run the exact smoke: `publish` with `powers: "sites"` and one `index.html` file whose base64 bytes are `dGVzdA==`. Before deployment this exact call was reconfirmed to return `Invalid pet name "@main"`. After deployment it must return a hash/URL. Fetch the returned URL and verify its body is `test`; clean up with `unpublish` if appropriate.
4. Confirm no direct guest repair is needed: the compatibility fallback should repair legacy guests in place. If anything guest-specific remains, repair it.
5. Update garden `skills/minion-town-clip-publishing/SKILL.md` on main2: replace the unresolved known-bug note with the confirmed diagnosis, landed fix/deploy status, affected guest scope, and verification evidence. Commit explicit pathspecs and push with the documented rebase CAS loop.
6. Close or update https://github.com/kriscendobot/minion.town/issues/74 only if authorized by the active job/inbox; otherwise report the remaining issue bookkeeping.

Origin: job `minion-town-fix-publish-invalid-main-pet-name`. This successor owns the entire unfinished deliverable.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=571 -->

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-01T20:04:51Z
