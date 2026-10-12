---
gate: blocked
blocked_on: book-hyperlink-references-after-copyedit-20261004
priority: normal
posted_by: producer
posted_at: 2026-10-12T20:08:14Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Publish the next edition of "Better Code and Gardens" as an ocap.site clip

Maintainer ask (kriskowal, 2026-10-12): continue publishing the garden book as an ocap.site.
Repository: `kriscendobot/garden-book`. Charged to the `garden-book` arc.

Parked behind `book-hyperlink-references-after-copyedit-20261004`, which itself waits on
PR #8 (reader-exposure copy-edit) merging. So the edition published here contains the
copy-edit and the hyperlink pass. Previous editions, newest first:
- review-economics edition: https://xddmohl7mf56oiaps45dm6vtoouoxhxkkpocwzuskmwg6mhzggea.ocap.site/
- illuminated edition:      https://dnl43y7ksqqrkfzkzsiyzhfoqks7tnxpedzi7gfymzviqo7uvkda.ocap.site/
Clips are immutable and content-addressed, so each edition gets a NEW URL; never try to
overwrite an old one (`upgrade` cannot rewrite live content).

## Preflight
- Confirm PR #8 merged and the hyperlink job's work is on current `main` of
  `kriscendobot/garden-book`; if not, stop and park another blocked notice.
- Read `skills/minion-town-clip-publishing/SKILL.md` first (CSP, reserved path prefixes,
  and the 2026-10-01 caution: pass a deliberately INERT pet name for `powers`, never
  `sites` or `@agent`).

## Procedure (same recipe as the 2026-10-04 publishes)
From a clean checkout of `main`: `npm ci`, `npm test`, `node build/build.mjs chapters out`,
`minion_mcp_prepare`, `node build/publish.mjs`. Verify the published bytes equal the
verified build output, and load the live URL in a browser (phone and desktop, light and
dark) to confirm it renders; check the new internal and external hyperlinks resolve.

## Report
Complete with the new URL and the commit sha published. Update the edition history in
`build/README.md` through a normal PR on `kriscendobot/garden-book` only if the existing
process does so; do not touch any other repo. Message the maintainer with the URL via
`scripts/jobs/message-user.sh`.
