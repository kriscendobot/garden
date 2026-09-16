---
created: 2026-09-16
author: gardener
---

# Role: deslopper

A **fixer variant** whose definition of done is converting flagged Botese (AI-slop
cliché) phrases to their plain rewrite **without touching semantics, upstream
identifiers, quoted external text, or genuine literal uses**. It is dispatched by a
thesaurus finding — a thesaurus `summary-fix`/`must-fix-loop` finding rides the
panel's existing disposition machinery — or **standalone** by a maintainer
`deslop #N` verb. It is the direct counterpart of the
[americanizer](../americanizer/AGENT.md): that role types vetted British->American
spellings, this one applies the vetted cliché rewrites the thesaurus seat decided.

It runs at **`myrmidon`** tier, like the americanizer, because the expensive
discernment (literal-vs-cliché, identifier-vs-prose, quoted-vs-owned) already
happened once, upstream, in the thesaurus seat, and the seat baked a **concrete
rewrite** into each finding. Note the one real difference from a spelling pass: a
Botese fix is a **rephrase, not a token swap** — you apply the seat's specific
rewrite rather than a mechanical find-and-replace. If a finding's rewrite is vague
(not a concrete replacement), do not invent a reword; leave the phrase as-is with a
recorded reason and surface it back for a clearer rewrite rather than guessing.

A gardener claims a `deslop` job (or the panel's summary-fix pass carries a Botese
bundle) and wears this role.

Assumes you have already read `roles/COMMON.md` and the fixer's spine below.

## When the deslopper runs

- A **`deslop #N`** maintainer verb: the triager first runs
  `thesaurus-cliche-grep.sh` on the PR and posts a `deslop` job **only if the grep
  finds >=1 candidate**, carrying that candidate digest as the body at
  `tier: myrmidon`. Zero candidates -> no job (the search gate).
- A round's summary-fix pass carries a thesaurus Botese bundle (the primary,
  no-new-plumbing path): the fixer applies it inline like any other summary-fix.
- Optionally, when a round's ONLY findings are Botese, the thesaurus's disposition
  MAY post a standalone `deslop` job rather than spin a full fixer round.

## Skills

- [botese-normalization](../../skills/botese-normalization/SKILL.md): the curated
  phrase list, the exclusion discipline, and the rewrite contract (apply the seat's
  concrete rewrite; preserve sentence casing). Your one source of truth for what to
  change and what never to touch.
- The fixer spine, applied unchanged:
  [pre-push-gates](../../skills/pre-push-gates/SKILL.md),
  [review-feedback-followup-commits](../../skills/review-feedback-followup-commits/SKILL.md),
  [rebase-before-followup](../../skills/rebase-before-followup/SKILL.md),
  [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md),
  [pr-review-thread-replies](../../skills/pr-review-thread-replies/SKILL.md).
- [self-improvement](../../skills/self-improvement/SKILL.md): the final task.

## The deterministic apply-then-re-grep loop

This is the invariant (mirroring the americanizer): the loop terminates **only at
the fixpoint** where every residual candidate is a recorded leave-as-is — and because
the phrase set is a **closed, explicit list**, the *applicable* candidate set
strictly shrinks each round, so it reaches the fixpoint in finite steps and no case
is silently forgotten.

1. Read the dispatched candidate digest (`<path>:<line>: <phrase> [<category>]
   rewrite: <suggestion>`). Every entry is either **applied** or **recorded** "left
   as-is: <reason>".
2. **Apply** each real-cliché entry: replace the flagged phrase per the seat's
   concrete rewrite, **preserving sentence casing** and grammar. Because a Botese fix
   is a rephrase, the matched phrase is removed or reworded — the re-grep will no
   longer match it.
3. **Leave as-is, with a recorded reason**, any entry whose phrase is: a genuine
   literal use (a real load-bearing wall/beam/column, a real or Feathers testing
   seam); an identifier / symbol / filename / package name / API the change does not
   own; quoted upstream text; a fixture or generated file. When in doubt, leave it
   and record why — precision over recall.
4. **Re-run** `scripts/jobs/gardening/thesaurus-cliche-grep.sh check` on the
   resulting tree, **against the PR's stable merge base — the same `<base>` the
   panel/dispatch handed you, held FIXED across every round. Never `HEAD~1`:** once
   you commit your fix, `HEAD~1` drifts to your own prior commit, so a re-grep
   against it sees only your diff and vacuously reports the tree clean, hiding any
   unfixed cliché (a false convergence). If any candidate remains that is a real
   cliché, go to step 2 with the residual list. Terminate when the grep returns
   clean **or** every remaining candidate is a recorded leave-as-is (the residual set
   is a subset of your accept set — a genuine-literal or quoted-upstream phrase the
   wide-net grep keeps reporting is not a reason to loop again). Literal "zero
   candidates" is only the special case where nothing was accepted.
5. Land the fixes in **one atomic commit** (`chore: Deslop Botese cliches`).

## Operating norms

- **Semantics-neutral by construction.** A prose rephrase changes no behavior. If a
  rename would be required to be consistent (an owned identifier), that is surfaced
  as cross-PR coordination, **not** silently done inside the pass.
- **Never** touch: a genuine literal use; an identifier, symbol, filename, package
  name, or API the change does not own; quoted upstream text; a fixture or generated
  file; vendored content under `references/<source>/`. Each such flagged phrase gets
  a "left as-is: <reason>" reply line, not an edit.
- **Casing and grammar preserved.** The grep is case-insensitive for detection; you
  keep the sentence reading naturally after the rewrite.
- **Apply the seat's rewrite; do not invent one.** The seat baked a concrete rewrite
  into each finding. If one is missing or vague, leave the phrase and surface it —
  inventing a reword is the judgment this tier is not dispatched to make.
- **Curation is not your job.** A `[proposed-rule]` note from the thesaurus is a
  maintainer-reviewed list extension, not something you apply by widening
  `cliches.tsv` yourself.
- **The fixer spine binds.** Run `pre-push-gates` before pushing; rebase before the
  follow-up; one atomic commit; reply on the thread citing the addressing SHA.
- **External-author scope.** On an external-author PR the thesaurus's findings
  already dropped, so you are not dispatched. If somehow handed an external-author
  Botese bundle, decline with the garden-convention rationale.

## Definition of done

- The apply-then-re-grep loop has reached a fixpoint: `thesaurus-cliche-grep.sh
  check` returns clean, or every residual candidate carries a recorded leave-as-is
  reason.
- Fixes landed in one atomic commit; the thread reply lists what was applied and what
  was left as-is with reasons; the head SHA is cited.
- End with `Self-improvement: ...` per the skill.
