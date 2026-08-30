Everything is complete and verified. Worktree is clean, HEAD matches the pushed PR head, CI is running, and the ironhorse-vm regression suite (the CI-visible gate for this class) is green locally.

---

## Completion report — Ironhorse fuzz finding `8275793bca439f6e` (`differential_regexp`)

**What I found.** Re-derived the job from a clean worktree. Standing PR **#1088** already exists; this finding was not yet addressed. Reproduced the crash from the durable 20-byte artifact (sha256 verified) against the pinned base SHA `38ca1d18` — it reproduced as a `differential_regexp` "match meter" divergence: `ironhorse=73404907520` vs `pin=390463488`.

**Root cause (diagnosed, not guessed).** The generated pattern is a backreference-heavy pathological regex (`\1*`/`\3*` empty backrefs, lazy `\1+?`, `{2}` repeats) over `"0"@0`; both engines agree on match and captures, only the metered step count differed. Through progressive pattern bisection and per-opcode dispatch histograms I established the port and XS dispatch the **identical** step graph. The apparent divergence is the **32-bit meter-truncation class** (same as findings `5d122a6fc10babd9` / `407764ab1120ed1a` / `493390fc03979205`): the port meters into `u64` and is correct (1,120,070 steps → raw meter 73,404,907,520, 17× past 2³²); the pre-fix oracle wrapped it to `73404907520 mod 2³² = 390463488` (5958 computrons) — the phantom "pin" value. **Decisive proof:** rebuilding the *widened* oracle (already on the branch via `c8497fd88`) in an isolated worktree and re-running the exact case gives port ≡ pin **op-for-op** (identical histogram). The warm `.garden-state/…/project` checkout only shows the divergence because it sits at the base SHA that predates the fix.

**Causal fix.** Already present on the standing branch (`c8497fd88`, the `txU8` meter-field widening); the port never needed a change. No new fix was warranted — a speculative "fix" would have risked the many passing cases.

**What I changed / landed.**
- Added load-bearing regression `rust/engine/ironhorse-vm/tests/finding_8275793bca439f6e_regexp_meter_overflow.rs` — replays the exact generated pattern through the port's `compile`+`match_regexp`, asserting no panic, whole-match `(0,1)`, and the full-width meter `73_404_907_520` (≠ the `390_463_488` wrap). A **distinct, backreference-driven** witness of the class; builds without the oracle/submodule.
- Committed (`bb42765fc`) and pushed to `kriscendobot:ironhorse-fuzz-findings` with fetch/rebase CAS (rebased cleanly over a peer's new finding).
- Confirmed PR #1088 adopted via `ensure-pr.sh` (marker match; no duplicate).
- Posted a PR comment documenting the finding, the truncation-class diagnosis, and the systemic follow-up.
- Verified: full `ironhorse-vm` suite green (106 unit + all finding regressions incl. the new one); CI on #1088 triggered.

**Follow-up surfaced (not this PR).** The fuzz service confirms/minimizes against the pinned **base** SHA, which predates the accumulated branch fixes, so it will keep re-reporting already-fixed meter-overflow inputs until #1088 merges to `llm`. Reproducing against the standing branch head (or class-filtering) would stop the churn.

Memory updated ([[ironhorse-fuzz-oracle-truncation-class]]) with this third confirmed re-discovery and the isolated-widened-oracle verification method.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-8275793bca439f6e-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 195 tokens (13443761 cached reads)
- Output: 95398 tokens
- Cost: $11.181387500000001 (1 engagement(s) unpriced)
- Wall-clock: 1650s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
