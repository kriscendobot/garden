• PR #778 adds `designs/endo-ertp-migration.md` on branch `design/endo-ertp-migration`. Let me get an isolated project checkout and inspect the doc.

• All 41 cited numbers verified against Agoric/agoric-sdk — titles/states match the doc; #5283 is a PR (needs `/pull/` URL), the rest are issues. Let me check my inbox and the PR's CI conventions, then make the edits.

• Inbox is empty; CI is build/lint/test/zizmor. Now I'll verify every backticked numeral in the doc is an issue reference, then apply the transformation.

• Transformation applied (2 multi-spans, 2 agoric-sdk issues, 59 issue refs, 28 bare numerals). Now let me review the full diff carefully.

• Now let me verify the final state: every citation linked, no double-wraps, URLs all well-formed and pointing to the right targets.

• The repo lints with prettier. Let me check whether `designs/` is covered and run prettier on the changed file.

• `lint:prettier` only covers `.github`/`packages` (designs/ isn't linted), and the file passes prettier anyway. Now commit and push to the PR head branch.

• PR head is `origin/design/endo-ertp-migration` on endojs/endo-but-for-bots. Committing and pushing with a rebase CAS loop.

• Push confirmed on the PR. Posting the review reply and checking CI.

• zizmor failed on my push though it passed on the prior commit. A markdown-only change shouldn't affect it — let me inspect the failure log.

• While CI settles, let me drain the inbox once more.

• CI settled: build/lint/test pass; zizmor fails for environmental reasons unrelated to this change. Work is complete — writing the report.

  ---

  **Job: endojs-endo-but-for-bots-pr778-review-95a2b3a4 — Review directive on endojs/endo-but-for-bots PR #778 (kriskowal review 4814070872, CHANGES_REQUESTED)**

  **Ask (whole review):** "Please add fully qualified URL citations to the various documents and conversations about the ambitions for ERTP v2." Enumerated inline comments tied to review 4814070872 via `gh api .../pulls/778/comments` — **none** (`[]`); the review body was the only ask. Preflight (`pr-feedback-preflight.sh`) exited 0 (PROCEED, no peer resolution).

  **What I did:**
  - Worked in the isolated project checkout `scratch/project-wt-endojs-endo-but-for-bots-pr778-review-95a2b3a4-e83b339e` (per ensure-project-worktree.sh), branch `design/endo-ertp-migration`.
  - Verified all 41 cited Agoric/agoric-sdk numbers against the live tracker (`gh api repos/Agoric/agoric-sdk/issues/N`): every title and open/closed state in the doc matches; #5283 ("feat(ertp): durability") is a PR, so it is cited via `/pull/5283`.
  - Rewrote every citation in `designs/endo-ertp-migration.md` as a fully qualified URL markdown link — 89 links across the corpus survey, the fold-in table, design/roadmap/open-questions references. Fixed a self-inflicted double-wrap on the two `issues A / B / C` spans; programmatic audit confirmed link text ↔ URL number consistency (0 mismatches) and no remaining plain-text citations.
  - Updated the corpus-section note (was "cited link-free to avoid backlinks") to record the fully-qualified-URL convention — a link in committed markdown creates no upstream cross-reference backlink — and added a trailing note after the verbatim Prompt blockquote recording that the maintainer's review supersedes the prompt's link-free constraint.
  - Committed `aac89e41e` ("design(ertp): cite ERTP v2 corpus with fully qualified URLs") and pushed to the PR head (`git push origin HEAD:design/endo-ertp-migration`, first CAS attempt succeeded). Confirmed the commit is the PR tip via `gh pr view`.
  - Posted a reply comment on the PR referencing the review and the commit: https://github.com/endojs/endo-but-for-bots/pull/778#issuecomment-5124947349

  **Verification:** `npx prettier --check` on the changed file passes (repo `lint:prettier` covers only `.github`/`packages` anyway). CI on the push: build pass, lint pass, test pass.

  **Follow-up (not caused by this change):** the `zizmor` check now fails on the PR (run 30503386441, exit 13) flagging pre-existing action hash pins in `.github/workflows/ci.yml:123` and `ci-docs.yml:42,71`. The identical workflow files passed zizmor on the previous PR head (run 29558307885); the runner-image zizmor version moved between runs (20260714.240.1 → 20260720.247.2). This is a base-branch (`llm-d396059`) issue affecting every PR that re-runs CI; fixing the pins is out of scope for this citation review and was left untouched.

  Inbox drained (empty) at start and before completion.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr778-review-95a2b3a4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47109 tokens (1278208 cached reads)
- Output: 17549 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 930s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
