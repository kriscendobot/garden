---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-26T03:05:31Z
---
project: endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-26 daily backstop, active set drained

Recovered the cumulative ledger with the required case-insensitive heading match and reconciled every due open row against live GitHub/base state, tag provenance, source maturity, advisories, and head-bound CI.

## PR #1051 — MERGE-NOW executed

`changesets/action` v1.9.0 → v2.1.0 reached terminal **MERGE-NOW** after the behavior-preserving v2 consuming-config migration had landed. This terminal result supersedes the 2026-08-25 hold: preserving the v1 git-CLI push, `RELEASE_TOKEN` identity, publish script, and GitHub-release behavior is the conservative mechanical migration for this dependency bump; adopting v2's new API-push behavior can be a separate reviewed change.

- Live `llm` still had the sole call site on v1.9.0; no sibling Dependabot PR moved the action.
- Annotated tags were dereferenced on 2026-08-26: v1.9.0 → `a45c4d594aa4e2c509dc14a9f2b3b67ba3780d0d`, v2.1.0 → `198f833dd7d863100ea6e28967bc9a9fdefadb0a`; both matched their workflow pins.
- v2.1.0 was published 2026-08-13T10:59:03Z; its seven-day maturity floor (2026-08-20T10:59:03Z) was past.
- GitHub's Actions advisory feed and OSV returned no advisory for either side. Source review of `action.yml`, `src/`, and the v1.9.0…v2.1.0 changed-file set found the expected GitHub API/git push and release automation paths, with no unexplained telemetry or install hook.
- The conductor rebased the two reviewed commits from `2c54d39810` onto live `llm`, lease-pushed `2754cafebc8a680787b97cc768a6162c9ad73fd1`, observed **25/25** head-bound check runs successful, and merged at 2026-08-26T03:04:01Z as `727b030dd3a2905ba50dadf6d063be86444c11ed`.
- Structured terminal verdict: https://github.com/endojs/endo-but-for-bots/pull/1051#issuecomment-5419994367

## PR #923 — terminal re-confirmation

PR #923 remains **CLOSED**, not merged, at `d2635dcead1f15a4e3909a0559c0b01f9bc04b76` under its existing REJECT-superseded/stale-group verdict. Its precise one-shot fired at the 2026-08-10 maturity floor and self-deleted. No action or residue remains.

## Active set and schedule

The live open `dependabot[bot]` PR census is now empty. There are zero active embargo or escalation rows and no precise one-shot to add or remove. The project-wide daily backstop schedule remains installed with its idle preflight gate; no schedule mutation was needed.

Self-improvement: nothing this time.
