---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--7af4b5
ts: 2026-06-03T07:38:11Z
ref_id: 7af4b5
---

# Cycle 145 result — formula-inspector.md (pivot after duplicate-skip)

Cycle 145 of the librarian arc. Nominally papers-lane (cycle 144 was
comments-lane); papers-lane has been blocked for **39+ consecutive
cycles** due to lack of PDF-fetching infrastructure. Pivoted to
designs-lane.

## Source-slug duplicate-check catch

The initial designs-lane candidate was `gateway-bearer-token-auth.md`
— authoritative-looking, 157 lines, *Implemented* status, the auth
substrate referenced by cycles 126/139/143. Prepared the dispatch
worktree (liaison--7af4b5), fetched + read the full design content,
and drafted a 268-line section file under the slug
`endo-but-for-bots--llm-designs-gateway-bearer-token-auth--agent-id-as-bearer-token-with-URL-fragment-and-per-IP-rate-limiting`
+ committed (`64a8e949`).

While writing the source page, found the slug
`endo-but-for-bots--llm-designs-gateway-bearer-token-auth.md` already
present in `library/sources/` — **ingested 2026-05-14** with **3
sections** under slugs `endo-but-for-bots--llm-designs-gbta--*` (the
short-form slug version). The duplicate-check discipline at work.

Reset the section commit (`git reset --hard HEAD~1` back to
`3f1a04da`). Pivoted to `formula-inspector.md`.

## The pivot — formula-inspector.md

110-line *Not Started* status design by Kris Kowal *(prompted)*,
created 2026-02-14 / updated 2026-02-24. Surfaces the daemon's
26-formula-type structure to the user via a "popping-the-bonnet"
debug-tool sitting between daemon internals and chat UI.

Single most structurally interesting move: §load-bearing-metaphor
*popping the bonnet*. The §pet-name-hides-the-formula observation —
the chat UI shows only the *rendered value* of each capability; the
daemon storage holds a *richer formula structure* with 26 types and
fields (`worker`, `source`, `endowments`, `hub`, `path`). The
inspector surfaces the second layer to advanced users.

§26-formula-types-with-type-specific-metadata: six concrete shapes
listed (eval / lookup / guest / make-bundle / make-unconfined /
peer). The §`InspectorHub.lookup(petName)` API *already* returns this
metadata; the design's add is mostly UI. §`makePetStoreInspector`
reference at `packages/daemon/src/daemon.js` 3210-3319.

§Formula-references-as-clickable-links discipline: the
formula-graph-as-hypertext idiom + navigation-via-formula-identifiers
pattern lets the user *walk the formula graph node by node*.

§Edit-toggle-with-revise-API discipline: §read-only-default + opt-in
edit toggle. The new daemon method `E(agent).revise(petName, patch) →
revised-formula-identifier` validates formula invariants before
persisting (a `worker` field must reference a valid worker formula).

§Retention-path-reveal facility ties to cycle 49's
retention-path-notation cluster — *every retention path in the
formula graph for identified formulas*. §why-retention-paths-matter:
removing the last retention path GCs the formula; showing paths in
inspector tells the user *exactly which removals lose the
capability*.

§CLI-mirror (`endo inspect <name>` prints formula JSON);
§two-surfaces-one-API discipline. §Security-gated-edit (host-level +
audit trail); §inspection-vs-editing-security-asymmetry — inspection
visible to owner; editing host-level only. §Three-affected-packages
partition (daemon + chat + cli) with §thin-API-thick-UI principle.

§Not-Started-design-as-roadmap shape; §existing-API-leverage
observation (most data already available via InspectorHub.lookup →
additive implementation path). §Maybe-prefix-on-tests discipline.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-formula-inspector`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md`
- **Topics**: daemon, agent-conventions, tooling
- **Library totals**: 649 sections from 190 source documents
- **Lane rotation**: nominally papers-lane (39+ consecutive blocks);
  pivoted to designs-lane
- **Discipline tested**: source-slug duplicate-check (caught
  gateway-bearer-token-auth via the gbta-short-slug form)

## Self-improvement note

The duplicate-check discipline worked correctly this cycle. The slug
mismatch (gateway-bearer-token-auth vs gbta) means the short-form
slug convention from older cycles can mask the long-form match.
Consider standing discipline: when checking for duplicates, search
both the full source-path form *and* possible abbreviated forms (e.g.
acronyms of multi-word file names). For this cycle, listing the
source page filename only (cf. `gateway-bearer-token-auth.md` vs
`gbta`) gave a clean confirmation.

Cycle 145 closes. Schedule next wake 1500s for cycle 146.
