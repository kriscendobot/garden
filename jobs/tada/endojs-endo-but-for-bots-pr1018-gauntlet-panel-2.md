The review is posted. Panel round 2 completed with disposition **must-fix**.

## Completion report

**Job:** Gauntlet PANEL stage, round 2, for endojs/endo-but-for-bots PR #1018 (`design(ironhorse): panic mechanism and message-embargo contract`).

**What I did:**
- Resolved the PR head (`endojs/endo-but-for-bots` @ `design/ironhorse-panic`, base `llm` @ `92148f20f`) and set up an isolated project worktree keyed to this job.
- Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the head worktree with the real merge-base SHA (`92148f20ff…`, not the bare `llm` branch, per the base-normalization gotcha). Seats fanned: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice.
- Panel disposition: **must-fix**.
- Posted the aggregated seat verdicts to PR #1018 as a `gh pr review`. `--request-changes` was rejected (GitHub forbids requesting changes on your own PR — the bot authored #1018), so I posted the same aggregate as a **comment review** (author `kriscendobot`, submitted 2026-08-31T05:37:07Z). The gauntlet advances off the stage-result marker below, and the fixer reads the latest panel verdict regardless of review type.

**Key must-fix findings the fixer will apply** (design-doc only diff: `designs/ironhorse-panic.md` +674, `designs/README.md`):
- **pedant:** em-dash rule violated 17× (must rewrite as period/parens/colon per `em-dash-style`); heading capitalization inconsistency ("is" vs "Is").
- **skeptic:** central "not a compromised daemon" premise unverified against the live in-proc XS/FFI boundary (`extern "C"` panic → whole-process abort; no `catch_unwind` in `rust/endo/xsnap/src/`); underspecified retry-replay semantics.
- **critic:** durable per-message WAL transcript is mandatory for every worker despite an admitted latency regression, without discussing a per-worker opt-in (mirroring the Coda).
- **decomplector:** static per-worker flag conflates "want diagnostics" with "make ReferenceError uncatchable" (footgun); unaudited sixth "tentative-local" host-fn category outside the five-way taxonomy.
- **ergonomist:** `<panic kind=…>` wire enum omits `decode`/`step-limit` that `is_panic()` can produce; two payload shapes for one semantic family.
- **novice:** forward references to unintroduced context; implementation jargon before the problem is motivated.
- **copyeditor:** paragraph-flow and tense-slip nits (comment-only).

**Stage boundary respected:** ran exactly one panel round; did not fix, un-draft, or loop.

No follow-ups needed from me — the gauntlet supervisor advances to the fix stage off the marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (770271 cached reads)
- Output: 5893 tokens
- Cost: $1.0285195
- Wall-clock: 401s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
