## Completion report: build-minion-town-https-locators-browser-proof-20261104

The real-browser proof is on PR [#240](https://github.com/kriscendobot/minion.town/pull/240) (branch `feat/https-capability-urls`, commit `0ac69825`). It passes locally and in CI (run [41768709474](https://github.com/kriscendobot/minion.town/actions/runs/41768709474)). I checked the CI log: the test ran rather than skipped. The PR is still a draft and nothing was deployed.

**What the test does** (`test/web/https-locator-browser.test.ts`)
- It runs against a real Endo daemon and a real Caddy. It is gated on `ENDO_CHECKOUT` like `guest-web-daemon.test.ts`, and also on `CADDY_BIN`. Without them it skips.
- **Caddy setup:** Caddy serves the repo's `conf.d/minion-town.caddy` site block. For the local run only these change: the site address becomes `https://minion.town:<port>`, plus `tls internal`, a JSON access log, and the upstream and file root pointed at the test. The test asserts the `@landing` route is otherwise byte for byte the deployed one. Chromium resolves `minion.town` to 127.0.0.1.
- **Minting:** the invitation is minted through the MCP `evaluate` tool with `E(E(agent).invite('webcomer')).locate()`.
- **Accept:** a fresh browser context opens `/accept#v=1&locator=<encoded>` and clicks accept on the card, which creates a guest.
- **Mail both ways:** `evaluate` send → the guest's inbox, then `POST /api/guest/mail` → `evaluate` `listMessages` reads it back.
- **Errors:**
  - A replay in a second fresh context shows the spent-invitation message.
  - A malformed fragment shows the malformed-link message.
  - Neither message, page or address bar contains the locator, its encoded form, the invitation number, `locator=`, or the malformed test string.
- **Logs:** Caddy's access log has exactly three `/accept` entries, each a bare `GET /accept`. Neither that log nor the app's log (request lines plus console output) contains any fragment text. The test also checks that its capture of the app log is actually picking up output, so it can't pass on an empty log.

**Two things that weren't obvious**
- **Browser in a child process:** Playwright runs in a separate process (`test/web/https-locator-browser-driver.ts`). Run in the same process, it attaches hidden fields to every JavaScript promise. The daemon connection then rejects them ("Must not have any own properties: [Symbol(async_id_symbol)]…") and requests hang.
- **Console capture:** vitest normally captures `console` output itself, so it never reaches the streams the test reads. The test therefore has to run with `--disableConsoleIntercept`. The file header says so, and the log check fails loudly if the flag is missing.

**CI wiring** (`.github/workflows/test.yml`)
- New steps after the guest-web-daemon run download Caddy v2.10.2 (checked against the release tarball's SHA-512) and install Playwright Chromium.
- The test runs as its own step after those.
- The `test` job timeout goes from 15 to 20 minutes.

**PR body:** "Still open" is replaced by a "Production outcome" section with these results, the CI run link, and the note about the child process. The threat notes and verification list now point to it.

**Follow-ups**
- The Caddy download is pinned to linux/amd64. If the self-hosted CI runner moves to arm64, that step needs a second checksum.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-https-locators-browser-proof-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4485468 cached reads)
- Output: 36744 tokens
- Cost: $2.5882536
- Wall-clock: 1022s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
