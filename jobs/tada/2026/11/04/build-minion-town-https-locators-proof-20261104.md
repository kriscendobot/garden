---
handed-off: build-minion-town-https-locators-browser-proof-20261104
deliverable-complete: false
---
I finished four of the five items on draft PR https://github.com/kriscendobot/minion.town/pull/240 and handed off the fifth, the real-browser and Caddy log proof, to a successor job. CI is green on the new head (7/7 checks), the PR is still a draft, and nothing was deployed.

**One change from the plan: #240 is now stacked on #239.** The tool-minimalism job's draft PR #239 had already fixed the evaluate side: the accept route takes `{ locator, petName }`, and a real-daemon test covers an `evaluate` mint, web accept, mail both ways, and a 404 on replay. Rather than build a parallel route, I merged #239's commit unchanged into this branch, so #239 should merge first. The PR body says #239 owns the evaluate fix.

**Done on the branch:**
1. **`/adopt` and link errors.**
   - Caddy now serves the landing page at `/`, `/accept` and `/adopt`, and the route-admission record matches.
   - The page reads `#v=1&locator=` on either path and redeems it through the visitor's guest, creating one first if needed. An `invitation=` id on `/adopt` counts as malformed.
   - A malformed link and a spent invitation each show fixed error text that repeats nothing from the link, and the visitor keeps their existing guest.
   - **Limit:** `/adopt` only handles locators the daemon accepts as invitations. Adopting other capabilities would need a power the pinned Endo version doesn't give a guest. The PR says so.
2. **Evaluate-minted invitations.** These now work through the https link. An agent mints with `E(E(agent).invite(n)).locate()` and hands out `https://minion.town/accept#v=1&locator=<encoded>`; the bare `endo://` form also still works.
3. **Pasted locators.** The accept route is the only place on the site where a user pastes a locator, and it now accepts either form, refusing links for another origin. The settings remote invitation from #236 is a locator printed for the `endo accept` CLI to consume, not something pasted into the site, so it stays `endo://`.
4. **Real-browser proof: not done.** No Caddy binary or Endo checkout was available on this host. It is now job `build-minion-town-https-locators-browser-proof-20261104`, on the same branch: a Playwright test over a real daemon, fronted by a local Caddy with the repo's config, checking both logs for fragment text.
5. **Threat notes** for referrers, link-preview crawlers, browser history, the #173 leak signal and error messages are in the PR body, which is now written as a production-outcome report.

**Tests:**
- The affected suites pass (235 passed, 6 skipped). The skipped ones are the real-daemon suite, which needs an Endo checkout.
- New tests cover reading and scrubbing locators, error text with no fragment content, and accepting both locator forms while refusing a foreign origin.
- `tsc --noEmit` is clean.
- The full local run has one failing test and two suites that won't load (`git-remote/capability.test.ts`, `tools/claude-harness/*`). They are in code this PR doesn't touch, and they look like the known false failures from the bot host's git wrapper and sandbox.

The tool-minimalism job had already completed, so I didn't message its inbox; that would have spawned a new job. The ownership split is recorded in the PR body instead.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-https-locators-proof-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3770141 cached reads)
- Output: 25784 tokens
- Cost: $2.0943801999999994
- Wall-clock: 662s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
