Finding bd4559ecbc0432c1 was a spelling difference in the XS oracle, not an engine bug. The port was already right and the harness already has the fix, so I added only a regression test and made no code change.

**Reproduction**
- I rebuilt the input from the journal's `input_base64`, and its sha256 matches `f0f87045…8387f49`.
- At `38ca1d1893` the fuzz target fires: the program `(226492416 * 226492416)` gives `oracle="51298814505517056"` and `ironhorse="51298814505517060"`.
- Both strings parse to the same double. XS prints the full integer, while the port prints the shortest spelling the ECMA-262 spec requires. This is the known large-integer dtoa class.
- At the branch head (`91f38a663d`) the target no longer fires on this input. The fix that stopped it is the exact-double Number comparison already on the branch (fdb9fef6e0 and its follow-ups).

**What changed**
- I pushed commit `7fdaff6d0c` to `kriscendobot/endo-but-for-bots` branch `ironhorse-fuzz-findings`, using fetch/rebase/push. It adds:
  - `rust/engine/ironhorse-vm/tests/finding_bd4559ecbc0432c1_large_integer_dtoa.rs`
  - `rust/engine/ironhorse-vm/tests/fixtures/finding-bd4559ecbc0432c1.{input.bin,program.txt}`
- The test checks the input's sha256, runs the pinned program through the pure-Rust compiler and VM, and asserts it completes with result `51298814505517060`. It also asserts that spelling and XS's spelling are the same double.
- I generated the program fixture from the input with the maintained generator. `vm_finding_fixtures` regenerates it and requires an exact byte match.
- Both tests pass locally.

**Standing PR**
- `ensure-pr.sh --find-only` found the existing PR, endojs/endo-but-for-bots#1298 (draft), and created nothing new.
- I posted a comment on #1298 covering the reproducer, symptom, cause, fix, and the new test: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5866923728

**Follow-ups**
- I did not run a gauntlet. Under the manual-gauntlet regime the maintainer starts it with "run the gauntlet #1298", as with the earlier findings on this PR.
- When I left, CI on #1298 was still running: 1 pass, 1 pending, 2 skipped. I did not wait for it to finish.
- The project checkout has local changes to `packages/floot/package.json` and some untracked compartment-mapper fixture directories. I left them alone and committed none of them.
- My inbox drain failed because the journal clone was offline.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-bd4559ecbc0432c1-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 3 host(s) (2 unmetered)
- Input: 48 tokens (1529938 cached reads)
- Output: 9551 tokens
- Cost: $1.0451516 (2 engagement(s) unpriced)
- Wall-clock: 638s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
