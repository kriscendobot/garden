---
ts: 2026-06-15T23:04:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--994622
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/Agoric/agoric-sdk/pull/12527#discussion_r3404720531
---

# dispatch: fixer — apply turadg's parameterized bundle-source type on PR #5 mirror

Upstream review comment (turadg on Agoric/agoric-sdk#12527, 2026-06-12T16:16Z, inline on `packages/SwingSet/tools/test-swingset.js:46`):

> Since [Apr 14](https://github.com/endojs/endo/commit/7f7ae8eac3672543190dc786b02d49453be72483) Endo has had a parameterized type https://github.com/endojs/endo/blob/a9d2341a1ed6abb1da5991d246335989bf68e22f/packages/bundle-source/src/types.ts#L81-L92

User directive (kriskowal on garden, 2026-06-15T22:57Z): apply turadg's comment to our mirror PR #5.

Prior fix (`255c705e9a fix(SwingSet): annotate bundleFromSourceSpec return type per copilot`) annotated the return as `Promise<EndoZipBase64Bundle>`. turadg's refinement: use Endo's now-parameterized type (which is generic over bundle format) instead of pinning to the zip-base64-specific shape.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `9216c5a936`.

## Task

In your `project/` worktree at `9216c5a936`:

1. Read `packages/SwingSet/tools/test-swingset.js` line ~46 (the bundleFromSourceSpec annotation site).
2. Look up Endo's bundle-source types at `node_modules/@endo/bundle-source/src/types.ts` lines ~81-92 (or wherever the parameterized type is now defined). The relevant type is parameterized — likely `BundleFromSourceSpecPower<T>` or similar.
3. Identify the parameterized API. It may look like `BundleFromSourceSpec` or `bundleFromSourceSpec` with a generic parameter for the bundle type (`EndoZipBase64Bundle | NestedEvaluateBundle | GetExportBundle` or similar).
4. Update the annotation at test-swingset.js:46 to use the parameterized type with the right type parameter rather than the bare `EndoZipBase64Bundle`. If the parameterized type permits inference at the call site, prefer that; otherwise specify explicitly.
5. Run `corepack yarn workspace @agoric/swingset-vat lint:types` (or the appropriate per-workspace check) to confirm clean.
6. Commit: `fix(SwingSet): use Endo's parameterized bundle-source type per turadg`.
7. Push: `git push origin HEAD:mirror/12527-endo-sync-refresh` (append only).
8. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Note turadg's upstream comment ID.
   - The refinement: from explicit `EndoZipBase64Bundle` to the parameterized type.
   - Commit SHA.
9. Do NOT post on upstream Agoric/agoric-sdk#12527 (boatman territory).

## Authorizations

- Push to `mirror/12527-endo-sync-refresh` (append only).
- Top-level comment on PR #5.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue CI failures (separate serial-fixer chain).
- Do NOT change the bundle-source choice itself; only the type annotation.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- The parameterized type identified + line-level change description.
- Local lint:types result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: fixer` — Class B (cosmic-swingset SIGHUP) pending CI on `9216c5a936`, per fixer cb7a05's report.

End your turn with a concise summary back to the orchestrator.
