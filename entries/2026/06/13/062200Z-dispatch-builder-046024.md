---
ts: 2026-06-13T06:22:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--046024
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/061802Z-result-researcher-0ddf1e.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/152200Z-result-researcher-d73da3.md
---

# dispatch: builder — implement the merged #439 formula-inspector design

User directive (2026-06-13T~06:11Z): "Please dispatch a
subagent to build the design landed at
https://github.com/endojs/endo-but-for-bots/pull/439"

Researcher `0ddf1e` produced the build-precedence references
+ recommended 4-cut commit ladder. **Read its result entry
in full** (`journal/entries/2026/06/13/061802Z-result-researcher-0ddf1e.md`)
before starting. The prior researcher `d73da3`'s broad
references are still mostly valid.

## What's being built

Per `designs/formula-inspector.md` (merged on `llm` as
`aaff6ebaa`):

1. **Host-only `EndoHost.getFormula(identifier)`** method on
   `HostInterface`, absent on `GuestInterface`.
2. **Drop `@info`** from host's special-names map. Retire
   `InspectorHubInterface` AND `InspectorInterface`. No
   deprecation alias.
3. **CLI verb `endo inspect <name-or-identifier>`** with
   `--identifier` and `--json` flags.
4. **Chat UI single-surface** (modal back face): gear icon
   flips Value → Formula, `F` + button flips back, inventory
   gear opens already-flipped, `Shift+P` for Enter Profile.
   Read-only at this stage.
5. **Promise-formula view**: status-split (pending /
   fulfilled / rejected); rejected fetches
   `E(host).traces().lookup(errorId)` on demand.
6. **No cycle unwinding** (principle of least surprise).

## Recommended commit ladder (per researcher)

1. **Daemon cut** (`master`): drop `@info`, add `getFormula`,
   retire `InspectorHubInterface` + `InspectorInterface`,
   types.d.ts sync, rewrite `endo.test.js:2377-2510` AVA
   tests + new per-type + guest-authority + cross-peer-
   locator tests.
2. **CLI cut** (`master`): `endo inspect <name-or-identifier>`
   with `--identifier` and `--json`. Integration test under
   `packages/cli/test/`.
3. **Chat cut** (`master`): new `packages/chat/src/formula-view-component.js`
   + `formula-view-registry.js`; edits to
   `packages/chat/src/value-component.js` (flip + F + back-
   stack + Escape-flip + Shift+P), `inventory-component.js`
   (gear icon), `chat.js` (DOM lines 95-128, wiring lines
   442-457 / 1734-1750), `index.css` (card-flip CSS
   variables + reduced-motion override). Unit + component
   (happy-dom) + e2e (Playwright) tests.
4. **Design-doc status bump** (`llm`): bump
   `designs/formula-inspector.md` status (Not-Started →
   In-Progress or Shipped); sync `designs/README.md`.

Cuts 1-3 land on `master`. Cut 4 lands on `llm`.

## Open questions surfaced by researcher

(Address by best-design-signal or document in PR body's
"Design departures" section.)

1. **`make-bundle` formula type**: the merged design's
   33-formula-type taxonomy includes `make-bundle`, but
   `packages/daemon/src/formula-type.js`'s canonical list
   omits it (count grew from 26 to 33). Verify the design's
   intent; either add the type or note the discrepancy.
2. **`Shift+P` modeline hint**: the design's `Shift+P` for
   Enter Profile should also be listed in the
   `chat-command-bar.md` design's modeline row. The builder
   shouldn't author this in `chat-command-bar.md` directly
   (that's a separate design's territory); flag for
   follow-up.
3. **Card-flip animation register**: no chat-wide animation
   register exists yet. Builder decides whether to introduce
   one or implement the flip with local CSS state.
4. **`inspectorId` allocation chain**: post-`@info` removal,
   the inspectorId allocation chain may be dead code. The
   builder confirms + removes if so.

## Task

In your `project/` worktree at endo-but-for-bots master
(`4a04d078b` — but the design lives on `llm` per the merge.
Reach the merged design via
`git show llm:designs/formula-inspector.md`).

Implementation order: follow the 4-cut ladder. Within each
cut, commit per logical step.

After all cuts land, **open a DRAFT PR** on the bot fork
targeting current `master`. Title:
`feat(daemon,cli,chat): drop @info name hub for
formula-inspector design (#439)`. Body follows
`.github/PULL_REQUEST_TEMPLATE.md`. Reference PR #439 as the
design predecessor.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to a new branch on the fork (builder
  chooses name, e.g., `feat/formula-inspector`).
- **Open the DRAFT PR**.
- **Top-level summary comment** at-mentioning `@kriskowal`.
- Do NOT mark the PR ready (judge un-drafts at gamut
  termination).

## Out of scope

- Do NOT touch packages outside daemon, cli, chat.
- Do NOT redesign anything; the merged
  `designs/formula-inspector.md` is the spec.
- Do NOT author changes to `chat-command-bar.md` for the
  Shift+P hint (flag as follow-up).
- Do NOT chase upstream typescript-go / tsgo issues.

## Deliverable

A `result` entry under `journal/entries/2026/06/13/`
naming:

- The new PR number/URL.
- The commit series per cut (SHA + scope per commit).
- The 4 open-question decisions.
- File-by-file change summary.
- Test results per package.
- pre-push-gates result.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` to start the
  gamut.

End your turn with a concise summary back to the orchestrator. The
orchestrator continues the gamut and tears down your dispatch
root on return.
