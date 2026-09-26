All three fronts assessed. Final confirmation: the fixer job's `[post] posted` line prints only after its CAS push to `origin/journal2` lands (my local `journal/` worktree just hasn't re-synced yet — I must not run git there). Work is complete.

---

## Completion report — `xs2rust-endor-press-20260827-233529`

Hourly Ironhorse press. Assessed all three fronts against live state; deferred to no live pusher because none exists right now (only `garden-gardener@1` is active on this host, running this job — the earlier `#1046` shepherd/oom claims sit stranded in `doin/` from stopped workers). Pressed by posting the one genuinely-actionable, evidence-backed fixer.

**Front 1 — fixture-parity ratchet campaign: COMPLETE and MERGED.** PR #282 (`feat(endor): node_modules entry walker + fixture-parity ratchet`) merged 2026-08-27T23:15:25Z at **32 exercised / 0 pending / 8 durable** — all 7 increments landed, including Increment 7 (host-hooks, `endor-walker-host-hooks-20260827`). The `endor-walker-exports-resolution` child that halted the campaign twice was **resolved** (`endor-walker-exports-resolution-20260827` landed Increment 2 — the two prior halts were diagnosed as provider-acquisition/tier-routing failures, not task difficulty). No third halt, no re-orchestration needed. The leftover `plan/endor-walker-exports-resolution.md` is an obsolete doomed reaper-repost of that now-completed child (invisible to foreman/reaper) — left as-is.

**Front 2 — open Ironhorse PRs:**
- **#1046** (Ironhorse coverage agents, `feat/ironhorse-coverage-matrix`): `fuzz-ironhorse` is **RED** on head `a3e9d138a7` — a genuine new VM panic `leave_call with empty call stack` at `interp.rs:30797` (CI run 33123238794). A leave/return-family opcode underflows the call stack and aborts instead of degrading to a `Halt`. **Distinct** from the already-landed native-dispatch depth cap and from the separately-owned async-instance OOM job (`…fuzz-async-instance-oom-20260827`). No live worker on it. **Posted focused fixer** `endojs-endo-but-for-bots-pr1046-fuzz-leave-call-underflow-20260827` (fixer/mentor+minion) carrying the exact 20-byte reproduction input (`290cc1c1c1c10c0c38666666666666660642c152` / Base64 `KQzBwcHBDAw4ZmZmZmZmZgZCwVI=`), the invariant-fix mandate, and a permanent-regression + drive-CI-green requirement.
- **#1064** (ArrayBuffer/view coverage): 25/25 green, mergeable — awaits human review. Nothing to press.
- **#877** (dual-build npm package execution): 28/28 green — awaits review. Nothing to press.
- **#1067** (generator-fn-constructor intrinsic): CI in progress (10 success / 15 pending), recently gauntlet-fixed. Left running.
- Drafts (#1059 snapshot store, #1039 error-unwind, #1019/#1018/#1016 designs, #892/#879/#855 docs): WIP/design — left.

**Front 3 — endor-git-bindings + standing lines:** PR `kriscendobot/endo-but-for-bots#4` unchanged at **35 SUCCESS / 1 FAILURE**, the sole failure the documented `windows-gnu-zig-probe`; no push since 2026-08-22. No regression. Windows follow-up remains parked as `design-endor-git-windows-followup`.

**Verification:** live `gh pr view`/`gh api` for PR #282, #1046, #1064, #877, #1067, and fork #4; `gh run view --log` on the failing fuzz job to extract the panic site and minimized crash input; systemd unit inspection for worker liveness; journal board inspection for campaign/orchestration state and dedup.

**Follow-ups:** the posted leave_call fixer (owns the #1046 fuzz gate); the pre-existing async-instance OOM job and a stranded `pr1046-shepherd` remain in `doin/` awaiting reaper requeue (not mine to force). No self-improvement this cycle.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs2rust-endor-press-20260827-233529.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 65 tokens (2439239 cached reads)
- Output: 28072 tokens
- Cost: $2.8037194999999984
- Wall-clock: 450s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
