---
handed-off: build-minion-town-https-locators-proof-20261104
deliverable-complete: false
---
I opened draft PR [kriscendobot/minion.town#240](https://github.com/kriscendobot/minion.town/pull/240), but it covers only the first slice. The `/adopt` page, the `evaluate` change and the Playwright proof are not done; I handed them to a successor job.

**What the PR changes** (based on `main-9196892`, not deployed):
- **URL grammar:** a new module, `src/web/capability-url.ts`, defines:
  - `/accept#v=1&invitation=<id>` for a minion.town invitation.
  - `/accept#v=1&locator=<endo://…>` for a daemon invitation locator.
  - `/adopt#v=1&locator=<endo://…>` for adopting a capability.
  - **Fragment rules:** `v=1` is required, each key may appear once, and unknown keys are rejected. A link must carry exactly one of `invitation` or `locator`. Error messages never repeat fragment content, and an encrypted `v=2` can come later per #170.
  - **Both forms work during the transition:** `toEndoLocator` accepts either a bare `endo://` locator or the https link and returns the locator; a locator turned into a link reads back unchanged. The existing `endo://` parsing is untouched.
- **Minting:** invitations from the MCP `invite` tool and the browser now come out as `https://minion.town/accept#v=1&invitation=<id>`. Old `/#v=1&invitation=` links still work.
- **Caddy:** `/accept` now serves the same landing page as `/`, with the same CSP, `no-referrer` and `no-store` headers. The route-admission record and the Caddy tests are updated.
- **Fragment scrub:** before, `home.js` only removed `guest=` fragments from the address bar. It now removes any fragment holding `guest`, `invitation` or `locator` as soon as it reads it. The value stays in memory only, so reloading the page drops the link.
- The PR also adds a changeset and first-pass threat notes (referrer, link-preview crawlers, history, the #173 signal).

**Tests:**
- The new grammar test file passes all 19 tests, and `tsc` is clean.
- The full vitest run had 1692 passing and 1 failing: `test/git-remote/capability.test.ts`. That test is in code this PR doesn't touch, and it is a known false failure from the bot sandbox's git wrapper.
- I did not run Prettier on files I edited that were already unformatted on main, because the repo doesn't enforce it.

**Not done, now owned by `build-minion-town-https-locators-proof-20261104`** (posted to the board, works on the same branch and PR):
- The `/adopt` page and `locator=` handling in `home.js`.
- Visible errors for a malformed fragment or a spent invitation. Right now a malformed fragment falls back to the splash page.
- Making `evaluate`-minted invitations use the https form.
- Using `toEndoLocator` wherever a user pastes a locator, including #236.
- The real-daemon Playwright test, including the check that server and Caddy logs contain no fragment.

**Possible duplicate work:** job `build-minion-town-tool-minimalism-20261104` had already finished when I messaged it about the `evaluate` overlap. The message was dead-lettered, so it will be promoted to a new job. That job and the successor could both fix `evaluate`; the successor's brief tells it to check with that job first.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-https-locators-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 68 tokens (2687273 cached reads)
- Output: 21515 tokens
- Cost: $1.6926586000000001 (1 engagement(s) unpriced)
- Wall-clock: 2723s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
