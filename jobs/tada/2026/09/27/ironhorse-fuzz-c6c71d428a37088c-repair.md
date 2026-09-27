Finding `c6c71d428a37088c` (`differential_regexp_surface`) was already fully handled before this rerun. I made no new changes and nothing needed redoing.

**What's already on the standing branch:**
- **Regression test:** commit `7d884cb5ac`, "test(ironhorse-vm): regression-lock unescaped regexp source getter (fuzz c6c71d428a37088c)", is on `kriscendobot:ironhorse-fuzz-findings`. The branch tip is `76502b5911`. It adds `rust/engine/ironhorse-vm/tests/finding_c6c71d428a37088c_regexp_source_meter.rs`, which replays the exact input's frozen bytecode and symbols. It checks that the program finishes without panicking and returns the same 1043-byte `.source` value byte for byte. It deliberately does not check the computron count, because the harness treats computron gaps against XS as advisory.
- **Fix:** commit `dbdddec76` is already in `llm`. It makes the `.source` getter reuse the constructor's source key when nothing needs escaping. The engine always returned the right value; only the computron count differed from XS.
- **Write-up:** the body of standing PR endojs/endo-but-for-bots#1298 has a section, "Finding `c6c71d428a37088c` — unescaped `RegExp.source` getter meter", covering what happened, the root cause and fix, the current state, and the regression test. Sibling findings `6ca7a76e0bfe3435`, `b95320dfb5dd9d3d` and `1cb63ec6f8e6fc22` refer to it as the same class.

**What I checked this run:**
- `cargo test -p ironhorse-vm --test finding_c6c71d428a37088c_regexp_source_meter` passes on a fresh checkout of the branch tip (1 passed).
- PR #1298 is open. On its checks, 20 passed and 7 were skipped. The other 6 were still running when I looked: `test` on Node 22.x and 24.x (ubuntu and macOS), `test-ironhorse` and `test-ironhorse-macos`. I didn't wait for them to finish.
- The PR's gauntlet jobs are already on the board (`endojs-endo-but-for-bots-pr1298-gauntlet`, plus its clean, viability, panel-1 and fix-1 stages), so I didn't post another.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-c6c71d428a37088c-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 3 host(s) (3 unmetered)
- Input: 152 tokens (6434856 cached reads)
- Output: 36854 tokens
- Cost: $5.5047927 (3 engagement(s) unpriced)
- Wall-clock: 1268s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×2

<!-- garden-usage-end -->
