---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 347
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: 3033
created_at: 2026-05-22T01:33:00Z
last_appended_at: 2026-05-22T01:33:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#347

Created from the barrister panel verdict (6 seats: typist, stylist, purist, assessor, changeset-auditor, releaser; in-band fallback; reduced composition matching the cleaner's same-PR carve-out) on the +2/-0 JSDoc-cast mirror PR. One follow-up warrants revisit at merge time; the rest of the panel's findings resolved as acknowledge.

## Items

- [ ] **`packages/ocapn/src/codecs/subtypes.js` lacks the `// @ts-check` directive that every sibling in `packages/ocapn/src/codecs/` carries.**
  **Source juror(s)**: typist.
  **Round**: 1.
  **Recommended action**: when this PR merges (or upstream mirror endojs/endo#3033 merges), sweep the `packages/ocapn/src/` tree (not just `subtypes.js`) for any `.js` file missing the `// @ts-check` directive. Five `codecs/` siblings (`components.js`, `descriptors.js`, `ocapn-pass-style.js`, `operations.js`, `passable.js`) carry the header; `subtypes.js` is the outlier in that directory. The root `tsconfig.eslint-base.json` sets `checkJs: true` so the check still runs project-wide; this is a file-local consistency nit rather than a correctness gap. File as a follow-up cleanup PR or as a single tree-wide commit on a later mirror PR with adjacent scope.
