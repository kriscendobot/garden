---
role: builder
tier: mentor
arc: garden-book
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-13T17:49:46Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Publish the post-hyperlink edition of "Better Code and Gardens" as an ocap.site clip

This is the durable successor to `garden-book-publish-ocap-site-20261012`, which
was promoted before its publication prerequisite merged. Repository:
`kriscendobot/garden-book`. Charged to the `garden-book` arc.

Blocked on https://github.com/kriscendobot/garden-book/pull/13, the hyperlink
pass produced by `book-hyperlink-references-after-copyedit-20261004`.

## Preflight

- Confirm PR #13 is actually `MERGED`, not merely closed, and that its reviewed
  hyperlink changes are present on current `main`. If not, stop and preserve the
  publication task behind the exact blocker; never publish the draft branch.
- Confirm PR #8 remains merged and its copy-edit is present on current `main`.
- Read `skills/minion-town-clip-publishing/SKILL.md` in the garden repository
  before publishing. In particular, obey the CSP and reserved-path constraints,
  and pass a deliberately inert pet name for `powers`; never pass `sites` or
  `@agent`.
- Read the project repository's own `AGENTS.md`/instructions and
  `build/README.md`, including any edition-history convention, before acting.

## Publish and verify

Use an isolated project checkout keyed by this successor basename and a clean
checkout of current `main`. Follow the established edition recipe:

```sh
npm ci
npm test
node build/build.mjs chapters out
minion_mcp_prepare
node build/publish.mjs
```

Clips are immutable and content-addressed. Publish a new clip URL; never attempt
to overwrite an older edition with `upgrade`.

Verify the published bytes equal the verified build output. Load the live URL
in an actual browser at phone and desktop viewports, in light and dark color
schemes, and record rendered-DOM observations. Check representative new internal
and external hyperlinks actually resolve. Report anything not actually verified
as not verified.

If the existing project process records editions in `build/README.md`, update it
through a normal PR on `kriscendobot/garden-book` using `ensure-pr.sh`; do not
touch any other project repository. Avoid creating a duplicate PR by running the
helper in discovery mode first.

## Report and notifications

Complete with the new immutable ocap.site URL and exact source commit SHA.
Message the maintainer with the URL through `scripts/jobs/message-user.sh`.
Notify `garden-book-review-supervisor-after-hyperlinks-20261013` of the published
URL and source SHA if that supervisor is still active.

Previous editions, newest first:

- review-economics: https://xddmohl7mf56oiaps45dm6vtoouoxhxkkpocwzuskmwg6mhzggea.ocap.site/
- illuminated: https://dnl43y7ksqqrkfzkzsiyzhfoqks7tnxpedzi7gfymzviqo7uvkda.ocap.site/

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-13T17:50:16Z
