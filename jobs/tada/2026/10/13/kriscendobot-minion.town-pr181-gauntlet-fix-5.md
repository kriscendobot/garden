## Fix round 5 report: kriscendobot/minion.town PR #181

A previous claimant of this job had already pushed the fix, so I checked it and ran the CI wait. I made no new commits. CI is green.

**Panel round 5 must-fix items** (the review of head `a95f956`, where 2 of 34 seats requested changes). Both are handled by commit `b7bd43c` (`docs(git-remote): address panel-5 must-fix items in the served-clip design`), which is the current PR head:
- **archivist:** The Status line in `designs/git-remote-served-clip.md` used to say "spec only, no live change". It now says the document is a proposed design for increment 4, and that its build, increment 5, is under review at #181. The increments list now marks 5 as "in review, #181". No "spec only" text is left in either design file.
- **decomplector:** I checked that § 4 of the design now has a "Why not projection on push alone" paragraph, and the PR body has a matching one-sentence rationale. The reason given is that a push event misses three things:
  - The operator script writes tombstones and purge requests from a separate process.
  - A projection that fails without a crash needs to be retried.
  - `destroy` needs a marker to see a push that is still in flight.

  The hourly full sweep catches drift that no event announces, such as a record someone deleted by hand.

**CI:** `ci-wait-merge.sh --no-merge` finished with rc 0. There was one Actions run on `b7bd43c` and it passed. The bot's token can't read the PR's combined check status (it gets a GraphQL "not accessible" error), so the script fell back to the Actions runs API. That means only Actions runs were checked; commit statuses and non-Actions checks weren't visible.

**Follow-ups:** None from this stage. The driver will post panel round 6.

<!-- gauntlet-stage-result: fix=done -->
