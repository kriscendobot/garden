The clean stage for endojs/endo-but-for-bots#1380 is done: I added one test and CI is green on the new head (`dcbd82cc16`, 35 checks, 0 failed, `ci-wait-merge.sh` returned 0).

**Coverage pass**
- **slot-machine-transcript:** all 15 tests pass under `cargo llvm-cov`, with 85% line coverage. What the tests don't reach is mostly error handling for storage failures and `Display` impls.
- **xsnap:** 144 of 145 unit tests pass under coverage. The one that crashes (SIGSEGV) is `archive_text_endowments_provide_codecs`, and only because the local bundle build wrote a stub `archive_text_endowments.js`. CI only runs `cargo check` on xsnap, not its unit tests. To build it locally I had to initialise the `c/moddable` submodule and generate the JS bundles (`build:xs-bundles` and `bundle:xs`).
- **Gap closed:** no test re-seated a handle opened relative to a directory *handle*, as opposed to a directory token. That is the code path that joins the child path onto the parent directory's path. The test for re-seating handles after a suspend and resume (`host_transcript_lifts_the_suspend_refusal_and_resume_reseats_handles`) now opens a reader under the `openDir` handle and reads 2 bytes before suspending. After resuming it checks the reader is in the re-seat report and continues from the saved offset. I broke the path join on purpose and the test failed, so it does guard that code.
- **Dead code:** the change leaves none behind. The warnings `cargo check` does print (in `assemble.rs`, a bench import, and `lib.rs:5116`) all come from older commits.

**Pushed:** one commit, `test(xsnap): re-seat a reader opened below a directory handle` (`93e73e1caa` → `dcbd82cc16`), pushed with `safe-push-pr-head.sh`.

**Follow-ups:**
- xsnap unit tests aren't run anywhere in CI, and `rustfmt` isn't checked on xsnap. The crate already has formatting drift unrelated to this PR.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (265062 cached reads)
- Output: 1200 tokens
- Cost: $1.0004043999999999
- Wall-clock: 18s

<!-- garden-usage-end -->
