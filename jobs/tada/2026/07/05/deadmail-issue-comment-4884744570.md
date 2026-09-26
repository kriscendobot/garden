Reply posted to the issue thread. No garden-repo code change was warranted — this was a technical-opinion request from a maintainer (dckc), answered on the issue as required (issue/PR comms go via comments, never the maintainer inbox; issue left open for the submitter to close).

## Completion report

**Job:** Dead-lettered message for `issue-kriskowal-garden-25` — dckc (a maintainer) commented on kriskowal/garden #25 asking @kriscendobot for an opinion on `makeSheetsORM` in `dckc/finquick:packages/lm-sync/src/sheetsAccess.js`, relative to the Google Sheets connector sketched earlier in the issue.

**What I did:**
- Read the issue thread (my prior "SheetSync in Endo" ocap sketch) and fetched the referenced `sheetsAccess.js` plus its `gcORM.js` base to ground the answer in the actual code.
- Assessed `makeSheetsORM`: it's a real, working instance of the "sheet facet" my sketch proposed — a maker taking one authority (`GoogleSpreadsheet doc`), returning a `freeze()`d narrow object (`lookup`/`getPage`/`update`/`highlight`/`commit`), with the broad `doc` captured in-closure and never returned, and Passable args/returns that marshal cleanly across a vat boundary.
- Named the concrete deltas to turn it into a true Endo capability: (1) `Object.freeze` → transitive `harden`; (2) the real POLA hole — `lookup().get()` returns the **live** `GoogleSpreadsheetRow` and `update()` `Object.assign`s onto it, leaking mutate authority; return a data copy and take edits by value; (3) throw `Error`, not bare strings, for clean cross-vat rejection; (4) cache-staleness for a long-lived facet. Noted the OAuth/token custody stays in the connector that constructs `doc`.
- Posted the reply as an issue comment: https://github.com/kriskowal/garden/issues/25#issuecomment-4887009634

**Changed:** Nothing in the garden repo (discussion-only; no commit/push). Issue left open.

**Follow-ups:** None required. The still-open ingestion follow-up from my earlier comment (scholar-ingest of Plaid + Endo caplet docs) remains the clean next step if the maintainer wants the connector work captured in the library, but that's not blocked on this reply.
