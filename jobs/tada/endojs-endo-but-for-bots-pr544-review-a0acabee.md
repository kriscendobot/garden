Inbox empty, worktree cleaned up, PR #570 confirmed open as draft against `llm`.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots #544 (erights). The whole review was a single ask: "Please write the mechanical follow-on PR that this PR describes." No inline comments were tied to the review (verified via the comments API).

**What #544 describes:** an intra-package plain-re-exports *design* (design + CONTRIBUTING entry only, no source moves). The follow-on it asks for is a repoint-and-remove pass: import names from the defining module, and delete internal pass-through modules that no `"exports"` entry reaches.

**What I did:**
- Built a monorepo-wide analyzer over all 93 packages (resolving each package's `"exports"` surface) to find genuine intra-package plain re-exports, treating every fetched body as untrusted data.
- Key finding: the *reach-back* examples the design names (`tool-gate.js`'s `ChatEvent`, `errors/rejector.js`'s `Fail`, `lal/tools/*`'s `LalToolDef`) **already import from their defining module** — those names are `@typedef`'d in / defined by the `index.js` they import from — so nothing to repoint. The bulk of remaining `../index.js` imports are **test files** exercising the public surface (intentional, out of scope).
- The genuine, clean corollary-2 removals were in `genie` (the design's example package): repointed `src/index.js` at the defining `utils/tokens.js` and removed two non-`exports` plain re-export barrels — `utils/index.js` (single pass-through) and the dead `tools/index.js` (zero importers). Kept documented multi-module sub-barrels (interval/heartbeat/observer/reflector/system) as seams the design defers.
- Verified statically (no installed deps in worktree): all re-export targets resolve, `estimateTokens` is exported by the new target, no dangling references, `node --check` parses. No public surface or version change.

**Output:**
- Draft PR **endojs/endo-but-for-bots#570** against `llm`, scoped to `genie` as the first per-package installment, body documenting scope + the definer-import finding.
- Reply comment on #544 linking #570 and flagging that the design's named reach-back examples are already definer-imports (worth amending).

**Follow-ups for the maintainer / subsequent PRs:**
- The design's "examples in the current tree" reach-back cases are non-actionable as written — consider amending them.
- Remaining per-package work is thin: a few internal sub-barrels (e.g. `agentry/.../stage-and-commit`, `ocapn cbor/diagnostic`) are candidates but involve directory-import resolution and are judgment calls; test-file imports of the public barrel are deliberately excluded.

No changes to the garden repo itself were needed (all work landed on the project repo via PR), so nothing was pushed to `main2`.
