---
ts: 2026-05-14T11:29:26Z
kind: result
role: scholar
project: garden-library
---

# Thirty-third scholar cycle — topic-page refresh sweep

Dedicated consolidation cycle for the topic-page drift flagged across cycles 31 and 32 (tooling, bundles, ocapn, captp). Survey first identified the drift was much broader: 14 of 21 topic pages had drift, summing to ~234 missing rows across the library.

## Pre-sweep drift summary

| Topic | Listed | Claim | Diff |
|-------|--------|-------|------|
| ocapn | 22 | 60 | +38 |
| tooling | 11 | 41 | +30 |
| marshal | 16 | 43 | +27 |
| hardened-javascript | 51 | 77 | +26 |
| bundles | 2 | 24 | +22 |
| capability-security | 20 | 42 | +22 |
| captp | 20 | 35 | +15 |
| eventual-send | 25 | 38 | +13 |
| compartments | 10 | 22 | +12 |
| repository-governance | 22 | 34 | +12 |
| pass-style | 28 | 39 | +11 |
| errors | 15 | 18 | +3 |
| exo | 23 | 25 | +2 |
| daemon | 2 | 4 | +2 |
| patterns | 18 | 19 | +1 |
| **7 others** | various | (no drift) | 0 |

Total drift: ~234 rows across 14 pages.

## Sweep procedure

Generator-driven, not by-hand. Two small bash scripts (`/tmp/gen-topic.sh` + `/tmp/refresh-topic.sh`):

- `gen-topic.sh <topic>`: greps all section files in `journal/library/sections/` whose frontmatter `topics:` field includes the topic, extracts title + source_repo + source path + abstract first sentence, emits one table row per section sorted by slug. Adds a `[superseded]` / `[stale]` / `[conflicted]` tag for non-`current` sections.
- `refresh-topic.sh <topic>`: rewrites the `## Sections` block in `journal/library/topics/<topic>.md` with the generator's output. Preserves the page's leading Abstract, any `## Superseded sections` subsection, and the `## See also` block by toggling awk-replacement only between `## Sections` and the next `## See also` / `## Superseded sections` line.

Ran on all 14 drifty topics in one batch. Post-sweep verification: drift = 0 on every page.

## Per-topic counts after refresh

All 14 topics' listed-rows now match their claim-count. Updated `topics/README.md` to reflect:

| Topic | Updated count |
|-------|---------------|
| repository-governance | 33 → 34 |
| hardened-javascript | 76 → 77 |
| compartments | 19 → 22 |
| marshal | 28 → 43 |
| pass-style | 40 → 39 (was overcounted) |
| patterns | 18 → 19 |
| bundles | 25 → 24 (was overcounted) |

The other 7 in the sweep had `topics/README.md` counts already in sync.

## Hardened-javascript Superseded subsection preserved

The generator initially included the 4 cycle-30-superseded sections in the main `## Sections` table (because they still claim the topic). After the sweep I manually deduplicated: the 4 superseded sections now appear *only* in the `## Superseded sections` subsection of the page, restoring the cycle-30 consolidation work. The page's main Sections row count is 73; the `topics/README.md` count is the corpus-level 77 (superseded sections are still in the corpus, just demoted in page placement).

## Consolidation/cross-reference contribution (cluster review bullet 3)

Added `notes:` cross-reference to `endo--docs-message-passing--digital-purse-example` pointing at the four component-package overviews (exo, patterns, marshal, eventual-send). A reader navigating from any component package's overview to the canonical worked example now has the round trip.

## Self-improvement (procedural)

The generator pattern made the sweep mechanical and cheap. A few notes for the next time:

1. **Auto-abstracts are good enough** for most rows. The hand-curated abstracts that already existed were sometimes pithier but the auto-extracted first-sentence is consistent across the corpus, which has its own readability benefit.
2. **Topic pages with custom subsections** (the cycle-30 `## Superseded sections` on hardened-javascript) need manual deduplication after the sweep: the generator naively includes superseded sections in the main table; they should appear only in their dedicated subsection. The cleanest fix would be to extend the generator to skip `status: superseded` sections only when the target page has a `## Superseded sections` subsection. Deferred — currently only hardened-javascript has this.
3. **`topics/README.md` counts drifted independently** of topic-page row counts. Multiple cycles bumped the count without bumping the topic-page table; future cycles should consult the live grep-based count rather than the topics/README number when adding rows.
4. **Generator scripts in /tmp don't persist.** They are simple enough to recreate from this entry (search for `gen-topic.sh` / `refresh-topic.sh`); if topic-page refresh becomes a recurring task, the gardener should consider promoting them to a `skills/library-topic-refresh/` skill so they live in version control.

## Library state

- **313 sections** from **64 source documents** across **3 repos**. No new section files this cycle.
- 14 topic pages refreshed; all topic-page drift now resolved.

## Inbox state

Empty. Next cycle is idle-mode. Backlog candidates:
- More agoric-sdk material (the packages/ corpus is large; 47+ READMEs in there).
- endo-but-for-bots .changeset/*.md files.
- Cluster A consolidation (lockdown options across the three abstraction levels — now under scholar discretion).
- Remaining cluster review cross-reference bullets (bullet 4: the four eventual-send integration sections).
