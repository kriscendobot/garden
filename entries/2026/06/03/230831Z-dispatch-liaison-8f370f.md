---
ts: 2026-06-03T23:08:31Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--8f370f
prs: []
refs:
  - entries/2026/06/03/230622Z-result-shepherd-6fa598.md
---

# dispatch: fixer — fix zizmor `changesets/action` pin-comment drift (master-side)

Shepherd `6fa598` classified the zizmor failure on #411 as
real-but-on-master. Auto-chain per memory rule.

## Root cause (per shepherd)

`.github/workflows/release.yml:63` pins
`changesets/action@63a615b9...` with comment `# v1`. Upstream
moved the floating `v1` tag at 2026-06-03T07:05:44Z from
v1.8.0 (`63a615b9...`) to v1.9.0 (`a45c4d594aa4...`). zizmor
now flags this as "mismatched version comment."

## Decision: pin vs bump

Two options:
- **Option A** (defensive, smaller diff): change the comment
  from `# v1` to `# v1.8.0` to match the pinned SHA. Keeps
  the action at the pinned commit. Safe.
- **Option B** (bump): update both SHA and comment to v1.9.0
  (SHA `a45c4d594aa4...`).

**Recommend Option A** — defensive pin-to-specific is what
zizmor's `mismatched version comment` rule expects; pinning
to `# v1.8.0` keeps the comment honest. The user-visible diff
is two characters (`v1` → `v1.8.0`).

Use judgment if you see a reason to bump.

## Procedure

1. Branch off `origin/master` (`ba26f4cdb`). Branch name
   suggested: `chore/release-pin-changesets-v1.8.0` (or
   similar).
2. Edit `.github/workflows/release.yml:63` to change `# v1`
   → `# v1.8.0` (or to bump SHA + comment if Option B).
3. Commit:
   ```
   chore(ci): pin changesets/action comment to v1.8.0 to match SHA (zizmor mismatched-version-comment fix)
   ```
4. Open DRAFT PR against `master`. Title:
   ```
   chore(ci): pin changesets/action comment to v1.8.0 (zizmor fix)
   ```
   Body: brief explanation of the upstream tag drift + reference
   to shepherd's classification.
5. PR opens against bare master (no frozen-base snapshot
   needed for a 2-character workflow fix).
6. Don't un-draft (gauntlet will pick up, OR a fast-path
   review from the maintainer can un-draft + merge).

## Per-action authorizations

- Branch off `origin/master`. Authorized.
- Edit `.github/workflows/release.yml`. Authorized.
- One regular commit + push to new branch. Authorized.
- Open DRAFT PR. Authorized.

## Not authorized

- Force-pushing.
- Editing #411's branch (this is a separate chore PR).
- Touching upstream endojs/endo (boatman's job; ferry only
  after maintainer signoff).
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--8f370f/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--8f370f/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `master` (head
`ba26f4cdb`).

## Report

A `result` journal entry. Include:

- New branch + head SHA.
- PR number + URL.
- Option A vs B choice + reason.
- New text in release.yml line 63.
- Judgment calls.
