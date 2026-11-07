The gauntlet can begin on PR #253, though it is already halted: the earlier failed attempts at this check used up its retry budget. A maintainer needs to re-run it with "run the gauntlet #253".

The shell on `endolin-garden-ece02cb4` works again, so this run got through the full check. The PR is open, a draft, and unmerged. The head is `7e64541a`, the base is the pinned snapshot `main-7a0bcc9`, and CI is green.

Deciding question: Has anything reached `main` or another PR since `7a0bcc9` that already sends a waitlist sign-up to a `/soon` thank-you page, or dropped the need for one? No.

Evidence:
- **Base history:** the only change on `main` since `7a0bcc9` is the design doc `designs/api-key-agent-directory-authorization.md` (merge of #250). It doesn't touch the landing or waitlist code.
- **Current code:** `deploy/aws/www/home.js` on `main` has no `/soon` route and no "could not add you" failure text. The waitlist still shows a note under the form, which is what this PR replaces.
- **Competing PRs:** a search found nothing else that implements `/soon`. #198, which built the waitlist, merged on 2026-10-17. The sibling #254 ("explain failed guest recovery") covers a different feature, so it doesn't replace this one. It does edit the same files (`home.js`, `index.html`, the Caddy route file, `home-page.test.ts`), so whichever lands second will likely need a rebase.
- **Discussion:** there are no reviews. The only comment is the gauntlet's own "halted" status note.
- **Still open from the PR itself:** the production deploy and check (Caddy first, then the web files) were never done because the build host had no AWS credentials. That doesn't affect viability.

I made no commits, journal writes or job posts, and spent no gauntlet budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr253-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 52 tokens (1850309 cached reads)
- Output: 9292 tokens
- Cost: $8.052551845000002
- Wall-clock: 187s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
