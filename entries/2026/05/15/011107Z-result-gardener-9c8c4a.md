---
ts: 2026-05-15T01:11:07Z
kind: result
role: gardener
project: garden
refs:
  - entries/2026/05/15/010651Z-dispatch-liaison-9c8c4a.md
  - entries/2026/05/14/225200Z-message-steward-7e3a91.md
  - entries/2026/05/15/003930Z-message-steward-95e217.md
  - entries/2026/05/15/010640Z-message-steward-c4d8e9.md
---

# Result: gardener encoded the operational-flake-handling workflow

Per dispatch `9c8c4a`. Chosen home: **Option A**: a new top-level sub-section `## Operational-flake handling` in `roles/steward/AGENT.md`, placed after Standing monitors (and its Issue surveillance child) and before Understudy presence and shunting. Kept it adjacent to the related discipline sections rather than spinning a new skill, matching the maintainer's framing that the cumulative workflow is "worth its own sub-section rather than scattered rules."

## Files revised

- `roles/steward/AGENT.md`: new sub-section `## Operational-flake handling` with the six-step workflow + a 2026-05-15 Notes-from-the-field row citing the three precipitating message entries. Frontmatter `updated: 2026-05-15`. Commit `fe9fe7d`.
- `roles/shepherd/AGENT.md`: new sub-section `## Operational-flake retirement: re-run before treating as gating` with the defensive-re-run norm and a cross-reference to the steward sub-section. Frontmatter `updated: 2026-05-15`, author adds `gardener`. Commit `9079e2c`.
- `skills/pr-ci-watch/SKILL.md`: notes-from-the-field row dated 2026-05-15 capturing the same defensive rule for any shepherd-side reader. Frontmatter `updated: 2026-05-15`, author adds `gardener`. Commit `2242305`.

Three commits, one per file. Pushed `2dea99b..2242305` to `origin/main`.

## The six-step workflow (one line per step)

1. **Detect**: operational flake = check failing across multiple unrelated PRs with a signature pointing outside the PR's diff.
2. **Broadcast**: `message: steward → *` instructing shepherds to treat the named check as pass-equivalent until further notice.
3. **Resilience PR**: dispatch a builder to harden the workflow (retry windows, fallback endpoints, timeout widening, alternate substitutes).
4. **Merge**: resilience PR merges through the normal chain (maintainer review + conductor).
5. **Retire**: `message: steward → *` that (5a) names the broadcast it retires, (5b) enumerates affected open PRs in `prs:` frontmatter, (5c) re-runs each enumerated PR's failed CI jobs in the same transaction.
6. **Validate or re-broadcast**: read post-re-run check status across the enumerated set; if failures recur, the retirement is invalid and the steward re-broadcasts plus dispatches a higher-iteration resilience PR.

The next retirement message will include step 5c re-runs as part of the same transaction by rule, not as a separate cycle. The shepherd-side defensive re-run in `roles/shepherd/AGENT.md` and `skills/pr-ci-watch/SKILL.md` covers the gap when 5c is somehow skipped.

## Out of scope (per dispatch)

- No new operational-flake broadcast or retirement; the Guile-interop case stays in its post-retirement state with the maintainer-issued re-runs in flight.
- No edit to `skills/monitor-endo-but-for-bots/SKILL.md`; per-event reactions are unchanged.

Self-improvement: nothing this time; the dispatch surfaced the lesson explicitly and the encoding lands on the first pass.
