Merged #805 into `llm`: `1c45ab718d1698b2d2687cd1f13aefe7f4b86a75`.

Rebase was unnecessary: head `09540db9fc24dd192b026020686cc3a416d6c00b` already contained current `llm`. Maintainer approval remained on that head. CI completed green: 24/24 checks passed, including lint and test matrices; no separate types check was present.

Posted completion summary: https://github.com/endojs/endo-but-for-bots/pull/805#issuecomment-5036092136

Follow-up: retained `feat/endor-run-top-level-await`, because open #812 still uses it as its base. Retarget #812 before deleting the branch.
