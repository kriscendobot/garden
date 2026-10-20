Clean stage for kriscendobot/minion.town#198 (head `f4c29e6c`, "one landing at /, closed-beta splash and waitlist"): coverage and dead code are already in order and CI is green. I pushed nothing.

- **PR state:** open, not a draft. All 7 checks were already passing when I started: gate (chromium, firefox, webkit), changes, test, and Claude harness (amd64, arm64). `ci-wait-merge.sh --no-merge` returned rc=0 (CI GREEN, 7 total, 0 failed).
- **Coverage:** the source the PR adds is `src/waitlist/waitlist.ts`, `src/waitlist/stores/dynamodb.ts` and `src/waitlist-cli.ts`. Its tests are `test/waitlist.test.ts` and `test/waitlist-dynamodb.test.ts`, and all 57 pass locally. Every new exported helper is called directly by a test or indirectly through one. The ones only reached indirectly are:
  - `csvField`, through the CSV quoting and formula-neutralizing tests.
  - `clientAddress`, through the X-Forwarded-For rate-limit tests.
  - `compareCodeUnits`, through the oldest-first list test.
  - `MAX_EMAIL_LENGTH`, through `normalizeEmail`.
- **No coverage report:** `@vitest/coverage-v8` isn't installed in the project, so I couldn't get line-level coverage numbers. The coverage check above is based on reading which tests call which helpers.
- **Dead code:** none found. The PR deletes `guest.html`, `guest.js` and `shell.html`. What still mentions them is the 308 redirects in the Caddy config and the dev demo, a test that checks they are gone, and comments about the daemon's own `guest.js`. The new `InvitationUnavailableError` in `src/web/guest-web-router.ts` is used.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr198-screen-f4c29e6c-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (541985 cached reads)
- Output: 3729 tokens
- Cost: $0.586137
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
