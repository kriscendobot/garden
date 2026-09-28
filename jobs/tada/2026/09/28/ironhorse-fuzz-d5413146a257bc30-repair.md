## Ironhorse fuzz finding d5413146a257bc30: regression lock added, no engine fix needed

The crash reproduced at the finding's SHA but no longer happens on the standing branch. It was a disagreement in metering cost only (computrons), and the current rules treat that as advisory. I added two regression tests, pushed them to `ironhorse-fuzz-findings`, and documented the case on the standing PR. I did not run the PR's gauntlet (see Follow-ups).

**What the input does**
- I decoded the input from the journal copy, because the leader-host artifact isn't on this host. Its sha256 matches `957c39a8…0563` (6 bytes).
- The generator turns it into this program: `new RegExp("a+a{1,3}a+|(?:a*\\s+|a{1,3}a+)?\\s+|a{1,3}a+|[a-c]+a{1,3}", "m").source`

**Reproduction**
- **At `38ca1d18`:** it crashes as "regexp-surface differential divergence … `computrons: oracle=37 ironhorse=38`". The completion and the result string matched the XS reference byte for byte.
- **At the standing tip (`30e8df35ce`):** `cargo fuzz run differential_regexp_surface <input> -- -runs=1` runs clean. Under meter-v4 a computron gap against XS is advisory; completion and result must still agree. This is the same class as the earlier finding `89e303d17e33b117` (commit `c01688e627`).
- **Fix:** none. The engine output was already correct, and I did not change any meter constants.

**Regression tests (commit `527de4aede`, pushed to `ironhorse-fuzz-findings`)**
- `rust/engine/ironhorse-vm/tests/finding_d5413146a257bc30_regexp_source_meter.rs` builds without the XS submodule. It replays the exact input's XS-emitted bytecode and symbols (saved as fixtures) and checks that the program completes with the exact `.source` text.
- `rust/engine/ironhorse-fuzz/tests/finding_d5413146a257bc30_regexp_source.rs` checks that the exact input still produces this `RegExp(...).source` program and agrees with XS.
- Fixtures are under `rust/engine/ironhorse-vm/tests/fixtures/finding-d5413146a257bc30.{input.bin,bytecode.bin,symbols.bin,expected-result.txt}`.
- Both tests pass locally, and `cargo fmt --check` is clean. I pushed with a fetch/rebase/push loop; the push went through first time.
- **Limit:** neither test would fail at `38ca1d18`. The ironhorse-vm test doesn't pin the computron count, so it passes there too. The ironhorse-fuzz test depends on `differential_check_meter_v4`, which I expect didn't exist at that SHA, though I didn't check. So they lock the current correct behaviour rather than detect the original crash, the same way the `89e303d17e33b117` lock does.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing standing PR endojs/endo-but-for-bots#1298 and created nothing new. It also noted there's no board record for the `ironhorse-fuzz-findings` job on this host.
- The PR head is now `527de4aede`. It is still a draft.
- The case and its resolution are in a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864600718

**Follow-ups**
- **Gauntlet:** not run. Gauntlets are now started only by an explicit maintainer "run the gauntlet #1298". I only added test files, and I didn't wait for CI on the new head.
- **Inbox:** I couldn't read my inbox because the journal clone timed out.
- **Cleanup:** I removed the temporary `38ca1d18` side worktree I used for reproduction.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-d5413146a257bc30-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (5 unmetered)
- Input: 86 tokens (2791902 cached reads)
- Output: 19119 tokens
- Cost: $2.970503 (5 engagement(s) unpriced)
- Wall-clock: 1264s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
