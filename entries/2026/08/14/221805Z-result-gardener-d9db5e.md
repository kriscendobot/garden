---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-14T22:18:08Z
---
# Ingested cordiverse/paper — "A Programming Paradigm for Spatiotemporal Composability" (Shi-Zhang-Cui, 2026)

Scholar cycle for `scholar-ingest-cordiverse-paper`. One paper ingested (paper schema), plus the applicability report the job asked for.

## Source ingested
- **`papers--shi-spatiotemporal-composability-2026`** — 6 sections. Paper schema; idempotency anchor `source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f` (88-page PDF, 2.14 MB, fetched direct from `https://raw.githubusercontent.com/cordiverse/paper/main/paper.pdf`). No formal venue — hosted in the GitHub repo cordiverse/paper@main — so the content hash is the anchor, not a git commit.
  - Sections: `overview`, `revertible-effects`, `reactive-coeffects`, `context-paradigm-and-calculus`, `cordis-implementation-and-koishi`, `boundaries-security-and-codesign`.

## Topics / concepts touched
- **New topics**: `dynamic-composition` (5 sections), `effect-and-coeffect-systems` (4 sections). A genuinely new domain for the (endo-centric) corpus, so new topics rather than bending the taxonomy.
- **Existing topics cross-filed** (one row each, via `insert-sections-table-row.sh`): `change-propagation` (reactive-coeffects), `module-loader` (cordis+HMR), `capability-security` (§6.3), `sandbox-platforms` (§6.3).
- **New concept page**: `spatiotemporal-composability` (7 keyword clusters added to `keywords.md`). Cross-linked from the `object-capability` concept page (a section row added there — §6.3 independently reaches the ocap model).
- README indexes updated: `sources/README.md` (External papers row), `topics/README.md` (2 new rows), `concepts/README.md` (1 new row).

## Integrity gate (step 8) — PASS
- `library-link-check.sh --changed`: OK — every checked link resolves to a committed file (source cluster + touched pages).
- `regenerate-topics-counts.sh --check`: stale counts only (informational; no missing topic page), reconciled at land.
- `library-slug-prefix-check.sh --changed`: OK (`papers--` matches its host's siblings).
- Final landing: `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both regenerated and landed (`sections/README.md`, `topics/README.md` counts).

## Follow-on
- No remainder follow-on from me — one paper is a full cycle and it is fully ingested.
- A peer, `scholar-ingest-cordiverse-paper-readme`, owns the repo-side material (README, repo description, code/examples, paper-vs-implementation deltas) as a companion, cross-referenced from this source entry. Notified of the source-slug.

---

# Applicability report: does Cordis's paradigm suggest anything for the garden?

**Headline verdict: RELEVANT AS A LENS, NOT AS AN ADOPTION.** This paper is the closest formal description in the corpus of the *exact* problem the garden lives — it names "self-evolving agent harnesses" as one of its two motivating examples and its future-validation target — but its mechanisms operate one level below where the garden operates (in-process TypeScript components sharing an address space), so it is a vocabulary and a design mirror for the garden, not a framework to bring in. Two of its ideas are worth carrying into how we *talk about and check* the garden; none justifies re-architecting it.

**Why it maps.** Cordis's two dimensions are the garden's two recurring failure classes:
- *Temporal composability* (revert a component's effects completely on removal) is exactly the garden's drain/deploy discipline: the deliberate-deploy design, the root-repo guard, the "stranded drain marker after an abort" hazard, and the job-worktree teardown all exist because the garden *cannot* cleanly revert an in-flight worker's effects. Cordis's answer — every effect pairs with an inverse the runtime accumulates, and unloading is just applying the accumulator — is the idealized version of what our teardown scripts approximate imperatively.
- *Spatial composability* (declare + reactively resolve inter-component dependencies) is the garden's orchestration layer: `blocked_on` + `unblock.sh`, the orchestration jobs (serial/parallel with a child-failure policy), and the leader/follower singleton gating are all hand-rolled dependency topology. Cordis's reactive coeffects (a component activates only when all declared deps are present, deactivates reactively when one withdraws, and the withdrawal guard holds a provider's teardown until dependents finish) are a principled version of what the orchestrate watcher does deterministically.

**Where it does NOT transfer.** The garden's components are *processes and git state across hosts*, not objects in one JS heap. The paper is explicit (§1.2.3, §6.7) that OS processes and container orchestrators are the *coarse-grained substitute* for exactly this, and that the garden's granularity (systemd units, per-job worktrees, a git-CAS job board) is that coarse substitute. The garden deliberately pays the restart/replica cost the paper critiques because its isolation and crash-safety requirements (untrusted PR text, quota, multi-host) are worth more than fine-grained in-address-space composition. Cordis's revertible-effect model assumes the runtime can restore a location exactly; the garden's effects are git pushes, GitHub API mutations, and upstream ferries — mostly *outside the system boundary* in the paper's own §6.1 sense (emission, not acquisition), recoverable only by compensation, which the garden already does ad hoc.

**The two genuinely useful takeaways** (for a mentor/liaison, not for me to land):
1. *The system-boundary / acquisition-vs-emission framing (§6.1)* is a sharp way to audit which garden actions are revertible (a scratch worktree = inside; a push to a PR head or a ferry = emission, outside) and therefore which need *compensation* rather than rollback. This is latent doctrine in the ferry's permissioning and the drain discipline; the paper gives it a name.
2. *§6.3's independent arrival at capability-based access control* — dependency declaration as a load-time-reviewable capability request, interception as orchestrator-adjustable policy on a held capability — is corroboration of the garden/endo ocap thesis from an unrelated PL-theory team, and a citable outside data point that the garden's `inject`-style dependency declaration and the fleet's `gh`-identity pin are the same shape as ocap least-authority.

**What I did NOT do**: no role/skill/design edits (those are mentor/liaison territory per self-improvement). If the boundary/compensation framing is judged worth encoding into the drain or ferry docs, that is a self-improvement item for the mentor, not a scholar edit.

Self-improvement: For a paper that lives in a GitHub repo rather than a venue, the paper schema's `source_pdf_sha256` anchor is the honest idempotency choice (main-branch PDFs can be revised), but it leaves the repo-side material (README, examples, paper-vs-code drift) uncovered — which is exactly why the split into a companion `-readme` job worked well here. Worth a convention note that a repo-hosted paper is a two-job pattern: paper-schema PDF ingest + repo-content companion, coordinated over the bus on the shared source-slug.
