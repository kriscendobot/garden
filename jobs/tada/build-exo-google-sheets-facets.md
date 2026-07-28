# Job report: `build-exo-google-sheets-facets`

**Deliverable: DRAFT PR https://github.com/endojs/endo-but-for-bots/pull/881** — `feat: add attenuated Google Sheets facets`, head `build-exo-google-sheets-facets`, **base `build-endo-google-sheets-client`** (correctly stacked on #874, stated in the PR body: "Stacks on #874 and must merge after it"). State: OPEN, **isDraft: true**, MERGEABLE. Head `d2b3af3d2f`. **All 23 CI checks pass**, zero non-pass.

**Affected package:** `packages/exo-google-sheets/` (new). `packages/google-sheets/` was not touched.

## What this (third) session did

Resumed after a reaper requeue that had left work committed and pushed but history untidy. Concretely:

- **Squashed the dangling `fixup! feat: add attenuated Google Sheets facets`** (package.json `author`/`repository`/`bugs` metadata) into its target commit — it was sitting unsquashed at the branch tip from the reaped session.
- **Folded the two `chore: update yarn.lock` commits into one**, per `skills/yarn-lock-separate-commit`.
- Verified the rewrite was **history-only**: `git diff 011c92adc8 d2b3af3d2f` is empty, identical tree sha `5e0c712efa`. Force-pushed with `--force-with-lease` pinned to the fetched remote sha, and notified the live peer `endojs-endo-but-for-bots-pr881-shepherd` on the bus so the churn wasn't a surprise.
- **Ran `local-verify`.** First pass had a real lint error (`Unable to resolve path to module '@endo/captp'` in the package test) caused by a **stale `node_modules`** — `@endo/captp` was correctly declared in devDependencies and correctly in `yarn.lock`, but not linked. `yarn install` fixed it; `yarn install --mode=update-lockfile` produced no lockfile change. After that: **format, lint, build, codegen, docs all green**.
- **Ran the package's own tests** (`packages/exo-google-sheets`, needs the exec-capable `TMPDIR` shim `local-verify` uses): **6/6 pass** over loopback CapTP against a stubbed client — no network, no token.
- **Confirmed regression evidence** for the security-critical property: neutering the two range/sheet confinement throws in `src/powers.js` fails 3 tests. Tree restored; working tree clean.

Final history (7 commits): `feat` + `chore: update yarn.lock` + `fix: confine ranges` + `test: CapTP` + the three review-response commits (`refactor: attenuate by construction`, `docs:`, `feat: part()`).

## Phase-2 surfaces implemented

- **Facet lattice with `M.interface` guards** — `Spreadsheet` (reader), `SpreadsheetWriter`, `SpreadsheetAppender`, `SpreadsheetWriteOnly`, `SpreadsheetControl` (`src/interfaces.js`, `src/facets.js`).
- **Permission attenuators** `readOnly()` / `appendOnly()` / `writeOnly()` — all narrow, none widen (Decision 4).
- **Scope attenuators** `sheet()` / `range()` with range confinement (Decision 3), plus `part(designation)`, the mereological narrowing verb added in response to review.
- **Token-bucket throttle**, adjustable from `control`, bounding every request including metadata reads (Decision 7).
- **`readRecords`** layered over the read core (Decision 8).
- **Polling `follow(range)`** implementing the async-iterator contract (Decision 6).
- **Revocation**: `control.revokeWrites()` (severs mutating authority, leaves outstanding readers working) and `control.revoke()` (severs read too), via two independent caretakers. One-way.
- README + `SECURITY.md` + `LICENSE` + changeset (`.changeset/calm-sheets-facets.md`), mirroring `packages/exo-zip/`.

**Deliberately deferred** (stated in the README and PR body): `SheetsService` group facet, `SpreadsheetStructure`, and push/webhook delivery (Phase 5).

## Review already addressed on this PR

@dckc (human, external) left two reviews. Both were addressed in-branch before this session, and I left them intact:
- `if (readOnly)` was a smell → the whole package was **restructured to attenuate by construction**: `makeExoSpreadsheet` is now the sole holder of a whole client; it takes the client apart and hands each power maker only the operations its authority class needs, so `makeReader` provably cannot write. There is no read-only flag to forget to check.
- "POLA-shaped attenuation usually follows a mereology builder pattern: `whole.part('A')`" → `part(designation)` added on all four authority classes, composing and orthogonal to the authority axis. Shape credited to `@agoric/pola-io` and the disciplined-python-attenuation style guide.

## Follow-ups

1. **Environment-parity defect in the fleet's `local-verify`, not in this PR.** The `test` step fails one test — `@endo/agentry › eval › conflict-rebase › outcome assertion fails when conflicted worktree is left mid-rebase` — while the identical tree is green on CI. Root cause found: the container's **global `rerere.enabled=true`** leaks into the eval's fixture repo, so git auto-resolves the intentional conflict ("Staged 'app.txt' using previous resolution") and the fixture never ends up conflicted mid-rebase. My branch does not touch `packages/agentry` at all. Fix belongs either in the fixture (`git -c rerere.enabled=false`) or in `local-verify` (neutralize host git config). Worth a job — per `skills/local-verify` § Parity is the contract, a local-fail/CI-pass discrepancy is itself a defect to close.
2. **`local-verify`'s `test` step fails fast at the first failing workspace**, so it never reached `packages/exo-google-sheets`. I ran that package's tests separately. Combined with (1), the gate silently under-covers whenever an unrelated package is red.
3. `SheetsService` and `SpreadsheetStructure` remain unbuilt (design's thin follow-on layers) — a natural next job once #874 and this land.
4. No gaps found in the Phase-1 client (`packages/google-sheets/`); the exo wraps `client.values.{get,append,update,clear}` and `client.spreadsheets.get` without needing changes. Nothing raised on #874.
5. The gauntlet's **panel stage has not run** on this PR — the only reviews to date are @dckc's two and the bot's replies. Handing off per `roles/builder` ("the builder does not run the panel; the gardener's gauntlet script does"). `endojs-endo-but-for-bots-pr881-shepherd` is live on CI.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-exo-google-sheets-facets.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 117 tokens (4558349 cached reads)
- Output: 25334 tokens
- Cost: $3.7805395 (1 engagement(s) unpriced)
- Wall-clock: 2064s

<!-- garden-usage-end -->
