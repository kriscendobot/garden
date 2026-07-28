The GitHub repo `kriskowal/garden` was transferred/renamed to `kriscendobot/garden`
(confirmed 2026-07-28 via `gh api repos/kriskowal/garden` redirecting to
`full_name: kriscendobot/garden`, not a fork). Git remotes still work fine
(GitHub redirects transparently), but hardcoded doc references to the OLD
Pages URL are now stale and 404:

- `https://kriskowal.github.io/garden/bulletin/` -> should be
  `https://kriscendobot.github.io/garden/bulletin/`

Grep the repo for `kriskowal.github.io` and update every hit to
`kriscendobot.github.io/garden` (confirmed live via `gh api repos/.../pages`
and a 200 on the bulletin URL). Known hits include `CLAUDE.md` (§ Container
guard / monitoring section) and `docs/bulletin/SETUP.md`. Also check for any
other `kriskowal/garden` GitHub URLs (issue links, raw content links, etc.)
that should move to `kriscendobot/garden` for consistency, using judgment
about which references are meant to name the canonical repo (should update)
vs. historical/quoted text (should not).

<!-- garden-reaped: 1 -->

---
claim:
  host: ps23-garden-f65473ae
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-28T20:53:13Z
