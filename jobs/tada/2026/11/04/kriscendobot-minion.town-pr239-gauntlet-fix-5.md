**Fix round 5 for kriscendobot/minion.town#239 is pushed and CI is green (7 of 7 checks).**

There was no deterministic pre-pass block in the job, so I worked from the latest panel review (5773725285). Its must-fix items are both fixed, along with some of the should-fix items. The fix is commit `59d0608e`, pushed to `garden/web-accept-evaluate-locator` with `safe-push-pr-head.sh`.

**Must-fix items:**
- **Archivist #1, the changeset:** it no longer tells users to paste a locator into the invitation card, which has no field for one. It now says to open the link `https://minion.town/#v=1&locator=<endo://...>` with the URL-encoded locator.
- **Saboteur #1, daemon faults read as "spent":**
  - `isLocalInvitation` no longer has its broad `try { … } catch { return false }`, so errors from the invitation lookup and `locate()` now reach the caller.
  - In `acceptLocal`, only errors that `isDaemonInvitationRefusal` recognises become `InvitationUnavailableError` (404). Any other daemon fault rejects as itself and is answered with 503, so a good locator is no longer reported as dead.

**Should-fix items:**
- **Saboteur #3:** `invitationParts` now returns `undefined` on a malformed percent-escape instead of throwing a raw `URIError`.
- **Archivist #2:** the `BrowserGuestDirectory` doc now says it reads the daemon's own node and looks the invitation up by identifier.
- **Archivist #3:** the design doc and the router comment now describe the locator's node, number, `from` and `fromNode` fields as 64 hex digits, not `<handle>`.
- **Pruner #7:** removed the "Caller-supplied since…" history comment.

**Tests:**
- I added cases in `guest-web-socket-faults.test.ts` where `lookupById` or the invitation's `locate()` fails on the local node; both must reject as a fault, not a 404.
- I changed the fake daemon so that looking up a non-hex number throws the real daemon's "No formula exists for number" refusal. The fake used to return a guest object, and with the broad catch gone that case broke the existing "unknown" test.

**Checks run locally:**
- `tsc` passes, and all of `test/web` passes.
- A full `vitest run` had one failure, in `test/git-remote/capability.test.ts`, which my change doesn't touch. It also flagged the two `tools/claude-harness` suites, which the package's `test` script excludes anyway.
- I did not run Prettier with `--write`. Five of the files I edited already failed the Prettier check before my change.

**Left for later rounds:** the curator and decomplector should-fixes, which ask for one shared parser and type for the locator, plus the rest of the pruner's comment trims and saboteur #2 (refusals are matched on daemon message text). I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1417358 cached reads)
- Output: 10472 tokens
- Cost: $1.0808635999999998
- Wall-clock: 471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
