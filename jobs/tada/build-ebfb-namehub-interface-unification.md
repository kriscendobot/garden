I've completed the substantive work and am waiting on CI. Let me stop here and resume when the background CI poll reports back.

Summary of state so far (will finalize after CI):
- **Finding:** the design's production substance already shipped (C1 landed `ReadableNameHubInterface` + `EndoMount.maybeLookup`; #277 landed the `followNameChanges` `M.remotable()` form). Adding `followNameChanges` to the shared record would break genie's `LocalMount`, so no production change was safe/needed.
- **Delivered:** the design's outstanding Test Plan (items 1 & 2) as `packages/daemon/test/namehub-interface-unification.test.js` (4 tests), making the previously-dead `ReadableNameHubInterface` a load-bearing drift guard. Local `ava`/`eslint`/`tsc` all green.
- **PR:** [#583](https://github.com/endojs/endo-but-for-bots/pull/583) DRAFT, stacked on #277, honest body + summary comment posted, left draft pending maintainer triage.
