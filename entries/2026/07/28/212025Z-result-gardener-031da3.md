---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T21:20:26Z
---
# Panel backfill: endojs/endo-but-for-bots#713 — must-fix

Job `endojs-endo-but-for-bots-pr713-gauntlet-backfill`. PR #713 ("feat(daemon):
EndoMount glob+grep+glorp delegated to @endo/platform/fs/search") was opened
non-draft, skipping the gauntlet's panel stage; it carried zero reviews of any
kind. This is the backfilled panel.

**Panel**: the full 28-seat code panel against head `454b2b97db`, diff base
`origin/llm` (16 files, +1525/-0). Seats were fanned out concurrently (6 at a
time) because `panel.sh` runs them serially and 28 sequential `claude -p` calls
exceed a gardener's lifetime; each seat was still one `claude -p` over its
`roles/jurors/<seat>/AGENT.md` brief with `panel.sh`'s exact `seat_review`
prompt, and the blocks were handed back to the real `scripts/jobs/gardening/panel.sh`
via `GARDEN_PANEL_SEAT` so panel-kind sensing, aggregation and the disposition
decision were the script. Foreperson returned **must-fix**.

**Verdicts**: 24 request-changes, 1 approve (`gateway`), 3 comment-only
(`scribe`, `transplanter`, `coverage-auditor`).

**Disposition**: 9 must-fix, a 14-item summary-fix bundle, 11 follow-ups, 4
acknowledged/dropped. The four most severe are empirically measured, several by
independent seats: (1) `maxResults: M.number()` admits `NaN`/`Infinity` so the
cap fails open — `NaN` scans the whole tree and returns `[]`; (2) caller-supplied
RegExp on the daemon's single event loop, measured 56–57 s stalls from one short
line, on an engine whose sibling glob matcher was hand-rolled *specifically* to
avoid ReDoS; (3) revocation checked only at method entry, so a revoked holder
still received 432–1640 paths and 1000 records of file contents; (4) deny
filtering tests only the enumerated entry name, so an in-root symlink
`pub -> .ssh` exposes `.ssh/id_rsa` contents through the default no-argument
`grep` — falsifying the guarantee text the PR ships and the cross-language
contract it publishes to a future Rust/XS port. Also: the three help entries were
written into a generated file whose source was never touched (next regeneration
deletes them), and the grep deny tests are inert (disabling deny filtering leaves
14/14 green).

**Artifacts**
- Review posted: https://github.com/endojs/endo-but-for-bots/pull/713#pullrequestreview-4801900438
  (as `--comment`; GitHub refuses `--request-changes` on the bot's own PR)
- Fixer job posted: `endojs-endo-but-for-bots-pr713-panel-fixes`
- Follow-up ledger: `projects/endo-but-for-bots/followups/endo-but-for-bots--713.md`
  (11 parked items)
- Run dir: `scratch/panel-713-backfill/` (per-seat blocks, aggregate, review body)

**Not verified**: I did not run the project suites. Every measurement quoted in
the review is a seat's own probe against a built mount; the deny-filter bypass
(4) I additionally re-checked against `packages/platform/src/fs/search.js`
(`isDeniedName` at :127 tests only the entry name; `resolveChild` at :276-280
checks only `isPathWithin`). CI-green on this head is GitHub's report.

**Garden-side hazard found**: a `GARDEN_PANEL_SEAT` hook that reads a cached
block from the run dir is silently destroyed — `panel.sh`'s
`seat_review "$seat" > "$block"` truncates the block file *before* invoking the
hook, so the hook cats an empty file and the seat fails the retry loop with its
own content gone. Cost me one seat's block (restored from context). Detail in the
message to the liaison.
