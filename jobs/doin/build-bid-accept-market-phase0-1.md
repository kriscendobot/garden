# Build: bid/accept market — Phase 0/1 (opt-in field + shadow reputation ledger)

Kind: build. Repo: kriskowal/garden (main2). Origin: maintainer review on PR #16
(kriskowal approved the design and asked to "dispatch a builder").

Implement the FIRST mergeable increment of the approved design
`designs/gardener-bid-accept-market.md` (§6 phased rollout). Do NOT try to build
the whole market in one PR — land the additive, zero-behavior-change base:

- **Phase 0** — add a `market: race | bid` job-frontmatter field, defaulting to
  `race`. A `race` job takes exactly today's `claim-job.sh` path (no code-path
  change for existing jobs). Only `market: bid` would enter the (future)
  handshake; a `bid` job may be posted but the bid/accept machinery itself is a
  later increment — this PR just plumbs the field + defaulting + a no-op guard.
- **Phase 1** — stand up an append-only `reputation/` ledger and record
  accept/reject events for all jobs (retroactively from `tada`) in SHADOW: the
  ledger accrues but never affects selection yet. Surface shadow scores where the
  bulletin already reports, for maintainer sanity-check.

Constraints (from the design): every transition a single-writer fast-forward
push — NO lock service, the push stays the serialization point; rollback is a
one-field revert; the broker (bid selection) and the oracle (acceptance, §4) are
distinct. Terminology note: the design renamed the bid-award entity to **broker**
(not "selector") per the maintainer's review — use "broker" in any new code/docs.

Run the full build gauntlet (researcher precedence, panel, local-verify). Open a
DRAFT PR against main2 and run the PR-creation chain to termination. This is garden
infra on main2 — build in an isolated worktree off origin/main2.

---
claim:
  host: endolinbot2
  gardener: 98
  claimed_at: 2026-07-01T00:13:34Z
