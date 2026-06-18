---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 460
created_at: 2026-06-18T09:31:08Z
last_appended_at: 2026-06-18T09:31:08Z
status: parked
---

# Follow-ups for endo-but-for-bots#460

## Items

- [ ] Add `fast-check` property-based tests for security-critical sanitizers (`sanitizeUrl`, `sanitizeElementProps`, `coerceToSafeVNode`) covering arbitrary byte strings as URL values, attribute names, deeply nested vnode structures, and random prop bags.  
  **Source juror(s)**: fast-checker  
  **Round**: 1  
  **Recommended action**: add a `test:pbt` script with fast-check covering the three functions above; open follow-up PR targeting the preact-container package

- [ ] Move `_registerTrustedExitType` and `_registerSecureReentryType` to a `./internal` subpath export when the package is prepared for publish, so consumers do not take an accidental dependency on them.  
  **Source juror(s)**: curator  
  **Round**: 1  
  **Recommended action**: add `"./internal": { "types": "./src/internal.d.ts", "default": "./src/internal.js" }` to the exports map; move the two privileged extension functions there

- [ ] Add per-component endowment selection option to `confineComponent` for least-authority refinement.  
  **Source juror(s)**: locksmith  
  **Round**: 1  
  **Recommended action**: design a `confineComponent(fn, { endowments: ['h', 'useState'] })` API; open a design PR before implementing

- [ ] Restrict `peerDependencies` Preact range to `^10.0.0` (verified) or add a comment noting `^11.0.0` is unverified against the mangled internal names the package depends on.  
  **Source juror(s)**: migrator  
  **Round**: 1  
  **Recommended action**: update `package.json` peerDep range or add inline comment; no new PR needed — can be a direct commit
