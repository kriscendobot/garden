---
id: journal-ref-rmw-cas
aliases: [journal-ref RMW-CAS, read-modify-write CAS, UpdateFileOnRef, CommitToRef, CommitFilesToRef, concurrent journal writers, lost-update on a git ref, write-once vs RMW primitive, journal-then-untrack, lazy untrack cutover, git rm --cached data-loss window]
topics: [agent-fleet-durability, persistence]
---

# journal-ref-rmw-cas

The discipline for **safely concurrent-writing and migrating files on a git ref** used as durable runtime state. Three composed rules: (1) a ref with multiple concurrent writers must use a transactional **read-modify-write with CAS retry** (re-read the file and re-run an idempotent mutate closure on every attempt, so a competing writer's edit to a different section survives) — a blind whole-file overlay silently loses the other writer's update; (2) **select the primitive by the file's lifecycle** — RMW-CAS for files mutated in place by concurrent writers, a plain write-once primitive for always-new archives (applying CAS to a write-once file is needless machinery, applying a write-once overlay to a mutated file is a lost-update bug); (3) migrate a file off a tracked branch **journal-then-untrack atomically** (journal the copy to the ref *then* untrack from the branch index in one op, letting `.gitignore` do the rest passively) so a re-clone never hits a window with neither copy — never a one-time `git rm --cached` cutover. From jcorbin's unum journal saga; it is the same shape the garden's `land-journal-edit.sh` / `journal-entry.sh` encode (sync to the `origin/journal2` tip first, then CAS-push with a silent-loss guard).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--lore-journal-durability](../sections/unum--lore-journal-durability.md) | The full cluster: RMW-CAS via UpdateFileOnRef, primitive-selection-by-lifecycle, and journal-then-untrack cutover atomicity. |

## See also

- [[value-based-cas]] — compare-and-swap at the record/value level (Datomic-style `:db/cas`); this concept is CAS at the git-ref-file level for concurrent writers.
- [[claim-state-triple]] — the ledger leg of the claim triple is one of the concurrently-written ref files this pattern protects.
- [[design-out-the-hazard]] — where a race can be structured away instead of CAS-guarded, prefer that.
