Fix round 6 for kriscendobot/minion.town PR #201 is pushed. CI is green on the new head `bd264aec`: every check passed and none failed.

**Must-fix items from the round-6 panel (review 5565359951):**
- **Weave onto current `main` (integrator).** #197, the live-frame PR, merged after this PR's frozen base, so I rebased all 15 commits onto `main` at `cfafabea` and moved the PR base from `main-bda7739` to the existing frozen `main-cfafabe`. Five files conflicted: `minion-town.caddy`, `shell.js`, `clip-shell-framework.md`, `guest-self-endpoint.ts` and `http.ts`.
  - Every conflict keeps #197's live frame and saved clip order, with the New Clip mint added alongside. The `@guestSelf` matcher now lists `/clips/order` and `/clips/new`; the endpoint takes both `clipsFor` and `mintNewClip`.
  - The rebase broke `dev/new-clip-stack.ts`, which still called the old `listClips`. A follow-up commit wires it to #197's `clipsFor`.
  - I fixed each outdated "§ 6 follow-on" / "live-frame follow-on" reference by what it actually means (the integrator's second finding). Drag-reorder is now described as shipped, and the "until #197" text in `designs/new-clip.md` now says the shell frames the clip live.
- **Removed `importLocator` from the public clip power (locksmith, saboteur, breaker, wire-watcher).** Clip ids are formula numbers, so they are public. The import let anyone with a clip URL turn one into the value it names. Removing it from the power, the page's creator list, the browser demo and its `/locator` control route, and the design closes all four findings:
  - write access to another owner's directory;
  - a value that never answers jamming the mutation queue;
  - quota refunds for an import that grew outside the power;
  - walking into a guest.

  Importing waits for the owner-held credential (#88), along with invitations and browsing the guest's root. The tests now check the method is absent, in the unit tests and against the real daemon in CI.
- **Smaller fixes:** `'← Back'` is now `'Back'` (typist), and the comment that repeated the re-export in `model.js` is gone (pruner).

I updated the PR body (live framing via #197, the narrower authority) and posted a follow-up comment on the PR (issuecomment-6256724696) listing what changed and what I declined.

**Not done:** the should-fix and comment-only items. These are the quota-bookkeeping refactor, the shared worker-selection helper, the unused `makeApp` type, `isWellFormed` checks on names and text, an `Origin` fallback for the cross-site check, a credit check before the prepare step, eager usage measurement, and a restart test.

**Verification:**
- `tsc --noEmit` is clean.
- The New Clip, shell and guest-self-endpoint test suites pass locally (155 passed). The real-daemon suite skips without `ENDO_CHECKOUT` but passed in CI.
- In the full local run, the only failure is `test/git-remote/capability.test.ts` ("propagates a git failure"). This PR doesn't touch that file; it matches the known local git-wrapper false failure.
- The base retarget started a second copy of every workflow. Those copies queued on the shared runner, so CI went green about 6 minutes past the 3600s wait budget. The background wait job hit its time limit and was stopped, so I re-ran the wait in the foreground until it reported green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (7261011 cached reads)
- Output: 27332 tokens
- Cost: $3.2406582000000004
- Wall-clock: 4329s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
