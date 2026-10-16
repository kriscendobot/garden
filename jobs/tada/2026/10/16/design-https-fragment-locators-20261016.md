## Completion report: design-https-fragment-locators-20261016

The design is written and open for review as draft PR https://github.com/endojs/endo-but-for-bots/pull/1484. Nothing was merged, un-drafted or implemented.

- **Where it is:** `designs/https-fragment-locators.md` on branch `design/https-fragment-locators` (commit `a908c2902a`), against the frozen base `llm-61cd656`. The PR carries the job marker.
- **Status:** Proposed. It covers both Endo and minion.town in one document.
- **Roadmap:** placed in M8 (Peer App Sharing), before `familiar-deep-link-invitations`; `designs/README.md` gained the summary, M8, dependency-graph and estimate rows and a totals note.
- **No garden-repo PR was needed,** because the design lives in endo-but-for-bots, not in the garden repo.
- **Checks:** the design has no mermaid diagrams. The house spelling and cliché grep scripts would not run on a single file, so I did not run them; the review panel will.

### What the design proposes
- **Link shape:** `https://<base>/{adopt,invite}/#v=1&type=…&id=…&peer=…&from=…&at=…`, or a bare `#…` when the agent has no base configured.
  - The secret (`id`) is only in the fragment.
  - The path only routes, and the parser ignores the base.
  - The path and `type` must agree (invitation versus adoption).
- **Parsing rules:**
  - Repeated single-value keys and unknown keys are rejected.
  - Hints keep their order.
  - Links are always written through `URLSearchParams`. This matters because today's hint prefixes contain `+` (`tcp+netstring+json+captp0:`), which turns into a space if a link is built by hand.
  - Hex must be lowercase. Two links are equal when their bare forms match; the base never counts.
- **OCapN:** the new link is a wrapper, not a fork. Each `at` hint corresponds to one OCapN sturdyref with the same designator and Swiss number; the type and invitation fields are Endo-specific.
- **Capture page:** it erases the fragment before parsing anything and has a strict CSP with no network access at all. It keeps one pending record in local storage for 15 minutes and must sit outside the login redirect.
- **Base URL as a trust anchor:** whatever page serves the base sees the secret. So the base is applied only when an agent shares, stored links are kept bare (a foreign base is never forwarded), and only hosts can configure a base.
- **Other rules:**
  - Invitations get a deadline enforced by the daemon.
  - Zero-hint invitations are refused, which fixes the tower report's undialable links.
  - Error messages never contain a locator (today `parseLocator` puts the whole locator in every error).
- **Migration:** both old and new forms parse. Stored formulas hold internal ids, not locator strings, so nothing on disk is rewritten. Old `endo://` invitations still redeem. The design gives a seven-step rollout order.
- **Per-agent base:** a new `locatorBase` field, inherited from the creating host and set by a host method. It fits `#1404`: guests never produce locators, so a guest's base is used only when its host shares for it.

### Conflicts it flags
1. **minion.town `guest.js`:** `normalizeGuestUrl` writes the guest formula id back into the fragment so the page can be bookmarked. That contradicts the "erase from history" rule (open question 6).
2. **The garden `ocapn-bootstrap-package` design (garden PR #124):** it wraps its nonce locator in minion.town's own `#v=1&invitation=` envelope. The two envelopes need to converge on one.
3. **Earlier maintainer decision:** "keep `endo://`, for now" in `daemon-ocapn-external-connectivity` would be partly superseded, as would the `endo://invite/` link shape in `familiar-deep-link-invitations`.
4. **Logging claim in the brief:** I found no daemon `console` call that logs the spent invitation id. The design asks the build to confirm this with a log-scanning test.

### Inventory counts (literal `endo://`, excluding `node_modules`)
| Repository | Files | Lines | Split |
|---|---:|---:|---|
| endo-but-for-bots (`llm` 61cd656) | 65 | 226 | src 23/53, tests 25/105, docs 17/68 |
| minion.town (`main`) | 13 | 28 | src 5/5, tests 4/~11, deploy 2/~8, docs 5/~9, UI 1/1 |

About 30 more Endo files call the locator functions without the literal string. minion.town has no `/adopt` or `/invite` route today.

### Platform facts
**Verified against primary sources:**
- iOS gives the app an `NSUserActivity` whose `webpageURL` is the link.
- Android App Links: `autoVerify` with `assetlinks.json`, one app per domain, periodic re-verification on Android 15 and later. The fragment-matching manifest attributes date from API 35.
- Windows "Apps for Websites" does not open the app from Edge Chromium or Firefox.
- Electron documents only custom schemes.
- The W3C Referrer Policy (§ 8.4) strips the fragment from `Referer`.
- `replaceState` replaces the current session-history entry.
- The OCapN locator and sturdyref URI forms.
- The W3C TAG capability-URL guidance.

**Not verified:**
- Whether iOS and Android actually deliver the fragment to the app. The design plans one device check each.
- macOS Universal Links for desktop apps; Linux; what browser extensions can do.
- Fragment inheritance across HTTP redirects.
- How link unfurlers (Slack, iMessage) handle the fragment.
- Whether browsers' global history and sync record the URL before `replaceState` runs. The Playwright plan measures this.

**Conclusion in the design:** no verified desktop platform lets an installed app claim an HTTPS link clicked in Chrome or Firefox. The capture page plus an "open in Familiar" launch scheme is the fallback everywhere.

**The Jasvir Nagra article could not be found** after several searches. The design cites the W3C TAG capability-URL note and Tyler Close's 2009 ietf-http-wg post instead, and open question 8 asks the maintainer for the link.

### Open questions (9, each with a recommendation)
1. Whether `minion.town` is the default base for Endo itself or only for agents hosted there.
2. A dedicated origin for the capture page.
3. Whether `at` hints should later become full `ocapn://` peer locators.
4. Rejecting versus tolerating unknown fragment keys.
5. Which custom scheme launches Familiar: `endo:` or `familiar:`.
6. Erasing the fragment versus minion.town's bookmarkable guest URL.
7. The default invitation deadline.
8. The Nagra article link.
9. Whether durable adoption locators should also get a deadline.

### Follow-ups
- **Build:** after the design is accepted, `build-https-fragment-locators` covers the five phases in § 11, estimated at 12 to 14 days and split across endo-but-for-bots, minion.town and Familiar. The completion machinery handles posting it.
- **Device checks:** test fragment delivery on one iOS and one Android device before Familiar mobile relies on it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-https-fragment-locators-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3555123 cached reads)
- Output: 36177 tokens
- Cost: $3.305640000000001
- Wall-clock: 590s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
