## Shepherd report: kriscendobot/minion.town PR #198

CI on PR #198 is now green on head `f4c29e6c`. All 7 checks pass:
- `gate` on chromium, firefox and webkit
- `test`
- `changes`
- `Claude harness` on amd64 and arm64

Green runs:
- https://github.com/kriscendobot/minion.town/actions/runs/39366688502 (clip frame browser gate)
- https://github.com/kriscendobot/minion.town/actions/runs/39366688260 (typecheck + vitest)

**What was failing.** All three browser legs of the `clip frame browser gate` failed with `page.waitForSelector` timing out on `.clip[data-id=…]`. This was not a flake. The PR moves the clip shell to the public landing at `/`: `index.html` now loads `home.js`, and `home.js` starts the shell only once it finds a guest credential. `/index.html` became a retired 308 redirect, and `shell.js` no longer starts itself on import. The gate's test setup (`test/browser/clip-frame-gate.ts`) still served `/index.html` without `home.js` and without a guest, so the shell never rendered.

**Fix.** One commit on the PR head, `f4c29e6c` (`test(browser): drive the clip-frame gate through the one landing at /`), changing only the test file:
- The test now reads the page's security policy from the Caddy `handle /` block, the real landing route. Before, it read an older gated block.
- `/` now serves `index.html`, and the test also serves `home.js` and a mock `/api/guest` that accepts one fixed fake guest and refuses anything else with 401.
- The page opens with a `#v=1&guest=<id>` link, so `home.js` takes the shell path. Every URL assertion now expects `${APEX}/`.
- I removed `/index.html` from the frame-navigation targets. It is now a redirect, and the test's own comment says redirects pass vacuously, so they are checked at their destination (`/`, already in the list). The frame-src check now targets `/` instead.
- The "no locator-shaped value in storage" check now ignores the guest-credential key, which `home.js` keeps in localStorage on purpose. Every other storage key is still checked.

No test was skipped and no check was weakened beyond those two changes. Before pushing, Chromium passed 29/29 locally. Firefox and WebKit could not run here because those browsers aren't installed, but both passed in CI. I pushed with `--force-with-lease` against the old head `364e0ea7`. One earlier background CI-polling loop hit its time limit and was stopped; I finished waiting with foreground polls, so it had no effect on the result.

I posted no PR comment because the job body didn't authorize one.

**next: none.** CI is green and the PR stays open and non-draft for its normal review path.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1505872 cached reads)
- Output: 8652 tokens
- Cost: $1.0978224000000003
- Wall-clock: 1438s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
