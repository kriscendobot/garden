Panel round 1 on endojs/endo-but-for-bots#1298 came back **must-fix**, and the verdict is posted on the PR.

**What I ran**
- Got a separate checkout of the PR head, `kriscendobot/endo-but-for-bots` branch `ironhorse-fuzz-findings` at `a0b1f49d5`, in `scratch/project-wt-endojs--f4f6fb71f1dd-0f359a6d`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1298 387ea66146a0…`. I gave it the base commit's exact sha (`llm-387ea66`) so it reviewed only the PR's own diff: 94 files, +5416/−22.
- It exited 0 with the terminal line `code-panel single-round — must-fix`. All 30 seats finished.

**Seat results**
- **20 approve.**
- **6 comment-only:** typist, migrator, spec-keeper, duality-auditor, corner-prober, fast-checker. Scribe and coverage-auditor were also comment-only (8 in total).
- **4 request-changes:** archivist, purist, integrator, thesaurus.

**Main findings**
- **Must-fix (integrator):** commit `fdb9fef6e` changes how the XS oracle compares Number results. The PR's description has to name that behavior change.
- **Should-fix:**
  - The regexp generator is copied into 10–15 `finding_*_regexp_*.rs` test files.
  - Fixture names mix `-input.bin` and `.input.bin`.
  - Some programs are locked as regressions more than once.
  - Three rustfmt fixup commits should be folded.
  - Archivist says the tuple field order in `comparison.rs` is poorly documented.
  - Typist found `…` characters in comments that should be ASCII `...`.
  - Thesaurus requested changes on wording.

**How the review was posted**
- It's a COMMENTED review from kriscendobot at 2026-09-27T10:50:08Z, not "request changes". GitHub refuses a request-changes review on the bot's own PR, as on earlier own-PR panels.
- The full aggregate is 81KB, over GitHub's 65,536-character limit for a review. The review has a header with the disposition and seat tally, every non-approve seat's section in full, and the approving seats listed by name only. That comes to about 36.6KB.

**Follow-ups**
- The next fix stage should read the must-fix and should-fix items from that COMMENTED review. There is no request-changes review to find.
- `inbox-read.sh` couldn't clone the journal (GitHub disconnected), so I couldn't check the inbox. Nothing arrived that affects this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 34 tokens (913949 cached reads)
- Output: 5257 tokens
- Cost: $0.7414418
- Wall-clock: 605s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
