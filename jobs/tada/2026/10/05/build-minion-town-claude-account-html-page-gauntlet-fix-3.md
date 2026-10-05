Fix round 3 for kriscendobot/minion.town#157 (head branch `claude-account-html-page`) is pushed and CI is green.

I fixed both must-fix findings from the panel-3 review on `ae9b939`, plus some cheap should-fix items, in commit `783f8b7`. It was pushed with `safe-push-pr-head.sh --mode advance` (`ae9b939` → `783f8b7`).

**Must-fix**
- **archivist:** `sendHtml` in `src/auth/claude-account-endpoint.ts` now has a doc comment explaining the `no-store`, CSP and no-referrer headers and why it sets them. The awkward cross-site POST sentence in the BROWSER PAGES comment now reads "A POST that a Fetch-Metadata-capable browser marks as cross-site … is refused".
- **pruner:** I rewrote the PR body down to the issue link, a one-paragraph summary of the change, one sentence on test coverage, and the deploy note. The implementation walkthrough and the restated root cause are gone. The `garden-job` marker is kept.

**Should-fix, also applied**
- **stylist:** renamed `crossSiteForm` to `isCrossSiteForm`, to match the other `is…`/`wants…` checks in the file.
- **saboteur:** a token submitted through the form is now trimmed before the empty check. A blank or whitespace-only paste gets a 400 and leaves the single-use link usable, and a token with stray spaces now connects.
- **saboteur:** a resubmitted form (a double tap, say) whose link was already used now gets "Link already used — check your account page to see whether it connected" instead of "Link expired".
- **Tests:** the resubmit test now expects status 410 and the "already used" text. Two tests are new:
  - a never-issued link gets the 404 expired page;
  - a whitespace-only token is refused without using up the link, and a padded token then connects.

`tsc --noEmit` is clean, and the endpoint and dark-mode tests pass locally (31 tests). `ci-wait-merge` returned rc 0: all 3 checks are green.

**Left for later:** the other comment-only notes. These are:
- making the palette a shared constant instead of a copy;
- property-based tests suggested by fast-checker;
- a regression test for dates outside the range a `Date` can hold;
- HTML pages for the refusals that happen before the user is admitted, which are still plain text;
- the lack of a coverage report;
- testing the form on a real phone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-html-page-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (923126 cached reads)
- Output: 5829 tokens
- Cost: $0.8061892
- Wall-clock: 378s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
