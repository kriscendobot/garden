---
title: The four regex patterns that shorten kept call-site strings in concise stack traces; the four ad-hoc rules that govern path-prefix dropping (`/.../`-bracketed prefix; bare-`.../`-prefix; pre-`packages/` monorepo path; `file://` vs `file:///` distinction with the VS-Code-clickability rationale); the agoric-sdk#2326 cross-thread linked in two of the four comment blocks; the unit-test-export discipline for shortenCallSiteString
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
---

## Abstract

The §middle cluster of `tame-v8-error-constructor.js` defines four regex patterns used to shorten kept call-site strings in *concise* stack traces. The four patterns and their rules: **CALLSITE_ELLIPSIS_PATTERN1** — *any likely-file-path or likely url-path prefix, ending in a `/.../` should get dropped*; example: `'Object.bar (/vat-v1/.../errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (errors/test/deep-send.test.js:13:21)'`. **CALLSITE_ELLIPSIS_PATTERN2** — *any likely-file-path or likely url-path prefix consisting of `.../` should get dropped*; the simpler form when the `.../` is at the path's start. **CALLSITE_PACKAGES_PATTERN** — *any likely-file-path or likely url-path prefix, ending in a `/` and prior to `packages/` should get dropped*; example: `'Object.bar (/Users/markmiller/src/ongithub/agoric/agoric-sdk/packages/errors/test/deep-send.test.js:13:21)'` simplifies to `'Object.bar (packages/errors/test/deep-send.test.js:13:21)'`. *Note that `/packages/` is a convention for monorepos encouraged by lerna.* **CALLSITE_FILE_2SLASH_PATTERN** — *any likely-file-path or likely url-path prefix of the form `file://` but not `file:///` gets dropped*. The §2slash rationale: *`file:///` usually precedes an absolute path which is clickable without removing the `file:///`, whereas `file://` usually precedes a relative path which, for whatever vscode reason, is not clickable until the `file://` is removed*. The four patterns are tried *in order*: the first matching pattern's capture-groups define the kept-parts; if no pattern matches, the original string is returned unchanged. The `shortenCallSiteString` function is *exported only so it can be unit tested* (same convention as §1's `filterFileName`).

## Body

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

## Connection to the wider library

This section is the **canonical worked example of *path-shortening via ordered regex patterns*** at the SES error layer. Three threads:

1. **The first-match-wins-via-ordered-list pattern**. Each pattern is more or less specific; the first that matches captures the intended transformation. Reusable for any rewriting pipeline where multiple patterns might apply but only one should fire per input.

2. **The `agoric-sdk#2326#issuecomment-773020389` cross-thread linking discipline**. The patterns reference the GitHub discussion where they were designed. Future maintainers reading the code can follow the link to understand *why* these patterns were chosen.

3. **The export-for-testability + non-API-status comment pair**. Both `filterFileName` and `shortenCallSiteString` are *internal*-but-*exported* with the `// Exported only so it can be unit tested.` comment. The pattern signals *don't depend on this from outside the package*.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Four ad-hoc regex patterns for path shortening | Heuristic rewriting; good-enough for common cases. |
| `/.../` ellipsis marker convention | A shorthand for *path-here-was-elided*; widely used in error messages, debuggers, logs. |
| `packages/` prefix as monorepo convention | The de-facto monorepo path layout (lerna, yarn workspaces, pnpm workspaces). |
| `file:///` clickable vs `file://` not — *whatever vscode reason* | Honest-about-empirical-discovery; documents the workaround without claiming the underlying cause. |
| First-match-wins via for-loop | Standard ordered-pattern dispatch. |
| `// Exported only so it can be unit tested.` | Non-API export signal; common across the corpus. |
| Cross-thread link in code comment | The *historical-context-pointer* discipline; preserves design rationale beyond the commit message. |

## See also

- [[hardened-javascript]] (topic) — the SES substrate.
- [[errors]] (topic) — the broader SES error-handling surface.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors` — the prior section in this source: the permit list + filename-censors that decide *whether* a frame is kept.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns` — the next section: how the tameV8ErrorConstructor function wires the attenuation into V8's `Error.prepareStackTrace` hook.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the complementary pass-style-side V8-stack-accessor work.

## Common confusions

- **"The four patterns are too ad-hoc."** They are *deliberately* ad-hoc — concise stacks are optimized for human readability, not formal correctness. A formal grammar for *path-likely-to-shorten* would be over-engineered for the use case. The patterns serve the common cases (Node monorepos, file://-prefixed paths, ellipsis conventions) and fall through cleanly when they don't apply.
- **"The order of the patterns matters — that's fragile."** It does, but it's the *intentional* order: more specific patterns first, more general patterns later. The order is part of the design, not an implementation accident.
- **"`/packages/` is specific to lerna."** The comment names this — *Note that `/packages/` is a convention for monorepos encouraged by lerna*. The pattern works for any monorepo using the convention (yarn workspaces, pnpm workspaces, nx, turborepo all default to `packages/`). The pattern *doesn't apply* to non-`packages/`-rooted monorepos (e.g. `apps/...` or `services/...`), but the fall-through to unchanged-string is the right outcome there.
- **"`file://` vs `file:///` distinction is fragile."** It is *VS-Code-specific* and *empirically discovered*. The author documents the workaround honestly. If VS Code's URL detection changes, this pattern might need adjustment — but that's a known sensitivity, not a hidden bug. Other terminals (e.g. iTerm2) might treat both forms uniformly; the workaround is conservative.
- **"`agoric-sdk#2326#issuecomment-773020389` is a brittle link."** GitHub issue URLs are *long-lived but not immortal*. The link preserves the design-discussion-thread for as long as the issue exists. If the issue moves or is archived, future maintainers would need to follow the redirect or check the comment-archive. The link is *worth-having-even-if-fragile* — better than no record.
- **"The TODO about lockdown options is just deferred work."** It is — and the deferral is *deliberate*. Until a concrete use case demands user-configurable censor/pattern lists, the hardcoded defaults serve. The TODO records that the design surface is *known* to be limited and *intentionally* limited until the use case arrives.
