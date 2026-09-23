---
job: 1077c8
posted_by_role: liaison
posted_by_host: endolinbot
posted_at: 2026-05-19T03:06:07Z
verb: fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 109
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/109
preconditions: []
claimed_by_role: general-contractor
claimed_by_host: endolinbot
claimed_by_session: 11ad
claimed_at: 2026-05-19T03:14:00Z
completed_at: 2026-05-19T03:24:11Z
outcome: done
result_entry: entries/2026/05/19/032256Z-result-fixer-037980.md
---

# Fix: address `syrups` → `syrup` (singular) on endojs/endo-but-for-bots#109

PR: `feat(syrup-frame): syrup-frame package and opt-in framing for OCapN TCP-for-testing`. Head `aeaecfcc7`. Branch `feat/syrups-package`.

The maintainer flagged at 2026-05-14T21:56-21:57Z that the package should be **syrup** (singular), not **syrups**. Two specific anchors:

- **`packages/ocapn/src/netlayers/tcp-test-only.js:32`** — *"Call it syrup, please. Not syrups."*
- **`.changeset/ocapn-tcp-syrups-framing.md:1`** — *"s/syrups/syrup in the file name. Please address syrups in the description: should be simply framing: syrup."*

The liaison flags: there are **still** references to `syrups` in #109. The kriscendobot response earlier reframed the README but did not finish the rename sweep.

## Task

1. `grep -rin "syrups\?" packages/ .changeset/ designs/` (case-insensitive) on the PR's head. Inventory every match.
2. Replace `syrups` (plural) with `syrup` (singular) in:
   - Source files (imports, identifiers, prose comments)
   - Markdown docs (READMEs, CHANGELOG, design refs)
   - Changeset files including the `.changeset/ocapn-tcp-syrups-framing.md` *filename itself* (rename to `ocapn-tcp-syrup-framing.md`) and its description body
   - Branch name `feat/syrups-package` — note: do NOT rename the branch (force-pushing to a renamed branch is destructive; the branch name is not a blocker to merge). Add a one-line note in the result that the branch retains the plural; the maintainer can rename at merge-time.
   - **The package directory itself** if `packages/syrups/` exists → `git mv packages/syrups/ packages/syrup/`. Adjust workspace package.json paths + every import that references `@endo/syrups` or relative paths to that dir.
3. **Do not touch** legitimate plural English usages where they appear (e.g., "the family of syrup-like framings" if any). Use judgment; the maintainer's directive is specifically the package name + spec name.
4. Local validation:
   - `yarn install`
   - `yarn lint`
   - `yarn workspace @endo/syrup test` (renamed package)
   - `yarn workspace @endo/ocapn test` if the rename touched ocapn imports
5. Per today's self-improvement: commit + push BEFORE extended local validation. Force-push with `--force-with-lease=feat/syrups-package:aeaecfcc7`.
6. Conventional commits — likely two commits:
   - `chore(syrup): rename @endo/syrups package to @endo/syrup per maintainer`
   - `chore: Update yarn.lock` (separate, per skills/yarn-lock-separate-commit/SKILL.md)
7. Reply to each unresolved review thread (the two anchors above) per `skills/pr-review-thread-replies/SKILL.md` confirming the rename landed.

## Per-action authorization

Standing on endo-but-for-bots: force-push to `feat/syrups-package` with lease. READ-ONLY on `endojs/endo`.

## Out of scope

- No upstream ferry — boatman handles when authorized.
- No un-draft (already non-draft).
- No content changes beyond the rename.

## Report

Files renamed (one-line each), grep before/after match counts, commit SHAs, CI status, one-line `Self-improvement: ...`.
