The clean stage passed for endojs/endo-but-for-bots PR #1391: the coverage review found nothing to add, I pushed nothing, and CI is green at the current head.

- **PR state:** It is a draft, open, with head `14381fc8f5` on branch `build/sturdyref-ses-accommodation`. Its base is `build/sturdyref-shim-first-wins-ef4662f`. I reviewed it in an isolated checkout made with `ensure-project-worktree.sh`.
- **Coverage pass (`packages/ses`, plus the daemon test launcher):** I read the diff against the base rather than running a coverage tool. The PR's own tests exercise every new branch in `sampleSturdyRef`, `isFirstWinsDescriptor`/`firstWinsPropertyNames` and the `presampled` argument to `sampleGlobals`/`makeIntrinsicsCollector`. Those tests cover:
  - a missing `SturdyRef`
  - an accessor global, an arrow function, a non-function value and an impostor
  - shims installed as writable, enumerable or configurable
  - a reentrant shim and a correctly shimmed one
  - a run on XS
- **Not covered, by design:** the `binding === undefined` check after `hasOwn` is a defensive guard, and the value comparison in `isFirstWinsDescriptor` is commented as only guarding against a future change.
- **Dead code:** the change doesn't leave any code unused.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 after about 26 minutes, with 0 of 33 checks failed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (283637 cached reads)
- Output: 2249 tokens
- Cost: $0.4849473999999999
- Wall-clock: 1683s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
