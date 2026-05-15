---
slot: 2
status: in-flight
design_path: designs/hardened-url-shim.md
pr_number: null
current_stage: builder
in_flight_dispatch: a232cc
last_update: 2026-05-15T04:09:00Z
started_at: 2026-05-15T04:09:00Z
host: endolinbot
---

Slot 2 refilled with fresh design `hardened-url-shim.md`. Sibling to
shipped PR #259 (text-codecs shim); both originate from
endojs/endo#2635. Design merged via #84; no current implementation PR
covers it (verified via `gh pr list --search`).

Walk verdict: start-here (no in-flight prereqs; both sibling designs
in the dep set are independent).

Implementation base: master.

Initial-PR-drafting cap check: free (slot 1 has cleaner, no initial-PR
builder in flight; the slot 3 builder for #259 completed earlier).

Dispatch root: `dispatches/builder--a232cc` (head ~`c2fc02eb8`).
