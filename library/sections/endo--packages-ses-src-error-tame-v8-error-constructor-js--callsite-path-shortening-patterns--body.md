---
title: Body
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "124-210 (CALLSITE_ELLIPSIS_PATTERN1/2 + CALLSITE_PACKAGES_PATTERN + CALLSITE_FILE_2SLASH_PATTERN + shortenCallSiteString)"
topics: [hardened-javascript, errors]
status: current
notes: |
  The middle section of `tame-v8-error-constructor.js` defines four
  regex patterns that *shorten* kept stack-frame strings in concise
  mode. Each pattern encodes one ad-hoc rule for which path-prefix to
  drop. The rules are *deliberately heuristic* — concise stacks are
  optimized for human readability rather than completeness — and each
  is documented with a worked before/after example. Two of the four
  comments link to `agoric-sdk#2326#issuecomment-773020389`, the
  cross-thread where the patterns were originally argued. The four
  patterns and the `shortenCallSiteString` function pair with the §1
  filename-censor mechanism: filename-censoring decides *whether* a
  frame is kept; pattern-shortening decides *how much path* to show in
  the kept frame's stringification.
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns
---

### §CALLSITE_ELLIPSIS_PATTERN1 — drop `/.../-`bracketed path prefix

The §first pattern:

```js
const CALLSITE_ELLIPSIS_PATTERN1 = freezeRegexp(
  /^((?:.*[( ])?)[:/\w_-]*\/\.\.\.\/(.+)$/,
);
```

The rule: *any likely-file-path or likely url-path prefix, ending in a `/.../` should get dropped*.

Worked example:

> `'Object.bar (/vat-v1/.../errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (errors/test/deep-send.test.js:13:21)'`

The structural reading:

