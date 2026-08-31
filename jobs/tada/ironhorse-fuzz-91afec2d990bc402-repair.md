My commit `4b24dbedc` is durably on `origin/ironhorse-fuzz-findings` (a peer stacked `938ff59f1` on top of it). All deliverables are complete. Inbox is empty.

## Completion report

**Finding `91afec2d990bc402`, target `differential_regexp_surface`** — reproduced, regression-locked, and documented on the standing PR.

**What I did**
- Recovered the 4-byte minimized input to a file (`base64 -d` of the journal marker), verified `sha256 = 1e9756ce…4670419`.
- Set up the pinned fuzz env (c/moddable submodule at `23b4d6b0` via local peer-init, `nightly-2026-08-15`, cargo-fuzz).
- **Reproduced the crash at the fuzzed SHA `38ca1d189`**: the input folds into a deeply nested `new RegExp(<pattern>, "s").source` (a 1117-byte program, `sel = 0x34 % 12 = 4` → `.source`); `cargo fuzz run differential_regexp_surface` panics there with a *result* divergence vs the XS pin.
- Confirmed it does **not** reproduce at the standing branch HEAD.

**Root cause / fix** — This is an **oracle-side buffer-truncation artifact, not a port defect**, identical in class to already-documented finding `493390fc03979205`: the `.source` completion value (~1090 bytes) overflowed the XS oracle's old 1024-byte capture buffer, so the harness compared a truncated oracle prefix against the port's correct full result. It is **already resolved on this branch** by the sibling `xs-oracle` fix (`ENDOR_RESULT_MAX` grown to 16 KiB + honest `result_truncated` skip on overflow). No new port/oracle change was needed or made.

**What changed**
- `rust/engine/ironhorse-fuzz/src/lib.rs`: added load-bearing differential regression `finding_91afec2d990bc402_regexp_source_agrees` replaying the exact bytes through `differential_check_with_symbols` and asserting no divergence (fmt-clean, mirrors the existing `finding_*` siblings). It crashes at `38ca1d189` (pre-fix) and passes at HEAD, so it fails if the oracle-buffer fix is reverted.
- Committed and pushed to `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase CAS (a concurrent peer push rebased cleanly).
- Adopted the standing PR **endojs/endo-but-for-bots#1088** via `ensure-pr.sh` (marker match; created nothing) and documented finding `91afec2d990bc402` as a PR comment.

**Follow-ups** — None specific to this finding. (Pre-existing note carried from `493390fc03979205`: the module-run path shares the result buffer but its differential targets don't yet consult `result_truncated`; out of scope until a module fuzz target surfaces a >16 KiB result.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-91afec2d990bc402-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3336575 cached reads)
- Output: 30574 tokens
- Cost: $3.4216905000000004
- Wall-clock: 821s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
