---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-25T03:15:51Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-25 daily backstop

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260825-025004`.
Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every due open row against live GitHub, base, maturity, advisory,
source, and CI state.

## Live open Dependabot set

Exactly one open `dependabot[bot]` PR: **#1051** (`changesets/action`
1.9.0 → 2.1.0, github-actions). The prior terminal rows (#1052, #1056 merged
2026-08-24; #1055 rejected 2026-08-23; #1007/#1009 merged; #1005 closed
superseded) carry no residue.

## PR #1051 — v2 config migration LANDED; merge HELD pending maintainer decision

The 2026-08-23 escalation to a fixer for the `changesets/action` v2 config
migration had **stalled operationally**: the fixer child was reaper-doomed
(elapsed-constancy, 3 requeues) and the `endojs-endo-but-for-bots-pr1051-v2migrate`
orchestration halted, leaving both children parked in `plan/`. This backstop
re-drove the row directly rather than re-risking the fixer stall.

Re-confirmed live (2026-08-25): pins tag→commit both sides
(v2.1.0 → `198f833dd7d863100ea6e28967bc9a9fdefadb0a` == PR pin;
v1.9.0 → `a45c4d594aa4e2c509dc14a9f2b3b67ba3780d0d` == base pin, annotated tags
dereferenced); advisories empty (actions feed + OSV); maturity floor
2026-08-20 past; single base call site (`.github/workflows/release.yml`) still
on v1.9.0 — genuine live upgrade, not a no-op. `RELEASE_TOKEN` confirmed present
and in active use (checkout token + release step), resolving the prior "does the
token still exist" uncertainty.

Landed the verified, behavior-preserving migration on the head branch as commit
`2c54d39810`: `publish`→`publish-script`, `createGithubReleases`→
`create-github-releases`, token moved to the new `github-token` input (v2 stopped
reading `GITHUB_TOKEN` env), removed the redundant env block, and
`push-with-git-cli: true` to keep v1's git-CLI push (v2's default flipped to the
GitHub API). All four verified against `action.yml`/`src/index.ts` at `198f833`.
25/25 PR checks green on the migrated head; note `release.yml` runs on
`push: master` only, so CI does not exercise it — the migration is validated by
config translation, not CI.

**Held, not conducted.** The one leg CI cannot decide is a release-security
choice: preserve v1's git-CLI push (done) vs. adopt v2's GitHub-API push default.
Surfaced to the maintainer via the liaison (message
`20260825T031444Z-9634bc` to inbox/maintainer) with a recommendation to keep
v1. Merge waits on the maintainer's confirmation; on their "conduct preserve-v1"
reply (dead-lettered to a fresh job if this backstop has completed) or a future
recheck once confirmed, conduct proceeds via
`ci-wait-merge.sh --dependabot-auto-merge`. Verdict comment (superseding the
2026-08-23 escalation verdict) posted disclosing the migration:
https://github.com/endojs/endo-but-for-bots/pull/1051#issuecomment-5404584989

The stalled `endojs-endo-but-for-bots-pr1051-{fixer,conduct}` plan children and
the halted `-v2migrate` orchestration are now superseded (the migration is
landed) and left inert; no withdraw tool exists and the shared journal repo must
not be hand-edited. They will not be promoted (fixer doomed; conduct
orchestrated-gated under a halted orchestration).

## PR #923 — terminal re-confirmation

The schedule's explicitly named row remains CLOSED without merge since
2026-08-10T21:25:33Z (head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`), under its
existing REJECT (stale group, base moved past it) verdict. No disposition or
schedule residue.

The daily backstop remains present and idle-gated.

Self-improvement: nothing this time.
