# Re-architect the GitHub Pages bulletin: CI-generated, not committed to main2

Maintainer directive on kriskowal/garden #10 (folds into / supersedes the
`build-github-pages-bulletin` deliverable):

> Committing to main2 is off limits. It should be possible to set up a CI
> workflow in main2 that is triggered by changes landed on journal2.

The prior build landed `docs/bulletin/` (8 files) as committed content on
`main2` (commit `6454719ec`), which crossed this directive in flight. Re-do the
bulletin so that **no rendered/deployed content is committed to `main2`** — the
bulletin is generated and published by a CI workflow instead.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-10
issue_url: https://github.com/kriskowal/garden/issues/10#issuecomment-4826648086
submitter: kriskowal
----- END ISSUE NOTE -----

## Deliverable

A short revised design note FIRST (resolve the two real constraints below),
then the implementation. Garden-infra work, no PR. Develop in an isolated
worktree off `origin/main2`; **do not edit the root checkout.**

## What to build

1. A GitHub Actions workflow committed to `main2` (this is the "CI workflow in
   main2" the maintainer explicitly endorses — only *content* is off limits,
   not the workflow file) that:
   - reads the live bulletin from `journal2` (`README.md` + the maintainer
     inbox under `inbox/maintainer/unread/`),
   - renders it to a static site, and
   - publishes to GitHub Pages **via the Pages-from-Actions path**
     (`actions/configure-pages` + `actions/upload-pages-artifact` +
     `actions/deploy-pages`) so nothing is committed anywhere — this is the
     cleanest reading of "committing to main2 is off limits."
2. Preserve the issue's original feature: each maintainer-inbox message gets a
   reply box that commits an acknowledgement/reply to `journal2` (route to the
   message's `reply_to` doer, fall back to the liaison's inbox, archive the
   original unread→read). This stays pure client-side JS using a pasted
   fine-grained PAT (the prior build already solved this in
   `docs/bulletin/{app,github,markdown}.js` — reuse those assets as workflow
   *inputs*, not as deployed-from-branch content).

## Two constraints the design note MUST resolve

1. **Trigger mechanics (the real wrinkle).** For a `push` event, GitHub runs the
   workflow file *from the pushed branch's ref* — so a workflow on `main2` will
   NOT fire on a push to `journal2` unless the YAML also lives on `journal2`.
   `journal2` is a large orphan branch we'd rather not put a workflow on.
   `main2` IS the default branch, so events that always use the default-branch
   workflow — `repository_dispatch`, `workflow_dispatch`, `schedule` — DO work
   from `main2`. Recommended: workflow on `main2` triggered by
   `repository_dispatch` (type e.g. `journal2-updated`) fired by the existing
   journal2-push machinery after a successful push, plus `workflow_dispatch`
   (manual) and a low-frequency `schedule` safety net. The design note picks and
   justifies the trigger path and wires the dispatch from whatever pushes
   `journal2`.
2. **Where the client-side app source lives.** The reply-box JS/HTML/CSS must
   live somewhere for the workflow to assemble into the Pages artifact. Decide
   and justify: keep minimal app *source* in `main2` (it is build input copied
   into the artifact, not deployed-from-branch content — arguably consistent
   with the directive) vs. generate everything in the workflow. State the
   tradeoff explicitly in the note so the maintainer can veto.

## Clean up the crossed-in-flight commit

`docs/bulletin/` on `main2` (`6454719ec`) is the now-superseded committed-content
approach. As part of this re-architecture, remove the deployed-content files
(keeping any JS reused as workflow input per constraint 2) so `main2` no longer
carries the rendered site. Note in the design note exactly what was removed vs.
repurposed.

## Report back

Comment the outcome on the issue thread (issue_url above) — never close the
issue, the submitter does that. Include: the workflow's trigger path, the Pages
config the maintainer must set (Settings → Pages → Source = GitHub Actions), any
one-time human credential step, and what was removed from `main2`.

---
claim:
  host: endolinbot
  gardener: 32
  claimed_at: 2026-06-28T16:15:28Z
