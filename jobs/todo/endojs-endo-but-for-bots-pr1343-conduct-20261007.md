---
role: conductor
tier: mentor
fallback-tier: minion
arc: minion-town-mcp-ocapn
dispatch: automatic
---
**Role: conductor.** Merge https://github.com/endojs/endo-but-for-bots/pull/1343 ("feat(daemon): endow retained guest special names", APPROVED) on its current base. Do NOT weave or rebase https://github.com/endojs/endo-but-for-bots/pull/1042: the maintainer is closing it (see below).

Maintainer decision (kriskowal, liaison muster 2026-10-07; milestone M3, guest-endowment step): land #1343 now. **Amended same session:** the maintainer dispreferred #1042's approach and is returning it to its author and closing it, so no #1042 follow-up.

**Precondition, check first:** #1343 must not depend on #1042. Confirm that its diff builds and its tests pass on its own base without anything introduced by #1042 (introducedNames / guest retention). If it does depend on #1042, **stop without merging**. Report the dependency to the maintainer (#1042 is being closed, so #1343 would need its own decoupled path).

**If independent:** run the normal conduct (CI green, effective maintainer approval, merge). Post no #1042 weave.
