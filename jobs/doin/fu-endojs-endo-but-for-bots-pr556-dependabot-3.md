In the garden's own library (kriskowal/garden, `main2`), extend `roles/botanist/AGENT.md`: it is written entirely for npm lockfile bumps but is routinely handed `github-actions` dependabot PRs. Add the check unique to those — verify that a pinned commit SHA in the workflow actually resolves to the tag the PR claims — without rewriting any existing rule (the broader 5-item proposal sitting in `inbox/liaison` is the maintainer's call).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T12:13:23Z
