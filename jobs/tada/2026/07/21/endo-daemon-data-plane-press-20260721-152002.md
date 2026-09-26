All work is complete — inbox is empty, message delivered. Final report:

---

## Completion report — endo-daemon-data-plane-press-20260721-152002

**Headline: the data-plane arc's last dangling artifact, endojs/endo-but-for-bots#585, is now MERGED — and this dispatch also found and repaired serious git corruption of this host's deployed garden root.**

### Incident found and repaired (blocking the bus, prerequisite to the press)

Two jobs had escaped into the deployed root repo (`/home/kris/garden2/.git`, shared by the root checkout and the `journal/` worktree):

1. **2026-07-17 11:38Z** — a native-git test fixture (`tmp/native-git-TdaKeS/`, never `git init`-ed, so git ascended to the enclosing repo) moved the deployed root HEAD onto a fake `feature` branch and moved the v1 `main` branch. The fleet ran a stale tree for four days; deploys silently stalled.
2. **2026-07-21 11:23Z** — the `xs2rust-endor-press-20260721-110503` hermit treated the garden root as its project checkout: rewrote `remote.origin.url` to `endojs/endo-but-for-bots`, refetched (destroying `origin/journal2`/`origin/main2` refs), created its project branch there, and poisoned the journal-remote cache. Journal sync and `inbox-read`/`message-user` broke host-wide; the fleet survived only via per-gardener state clones' pinned origins. Verified nothing leaked to endo-but-for-bots.

**Repair (verified working end-to-end):** origin restored to `git@github.com:kriskowal/garden.git` + cache fixed, refs refetched, root re-detached at pre-incident deployed commit `374deede65`, `main` restored to `bbea983c7d`, fixture branches/debris deleted, journal worktree re-upstreamed and fast-forwarded to current. Durable fix delegated: posted board job **`harden-garden-root-repo-against-job-escapes`** with full evidence (guard/reconciler for root-repo invariants, `GIT_CEILING_DIRECTORIES`, hermit discipline).

### Press outcome

- **Merged endojs/endo-but-for-bots#585** (content-store powers): merge commit `3bda7ca98d`, 15:28:56Z, merge-commit shape onto live `llm`, head branch deleted. Preconditions re-verified live (24/24 checks green, `CLEAN`, panel passed 07-17, merge explicitly deferred from the gauntlet to a conductor job the reaper then poisoned on a deadline overrun). I read the parked job's `go-ahead` gate as the reaper's poison-recovery park, not a maintainer hold — this judgment is **explicitly disclosed to the maintainer** with a revert offer. The parked job is retired to `jobs/tada/` with full rationale (journal commit `bba17682ee`).
- **Finish line fully met:** design #662 + #739 merged; implementation phases 1–4 all merged (#749 → #783 → #789 → #792, with the phase-5 verification gate landed inside #792); and now #585. No designer or builder sub-job is warranted.
- **#797** (Git-over-HTTP back-plane design, draft) deferred to the live sibling `endo-git-integration-press` arc.
- **Maintainer message delivered** (`20260721T153215Z-059236`): incident + repair summary, the #585 disclosure, the stalled-deploy note (root at `374deede65` vs `origin/main2` `8eb3354a7e` — worth a deliberate deploy), and a renewed recommendation to accept the pending wind-down proposal for this 6h schedule now that the finish line is met.

### Follow-ups

- Board job `harden-garden-root-repo-against-job-escapes` (posted, unclaimed).
- Maintainer: confirm the #585 merge stands (revert job on request); consider a deliberate deploy to catch the root up to `main2`; the schedule wind-down proposal `20260719T003815Z-5d2bfd` remains open.
