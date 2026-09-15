Inbox empty. Work complete and pushed.

## Completion report

**What I did.** Added per-section provenance footnotes so an *aggregated* multi-agent report (a panel review stitched from many `claude -p` seats, a PR completion summary stitched from many contributors) attributes each section to the model/harness/provider that produced it — instead of the single whole-body footer that misattributes every section but one. Built on the `fix-comment-provenance-provider-and-automatic-mark` conventions (provider fact, `automatic` marker, `<sub>` styling, fail-open) rather than inventing new ones.

**What changed.**
- `scripts/jobs/comment-provenance.sh`:
  - Factored the footer's model/harness/provider rendering into a pure `_prov_mhp_parts` that takes **explicit** facts (+ a no-LLM flag), so a composer can render each section's own facts rather than only the current process's env. `provenance_line` (the whole-body, env-reading footer) is now a thin wrapper over it — byte-identical output, existing tests unchanged.
  - Added `provenance_footnote <model> <harness> <provider> [no_llm]` and `provenance_footnote_for_kind <model> <worker-kind> [no_llm]`: a per-section `<sub>` footnote in the whole-body footer's visual style, carrying a **distinct** `PROV_SECTION_MARKER` and omitting the (whole-body) garden sha.
  - Tightened `provenance_body_has_line` to match the *delimited* `<!--marker-->` token. The section marker is a superstring of the whole-body marker; the old bare-substring test would false-positive on a section-footnoted body and wrongly suppress its single closing whole-body footer.
- `scripts/jobs/gardening/panel.sh`: sources the (pure) provenance library and appends a per-seat footnote to each seat's block as it assembles the aggregate — which the gauntlet posts verbatim as the `gh pr review`. New `seat_provenance_footnote` hook (overridable via `GARDEN_PANEL_SEAT_PROVENANCE`) captures each seat's facts; a deterministic seat renders `automatic`; fail-open when no facts/library.
- `skills/panel-review/SKILL.md`, `skills/pr-completion-summary-comment/SKILL.md`: documented the per-section footnote shape and the helpers.
- Tests: `comment-provenance-test.sh` gained SUBTEST 11 (distinct footnotes from different mocked facts, section marker + no sha, `automatic`, fail-open, and an end-to-end multi-section post that keeps N section footnotes **plus** exactly 1 closing whole-body footer). New `panel-per-section-provenance-test.sh` + stub assert the panel aggregate carries one distinct footnote per seat with each seat's own facts.

**Verification.** `comment-provenance-test.sh` 50/0; `panel-per-section-provenance-test.sh` 8/0; `gh-wrapper-fail-closed-test.sh` 49/0; all 12 panel suites green. `shellcheck -S warning` clean on changed files (one pre-existing SC1090 on an untouched line). Pushed to `main2` as `a2ac6fd424`.

**Follow-ups (optional, not required by the job).** Panel seats today all run `claude -p` at the panel job's resolved facts, so per-seat footnotes are currently identical in practice; the mechanism is correct the moment seats diverge (a per-seat `--model`) or a cost-gated seat resolves deterministically. Detecting the deterministic-seat case automatically from panel.sh (rather than via the injectable hook) would need the seat-gate scripts to signal whether they spent an LLM — a possible refinement, not needed now.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/add-per-section-provenance-footnotes-aggregated-reports.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (6219910 cached reads)
- Output: 48164 tokens
- Cost: $5.857698999999998
- Wall-clock: 717s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
