---
slot: 2
status: in-flight
design_path: designs/hardened-url-shim.md
pr_number: 263
current_stage: fixer
in_flight_dispatch: 4bf911
last_update: 2026-05-15T05:02:00Z
started_at: 2026-05-15T04:09:00Z
host: endolinbot
---

Cleaner `924af9` returned at 04:58Z with 5 coverage tests (head
`9acdcc4f0`) and SES suite green (525/525). But 2 real CI reds:

1. **lint**: `packages/ses/src/get-anonymous-intrinsics.js:188` —
   builder's `new globalThis.URLSearchParams().entries()` triggers
   `@endo/no-polymorphic-call`. Add a disable comment (the file already
   has 5 similar ones).
2. **browser-tests** (Chromium): same `cauterize-property.js` bug
   sibling PR #259 fixed. The fix `b2a3657fc` is on `feat/hardened-text-codecs-shim`
   but not yet on master. Cherry-pick `b2a3657fc` onto `feat/hardened-url-shim`
   (or wait for #259 to merge).

Next-stage-owed: fixer. The fixer's brief covers both. After CI green,
judge dispatches.

Dispatch root: `dispatches/fixer--4bf911`.
