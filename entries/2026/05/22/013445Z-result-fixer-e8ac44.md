---
ts: 2026-05-22T01:34:45Z
kind: result
role: fixer
worktree: dispatches/fixer--e8ac44/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-e8ac44.md
  - entries/2026/05/22/010304Z-result-weaver-34b8fe.md
---

Carried inline-review feedback from upstream `endojs/endo#3047` onto the bot mirror `endo-but-for-bots#344` (`mirror/3047-readmes`). 16 follow-up commits, one concern per commit. No replies posted on either repo; no un-draft. Final head: `0c9fe40e2992778d6969eaf380bef0d7dd079bad`.

## Context: concurrent dispatch

A second fixer dispatch landed 4 commits on the same branch while I was working (`f2518bb38..de9e80e5b3`): `--powers HOST not AGENT` correction, `endo make` --powers enum & run/make asymmetry, netstring spacing & digit-separator consistency, stream-node Overview reflow. I rebased my work onto the new tip and harmonized:

- Dropped my redundant "Remove stray space before trailing comma" netstring commit (subsumed by the other fixer's `82d176ba5`).
- Rewrote my agency→authority commit to apply to the now-correct `HOST` line and the new run/make asymmetry paragraph (which had introduced its own use of "agency").
- Rewrote my "Define primary user and AGENT powers" to refer to `HOST` instead of `AGENT`, since the run command actually accepts HOST.

## In-scope items addressed (16 commits)

CLI README (`packages/cli/README.md`):

1. `00dc70ce2` Correct `yarn endo start` (the package has no `start` script) — discussion_r2776997379.
2. `b7db832ad` Use "authority" instead of "agency" on the HOST powers comment and in the run/make asymmetry paragraph — discussion_r2782004500.
3. `dd6d8dfda` Align mkhost comment with --powers HOST wording — discussion_r2781998070 (PR author confirmed in reply 2785719188).
4. `3a876eded` Introduce `--as` before its first use (moved the "Act as a different agent" block to right after agent creation) — discussion_r2782134110.
5. `653d1fbf2` Link to `demo/README.md` tutorial from the overview — discussion_r2782150797.
6. `1f11d5ad0` Define "primary user" and HOST powers (a short paragraph after the --powers examples) — discussion_r2710382629, discussion_r2781968151, discussion_r2781964030 (cluster).
7. `5b9461821` Define what "blob" means in Endo, distinct from web `Blob` — discussion_r2790508413 + follow-up 2801831896.
8. `ec55bc49d` Define "persistent worker" — discussion_r2780375959.
9. `57c817e0f` Distinguish `endo start` from `endo restart` — discussion_r2777052852.
10. `2a877cc0b` Note the daemon is per-OS-account — discussion_r2710347179.
11. `4f3bba4d0` Suggest a shell alias for the bin path — discussion_r2777030627.
12. `90f6b7fd6` Thread the `adopt` example through the name embedded in the prior `send` example — discussion_r2782110780 (in-scope half).
13. `c00cb0550` Frame `resolve` / `reject` as request response — discussion_r2782129412.

netstring README (`packages/netstring/README.md`):

14. `03493d590` Distinguish message parts from stream chunks; rename "Writing chunked messages" to "Writing messages in parts" — discussion_r2710312091.
15. `9f568b052` Name the `make*Reader` / `make*Writer` pair convention so users writing their own framings follow it — discussion_r2710317813.

stream-node README (`packages/stream-node/README.md`):

16. `0c9fe40e2` Explain `pump` in the cat example — discussion_r2710252567.

## Verified, no further change needed (in-scope items already addressed in earlier PR commits)

- discussion_r2710301445 (underbar separators for long numbers): the rebased branch had this and the other fixer's `82d176ba5` cleaned the comma spacing further.
- discussion_r2777054797 (`--powers NONE (default)` explicit line): already present.
- discussion_r2677222756 (jcorbin BNF `|` notation in `ls|list`): already replaced by parenthetical `(or: endo ls)` in the rebased branch.
- discussion_r2677232227 / discussion_r2677233437 (jcorbin alice/bob viewpoint clarity): every example now uses explicit `--as alice` / `--as bob`, plus section headers that name whose perspective ("alice the host sends to bob the guest", "bob the guest receives from alice"). No further surgery seemed warranted.
- discussion_r2710263237 (erights "link to Node Stream docs at the top of this README"): the rebased branch already has Node Readable/Writable links at the top of the stream-node Overview and a reference block at the bottom for Buffer / object-mode / backpressure / drain.

## Out of scope / deferred (with reasons)

- **gibson042's "update `packages/skel` and `scripts/create-package.sh`"** (discussion_r2677012254, discussion_r2677059731): the dispatch brief named this as deferred follow-up work, not this PR's diff. No commit; one-line acknowledgment in this report.
- **jcorbin's djbtools praise** (discussion_r2677268674): meta praise, not a change ask.
- **erights' TS `Stream` interface bug** (discussion_r2710228530, "no change suggested"): the comment text is about the type declaration in `packages/stream/types.d.ts`, not the README. Self-flagged as no change.
- **erights' `--start` EADDRINUSE message critique** (discussion_r2777021911): self-flagged as "not a comment on this PR".
- **erights' `endo run` zero-exit-code on guest error** (discussion_r2780262451): "no change suggested" by reviewer.
- **erights' embedded image-only comment** (discussion_r2777047086): no question.
- **erights' single-word reactions** ("Interesting", "Thanks", "I'm scared to ask"): no change asked.
- **erights' "nevermind"** (discussion_r2781985011): self-resolved by reading further.
- **erights' `endo eval` returning NaN for unknown petnames** (discussion_r2782034229): a behavior question on `eval` semantics, not a README change. The PR author confirmed in 2785723180 it surfaces from the new SES `undefined`-vs-ReferenceError change. Not a docs fix.
- **erights' directory → namespace rename** (discussion_r2782072783): the PR author replied that the naming is "tricky" and not settled, with a list of related concepts (name hub, directory, pet store, pet sitter) and "names are subject to discussion". A README-only rename now would diverge from the CLI commands (`mkdir`, `--ls some-directory`); leave for the author to converge.
- **erights' embedded-petname syntax / Familiar convergence question** (discussion_r2782092989): a cross-project design question; the PR author replied with the convergence intent. Not a README change.
- **erights' message-scoped names "btw" half of discussion_r2782110780**: a design discussion the PR author engaged with in 2785773694; the in-scope "which value from message #1?" half is addressed in commit 90f6b7fd6.
- **erights' AsyncIterableIterator vs AsyncGenerator tail of discussion_r2710228530**: about a `// Stream is nearly identical to AsyncGenerator` comment in the package source, not a README change.

## Per-command local test status

- `yarn format`: pass (no changes).
- `yarn lint`: pass (0 errors; 2 pre-existing warnings in `packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js`, neither in our diff).
- `yarn docs`: pass (0 errors, ~67 pre-existing warnings; none introduced by our edits, the new `./demo/README.md` link in cli/README does not appear among them).
- pre-push-gates (`--no-auto-fix --summary`): the 3 failing probes (`no-inline-import-jsdoc` in netstring/reader.js, `security-md-hash-uniform`, `sentence-per-line-md`) all fire on pre-existing tree state outside our follow-up diff. Our touched files (`packages/cli/README.md`, `packages/netstring/README.md`, `packages/stream-node/README.md`) trigger no new probe findings; the one sentence-per-line hit in `packages/netstring/README.md:155` is the false-positive `D. J. Bernstein` in a list block, pre-existing in the rebased branch.

Final head of `mirror/3047-readmes`: `0c9fe40e2992778d6969eaf380bef0d7dd079bad`. Pushed via fast-forward over the concurrent fixer's tip (`de9e80e5b`).

Self-improvement: when the contractor's PR-creation-flow scan has already moved the branch tip past the dispatch-prompt's named HEAD (because a weaver rebased in between), a fixer should `git fetch origin <branch>` and reset to the remote tip on entry rather than trust the prompt's pre-rebase SHA. Concurrent fixer dispatches on the same branch are also possible (this dispatch overlapped with one that landed `f2518bb38..de9e80e5b3` mid-flight) and a fetch right before push is the cheap defense against losing your work to a non-fast-forward reject.
