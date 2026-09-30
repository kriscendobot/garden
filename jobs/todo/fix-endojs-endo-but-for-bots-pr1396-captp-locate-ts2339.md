---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1396
---

# Fix TS2339 lint break in #1396 and restack the SturdyRef stack above it

endojs/endo-but-for-bots PR #1396 (head `build/sturdyref-captp-construct`, commit
7a341141ca "test(captp,ocapn): cover SturdyRef-from-data validation branches")
adds `packages/captp/test/sturdyref.test.js:264`:

    await t.throwsAsync(() => E(locator).locate(1), { ... })

which fails the root and workspace TypeScript checks (and the typedoc "build API
docs" step) in CI lint:

    error TS2339: Property 'locate' does not exist on type 'EMethods<Required<unknown>>'.

(Seen on #1398's CI run 36701856416, head 8b57a39; #1396 itself has had no CI run
on 7a34114.) Fix it on #1396's head (for example, type `locator` with a JSDoc cast
so `E(locator).locate` type-checks, or match how neighboring tests in the file
type their locators), run the repo-root `tsc -p tsconfig.json` and
`yarn workspace @endo/captp lint:types` locally, and push with
safe-push-pr-head.sh. Then restack the layers above it so they carry the fix:
#1397 (`build/sturdyref-ocapn-enliven`) and #1398 (`build/sturdyref-daemon-formula`),
moving each PR's frozen base as needed. Confirm #1398's lint job goes green.
