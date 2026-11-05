**FIX round 2 for PR #1652: all 17 findings from the latest panel review are applied and pushed, and CI is green.**

The head moved from `4e280a46e2` to `6ac6b4e5d7` as seven follow-up commits, all in `designs/unified-virtual-filesystem.md`. `ci-wait-merge.sh` returned rc 0: of 31 checks, 7 passed, 24 were skipped and none failed. I set its deadline to 540s rather than the 3600s the job specified, but it went green before that ran out. This PR changes only docs, so I ran no local tests, only a line-length check.

| Commit | Finding (juror) | Change |
|---|---|---|
| `cdc3411c8f` | Controlled view never tied to a branch (novice); wrong `PRECONDITION_FAILED` wording (critic) | Added `makeController`, `makeBranch` and `controlled(k, branch)` with a complete worked setup. Only a competing commit now fails a controlled mutation, and every dynamic denial throws `ACCESS_REVOKED`. |
| `78eba68b07` | Entry kinds, missing-path behavior and strict snapshot option unspecified (ergonomist, 3 findings) | Added `kind()` with `EntryKind`, `{ name, kind }` and `{ path, kind }` list records, and the `has`/`lookup`/`maybeLookup` convention. Also added `snapshot({ strict = false })` and `CapabilityLink.resolve()`. |
| `c94e471942` | Cross-provider `Snapshot.equivalent` assumed connectivity (skeptic) | The caller holding both operands acts as the bridge and may relay. A severed connection throws the new `SNAPSHOT_UNREACHABLE`, never `false`. Foreign pulls run outside the provider transaction. |
| `25437fb296` | Safety limit doubled as a completeness cap (decomplector) | `limitResults` now sets only resource bounds, and an oversized record no longer ends the reader. A total cap is now an explicit grant, `withResultBudget({ records })`, with its own `RESULT_BUDGET_EXHAUSTED` error. |
| `ef776802c1` | Mutable transform sources (critic); worked example didn't match the API (novice) | Every transform source must be a `SnapshotBlob`. The move-a-function example now uses the exact operation shape, including the insert and delete steps. Added `lineByteRange` so it can get offsets without reading content. |
| `5c514ddf9e` | Hostile archive member names (skeptic) | Restore gets a new first step that checks raw and NFC-normalized names before reading the manifest, in every link mode. Failures throw the new `ARCHIVE_MALFORMED`. |
| `6ac6b4e5d7` | Copyedits (copyeditor, 3 findings; pedant, 2 findings) | Fixed `../packages/` paths, the comma splice and the long line. The conformance list is now grouped, with the hostile-archive tests added. The "cap becomes a reader" sentence was fixed in `25437fb296`. |

**For panel-3 to check:** these fixes add design surface the panel didn't specify, so it is my choice rather than theirs:
- **New API:** `makeBranch`, `withResultBudget`, `lineByteRange`, `resolve` and the `SnapshotLog`/`SnapshotData` kinds.
- **New error codes:** `SNAPSHOT_UNREACHABLE`, `RESULT_BUDGET_EXHAUSTED` and `ARCHIVE_MALFORMED`.
- **Behavior choices:**
  - Strict snapshots reject every capability link.
  - A link's locator crosses a comparison only as its digest.

The panel posted its verdict as a comment review with no inline threads, so there were no thread replies to make. Per the job, I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (795831 cached reads)
- Output: 33409 tokens
- Cost: $1.6617142
- Wall-clock: 1139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
