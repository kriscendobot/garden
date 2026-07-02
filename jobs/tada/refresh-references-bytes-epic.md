The refresh landed on `origin/journal2` and the inbox is empty. Job complete.

---

**Completion report — refresh `references/bytes-epic.md`**

Reconciled the Bytes-epic maintainer reference against authoritative `gh` state (read-only enumeration on `endojs/endo-but-for-bots`, plus the `kriscendobot/agoric-sdk` fork). Landed on `journal2` via `land-journal-edit.sh` (isolated producer clone + CAS loop; added `references` to `GARDEN_EDITABLE_TREES` for this land since the default allowlist is `library projects`).

**PRs moved to correct sections:**
- `#57`, `#429` → **Closed/superseded** (both were listed as open in-flight; withdrawn 2026-06-30 per erights' view-based pivot; upstream endojs/endo#3226 closed same day).
- `#430` → **Closed/superseded** (was open in-flight; closed 2026-06-30).
- Merged set (`#473 #468 #449 #435 #451 #140`) and closed set (`#417 #56 #27`) re-verified — all already correct, retained.

**Added since the last refresh (2026-06-25):**
- **#572** — the byteArray-view design of record; recorded its disposition (withdraw #57/#429/endo#3226, restrictive whole-buffer span with sub-view relaxation tracked at issue **#573**) and that it is now Ready for review.
- **#475** — flagged as *the fresh view-based implementation PR* Design Decision 6 calls for (seeded from `feat/narrow-bytearray-to-uint8`, stacked on merged #473).
- **#586** — new exhaustive `byteOffset`+`length` boundary tests (lands tests parked in #472).
- New **@endo/hex codec thread** section: benchmark **#580** (platform/size/speed/approach table; draft; leaves `@endo/hex@1.1.1` untouched) and downstream **kriscendobot/agoric-sdk#7** (XS-safe hex table; slims `@agoric/internal` to re-export `@endo/hex`).

**Stack order rewritten:** the obsolete "#57 → on #475" bare-buffer stack removed; now documents #473(merged)→#475 as the live view-based implementation, #572 as design of record, #503 as the separate upstream-ready reconstruction, and #472→#586. Header note updated to record the 2026-06-30 data-model pivot. Existing maintainer-reference format (sections + one-line PR links) preserved.

**Follow-ups:** none blocking. Upstream ferry order across the open PRs still needs explicit maintainer confirmation (noted in the file); #580 and #475 are Ready-for-review/draft states the maintainer may want to action.
