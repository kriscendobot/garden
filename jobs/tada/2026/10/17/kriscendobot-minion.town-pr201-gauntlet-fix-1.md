# Gauntlet FIX round 1: kriscendobot/minion.town #201

The panel's must-fix items are fixed and pushed to the PR head as `9935a16`. CI has not run yet: after about 56 minutes of waiting, `ci-wait-merge` returned rc 4 with all 3 checks pending. The runner is online and busy, but this PR's run is still queued behind 5 others (the oldest from 11:46Z).

## Must-fix items
- **locksmith / warden (bare `Far`):** the clip power in `src/endo/gateway/new-clip.ts` is now a `makeExo` with an `M.interface` guard:
  - paths must be arrays of strings;
  - forms and app types must be one of the known names;
  - text and locator arguments must be strings;
  - `getForm` takes at most one optional path.

  The hand-written checks inside each method stay as a second layer.
- **wire-watcher / saboteur (`acceptInvitation`):** I removed it from the public power, and with it the power's access to the guest agent. The power now reaches only its own space. Accepting invitations waits for a credential only the owner holds (#88). I removed it everywhere: the "+" creator in `model.js`, the design doc, the dev harness's `/invitation` route, and the demo.
- **typist:** `main.js` now uses `/** @import { Creator } from './model.js' */` instead of an inline `import()` type. Two typist-hostile characters are now ASCII: the en dash in the name-length message and the `…` in the locator placeholder.
- **coverage-auditor (browser demo not in CI):** `.github/workflows/test.yml` gains a step that runs `dev/new-clip-browser-demo.mjs` inside the `mcr.microsoft.com/playwright:v1.64.1-noble` image. The runner user has no sudo to install Chromium's system libraries, so the image supplies them. Under CI the demo now fails, rather than quietly skipping, when `ENDO_CHECKOUT` is unset. I raised the job timeout from 15 to 25 minutes.

## Should-fix and pruner items also done
- `makeApp` now removes the half-made directory if a later step fails.
- The daemon test now covers hostile inputs:
  - bad path segments: `.`, empty, a name with `/`, a NUL byte, `@agent`, and a path 17 segments deep;
  - a path that isn't an array, non-string text, text over 64 KiB, an unknown app type, extra arguments, and a call to the removed `acceptInvitation`.
- The power's header now says that kind labels and app markers come from untrusted writers.
- I cut the narrating comments in the demo, `model.js` and `main.js`. The design doc's authority and verification sections are now short pointers.
- The PR body is down from about 1,050 words to 360.
- I kept the silent fallback in `selectWorkerName`, but explained it in a comment rather than adding a warning. The pinned daemon rejects `"@main"` on every mint, so a warning would fire every time.

## Local checks, all on the pinned Endo commit
- Typecheck is clean and `test/new-clip.test.ts` passes 15/15.
- The real-daemon test `test/new-clip-daemon.test.ts` passes 2/2.
- The browser demo passes 18/18 checks in Chromium.
- In the full `npm test`, only `git-remote/capability.test.ts › propagates a git failure` fails. That failure comes from the garden's `git` wrapper on the PATH and isn't caused by this PR.

## Follow-ups
- **Risk on the next CI run:** the new Docker step has never run on the runner, because there is no Docker here to try it. If it fails, look first at the image's Node version or at running the container as the runner's user ID.
- **Deferred, not implemented:** a cap on how many entries and bytes a space can hold (saboteur), since any URL holder can write to it. It is listed under follow-ons in the design doc and the PR body.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4953553 cached reads)
- Output: 29850 tokens
- Cost: $2.616198600000001
- Wall-clock: 3680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
