## Fix round 1 report: kriscendobot/garden-book PR #12

I applied every must-fix item from the panel's round-1 verdict and pushed them as two follow-up commits. PR #12 now points at `634e04b`. `npm test` passes (47 of 47). The PR stays in draft.

**About CI:** garden-book has no CI at all (no `.github` directory, no checks), so `ci-wait-merge.sh` returned green only because I set `GARDEN_CI_ALLOW_NO_CHECKS=1`, the script's switch for repos without CI. The clean stage did the same. My first wait without that switch would just have sat out its full hour on an empty check list, so I stopped it.

**A second push landed while I worked.** Another job pushed `479fb39` ("illuminate equilibrium charts") to the PR branch. I rebased my commits on top of it, kept both chart commits and all their files, and regenerated the two charts that changed. A message from the supervisor asked for exactly that.

### Must-fix items
- **breaker (the cost of one review round, `c`):** `c` had been built from 10 ledger events, 9 of them OpenAI's provisional prices, then divided by a ratio that only applies to Anthropic. It is now the median cost of an endo-but-for-bots panel-stage job plus a fix-stage job, using only Anthropic usage allocated against the subscription. That rests on 611 and 540 jobs, and gives $0.2636 a round (it was $0.2418).
  - The scenario now records how many records each input rests on and refuses to run if an input is missing.
  - I regenerated `scenario.json`, charts E8 and E9, the tables in the chart brief, the chapter numbers (the $400 optimum moves from 41 to 42 minutes; machine work over six rounds is about $1.58), the evidence notes and the MANIFEST.
  - I also fixed breaker's two should-fix items: the chapter now says `d` (79%) is measured after machine review, and it no longer claims the six-round cap supports the assumed curve.
- **stylist:** `--rev` is now `--revision`. "pr" is spelled out as "pull request" in identifiers and JSON keys throughout `analyze.mjs`, `scenario.mjs`, the chart generator, the tests and the MANIFEST.
- **prover and corner-prober:** the pure rules moved into a new `tools/equilibrium/rules.mjs` so they can be tested directly.
  - New unit tests pin the edge cases of the statistics helpers, the human-reviewer filter, the regime classifier (each branch), the pull-request and stage parsing, and the pricing formula.
  - A hand-worked check of the scenario confirms the $1,600 curve's value at 0 minutes ($1,311.26), so a formula bug baked into both code and committed data would now be caught.
  - A new end-to-end test runs the real `analyze.mjs` over a fake journal and GitHub fetch seeded with marker text and confirms none of it reaches the output. I checked that it catches a leak by temporarily making `analyze.mjs` emit a review body; the test failed as it should.
- **archivist (two cross-repo links):** I kept the book's existing convention rather than switching to absolute URLs. More than 350 links in the book use the same relative style, and the build already rewrites them. I confirmed in the built book that both links resolve: to the chapter 6 skill entry and to `main2` on GitHub. `README.md` now explains the convention and lists `tools/` and `data/`.
- **pruner:** I cut the PR body's "What changed" and "Checks" sections to one short paragraph each, updated the GitHub fetch time, and removed the stale "charts are not in this stage" line.

### Should-fix items I also took (all small)
- `analyze.mjs` now resolves the revision to one commit before using it, and deletes its temporary copy of the journal when it exits.
- Unparseable usage lines and unresolvable improvement commits are counted in the output instead of silently dropped.
- A month with zero list-price cost no longer produces an infinite allocation factor.
- An empty set of values now reports a total of null rather than 0.
- `fetch-github.sh` no longer turns a failed `gh` call into empty output that looks valid.
- The $125/hour rate is defined once and shared by both scripts.

### How I verified the data
Rerunning `analyze.mjs` at `journal2` revision `6485a3b8` with a fresh GitHub fetch reproduced the committed `aggregates.json` exactly, apart from the fetch time. After my changes, the only differences are the new stage-cost fields, the renamed keys, and two new counters, both zero. Rerunning again on the final code matches the committed file byte for byte.

### Not done
Still open from the panel's should-fix list:
- **Typography:** non-ASCII symbols (×, Greek letters) outside the model formulas, which I did convert to plain ASCII names.
- **Provider basis:** moonshot, local and fireworks events are still included in the per-event estimated-cost totals.
- **Report names:** 13 completion-report names repeat; they are now resolved in sorted order but not counted.
- **Commit split:** the integrator suggested splitting the original commit three ways.
- **CI:** garden-book has none. A one-job `npm test` workflow would let future stages drop the no-checks switch.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-data-draft-20261004-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (7887530 cached reads)
- Output: 43667 tokens
- Cost: $3.7562300000000004
- Wall-clock: 1155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
