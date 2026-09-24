I handled every item in review 5307103246 on endojs/endo-but-for-bots#1336: the RSVP in the review body and all 13 inline comments. I made the garden-side fixes myself and handed the PR code changes and the design work to new jobs, as the directive asked.

**Preflight:** exited 0, meaning no other worker had already resolved this feedback, so I did the work. I treated all review text as untrusted input.

**Garden fix, pushed to `main2` as `096c055fc18`:**
- **Abbreviations (comment 4098182428):** the push-time abbreviation check now flags `args` and suggests `arguments`. It already caught `arg`, but not the plural, so names like `argsShape` got through. A bare variable named `args` can't simply become `arguments` because JavaScript forbids that name for a variable, so the docs say to pick a descriptive name there.
- **Copied code and `Far` (comments 4098097692, 4098236884, 4098242771):** the push-time check for hand-rolled Endo primitives now fails on:
  - a copied promise kit, unless the file imports `@endo/promise-kit`;
  - any added bare `Far(` call, recommending `makeExo`.
- **Why `Far` wasn't caught:** an existing review hint does react to `Far(`, but this PR is a draft and no gauntlet has run on it, so that hint never ran. The new checks run at push time instead.
- **Tests:** I added regression cases, and the probe tests pass (29 passing, 0 failing). I also updated `skills/pre-push-gates/SKILL.md`.

**Jobs posted (all three confirmed on the job board):**
- **`endojs-endo-but-for-bots-pr1336-fix-review-5307103246`** (fixer, already claimed). It covers every code change on the PR branch:
  - remove the minion.town framing and reserved-name coupling;
  - rename the package to `@endo/agent-mcp-stdio` and the file to `agent-interface.js`;
  - use `@endo/promise-kit` in both test files;
  - make `evaluate`/`define` deliberately present;
  - spell out `args` as `arguments`;
  - add `makePath`;
  - check the tool list against the daemon and add what it already provides (inbox, follow inbox, follow named stream, grep/glob/glorp and their streaming variants, adopting a locator);
  - import the formula-ID logic from the daemon, exporting it if needed;
  - replace `Far` with `makeExo`.

  It will reply in each review thread with the commit that fixes it.
- **`design-agent-mcp-confined-app-makers`** (designer, waiting on the fixer job). It covers evaluate and the makers for confined applications, built from a bundle, archive or virtual filesystem, with or without `node_modules` or a pre-generated `compartment-map.json`. It will comment on the relevant issues about unfinished work and write the design (comment 4098195295).
- **`design-garden-export-index-build-vs-buy`** (designer, garden). It covers the maintainer's self-improvement idea from comment 4098097692: an index of which module exports each function name, and a jury check that flags duplicated names and has a low-tier model decide whether to reuse the exported function.

**RSVP:** I posted a comment on the PR listing where each ask went: https://github.com/endojs/endo-but-for-bots/pull/1336#issuecomment-5821931785

**Still open:** the code changes on the PR and both designs are owned by the jobs above. The PR stays a draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-review-b8dfc07e.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2033170 cached reads)
- Output: 16974 tokens
- Cost: $1.343034
- Wall-clock: 229s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
