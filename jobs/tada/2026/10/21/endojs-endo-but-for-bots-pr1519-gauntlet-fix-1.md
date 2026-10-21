Fix round 1 for endojs/endo-but-for-bots#1519 is pushed and CI is green: all 15 checks passed, including `test (Bun)`, on head `911916382`. The panel's title and body fixes are not on the PR yet. This host's bot token gets a 403 on PR edits, so I posted a separate job to apply them.

There was no pre-pass block, so I worked from the latest panel verdict (review 5596761342, "Must-fix before merge"). Four follow-up commits went to `bun-ses-permits` via `safe-push-pr-head.sh` (advance mode, `261b077c3..17e9c3f31`).

**What changed:**
1. **`toJSON` permit removed** (`c2fc97662`, spec-keeper must-fix; purist agreed). The SES permit for Bun's `URLSearchParams.prototype.toJSON` is now `false`, so lockdown removes it silently. Only the undeletable `length` accessor stays permitted.
   - `url.test.js` now requires `toJSON` to be gone and, on Bun, requires `length` to be present. That covers the prover's finding about tests that passed by skipping.
   - With `toJSON` removed, the breaker's concern about it returning shared state no longer applies.
   - I checked that putting the `toJSON` permit back makes the test fail under Bun 1.4.3.
2. **Test runner `scripts/test-bun.mjs`** (`ab14532ae`, saboteur, breaker and corner-prober must-fixes):
   - `--package` now rejects values that start with `-`.
   - A run fails when a requested package matches no AVA run, or when nothing runs at all.
   - A malformed `package.json` now produces an error naming the file.
   - A new `--file <package>:<file>` option runs single test files.
   - I also took the stylist's renames (`avaCommandLineInterfacePath`, `translateExecutionArguments`).
   - Checked by hand: an unknown package, `--package --fail-fast`, a malformed `--file`, a missing file, and a package selected both whole and by file each exit 1.
3. **CI** (`3f3b7fb1f`, breaker must-fix; archivist rename):
   - A new required step runs `ses:test/url.test.js` and five `@endo/parser-pipeline` test files under Bun. I confirmed the parser-pipeline files fail when the `@babel/traverse` import fix is undone.
   - A new step checks that an unknown package fails the runner.
   - The advisory step is renamed to "all supported packages".
4. **Changesets** (`17e9c3f31`, packager must-fix): the three changesets are merged into one, `.changeset/bun-compatibility.md`, with one line per user-visible result.

Lint, prettier, and the ses tests under Node also passed locally.

**Someone else pushed on top:** a different Kriscendo Bot push added `911916382` ("test: cover Bun runner selections that match nothing", a new `scripts/test-bun.test.mjs`) after my push. It builds on my commits, and the green CI result is on that head.

**Still to do:** the integrator's title and body fixes. I posted job `endojs-endo-but-for-bots-pr1519-gauntlet-fix-1-pr-body`, pinned to `endolin-garden-ece02cb4`. It sets the title to "fix: run SES, module analysis, and passable errors on Bun; gate Bun in CI" and replaces the escaped-string body with real section headings, the corrected 35-package count, and a shorter text.

**Should-fix items not applied:**
- The locksmith and spec-keeper notes on the loosened assertions in `heap-classes.test.js` and `module-proxy.test.js`.
- The engine-realist note on `@endo/immutable-arraybuffer`.
- The other optional coverage suggestions.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1519-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3382785 cached reads)
- Output: 21851 tokens
- Cost: $1.833833
- Wall-clock: 2151s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
