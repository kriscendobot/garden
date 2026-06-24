---
ts: 2026-06-08T03:00:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--356426
prs:
  - repo: endojs/endo-but-for-bots
    pr: 404
    role: target
refs:
  - entries/2026/06/08/025000Z-dispatch-researcher-c19e1e.md
  - entries/2026/06/08/025500Z-result-researcher-c19e1e.md
  - https://github.com/endojs/endo-but-for-bots/pull/404
  - https://github.com/endojs/endo-but-for-bots/pull/404#issuecomment-4641513421
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-4415614938
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-4414531688
---

# dispatch: designer — rsvp #404: rebase + address ~12 asks across two kriskowal reviews (3 sibling-design dispatches surfaced)

User RSVP directive (2026-06-08T02:42Z) on `endojs/endo-but-for-
bots#404` comment 4641513421 (kriskowal, 2026-06-07T05:17:11Z):
*"Please rebase and ensure feedback above is addressed."*

PR #404 is **design-only** (`designs/chat-inventory-create-
menu.md` + `designs/README.md`), 2 files, base `llm`, head
`design/chat-inventory-create-menu` at `7b2bf91`.

Two prior kriskowal reviews:
- COMMENTED 2026-06-03T00:04:15Z (`4414531688`): Ollama menu
  + local/remote alternatives.
- CHANGES_REQUESTED 2026-06-03T05:25:40Z (`4415614938`):
  10 inline comments lines 289-509.

Read the researcher's full `## Library and project references`
section at
`journal/entries/2026/06/08/025500Z-result-researcher-c19e1e.md`
**first**. Key load-bearing findings from the researcher:

1. **THREE sibling-designer dispatches needed** (not two): line
   363 (`@root` endowment + user/user-profile root host
   special-place split), line 477 (encrypted-at-rest formulas
   in root host pet store), and line 484 (deferred-complication
   placeholder). Author the three dispatch prompts as **messages
   to the steward** (the steward will route them as separate
   dispatches in the next cycle).
2. **Inline 495's `introducedNames` confusion has a canonical
   answer**: `provideGuest(name, { introducedNames: { ... } })`
   per `lal-fae-form-provisioning`. The current Open Question 4
   collapses; rewrite as a clarification.
3. **Inline 363 reframing tension**: maintainer says "this
   should replace lal fae form provisioning"; the current
   Design Decision 7 says "extends, never replaces". Thread the
   needle: Chat absorbs the provisioning entry point; lal-fae
   daemon-side substrate stays; inbox-as-durable-config-store
   preserved via Chat-side inbox replay on first launch.
4. **Rebase is clean**: design-only; master-into-llm unicorn
   autofixes don't apply. Use frozen base `llm-11a76ae`
   (existing) per `skills/frozen-base-branch/SKILL.md`.
5. **Pane 3 expansion (line 509)**: honest answer is one row
   shippable today (filesystem, `Draft` in daemon-capability-
   bank), eight rows as documented placeholders (`Planned`).
6. **Encrypted-at-rest discipline** is documented in the
   `endopi-provider-registry-and-oauth` section as
   "Endo's encrypted store is mandatory"; this is the
   structural anchor for the line 477 sibling design.

## Maintainer asks (verbatim, all 10 inline + COMMENTED + RSVP)

**COMMENTED review** body (id `4414531688`): *"Given that our
default is to use Ollama locally, if we can, we should also add
support for querying ollama supported models and providing a
menu, including the option of downloading a supported model ..."*
(read full via gh-api).

**CHANGES_REQUESTED review** (id `4415614938`), 10 inline:

1. **Line 289** (id `3346071065`): *"Right, and importantly, the
   `@fs` and `@main` bindings can be coupled for a posix
   sandbox."*
2. **Line 290** (id `3346064855`): *"This can be omitted or can
   be a scratch or a snapshot."*
3. **Line 291** (id `3346066647`): *"This will also be omitted
   by default. Opt-in is not recommended."*
