---
role: conductor
tier: mentor
fallback-tier: minion
arc: minion-town-mcp-ocapn
dispatch: automatic
---
**Role: conductor.** Merge https://github.com/endojs/endo-but-for-bots/pull/1343 ("feat(daemon): endow retained guest special names", APPROVED) on its current base. Then rebase https://github.com/endojs/endo-but-for-bots/pull/1042 (draft) onto the result.

Maintainer decision (kriskowal, liaison muster 2026-10-07; milestone M3, guest-endowment step): land #1343 now, and rebase #1042 afterwards.

**Precondition, check first:** #1343 must not depend on #1042. Confirm that its diff builds and its tests pass on its own base without anything introduced by #1042 (introducedNames / guest retention). If it does depend on #1042, **stop without merging**. Report the dependency to the maintainer and recommend landing #1042 first.

**If independent:** run the normal conduct (CI green, effective maintainer approval, merge). Then post a weaver job, `endojs-endo-but-for-bots-pr1042-weave-<YYYYMMDD>`, to rebase #1042 onto the base it now needs, resolving conflicts with #1343. #1042 stays a draft.
