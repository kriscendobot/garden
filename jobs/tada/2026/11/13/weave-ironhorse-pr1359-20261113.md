I wove PR #1359 onto the live `llm` branch: its base is now `llm` itself, not a frozen snapshot, so the ratchet delegation covers it again. But `llm` had already landed the same engine fix on its own, so **the PR no longer adds any coverage over its base**.

- **New head:** `5825b6c5667f254d890b0463f02340bfefa5181c` on `feat/ironhorse-test262-ratchet-round3`, force-pushed with lease from `f6a8388bf1`.
- **New base:** `llm`, retargeted from `llm-47f6965`. I rebased onto `llm`'s tip at the time, `48d6f3e08b`.
- **PR state:** still a draft, still open, still carries the `<!-- garden-arc: ironhorse-test262-ratchet -->` line. No second PR, no merge, no comment.

**The rebase**
- One conflict, in `rust/engine/ironhorse-vm/src/interp/link.rs`. `llm` already has commit `25d95061b4`, which makes the Math and Number constants and every `BYTES_PER_ELEMENT` non-writable, non-enumerable and non-configurable. It uses the same three flags as the PR's commit `9df05366b3`. I kept `llm`'s version, so the PR no longer changes engine code.
- The PR diff against `48d6f3e08b` is its own 10 files only: the regression test `rust/engine/ironhorse-262/tests/intrinsic_numeric_constants.rs` and the 9 evidence files under `baseline/refresh-20260928/`, unchanged.
- The regression test passes against the new base (5 of 5, release build, with the XS oracle).

**Coverage on the new head** (whole corpus, same pinned test262 `be13516f` and XS oracle `23b4d6b0`, 14 jobs; since the head has no engine change, this measures `llm`):
- covered 39,860, ironhorse-failure 1,064, unsupported 3,256, skipped 7,614, infrastructure 177, refused 5, total 51,976. At the branch point it was 36,599 covered and 2,822 failures.
- **The covered set does not contain the full union of the historical floor and the branch-point covered paths.** The union is 37,505 paths, and 882 of them are not covered.
  - Branch-point covered paths lost: 0.
  - Round-3 covered paths lost: 0. All 74 "gained" paths are covered, because `llm` now has the fix.
  - September 4 floor paths lost: 882, down from the 901 recorded in round 3. 19 have been recovered.
- **New regressions from the move: none.** All 882 were already among the 901 recorded losses.
  - Of the 882: 443 abort at a resource limit, 410 are positive tests both engines abort, 19 are "TypeError: canno…" throws where XS completes, 5 accept strict code XS rejects, 3 fail on XS's handling of declarations in script eval, and 2 are async test failures.
  - 15 of them changed reason without being recovered. Twelve annexB RegExp cases and `value-await-non-module-escaped.js` moved from error-message-differs to both-engines-abort. The two `Promise/prototype/finally/*-observable-then-calls-argument.js` cases moved from async reported-failure to a hard failure on `resolve.length` (1 instead of 0).

**What this means for the liaison and the floor-resolution successor**
- On the directive's rule ("nothing merges until the ratchet produces an improvement on the base"), #1359 is now zero over `llm`. Its remaining value is the regression test.
- The committed `refresh-20260928` evidence measures a superseded branch point. It is still in the PR as required, but it no longer describes this PR's effect on its base.
- The successor job `ironhorse-test262-ratchet-round3-floor-resolution-20260928` should start from the 882 remaining floor losses, not the 901, and from a fresh measurement on the current `llm` tip. Reproducing the sweep takes about 5 minutes with `scripts/full-run.sh --jobs 14 --oracle on`. I did not commit these new results anywhere, because the job asked for a report only.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-ironhorse-pr1359-20261113.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1652747 cached reads)
- Output: 9063 tokens
- Cost: $1.0968974
- Wall-clock: 847s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
