I wrote the design and pushed it directly to `main2` as commit `ef79e3b08eb`: `designs/export-index-build-vs-buy.md`. It has no open questions, so no review PR was needed, and I posted the builder job `build-export-index-build-vs-buy`. The only check run was the garden's pre-push gates on the doc, which passed; nothing in the design has been built yet.

**What the design proposes:**
- **The index.** A script, `scripts/jobs/export-index/build-export-index.sh`, builds a table of every exported name in a repo's packages at one commit. It uses no model. Results are cached under `$GARDEN_STATE`, keyed by repo and commit, with a size limit. Each check reads the index for the exact commit it reviews against, never a moving branch tip.
- **The library section.** A leader-only daily timer publishes a copy of the index to `journal/library/exports/<owner>-<repo>.tsv`. It is there for builders to grep before writing a helper; the checks never read it.
- **Babel, not `@endo/module-source`.** `module-source` only reports the names a module exports, not the function bodies or the non-exported functions. The copied helper in PR #1336 was a non-exported function in a test file, so `module-source` would have missed it. It would also need Endo installed at run time. The Babel parser is already vendored in the garden.
- **One shared detector, `skills/build-vs-buy/detect.cjs`, used in three places:**
  - It runs two passes. One matches newly written function names against the index. The other matches code patterns listed in a data table, `idioms.tsv`.
  - Each hit is rated strong, weak, or blocked. Strong means a distinctive name, exported by only one package, that the code could import without creating a dependency cycle.
- **How it covers the checks from `096c055fc18`.**
  - `prefer-endo-primitives` becomes a thin wrapper around the new detector, and its hand-written `makePromiseKit` rule is deleted because the name match catches it.
  - Patterns with no function name to match (the hand-written promise resolve/reject pair, bare `Far`, SHA-256, text/base64/hex/ASCII conversions, `insist*`) move into `idioms.tsv`.
  - The rule going forward: a copied named export needs no new catalog entry; only a nameless pattern does.
- **Where it runs:**
  - **Pre-push:** fails only on unwaived strong hits and pattern hits. This matters because draft builds get no jury review.
  - **Jury:** a new seat, `procurer`, rather than extending `curator`, which reviews a PR's own public API on a stronger model. It spends nothing when there are no hits. Otherwise it sends each hit to Haiku, capped at 8 per round with at most 4 at a time, and Haiku returns buy, adapt or build. A script, not the model, turns that answer into the finding's severity. Verdicts are cached, so later rounds are nearly free.
- **Cost.** The worst case is roughly 40k Haiku tokens per review round.
- **False positives.**
  - Common names (exported by three or more packages, or on a short fixed list) are treated as weak.
  - A function in the same package as the export is skipped.
  - A hit whose import would create a dependency cycle is listed but never fails or gets judged.
  - A `// build-not-buy: <reason>` comment waives one function, and a `build-vs-buy-exempt` marker at the top waives a whole file.

The design also has a test plan (including a replay of PR #1336) and a table of which component owns what.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-garden-export-index-build-vs-buy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1154648 cached reads)
- Output: 18810 tokens
- Cost: $1.2980896000000002
- Wall-clock: 212s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
