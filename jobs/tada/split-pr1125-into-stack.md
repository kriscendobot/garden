All deliverables are complete. Here's my report.

---

## Completion report: split endojs/endo-but-for-bots#1125 into a stack

**Outcome:** #1125 retired and replaced by a dependency-ordered **3-PR stack**. When all three merge, the tree is **byte-identical in source and tests** to #1125's head `9fad002` — the split changes no behavior.

### Slice boundaries and rationale
The three areas the maintainer named map cleanly onto a genuine dependency stack, which is why I stacked rather than opening three independent PRs (they share the same functions in `manager.js`/`guest.js`/`host.js`, so independent PRs against `llm` would conflict with each other):

1. **#1304 — read-only directory attenuation** (base). `EndoDirectory.readOnly()`, the guarded `ReadableNameHub` exo, the read-only-directory eval formula + `isReadOnlyDirectoryFormula`. Self-contained; nothing depends on the others. Targets pinned `llm-387ea66`.
2. **#1306 — caller-elected pins, networks, names** (on #1304). `provideHost`/`provideGuest` `pins`/`networks` options, guest-visible `@pins` vs host-only pin directory, mailbox pin reincarnation, `NameHub.listValues()`, inspector surfacing. **Depends on #1304** because the read-only `networks` option delegates through `EndoDirectory.readOnly()`.
3. **#1305 — guest-owned invitation primitive** (on #1306). `EndoGuest.invite`, the `hostAgent`/`hostHandle`→`invitingAgent`/`invitingHandle` rename, the internal network broker, single-use atomic accept, `Invitation.cancel()`, result-name connection roots. Shares the guest/host provisioning surface, so it sits on top.

I built it as three commits where the top layer's tree equals the known-green PR head, so the union is provably the original change. Each lower layer (A, B) was verified with **`tsc` + `eslint` clean** (0 errors). I could not run the daemon integration suite locally — the per-job worktree path exceeds the ~104-char unix-socket limit (`endo.sock` ENOENT), a known environmental limit — so full-CI green is delegated to each slice's shepherd loop.

### Links
- **#1125** — CLOSED, with a comment linking all three replacements + the receipt division.
- **#1304** (1/3), **#1306** (2/3), **#1305** (3/3) — all OPEN as drafts with incremental, per-slice diffs. The stack lives on in-repo `endojs` branches `bot/build/1125-*` (a cross-fork base is impossible; the bot has push to endojs, and stacked bases must be in-repo).

### Orchestration
Posted **`split-pr1125-stack-gauntlets`** (serial, halt-on-failure) with children `split-pr1125-{1304,1306,1305}-gauntlet-shepherd`. Serial is load-bearing: a fix a gauntlet pushes to a lower slice forces rebasing the slices above, so a parallel run would make a lower fix appear to "revert" in an upper diff. Each child rebases onto its settled base before initiating its own gauntlet (which includes the CI-driving shepherd loop).

### Receipt
Generated #1125's receipt via `cost-by-pr.sh --base-map`: **~$207.80** calibrated across 53 bases. Divided by the slice each item's work maps to — direct: **$0.06** (#1304), **$45.85** (#1306, pins/nets/option-parity/restart-durable fixes), **$24.63** (#1305, invitation/chat-diagnostics/build). The remaining **$137.26** is whole-PR review/gauntlet/shepherd overhead (32 bases) — the very cost the split aims to reduce; apportioned in even thirds it gives ≈$45.81/$91.60/$70.39. Posted as a division table on #1125 and forwarded as a share comment on each new PR so each PR's eventual (merged) receipt can capture it.

**Follow-up flagged (more than a one-off):** the automated receipt mechanism (`receipt-watcher.sh`/`cost-by-pr.sh`) only rolls up to **merged** PRs and has no path for **closed→forwarded** line-item division. The durable mechanical forward would be `receipts/base-pr-overrides.tsv` rows remapping each #1125 base to its slice PR, but writing that is a journal-data commit I did not make from the deployed root (shared-repo hazard). The comments are the durable capture today; extending the receipt tooling to honor a closed-PR forward (or the overrides remap for shared vs. slice-specific bases) is a genuine mechanism gap worth a small design/build.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/split-pr1125-into-stack.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 190 tokens (15742620 cached reads)
- Output: 129846 tokens
- Cost: $13.567181000000005 (2 engagement(s) unpriced)
- Wall-clock: 2265s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
