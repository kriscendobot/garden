---
ts: 2026-06-03T02:47:50Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

PR #394 redesign + #395 / #396 / #397 cascade rebase.

## #394 redesign

SHA: 119d21f45 — refactor(gateway): one-repo-per-daemon, bearer-as-formula-ref shape (#394 review).

Reshape per kriskowal's line 456 directive:

- URL path drops the repo-id segment.
  The three operations are `/git/info/refs`, `/git/git-upload-pack`, `/git/git-receive-pack`.
  The legacy `/git/<repo-id>/<op>` shape now 400s.
- `resolveRepo({ token, repoId })` becomes `serveRepo({ token }) -> DaemonRepoCapability | undefined`.
  The capability is scoped to one formula's ref within the daemon's one Git object store.
- `RepoCapability` -> `DaemonRepoCapability` reflects the new scoping invariant.
- types.d.ts, the makeGateway factory power name, index.js wiring, and the design doc's Feature 3 section all carry the new shape.
- The integration test's `makeHex64` fixture switched from a weak LCG to sha256-of-label.
  This fixed a latent collision (the LCG only used the low 4 bits of state per character; several seeds produced the same output, which would have made `wrongToken === token` in the redesigned auth path).

Pre-push gates: `yarn lint` 0 errors, `yarn lint:types` clean, `yarn workspace @endo/gateway test` 279 / 279 passing.

Regression evidence: deliberately replaced the 401 path with a 200-everything stub.
Both the unit test (`401s when serveRepo returns undefined`) and the integration test (`push with wrong token unexpectedly succeeded`) fail closed under the sabotage.
Sabotage reverted; tests pass on the actual head.

## Daemon-side scope: deferred (option b)

The daemon does not currently embed the gateway or implement a Git-backed CAS.
The gateway-side contract here is the integration point a future daemon-side PR will plug into.

Filed follow-up issue **#407** carrying the full quoted maintainer framing (CAS replacement for Node and Rust, lock care, @0xpatrickdev's library or libgit2, sha256 variant) and referencing the existing overlapping designs (`daemon-git-capability.md`, `daemon-content-store-gc.md`, `daemon-cas-management.md`).

## Cascade rebase

- **#395** (gateway phase 7, formula-backed AppsNameHub): rebased onto 119d21f45.
  New head: **515f7cfbd**.
  Conflict in types.d.ts (the `GatewayPowers` interface gained both `serveRepo` and `appsFormulaStore`; resolved by keeping both).
  Tests: 321 / 321 passing.
- **#396** (gateway phase 8, ResourceLedger): rebased onto 515f7cfbd.
  New head: **dc18b3d90**.
  rerere applied the same conflict resolution; no manual intervention needed.
  Tests: 363 / 363 passing.
- **#397** (gateway phase 9, Familiar-bundled fallback publisher): rebased onto dc18b3d90.
  New head: **32c2f7429**.
  Clean rebase.
  Tests: 397 / 397 passing.

All four pushed via `--force-with-lease` against the prior SHAs.

## Upstream actions taken (under standing relaxation)

- Replied on kriskowal's PR #394 review thread (comment 3345066407) citing the addressing SHA.
- Top-level summary on PR #394 with @kriskowal mention.
- Re-requested review via JSON-body `requested_reviewers` shape.
- Filed issue #407 for daemon-side scope.

Self-improvement: a `makeHex64`-style LCG with `state % 16` chained per output character is a degenerate generator — it collapses to a 16-cycle quickly and ignores the upper bits of any seed.
Two of three test seeds (`0xb0b5c4fe`, `0xfeedface`) produced identical output, which would have silently broken the integration test's auth-deny path if it had ever been exercised on a config where token and wrongToken collided.
The sibling commit 77bebfb1f renamed `repoId` seed to `0xb0b5c4fe` without inspecting the LCG's output for collisions; the redesign here happens to exercise the auth-deny path differently (single bearer token instead of token+repoId pair), which surfaced the latent collision as a hard test failure.
Lesson for the fixer playbook: when a sibling-commit fixer-style change renames a constant in a test fixture (especially a fixture with hand-rolled randomness), validate the renamed value does not collide with siblings in the same fixture before pushing.
The sha256-of-label replacement is the correct shape for a deterministic test fixture and should be the default — handrolled LCGs are not worth their seed-collision risk.
