Inbox empty. The directive is fully satisfied. No main2 garden-repo changes were needed — the deliverable is a board artifact on `journal2`, already pushed by `post-plan.sh`.

## Completion report

**Directive** (endojs/endo-but-for-bots#987, kriskowal): "post a builder to attempt this next week, after the quota reset on Friday at 9pm."

**Preflight corroboration (exit 2 was a hint, not a resolution):** The only artifact citing feedback id `5337796794` is *this job's own auto-ack* ("On it — I've posted a job `endojs-endo-but-for-bots-pr987-2cc814f3`…"), not a peer's resolution. Board search found no builder for #987's revised design (the prior tada `…-build-endor-git-cas` is the *earlier* pure-Rust `gix` Phase-1 CAS build, PR #872 — a different approach). No schedule/plan entry defers one. → Proceeded with the work.

**What I did:**
- Parked a **budget-hold builder plan** `endojs-endo-but-for-bots-build-endor-git-bindings` (`role: builder`, `priority: high`, `gate: go-ahead`) on `journal2`.
- Set `budget_resets_at: 2026-08-22T04:00:00Z` = **Fri 2026-08-21 21:00 America/Los_Angeles**, the Friday-9pm reset that opens next week's quota. The active `garden-budget-refresh` watcher deterministically promotes it to `todo/` once that instant passes — the purpose-built garden mechanism for "run after the quota reset."
- Body targets the *revised* design in #987: new `rust/endor-git` crate binding **libgit2** via `git2`/`libgit2-sys` (vendored static libgit2, `unstable-sha256`), the `Libgit2Repository`/`Libgit2Backend` seam, and the Zig cross-build matrix + release lanes — with the design's own least-proven Windows-GNU lane (`cargo-zigbuild`) flagged as attempt-and-report-gaps rather than force.
- Verified the parked frontmatter landed correctly.

**Decision surfaced to the maintainer (via message-bus):** The automatic router stamps `tier: mentor` on every parked body (Claude off automatic since 07-29), so as-parked this hard build will attempt on **mentor tier, not Opus**, even after the reset. Since deferring *to the quota reset* strongly implies they want an Opus builder on fresh quota, I flagged that they should promote/re-post it as a manual Opus job at that time (or re-enable automatic Claude routing) — and left it a go-ahead budget-hold so they retain full control. Overriding standing routing policy is a maintainer/liaison call, not a gardener's.

**Follow-ups:** Awaiting the maintainer's tier preference (mentor vs. Opus). No PR comment posted beyond the existing auto-ack (no over-posting; nothing resolved/closed). No main2 changes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-2cc814f3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1401119 cached reads)
- Output: 23654 tokens
- Cost: $2.0189744999999997
- Wall-clock: 356s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
