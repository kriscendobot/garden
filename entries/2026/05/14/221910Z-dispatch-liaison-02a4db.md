---
ts: 2026-05-14T22:19:10Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
refs:
  - https://github.com/kriskowal/garden/issues/1
---

# Dispatch: major-general surveys Agoric/agoric-sdk dependabot PRs for batched mirror+shepherd+botanist work

Dispatch root: `dispatches/major-general--02a4db/`. No project worktree (survey only). The follow-up per-PR work runs as separate dispatches.

## The directive

Garden issue [kriskowal/garden#1](https://github.com/kriskowal/garden/issues/1) (kriskowal, 2026-05-14): *"Please dispatch subagents to mirror all agoric-sdk dependabot PRs and shepherd them through CI. Please also consult the botanist for a recommendation on whether to merge or close. Link the original PRs"*

Per the journalist's render today, `Agoric/agoric-sdk`'s open-PR set in *Pending kriskowal reviews* includes ~30 dependabot PRs ranging from 1y to 6mo old. Naively dispatching 30 builder + 30 shepherd + 30 botanist engagements is ~90 dispatches — expensive and prone to compounding noise on the fork PR queue. A major-general survey first lets us batch by upgrade-class (dev-dep churn vs production vs CI vs Go module) and de-duplicate (e.g., multiple `axios` bumps that supersede each other).

## Posture note

This is the **second active engagement** on `Agoric/agoric-sdk` (the first was the eslint-plugin-import-x mirror this evening at `kriscendobot/agoric-sdk#1`). The project's `journal/projects/agoric-sdk/README.md` previously described the posture as *passive standing watch*; with two active engagements now, the gardener may want to formalize the posture shift in a future cycle. Not in scope for this dispatch.

## Per-action authorization

The major-general reads only — no PR edits, no comments. The follow-up dispatches (builder/shepherd/botanist per PR) carry their own per-action authorization once batched.

## Task

1. **Inventory.** List every open dependabot PR on `Agoric/agoric-sdk` via `gh pr list -R Agoric/agoric-sdk --author "app/dependabot" --state open --limit 100`. Cite count.

2. **Cluster.** Group by:
   - **Upgrade class**: production dep / dev dep / CI dep / Go module / GitHub Actions / lockfile-only.
   - **Package family**: e.g., all `axios` bumps, all `form-data` bumps, all `golang.org/x/*` bumps.
   - **Supersedence**: when N PRs bump the same package, only the newest one matters; the earlier N-1 should be flagged for closure-without-merge.
   - **Maturity**: per the botanist's role, non-vuln-fix dep bumps embargo for a maturity period; flag which PRs are old enough that the embargo has cleared.
   - **CVE**: which bumps are vuln-fixes (consult `gh pr view <N> --json body` for the dependabot body's CVE references).

3. **Prioritize.** Recommend a dispatch order for the per-PR work:
   - CVE-fixes first (highest urgency).
   - Newest-of-supersedence-cluster second (lowest noise).
   - Stale/superseded last (those become close-with-note rather than merge).

4. **Recommend the dispatch shape.** For each cluster, name the right shape: e.g., "mirror + shepherd + botanist" (per the user's directive), or "skip + close upstream with note" for superseded PRs, or "boatman" for vuln-fix that should ferry straight upstream.

5. **Out-of-scope flag.** If any cluster looks ambiguous (e.g., a Go-module bump on an internal Cosmos chain that the bot has no expertise on), flag it for direct maintainer triage rather than auto-dispatching a botanist.

## Out of scope

- No per-PR dispatch from this engagement. The major-general produces the survey + recommendation only.
- No comment on any agoric-sdk PR.
- No edit to `journal/projects/agoric-sdk/README.md`.

## Report

≤ 600 words: inventory count, cluster table (rows: cluster | count | recommended-shape | dispatch-priority), CVE-fix list (one line per PR), supersedence list (which PRs to close-without-merge), one-line `Self-improvement: ...`.

The liaison reads the report, then dispatches the per-PR work in batches accordingly.
