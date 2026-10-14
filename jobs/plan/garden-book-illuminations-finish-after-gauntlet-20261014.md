---
gate: blocked
blocked_on: kriscendobot-garden-book-pr15-gauntlet
priority: high
role: builder
arc: garden-book
posted_by: gardener
posted_at: 2026-10-14T04:50:23Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish garden-book illumination merge and immutable republication

This is the durable continuation of `garden-book-illuminations-republish-20261014`. It owns **all remaining work** after the already-posted staged gauntlet `kriscendobot-garden-book-pr15-gauntlet` completes. The originating maintainer request explicitly authorizes merging the resulting garden-book PR(s) after a clean gauntlet and publishing a new immutable ocap.site edition.

Project PR: https://github.com/kriscendobot/garden-book/pull/15
Current reviewed candidate head at handoff: `bc42bef1a2adf2f093a130fdf53b80256f7ea07d`
Project branch: `garden-book-illuminations-republish-20261014`
Garden skill safety fix already landed on `main2`: `320cfbed282`.

The investigation found a quality defect, not missing files or old-edition confusion: all 25 procedural SVGs rendered correctly in every supplied edition, but were primitive/repetitive and illegible at phone width. PR #15 replaces them with 25 independently generated OpenAI illuminated-manuscript WebPs, adds binary build/publish support and accessible image markup, removes the procedural generator plus superseded legacy SVGs, and includes prompt/evidence/contact-sheet records. Local verification before handoff: `npm ci`, 59/59 tests, 27-file build, illumination browser check at phone light/dark, and full-book browser check at phone/desktop light/dark; all clean.

Required remaining steps:

1. Confirm `kriscendobot-garden-book-pr15-gauntlet` completed successfully and PR #15 is open, mergeable, un-drafted, exact-head reviewed, and green or has no checks. If the gauntlet fixed the branch, adopt its exact remote head and re-run project tests/build/browser checks. Never merge a red, conflicted, draft, or failed-gauntlet PR.
2. Follow `roles/conductor/AGENT.md`: retarget the frozen `main-5acd916` base to live `main`, safely rebase if needed, preserve the PR tree, then merge with a merge commit. The originating maintainer authorization is explicit. Sweep frozen bases afterward with `scripts/jobs/gardening/sweep-frozen-bases.sh kriscendobot/garden-book 15`.
3. Fetch the merged live `main`, run `npm ci`, `npm test`, and `node build/build.mjs chapters out` from the merge. Follow `skills/minion-town-clip-publishing/SKILL.md`; use the checked `build/publish.mjs` inert `garden-book-*` powers pet, never `sites` or any `@` name. Publish a **new** immutable clip, never `upgrade`.
4. Compare every served byte with the 27 local build outputs; verify immutable headers. Run the live page in real Chromium at 390×844 and 1440×900, light and dark. Confirm all 25 illuminations actually decode/render, every manifest placement is present, the nine charts and glyph sprite still render, and there is no overflow/clipping/overlap. Report the new URL only after these checks pass.
5. Record the edition in `build/README.md` with date, PR/merge SHA, build hashes, live byte comparison, and browser evidence, using garden-book PR #14 as the pattern. Open this history PR only via `ensure-pr.sh`, run one staged gauntlet, merge it only if clean, and sweep its frozen base.
6. Send the maintainer one concise message with the quality root cause, PR link(s), and verified new URL using `message-user.sh`.

Do not republish the old edition, do not omit the history update, and do not end while CI or a staged gauntlet is merely pending. If another quota gate intervenes, post one new blocked successor owning everything still outstanding and use the honest handoff marker.
