Panel round 2's must-fix items on [kriscendobot/minion.town#240](https://github.com/kriscendobot/minion.town/pull/240) are applied and pushed, with one partly applied (below). CI is green on head `e5948d7b`. The real-daemon suite and the real-browser test behind Caddy both ran and passed in their own CI steps; the push moved the branch forward from `6a1c2bed` with no rewrite.

**Commits**
- `b0702aee` merges #239's tip (`aebfdf39`), which makes the PR's stack claim true. It also brings in the foreign-node refusal in `acceptLocal` and the refusal of a body naming both credentials.
- `e5948d7b` is the review-feedback follow-up.

**Must-fix items**
- **One locator predicate:** the router's loose check and `isEndoLocator` are now one `isInvitationLocator` in `capability-url.ts`, used for both bare and https forms.
  - It matches the spelling the daemon mints and requires `type=invitation` and `from`. It refuses userinfo, dot segments, encoded numbers, repeated or unknown keys, and bad hint escapes.
  - `home.js` can't import it, so it carries a copy, and one fixture table tests both.
- **Foreign node dial:** this comes from the #239 merge. I added a case with a foreign node and hints, and fixed the daemon test's host so it reaches the node check. The stale comments in `local-invitations.ts` and `guest-web-socket-service.ts` are corrected.
- **Outage reported as a spent link:** after a failed accept, the route now probes the daemon, so a fault answers 503. An accept overtaken by a deletion answers as the deletion.
- **`/adopt` guard:** the path is now read before the scrub replaces it.
- **Returning guest losing the link:** a browser with a live guest now gets the accept card.
- **Page and server grammar drift:** the page now refuses unknown fragment keys, so an unencoded locator shows as malformed instead of being truncated. Docs and designs now use the `/accept` form.
- **Maintainer-review conflict (decomplector):** I did not stop for confirmation. The maintainer's 2026-11-04 direction asks for `/accept#…` and `/adopt#…` carrying the existing locator, and it is later than the #1484 review. The PR body now cites it and says this PR doesn't implement the `#ocapn=…` shape, which the maintainer may still want to weigh.
- **Unused server grammar (decomplector, partly applied):** I kept the https parse path and the locator arm of `formatCapabilityUrl`, because the same direction asks for a round trip with `endo://`. I un-exported the unused helpers and corrected the false docstring.

**Should-fix items also done**
- Changeset wording, the `/adopt` alias documentation and the path math in the test.
- Removing the narrating comments in the test driver, and adding `/accept` and `/adopt` routes to the dev demo.
- Trimming the PR body and removing its duplicate job marker. It is about 440 words, still over the pruner's ~300-word bar.

**Tests**
- The browser proof now also covers a stored guest, a shaped-but-invalid locator, and `/adopt` with an invitation.
- Locally, `tsc` is clean and the web, home-page, Caddy-framing and invite-tool suites had no failures (289 passed, 7 skipped). The skipped ones need `ENDO_CHECKOUT` and passed in CI. The full vitest suite wasn't run locally.
- `pre-push-gates` probes exited 0.

**Left open**
- **Exported parser:** `guest-locator.ts` keeps its private `parseLocator` rather than sharing it. It requires `type` as the only query key, so it can't parse an invitation locator carrying `from`.
- **Commit history:** the earlier fixup commits were not folded, since this job only adds follow-up commits.
- **Deploy order:** the app still deploys before Caddy. This is called out in the PR body, not changed.
- **Outage detection limit:** a daemon restart fast enough to answer the probe still reads as a spent link.
- **#239 still moving:** its panel-3 job is on the board, so any later #239 commits will need another merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (2159610 cached reads)
- Output: 45369 tokens
- Cost: $2.713998
- Wall-clock: 1104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
