CI is GREEN (rc 0). The fix round is complete.

## Completion report

**Job:** Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #987 (`design(endor): bind libgit2 with Zig cross-builds`)

This is a **design-document PR** (`designs/endor-git-bindings.md`). The panel-1 review was a single aggregate `gh pr review` with 5 request-changes seats (critic, skeptic, ergonomist, copyeditor, novice) and 2 comment-only seats (decomplector, pedant). I applied every must-fix item, plus the two comment-only pedant consistency fixes, in one commit.

**What changed** (`96f5a26f82`, 2 files):

*Substance (critic / skeptic / ergonomist):*
- **Renamed `GitStore` → `GitObjectDb`** everywhere to remove the collision with Endor's `ContentStore` (ergonomist).
- **Conceded the Zig cross-toolchain tradeoff** against the 2026-07-26 PR #740 rejection: the saving is bounded to the four Linux target triples; the Windows-GNU and macOS lanes are conceded as still needing hand-maintained wrappers / a pinned SDK, not presented as solved (critic).
- **Added a maintainer escalation trigger** for any release target Zig cannot reproducibly cross-build + natively run, mirroring the SHA-256 gate discipline (skeptic).
- **Gave `gix` a technical rejection basis** — no stable published custom ODB/refdb plug-in seam, which is the load-bearing fact — and noted the switch is SHA-256-neutral (critic).
- **Documented the sync-to-async blocking-pool bridge as an `endor-git`-owned reusable affordance** (ergonomist).
- **Added a "Pack resource bounds" verification gate** for oversized/malformed/delta-bomb packs on the one guest-controlled input path (skeptic).
- **Re-derived the `designs/README.md` estimate** from `M | 4-5 days` to `L | 2-3 weeks` for the expanded unsafe-FFI + cross-build + cross-repo scope (skeptic).

*Prose (novice / copyeditor / pedant):*
- Glossed **Minion Town**, **partition**, and **weblet manifest** on first use (novice).
- Fixed `PR #740` citation, unified the "CAS and SQLite adapter" phrasing across doc + mermaid + README, list-mood parallelism, the `them` pronoun antecedent, the tangled "seam and build experience" clause, and Phased-delivery item 5's parallel structure (pedant, copyeditor).

Verified no em-dashes / curly quotes / typist-hostile code points in the additions; mermaid diagram still valid.

**Push & CI:** Pushed via `safe-push-pr-head.sh --mode advance` (`94a6571e90 → 96f5a26f82`). CI watched to terminal, bounded — **GREEN**, 5/5 checks, 0 failed (rc 0).

**Follow-up (non-blocking):** README milestone aggregate M11 (`14-21 / 16-23 weeks`, line ~1550) sums 5 designs including this one; I left the aggregate untouched since re-deriving a 5-design milestone sum is out of this stage's scope and error-prone to guess. The panel driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 63 tokens (2292597 cached reads)
- Output: 18365 tokens
- Cost: $2.3118295000000004
- Wall-clock: 705s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
