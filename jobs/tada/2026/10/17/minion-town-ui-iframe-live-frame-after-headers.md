## Completion report: minion-town-ui-iframe-live-frame-after-headers

The live clip frame is built and open as draft PR https://github.com/kriscendobot/minion.town/pull/197 (head `feat/clip-live-frame` at `f55f6a2`, against the new frozen base `main-bda7739`). The design's browser check passed 29 of 29 on Chromium, Firefox and WebKit in CI.

**Starting point**
- The header PR, #194, is merged on `main` (`bda7739`) and running in production: the shell sends both CSP fields plus XFO `DENY`, and the prod canary clip sends `frame-ancestors https://minion.town`.
- The approved sandbox flags come from #189, the approved design amendment, which is still a draft and unmerged. The maintainer's 2026-10-16 approval comment is on it. The two tokens are `allow-scripts allow-same-origin`.
- #88 has not landed, so the frame uses the listed clip id with no fragment and no locator.

**What changed**
- **Live branch in `deploy/aws/www/shell.js`:** a served clip gets a live frame only if its id passes `isCanonicalClipId`, a browser copy of the gateway's `labelToId` round trip (exactly 32 bytes, pad bits zero).
  - The `src` is always rebuilt from the id by `clipOrigin`. A supplied origin, url or src field is never used.
  - Everything else shows the inert card: a host name, a wrong-length id, a pad-bit alias, or a clip the listing says is not served.
  - In `showLive` the order is: remove `srcdoc` under the empty sandbox, set the sandbox, then assign `src` with `referrerpolicy="no-referrer"`.
- **Failure handling:** the shell can't see why a cross-origin frame was refused, so every live frame now has a shell-owned caption under it ("Clip not loading? Open it in a new tab"). The existing "Open in new tab" link stays in both states. Two failures the shell can see swap in the inert card: no `load` within 15 seconds, or a frame-src violation in the shell naming the clip's origin.
- **Layout (`index.html`):** `#main` is now a column with the frame and then the caption. The frame stays inside `#main`, and the stacking that keeps the settings chrome above the clip is unchanged.
- **Tests (`test/shell-clip.test.ts`, now 79):** they cover the live config, forged fields, each bad-id case, agreement with `labelToId` on random inputs, the failure watch, the sink order, the caption markup, and a pin that keeps the CI image tag in step with `playwright`. Seven mutations each made at least one test fail.
- **Browser check:**
  - `test/browser/clip-frame-gate.ts` is a self-contained Playwright harness. It serves this checkout's shell with the Caddy headers and the gateway's real `ISOLATION_HEADERS`.
  - The new `.github/workflows/browser-gate.yml` runs it on all three engines in the `mcr.microsoft.com/playwright:v1.64.1-noble` image.
  - `playwright@1.64.1` is added as a devDependency.
- **Design file:** `designs/clip-shell-framework.md` gets a new § 3.2 describing what shipped, and Open question #1 is marked resolved.

**Verification**
- Typecheck is clean. The unit tests and the `test` CI job pass.
- **Browser check:** 29 of 29 on Chromium locally, and 29 of 29 on each engine in CI. Every engine framed the scripted clip despite XFO `DENY` and CORP `same-origin`, so the design's fallbacks aren't needed.
- **Mutation runs:** removing each defence in turn makes the matching checks fail. Removing the site-wide anti-framing headers alone did not: in Chromium the shell's `frame-src` by itself still refused every navigation the clip started onto `minion.town`. The design had marked this as unverified and doesn't rely on it.
- **Fixed during testing:** my first child-navigation checks passed even with every defence removed, so they proved nothing. I replaced them with a check on whether the shell can read the frame's document.

**Limits**
- **Firefox and WebKit can't run on the garden host** (missing system libraries, no root), so those two engines are checked in CI only.
- **Redirects aren't tested directly.** In this harness a faked 3xx never completes a frame navigation. Each redirect is checked at where it lands instead: the sign-in redirect at `/oauth2/sign_in`, and the `www.minion.town` and `ocap.site` redirects at the apex pages. That real Caddy sends the anti-framing headers on 3xx and error responses is #194's evidence.
- **Safari:** WebKit stands in for it.
- **Unrelated local failure:** `test/git-remote/capability.test.ts` fails on this host without my changes, as #194 also recorded. The `test` CI job passes.

**Follow-ups**
- The PR stays draft. Merging it deploys the live frame to production.
- `shell.js` is 46.6 KB, about 62 KB as base64, close to `deploy-www.sh`'s 70,000-byte per-file limit.
- The CI runner now pulls the Playwright image for any PR that touches the shell, the Caddy shell headers or the clip headers.

No garden (main2) changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-iframe-live-frame-after-headers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 156 tokens (11991516 cached reads)
- Output: 74013 tokens
- Cost: $5.5620432
- Wall-clock: 2638s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
