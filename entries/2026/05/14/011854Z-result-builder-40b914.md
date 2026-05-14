---
ts: 2026-05-14T01:18:54Z
kind: result
role: builder
project: endo
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 242
    role: target
refs:
  - entries/2026/05/14/010704Z-dispatch-liaison-a05cbb.md
  - entries/2026/05/14/010511Z-result-builder-48a8a1.md
---

# Result: builder opened endojs/endo-but-for-bots#242 (draft) to consume syrups-framed ocapn-test-suite

Draft PR: https://github.com/endojs/endo-but-for-bots/pull/242
Topic branch: `feat/syrups-ocapn-framing` on `endojs/endo-but-for-bots`.
Base: `feat/syrups-package` (PR #109; not `llm`; see *Base choice* below).
Head SHA: pushed to `feat/syrups-ocapn-framing`; one commit on top of `feat/syrups-package` tip `4ffb3d84e50c35f330d90e7e600040944e789a3c`.

## Consumption mechanism

A CI workflow checkout, not a submodule and not a JS dependency. `.github/workflows/ci.yml` § `test-ocapn-python` checks out the Python `ocapn-test-suite` repo at a pinned SHA and runs `python ./test_runner.py` against the JS server started from `packages/ocapn/test/python-test-suite/index.js`. The previous pin was `ocapn/ocapn-test-suite` at `74db78f08a40efba1e2b975d809374ff0e7acf60`; the new pin is `endojs/ocapn-test-suite` at `89e80d70cf0689fce0b92936f22a84b02e9e1aee` (branch `feat/syrups-framing`, the head of endojs/ocapn-test-suite#1).

No submodule (`.gitmodules` is moddable-only, unrelated). No `package.json` dependency on the test suite. No vendored copy.

## Diff summary

Three files changed, 19 insertions, 5 deletions, in one commit.

- `.github/workflows/ci.yml` (6 +, 3 -): repoint the test-suite checkout `repository` from `ocapn/ocapn-test-suite` to `endojs/ocapn-test-suite`, repoint `ref` to the new SHA, and update the comment to reference the framing variant and endojs/ocapn-test-suite#1.
- `packages/ocapn/test/python-test-suite/index.js` (7 +, 1 -): pass `framing: 'syrups'` to `makeTcpNetLayer`, with an inline comment naming the pinned test-suite SHA so the two ends move in lockstep.
- `packages/ocapn/test/python-test-suite/README.md` (6 +, 1 -): one paragraph naming the new upstream and noting the JS peer runs in `framing: 'syrups'` mode.

No changes to `@endo/syrups`, the `tcp-test-only.js` netlayer, or any test-vector content.

## Base choice

The dispatch named the upstream builder's report (`010511Z-result-builder-48a8a1.md`) but did not name a base branch for this PR. `endojs/endo-but-for-bots`'s `llm` branch does **not** yet contain `@endo/syrups` or the `framing` option on `makeTcpNetLayer`; both come from PR #109 (`feat/syrups-package`), which is still open against `master` on the upstream `endojs/endo` repository and has not yet been merged into `llm`.

Two paths:

- (A) Base on `llm` and cherry-pick the `@endo/syrups` package + the netlayer `framing` integration. Couples this PR's review to the contents of #109; "out of scope" per the dispatch.
- (B) Base on `feat/syrups-package` directly. Stacks this PR on #109's head; the incremental diff shows only the three files this builder owns. The dispatch is silent on stacking, but the constraint "no edits to `@endo/syrups`" is only satisfiable if the package is already in the base.

Chose (B). The PR base is `feat/syrups-package`, and the body cross-refs #109 in a *Stacked on #109* section. When #109 merges into `llm`, this PR's base will need to follow; the rebase is mechanical.

## Local validation outcome

Two suites run with `corepack yarn install --immutable` followed by `corepack yarn test` from the relevant package directory.

- `packages/syrups` (the `@endo/syrups` package itself): **35 / 35 tests pass**. Includes round-trip across adversarial chunk boundaries, concurrent writes (chunked and unchunked), `writer.throw`/`writer.return` forwarding, prefix-too-long rejection, trailing-comma rejection, and prefix-divided-over-chunk-boundary handling.
- `packages/ocapn` (the OCapN client, includes `test/netlayer-tcp-syrups.test.js`): **285 / 285 tests pass** across all four ses-ava configurations (`lockdown`, `unsafe`, `endo`, `noop-harden`). Notably the three netlayer-tcp-syrups assertions all pass:
  - `syrups framing wraps outgoing bytes with <length>:<payload> and contains no comma` (sniffer-server confirms the wire bytes are `<ascii-digits>:<payload>` with no trailing `,` at the netstring-terminator position).
  - `syrups framing round-trip through the test-only TCP netlayer` (two `@endo/ocapn` clients exchange an echo string over the framed transport).
  - `rejects unknown framing option` (constructor validation).
- ESLint on the changed file (`packages/ocapn/test/python-test-suite/index.js`): clean.
- `node --check` on the changed file: clean.

Pass / fail count across both suites: **320 / 320**.

## Round-trip verdict

`@endo/syrups` round-trips messages cleanly with the new framing. The grammar enforced by both ends (`<ascii-decimal-length>:<payload>`, no trailing separator) is the same on the JS and Python sides:

- JS encode (`makeSyrupsWriter`): prepends `${len}:` ASCII bytes, no comma.
- Python encode (`CapTPSocket.send_message` in the pinned test-suite SHA): `prefix = f"{len(message)}:".encode("ascii")`, no comma.
- JS decode (`makeSyrupsReader`): reads decimal digits up to `:` then exactly `length` bytes, with chunk-boundary tolerance.
- Python decode (`CapTPSocket.receive_message`): byte-by-byte digit accumulation up to `:` then exactly `length` bytes.

The `netlayer-tcp-syrups` round-trip test exercises this end-to-end on the JS side; CI on PR #242 (once it merges down to the test-ocapn-python job) is what measures interop against the live Python suite.

## Identity verification

Commit author and committer are both `kriscendobot <279080640+kriscendobot@users.noreply.github.com>`. `git interpret-trailers --parse` on the commit message returns empty (no `Co-authored-by` or `Generated with` trailers).

## Self-improvement

One observation, surfaces at the boundary between the dispatch contract and the PR-stacking pattern. The dispatch named the target SHA on `endojs/ocapn-test-suite` (the test-suite side of the work) but did not name a base branch on `endojs/endo-but-for-bots` (the consumer side). The `llm` branch was the implicit default per the project worktree's HEAD, but `llm` did not yet carry the `@endo/syrups` prerequisite. The builder had to choose between (a) cherry-picking the prerequisite into the topic branch (against "no edits to `@endo/syrups`") and (b) stacking the PR on the prerequisite branch (which the dispatch is silent on). This is a one-off; if a second dispatch hits the same shape, the cheap durable fix is for the dispatch prompt to name the prerequisite branch explicitly (or to defer the dispatch until the prerequisite has merged). Not worth a skill-edit on a single occurrence; capturing here so a third occurrence can promote it to the `pr-creation-flow` *Pitfalls* section.

Self-improvement: nothing role-level this time; the stacking observation above is captured for the liaison's reading.
