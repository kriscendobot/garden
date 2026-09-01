---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: endojs/endo-but-for-bots. Build https://github.com/endojs/endo-but-for-bots/issues/982 in response to https://github.com/endojs/endo-but-for-bots/issues/982#issuecomment-5497719522.

Implement creator-supplied special-name endowments for freshly provisioned Endo guests, including the default and override behavior for @main, across provideGuest, makeGuest, and the relevant provisioning surfaces. Establish a narrowly typed endowSpecialNames-style input (use the repository's settled naming if an equivalent API already exists): only the authority creating the guest may supply it; ordinary guest callers cannot rename another guest's special workers; omitted configuration preserves the default @main worker; retained/reacquired guests preserve the original immutable special-name policy; and repeated provisioning must fail closed rather than widen or replace authority. Reconcile with the retained guest provisioning work in PR #1042 and the minion.town compatibility implementation in https://github.com/kriscendobot/minion.town/pull/62. Add focused durability, formula-identity, defaulting, override, collision, mutation-rejection, and no-authority-widening tests, plus documentation and changeset coverage.

Forward-reference requirement: immediately after opening or identifying the implementation pull request, post a comment on issue #982 linking that build PR and stating its current status. Do not complete this job with the forward reference merely described in prose; actually post it and include the issue-comment URL in the completion report. If an existing build already implements the issue, verify it at current head and post that exact PR as the forward reference instead of opening a duplicate.
