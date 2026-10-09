I applied the panel-6 must-fix items to kriscendobot/minion.town#170 in one commit, pushed it, and CI went green: 3 of 3 checks passed (`ci-wait-merge` rc 0).

**Fixes**, in commit `95e949e` on `feat/locator-fragment-scrub`, pushed `486a9a6..95e949e` with `safe-push-pr-head.sh`:
- **Curator and surfacer #1 (duplicated constants):** `deploy/aws/www/locator-fragment.js` now exports `ENVELOPE_VERSION`, `MAX_LABEL_LENGTH` and a frozen `FRAGMENT_KEYS`, and its parser uses them. `src/web/invitation-envelope.ts` now imports these and re-exports the version and label limit. It no longer keeps its own copies, and the builders read the same key names and limits. Its header comment now says the shared module is the canonical one.
- **Archivist (no API docs):** `locator-fragment.d.ts` now has JSDoc on every export, covering the six functions, the types and the new constants.
- **Surfacer #2 (unchecked `.d.ts`):** a new test, `test/web/locator-fragment-declarations.test.ts`, reads the `.d.ts` with the TypeScript compiler. It checks the `.d.ts` against the runtime module on three points: export names match exactly, each function has the same parameter count, and each declared literal constant has its runtime value. It does not check parameter or return types.
- **Pruner (repetition):** I shortened the `UNKNOWN_CREDENTIAL_PATTERN` comment in `src/web/guest-web-service.ts` and the "Superseded in part by § 4.1" note in `designs/invitation-only-guest-onboarding.md`.

**Checks run locally:** `npm run typecheck` is clean and the `test/web` tests pass (61 passed, 3 skipped). One test in the full suite failed locally: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That code is not part of this PR, and the same suite passed in CI.

**Not done:** the decomplector's three should-fix items:
- the daemon-error text matching that decides 401 versus 503
- `isGuest` recognising a guest by its method names
- whether the `pending-guest` slot and the encrypted IndexedDB storage are more than the problem needs

Each would be a design change rather than a quick fix. The decomplector also asked that the PR body link the maintainer's approval of § 4.1 reversing the #56 decisions; I did not add that link. These remain for panel-7 or the maintainer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1318206 cached reads)
- Output: 11042 tokens
- Cost: $1.0600892000000002
- Wall-clock: 1038s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
