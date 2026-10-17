# mt-beta-settings-simplify: completion report

I opened draft PR **https://github.com/kriscendobot/minion.town/pull/200**. It is stacked on #198, the one-landing PR, whose overlay this reshapes, and it targets a frozen snapshot of #198's head, `feat/beta-home-splash-waitlist-bbf6c15`. All CI checks pass, including the real-daemon suite. I changed no production admission setting.

## What changed
- **Menu:** it now holds exactly **Connect CLI**, **Connect MCP** and **Invite a Friend (N available)**. Connect CLI creates a one-use invitation for an Endo daemon the user runs locally. Connect MCP links to `/connect.html`. Invite a Friend creates and copies an invitation link.
- **Log out:** shown only when the server reports at least one bonded recovery sign-in. If it reports none, a hint links to *Add a recovery sign-in*. If it can't answer, neither appears.
- **Delete account…:** a separate, de-emphasized item. It explains what is lost, requires typing `delete my account`, and calls `DELETE /api/guest`. The server removes every recovery bond, records the deletion durably, cancels the guest and drops its daemon names. It writes an audit line before and after, to stderr and to `account-deletions.jsonl`, naming the guest only by a hash.
- **Bond lookup:** checking and removing bonds by guest uses a new DynamoDB index. `deploy-accounts-store.sh` adds the index and a query grant on it only; the app role still cannot Scan or DeleteItem.
- **Removed clutter** (each item is listed in the PR body): greeting, role panel, guest formula id, guest locator, credits, old Session block, Copy guest URL, Forget this browser, the old invite form, mail, and the recovery blurb.

## Things worth knowing
- **Deleting a guest needed more than removing it from the daemon.** Against the real pinned daemon, the old guest URL still worked after cancel and name removal, because production runs without formula garbage collection (`ENDO_GC` off). So the server keeps a durable deleted-guests list and refuses those guests on every route. In production, deletion answers 503 unless that list is durable. A side effect: the guest's state stays on the daemon's disk until collection is turned on.
- **No invitation count yet.** The coupon PR (#199) isn't merged and has no per-holder count. I coded against a small interface whose stub shows no count, so the menu reads just "Invite a Friend" today. Wiring it up after #199 is a one-line change, described in the PR.
- **Data deletion leaves in place** (flagged for maintainer review in a table in the PR): the OAuth account row, clips (stored under the OAuth sign-in, not the guest), coupons (they return to the pool when they expire), and waitlist email.
- **The browser run caught a real bug:** Log out showed without a bond because a CSS rule overrode `hidden`. It's fixed, and a test pins it.

## Evidence
- **Real daemon:** the new deletion test passed locally against the pinned Endo commit, and in CI, where it actually ran rather than being skipped.
- **Real browser (headless Chromium, production CSP):**
  - The menu shows the three items, and the count appears when a stub supplies one.
  - Log out is hidden before a bond exists and shown after.
  - The delete button stays disabled until the phrase matches. After deletion the old URL gets 401 and recovery gets 404.
  - The audit file holds the "requested" and "deleted" lines, and there were no CSP violations.
- **Tests:** 23 new across three files. Removing the deleted-guests check fails 3 of them. Typecheck and pre-push gates pass. `npm test` has 1238 passing; the one local failure is the environmental `test/git-remote/capability.test.ts`, which also fails for #198 and #199.

## Follow-ups (in the PR body)
1. Before merging, the maintainer runs `deploy-accounts-store.sh` to add the index. Until the index is active, Log out stays hidden and deletion answers 503 without deleting anything.
2. Wire the invitation count once #199 adds a per-holder count.
3. For maintainer veto:
   - the no-bond hint;
   - removing Copy guest URL and Forget this browser;
   - removing mail before the chat clip exists;
   - leaving daemon state on disk while garbage collection is off.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mt-beta-settings-simplify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 224 tokens (20761730 cached reads)
- Output: 89586 tokens
- Cost: $8.002378
- Wall-clock: 2415s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
