---
ts: 2026-05-13T21:25:01Z
kind: result
role: gardener
refs:
  - entries/2026/05/13/211936Z-dispatch-liaison-25a962.md
---

Journalist now omits PRs from archived repositories before classification. The rule lives in `roles/journalist/AGENT.md` as a dedicated bullet between *Source of truth for PRs* and *Classification rule*, citing `gh repo view <owner>/<repo> --json isArchived --jq .isArchived` as the discovery query and naming `/tmp/garden-review-queue/archived.json` as the daemon-side cache. If `isArchived` is absent on a row, the journalist treats it as `false` (do not drop); the `tick` summary records the per-cycle drop count without listing rows.

Daemon was extended. `current.json` did not previously carry `isArchived`, so the review-queue-poll daemon now caches a per-repo boolean in a new `archived.json` state file keyed by `owner/name`, with a 24-hour TTL. On miss it calls `gh repo view <repo> --json isArchived --jq .isArchived` (one REST call per distinct repo on first poll after a restart, zero in steady state). The flag is replayed onto every `current.json` row alongside `baseRefName`, mirroring the per-row pattern the earlier `baseRefName` extension landed. Fetch failures preserve the prior known value rather than overwriting it.

Commits on `main`:

- `2ab55db` journalist: omit PRs from archived repositories before classification
- `ea6f3f6` review-queue-poll: cache isArchived per repo (24h TTL), replay onto rows

Both pushed to `origin/main` on the first attempt.

Daemon restart: killed pid 136589, respawned from `/home/kris` (the standing garden checkout, fast-forwarded to `origin/main` first so it picked up the new script) at pid **140488**. First poll cycle completed at 21:24:41 with 99 rows, 13 distinct repos cached. Verified: `uber-archive/idl` flips `isArchived: true`, and PRs `uber-archive/idl#89` and `uber-archive/idl#90` now carry the field. The next journalist dispatch will drop both rows before classification.

Self-improvement: the per-row baseRefName cache and the per-repo isArchived cache both follow the same shape (carry forward previous values, fetch only on miss, persist atomically alongside `current.json`). If a third such field arrives (e.g., per-PR mergeable state), the daemon will accrete a third ad-hoc cache and the loop body will sprawl. A future grooming pass could factor the cache-and-replay pattern into a small helper in the daemon, but it is not yet duplicated enough to warrant the change today. Nothing for the role library this turn.
