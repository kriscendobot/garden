I did not restage the ferry for endojs/endo-but-for-bots#1349. One review item that this job required to be closed is still open. The maintainer has the details and the options.

**What I found:**
- **Gauntlet:** `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e` is complete (`gauntlet-status: complete`). Panel round 2 passed at head `1e19cde89b`, which is still the PR's current head. CI is green there, 15 of 15 checks.
- **Panel review 5677937470 at that head:** the integrator seat still has an open **must-fix**. #1349 carries the XS lockdown-compartment commits that endojs/endo-but-for-bots#1425 also makes. #1425 is still an open draft with no review. The integrator wants that overlap reconciled, or #1349 put back into draft behind #1425. Fix-1 rewrote the PR body to say "Overlaps: #1425; whichever lands second drops the duplicate", but the integrator still flags it.
- **The other integrator item is fixed:** the PR body no longer says `ci.yml` changes.
- **Also open, but not blocking:**
  - The changeset-auditor requested changes: the sentences in `.changeset/ses-xs-lockdown-compartment-intrinsics.md` should each sit on one line.
  - Should-fix items: squash the leftover fixup commits and split the CI changes into their own PR.

**What I did:**
- Made no changes to the ferry directive, the journal, the PR or the garden repo.
- The directive `jobs/ferry/endojs-endo-but-for-bots-pr1349.md` still pins `b122ff91ef`. Its own precondition makes the boatman stop if `scripts/ferry.sh` is run now, because the head has moved.
- Did not post a PR comment, since nothing was restaged.
- Messaged the maintainer through `message-user.sh` (msg `…-018bed2a350d`) with three options:
  - (a) accept the overlap and ask for the ferry to be restaged at `1e19cde8`;
  - (b) drop the XS commits from #1349 so #1425 owns them, then run the gauntlet again;
  - (c) land #1425 first, then weave #1349.

**Follow-up:** this needs the maintainer's decision. If they choose (a), the restage is a short job: pin `downstream_head: 1e19cde89b2810be097cf4bd8839ec4d7d43905f` and refresh the preconditions and provenance sections.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-ferry-restage-20261028.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (868914 cached reads)
- Output: 5940 tokens
- Cost: $0.8307428
- Wall-clock: 101s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
