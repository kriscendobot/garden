---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Post as a fixer job.

The panel round on the Endo guest-HTTP work established that `??` is wrong for the guest demo's env-var defaults: an empty override (`GUEST_NAME=""`) passes `""` straight through to a `z.string().min(1)` wire contract, turning what should be a default into a schema violation. Commits 464ad2a and 21eaaa9 applied that reasoning — 21eaaa9 restored the `||`-default for petName/guestText in `test/endo-guest-http.test.ts`, and 464ad2a's message claims the same for "the guest-mode defaults" — but the demo CLI itself was left untouched.

At tip d827af8, `dev/client.ts:21-22` still reads:

    const guestName = process.env.GUEST_NAME ?? "b5-daemon-note";
    const guestText = process.env.GUEST_TEXT ?? "B5 Endo daemon durability probe";

and `guestName` is passed as the `name` argument to `writeText`/`readText`/`remove`, whose schemas in `src/endo/guest-tools.ts` (lines 238, 258, 278) are `z.string().min(1)`. So `GUEST_NAME= npm run client` fails the tool call on a schema error instead of using the documented default — the exact defect the panel flagged, surviving in the one place an operator actually runs.

Do: flip both to `||` in `dev/client.ts`, with a brief comment matching the one already written at `dev/oauth-client.ts` explaining why `||` (not `??`) is correct here, so the choice does not read as an unreconciled flip-flop and get reverted again. Check for any sibling env-default site in `dev/` with the same shape and fix it the same way. Verify `npm test` stays green and that `GUEST_NAME= npm run client` now uses the default rather than erroring.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T06:31:44Z
