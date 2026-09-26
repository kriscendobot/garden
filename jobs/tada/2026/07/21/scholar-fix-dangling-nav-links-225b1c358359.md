Repaired all three dangling navigation links in the reference library.

**What was wrong.** `library/sources/tc39-module-harmony--compartments-compartment-class.md` carried a 5-row section table (`section_count: 5`). Two rows resolved; three pointed at slugs that were planned but never ingested (`compartment-import-evaluate-methods`, `compartment-resolve-load-hooks`, `compartment-thenable-hazard`). Meanwhile the source's actual ingest produced three real-but-unlisted sibling sections: `compartment-motivating-examples`, `compartment-virtual-modules`, `compartment-thenable-and-design`.

**What I did.**
- Confirmed the 3 dangling links and the real section inventory against `origin/journal2` (5 committed `...compartment-*` section files, 3 unreferenced).
- Repointed the three dangling nav rows to the three real sibling sections (thenable-hazard → thenable-and-design; the other two → virtual-modules and motivating-examples). `section_count: 5` stays accurate — the table now lists all five actual sections.
- Re-verified each new target exists at the current tip with `library-link-scan.sh --exists` before committing.
- Landed the whole-file edit through `land-journal-edit.sh` (isolated producer clone, CAS loop) — no live-worktree git.
- Re-ran `library-link-scan.sh`: **OK — every checked link resolves.**

**Changed:** `library/sources/tc39-module-harmony--compartments-compartment-class.md` on `journal2` (landed; tip now `c841e8ce2`).

**Follow-ups:** none. Scan is clean. No garden-repo (`main2`) changes were needed for this job.
