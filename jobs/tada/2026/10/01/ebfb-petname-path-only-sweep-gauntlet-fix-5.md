Fix round 5 for endojs/endo-but-for-bots PR #1390 is pushed and CI is green: all 33 checks pass at head `15f46bb218`.

The first CI run had one red leg, `test (22.x, macos-15)`. The daemon's `endo.test.js` threw an unhandled `Termination requested` rejection during teardown, after every test in it had passed. The other 32 checks passed on that same run. A rerun of that leg was already queued, and it passed. A final `ci-wait-merge.sh` check returned rc 0. I treated the failure as a timing flake and did not investigate it further. My changes only touch types, a changeset, comments, and one argument that carries the same values.

**Panel round 5 (review 5372775984) must-fix items:**
1. **typist:** `ToolCallArgs.workerName` is now typed `NamePath | string`, its shape before validation. The cast through `unknown` in `lal/tool-dispatch.js` is gone. (`6b99d28298`)
2. **curator / changeset-auditor:** `@endo/lal` is bumped from `minor` to `major` in `.changeset/pet-name-path-only.md`. I also put the changeset's lal paragraph back to one sentence per line. (`ae16de9b74`)
3. **releaser:** `@endo/conversation-tree` was already listed by the round-4 commit `4a60faefbe`, which landed after this panel's review head. No change was needed.
4. **scribe:** I posted a completion summary covering `970f27de73`..`15f46bb218` (issuecomment-5921077609).

**Should-fix items also applied:**
- **wire-watcher:** `prepareWorkerFormulation` in `daemon/src/host.js` and `daemon/src/guest.js` now passes the validated `workerPath` to `identify`. (`d7a227c8eb`)
- **stylist, integrator, assessor:** in `15f46bb218`:
  - The parameter comments in `daemon/src/interfaces.js` use the new `…NamePath` names.
  - `claude-sandbox/DESIGN.md` now cites `petNamePaths`.
  - The `spaces-util/src/name-hub.js` note no longer says a bare name "silently" behaves differently, since it now throws.
- **purist:** the dead string branch for `credential` had already been removed in `d078919c6e`.

`tsc --noEmit` is clean for `lal`, `daemon` and `spaces-util`. The `lal` `evaluate-dispatch` tests pass (4/4), and eslint reports no errors on the touched files.

**Not done (all comment-only, listed in the PR summary comment):**
- **purist:** the four hand-rolled helpers that wrap a bare name into a one-segment path are not merged into one. That needs a new `@endo/daemon` export, so it belongs in a follow-up.
- **saboteur:** the `.split('/')` calls in `chat.js` are unchanged. They split pet-name paths entered in the UI, and an upstream `identify` check guards them.
- **fast-checker:** no fast-check property was added, because `@endo/lal` doesn't depend on `fast-check`.
- **corner-prober:** the 255-character pet-name cap that a scratch label can exceed is noted, not fixed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2665682 cached reads)
- Output: 12460 tokens
- Cost: $1.4002404000000004
- Wall-clock: 4911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
