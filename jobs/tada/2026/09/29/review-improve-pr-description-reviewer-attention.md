Both parts are done and pushed to `main2` in commit `8ebbdb344a0`. The `pr-description-reviewer-attention` cluster is now closed.

**Prevention**
- **New checker**: `scripts/jobs/gardening/pr-body-template-check.sh` compares a PR body against the base branch's `.github/PULL_REQUEST_TEMPLATE.md`. It reads the template from the base ref in the project checkout, or over GraphQL, because the REST quota was exhausted during this run.
  - Exit 20 (blocking): a template heading is missing or out of order, or template guidance was left in (a `> …` prompt or a `#XXXX` placeholder).
  - Exit 10 (attention only): the body adds headings the template doesn't name. I made this a warning because the garden's own "Phase and evidence ledger" section would otherwise be rejected. The maintainer-accepted current #1281 body also has an extra "Provenance" heading and scores 10.
  - Exit 3: the body or template couldn't be read.
- **`ensure-pr.sh` refuses a blocking body** before creating the PR, and prints the findings and how to fix them.
  - **Why refuse rather than warn:** a warning in a headless log is the same kind of reminder that already failed across six panel rounds on #1281, and the fix (refill the body from the template) is mechanical.
  - A template that can't be read only warns, because the panel checks again each round. `GARDEN_ALLOW_NONTEMPLATE_BODY=1` is the escape hatch.
- **Concision guidance**:
  - `pr-formation` has a new section, "Cut to what the reviewer needs": no per-package lists, no inline test counts (link the run instead), and cut past about 300 words.
  - `pr-review-thread-replies` now says to answer "which test?" with a permalink to the test. It also shows how to check a draft reply with the probe (`--kind reply`) before posting.
  - `pre-pr-checklist` notes that the template rule is now enforced.

**Sensing**
- **New pre-pass in `panel.sh`**, run every round: it fetches the live PR body and runs the template check.
  - A blocking result adds the integrator seat, hands it the findings, and forces the round's verdict to must-fix. An attention-only result just adds the integrator.
- **New probe**: `skills/panel-hints/probes/C-pruner-pr-body.sh` runs on the same body. It fires on more than 300 words (80 for a reply), a checklist, per-file bullet lists, or an inline test count. When it fires, the pruner seat is added with the signals.
- **Brief lines**: the integrator, pruner and fixer briefs gained matching lines. The fixer line says a must-fix on the PR description is fixed with `gh pr edit --body-file`, not a commit. The `panel-hints` skill documents the pre-pass.

**Re-litigation**: the new test `scripts/jobs/test/pr-body-template-check-test.sh` passes 21 of 21 checks, using the historical artifacts saved under `scripts/jobs/test/fixtures/pr-description-reviewer-attention/`.
- #1281's body as opened (the 2026-09-15T23:08:36Z revision from `userContentEdits`) fails the template check with exit 20. All 7 template headings are reported missing and "Goal" and "What was noisy" are flagged as invented.
- #16's body as reviewed also ignored the agoric-sdk template (exit 20). It also trips the concision probe on its per-package bullets and "25 tests pass".
- #16's thread reply 3576146608 trips the probe (235 words, 4 bullets, "8 passed"). The one-line permalink reply that closed the thread does not.
- The test also runs the `panel.sh` pre-pass directly on the #1281 body. It forces the must-fix verdict, adds the integrator and pruner seats, and hands both their findings.
- The `ensure-pr` test gained 4 template cases (36 of 36 pass). All 18 existing panel tests, the phase-evidence and cross-platform probe tests, and `tests/checks` pass, and `shellcheck` is clean.

**Follow-ups**
- Any garden PR opened through `ensure-pr.sh` against a base that has a template (including `llm` on endo-but-for-bots) will now be refused if the body doesn't follow it. That matches the existing skill rule, but builders and designers who were writing freeform bodies there will hit the refusal once.
- In panel tests whose checkout has a GitHub-looking origin, the pre-pass makes a `gh pr view` call that fails and is logged as non-fatal. The phase-evidence pre-pass already does the same.
- Nothing checks a thread reply before it is posted; the probe is available for a self-check, but only the skill tells anyone to run it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-pr-description-reviewer-attention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 80 tokens (5007168 cached reads)
- Output: 44388 tokens
- Cost: $3.1883536000000006
- Wall-clock: 538s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
