Panel round 1 on endojs/endo-but-for-bots#1396 finished with a **must-fix** verdict, and I posted it to the PR as a review. Nothing was fixed or un-drafted; that is for later stages.

**Run:** the panel checked head `14e9810335` against the PR's base, `build/sturdyref-captp-wire-2d2a656` (`2d2a656b84`). `panel.sh` exited 0. All 33 reviewer seats ran: 13 asked for changes, 6 left comments only, and 14 approved.

**Posted review:** it went up at 2026-10-01T01:59:34Z as a **comment** review, not a request-changes review. The bot account authored this PR, and GitHub won't let an author request changes on their own PR. The body still says **must-fix** at the top and lists must-fix, should-fix and out-of-scope sections, followed by the full findings from every seat that didn't approve.

To get the review posted, I made three changes to the body:
- **Size:** the raw aggregate was about 85 KB, over GitHub's 65,536-character limit for a review. I listed the approving seats by name only (their findings were left out) and shortened the comment-only fast-checker block.
- **Truncation fix:** shortening that block cut through a code block, so I closed it to keep the review readable.
- **Links:** I wrote `#1394` and `#695` out in full as endojs/endo-but-for-bots links, because the fleet's `gh` wrapper refused the bare form when another repository is mentioned.

**Must-fix items for the fixer:**
1. `getSturdyRefData` in ocapn reads from a WeakMap shared by the whole module, not one per client. One client can read SturdyRef data another client created, so the "closely held" claim in the docs is false.
2. captp and ocapn each define a `SturdyRefData` type, and the two have different shapes. The `designator` and `objectId` fields and the type of the hint values all differ, yet the docs call it a shared vocabulary.
3. A new test helper uses abbreviated names: `makeOptsPair`, `leftOpts`, `rightOpts`.
4. The PR description names the wrong frozen base for layer 5. It says `dc0027b`, but the PR is built on `2d2a656`.
5. The PR description doesn't explain why there are no xs tests. `test:xs` is `exit 0` in both touched packages.

**Main should-fix items:**
- ocapn doesn't check that each hint value is a string, unlike captp.
- `designator` here means the network, but in `OcapnLocation` it means the peer's public key.
- A `Uint8Array` secret is stored and returned without being copied or frozen.
- `SturdyRefData` isn't exported from either package's public entry point.
- captp's locator returns `undefined` for an unknown object id instead of rejecting.
- The PR description could be shorter.

**Follow-ups:** none from me. The next stage is the fixer.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1207116 cached reads)
- Output: 8135 tokens
- Cost: $0.9415072000000002
- Wall-clock: 747s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
