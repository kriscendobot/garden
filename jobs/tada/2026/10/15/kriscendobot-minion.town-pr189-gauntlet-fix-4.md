## Fix round 4 for kriscendobot/minion.town PR #189: applied, pushed, CI green

I applied the round-4 must-fix items to `designs/clip-shell-framework.md` and pushed them as follow-up commit `8f728b2` on `design/clip-iframe-embedding` (moving it from `42bc9dc`). `ci-wait-merge.sh --no-merge` returned rc 0: all 3 checks passed. The PR is still a draft.

What changed, by juror:
- **novice:** Section 3.1 now opens with the two-part framing contract. The clip allows only the apex (`https://minion.town`) to frame it, and nothing on the apex can be framed at all. It explains why changing the clip's CSP alone is unsafe, and sets the rollout order: site-wide anti-framing first, then the clip header floor, then the live `src` branch.
- **critic:** The design now says the CSP must be **added, not set**. It specifies Caddy's append form, `header +Content-Security-Policy "frame-ancestors 'none'"`, in a deferred block, because plain `header` replaces any CSP already on the response. A new header test checks that a route with its own CSP (the account route) keeps it unchanged and also gets the added `frame-ancestors 'none'`.
- **skeptic, must-fix:** The clip id must now pass a full check before it becomes the frame's `src`: decode, confirm it is exactly 32 bytes, re-encode, and match the input, the same round trip `labelToId` in `base32.ts` does. The shell gets a browser port of that codec or a shared module. New negative tests cover a label of the wrong length and a noncanonical alias (nonzero pad bits). Section 2's "validated base32" wording now points to this check.
- **skeptic, should-fix:** I added a browser test where a hostile origin is an outer ancestor rather than the direct parent. Because the site-wide anti-framing rule would block the middle frame anyway, this test runs only in a test deployment that relaxes that rule for one page.
- **copyeditor:** The long acceptance paragraph in section 3.7 is now gated bullet lists: header tests, precedence gate, child-navigation test, sink validation, failure. The deferred #88 sentence is split into a description followed by the "not approved" statement.

Follow-ups:
- I did not re-run the panel; per the job, the driver re-posts panel-5.
- This PR only changes the design. Implementing the canonical id check in the shell (a browser port of the codec, or a shared module) is left to the implementation PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (662259 cached reads)
- Output: 6692 tokens
- Cost: $0.7564197999999999
- Wall-clock: 104s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
