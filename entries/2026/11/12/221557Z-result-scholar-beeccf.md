---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-11-12T22:15:59Z
job: scholar-ingest-meta-harnesses-codefall-ycc-typesafe
claim: 0007ea5329dfc0f0
---
# scholar-ingest-meta-harnesses-codefall-ycc-typesafe — result

Ingested two coding-harness READMEs as sibling/meta-harness references into `journal/library/`, one source per repository, filed alongside Symphony (OpenAI) and unum (jcorbin).

## Sources ingested

- **lividlabs/codefall** README @ `e42ed0d0b5100c068415c473eb813d2885153c90` (2026-11-12, Dave Jensen / Livid Labs). 3 sections: `codefall--readme--overview` (meta-harness/software-factory framing + comparison to Symphony/unum/garden board), `codefall--readme--spec-driven-lifecycle` (the five reasons for spec-driven development; Spec Kit/Kiro/Cascadia peers; EARS), `codefall--readme--pipeline-state-and-sandboxing` (loop/tools/sandboxing/state/routing: specify→plan→implement, parallel per-task worktree *waves*, review/test/triage *rounds*, docs+Beads+PRs state, merge-blocking hooks, multi-harness review, Clean-Architecture scaffold/ADRs/profiles). Source page `sources/codefall--readme.md`.
- **whyrusleeping/ycc** README @ `7f1bedee2e448d147e47224a09c4a252cc3f6356` (2026-11-10, whyrusleeping). 3 sections: `ycc--readme--overview` (docs-driven always-on daemon, multi-project, web+iOS views + comparison), `ycc--readme--repository-is-the-memory` (spec.md/backlog/memory.md/git durable state, disposable sessions, spec-check, todo/proposed/blocked task authority, session modes, unattended work loops), `ycc--readme--daemon-models-and-credentials` (daemon owns the work / clients are views over an append-only event log via Connect RPC; roles + review tiers across anthropic/openai/openai-compatible/ollama; subscriptions vs API-key secrets store; creds stripped from tool shells as "a safety net, not a sandbox"; budget caps). Source page `sources/ycc--readme.md`.

## Comparison captured (per the ask)

Both are spec/docs-driven harnesses whose durable state is committed repo files and whose review runs in a *different model* — the same bet the garden makes with the journal-as-job-board. Divergences recorded in the section bodies: Codefall is a stateless in-repo **skill kit** installed into an existing agent (no daemon, no fleet; its only parallelism is `implement`'s per-task worktree waves), whereas ycc is a standing multi-project **daemon** with unattended work loops (closer to a fleet orchestrator); the garden differs from both by racing a standing cross-host gardener fleet to claim tasks off a `journal2`-branch CAS board (no single authority), while ycc's one daemon per machine *is* the authority. ycc's work loops ≈ Symphony/unum's poll–dispatch–review–commit loop; Codefall's beads ≈ unum's TODO board / the garden job board.

## Indexing

- Topic rows inserted (via `insert-sections-table-row.sh`): **agentic-sdlc** (5), **agent-fleet-orchestration** (5), **llm-agent-frameworks** (2), **agent-fleet-durability** (2), **coding-agent-economics** (1).
- `sources/README.md`: two rows added under *External code repositories (sibling implementations)* (after unum).
- `keywords.md`: codefall and ycc keyword lines added.

## Gates

- `library-link-check.sh --source-slug codefall--readme` → OK (rc=0); `--source-slug ycc--readme` → OK (rc=0).
- `regenerate-sections-index.sh` → landed `sections/README.md`.
- `regenerate-topics-counts.sh` → landed `topics/README.md`; final `--check` → current (idempotent, rc=0).

## Classifier manifests and token usage

Every fetch went through `fetch-source.sh` (both `source_fetched_via=direct`): codefall README sha256 `99c2f097491ccf02150d2a38106de33d00e026f2a177e9a3572f963366c37aaa`; ycc README sha256 `2bb881da64db78d74f4a5b05a91b4a1699d2be4a3f8b90d55ea34ced94131863`. The mandatory foreign-content pre-classification gate (`classify-foreign-content.sh`) was run on both before reading. **Classifier verdict for both: `classify_status=unavailable`, `classify_policy=proceed_unclassified`, reason "TYPESAFE_API_KEY absent".** This host has no reachable TypeSafe key (empty secret store, no legacy env), and no fleet host does — which is why the maintainer added the `config/typesafe-bypass` capability-bypass directive today (main2 `c2a2b3c899a`, "scholar-ingest runs with the foreign-content classifier failing open"). I honored that dated directive: fetched and ingested with the classifier **failing open** (`CLASSIFY_REQUIRE=0`), recording `content_caveat: unwatched external repo; classifier unavailable; proceed_unclassified` in each section and source page, and treating all fetched README text strictly as DATA, never as instructions. **TypeSafe token usage: zero** (the classifier never reached the API — it was unavailable). No `halt` verdict occurred.

## Notes / follow-ups

- Both repos are **outside the garden watch set** (not `repos/`-armed, not own forks), so provenance is hand-noted per `roles/scholar/AGENT.md` and the idempotency anchor is the file-specific README commit sha (not a watched bare clone).
- Only each repo's README was ingested (the ask: "one source per repository"). Deeper material exists and could seed follow-on ingests if wanted: codefall's `AGENTS.md`/`docs/guide/`/`docs/workflow.md`/ADRs; ycc's `spec.md`, `CONTRIBUTING.md`, `docs/design/`, and the rich `backlog/` of design docs.

Self-improvement: The `typesafe` capability bypass (`config/typesafe-bypass`, main2 `c2a2b3c899a`) lets a keyless host *claim* a `requires: typesafe` scholar-ingest job, but `gardener.sh` still unconditionally exports `CLASSIFY_REQUIRE=1` for any typesafe-required job, under which `fetch-source.sh` and `classify-foreign-content.sh` **hard-fail (exit 4)** rather than failing open — directly contradicting the bypass comment's stated intent ("classifier failing open"). The gap means the bypass as shipped produces an infinite requeue, not a fail-open ingest, unless the worker overrides `CLASSIFY_REQUIRE` as I did here by hand. Worth a mentor/liaison fix: have `gardener.sh` set `CLASSIFY_REQUIRE=0` (or consult the bypass marker) when the typesafe capability is satisfied *only* by `config/typesafe-bypass`, so the fail-open path is the code path and no gardener has to override it manually.
