# Gauntlet CLEAN stage: endojs/endo-but-for-bots PR #1390

**Result: the clean stage is done and CI is green (33 of 33 checks, 0 failed).** I pushed nothing: the coverage pass found no gaps and no dead code to remove.

**PR:** "feat(daemon)!: accept only pet-name paths, reject bare pet-name strings". It is a draft, head `065f1344ea` on `endojs/build/pet-name-path-only`, base `llm-8e53cc0`, 178 files.

## Coverage and dead-code pass
I did this in an isolated checkout, `scratch/project-wt-ebfb-pe-04f827a2d7c9-0186d129`.

- **Coverage:** every new behavior has tests.
  - **`namePathFrom` / `petNamePathFrom` (`pet-name.js`):** new tests cover the bare-string rejection with its retry hint, including a slash-delimited string, the empty string and the one-segment path.
  - **`toPetNamePath` in `agent-tools/src/code-mode/daemon.js`:** a new test covers splitting a string name, passing a result name through, and an `undefined` result name.
  - **Updated call sites:** tests across daemon, chat, claude-sandbox and cli already exercise them.
- **Dead code:**
  - The removed names `NameOrPath`, `NameOrPathShape` and `NamesOrPathsShape` have no references left in the repo.
  - `Inspector.lookup` in `manager.js` no longer has a string branch; it now goes through `namePathFrom`.
  - Leftover `nameOrPath` names only appear as local variable names in `guest.js`, `mail.js` and `directory.js`, and in test mocks. They all call `namePathFrom`, so they are not dead code.
- **Two small leftovers, left as they are:**
  - In `host.js`, `stageTreeInternal`'s JSDoc still says `string | string[]`.
  - `makeFromTree`'s worker-label ternary (`Array.isArray(treeName) ? … : treeName`, around `host.js:1838`) still has a string branch. A string `treeName` is rejected later by `namePathFrom`, so this is harmless. A later fix round could tidy both.
- **`mount.js` string handling:** this is outside the PR. It is the filesystem path surface, not pet names, and the PR does not touch it.

## CI
`ci-wait-merge.sh --no-merge` exited with rc 0 after about 12 minutes, once the four `test (22.x/24.x, ubuntu/macos)` cells finished. No follow-ups needed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (552899 cached reads)
- Output: 3744 tokens
- Cost: $0.6402758
- Wall-clock: 861s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
