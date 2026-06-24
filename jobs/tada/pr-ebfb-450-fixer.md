I've completed my investigation. Here is my report.

---

## Completion report — job `pr-ebfb-450-fixer` (endojs/endo-but-for-bots#450)

**Outcome: no fix needed — re-triage false positive. The substance was fully addressed six days ago; the PR is stuck only on a missing review re-request that cannot be issued correctly from this host.**

### What I found
PR #450 (`designs: Add presence-severance-observation`, branch `design/presence-severance-observation`) shows `reviewDecision: CHANGES_REQUESTED`, which is what the 2026-06-24 triage keyed on. But that status is stale:

- kriskowal's CHANGES_REQUESTED review (2026-06-17, id 4519898190) carried **5 inline asks**, all on the design doc:
  1. severance/partition are synonymous
  2. reconnect-as-fresh-snapshot posture is correct
  3. forgetting severed presences is out of scope (a GC feature)
  4. debouncing belongs in the transport layer (session continuity)
  5. returning a promise is sufficient for cleanup ownership
- **All 5 were addressed in commit `994c1a86b` (2026-06-18)**, with a reply posted on each of the 5 threads, and the PR re-marked `ready_for_review`.
- An **R2 design panel ran clean** the same day: verdict `comment`, **0 must-fix**, 4 follow-ups explicitly parked for the future *implementation* PR (error-reason shape, three-sub-case test vectors, permission-revoked routing, already-severed behavior) — none are in-scope for this design PR.
- CI is green (5 design checks). Head SHA `994c1a86b`; no commits since 2026-06-18.

### What I verified
I fetched the design doc at head and confirmed the fix actually landed (not just claimed in replies): the "Session continuity across physical connections" rewrite (L195), the GC out-of-scope note (L194), "Returning a promise is sufficient" + holder-responsibility (L201–202), and the Open-questions resolution with the librarian-alias note (L186–191) are all present.

### Why the PR is stuck
After the 2026-06-18 fix, **kriskowal was never re-requested as reviewer** (`requested_reviewers` is empty). GitHub therefore keeps the decision at CHANGES_REQUESTED and the PR falls out of kriskowal's pending-review queue. That re-request is the only remaining action.

### What I changed
**Nothing.** There is no unaddressed feedback to carry into the doc, and no thread reply to post — the prior fixer already did both.

### Blocker (why I did not post the re-request myself)
On this host (`endolinbot`), `gh` is authenticated as **kriskowal** (verified: `gh api user` → `kriskowal`), while the PR author is **kriscendobot**. Issuing the re-request here would act as the maintainer re-requesting their own review under the maintainer's identity, breaking the bot/maintainer separation. The same boundary that stops a boatman on the wrong host applies: I will not emit fixer artifacts under kriskowal's credentials.

### Recommended follow-ups
1. **Unstick the PR**: re-request kriskowal's review as the bot author (`echo '{"reviewers":["kriskowal"]}' | gh api repos/endojs/endo-but-for-bots/pulls/450/requested_reviewers --input -`) from the **kriscendobot-credentialed host**. Alternatively, kriskowal (present at this terminal) can simply re-review #450 directly — it is ready and clean.
2. **Triage guard**: a re-triage that sees CHANGES_REQUESTED should compare the latest maintainer review's timestamp against subsequent commits + thread replies before posting a fixer job; here the asks predated the fix by ~11 hours.
3. **Prior-fixer gap**: the 2026-06-18 fixer addressed everything and replied but skipped the re-request — that omission is what left the PR stranded for six days.

**Self-improvement:** worth a feedback memory — a lingering CHANGES_REQUESTED on a PR whose head post-dates the review with replies on every thread usually means "awaiting re-request," not "needs a fixer"; check `requested_reviewers` and commit-vs-review timestamps before dispatching fixer work.
