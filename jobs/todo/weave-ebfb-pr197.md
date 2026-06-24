# Weave (rebase) endo-but-for-bots #197 onto current `llm`; re-land ESM if needed

**Maintainer decision (2026-06-24): CONTINUE this PR** (not supersede). This
authorizes the rebase + re-land effort the botanist gated on maintainer
confirmation (see `jobs/tada/botany-ebfb-pr197.md`).

Repo: `endojs/endo-but-for-bots`, PR **#197** (electron 40.9.3 → 42.0.1 + a
maintainer-directed ESM migration). Wear the **weaver** role
(`roles/weaver/AGENT.md`).

## Context from the botany report (do not re-derive)

- #197 began as the dependabot electron bump (`cf4f1ccc98`) but was **commandeered
  by kriskowal's ESM migration**: commits `35eff1d9f8` (preload→ESM) and
  `ed5542dd89` (drop CJS shims) are **maintainer-authored**. **Preserve that
  intent** — do not discard the ESM work.
- Branch is **888 commits behind `llm`**, `mergeable: CONFLICTING`/`DIRTY`;
  Dependabot disabled auto-rebase. The lockfile **will** conflict, and the ESM
  rework was authored against a ~5-month-old tip, so expect **more than a
  mechanical lockfile rebase**.
- Dependency substance is already clean and mature (electron 42.0.1, 47 days old,
  no GHSA/OSV advisory) — so the only blocker is staleness, which this rebase
  resolves.

## Task

1. Confirm the PR's current base branch (the botany report says `llm`, tip
   `6da436b676` — verify the live tip) and **rebase #197 onto it**. Resolve the
   lockfile conflict per `skills/conflict-resolution` / yarn-lock discipline.
2. **If the rebase is more than mechanical** (the ESM migration conflicts
   substantively against 5 months of drift), **escalate to re-land the ESM work**
   on the rebased base — wear/escalate to a **builder/fixer** to re-apply the
   preload→ESM conversion and CJS-shim removal faithfully to kriskowal's intent,
   rather than forcing a broken mechanical rebase. (This is the standing
   weaver-impasse → fixer/builder escalation; you are pre-authorized to carry it
   through rather than stopping at the impasse.)
3. Keep the electron 40→42 bump intact as the dependency basis.
4. Push the rebased head to the PR branch (detached-HEAD style,
   `git push --force-with-lease origin HEAD:<pr-branch>`), under the **bot
   identity**. This is a bot-fork PR branch — no identity switch, no ferry.

## After the rebase lands — post the downstream follow-ups

This PR's chain is rebase → shepherd → re-botany. On success, **post two jobs** so
the chain continues (deterministic basenames; idempotent):
- `shepherd-ebfb-pr197` — drive the rebased head's CI to green (the recorded green
  rollup was stale, from 2026-05-12 against the old head).
- `re-botany-ebfb-pr197` — once CI is green, re-run the botanist for the **terminal
  MERGE-NOW/REJECT** verdict (cheap: substance is already vetted clean and mature;
  just confirm the rebase didn't pull a newer electron and re-run OSV against the
  final moved set). Authorize it to comment/merge/close per the (updated) botanist
  role.

## Definition of done

#197 rebased onto current base with the ESM work preserved (re-landed if the
rebase wasn't mechanical), force-pushed to the PR branch under the bot identity,
and the `shepherd-ebfb-pr197` + `re-botany-ebfb-pr197` follow-up jobs posted.
Report the new head SHA, whether a builder/fixer re-land was needed, and the
conflict resolution. If you cannot complete the rebase (e.g. the ESM re-land is
too large for one job), report the precise state and post a scoped builder job
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
