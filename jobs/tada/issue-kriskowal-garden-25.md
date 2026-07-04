Job done. Report follows.

---

## Completion report — `issue-kriskowal-garden-25`

**Task:** Research SheetSync (Google Sheets ↔ banks via Plaid), and report on issue kriskowal/garden#25 how the same result could be accomplished in Endo with a plugin and ocaps.

**What I did**
- Researched SheetSync and its peers (BankToSheets, SheetLink, BankSync) and Plaid's Link → `public_token` exchange → read-only `access_token` (Item) → `/transactions/sync` flow, via WebSearch/WebFetch.
- Wrote a complete, cited reply that (1) explains what SheetSync is and where its two bearer secrets (Plaid `access_token`, Google OAuth token) live; (2) maps it onto Endo as **two small trusted connector caplets** (Plaid, Google Sheets) that mint **attenuated object-capability facets** — a read-only `item` and a single-sheet `sheet` writer — handed to a **confined SheetSync guest caplet** (the "plugin") endowed with only those facets plus a clock, zero ambient authority; (3) covers powerbox/petname granting, local instant revocation, daemon persistence, and webhooks-as-callback-capabilities; (4) gives an object-graph sketch and honest caveats (network endowment + connectors must still be built; Plaid Link needs a web view). Cross-referenced the garden's `oauth-use-case-patterns` skill for the Google connector.
- Draft saved at `issue-25-comment.md` in the job worktree.

**Delivery — important**
- I could **not** post the comment to GitHub myself. This job executed on the raw host `endolin` (no `/.dockerenv`; `GARDEN=endolinbot2`), where there is **no real `gh` binary** behind the fleet `gh` wrapper (`exit 127`), and the live journal worktree is broken (points at `/home/kris/.git`). So the GitHub API is unreachable from here.
- Instead I handed the **verbatim, ready-to-post comment** to the maintainer inbox via `message-user.sh` (CAS-accepted push; independently confirmed at `inbox/maintainer/unread/20260704T164740Z-fa5477.md` on `origin/journal2`), with instructions to post it as kriscendobot on issue #25 and **not** to close it.
- The issue itself is therefore **not yet commented** — it is queued for the liaison/maintainer to post. I did not close the issue (correct per issue-inbox etiquette).

**Follow-ups**
- **Environment defect (flagged in the handoff):** gardener 15 on `endolinbot2` is running outside the container on host `endolin` with no `gh` and a broken journal worktree; any issue/PR/ferry job claimed there will hit the same wall. Worth fixing before more GitHub-facing jobs land on it.
- **Library ingestion not run:** the issue mentioned "ingest articles." I did not run the scholar library pipeline (`land-journal-edit`, producer clones) because the journal worktree on this host is broken. Recommended clean next step: a `scholar-ingest-source` job over the Plaid Transactions/Link docs + Endo caplet/powerbox docs. Noted in the comment itself.

Nothing was committed to `main2` (this was research + a message-bus handoff, no garden-library code change). No project worktree was created.