4. **Line 363** (id `3346088221`): *"My intention is that this
   should replace lal fae form provisioning. Provisioning
   becomes a dependency of the Chat application but not a
   dependency of the daemon. This requires Chat to install the
   prov..."* (read full via gh-api)
5. **Line 477** (id `3346092304`): *"Let's use the root host
   agent pet store. Please dispatch a designer to ensure
   formulas are encrypted at rest."*
6. **Line 484** (id `3346094334`): *"Agree this is a separate
   design. Dispatch a designer to leave a place-holder for this
   complication."*
7. **Line 489** (id `3346099144`): *"We can detect the local
   Ollama and also provide an alternative for Ollama hosted
   elsewhere, revealing the custom URL only if the user
   chooses 'Ollama Remote'. Similarly, Open Router will require
   addit..."* (read full via gh-api)
8. **Line 495** (id `3346102965`): *"This confuses me. I think
   we can use introducedNames to endow the guest."*
9. **Line 499** (id `3346107028`): *"Agreed."* (no action; just
   reply acknowledging)
10. **Line 509** (id `3346114334`): *"Let's elaborate on my
    initial list with all sensible capabilities we can construct
    with the material we have today, and also agree that the
    system is extensible."*

**RSVP comment** (id `4641513421`): *"Please rebase and ensure
feedback above is addressed."*

## Task

In your `project/` worktree on `design/chat-inventory-create-
menu` (currently at `7b2bf91`):

1. **Rebase on frozen base** `llm-11a76ae` (existing on origin):
   `git fetch origin && git rebase llm-11a76ae`. Force-with-
   lease push.
2. **Retarget PR base** to `llm-11a76ae` via `gh pr edit 404
   --base llm-11a76ae`.
3. **Read full inline comment bodies** for truncated comments
   (lines 363, 489) via `gh api repos/.../pulls/comments/<id>`.
4. **Address each inline** (10 asks) by editing
   `designs/chat-inventory-create-menu.md` per the researcher's
   findings + the verbatim asks. Commit per ask group:
   - Lines 289-291: posix-sandbox + scratch/snapshot framing.
   - Line 363: rewrite Design Decision 7 to absorb provisioning
     into Chat per maintainer's framing, preserve daemon-side
     lal-fae substrate.
   - Lines 477, 484: surface as sibling-designer follow-up
     dispatches (write as `message: designer → steward` entries
     so the steward routes them next cycle).
   - Line 489: rewrite Ollama-detect + Remote-alternative
     section per maintainer's full body.
   - Line 495: collapse to `provideGuest({ introducedNames })`
     clarification.
   - Line 499: acknowledge in reply (no edit).
   - Line 509: expand Pane 3 with 1 shippable + 8 placeholder
     rows.
5. **Sibling-design messages**: write three
   `message: designer → steward` entries (line 363, 477, 484)
   so the steward can route as fresh dispatches.
6. **Push** commits to `design/chat-inventory-create-menu`.
7. **Reply on each inline thread** citing the addressing
   commit. Reply on the COMMENTED review's body via a top-
   level comment. Post a top-level summary comment on PR #404
   acknowledging the rebase + all addressed asks.

## Authorizations (per-action, forwarded by steward)

- **Push** rebased+addressed head.
- **Retarget PR base** via `gh pr edit`.
- **Reply on each inline thread** + top-level summary comment
  + reply on the COMMENTED review body (`endo-but-for-bots`
  standing broad-comment authorization).
- **NOT re-request review**.

## Out of scope

- Do NOT author the three sibling designs IN this PR; surface
  them as `message: designer → steward` entries.
- Do NOT touch packages outside `designs/`.
- Do NOT trigger panel/judge/fixer chain.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- Pre/post head SHAs.
- Per-commit SHA + description.
- The three sibling-design dispatch messages (paths in journal).
- Per-thread reply URLs (10) + top-level summary URL +
  COMMENTED-review reply URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
