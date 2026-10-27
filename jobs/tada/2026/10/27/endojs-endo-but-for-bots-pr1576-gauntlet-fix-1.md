I applied the panel-1 fixes to endojs/endo-but-for-bots PR #1576, pushed them, and CI is green: `ci-wait-merge.sh` returned rc 0 with 30 checks and no failures.

I worked from the latest panel verdict, the bot's "Must-fix before merge" review 5667226818, since there was no pre-pass block for this round. The fixes are in one new commit, `bcf5e1ebe6`, on `build/hardened-text-codecs-downstream-audit`, pushed with `safe-push-pr-head.sh`. It fast-forwarded the branch from `fb5cd276ba`.

**Must-fix items:**
- **Audit scope (skeptic):** The audit now states what it covers: `packages/*/src`, plus the non-test package folders `bench/`, `demo/`, `scripts/` and the Markdown files. It says why the 83 matches under `packages/*/test/` are left out.
  - I checked `packages/compartment-mapper/demo/policy/app.js`. It does run inside a compartment created after lockdown. Its `Buffer.from` call decodes hex through a `Buffer` subset the demo's policy grants. `TextEncoder` and `TextDecoder` can't do hex, so it isn't a migration candidate; the doc now says so.
  - The other matches outside `src` are host scripts or Markdown, and the doc lists them.
  - I also reworded the Phase 3 bullet. It now says "code that runs inside a compartment created after lockdown" instead of "code that runs under SES", since the start compartment also runs under SES.
- **Stale index date (skeptic, pedant):** The `designs/README.md` row now shows Updated 2026-10-27, matching the design. The totals don't change.

**Should-fix items, also addressed:**
- **Two separate axes (decomplector, novice):** The rule for what counts as a migration candidate is now stated before the list. Each site is judged separately on where it runs and on what conversion it does. A conversion is either plain UTF-8, which `TextEncoder`/`TextDecoder` can replace, or something that needs `Buffer`: hex, base64, `Buffer` views passed to Node streams, or `Buffer#copy`.
- **Paths and line length (pedant):** Every path is now repo-relative, like `packages/...`. I replaced the over-wide table with a list wrapped at 72 columns, and each entry now names its conversion kind.

The conclusion hasn't changed: nothing meets the migration rule. The plain UTF-8 sites could still move to `TextEncoder`/`TextDecoder` as optional cleanup.

A few lines elsewhere in the design are still over 80 columns. They were there before this PR and fall outside the audit section, so I left them alone.

I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1576-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1143573 cached reads)
- Output: 8673 tokens
- Cost: $0.9029266
- Wall-clock: 726s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
