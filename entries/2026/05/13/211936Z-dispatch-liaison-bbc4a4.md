---
ts: 2026-05-13T21:19:36Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/playground
    pr: 14
    role: source
---

# Dispatch: builder turns endojs/playground#14 (rps) into an Endo-plugin demonstration

Dispatch root: `dispatches/builder--rps-demo-distributed-game--20260513-211957--bbc4a4/`. Builder first engagement; pr-creation-flow draft discipline applies.

Task: collect the "rps" tool from `https://github.com/endojs/playground/pull/14` and turn it into a well-documented and tested demonstration of creating Endo daemon plugins for a distributed game. The deliverable is a draft PR on `endojs/endo-but-for-bots:llm`.

Procedure:

1. Read the playground PR: `gh pr view 14 -R endojs/playground --json files,headRefOid,baseRefName,body,title`; `gh pr diff 14 -R endojs/playground | head -500` and similar `gh api` calls as needed to inspect the source.
2. Identify the rps tool's shape (game logic, the Endo daemon plugin integration points, the distributed-game protocol). Note that the source is in `endojs/playground`, which has no formal package conventions; you will need to author proper package structure on the destination side.
3. Author the demonstration in `endo-but-for-bots` (your project worktree is checked out at `llm`):
   - New package at `packages/rps-demo/` (or similar slug — builder picks; consider `packages/demo-rps/` if a `packages/demo-*` convention emerges).
   - Source code adapted from the playground PR, organized as a proper Endo daemon plugin.
   - Documentation: README explaining what the demo shows, how to run it, and what the maintainer should look at to understand "how to author an Endo daemon plugin for a distributed game."
   - Tests covering the core game logic and the plugin integration. Use the project's existing test framework (likely `ava`).
4. Identity kriscendobot. Per pr-creation-flow: open in **draft**.
5. Push to a topic branch `feat/rps-demo` on `endojs/endo-but-for-bots`; open the draft PR against `llm`.
6. PR title: conventional-commits, e.g. `feat(rps-demo): Endo daemon plugin demonstration as a distributed game (from endojs/playground#14)`. Body: name the source PR, summarize the demo's purpose, list the testing approach.

Out of scope:
- Do not file anything on `endojs/playground` upstream.
- Do not bring over playground's larger structure; this is a focused mirror-and-rework into a teaching demo, not a wholesale port.
- Do not run CI watchers; shepherd handles that in a follow-up if the maintainer requests it.

Report: PR URL, package path, test files added, one-paragraph summary of what the demo teaches and what was adapted vs preserved from the source.
