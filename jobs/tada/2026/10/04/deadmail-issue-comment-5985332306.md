I've found why https://minion.town/account/claude downloads a file on mobile, posted a build job to fix it, and replied on the issue. Nothing on minion.town has changed yet.

**Cause** (in `src/auth/claude-account-endpoint.ts` at minion.town `main` `880278b`):
- `GET /account/claude` returns JSON, so mobile browsers download it instead of showing it.
- The connect page `GET /account/claude/:nonce` is plain text that says "submit the token below", but it has no form.
- `POST /account/claude/:nonce` only accepts a JSON body, so nobody can finish connecting from any browser.

**What I did:**
- Posted `build-minion-town-claude-account-html-page` on kriscendobot/minion.town. It asks for:
  - an HTML page for browsers, with JSON kept for API clients;
  - a token form that works without JavaScript;
  - form-encoded POST support with an HTML result page;
  - access checks left unchanged, the token never echoed, logged or put in a URL, and tests.

  The job body includes the ISSUE NOTE. It will open a draft PR, go through the gauntlet automatically, and post the PR link on the issue.
- Replied on the issue with the cause, the job name, and the stopgap: until the fix lands, connecting needs a desktop `curl`. https://github.com/kriscendobot/garden/issues/89#issuecomment-5985361741

**Follow-ups:** The parked canary `minion-town-claude-cli-production-canary-after-connection-20261004` stays blocked until the maintainer connects. That will probably wait for the new page.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5985332306.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (536210 cached reads)
- Output: 3572 tokens
- Cost: $0.5978100000000001
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
