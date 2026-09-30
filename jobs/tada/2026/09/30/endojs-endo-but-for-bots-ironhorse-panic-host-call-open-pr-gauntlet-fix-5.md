# Fix round 5 for endojs/endo-but-for-bots#1379: fixes were already pushed, CI is green

A previous claimant of this job had already applied every round-5 must-fix item. I found nothing left to push, so this attempt only drove CI to green.

**What's on the PR head (`4cffd6fea4`):**
- **assessor:** a `Transactional` call refused on the reply size limit no longer records an escaped handle, because its write never ran.
- **saboteur, engine-realist, wire-watcher:** a `Barrier` call whose reply goes over the per-crank host-call limit keeps its call number reserved, and the crank refuses to commit. The supervisor has to abort the crank, so recovery stops at the escaped barrier. Before, a later call could reuse the same number and fail the commit, or the barrier could slip past recovery unnoticed.
- **locksmith:** a transactional write now runs under an SQLite authorizer that blocks the transcript's own tables, transaction control, attach and pragmas.
- **breaker:** the handle-state doc now says that after compaction the `host_handle` table, not the event log, is authoritative.
- **stylist:** abbreviated names are spelled out, including `acknowledgment_flushes`, `ContentAddressedStoreError`, `blob_store`, `watermark` and `socket`.
- **prover:** a new test checks that the blob temp-file prefix stays distinct from xsnap's.
- **integrator:** the PR body now says the Q3, Q6 and Q7 answers rest on #1370, a bot-authored design amendment no maintainer has reviewed yet.
- A round-5 summary comment was posted at 08:28:43Z.

**CI:** the first wait came back red on one leg, `test (22.x, macos-15)`. The failing test was `daemon-teardown › an orphaned daemon shuts itself down…` in `@endo/daemon`. This PR only touches the Rust `slot-machine-transcript` crate and CI wiring, so I treated it as a flake and re-ran the failed job. The re-run passed, and `ci-wait-merge.sh --no-merge` returned rc 0 with all 35 checks green (0 failed).

**Follow-ups (not must-fix):**
- The panel's concision check flagged the PR body at about 1,880 words, well over its 300-word target.
- The phase/evidence check will keep flagging the body as long as #1370 is unmerged. That dependency is disclosed in the body, but the maintainer has to review #1370 to clear it.
- The `daemon-teardown` test on macOS may be flaky across PRs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 132 tokens (5711646 cached reads)
- Output: 30963 tokens
- Cost: $3.1927892
- Wall-clock: 6522s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
