## Weave: rebased the sturdyref stack onto the #1393 cycle fix

The whole stack (#1394 → #1396 → #1397 → #1398 → #1399) now sits on the new #1393 head 36c4f40bcd, which drops the `@endo/pass-style` devDependency that caused the "Cyclic dependency detected" CI failure. The heads were force-pushed with a lease check. No tests passed locally (the local test setup is broken, see below), so CI on the new heads is the only check on the rebased code.

| PR | New head | New frozen base |
|---|---|---|
| [#1394](https://github.com/endojs/endo-but-for-bots/pull/1394) captp-wire | 6450485a67 → **2d2a656b84** | `build/sturdyref-marshal-representation-36c4f40` |
| [#1396](https://github.com/endojs/endo-but-for-bots/pull/1396) captp-construct | 608307976c → **7a341141ca** | `build/sturdyref-captp-wire-2d2a656` |
| [#1397](https://github.com/endojs/endo-but-for-bots/pull/1397) ocapn-enliven | f212191840 → **267b1aa059** | `build/sturdyref-captp-construct-7a34114` |
| [#1398](https://github.com/endojs/endo-but-for-bots/pull/1398) daemon-formula | 1d4d84b796 → **8b57a39864** | `build/sturdyref-ocapn-enliven-267b1aa` |
| [#1399](https://github.com/endojs/endo-but-for-bots/pull/1399) agent-api (design) | cdf23ab930 → **aeb35421b2** | `build/sturdyref-daemon-formula-8b57a39` |

After the base changes, all five PRs report MERGEABLE, and the heads were confirmed unchanged afterwards.

**What changed besides the move:**
- **Stale pins fixed.** The upper layers had also fallen behind their own parents. #1396 was pinned to an older #1394 (dc0027b), #1397 to an older #1396 (ef45f1d), and #1398 was based on that stale #1397 base. Each layer now sits on its parent's current head, so they pick up the parents' later test and tsconfig commits.
- **One conflict, in #1396's `packages/captp/test/sturdyref.test.js`.** Both sides had added different tests at the same spot: #1394's unknown-export protocol-failure test and #1396's `makeOptsPair` and SturdyRef-from-data tests. I kept both; the file parses and passes Prettier.
- **Changed files per layer:** #1394, #1396, #1397 and #1399 touch the same files as before. #1398 no longer touches `packages/ocapn/tsconfig.composite.json`, because that regeneration now comes in through the #1394 base.
- **Lockfile:** `yarn install --immutable` passes on the #1398 head (the #1399 design layer on top doesn't touch it). No commits became empty.

**Tests:** I couldn't run them locally. Every test fails with `ReferenceError: assert is not defined` (SES isn't set up in this local build), including the untouched `captp/test/disco.test.js` on the old head. So this is the environment, not the rebase.

**Gauntlets:** I posted staged gauntlets for four PRs:
- `endojs-endo-but-for-bots-pr1394-20260930-gauntlet`
- `endojs-endo-but-for-bots-pr1397-20260930-gauntlet`
- `endojs-endo-but-for-bots-pr1398-20260930-gauntlet`
- `endojs-endo-but-for-bots-pr1399-20260930-gauntlet`

#1396 already had a gauntlet running (`ebfb-sturdyref-layer6-captp-construct-20260930-gauntlet`), which will pick up the new head. Its clean-stage agent was gone by the time I messaged it about the force-push, so the heads-up went to dead mail and may be promoted into a small no-op job.

**Follow-ups:**
- The old frozen bases (`…-f404dbc`, `…-dc0027b`, `…-ef45f1d`, `…-f212191`, `…-1d4d84b`) are still on origin; the conductor removes them when the PRs close.
- I didn't comment on the PRs, since the job didn't authorize it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-ebfb-1394-sturdyref-stack-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2058223 cached reads)
- Output: 13078 tokens
- Cost: $1.2221326000000001
- Wall-clock: 236s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
