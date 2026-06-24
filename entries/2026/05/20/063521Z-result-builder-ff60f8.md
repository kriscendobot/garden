---
ts: 2026-05-20T06:35:21Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--ff60f8
---

G5 from PR #231 (`designs/familiar-release.md`) implemented: bumped the familiar app's bundled Node binary pin from `v20.18.1` (Node 20 Iron, EOL April 2026) to `v22.22.3` (Node 22 Jod, Maintenance LTS, latest patch as of 2026-05-13).

Branch: `chore/familiar-lts-node-pin` off `llm`.
Commit: `bc2882959 chore(familiar): bump bundled Node pin to v22.22.3 LTS`.
PR (DRAFT): https://github.com/endojs/endo-but-for-bots/pull/316.
Affected package: `@endo/familiar`.

LTS choice: Node 22 over Node 24. As of 2026-05-19 both are currently-supported LTS (22 in Maintenance, 24 in Active). The maintainer's directive allowed either. Picked the more conservative line for an MVR release artifact. The new `engines` field admits both `^22.0.0 || ^24.0.0` so a downstream installer is not artificially constrained to one.

Lockstep bumps applied in three places: `packages/familiar/scripts/download-node.mjs` default, `packages/familiar/scripts/download-node.sh` default, and `.github/workflows/familiar-release.yml` invocation. Added comment at each call site naming the lockstep relationship so a future bump does not drift.

Did not include: an `engines` bump on the root `package.json` (its `>=16` is stale but out of scope for G5, which is the familiar-app pin); the CI matrix in `.github/workflows/ci.yml` (Node-20-drop is being handled in a separate pipeline already in flight per PR #232); a Node-20-removed scout pass on bundled-binary callers in other packages (familiar is the only consumer of the bundled-binary scripts).

Pre-push gate: ran `pre-push-gates.sh --summary` from the project root. Prettier and lint passed for the changed files. The probe pass surfaced pre-existing repo-wide findings (bare `#N` refs, divergent `SECURITY.md` hashes, inline `import()` JSDoc) — none introduced by this diff; verified by re-running each probe rule against the five changed paths. The probes' fallback base-detection used `master` because the branch has no upstream at pre-push time, which widens the scan beyond the actual diff; that's a probe ergonomic issue worth noting (see self-improvement).

Did not run: `yarn typecheck` (familiar has no `tsc --build` script wired in; `yarn lint:types` runs as part of `yarn lint`, which passed). No tests under `packages/familiar/` to run.

No yarn.lock change (no dependency added or removed).

Self-improvement: the `pre-push-gates.sh` probes fall back to `git diff origin/master...HEAD` when no upstream is configured for the current branch. On `endojs/endo-but-for-bots`'s `llm` branch (the natural base for design-adjacent work), the fallback widens the scan to the entire `master`-vs-`llm` divergence and floods the report with pre-existing findings unrelated to the current diff. A small probe-driver tweak — fall back to the dispatch's known base (passed via env or read from `.git/HEAD`'s tracking config when present, or default to `llm` for this repo when the cached diff is non-empty but the filtered subset is empty) — would let the gate cleanly report "no findings in your diff" on llm-based work. Routed as a `message` to liaison.
