Completed PR #740's design-only gauntlet.

- Fixed the GitCas integrity contract in 446f8da478: repository-format object IDs, validated typed trees, direct-ref target and symbolic-ref rejection, and a concrete full-verification contract over all objects and allowed refs.
- Pushed 446f8da478 to design/endor-git-bindings, recorded a passing panel verdict, and marked PR #740 ready for review.
- Verification: `git diff --check` passed; `cargo info git2@0.21.0` confirmed the documented local-only feature surface; GitHub lint and build checks passed on 446f8da478. Browser, test, and zizmor checks were still pending when the gauntlet was completed.

Follow-ups: CI watcher should surface any non-passing pending checks.
