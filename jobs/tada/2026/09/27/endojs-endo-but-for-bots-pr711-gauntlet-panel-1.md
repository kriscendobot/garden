I ran round 1 of the panel on PR #711 ("design(daemon): netstring to cbor-frame migration"). The verdict is **must-fix**, and the review is posted on the PR. I didn't fix or un-draft anything, as this stage requires.

**What I did**
- Checked out the PR head (branch `design/daemon-cbor-frame-migration` at `554a2427ac`, in endojs/endo-but-for-bots) into an isolated worktree for this job, `/home/kris/garden/scratch/project-wt-endojs--6a1f16d97b89-8f4132c1`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against it. I passed the real base SHA `cc41f42e243d` (the tip of `llm`) rather than the branch name. panel.sh exited 0 and chose the design panel; all 9 seats returned results. Its last line was "design-panel single-round — must-fix". The run is in `/tmp/panel-pr711-r1-3656193` and was recorded at `panel-runs/endojs-endo-but-for-bots-711/4629071a0ca2.md`.
- Seat verdicts:
  - **Request changes (6):** critic, skeptic, decomplector, ergonomist, pedant, novice.
  - **Comment only (1):** copyeditor.
  - **Approve (2):** orthographer, thesaurus.
- Posted the combined review: https://github.com/endojs/endo-but-for-bots/pull/711#pullrequestreview-5328767315. **It is a COMMENT review, not a request-changes one:** GitHub refused request-changes because the bot opened this PR. The review's heading says must-fix, and the body ends with `<!-- garden-panel-verdict: round=1 disposition=must-fix -->`.

**Main findings**
1. **Surface D migration plan (critic, decomplector):** it doesn't match the rest of the design.
   - The design argues for first-byte sniffing on Surface A but never considers it for Surface D.
   - Its "flip atomically where the framing name does not appear" clause conflicts with Surface D being classed as having no version coupling.
2. **Missing Rust codec (skeptic):** the inventory leaves out the separate netstring codec in the Rust `endo_iroh` crate (`netstring.rs` and `transport.rs`).
3. **Undefined term (novice):** "engo (Go supervisor)" is used without being introduced. The novice also flagged that the llm-branch vs. PR #124 split is never explained, and that some function names are used long before they are defined.
4. **Naming (ergonomist):** rename `makeFramed*` to `makeFrame*` and `ENDO_CBOR_FRAME` to `ENDO_USE_CBOR_FRAME`.
5. **Arrows (pedant):** replace the `→` characters in `designs/README.md` with `->`.

**Follow-ups**
- **Fix stage may miss the review:** the fix-stage brief tells the fixer to read the latest *request-changes* review, but this one is a comment review. The fix stage should also accept a comment review that carries the must-fix marker for bot-authored PRs.
- **Inbox not checked:** I couldn't drain this job's inbox because cloning the garden journal timed out.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr711-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 1 host(s)
- Input: 24 tokens (824101 cached reads)
- Output: 4260 tokens
- Cost: $0.8210602000000002
- Wall-clock: 337s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
