Opened https://github.com/endojs/endo-but-for-bots/pull/848 from `build/pi-0.81.1-migration` (commit `0d601ca3f`).

Updated `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` from 0.80.3 to 0.81.1 in agent-tools, agentry, genie, and lal, with `yarn.lock` refreshed. Added explicit `pi-ai/compat` `streamSimple` fallbacks in Agentry and Genie because Pi 0.81 no longer provides an implicit Agent stream function.

Verification passed: `yarn install --immutable`; focused Agentry faux-provider agent test; Genie, LAL, and agent-tools test suites; agentry typecheck/lint, Genie lint, and agent-tools typecheck. Lint reported existing warnings only. The complete Agentry suite has one unrelated conflict-rebase fixture failure.

Follow-ups: none.
