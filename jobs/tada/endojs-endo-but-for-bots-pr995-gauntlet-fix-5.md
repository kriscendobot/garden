Inbox empty. The fix stage is complete.

## Completion report — gauntlet FIX round 5, endojs/endo-but-for-bots PR #995

**PR:** `design(endo-claude)` — a design-doc PR (`designs/endo-claude.md` + `designs/README.md`), head `endojs/endo-but-for-bots:design/endo-claude`.

**Panel round-5 disposition was must-fix** (7 seats, all request-changes). I applied the must-fix items once, as review-feedback follow-up commit `772188fd3d`, pushed via `safe-push-pr-head.sh --mode advance`, and CI came back **GREEN** (5/5 checks, 0 failed).

**What I changed:**
- **Code-eval deny at the boundary (critic/decomplector #1):** the design now prunes unsafe/dunder/code-eval names (`evaluate`/`eval`/`define`, `__`-bearing, reserved) from the `tools/list` snapshot *before pinning*, so the bridge's own server-side dispatch check — not just `--allowedTools` — enforces them. One filter, one pruned snapshot, feeding both the allow-list and the bridge (DD2, § wildcard trap, the "One sentence" summary).
- **DD2 membership satisfiability (critic #2):** membership is now validated against the pinned catalog the bridge serves, not `E(facet).__getMethodNames__()` (Lal tools are `executeTool` names, not facet own-methods, so the old rule failed closed on every Lal entry). Withholding is pruning the catalog name, which works for `lookup`+call tools like `readText`.
- **DD1 title count (novice #1):** retitled "five flags, not one," marked § Why's three discovery-surface flags as a subset, and added a pinned `claude --version` assertion pre-spawn (skeptic #2).
- **Process topology (novice #2):** named the two stdio processes distinctly — harness-owned **facet broker** (holds the fd) vs claude-spawned **stdio adapter** — across § Local deployment, § Routing, the architecture flowchart, and the sequence diagram (which now shows both participants).
- **DD8 throw-vs-return rule (ergonomist #1):** grant/harness-invariant failures throw; every launched-inference outcome returns tagged and never rejects; before-spawn cancel is the one deliberate tagged-return seam.
- **`--tools` variadic (skeptic #1):** added to the argv-swallow enumeration, noting a swallowed token re-populates the deny-by-construction built-in set.
- **Entitlement residual (skeptic #4):** named as a third load-bearing residual (subscription terms/usage policy for fleet pooling) in § Pooling and Known Gaps.
- **README (copyeditor/pedant #1, skeptic #5):** fixed the stray `+ ` bullet that split the note's emphasis; synced M6's own-work rollup to fold in endo-claude's ~1-1.5 weeks (est. line, milestone table, total-remaining row); dropped U+2026 ellipses in code spans.

**Deliberately deferred (noted for the record, not CI-blocking):** the pedant's whole-file style findings — 37 em-dashes and the one-sentence-per-line reflow — are pervasive pre-existing conditions tolerated across five rounds; a single fix round should not mechanically mass-rewrite them (risk of meaning drift), and docs-only CI does not gate on them (Prettier only checks `.github`/`packages`, not `designs/`). The duplicate same-dated totals blocks in README are pre-existing structure the copyeditor itself flagged as not introduced by this PR.

I did not re-run the panel; the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (7683672 cached reads)
- Output: 48584 tokens
- Cost: $6.613407999999999
- Wall-clock: 1169s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
