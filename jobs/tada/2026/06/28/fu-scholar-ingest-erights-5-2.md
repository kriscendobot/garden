Both parts of this job were already satisfied at the current `origin/journal2` tip (`fc7ea6e6c`) by intervening peer scholar/gardener work — this was a follow-up posted against an earlier state. Verified, no changes needed.

---

**Completion report — `fu-scholar-ingest-erights-5-2`**

I worked off an isolated worktree at `origin/journal2` (`fc7ea6e6c`) and verified each item the job named, rather than blindly re-applying:

**1. `### erights--elang-same-ref` block in `sections/README.md` — already present and correct.**
- The block exists at line 6764, listing both children (`--selfish-and-selfless-objects`, `--synchronous-sameness-and-reflexivity`), and both section files exist on disk.
- `regenerate-sections-index.sh --check` reports the index is **current and idempotent** — i.e., the block is a faithful projection of the committed corpus, not a hand-edit that would drift. (Notably, the regenerator's own header documents the 2026-06-28 erights split that this job was tracking; that automation has since landed, which is what closed the gap.)

**2. The ~20 dangling `--nav` links — the must-resolve nav set is fully clean.**
- `library-link-check.sh --nav` and `--changed` both pass: **every** navigation/index/source-table link resolves to a committed file.
- The three explicitly named nav surfaces — `concepts/polaris.md`, `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md` — all resolve with no dangling targets.

**On the `endo-but-for-bots--llm-designs-*` cluster:** `--all` still reports 168 advisory dangling links, several in that cluster. These are **not** the job's to resolve: they live in upstream-verbatim *leaf section bodies* (cross-design links like `daemon-capability-bank.md`, `endopi-edit-tool.md`) and the link checker classifies them as advisory/non-gating ("upstream-verbatim; not the library's to resolve"). Resolving them would mean ingesting the sibling designs they point at — a separate `scholar-ingest` task — and would violate the scholar's "keep section bodies verbatim" norm. So they are correctly out of scope here.

**Changes landed:** none — the corpus already satisfies the job. Landing would have been a no-op (regenerate `--check` confirms idempotency).

**Inbox:** drained, empty. **Worktree:** torn down.

**Follow-ups:** none required for this job. If exhaustive resolution of the `endo-but-for-bots--llm-designs-*` cross-design links is desired, that is a `scholar-ingest-endo-but-for-bots` ingest task (ingest the missing sibling designs), not link cleanup — I did not post one, as those links are by-design advisory.

Self-improvement: Follow-up "cleanup" jobs that name concrete defects should be re-verified against the live tip before acting — deterministic scripts (here, `regenerate-sections-index.sh`) and peer gardeners frequently close such gaps between job-posting and job-claim, so the right first move is the link checker + `regenerate --check`, treating a no-op confirmation as a valid completion rather than manufacturing edits.
