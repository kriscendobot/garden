---
ts: 2026-06-15T05:33:03Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--725c2a
short_id: 725c2a
prs:
  - { repo: endojs/endo-but-for-bots, pr: 401, role: mirror-target }
  - { repo: endojs/endo, pr: 3300, role: upstream-source }
refs:
  - https://github.com/endojs/endo/pull/3300
  - https://github.com/endojs/endo-but-for-bots/pull/401
---

# dispatch: fixer — apply turadg+gibson042 feedback from endo#3300 to mirror #401

Maintainer directive (record on PR + result entry):

> Please address the new feedback on
> https://github.com/endojs/endo/pull/3300 and apply to our
> mirror. Note that we do not use git's object store as an
> intermediary in a pipeline that ends with xargs. We should
> generally favor null delimited list pipes, using xargs -0,
> anywhere applicable. Please take turadg's feedback about
> naming the script lint:shellcheck or better lint:sh, then
> incorporate as a step in yarn lint. This may obviate the
> special step in the CI job, since it will fall under
> yarn:lint.

Three changes:

1. **Rename package.json script** from `shellcheck` to
   `lint:sh` (per maintainer's "or better lint:sh"
   preference over turadg's `lint:shellcheck`).

2. **Roll lint:sh into yarn lint** so the parent `lint`
   script invokes it. Either:
   - Append ` && yarn lint:sh` to the existing `lint`
     definition, OR
   - Use the project's existing `npm-run-all` /
     `concurrently` pattern if one is in use.
   This makes the special shellcheck CI step redundant; the
   workflow can either be removed entirely OR reduced to a
   shellcheck-installer setup-step so `yarn lint` finds it.
   Maintainer's preference (per their inline reply 2026-06-11
   on the upstream PR): keep the `node --run shellcheck`
   pattern but roll into lint job for economy.

3. **Rewrite scripts/shellcheck.sh** to AVOID using git's
   object store as a pipeline intermediary. The current
   shape (per gibson042's suggestion) was
   `git cat-file blob "$HASH" | tr '\n' '\0' | xargs -0`;
   maintainer rejects that. Use null-delimited piping with
   `xargs -0` from a different source — `git ls-files -z
   '*.sh'` is the canonical idiom. Drop the
   load-list-into-string + git-hash-object dance entirely.

DO NOT touch upstream PR #3300; maintainer drives that. This
dispatch lands on mirror #401 only.
