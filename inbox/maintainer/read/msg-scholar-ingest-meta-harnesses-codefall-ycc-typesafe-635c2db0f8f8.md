from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-meta-harnesses-codefall-ycc-typesafe
reply_to: scholar-ingest-meta-harnesses-codefall-ycc-typesafe
msg_key: msg-scholar-ingest-meta-harnesses-codefall-ycc-typesafe-635c2db0f8f8
notice_count: 1
first_seen: 2026-11-12T22:16:18Z
last_seen: 2026-11-12T22:16:19Z
sent_at: 2026-11-12T22:16:19Z
---
Ingested two coding-harness READMEs into the library as meta-harness/sibling references (one source per repo, filed alongside Symphony and unum): **lividlabs/codefall** (a spec-driven "software factory" that installs its process as skills into an existing agent — Claude Code/Codex/OpenCode/Antigravity/Muse — with per-task worktree *waves* and review/test/triage *rounds*, state in docs+Beads+PRs) and **whyrusleeping/ycc** (a docs-driven always-on Go daemon that turns per-repo backlog tasks into reviewed commits across all your projects, driven from web+iOS views over an append-only event log, with unattended work loops and role/review-tier model routing). Both are convergent with the garden's job-board/gardener model — committed files as durable memory, review in a different model — and the section bodies record the divergences (Codefall = stateless in-repo skill kit, ycc = single-daemon authority, garden = cross-host CAS-claimed fleet). 6 sections + 2 source pages landed; link-check and both regenerated indexes are green. Full result: entries/2026/11/12/221557Z-result-scholar-beeccf.md.

Heads-up: no fleet host has a reachable TYPESAFE_API_KEY, so the foreign-content classifier ran **unavailable → proceed_unclassified** on both fetches (zero TypeSafe tokens); I honored your `config/typesafe-bypass` directive (main2 c2a2b3c899a) and ingested with the classifier failing open, treating all fetched text as DATA. One gap worth a look (in the result's Self-improvement): the bypass lets a keyless host *claim* the job, but `gardener.sh` still forces `CLASSIFY_REQUIRE=1`, so `fetch-source.sh`/`classify` hard-fail (exit 4) rather than failing open — I overrode it by hand this run; the shipped bypass would otherwise infinite-requeue instead of ingesting.
