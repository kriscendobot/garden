All three review items are resolved. Writing my completion report.

---

**Completion report — fix `endojs/endo-but-for-bots` PR #682 (design/endo-reminder), resolving kriskowal's CHANGES_REQUESTED review**

**Context.** The three review items were prior-addressed in commit `92804323d3`, but the SturdyRef survey there cited a **stale** PR stack (#510/#511/#539/#521/#541) and reported both of the maintainer's delivery requirements as open, uncovered gaps. This job's core work was retargeting that survey onto the current in-flight **#695 + #697–#704** stack and re-assessing coverage.

**What I did**
1. **Persistence atomicity (item 1)** — verified already correct in the current doc: design decision 9 and the durable-tracking section state atomic replacement is **write-then-`move` within the store directory**, with within-directory `move` *required of the backing* and a direct `write`'s atomicity explicitly *not* relied upon. No change needed; previously acknowledged inline.
2. **Incarnation-on-start via `@pins` (item 2)** — verified already correct: design decision 10 and the wake-on-restart section state retention is **user-driven for now — the user follows the `@endo/reminder` README to place the service in `@pins`**, no integration owning it automatically yet. No change needed; previously acknowledged inline.
3. **`storeValue` + SturdyRef gating (item 3)** — the substantive fix. Rewrote the *Gating dependency: SturdyRef modelling* section and the Dependencies-table row:
   - Retargeted the table onto the current cluster: **#539** (enlivenment foundation), **#695** (agent provide/accept surface + guest token), **#697** with cuts **#698–#704** (cross-peer bridge; **#701** = daemon mint/export over a swiss-num store), on **#521/#541** substrate. Kept #510/#511 only in a "superseded" note.
   - Reframed both maintainer requirements as **covered at the design level**: (b) obtaining a SturdyRef for a durable value is met by #695's `makeRefToken` (shared, guest-reachable) / `makeSturdyRef` (host-only) / `storeRef` plus #697/#701's wire-tier mint; (a) passing a ref in place of a pet name for `send` is met by #695's **mail-verb accept admission** (`send`/`reply`/`resolve`) — precisely the write/send-side that read-side-only #541 left untouched.
   - Recorded the residual as **unmerged-draft**, not missing-design: Phase 4 lands once #695's cuts A/B merge (+ #701/#703 for cross-peer recipients); the **same-daemon** case needs only the #695 token tier. Noted the one still-open *modelling* question (#539 enlivened-presence lifetime).

**Changes landed**
- Commit `dd541915c5` on `design/endo-reminder`, pushed to `origin` (67 insertions, 33 deletions in `designs/endo-reminder.md`). Style sweeps clean; mermaid block untouched.
- Inline reply posted on kriskowal's SturdyRef review thread (`r3571821599`) with the updated survey (posted as `kriscendobot`, the only gh-tokened account on this host and the same account that authored the PR's prior maintainer-facing replies).

**Follow-ups for the maintainer**
- The Phase 4 `send`+`storeValue` upgrade gates on the #695 provide+mail-accept cuts merging (and, for cross-peer recipients, #697/#701/#703). Phases 1–3 and the Phase 2 subscriber-capability baseline remain ungated.
- The design is now ready for kriskowal's re-review; the CHANGES_REQUESTED review is not auto-dismissed (maintainer re-reviews).
