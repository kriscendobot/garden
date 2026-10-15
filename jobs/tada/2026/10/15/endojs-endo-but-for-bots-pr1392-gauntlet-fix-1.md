Fix round 1 for endojs/endo-but-for-bots#1392 is done: the code and changeset fixes are on the PR head and CI is green. The PR body has not been rewritten yet, though — that is handed off to a separate queued job.

**Already pushed by an earlier attempt at this job.** Both commits sit on head `93bc151b8`:
- `66b77c389` answers the stylist: `desc` is now `descriptor`, and the test helpers `ref`/`makeRef` are now `parcel`/`makeParcel`. It also drops comments that only restated the line below them.
- `93bc151b8` fixes prose the reviewers flagged:
  - The pass-style changeset now names `Parcel.open` instead of the nonexistent `Parcel.enliven`.
  - It also says plainly that widening the `PassStyle` and `Passable` unions is a type-level change.
  - The `@endo/parcel` changeset is cut down to its typedef change.
  - The `ParcelObject` comment now gives the real reason it mirrors `Parcel` (pass-style deliberately doesn't depend on `@endo/parcel`), and the shim's typedef points back to it.
  - The `encodePassable.js` comment quotes the actual error messages, and comments about not-yet-landed work are gone.

**Checked this run, nothing to change:**
- The repeated comments in `parcel-gated-global.test.js` are already gone.
- `getRankCover` was already exported before this PR, so its changeset needs no new-export note.
- `@endo/spaces-util` is marked `"private": true`, so it needs no changeset.
- The integrator asked for a sweep of other `switch` statements over pass styles. The ones in `daemon` switch over formula types, not pass styles. In `dot-membrane`, marshalling a Parcel throws before it reaches that switch. `typeGuards.js` and the rest already handle `'parcel'` or are covered.

**PR body (handed off).** The body still describes the old SturdyRef version. The panel wants it to name the `parcel*.test.js` files, say why the tests don't run on XS, and fit the 300-word limit. This host's bot token gets a 403 when editing endojs PRs, so I couldn't apply it. The earlier attempt already queued `endojs-endo-but-for-bots-pr1392-body-fix1`, pinned to `endolin-garden-ece02cb4`, carrying the full replacement text; it is waiting in `jobs/todo/`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0: 33 checks, none failed, on head `93bc151b87a6`.

**Follow-ups:**
- No summary comment has been posted for the push from `5316b03b9` to `93bc151b8`, because this host can't comment on endojs. The body-fix job, or a later run on endolin, should post one.
- The packager pointed out that the head branch still carries about 27 SturdyRef-era commits underneath the Parcel ones. Cleaning that up means rewriting the branch history (a `retcon`), which is beyond a fix round.
- The packager also flagged that commit `09a1e687f` is marked breaking (`feat!:`) while its changeset is only a `minor` bump. The changeset now explains the type-level break, which is one of the two fixes the packager offered; rewording the commit title would also need a history rewrite.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 152 tokens (6450542 cached reads)
- Output: 26022 tokens
- Cost: $3.3589724000000003
- Wall-clock: 5844s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
