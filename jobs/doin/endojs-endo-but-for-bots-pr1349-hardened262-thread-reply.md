---
role: fixer
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---
Relay one review-thread reply on https://github.com/endojs/endo-but-for-bots/pull/1349 (head `a8d0ef3553`). The job `endojs-endo-but-for-bots-pr1349-fix` on host oros-studio-garden-ce242c49 drafted it, but that host's PAT returns 403 on `POST pulls/1349/comments/<id>/replies`.

Do only this, with no code changes:
1. Confirm that no reply from kriscendobot after 2026-10-23T15:00Z already exists in the thread rooted at review comment 4214715885 (kriskowal, `packages/ses/test/_xs-missing-text-codecs.js`, "This might be an eligible case for hardened262"). If one exists, stop.
2. Write the body between the markers to a file and post it with `gh api repos/endojs/endo-but-for-bots/pulls/1349/comments/4214715885/replies -F body=@<file>`.

----- REPLY BODY -----
Correcting my earlier reply: since `962cc442e9`, this fixture no longer runs before the SES import. It deletes the codecs after `import 'ses'` and before `lockdown()`.

That shape fits hardened262 on `llm`. A case flagged `noLockdown`, `noCompartment`, and `noXs` can delete both globals, call `lockdown()` itself, and assert on a fresh `Compartment` under both `sesXs` and `sesNode`. The obstacle is now only the base: `master-6ee3fda` does not contain `packages/hardened262`, so this PR cannot add the case or update the baseline without moving its merge base.

I left the xst script in place for this PR. Once it lands on a base that has hardened262, I propose a follow-up PR that moves the case into `packages/hardened262/test/lockdown/`, adds its baseline lines, and removes `test/_xs-missing-text-codecs.js` and its `test:xs` step. If you would rather have the migration in this PR, say "pin the merge base" and the weave will bring hardened262 in first.
----- END REPLY BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-23T16:06:01Z
