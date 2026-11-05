**FIX round 3 for PR #1652: all panel-3 must-fix items are applied and pushed, and CI is green.** The head moved from `6ac6b4e5d7` to `7041c0f28f` in eight follow-up commits. `ci-wait-merge.sh` returned rc 0 with 31 checks and 0 failed, using the full 3600s deadline. This PR changes only docs, so I ran no local tests, only a line-length check on the design doc.

| Commit | Finding (juror) | Change |
|---|---|---|
| `45aaef4aab` | Link equality promised exact bytes but sent only a digest (critic, skeptic) | Links can't be compared across identity domains: neither locator bytes nor a digest cross. The comparison answers `false` on any other difference, and otherwise throws the new `REFERENCE_INCOMPARABLE`. It never answers `true`. A foreign `expected` holding a link always throws this error. The same-domain digest now states its collision-resistance assumption, and adversarial tests are added. |
| `61debf017d` | `DataStore` values assumed to be Keys (skeptic) | Stores holding non-Key values stay valid entries with typed operations and a non-strict snapshot. `identity`, `equivalent`, strict `snapshot` and `expected` throw `UNSNAPSHOTTABLE_ENTRY` for them. Weak stores are reachable only through a link. Tests are added. |
| `c36c88ca1c` | `EntryKind` mixed content category with snapshot posture (decomplector) | Kind is now `Blob`, `Tree`, `Log`, `Data` or `Link`, and a snapshot keeps its kind. The facet's methods express posture and authority. |
| `1cabd84ed8` | Result `path` values undefined (ergonomist); `has(path)` convention (should-fix) | Every result `path` is a `Path` array relative to the receiver, so it feeds `lookup` directly. Traversal methods take one `Path`, with adapters for the variadic forms. |
| `0dfa9bdd6d` | Merge example ended on an unspecified operation (novice) | The example now uses `L.diff(merged)` and then `applyPatch` with `expected`, so it adds no new API. |
| `33ae5f6f62` | Remaining should-fixes (critic, skeptic, novice) | Adds one shared path-segment guard with symlink containment and a controlled method surface that stays the same across policy flips. `ResultReader` is now defined before the tables that use it. The grep `text` field gets a concrete recovery handle. |
| `20627e4026` | Copyedits (copyeditor 4, pedant 1) | Fixes the comma splice, the reversed "no failure" clause, the tangled transport sentence, the ambiguous "it", and the extra blank lines in `designs/README.md`. |
| `6472a0e04a`, `7041c0f28f` | Table rows too wide (pedant) | Converts 12 wide tables to nested lists with the same content, and sweeps up stale "category" and "table" wording. |

**For panel-4 to check:**
- **My design choices, not the panel's:**
  - The `REFERENCE_INCOMPARABLE` error.
  - Remotables are treated like links across domains.
  - `\` is rejected in path segments, which is stricter than the implemented `isValidName`.
  - Only the grep `text` field can be omitted from a record.
- **Wider than asked:** the pedant flagged the source map and ownership map tables, but I converted every table with a row over 100 columns.
- **Not applied:** the decomplector's should-fix to leave block, log and data stores as links, because it contradicts kriskowal's inline comment naming `BlockStore`, `LogStore` and the rest.

**Maintainer review still open:** kriskowal's review 5782081346 ("rsvp" plus nine inline comments) was outside this job, so none of it is applied. It covers:
- `Cell` and `MapStore` naming
- hash-line methods
- `snapshot`/`capture`
- `keep`/`drop`/`insert`
- `narrow`
- compare-and-swap instead of locks
- a signed locator file

About 40 minutes after it was submitted, the board had no job for it, and I can't tell whether the comment watcher is lagging or dropped it. I messaged the maintainer asking whether to post a job or wait for them to re-trigger it. Whichever job picks it up will rename `CapabilityLink` and `DataStore`, including this round's `Link` kind.

The panel posted its verdict as a comment review with no inline threads, so there were no thread replies to make. I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1706151 cached reads)
- Output: 38726 tokens
- Cost: $2.1294302000000003
- Wall-clock: 1549s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
