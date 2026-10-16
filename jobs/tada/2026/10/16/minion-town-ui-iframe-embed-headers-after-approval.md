## Completion report: minion-town-ui-iframe-embed-headers-after-approval

The previous attempt had already finished the work, and I didn't need to change anything. It committed and pushed the implementation and opened draft PR **https://github.com/kriscendobot/minion.town/pull/194** (`feat/clip-embed-headers` → `main`, head `cc666e6`, marked with the job's `garden-job` tag). `ensure-pr.sh` found that PR and adopted it, so no duplicate was opened.

**What I checked:**
- **Design state:** #189 is still open and not merged. The maintainer's approval comment says the final wording is the head of `design/clip-iframe-embedding`, which is `7d3d9fb` (the ocap.site shell-frame and same-clip-id revisions, 17:02Z). The PR commit was made after that, at 17:42Z, so it was built against the final approved wording.
- **Match with the design:** `src/endo/gateway/isolation-headers.ts` now sends `frame-ancestors https://minion.town`, held in an exported `CLIP_FRAME_ANCESTOR` constant. Everything else in the header floor is unchanged, including XFO DENY, CORP/COOP/COEP and no CORS. This is exactly the clip CSP in design §3.1.
- **Rest of the PR:**
  - Every `minion.town` response gets `frame-ancestors 'none'` plus XFO DENY, including Caddy's own error pages. A route-admission list is checked by a test.
  - The shell's CSP is now exactly `frame-ancestors 'none'; frame-src https://*.ocap.site; child-src https://*.ocap.site`.
  - `www.minion.town` only does a 308 redirect to `https://minion.town`.
  - The production probe expectation and the deploy smoke probe are updated to match.
- **Tests:** the new `test/caddy-framing-floor.test.ts` checks that only the approved ancestor (`https://minion.town`) can frame a clip, and that framing stays blocked for every other embedder and route. I re-ran it locally with the account-routes, shell-clip and gateway suites: 21 files, 266 tests, all passed. The PR body also records an earlier real-Caddy v2.10.2 curl run of the headers.
- **CI:** the "test (typecheck + vitest)" run on `cc666e6` passed. On this host the token can't read the PR's check summary, so I checked the Actions runs API.

**Follow-ups:**
- #194 is still a draft. The review and fix steps that follow a successful build job are posted automatically when this job completes.
- The live `src` frame and the three-browser check of whether `frame-ancestors` overrides XFO are left for the later live-frame increment, as the design says.
- The PR notes that the gateway deploys a few minutes before Caddy, but nothing is exposed in that gap, because no `minion.town` page frames a clip yet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-iframe-embed-headers-after-approval.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 100 tokens (4458838 cached reads)
- Output: 41353 tokens
- Cost: $3.0973476
- Wall-clock: 1773s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
