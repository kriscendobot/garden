The message is delivered to the maintainer. I've fulfilled the weaver's mandate for this case: surveyed divergence, confirmed the branch premise is broken on current llm, and surfaced to the maintainer rather than forcing a lossy rebase. PR #3 is untouched — no push, no base change, no force-push.

## Completion report

**Job:** rebase (refresh stale frozen base) on kriscendobot/endo-but-for-bots PR #3.

**Outcome: escalated to the maintainer — the mount stack premise no longer holds on current llm, so I did not force the rebase.** This is the exact escalation the job's survey caveat anticipated. PR #3 is untouched (no head push, no `--force-with-lease`, no base change).

**What I found (survey, per weaver step 1):**
- The frozen base `llm-b377b0e` is not an ancestor of live llm `67dfc18` (divergent histories, as warned).
- The PR's net diff over its base is two things: (1) `packages/regexp` — the RFC 9485 conservative profile, the PR's real title/intent; (2) a `rust/mount_parity` Rust crate pulled in by a `stack: merge endojs/endo-but-for-bots#654` merge commit — stack baggage from PR #654's mount glob/grep parity runner.
- The merge commit **discarded** the stack's daemon-side changes (net `packages/daemon` == base), so a naive linear rebase (which drops the merge and replays the 4 daemon commits) would be *wrong*, not just conflict-prone.

**Why a refresh onto current llm breaks (the broken premise):**
- The `mount_parity` crate reads its case tables via `contract_dir()` = `../../packages/daemon/test`. On llm those fixtures **moved** to `packages/platform/test`; the old daemon path is gone, so `mount_glob_parity.rs` / `mount_grep_parity.rs` would not find `mount-glob-cases.json` / `mount-grep-cases.json` / `mount-fixture-manifest.json`.
- llm has no `EndoMount.glob()` in `packages/daemon`; the feature relocated to a `platform` package.
- Dependency PRs are stale: endojs/endo-but-for-bots#127 (daemon glob/grep feature) is **CLOSED, not merged**; endojs/endo-but-for-bots#654 (the rust runner) is still **OPEN**, stranded on #127's closed branch.
- Even repointing `contract_dir` to `packages/platform/test` would not be safe: `mount-grep-cases.json` has **diverged** from what the crate was written against (mount-glob and the fixture manifest are still byte-identical; only grep evolved), so grep parity could fail against the Rust mirror.
- The regexp Rust parity (`i_regexp_profile_parity.rs` + `regexp_contract_dir()` in `mount_parity/src/lib.rs`) lives *inside* the same crate, so regexp and mount work cannot be split by a mechanical rebase.

**Surfaced to the maintainer** (via `message-user.sh`, delivered to `inbox/maintainer` `20260801T104125Z-f4eda2`) with the diagnosis and two fixer paths: **(A, recommended)** treat PR #3 as regexp-only, drop the `mount_parity` crate, and let endojs/endo-but-for-bots#654 pursue its own rebase; or **(B)** keep the crate, repoint `contract_dir` to `packages/platform/test`, and reconcile the Rust grep mirror against llm's evolved case table. I did not comment on the PR (the weaver job carries no comment authorization; the reply is held here and in the maintainer inbox).

**Follow-ups:**
- A maintainer/liaison scope decision is needed, then a **fixer** job (path A or B). This is not a weaver rebase.
- The originally-reported lint error (`packages/reminder/test/plugin.test.js` `no-redeclare`) does clear for free on any refresh (llm deleted that file), but it rides along with whichever fixer path is chosen.

Self-improvement: candidate note for `skills/frozen-base-branch` — a `stack: merge` whose net diff *cancels* a sub-tree can still be premise-broken, because a *retained* sub-tree (here a Rust crate) may depend at runtime on fixtures the merge discarded or that moved on the new base; check retained-content fixture paths, not just git textual cleanliness. Existing weaver runtime-inconsistency norm already covers the spirit, so I am flagging it rather than landing an edit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-but-for-bots-pr3-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 43 tokens (1819964 cached reads)
- Output: 36038 tokens
- Cost: $2.747229
- Wall-clock: 525s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