- The pattern's first capture group `((?:.*[( ])?)` captures the *prefix-before-the-path* — typically `'Object.bar ('` (function-name + space + opening paren) but possibly empty.
- The middle `[:/\w_-]*\/\.\.\.\/` matches the path-prefix that ends in `/.../`. The path-prefix can contain `:`, `/`, word characters, `_`, or `-` — common path components.
- The second capture group `(.+)$` captures the *path-after-`/.../`* — typically `'errors/test/deep-send.test.js:13:21)'`.
- The `arrayJoin(arraySlice(match, 1), '')` (in `shortenCallSiteString`) concatenates the first and second capture groups, dropping the matched-but-not-captured middle.

The *likely-file-path* heuristic is *good enough for the common case*. False positives (paths that contain `/.../` legitimately) are rare; false negatives (paths that should be shortened but aren't) fall through to the next pattern.

The §inline link to `agoric-sdk#2326#issuecomment-773020389` records the design discussion. The pattern was hashed out in a GitHub thread; the link preserves the historical context.

### §CALLSITE_ELLIPSIS_PATTERN2 — drop bare `.../`-prefix at start

The §second pattern:

```js
const CALLSITE_ELLIPSIS_PATTERN2 = freezeRegexp(/^((?:.*[( ])?)\.\.\.\/(.+)$/);
```

The rule: *any likely-file-path or likely url-path prefix consisting of `.../` should get dropped*.

Worked example:

> `'Object.bar (.../errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (errors/test/deep-send.test.js:13:21)'`

The structural difference from PATTERN1:

- **PATTERN1** matches `<prefix-with-content>/.../<suffix>` — the `/.../` is *embedded* in a longer path.
- **PATTERN2** matches `.../$<suffix>` — the `.../` is *at the start* of the path.

The two patterns are *complementary*: PATTERN2 handles the case where the path was already shortened externally and ships with the `.../` prefix; PATTERN1 handles the case where the path is full and contains a `/.../` middle. Both produce the same kept-suffix.

The agoric-sdk#2326 link is repeated for this pattern, indicating they were designed together in the same thread.

### §CALLSITE_PACKAGES_PATTERN — drop everything before `packages/`

The §third pattern:

```js
const CALLSITE_PACKAGES_PATTERN = freezeRegexp(
  /^((?:.*[( ])?)[:/\w_-]*\/(packages\/.+)$/,
);
```

The rule: *any likely-file-path or likely url-path prefix, ending in a `/` and prior to `packages/` should get dropped*.

Worked example:

> `'Object.bar (/Users/markmiller/src/ongithub/agoric/agoric-sdk/packages/errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (packages/errors/test/deep-send.test.js:13:21)'`

The §note about monorepos:

> Note that `/packages/` is a convention for monorepos encouraged by lerna.

The structural reading:

- The pattern's middle `[:/\w_-]*\/` captures the absolute-path prefix (e.g. `/Users/markmiller/src/ongithub/agoric/agoric-sdk/`).
- The capture group `(packages\/.+)` captures the *workspace-relative path* (e.g. `'packages/errors/test/deep-send.test.js:13:21)'`).
- The concatenation drops the absolute path and keeps the workspace-relative path.

The monorepo-convention note acknowledges *why this pattern works*: lerna (and yarn workspaces, pnpm workspaces, etc.) standardize on `packages/<workspace-name>/...` paths. The pattern leverages that convention to surface *workspace-relative* paths in concise stacks — far more useful for debugging than absolute developer paths.

### §CALLSITE_FILE_2SLASH_PATTERN — strip `file://` (but not `file:///`)

The §fourth pattern:

```js
const CALLSITE_FILE_2SLASH_PATTERN = freezeRegexp(
  /^((?:.*[( ])?)file:\/\/([^/].*)$/,
);
```

The rule: *any likely-file-path or likely url-path prefix of the form `file://` but not `file:///` gets dropped*.

The §rationale:

> The reason is that `file:///` usually precedes an absolute path which is clickable without removing the `file:///`, whereas `file://` usually precedes a relative path which, for whatever vscode reason, is not clickable until the `file://` is removed.

The structural reading:

- **`file:///` (three slashes)** — followed by an *absolute path*. VS Code's terminal recognizes `file:///` URLs and makes them clickable. The pattern *does not match* this case (the third slash bars the match).
- **`file://` (two slashes followed by non-`/`)** — followed by a *relative path*. VS Code's terminal does *not* recognize this as a clickable URL. The pattern matches and drops the `file://` prefix, leaving the relative path clickable.

The *whatever vscode reason* note is *honest-about-empirical-discovery* — the author doesn't claim to understand VS Code's URL-detection logic, but documents the practical workaround. This pairs with the §1 *Seems to suppress builtins like Array.every (<anonymous>)* discipline.

### §The shortenCallSiteString function

The §closing function applies the four patterns in order:

```js
export const shortenCallSiteString = callSiteString => {
  for (const filter of CALLSITE_PATTERNS) {
    const match = regexpExec(filter, callSiteString);
    if (match) {
      return arrayJoin(arraySlice(match, 1), '');
    }
  }
  return callSiteString;
};
```

The structural reading:

1. **Loop through `CALLSITE_PATTERNS`** in the order defined (PATTERN1, PATTERN2, PACKAGES, FILE_2SLASH).
2. **First match wins** — `regexpExec` returns the match info for the first pattern that matches.
3. **Concatenate capture groups** — `arraySlice(match, 1)` drops the full-match (index 0) and keeps the capture groups; `arrayJoin('')` joins them into the shortened string.
4. **No-match fallback** — if no pattern matches, return the original `callSiteString` unchanged.

The *first-match-wins* ordering is significant: PATTERN1 is most specific (drops a `/.../`-bracketed middle), PATTERN2 is less specific (drops a `.../`-prefix-at-start), PACKAGES is heuristic (drops everything before `packages/`), and FILE_2SLASH is engine-specific (drops `file://`). The order moves from most-specific to most-general; the first match captures the intended shortening.

The `// Exported only so it can be unit tested.` comment again signals *non-API status* — the function is exported for testability, not as a public API.

### §The TODO: future-work-tracked-in-comment

The same `// TODO Enable users to configure CALLSITE_PATTERNS via lockdown options.` comment as in §1's filename-censors. The two TODOs are parallel:

- §1: `// TODO Enable users to configure FILENAME_CENSORS via lockdown options.`
- §2 (this section): `// TODO Enable users to configure CALLSITE_PATTERNS via lockdown options.`

Both record the same future-work-direction: *the censor/pattern lists should be user-configurable*. The hardcoded lists serve the common case; future work makes them adjustable per-application.
