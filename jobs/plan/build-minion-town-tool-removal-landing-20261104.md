---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/239
priority: normal
posted_by: gardener
posted_at: 2026-11-04T03:33:36Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: aws
---

# Land the MCP tool removal after #239 deploys (kriscendobot/minion.town)

repo: https://github.com/kriscendobot/minion.town
predecessor: build-minion-town-tool-removal-20261104
tracker: https://github.com/kriscendobot/minion.town/issues/227
drafts: head branch garden/mcp-tool-removal (twelve tools, PR_A here), head branch garden/mcp-invite-tool-removal (invite, cancelInvite, and the browser proof, PR_B here)
related: https://github.com/kriscendobot/garden-book/pull/17 (must merge before PR_A deploys, or the book cannot publish)

This job is promoted when #239 merges or closes. Check which it was: closing it unmerged
promotes this too, and then the invite removal has no replacement, so stop and ask the
maintainer. #239's merge deploys.

1. **Production proof.** This needs a host with the MCP bridge's AWS credentials, and it needs
   Chromium for Playwright (`npx playwright install chromium`). Confirm the deploy
   reached production and the page answers `#v=1&locator=`. Run `tools/guide-recipes/verify-web-accept.ts` from PR_B against
   production through the garden's MCP bridge (see
   `context/operations/minion-town-mcp.md`), with `MINION_MCP_STDIO` set. It uses one
   throwaway invitation, deletes its browser guest, and removes its name. It prints no
   locator. Check that no guest or `recipe-web-*` name is left behind.
2. **If the proof fails,** keep `invite` and `cancelInvite` (PR_B stays draft), report to
   the maintainer through `message-user.sh`, and do not land PR_B.
3. **Order of landing.** #235 (the guide) must land before or with PR_A, because agents
   otherwise lose the tools with no instructions. #235 is held by its own stop gate
   (the cold-agent baseline, job `minion-town-mcp-guide-remaining-slices-20261104`). If it
   is still open, leave PR_A and PR_B draft, weave both onto the current state, and report
   what they wait on. Do not merge #235 yourself.
4. **Weave.** Rebase PR_A onto #235's final head or the base it merged to, and PR_B onto
   PR_A plus the merged #239, moving both frozen bases.
5. **Evidence.** Re-run `tools/guide-recipes/verify-production.ts` after PR_A's deploy, and
   record `tools/list` and its byte size from production before and after in each PR
   description. Build-time measure, all mounts: 19 tools 13264 bytes, then PR_A 7 tools
   7066 bytes, then PR_B 5 tools 5663 bytes.
6. Check `evaluate` against production for the garden's own callers (`scripts/jobs/minion-town-review-queue/publish.sh`, garden-book): oros-studio has no credentials, so this was not run when they moved.
7. Update each PR's phase ledger to `deliverable` when its evidence is in.

Constraints: no secrets in logs (a locator is a bearer), and no persistent production
guests.
