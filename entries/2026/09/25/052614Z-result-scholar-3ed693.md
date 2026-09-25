---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-25T05:26:16Z
---
# result: scholar-ingest-kaozkit-xs-agents-20260925

Job `scholar-ingest-kaozkit-xs-agents-20260925` (maintainer ask 2026-09-25): ingest the two KaozKit articles and cross-reference them with garden work.

## Ingested (both fetched live, direct; idempotency anchor = content SHA-256)
- `web--haruni-kaozkit-xs-agents` (Sébastien Burel, 2026-08; sha256 447e83ea…): 6 sections — overview, an-agent-is-a-module, why-xs-not-javascriptcore, what-the-snapshot-changes-in-practice, the-layers, licensing-and-whats-next.
- `web--moddable-kaozkit` (Peter Hoddie, 2026-09-15; sha256 0ab237b1…): 4 sections — introducing-kaozkit, xs-for-agents, agents-on-ice, dig-deeper-and-lesson-14.
- Each source page carries an agree/differ comparison with its companion.

## Library pages touched
- New topic `topics/xs-agent-runtimes.md` (10 rows, with § Agreement and divergence and § Garden cross-references ranked).
- New concept `concepts/xs-heap-snapshot-agent-persistence.md`.
- Rows added to topics llm-agent-frameworks, persistence, capability-security, hardened-javascript, scheduled-agent-tasks, capability-mediated-integrations; concepts principle-of-least-authority, ambient-authority, formula-persistence-thesis.
- Indexes: sources/README (2 rows), topics/README (1 row), concepts/README (1 row), keywords.md (2 lines).
- Integrity gate: library-link-check --changed OK; per-source link checks OK. sections/README.md and topics/README.md counts regenerated and landed.

## Cross-reference findings (ranked)
1. endo-but-for-bots XS-worker snapshot design: the same mechanism, but more rigorous (suspend-only-when-idle, CAS streaming, append-only host-callback table, named incompatibility axes); KaozKit leaves in-flight host calls and version skew informal. The metering design covers runaway-agent budgets, which KaozKit does not mention.
2. minion.town Claude/Codex confinement (#87 closed; #106, #115, #116 open drafts): KaozKit's "keys resolved host-side, never in JS" plus a no-default-services allow-list host is the positive form of #106 Gap 1 (API key in an env file) and #116 Gap 1 (deny-list CLI confinement). KaozKit is weaker than Endo on delegation: one `host` global per agent and tools named by string, so an agent cannot attenuate or pass narrower authority (compare guest invite/accept, ebfb#1125).
3. XS as oracle/target: Iron Horse XS divergences (fx_dtoa and similar) are correctness issues, not escapes, so they do not refute Hoddie's "no known vulnerabilities" claim; `test:xs` is still `exit 0` in exo-stream, and the #1100 follow-up needs a Moddable `xst`. KaozKit's symlinked Moddable checkout is one more sign that a pinned checkout is the practical XS dependency.
4. Burel's synchronous-handler actor invariant restates E turn discipline.
5. Heap-resident schedules versus the garden's journal-backed durability: these suit different scopes and do not contradict each other.

## Suggested follow-ups (for the maintainer; none posted)
- Provision a pinned Moddable `xst` in the sandbox, which unblocks the real `test:xs` run for #1100.
- For minion.town inference backends: adopt the "the agent holds an llm capability, never a key" shape plus an allow-list host as the design answer to #106 Gap 1 and #116 Gap 1.
- Optionally ask Burel or Moddable how KaozKit handles snapshots taken during an in-flight host call and across app updates. This is a read-only question; the garden should not initiate contact.

No follow-on scholar jobs posted: both sources were ingested completely.
