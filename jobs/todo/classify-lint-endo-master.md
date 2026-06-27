<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-06-27T11:53:05Z -->

# PLAN: classify lint errors on endo master, then post per-class fix plans

Maintainer directive: a **plan** to classify lint errors on **endo master** and then **post
plans (deferred) for addressing each class** of lint error. This is **deferred** lint-cleanup
work — it should be prioritized/selected, not auto-run. When promoted to `todo`, do the
following. Wear the **assayer/investigator** role, then producer.

## Task (when promoted)

1. **On endo master** (`endojs/endo-but-for-bots` `master`, which mirrors `endojs/endo@master`;
   sync bot-master to upstream master first if drifted), run **lint** across the endo packages
   (the repo's real lint command, e.g. `yarn lint` / per-package eslint). Capture the full lint
   output **silently into the git content store** (`git hash-object -w`) per the new local-verify
   discipline — do NOT flood context with raw lint output; inspect selectively via
   `git cat-file -p <sha> | grep/tail`.
2. **Collect and classify** every lint error into **classes** grouped by ESLint rule / category /
   root cause (e.g. "no-unused-vars", "import-ordering", "jsdoc", "type-coverage", a custom
   plugin rule). Count per class; ground each class in actual error instances.
3. **Post a per-class fix PLAN** (deferred, into `jobs/plan/`, e.g. `fix-lint-<rule-slug>`) for
   each class — naming the rule, the count, the affected files/packages, and the proposed fix
   approach (autofix-safe vs needs-judgment). Use `post-plan.sh` once it exists; until then, write
   to `jobs/plan/` directly with `gate: deferred`. These are deferred so the maintainer
   prioritizes which lint classes to address.
4. Write a **classification report** to the journal and surface a summary to the bulletin
   (`message-user`): the classes, counts, and which are autofixable.

## Bounds

- Scope to bot repos (endo-but-for-bots master). Investigation is read-heavy and deterministic;
  the per-class fix work is itself deferred (plans), not auto-run. Prefer `eslint --fix --dry-run`
  / rule metadata to mark which classes are mechanically autofixable.

## Definition of done

Lint errors on endo master classified into rule/root-cause classes (with counts and
autofixability), one deferred fix-plan posted per class, and a report surfaced to the bulletin.
