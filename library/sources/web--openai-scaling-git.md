---
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
section_count: 10
status: current
content_caveat: "Not classified: the TypeSafe classifier was unavailable on this host (TYPESAFE_API_KEY absent; classify_policy=proceed_unclassified under the maintainer's 2026-11-12 typesafe-bypass directive). On manual reading the page is factual engineering prose with no embedded instructions to agents; performance, adoption, and timeline figures are OpenAI's own claims, and the interactive simulation is labeled by the authors as a synthetic teaching model, not a benchmark."
notes: "openai.com refuses direct fetches from the bot sandbox (HTTP 403), so the bytes came from the Internet Archive id_ original-bytes capture 20261110004756 via scripts/jobs/fetch-source.sh (source_fetched_via=wayback, gzip decoded before hashing). The idempotency anchor is source_content_sha256 over those 965,207 bytes, not a git SHA. Sections follow the post's H2/H3 headings; the two interactive widgets (the three-architecture simulation and the push/fetch animation) are summarized in prose. Second agent-scale source-control source in the library after web--anthropic-redesigning-source-control (Scion); the two are deliberate contrasts (Git-compatible server rebuild versus a non-Git object-RPC service)."
---

Abstract: OpenAI's *Scaling Git at OpenAI* (Aaron Friel, Taylor Blau, Ted Nyman; 2026-11-02) describes **Pando**, a Git-protocol-compatible server backend built because Codex-driven parallel work pushed the monorepo's old serving stack below 90% reliability. Pando scales writes by giving up repository-wide ref consistency for **per-ref serializability and causal consistency** (each push stored as an immutable pack blob plus a **ref version** in a scalable metadata store, the ref pointer the only contended key), and scales reads by **reusing pushed packs** instead of computing per-client packs: it advertises only trunk on push so packs stay reusable, plans fetches as pack selection over ref versions in logarithmic time, serves packs exclusively through **`packfile-uri`** from a regional cache (Express), and replaces repack/GC with **LSM-style compaction covers** (L0 to L4) that double as a skip list. The post contrasts this with three-phase-commit and shared-manifest WAL replica designs, recounts a 10-week Codex-built Rust implementation verified with conformance tests, deterministic simulation, and Lean/TLA+, a proxy-first migration, and upstream Git contributions (parallel pack download/indexing, `packfile-uri` tracing, "explicit haves" for `--force-with-lease`). Figures are OpenAI's own.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--openai-scaling-git--overview.md) | source-control-architecture, agentic-sdlc | current |
| [Why OpenAI needed a new source control system](../sections/web--openai-scaling-git--why-a-new-source-control-system.md) | source-control-architecture, agentic-sdlc | current |
| [Git object storage primer](../sections/web--openai-scaling-git--git-object-storage-primer.md) | source-control-architecture, content-addressed-storage | current |
| [Existing distributed Git service patterns: 3PC and WAL](../sections/web--openai-scaling-git--existing-distributed-git-service-patterns.md) | source-control-architecture | current |
| [Rethinking constraints: causal consistency](../sections/web--openai-scaling-git--causal-consistency.md) | source-control-architecture | current |
| [Scaling pushes](../sections/web--openai-scaling-git--scaling-pushes.md) | source-control-architecture | current |
| [Line-rate fetch and clone](../sections/web--openai-scaling-git--line-rate-fetch-and-clone.md) | source-control-architecture, networking | current |
| [Compaction and time to first byte](../sections/web--openai-scaling-git--compaction-and-time-to-first-byte.md) | source-control-architecture, content-addressed-storage, data-structures | current |
| [Building and deploying Pando](../sections/web--openai-scaling-git--building-and-deploying-pando.md) | source-control-architecture, agentic-sdlc, testing | current |
| [Contributing back to Git, and what comes next](../sections/web--openai-scaling-git--contributing-back-to-git.md) | source-control-architecture | current |
