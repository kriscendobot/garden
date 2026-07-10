Inbox empty. Work complete.

## Completion report — `design-spark-gardeners`

**Task:** Design child of serial orchestration `orch-spark-gardeners`. Designed the **Spark gardener**: a fleet-worker variant harnessed on Meta's Muse Spark 1.1 through Simon Willison's LLM CLI (`llm-meta-ai`) instead of `claude -p`.

**Landed:** `designs/spark-gardeners.md` on `main2`, commit `76980b2ea172f0c9e76ac8c65776f8058de6d5f5` (rebased once past a concurrent bulletin change; CAS push accepted).

**Built on the scholar's findings** (`jobs/tada/scholar-muse-spark-harness.md` and its `journal/library/` ingest — the `muse-spark-garden-worker-fit`, `muse-spark`, and `llm-meta-ai` concept pages plus the six sections). No re-research; the design adopts the scholar's verdict (reachable but not a drop-in; motive is harness diversity, not capability) as its premise.

**Key decisions:**
- **Harness seam (Options-Considered):** chose a per-job `harness:` frontmatter field, orthogonal to `model:`/`role:`, dispatched in `gardener.sh` at the existing handler call site to a sibling `handlers/gardener-spark.sh`. Rejected for v1: a dedicated claim-filtered pool (forward-compatible if volume grows), folding Spark into `resolve_model_tier` (conflates model with substrate), and a bespoke OpenAI-compatible harness.
- **Capability routing, stated plainly:** Spark **can** take report-shaped work over trusted text (review memos, drafting, schema-shaped audits), later small scoped-write authoring jobs. Spark **cannot** be assigned anything the gardening state machine supervises (build/fix/gauntlet/shepherd/merge), watcher-fed or untrusted external text, the ferry, or unattended long loops.
- **Safety:** the sender-gated Monitoring-constraint exceptions are *not* extended to Spark; fixed minimal tool allowlist (no `run_command`), per-job worktree as Meta's recommended workspace isolation, bounded engagements answering the attractor-state flag.
- **Fleet/spend integration:** no new unit template, claim path untouched; completion via `--schema` structured output feeding the same sentinel gate; token metering from LLM's SQLite log keyed by a deterministic conversation id, ledger rows gaining a `harness` column (sequenced with the tada-token-accounting build); cost marked unmeterable (no published pricing).
- **Routing control:** explicit `--harness spark` on `post-job.sh`/`post-plan.sh` only; no role default, no foreman auto-routing in v1; absence of the field changes nothing.

**Recommended build phasing:** Build 1 (phase 0) = the dispatch seam, read-only Spark handler with precondition gate, `--harness` flags, model-selection skill section, handler test with a fake `llm`. Build 2 (phase 1) = scoped `write_file` + scripted `commit_and_push`. Phase 2 uncommitted, gated on pilot evidence and Meta GA/pricing. **Blocking preconditions before any build:** maintainer-obtained Meta API key with the model actually enabled (429-means-not-enabled preview gate), a per-host key-provisioning decision recorded in the journal, and an explicit pilot spend ceiling.

**Follow-ups:** none posted; the orchestration ends with this child. The build children should be posted only after the maintainer resolves the § Preconditions.
