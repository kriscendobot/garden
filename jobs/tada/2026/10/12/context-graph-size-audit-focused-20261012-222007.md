The October focused context-graph size audit is on `journal2` as a new dated report: `journal/reports/context-graph-size-audit-focused-2026-10-12.md`. Earlier reports were left untouched.

I ran `scripts/context-graph-size-audit.py` with `--exclude-root-glob 'designs/*.md'` and `--exclude-journal-seed 'projects/README.md'` against main2 `0411ed9fbd12` and journal2 `75f5daae480d`, then landed it with `land-journal-edit.sh` (`GARDEN_EDITABLE_TREES=reports`).

**Results:** 9,431 documents walked, 338 reorganization candidates. The previous run (2026-09-12) had 8,546 documents and 311 candidates.

| Area | Docs (Sep 12 → Oct 12) | Candidates (Sep 12 → Oct 12) |
| --- | --- | --- |
| main2 library | 239 → 272 | 38 → 51 |
| journal2 `library/` | 8,304 → 9,149 | 271 → 279 |
| journal2 `priorities-archive/` (new this run) | — → 6 | — → 5 |
| journal2 root | 1 → 2 | 1 → 2 |
| journal2 `projects/` | 2 → 2 | 1 → 1 |

Unreachable ("orphan") documents went from 37 to 46 on main2 and from 197 to 198 in the journal library.

**Largest-15, main2:** the list grew in the month. The main signal is that hand-written roles and skills are growing, more than new big files appearing:
- **New at the top:** `context/operations/systemd-units.md` (737 lines / 47 KB) jumped straight to #1 and is close to the very-large size threshold.
- **Grew:**
  - `skills/local-verify/SKILL.md`: 535 → 613 lines (now very large)
  - `roles/liaison/AGENT.md`: 428 → 500
  - `README.md`: 421 → 498
  - `skills/frozen-base-branch/SKILL.md`: 346 → 444
  - `skills/job-board/SKILL.md`: 329 → 398
  - `skills/pr-creation-flow/SKILL.md`: 389 → 405
- **Entered the list:** `roles/COMMON.md` (351) and `skills/caplet-validation/SKILL.md` (345).
- **Dropped off the list:** `CLAUDE.md`, `skills/design-dependency-walk/SKILL.md` and `skills/at-mention-surveillance/SKILL.md`.

**Largest-15, journal `library/`:**
- `sources/README.md`: 1,148 → 1,305 lines.
- `topics/capability-security.md`: 403 → 614 lines (now very large).
- New entries: `topics/cap-talk-open-questions.md` (427), `sources/cap-talk-2009-2012.md` (362) and `topics/agentic-sdlc.md` (345). They come from recent cap-talk and agentic-SDLC additions to the library.

**Follow-ups:**
- The two files that are now very large (`skills/local-verify/SKILL.md` and `context/operations/systemd-units.md`) are the best candidates for a split.
- 13 more main2 candidates and 9 more main2 orphans in a month suggest a cleanup job (for example, a librarian job on main2 roles, skills and context) may be worth posting. I haven't posted one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/context-graph-size-audit-focused-20261012-222007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (410439 cached reads)
- Output: 3038 tokens
- Cost: $0.5424718000000001
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
