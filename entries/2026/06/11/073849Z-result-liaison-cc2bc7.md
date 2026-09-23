---
ts: 2026-06-11T07:38:49Z
kind: result
role: liaison
dispatch: cc2bc7
host: endolin
model: opus-4-7-1m
---

# librarian cycle 299 — designs-lane — `kriskowal/garden/CLAUDE.md`

Cycle 299 (designs-lane after cycle 298 chat-lane garden scripts pair). One source ingested: `kriskowal/garden/CLAUDE.md` (146 lines; the current live version). **The fourth garden source ingested**. **§four-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299). **§four-named-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source + project-instructions).

## Library state

- 811 sections (up from 810 at cycle 298).
- 349 source documents (up from 348).
- §one-hundred-and-thirty-second consecutive designs-chat alternation cycles 166-250 + 252-299 (251 was out-of-band).

## Files written

- `library/sections/garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory.md` (new section file; 146-line document in full scope).
- `library/sources/garden--CLAUDE-md.md` (new source page).
- `library/sections/README.md` (Total bumped 810 → 811; sources 348 → 349; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 62 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-298` → `pending-cycle-299`).

## First-explicit-observations (sixty-two)

Major: §the-named-project-instructions-shape (Claude Code auto-loads `CLAUDE.md`; the-named-naming-convention-IS-the-named-discipline-against-auto-load) + §the-named-snapshot-vs-live-CLAUDE-md (May 2026 snapshot was 97 lines; current live IS 146 lines; named-organic-growth-of-project-instructions) + §the-named-vocabulary-table (eleven named direct-dispatch verbs; the-named-shorthand-vocabulary-table-IS-the-named-DSL-for-orchestrator-instructions; the-named-`#N`-IS-the-PR-number-convention) + §the-named-two-channel-message-bus (per-role-inbox + job-board; the-named-git-push-as-the-serialization-point; the-named-git-as-the-coordination-primitive) + §the-named-job-board-claim-race (named-back-off-without-retry; the-named-`/clear`-survival-property) + §the-named-Boatman-host-preconditions (kriskowal credentials only on kmkmbp2021; named second-line-of-defense; named-deliberate-credential-isolation) + §the-named-monitoring-safety-constraint (named-prompt-injection-as-named-cross-cutting-hazard; named-LLM-context-as-named-attack-surface; named-explicit-allowlist; two-named-surveillance-surfaces) + §the-named-current-inventory-shape (the file IS its own self-index; named-versioned-role-set narrated in prose; named-twenty-nine-roles-plus-75-skills) + §the-named-jury-seat-roles-are-NOT-orchestrator-dispatchable + §the-named-references-shelf (named-browse-on-demand-discipline) + §the-named-monitor-garden-IS-the-named-asymmetric-monitor (dispatches `liaison` instead of `monitor`; named-self-reflexive-shape) + §the-named-two-route-work-distribution (job-board-claim 2026-05-18 default + direct-dispatch-via-Agent) + §the-named-model-selection-IS-a-named-skill (named-canonical-choice-IS-a-named-anti-drift-mechanism).

## Multi-cycle pattern recognition

- **§four-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md + 298 scripts pair + 299 CLAUDE.md).
- **§four-named-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source + project-instructions).
- **§three-cycles-with-named-role-as-author-shape** — cycle 281 multi-author + cycle 297 single-author + cycle 299 multi-author (gardener + liaison + builder).
- **§two-named-instances-of-leveraging-git-as-coordination** — cycle 297 (detached-HEAD eliminates branch-singleton-contention) + cycle 299 (git-push as serialization point for job-board claim race).

## Synthesis target

Slot machine library `@game/CLAUDE.md`: YAML frontmatter with multi-role authors; named-project-instructions shape (auto-loaded by Claude Code at the project root); named-vocabulary-table with direct-dispatch verbs ("spin", "settle", "payout", "rollback") as a named DSL; named-two-channel message bus (per-table inbox + global tournament job-board with git-push-as-serialization); named-host-precondition for upstream-credential operations; named-monitoring-safety-constraint naming prompt-injection as the threat-model; named-allowlist of safe-to-monitor game-tables; named-current-inventory as named-self-index; named-references-shelf for borrowed game-engine patterns; named-asymmetric-role-dispatch for meta-monitoring; named-two-route-work-distribution; named-model-tier-selection via named-skill.

## Single most structurally interesting move

**§the-named-two-channel-message-bus** combined with **§the-named-git-push-as-the-serialization-point** — the journal acts as the named *message bus* between agents, with two named channels: a per-role inbox (directed) and a job board (broadcast-with-race). The race-to-claim resolves via the remote's `git push origin journal` ordering, not via an explicit lock or queue server. **§the-named-git-as-the-coordination-primitive**.

This extends cycle 297's **§the-named-detached-HEAD-eliminates-the-branch-singleton-contention** to a broader pattern: the garden uses git's built-in primitives (atomic ref updates, push-rejection-on-non-fast-forward) for *all* its concurrency control. There IS no Redis, no PostgreSQL, no Kafka, no message-queue service. **§the-named-coordination-via-git-only-discipline**.

The pattern generalizes to any orchestration system that already has a shared git repo: free coordination primitive via the remote. Push success IS atomic; push rejection IS the "back-off" signal; the journal branch IS the durable record. §two-named-instances-of-leveraging-git-as-coordination across cycles (297 + 299).

§the-named-no-additional-infrastructure-required-discipline: the garden runs on bash + git + Claude Code. The two-channel message bus runs on the same git infrastructure that holds the journal. §the-named-zero-dependency-coordination.

## Next cycle

Cycle 300 — chat-lane next. **MILESTONE 300 cycles**.
