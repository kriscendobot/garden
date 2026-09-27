Retro on kriscendobot/minion.town#69 (review 5119837026): **not a review miss.** I recorded it as a dismissal. No cluster was created, so nothing was checked against the dispatch threshold and no improvement job was posted.

**What I checked (in the world, not from the primary report)**
- **Idempotency:** no record existed for `kriscendobot-minion.town-pr69-review-f7e1d07a`. The only existing #69 record is a different review (6989f40d).
- **The feedback:** the review ("rsvp") carries one inline comment on `src/endo/gateway/daemon-site-registry.ts`. The maintainer said the `identify` / `storeIdentifier` methods on Guest agent facets will be retired, that the code should use the name already in scope rather than an intermediate formula id, and asked for a sweep of the change for similar spots.
- **Review history:** no gauntlet or panel job for #69 exists in `jobs/tada/`. Under the manual-gauntlet-trigger regime none was due.
- **Standing rules:** searching `roles/`, `skills/` and `context/` finds no rule about avoiding formula identifiers across the Guest boundary, and nothing marking those two methods as deprecated.
- **Primary deliverable exists:** commit ddb13cba ("fix(gateway): copy guest powers by name (#69)") removes the intermediate power formula id and its guest round trip, and #69 has since merged. This was not a false no-op.

**Why it was dismissed**
- This is a new, forward-looking Endo API direction ("we will need to retire"), first stated in this review. The pinned daemon still exposes both methods, so no panel seat could have flagged their use.
- It doesn't fit the existing `prefer-endo-primitives` or `capability-hardening-attenuation` clusters.
- No panel was due on this PR.

**Recorded:** `review-misses/dismissed/kriscendobot-minion.town-pr69-review-f7e1d07a.md`, written by `review-miss-record.sh`. It lost one push race, then succeeded on retry. The body is my own paraphrase plus the review URL.

**Follow-ups**
- **Possible pattern to watch:** this is the second Endo-naming-flavoured ask on minion.town#69, after the pet-name question in 6989f40d. Both are on one PR, so they are below the two-PR floor for a cluster. If "use a name instead of a formula identifier across agent facets" comes up on another PR, the record suggests creating a `names-over-formula-identifiers` cluster, with a line in the purist/locksmith juror brief and a panel-hints probe that fires on `identify(` / `storeIdentifier(` in diffs.
- **Small inconsistency on the PR thread (not a review miss):** two of the bot's later sweep replies disagree. One says the retirement was "declined for now"; the next says the power round trip was removed.
- No garden code changed, so nothing was committed to main2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr69-review-f7e1d07a-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 14 tokens (370270 cached reads)
- Output: 3976 tokens
- Cost: $0.594166 (2 engagement(s) unpriced)
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
