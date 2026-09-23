---
ts: 2026-05-22T23:27:57Z
kind: result
role: cleaner
worktree: dispatches/cleaner--d38b8f/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/231501Z-dispatch-general-contractor-d38b8f.md
---

PR #337 (feat(daemon,cli): Endo Gateway scaffolding slice 1).

Coverage baseline.
`@endo/where` started at 99.5% stmts / 92.68% branch / 100% funcs / 99.5% lines via `yarn cover`.
The two new functions whose Windows fallback branch was uncovered (`whereEndoGatewayEphemeralState`, `whereEndoGatewayCache`) had already been addressed by a concurrent cleaner pass 35 hours ago (origin commit bf4890e9, "test(where): cover Endo Gateway PROGRAMDATA-undefined Windows fallback"); when I rebased I found my own first commit was a duplicate and dropped it.
Post-rebase baseline is 95.23% branch coverage.

Adversarial pass.
Two invariants on `whereEndoGatewayRegistrarSock` were unasserted: the POSIX delegation through to the gateway's ephemeral-state directory (so `ENDO_GATEWAY_EPHEMERAL_STATE` composes through to the registrar socket path), and the precedence between `ENDO_GATEWAY_REGISTRAR_SOCK` and `ENDO_GATEWAY_EPHEMERAL_STATE` when both are set.
Added one test file extension (one commit) with two new tests pinning both invariants.

Regression evidence.
For the `inherits` test: replacing the registrar's POSIX `ephemeralStatePath` delegation with a hard-coded path fails the new assertion; reverting restores green.
For the `wins over` test: bypassing the `ENDO_GATEWAY_REGISTRAR_SOCK` env check makes the env-override and the new precedence test fail; reverting restores green.

Dead-code audit.
The four new functions (`whereEndoGatewayState`, `-EphemeralState`, `-RegistrarSock`, `-Cache`) are all exported via the package's index.js public surface and typed in `types.d.ts`.
The PR is explicit scaffolding slice 1; consumers (Slice 2+ daemon code) are deferred by design.
Nothing to delete.

Body audit.
PR body matches the diff: file list, "What lands" (4 functions + per-platform tests + minor-version changeset), and "What is deferred" (Slices 2-11) all reflect what is actually in the head commit.
Changeset `endo-where-gateway-paths.md` bumps `@endo/where: minor`, consistent with the additive surface.

Commits landed.
1 commit on feat/endo-gateway, pushed via `git push origin HEAD:feat/endo-gateway`:
- `test(where): assert registrar-socket composition with ephemeral-state override` (304ee587c).

CI status.
All 18 jobs pass on the cleaner's HEAD (304ee587c): browser-tests, build, check-action-pins, cover, lint, test (22.x/24.x ubuntu+macos), test-async-hooks (18/22), test-hermes, test-ocapn-python, test-xs, test262 (22.x/24.x), viable-release, zizmor.
PR remains in draft; next stage is judge.

Self-improvement: nothing this time.
