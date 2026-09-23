---
ts: 2026-05-14T22:36:03Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo
    pr: 3258
    role: source-of-narrow-version
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source-of-narrow-version
---

# Dispatch: builder authors master-base general package-uniformity checker (broadens scope of endo#3258)

Dispatch root: `dispatches/builder--0f0b5e/`. Project worktree on `endojs/endo-but-for-bots@master` (detached).

Maintainer directive (2026-05-14): *"I cannot find a mirror for https://github.com/endojs/endo/pull/3258 the security PR. But, we need to recreate it, based on master, and expand its scope. Please dispatch a fixer to redraft this change as a more general package uniformity checker."*

User said "fixer"; the work is authoring net-new logic (extending a script + adding ci.yml hooks + fixing any per-package drifts that surface). That's build-shaped; dispatching builder. (Per the vocabulary landed today, "fixer" applies when addressing review feedback; here there's no inline review — the maintainer is widening scope.)

## What to author

A general **package-uniformity checker**, generalizing the existing `scripts/check-security-md.sh` (`@endo/endo-but-for-bots#228`, ferried to upstream as `endojs/endo#3258`). The reference / source-of-truth is the **skel package** (`packages/skel/` is the conventional name for endo's "stamp a new package from this template" boilerplate; the builder verifies the actual location).

### Checks the script must enforce per package

For every workspace package (every `packages/*/` with a `package.json`):

1. **`SECURITY.md` byte-identical to `packages/skel/SECURITY.md`**.
2. **`LICENSE` byte-identical to `packages/skel/LICENSE`** (or `LICENSE.md`; whichever the skel uses).
3. **`package.json` field uniformity**, via `jq` automation:
   - `author` same as skel's `author`.
   - `repository` link is correct: the repo URL points at `endojs/endo` (or wherever skel says), AND `repository.directory` matches the package's directory (e.g., `packages/<name>`).
   - `name` matches the directory (i.e., for `packages/<name>/`, the `package.json#name` ends with `<name>` after the `@endo/` scope).
   - `description` differs from skel's default placeholder AND is non-empty.
   - **Other homogeneous fields**: the builder surveys the existing packages to identify which `package.json` fields are uniform today (`license`, `engines`, `publishConfig.access`, `type`, `scripts`'s `prepack` / `postpack`, etc.) and adds checks for those. Pick fields where >80% of packages agree; flag the rest as out-of-scope for v1.

### Implementation

- Author or rename `scripts/check-package-uniformity.sh` (replaces `scripts/check-security-md.sh`; keep the old name as a thin wrapper or delete + update the `.github/workflows/ci.yml` reference). The script uses `jq` for the JSON field checks.
- Wire it into `ci.yml`'s `lint` job (the existing wiring at `ci.yml:67-68` per the gardener's earlier exploration; replace the call to `check-security-md.sh` with the new script).
- The script must fail closed (exit 1 on any drift); print drift per package per check.

### Existing drift to fix

The builder runs the new script and surfaces per-package drifts. For each drift, the builder fixes the package's file/field (NOT the script — the script is the rule; the per-package fix is the data). Fixes go in the same PR. If a particular drift requires a maintainer decision (e.g., the package's `description` is genuinely different from skel's because the package has a unique purpose), the builder writes the package-specific `description` in the package's `package.json` and notes the decision in the commit message.

## Per-action authorization

Standing on endo-but-for-bots: push, open draft PR.

## Task

1. Locate the skel package on bots-side master. Read its `SECURITY.md`, `LICENSE`, `package.json`. These are the source-of-truth.

2. Author `scripts/check-package-uniformity.sh` per the checks above. Use `jq` for `package.json` field comparisons. The script is the rule; the package data is what fails closed.

3. Wire into `ci.yml`'s `lint` job (replace the `check-security-md.sh` invocation with the broader script). Keep `check-security-md.sh` only if other consumers reference it; otherwise delete.

4. Run the new script. Surface every drift. Apply per-package fixes:
   - Copy `packages/skel/SECURITY.md` into any package that has a different byte-identical content.
   - Copy `packages/skel/LICENSE` similarly.
   - Update each `package.json` field that diverges from skel's pattern (per the checks above).
   - For `description`: each package's description must be unique (not skel's default) AND non-empty. The builder either uses an existing readme-derived description if one exists, or writes a minimal package-specific description from the package's purpose.

5. Branch off master as `chore/package-uniformity-master`. Commit shape:
   - One commit for the script + ci.yml wire.
   - One commit per logical batch of per-package fixes (e.g., one for SECURITY.md copies, one for LICENSE copies, one for repository.directory fixes, one for description fills).
   - One `chore: Update yarn.lock` if any package.json change touches dependencies (unlikely).

6. **Open as DRAFT PR** against `master` per the new flow. Branch `chore/package-uniformity-master`. Title: `chore: general package uniformity checker (broadens endojs/endo#3258 scope)`. Body cites the original endo#3258 + bots#228 + the maintainer's directive 2026-05-14 to expand scope.

7. **Do NOT un-draft.** Per the new flow, the cleaner → judge → fixer-loop runs. The judge un-drafts.

## Out of scope

- No comment on upstream `endojs/endo#3258`. The boatman (sibling dispatch `1a294d`) is currently re-syncing upstream #3258 to the narrower bots-side llm state; the broader PR here, once approved, becomes the new ferry source via a future boatman dispatch.
- No fork-side close of `endojs/endo-but-for-bots#228` (already merged; nothing to close).
- No edit to llm-side scripts/check-security-md.sh (this dispatch is master-side only).

## Report

≤ 500 words: PR URL, head SHA, checks-enforced list (one line per), drift-fixes-applied count and one-line summary per per-package fix batch, CI status (lint should pass on the new script after all drifts are fixed), one-line `Self-improvement: ...`.
