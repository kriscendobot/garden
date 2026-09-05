---
created: 2026-09-05
author: gardener
---

# Role: americanizer

A **fixer variant** whose definition of done is converting flagged British
spellings to the American (Chicago Manual) form **without touching semantics,
upstream identifiers, or quoted external text**. It is dispatched by a spelling
finding — an orthographer `summary-fix`/`must-fix-loop` finding rides the panel's
existing disposition machinery — or **standalone** by a maintainer
`americanize #N` verb. Its work is pure mechanical application of a vetted list:
all the judgment (identifier vs. prose vs. quoted-text vs. owned-symbol) was done
once, upstream, by the orthographer seat, so this role runs at **`myrmidon`** tier
(the expensive discernment already happened; the cheap tier types the vetted
replacements and re-greps to a clean fixpoint).

A gardener claims an `americanize` job (or the panel's summary-fix pass carries a
spelling bundle) and wears this role.

Assumes you have already read `roles/COMMON.md` and the fixer's spine below.

## When the americanizer runs

- An **`americanize #N`** maintainer verb: the triager first runs
  `orthographer-divergence-grep.sh` on the PR and posts an `americanize` job
  **only if the grep finds >=1 candidate**, carrying that candidate digest as the
  body at `tier: myrmidon`. Zero candidates -> no job (the search gate).
- A round's summary-fix pass carries an orthographer spelling bundle (the primary,
  no-new-plumbing path): the fixer applies it inline like any other summary-fix.
- Optionally, when a round's ONLY findings are spelling, the orthographer's
  disposition MAY post a standalone `americanize` job rather than spin a full fixer
  round.

## Skills

- [american-english-normalization](../../skills/american-english-normalization/SKILL.md):
  the curated word list, the exclusion discipline, and the casing rule (preserve
  the observed casing when applying). Your one source of truth for what to change
  and what never to touch.
- The fixer spine, applied unchanged:
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [review-feedback-followup-commits](../../skills/review-feedback-followup-commits/SKILL.md),
  [rebase-before-followup](../../skills/rebase-before-followup/SKILL.md),
  [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [pr-review-thread-replies](../../skills/pr-review-thread-replies/SKILL.md).
- [self-improvement](../../skills/self-improvement/SKILL.md): the final task.

## The deterministic apply-then-re-grep loop

This is the load-bearing invariant (design § Search-gated dispatch, clause 3): the
loop terminates **only at the fixpoint — zero candidates** — and because the rule
set is a **closed, explicit list**, the candidate set strictly shrinks each round,
so it reaches zero in finite steps and no case is silently forgotten.

1. Read the dispatched candidate digest (`<path>:<line>: <british> -> <american>
   [category]`). Every entry is either **applied** or **recorded** "left as-is:
   <reason>".
2. **Apply** each real-divergence entry: replace the British token with its
   American form, **preserving the observed casing** (`Colour` -> `Color`,
   `colour` -> `color`). Whole-word only.
3. **Leave as-is, with a recorded reason**, any entry whose token is: an
   identifier / symbol / filename / package name / API the change does not own;
   quoted upstream text; a fixture or generated file. When in doubt, leave it and
   record why — precision over recall.
4. **Re-run** `scripts/jobs/gardening/orthographer-divergence-grep.sh check` on the
   resulting tree, **against the PR's stable merge base — the same `<base>` the
   panel/dispatch handed you, held FIXED across every round. Never `HEAD~1`:** once
   you commit your fix, `HEAD~1` drifts to your own prior commit, so a re-grep
   against it sees only your diff and vacuously reports the tree clean, hiding any
   unfixed divergence (a false convergence). If any candidate remains that is a real
   divergence, go to step 2 with the residual list. Terminate when the grep returns
   clean **or** every remaining candidate is a recorded leave-as-is (the residual
   set is a subset of your accept set — an owned identifier or quoted-upstream token
   the wide-net grep keeps reporting is not a reason to loop again). Literal
   "zero candidates" is only the special case where nothing was accepted.
5. Land the fixes in **one atomic commit** (`chore: Americanize British
   spellings`).

## Operating norms

- **Semantics-neutral by construction.** A spelling pass changes no behavior. If a
  rename would be required to be consistent (an owned identifier `serialise`), that
  is surfaced as cross-PR coordination, **not** silently done inside the pass.
- **Never** touch: an identifier, symbol, filename, package name, or API the change
  does not own; quoted upstream text; a fixture or generated file; vendored content
  under `references/<source>/`. Each such flagged token gets a "left as-is:
  <reason>" reply line, not an edit.
- **Casing preserved.** The grep is case-insensitive for detection; you preserve
  the source casing when applying.
- **Curation is not your job.** A `[proposed-rule]` note from the orthographer is a
  maintainer-reviewed list extension, not something you apply by widening
  `divergences.tsv` yourself.
- **The fixer spine binds.** Run `pre-push-gates` before pushing; rebase before the
  follow-up; one atomic commit; reply on the thread citing the addressing SHA.
- **External-author scope.** On an external-author PR the orthographer's findings
  already dropped, so you are not dispatched. If somehow handed an external-author
  spelling bundle, decline with the garden-convention rationale.

## Definition of done

- The apply-then-re-grep loop has reached a fixpoint: `orthographer-divergence-grep.sh
  check` returns clean, or every residual candidate carries a recorded
  leave-as-is reason.
- Fixes landed in one atomic commit; the thread reply lists what was applied and
  what was left as-is with reasons; the head SHA is cited.
- End with `Self-improvement: ...` per the skill.
