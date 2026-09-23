All five regexp finding regression tests pass (mine + four siblings) — my change is verified and doesn't disturb the shared harness/fixtures. The work is complete.

## Completion report

**Job:** Repair Ironhorse fuzz finding `557805e944888b5a` (target `differential_regexp_surface`) and amend the standing PR.

**What the finding actually is.** The 11-byte minimized input `14 14 14 a0 24 a0 c6 a0 24 a0 c6` (sha256 `6ec8c34e…8af6`, verified) folds through `gen_stage3b_regexp_program` into:
```js
new RegExp("(?:\\d* {1,3}\\d{1,3}|\\d* {1,3}\\d{1,3}|a*[a-c]*[a-c]{1,3})? +?\\d*", "").toString()
```
I built the XS oracle (fetched the pinned `c/moddable` `23b4d6b0` submodule via a blobless partial clone, compiled it on stable) and ran the exact function the fuzz target uses, `differential_check_meter_v4`. Result: the port and the XS pin **agree bit-for-bit** on the 65-byte completion value `/(?:\d* {1,3}\d{1,3}|\d* {1,3}\d{1,3}|a*[a-c]*[a-c]{1,3})? +?\d*/`; only the computron count diverges (XS 49, port 71 — `RegExp.prototype.toString` builds `/`+source+`/`+flags, metered on the port's own cost table). This is the same **unescaped-regexp-source metering class** as siblings `1898f584e9bf841a`, `1a2012ae1ec44d21`, `c6c71d428a37088c`.

**Causal fix.** None needed. At the finding SHA `38ca1d189` the surface arm gated on XS-computron equality (hence the crash); the harness now treats XS-computron equality as **advisory** ("cannot gate an IronHorse cost-table recalibration"), so `differential_check_meter_v4` returns `Ok` for this input on current `llm` — verified directly. The port was always correct on the value.

**What changed.** Added a submodule-free `ironhorse-vm` regression, mirroring the sibling `regexp_source_meter` locks:
- `rust/engine/ironhorse-vm/tests/finding_557805e944888b5a_regexp_tostring_meter.rs`
- fixtures `finding-557805e944888b5a.{input,bytecode,symbols}.bin` + `.expected-result.txt` (XS-emitted bytecode/symbols frozen). It replays the exact input's program and asserts completion-without-panic + the byte-identical `toString()` value; the raw computron is deliberately not pinned (advisory).

**Verification.** The new test passes; all four sibling regexp finding tests pass alongside it (5/5). (A full-suite `cargo test` OOM-killed the linker on an *unrelated* test binary `endowment_order` — a container memory ceiling from linking ~100 test binaries at once, not a defect in this change; I verified by running the regexp finding tests individually.)

**Standing PR.** Committed as `test(ironhorse-vm): regression-lock unescaped regexp toString meter (fuzz 557805e944888b5a)`, rebased onto the fast-moving standing branch and pushed with fetch/rebase/`safe-push-pr-head` CAS discipline (the branch advanced under me three times; my commit `15d1ee88e` is confirmed an ancestor of the current live head, so the finding is durably on the branch). `ensure-pr.sh` adopted the existing standing PR **#1298** (draft, `kriscendobot:ironhorse-fuzz-findings` → `llm`) — created no duplicate. The finding is documented in full in the commit message; a PR comment was attempted but the bot PAT lacks comment permission on `endojs`, so the commit message (visible in the PR's commit list) is the record.

**Gauntlet.** I did **not** self-launch the full adversarial panel gauntlet: IronHorse is paused at zero priority, the manual-gauntlet-trigger regime stages no gauntlet automatically, and the standing PR is being amended by peers every minute (a panel would race). Local verification (above) is the substantive gate I ran; a formal panel remains a maintainer-triggered `run the gauntlet #1298`.

**Follow-ups.** Triage record stamping for this finding (`resolved_by_cluster`/resolved) is producer-side and lives on the leader host's journal state, which isn't reachable from this follower — left to the fuzz service producer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-557805e944888b5a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 3 host(s) (6 unmetered)
- Input: 166 tokens (9156464 cached reads)
- Output: 58094 tokens
- Cost: $7.6418919999999995 (6 engagement(s) unpriced)
- Wall-clock: 2772s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
