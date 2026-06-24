---
created: 2026-05-14
updated: 2026-06-24
author: gardener
---

# Skill: rename-discipline

How to decide whether a rename is warranted, and how to keep accidental renames out of a PR's diff. Applies to any gardening step that touches existing identifiers, file names, or test-local bindings: the builder step, the fixer step, the weave/rebase step, and the cleaner step. The stylist jury seat also enforces it during the panel ([`../panel/SKILL.md`](../panel/SKILL.md)).

## The rule

A rename earns its place in the diff only when it carries information. The default for an identifier or file name already present on base is to leave it alone, even when the local context tempts an "improvement". A diff full of gratuitous renames forces the reviewer to disentangle the substantive change from the cosmetic one and trains them to skim places they should read.

## What counts as warranted

- The original name is wrong against current behavior (the function no longer does what its name says).
- The name shadows a binding in scope and the shadow is load-bearing (a test that imports `random` and also defines a local `random` is a real conflict; rename the local with a reason in the commit message or the PR body).
- A project-level naming guide demands the new name (e.g. the project's `kebab-case` module convention).
- The rename is the point of the work (the job says "rename X to Y" or the design document calls for it).

Anything else is presumed gratuitous. If you cannot name the reason in one short sentence on the commit or PR thread, do not rename.

## Specific failure modes

- **Test-local bindings.** A test that destructures `random` from a module and renames it `pickRandom` or `r` locally is gratuitous if no shadow conflict exists. Keep the import name. The reviewer comparing the test to the documented surface should not have to reverse-map names.
- **"Cleanup" passes inside a feature PR.** A feature PR that also renames adjacent identifiers in the same files looks like the rename was part of the feature. It rarely is. Strip the renames out of the feature commit, or land them as a separate prep PR with its own justification.
- **Rename to match an export's qualified form.** Renaming `equals.js` to `bytesEqual.js` because the exported identifier is `bytesEqual` is a stutter; the module-name convention is its own discipline.

## When the maintainer flags a gratuitous rename

The reviewer ask reads "this was better when named X" or "gratuitous rename". The fixer step's response is to revert the rename in the next fix-up commit, not to defend it. A name's prior life on base is itself an argument; the burden is on the renamer to justify, not on the reviewer to prove the old name was acceptable.

If a shadowing or scope conflict actually does motivate the rename, surface that on the thread (`local conflict with the imported \`random\` on L<n>`) and offer the smaller alternative (rename only the local, or rename the import to an alias) before insisting on the broader rename.

## Output

A diff whose renames are all justifiable in one sentence each, and a reverted rename (in a follow-up fix-up commit) whenever a reviewer flags one as gratuitous.

## Notes from the field

- _2026-05-14_: extracted from kriskowal's review of [endojs/endo#3232](https://github.com/endojs/endo/pull/3232), specifically comments [3239081576](https://github.com/endojs/endo/pull/3232#discussion_r3239081576) (test-local rename of `random` with no shadowing) and [3239082370](https://github.com/endojs/endo/pull/3232#discussion_r3239082370) ("Ditto. Gratuitous rename."). Both renames were inside otherwise-substantive consumer-side rewires.
