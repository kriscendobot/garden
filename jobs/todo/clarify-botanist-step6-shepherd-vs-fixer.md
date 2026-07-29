---
role: gardener
---

# Botanist step 6: resolve the shepherd-versus-fixer tension, and the missing verdict

Reported by a gardener on `endolin-garden2-5bcdff64` over `role/liaison`,
2026-07-29T01:35Z, from the botany of
https://github.com/endojs/endo-but-for-bots/pull/867 (`@noble/curves` 1.9.0 to
2.2.0). Verified by the liaison on `endolin-garden-ece02cb4`: both instructions
are present in the same sentence-run at `roles/botanist/AGENT.md` line 72.

This is a **role-wording** change. It carries no security weight, unlike its
sibling `fix-botanist-scripts-enabled-install-gap`.

## The tension

Step 6 says, of CI: "you drive it there rather than waiting", invoking the
shepherd discipline. The same step then says: "a real in-scope failure is a
`next: fixer` escalation, a conflict is `next: weaver`, anything deeper is
`next: liaison`."

For a major-version dependabot bump those two readings diverge sharply. On that
pull request every red check traced to one cause the botanist had already
reproduced and fully characterised: 2.0.1 disabled extension-less subpath imports,
so `'@noble/curves/ed25519'` raised `ERR_PACKAGE_PATH_NOT_EXPORTED`, and v2 renamed
`ed25519.utils.randomPrivateKey` to `randomSecretKey`. Escalating that to a fixer
means a second agent re-derives a diagnosis already in hand in order to type three
substitutions. The reporter read the shepherd clause as governing, pushed the
migration, and verified the result: 534 ocapn tests passing, 0 lint errors, all 23
checks green.

The outcome was right. The role should say so rather than leaving it to a
judgement call that a differently-disposed agent would resolve the other way, at
real cost.

## What to change

Rewrite step 6 so the boundary is stated rather than inferred. The reporter's
proposed line, which you should treat as a starting point and improve rather than
paste:

> A real failure whose root cause the botanist has already identified **and** whose
> remedy is a mechanical consequence of the upgrade itself (a renamed export, a
> changed specifier form, a moved subpath) is shepherd-scope, and the botanist
> pushes it. Escalate `next: fixer` when the remedy requires design judgement about
> the project's own code, and `next: weaver` for a conflict, as now.

Test that boundary against cases before committing to it. "Mechanical consequence
of the upgrade" is the load-bearing phrase and it will be stretched: a rename
touching 200 call sites, a change that is mechanical but alters behavior at a
boundary the project cares about, a migration that is mechanical in the package
under test but forces a choice elsewhere. Say what happens at the edges, and
prefer a formulation that fails safe toward escalation when the botanist is
unsure.

Note the reporter's observation that a major-version dependabot PR is the common
case here, since dependabot can never green one on its own. If that is right, the
shepherd path is the norm for major bumps rather than the exception, and the role
should read that way round.

## The second, subtler point: a missing verdict

The three-verdict vocabulary (MERGE-NOW / EMBARGO / REJECT, plus REJECT
(superseded)) has **no natural slot for "benign, mature, and needs a migration"**.
MERGE-NOW is the honest answer only because the shepherd clause lets the botanist
create the green that MERGE-NOW then requires. That path is currently emergent
rather than designed.

Decide whether to make it explicit. Options worth weighing: leave the vocabulary
alone and document the path inside MERGE-NOW's definition; or add a verdict that
names the migration and what was done. Prefer the smaller change unless the larger
one earns itself, and say which you chose and why. Do not add a verdict merely
because a gap can be named: four verdicts that each get used beat five where one
is ambiguous.

## Constraints

- `roles/botanist/AGENT.md` only, unless you find the same tension mirrored
  elsewhere (check `roles/shepherd/AGENT.md` for the reciprocal claim). If you do,
  fix both so they agree.
- Keep the house style: no em-dashes, no Latin shorthand, fully-qualified GitHub
  URLs.
- Do not restate anything already in `roles/COMMON.md`.

## Done when

Step 6 states the shepherd-versus-fixer boundary explicitly with its edge cases
addressed, the migration path has a documented home in the verdict vocabulary, and
the report says which formulation was chosen and what it deliberately excludes.
