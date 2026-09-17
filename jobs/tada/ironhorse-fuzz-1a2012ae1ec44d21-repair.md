All work complete. Let me summarize.

## Completion report

**Job:** Fix Ironhorse fuzz finding `1a2012ae1ec44d21` (target `differential_regexp_surface`) and amend the standing fuzz-findings PR.

**What I found**
- Recovered the 6-byte minimized input (base64 from the journal marker), verified sha256 `534cdfa5…b16c49`.
- Reproduced the crash at the finding SHA `38ca1d1`: a **computron divergence** `oracle=36 ironhorse=37` on the generated program `new RegExp("(?:0{1,3}\n{2})\S{1,3}(c|\1{1,3}\n{2})|(?:\1{1,3}\n{2})\S{1,3}(c|\2{1,3}.{1,3}){2}", "i").source`. The `.source` value needs no escaping, so XS reuses the constructor's source key while the pre-fix port charged a fresh string chunk — the result agreed exactly; only the meter diverged.
- **Root cause was already fixed**: identical class to sibling finding `1898f584e9bf841a`, resolved by `dbdddec76 fix(ironhorse-vm): reuse unescaped regexp source` (already in `llm`). No new production fix was needed or warranted; I verified the fix's code path is exactly the one this input exercises.
- On **current `llm`** the input no longer crashes the target: the surface harness now treats XS-computron equality as advisory (*"XS computron equality cannot gate an IronHorse cost-table recalibration"*), and the cost table was recalibrated (port now meters 64 vs XS 36, tolerated). Confirmed with a clean `cargo fuzz run … -runs=1` on current llm.

**What changed**
- Added a **submodule-free `ironhorse-vm` regression** `finding_1a2012ae1ec44d21_regexp_source_meter.rs` + 4 fixtures (input, oracle-emitted bytecode, symbols, expected result), replaying the exact bytes and locking the load-bearing invariant: completes without panic and yields the byte-identical `.source` value. The raw computron count is deliberately *not* pinned (advisory during recalibration — pinning it would be brittle, not load-bearing). Test passes on current llm; rustfmt clean.
- Rebased the **stale** standing branch `ironhorse-fuzz-findings` (its prior commits were all already merged into `llm`, which had advanced 1282 commits) onto current `origin/llm` + my single commit, force-pushed with lease. Diff vs base is exactly my 5 files.
- Created/confirmed frozen base `llm-387ea66` and opened the standing draft PR **endojs/endo-but-for-bots#1298** (head `kriscendobot:ironhorse-fuzz-findings`, base `llm-387ea66`), documenting finding `1a2012ae1ec44d21` in the body.

**Follow-ups**
- PR #1298 is **draft**, per the manual-gauntlet-trigger regime — awaiting an explicit maintainer **run the gauntlet #1298** to review/un-draft. I did not run the gauntlet myself (maintainer-triggered).
- No code defect remains; this finding is a regression-lock of an already-resolved class.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-1a2012ae1ec44d21-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (5 unmetered)
- Input: 154 tokens (8451580 cached reads)
- Output: 66194 tokens
- Cost: $7.503606000000001 (5 engagement(s) unpriced)
- Wall-clock: 1890s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
