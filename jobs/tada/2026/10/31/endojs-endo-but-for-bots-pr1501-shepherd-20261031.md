---
handed-off: endojs-endo-but-for-bots-pr1501-weave-after-pr1585
deliverable-complete: false
---
I couldn't get PR #1501 to green. Two red lanes remain, and both come from the `llm` base it sits on, not from the PR's own changes. The other two reds were flakes and passed when I reran them. I parked a weave job, `endojs-endo-but-for-bots-pr1501-weave-after-pr1585`, that takes over once the fix (draft PR #1585) merges.

#1501 only changes space-floot, chat, design-doc and changeset files, with no Rust. The PR's IronHorse jobs ran on the newly woven head `d4117a1e33`, on frozen base `llm-9a14ddf`. That base is the same commit as the current `llm` (`9a14ddf660`), and `llm`'s own push CI skipped those jobs.

| Failing job | Cause | Status |
|---|---|---|
| `test-ironhorse-oracle` | GitHub's `ubuntu-latest` runner is now Ubuntu 26.04. Its C math library now rounds `asinh`/`acosh` correctly, so the XS reference engine and IronHorse disagree by the last digit on `stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`). | Still red; fails the same way on rerun. #1585 targets this. |
| `ironhorse-oracle-sanitizers` | The same two cases, plus the `generated_multi_crank` test, which compares XS and IronHorse results directly. | Still red; I didn't rerun it because it can't pass until the fix lands. |
| `test (22.x, ubuntu-latest)` | Timing flake in `@endo/sandbox` (bwrap "process group survived bounded cleanup"). The same test passed in earlier runs. | Green on rerun. |
| `fuzz-ironhorse` | Random fuzzing hit a regular-expression input that hung for 1789s in `differential_regexp`, a real engine finding unrelated to this PR. | Green on rerun. |

**#1585 doesn't fully fix it yet.** It loosens the checks in `054.js`/`055.js`, but `generated_multi_crank` runs the source expression on both engines and requires the results to match. #1585's own `ironhorse-oracle-sanitizers` run already fails there (https://github.com/endojs/endo-but-for-bots/actions/runs/41171530072/job/124450402343). I sent this to #1585's job, `endo-ironhorse-oracle-stage3-math-ulp-drift`, with three possible fixes. Until it's fixed and merged, every PR that runs the IronHorse jobs stays red.

What I did:
- Reran the failed jobs of CI run 41162305359.
- Posted `ironhorse-fuzz-f9cde0bda6f97f6c-repair` to lock the hanging regex input as a regression test on the standing findings PR #1298 (with the input as base64), and to fix the hang if it's in IronHorse.
- Parked `endojs-endo-but-for-bots-pr1501-weave-after-pr1585`, blocked on #1585. It re-bases #1501 onto a fresh `llm` and confirms the two oracle lanes go green.

I made no commits and pushed nothing to #1501 or the garden, and posted no PR comments because commenting wasn't authorized for this job.

Next stage: `next: weaver`, after #1585 is completed and merged.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1501-shepherd-20261031.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3970264 cached reads)
- Output: 17206 tokens
- Cost: $1.9057808000000003
- Wall-clock: 4310s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
