I rebased kriscendobot/minion.town#198 onto current `main` and force-pushed it. GitHub now reports the PR as MERGEABLE; I did not merge it.

**What changed**
- The head branch `feat/beta-home-splash-waitlist` moved from `5ea6269` to `364e0ea`, on top of `main` @ `ea08cf05508`. I pushed with `--force-with-lease` pinned to the old head.
- All 23 commits were kept. Comparing old and new commits one by one, 17 are identical and 6 differ only where I resolved conflicts. The rebased PR changes exactly the same files as before.
- The PR's base stays `main`, as the job specified. I did not make a frozen `main-<sha>` snapshot because the job asked to rebase onto current `main`.

**How the conflicts were resolved.** They came up in 6 commits: `bbf6c15`, `cfb8bbd`, `83f7631`, `d9650ae`, `c2484cc` and one more that `main` had touched. Both sides had edited the same text:
- **What `main` added:** served clips with a canonical id are now framed live from their own `*.ocap.site` origin (design § 3.2), the gutter order is saved per owner, and a `PUT /account/clips/order` route exists.
- **What the PR changed:** one public landing page at `/`, the closed-beta splash, and shorter docs without history.

The resolution keeps the PR's wording and structure and adds `main`'s facts:
- **`designs/clip-shell-framework.md`:** the old "every clip still renders inert pending Open question #1" became "a served clip with a canonical id is framed live … every other clip renders as an inert card". The PUT order route is added to the list of routes that stay behind login.
- **`deploy/aws/www/index.html`:** the header comment now describes live framing in the first commit. A later PR commit cut that comment down, and I kept the cut.
- **`DEPLOYMENT.md`:** I kept the PR's shorter landing paragraph. `main`'s "Gutter order" paragraph is still there.
- I checked that the PR's new CSP on the landing page still allows `frame-src`/`child-src https://*.ocap.site`, so `main`'s live framing still works.

**Tests**
- The suites that cover the landing page, Caddy, the clip shell, `deploy-www` and the waitlist all pass (17 files, 361 tests).
- Full `npm test`: 1407 pass and 1 fails, `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`. That test also fails on a clean checkout of `main` using the same installed packages, and the PR touches no `git-remote` files.
- `tsc --noEmit` reports implicit-`any` errors only in `test/browser/clip-frame-gate.ts`, which comes from `main` and is not touched by the PR.

**Follow-ups**
- The proxy should re-screen the new head `364e0ea` and post a fresh conductor job.
- Outside this job: the failing `git-remote` test may need a look on `main` or in this host's environment.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `5ea626915dd62e50e5e79f36f76b26e9dc460dab`; this job presented `364e0ea7eb4be462d20430619e47cb3172505b60`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-minion-town-pr198-20261020.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1695137 cached reads)
- Output: 10908 tokens
- Cost: $1.0914114
- Wall-clock: 175s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
