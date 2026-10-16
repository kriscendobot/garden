## FIX round 1 for endojs/endo-but-for-bots PR #1479: done, CI green

I applied the panel-1 findings in one follow-up commit, `f188f851c`, on `docs/ocapn-tcp-syrup-framing-status`. I pushed it with `safe-push-pr-head.sh` as a plain fast-forward from `c5bcbca27`. `ci-wait-merge.sh --no-merge` then returned rc 0: 30 of 30 checks green, none failed.

**Findings and what I changed:**
- **README rows still described the unshipped plan** (skeptic and pedant, must-fix). The `designs/README.md` estimates row for this design said `@endo/syrups`, `tcp+syrups` and "impl PR #109 open". It now says the design is complete, names `@endo/syrup-frame` and the default `framing: 'syrup'` on the existing `tcp-testing-only` netlayer, cites commits 38fe6787d and bdb9ddc50 plus design PR #108, and states that the proposed package and netlayer were not built. PR #109 was closed without merging, so the row no longer claims it. I also changed the `syrups` package row to say it was consolidated into `@endo/syrup-frame`.
- **The design read as two conflicting models** (ergonomist and novice must-fix; critic, decomplector and copyeditor should-fix). In `designs/ocapn-tcp-syrup-framing.md` I replaced the old status section with an authoritative **As Built** section. It covers:
  - the package and its exports, with a short file layout;
  - the netlayer's `framing` option (`'syrup'` by default, `'none'` only for the Python test suite), which is Option 3 and replaces the old Option 2 recommendation;
  - an explicit statement of the tradeoff. Both framings share one network identifier, so a locator can't tell which one a peer speaks and the two sides must agree out of band. This drops the locator-level disambiguation the original Option 2 and Design Decision 5 promised.

  Everything after that now sits under a new **Original Proposal** heading. It opens with a note saying which parts the As Built section overrides: the package name, export names, the `tcp-syrups` identifier, the Option 2 recommendation, the layout and the phases. I moved that text's headings down one level so they nest under it.
- **Wording** (copyeditor): "shipped on `llm`" now reads "shipped to the `llm` branch".
- **Test evidence overstated** (skeptic, should-fix). The As Built section now says what each test file covers. Reassembly across chunk boundaries is tested in `syrup-frame.test.js`. `netlayer-tcp-syrup.test.js` checks the bytes on the wire, a round trip and rejection of a bad option, but doesn't itself split a message across TCP reads. I narrowed the claim rather than adding a test.
- **Skipped:** the pruner's suggestion to trim the PR description. It was comment-only.

Prettier passes on both files. No follow-up jobs; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1479-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1422109 cached reads)
- Output: 8511 tokens
- Cost: $0.9943538000000001
- Wall-clock: 1186s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
