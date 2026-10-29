I rewrote the design on endojs/endo-but-for-bots#1431 and staged a fresh design-panel pass on its new head. The PR is still a draft.

**Why it needed more than a refresh:** the remedy the PR documented was dropped upstream. On 2026-10-29, #1349 and its upstream mirror endojs/endo#3377 were closed unmerged as superseded by endojs/endo#3376. That PR, merged the same day as `679d9afaa4` and approved by gibson042, makes `cauterizeProperty` accept the frozen `null` `caller`/`arguments` properties, with a warning. That is the alternative the PR's design explicitly rejected. I did not argue against the maintainer's choice. I rewrote the design to describe what actually landed.

**What changed on #1431:**
- **Rebuilt on current `llm`:** the old base `llm-fda1ff5` was stale, and `llm` had since edited the same file. The head `design/hardened-text-codecs-encapsulation` is now one commit, `c3ab267ef9`, force-pushed with a lease. I moved the PR base to the existing frozen snapshot `llm-9a14ddf`, which matches the current `llm` tip. The diff is `designs/hardened-text-codecs-shim.md`, +119 −3, replacing the old 600-line encapsulation diff.
- **New section, "Revision: restricted `caller` and `arguments` on older Chromium (2026-10-29)":**
  - The failure (endojs/endo#3369) and the measured boundary: Chrome 120–137 affected, 138–140 clean.
  - The adopted fix. Host codec constructors stay the permitted intrinsics and identity holds on every engine. The fix also covers `URLSearchParams` and `%InitialURL%`, so `hardened-url-shim` needs no revision for this failure.
  - Security considerations: a V8 sloppy-mode function's own `arguments` has the same frozen-`null` descriptor and is live during a call. I confirmed that on Node 22.23. So the fix assumes no sloppy-mode function is ever a permitted intrinsic.
  - Two new test-plan items: the tests that landed with #3376, and a manual Chromium 137 browser check.
  - Considered and rejected: encapsulation (#1349 / #3377) and per-constructor permits (endojs/endo#3371).
  - One open question: should a test enforce that no permitted intrinsic is sloppy-mode?
- **Status updates:** a Status note says the fix is merged upstream but not yet on `llm`. Test item 6 now says #1349 closed unmerged, so no XS run of item 1 has landed. The Dependencies table gains a row for endojs/endo#3376.
- **PR title and body** rewritten to match. I kept the original `garden-job` marker. Prettier passes.

**Panel staged:** I recorded gauntlet `endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b` for https://github.com/endojs/endo-but-for-bots/pull/1431 with `post-gauntlet.sh`. The automatic handoff would not have run this pass: the old `endojs-endo-but-for-bots-pr1431-gauntlet` record is already terminal (review budget reached at `15dd235c`), and the handoff defers when a reviewed PR's head moves. The gauntlet starts from viability and clean before the panel, and it is keyed to this exact head.

**Follow-ups:**
- The maintainer should check that this reframing is wanted, or close #1431 if upstream #3376 is enough documentation.
- The open question about enforcing no sloppy-mode intrinsics is for the maintainer to decide.
- #3376 reaches `llm` with the next upstream merge.
- endojs/endo#3369 is still open upstream.
- No build follows from this design; the code is already merged upstream.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8fc7ac258b3d7e5a00d6060fb6daea9b54ba2f39`; this job presented `c3ab267ef93be425004246367bc4edc409ac8f9e`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-design-panel-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3057854 cached reads)
- Output: 19464 tokens
- Cost: $1.8413868
- Wall-clock: 324s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
