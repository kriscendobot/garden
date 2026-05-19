---
ts: 2026-05-19T23:15:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/206
  - https://github.com/endojs/endo-but-for-bots/pull/209
  - https://github.com/endojs/endo-but-for-bots/pull/210
  - https://github.com/endojs/endo-but-for-bots/pull/211
  - https://github.com/endojs/endo-but-for-bots/pull/247
  - https://github.com/endojs/endo-but-for-bots/pull/261
---

# Dispatch: builder replicates llm-branch devDep-cycle-breaking work onto master

Dispatch root: `dispatches/builder--867b8a/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-19): *"Please dispatch a builder to produce a PR based on actual/master that replicates all of the recent changes on the llm branch that paved the way for turborepo by breaking devDependency cycles. These generally were the commits that introduced *-test packages like ses-test and harden-test."*

This is **mirror-prep** work. The llm branch carries five Cuts of the devDep-cycle-breaking design + the design itself. None of it is on master yet. The maintainer wants a master-base PR that replicates the same surface, so the boatman can later ferry it upstream to `endojs/endo@master` (the actual destination). The bot fork's `master` is the staging mirror for upstream.

## Background — what to replicate

Design: [endojs/endo-but-for-bots#206](https://github.com/endojs/endo-but-for-bots/pull/206) — `design(workspace): break devDependency cycles via synthetic test packages`. Design doc lives at `designs/break-dev-dependency-cycles.md` on `llm`. After review the design adopted (a) Option B naming (`@endo/<pkg>-test`), (b) no separate `utils` package, (c) `"test"` exports condition for internal-only test surfaces, then (d) subpath-pattern exports under that condition (per kriskowal's #211 review).

The Cuts as they landed on `llm`:

| Cut | Package | PR | Merge commit | Status on llm |
|---|---|---|---|---|
| **Cut 1** | `@endo/ses-test` (extracted from `@endo/ses`) | [#261](https://github.com/endojs/endo-but-for-bots/pull/261) | — | **OPEN, not yet merged**; branch `feat/ses-test` (HEAD `5f4811ecc`) |
| **Cut 2** | `@endo/hex-test` (extracted from `@endo/hex`) | [#211](https://github.com/endojs/endo-but-for-bots/pull/211) | `68246ad92` | Merged |
| **Cut 3** | `@endo/zip` (devDep cleanup; no `*-test` package — Cut 3 removed unused `@endo/eventual-send` + `@endo/ses-ava` devDeps from `@endo/zip` per design) | [#209](https://github.com/endojs/endo-but-for-bots/pull/209) | `3ca283bf8` | Merged |
| **Cut 4** | `@endo/harden-test` (extracted from `@endo/harden`) | [#210](https://github.com/endojs/endo-but-for-bots/pull/210) | `e56e9940d` | Merged |
| **Cut 5** | `@endo/eventual-send-test` (extracted from `@endo/eventual-send`) | [#247](https://github.com/endojs/endo-but-for-bots/pull/247) | `c72d2a31f` | Merged |

The follow-up `chore(harden-test,hex-test): add missing SECURITY.md files (#245)` (commit `ea4d07bb1`) is a small hygiene commit you should also bring across.

The design-doc fixup commits on llm (`ea0933857`, `84c03cf33`, `686de4e94`, `fddfcae8b`, `9a30ff80b`, `616021230`) reflect the iteration the design itself went through. For master-mirror purposes you only need the **final design state on `origin/llm`** (HEAD `0ec70c6dd`, file `designs/break-dev-dependency-cycles.md`) — squash the fixups into the design commit; the maintainer reviewed all of them on llm already.

## Task

Read `garden/roles/COMMON.md` + `garden/roles/builder/AGENT.md` first.

1. **Inventory** the llm-side state (on `endojs/endo-but-for-bots@llm`) by reading:
   - `designs/break-dev-dependency-cycles.md` — the design as it stands on llm HEAD.
   - The five Cuts via `git show` on each merge commit (or `gh pr view <n> --json files`).

2. **Decide shape** — single bundled PR vs. stacked sequence:
   - **Shape A — single bundled PR** (one branch with ~6 commits: design + 5 Cuts + SECURITY hygiene; or squashed differently). Smaller dispatch surface; one CI gate; the maintainer can review side-by-side with the merged llm series. **Recommended unless the diff is unreviewable in one PR.**
   - **Shape B — stacked sequence of 5 PRs** mirroring the original landings, each based on the prior. More faithful to the original review flow but ~5x the orchestration overhead.

   Document the choice + rationale.

3. **Implement** on master-base branch `feat/break-devdep-cycles-master` (Shape A) or `feat/break-devdep-cycles-master-cut-<N>` (Shape B):
   - Bring across the design doc (final form on llm).
   - Replicate each Cut as a commit; preserve the conventional-commit subject of the merge commit on llm (e.g., `chore(hex,hex-test): break devDep cycle via @endo/hex-test (Cut 2 of #206 design)`).
   - Include the SECURITY.md hygiene commit from `ea4d07bb1`.
   - Cherry-pick is appropriate IF the cuts apply cleanly on master; otherwise reconstruct manually from the diff.
   - **Cut 1 (`@endo/ses-test`)**: include in the mirror PR, using `endojs/endo-but-for-bots@feat/ses-test` as the source. That branch is stale on llm (carries pre-llm-rebase removals like `turbo.json` deletion that shouldn't appear in a master-base PR). Take only the `ses` → `ses-test` extraction parts and the `package.json`/`exports` changes; drop anything that touches turborepo, security-md script, etc. Mention in the PR body that this mirrors the *intent* of #261 even though #261 hasn't landed on llm yet.

4. **Implementation targeting per design commit `84c03cf33`**: "implementation targets endojs/endo master, not the bot fork". For us, that translates to: this mirror PR's tree should be what we'd want the boatman to ferry to upstream `endojs/endo@master` verbatim. Don't sneak in bot-specific things.

5. **Local validation**:
   - `yarn install` clean.
   - `yarn lint` — repo-wide; the design's `"test"` exports-condition setup has specific lint implications.
   - `yarn workspaces foreach -A -v --include '@endo/{ses,ses-test,hex,hex-test,harden,harden-test,zip,eventual-send,eventual-send-test}' run test` (or analogous; you may need to invoke per package).
   - Run `node scripts/dependency-graph.js` (if it exists; the design mentions a dependency-graph audit script) to confirm zero non-trivial SCCs in the devDep graph after the cuts apply.

6. **Per today's recurring self-improvement**: commit + push BEFORE extended local validation. Force-push to your branch with lease for any cleanups.

7. **Conventional commits** per the originals (preserve the subjects from the llm merge commits). The `chore: Update yarn.lock` shape from `skills/yarn-lock-separate-commit/SKILL.md` applies — at minimum, the lockfile churn should ride its own commit.

8. **Open as DRAFT PR** against `endojs/endo-but-for-bots`'s `master`. Branch: `feat/break-devdep-cycles-master` (Shape A) or per-cut branches (Shape B).
   - Title (Shape A): `chore(workspace): break devDependency cycles via synthetic test packages (mirror of llm Cuts 1-5, refs #206)`.
   - Body: cite the design (#206), each of the merged llm-side PRs (#209, #210, #211, #247), the still-open #261, and explicitly name the staging-mirror intent. The boatman will ferry this upstream to `endojs/endo@master` under kriskowal identity in a separate dispatch from the maintainer's host.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to `feat/break-devdep-cycles-master*` branch(es), open draft PR(s). READ-ONLY on `endojs/endo` upstream (boatman handles ferry separately). No `master` push.

## Out of scope

- No upstream ferry — boatman does that in a follow-up dispatch.
- No turborepo adoption on master in this PR. Turborepo (PR #121 on llm) is a follow-up that depends on this cycle-breaking work landing first. Don't bring `turbo.json` or `turbo` as a devDep in this PR.
- No comments on the original llm-side PRs (#206, #209, #210, #211, #247, #261).
- No un-draft. (Cleaner + judge run separately per the gamut if the maintainer wants them.)
- No edit to the design's intent. If the design's final form on llm has bugs, that's a separate dispatch.

## Report

≤ 500 words: PR URL + head SHA, shape chosen (A or B) + rationale, files added/moved/modified (one-line each per Cut), per-cut SCC count if dependency-graph script ran, local-validation outcome, any deviations from the original llm-side surface (with citations), one-line `Self-improvement: ...`. The liaison adds a bulletin row.
