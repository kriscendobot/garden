**Undraft stage: kriscendobot/minion.town PR #253 ("feat(web): advance a waitlist sign-up to a thank-you page at /soon")**

**Result: no change needed.** The PR was already out of draft. I checked it twice and both times got: state OPEN, head `16a121842e4434fe85020cdab008f9677e9ff2a1` (exactly the commit the panel passed), isDraft false. So I did not run `gh pr ready`.

**Advisory appellate pass:** one short `claude -p` (sonnet) review of the 745-line diff. These are recorded only and did not block the stage:
- **Security:** it found no XSS or open-redirect problem. Dynamic text goes through `textContent`, and history updates only ever target fixed paths.
- **Routing:** the route matches `/soon` but not `/soon/` or `/Soon`. Those fall through to the OAuth-gated default route, so a slightly altered bookmark would land on a login redirect.
- **Client-side claim:** the "you are on the list" flag is just a `sessionStorage` value, so anyone can fake it and it can linger on a shared machine. It is cosmetic, but stronger than the design's "never claims" wording suggests.
- **Accessibility:**
  - Screen readers probably hear the heading twice: once on focus and again from the live-region announcer.
  - `#soon-status` is a status region that nothing ever writes to.
  - Focus is not restored after a failed submit.
  - The error message is not linked to the input.
- **Tests:**
  - The browser tests skip themselves when Chromium is missing, so CI passes silently unless `PLAYWRIGHT_BROWSER` is set.
  - The test checking that no address is stored in history matches the `home.js` source with a fragile regex.
  - Nothing tests a double submit, the `/soon#invitation=` handoff, or the deletion-pending state.
- **Minor:** `/soon` has no `noindex` header, so search engines could index it. Server errors (5xx) can no longer be told apart from network errors in what the visitor sees.

**Follow-ups (optional):** the trailing-slash route and the test that skips silently are the two points most worth a small fix.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr253-screen-16a12184-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (185904 cached reads)
- Output: 1362 tokens
- Cost: $0.43251680000000003
- Wall-clock: 70s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
