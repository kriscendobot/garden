# Fix round 4 for kriscendobot/minion.town#236: fixes pushed, CI green

I pushed one follow-up commit (`823bf9d1..7c8abacf`) that applies the panel's should-fix items from review 5768157142. CI finished green: 7 of 7 checks passed.

## What changed
- **Hint check (`src/endo/guest-locator.ts`):** `hintIsServed` now refuses three more things:
  - a location with keys other than `type`, `network`, `transport`, `designator` and `hints`, or whose `type` isn't `ocapn-peer` (breaker, purist, wire-watcher);
  - a hint URL whose spelling differs from what the URL parser produces;
  - a hint containing an empty trailing `#`, which the parser keeps but then reports as no fragment.

  The doc comment now says only what the check actually enforces. New tests cover the extra key, the alternate location, the wrong location type, the trailing `#`, the trailing newline and the empty userinfo.
- **Connect CLI (`deploy/aws/www/settings.js`):** the 409 branch now skips the `deletion-pending` code, so a pending guest deletion shows its own message (breaker 2).
- **Lost connection (`src/web/guest-web-socket-service.ts`):** the comment and the changeset now say that if the connection drops, the cancel can fail too and the name stays held until the user removes it. This was the fallback wire-watcher offered. I did not build the fresh-facet cleanup breaker asked for.
- **Changeset:** it now says the guest-locator check became stricter (it didn't add a filter), and that starting a WebSocket listener makes reveals answer 503 (integrator 1).
- **Design doc (`designs/remote-guest-endo-cli.md`):** the two leftover uses of "rewriting" now say "filtering" (integrator 2).
- **Test fixture (`test/web/guest-web-socket-faults.test.ts`):** the fixture now carries `type: "ocapn-peer"` to match the daemon's shape.

## Tests
- The three touched test files pass, and typecheck is clean.
- In a full `vitest run`, one test failed: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". I didn't touch that area or investigate it, and CI passed. Two `tools/claude-harness` test files also failed in that run, but `npm test` excludes that directory.

## Needs a maintainer decision
The decomplector's must-fix contradicts what three other jurors asked for, so I didn't apply it. It asks to remove `servedInvitationLocator` from `inviteRemote` and put `hintIsServed` back to its base strictness; the others asked to tighten that check. This is the PR's own Open question 3. I sent it to the maintainer inbox (`message-user`). Unless they rule on it before panel-5, the panel will likely raise the same must-fix again.

## Not applied this round
- The fresh-facet cancel fallback, with a fault test where `cancel` also fails (breaker 1 / wire-watcher 1).
- The purist's `formatServedLocator` simplification and the module-header scope note.
- The pruner's comment and PR-body trims.
- The integrator's PR-body additions and the `DEPLOYMENT.md` note on what a WebSocket hint would need.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1265425 cached reads)
- Output: 9375 tokens
- Cost: $1.0063370000000003
- Wall-clock: 449s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
