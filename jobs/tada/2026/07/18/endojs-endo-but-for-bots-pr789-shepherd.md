CI is green on head `747ef04510` — the previously-red `lint` and all four `test` matrix jobs now pass. The shepherd goal is met.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #789 — "feat(daemon): resolve content data planes"

**Diagnosis.** Two distinct red checks on the pre-fix head:
1. `lint` (prettier) — formatting violations in `packages/daemon/src/content-data-plane.js` and `types.d.ts`.
2. `test` matrix (all 4 jobs, deterministic) — `@endo/daemon` test `endo › mailboxes persist messages across restart` failed with `Mail fraud: unrecognized parcel`. This pre-existing test was regressed by the PR.

**Root cause (the real bug).** The PR gave every host and guest an `@planes` directory and wired `context.thisDiesIfThatDies(planesDirectoryId)` (mirroring `@nets`), but never registered that directory as a retained dependency. `extractLabeledDeps` in `manager.js` — the formula graph's static-dependency source — still listed only `networks` for the `host`/`guest` cases. So the freshly-formulated planes directory had no incoming retention edge, was swept as unreachable, and its death cascaded back through `thisDiesIfThatDies` to **reincarnate the agent mid-delivery**, discarding the in-memory mailbox outbox and surfacing as "unrecognized parcel" on the next package send.

I reproduced this locally (built `better-sqlite3`, worked around a socket-path-length env artifact), instrumented the mailbox to observe the double-incarnation, and bisected it to the missing `planes` dep.

**Changes pushed** (`5ae36da7cf..747ef04510` on `build/endo-content-locators-magnet-urn-phase3-planes-resolution`):
- `fix(daemon): retain each agent's @planes directory in the formula graph` (`0c41db38b2`) — added `['planes', formula.planes]` alongside `networks` in `extractLabeledDeps` for both `host` and `guest`, plus the matching reference in `makeFormulaRecord` (host introspection parity). Behavioral fix → normal `fix:` commit.
- `fixup! feat(daemon): resolve content data planes` (`747ef04510`) — `prettier --write` on the two flagged files. Format-only → `--fixup` targeting the introducing commit for conductor autosquash.

**Verification.** Full `@endo/daemon` `endo.test.js` suite run locally: **222 passed, 0 failed** (including the regressed test and the PR's two new `@planes` tests). eslint on changed files: 0 errors. CI now: **23/23 checks pass** — green run https://github.com/endojs/endo-but-for-bots/actions/runs/29624121338.

**Follow-ups.** None required. PR remains draft (unchanged; un-drafting is the gauntlet/maintainer's call, not the shepherd's). No summary comment posted — the job body carried no external-comment authorization. The `fixup!` commit will autosquash into the feature commit at merge.
