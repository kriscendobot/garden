## Fix round 5 for kriscendobot/minion.town PR #193: the panel-5 fixes are pushed and CI is green

I applied the panel-5 review fixes, which included all three must-fix seats (archivist, pruner, procurer) and the assessor's should-fix items, as one follow-up commit. I pushed it to `build/ocapn-guest-canary` (`0d3b357` → `f96656b`) with `safe-push-pr-head.sh`. CI on `f96656b` ended green: `ci-wait-merge.sh` returned rc 0 with no failed runs (the PR runs one check). The local suite also passes, 59 of 59 with `node --test deploy/probe/ocapn-canary.test.mjs`.

**Archivist**
- The `NAME_PATTERN` comment now cites `validSpecialName` in `src/endo/gateway/publish.ts`, minus its `@` sigil. It also says the pattern is stricter than both `validPetName` and the daemon's rule.
- The Endo `worker.js` endowments citation is now marked as an assumption: it can't be checked from this repo, and a daemon without those endowments fails the capability leg.
- The comment on mapping exit reasons to the auth-unavailable signal now says "the planned orchestrated caller" and cites `designs/root-canary-principal.md`.
- `DEPLOYMENT.md` now says the operator, not the canary, gets each locator from `GET /account/guest-locator` and writes `guests.json` with `chmod 600`.
- The Install block now includes `loginctl enable-linger` and the optional `ENDO_BIN` line.

**Pruner**
- Removed or trimmed the comments that only restated the code: `hostPetName`, `malformedField` (cut to "`undefined` when the guest is well formed"), the second line of the `probeSource` comment, the `auditRecord` comment, and the header's `--file` aside.
- Removed the two `DEPLOYMENT.md` sentences that restated `TimeoutStartSec` and the six-hour cadence.
- Re-wrapped the two overlong header lines.

**Procurer**
- I did not switch to `@endo/pass-style`'s `isRecord`. Its `passStyleOf` throws on the unfrozen output of `JSON.parse`, and the package can't load without SES, which this plain Node script doesn't install.
- The comment now records that reason and cites the package's `src/typeGuards.js`.
- The procurer raised this in round 4 as well, so panel-6 may raise it again.

**Assessor**
- A timed-out CLI call now reports exit code 124 whether the child exits after SIGTERM or has to be killed. Before, the SIGTERM path reported 1.
- The existing kill-grace test now expects 124, and a new test covers a child that exits promptly on SIGTERM.
- Removed `Persistent=true` from the timer, since it does nothing on an `OnBootSec`/`OnUnitActiveSec` timer.

**Follow-ups**
- `npx prettier --check` reports style issues in 6 files under `deploy/probe/` and in `DEPLOYMENT.md`. Its output named only `prod-objectives.test.mjs`, which this round didn't touch, and `DEPLOYMENT.md`, which it did. I didn't confirm whether the `DEPLOYMENT.md` warning predates my edits, or which files the other four are. CI doesn't run that check.
- I did not act on two comment-only suggestions:
  - Running the exchange over one `makeEndoClient` connection instead of the roughly 30 `endo eval` subprocesses.
  - Squashing the panel fix-up commits.

Per the job spec I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1316613 cached reads)
- Output: 9234 tokens
- Cost: $0.9592586000000002
- Wall-clock: 942s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
