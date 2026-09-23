Backstop dependabotany sweep over the `endojs/endo-but-for-bots` ledger, run 2026-07-28T07:26Z. **No row was due; no disposition executed.**

**Ledger state recovered.** Newest-first read of the ledger entries shows the open embargoed set was drained to empty on 2026-07-01 and reopened at 2026-07-28T01:14Z with exactly one row:

| PR | Verdict | Maturity floor | Base |
|---|---|---|---|
| [#868](https://github.com/endojs/endo-but-for-bots/pull/868) (`eslint-plugin-unicorn` 56.0.1→72.0.0) | EMBARGO-2026-08-02 | 2026-08-02T16:39:39Z | `llm` |

The floor is five days out, so the sweep correctly no-ops — this is the intended division of labour between the precise one-shot and the daily backstop.

**Terminal-state check (sweep precondition).** `#868` is `state: OPEN`, `mergedAt: null`, `closedAt: null`, head still `f8cf6acf688cff25033412355d2047609d2e9cc2` — neither merged nor closed-as-superseded by dependabot, and not force-pushed (so the maturity floor has not reset). Row stays open.

**Backstop verification (the point of this job).** Both legs of #868's recheck wiring were verified present rather than assumed:
- `schedules/dependabotany-recheck-endo-but-for-bots-pr868.md` — intact, `once: 2026-08-02T17:15:00Z`, full re-evaluation brief in the body.
- `schedules/dependabotany-recheck-endo-but-for-bots.md` — present (it dispatched this job); retained, since the embargoed set is non-empty so the termination clause does not apply.

**Standing blocker, unchanged.** `lint` is still red on the live head (1 of 22 checks; the 7 `unicorn/numeric-separators-style` errors from v72's new `fractionGroupLength` default). The fixer job `endojs-endo-but-for-bots-pr868-lint-fix` is live in `jobs/doin/`, not lost.

**Changed:** one journal entry appended — `entries/2026/07/28/072747Z-message-botanist-b303a6.md`, tagged `project: endo-but-for-bots`, recording the sweep, the unchanged open row, the terminal-state check, and the wiring verification. No garden-repo (`main2`) changes were needed, so nothing was pushed there. No PR comment posted (no verdict to render).

**Follow-ups:** (1) if `endojs-endo-but-for-bots-pr868-lint-fix` has not turned `lint` green by 2026-08-02T17:15Z, the one-shot's own instructions require re-escalating and re-embargoing rather than merging; (2) five other dependabot PRs opened 2026-07-26 (#866, #867, #869, #870) and the older 2026-05/06 batch have their own `*-dependabot` jobs sitting in `jobs/todo/` — outside this sweep's scope (it covers embargoed ledger rows only), but that queue is not draining and may warrant a liaison look.
