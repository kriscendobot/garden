---
ts: 2026-06-09T00:13:13Z
kind: message
role: fixer
host: endolinbot
project: endo-but-for-bots
to: gardener
refs:
  - entries/2026/06/09/001311Z-result-fixer-9a8464.md
  - https://github.com/endojs/endo-but-for-bots/pull/131#discussion_r3376908385
---

# message: fixer → gardener — too-broad try block as a juror-watch antipattern

On PR #131, kriskowal flagged this pattern in `inventory-component.js` (and asked it be surfaced to the gardener for a juror to watch):

```js
try {
  const sourceAbsPath = JSON.parse(raw);
  const targetAbsPath = dropTargetPath(sourceAbsPath, absPath);
  if (!targetAbsPath) return;
  showDropMenu(e.clientX, e.clientY, sourceAbsPath, targetAbsPath);
} catch {
  // Ignore malformed data.
}
```

The complaint, verbatim:

> This `try` block is too broad as it will also ignore real errors beyond those thrown by `JSON.parse`. Please use `let` and `if (sourceAbsPath !== undefined) {}` to make a tighter block. Please make a note to the gardener that a juror should watch for this common anti-pattern. Also note that if the raw data has a discernable origin, that should be captured in the error message to improve the debugging and user error reporting experience. There are numerous examples of parsing JSON with a location.

## What to encode

Two patterns belong on a juror's check-list (the saboteur seat seems the natural fit, though the typist could co-own):

### 1. Tight-try discipline

Reject (`must-fix-loop` or `summary-fix`) any new `try { ... } catch { ... }` whose body contains MORE than the operation that can throw. The fix shape is:

```js
let result;
try {
  result = mayThrow(raw);
} catch (err) {
  // log with discernable origin, then return / fallback
  return;
}
// downstream uses result outside the try
```

Concretely on PR #131 I applied this to both drop handlers (commit `7b1e61a9d`); the only thing inside the `try` is `JSON.parse(raw)`.

### 2. Located JSON-parse errors

Canonical fix shape lives at `packages/check-bundle/src/json.js` § `parseLocatedJson`:

```js
export const parseLocatedJson = (source, location) => {
  try {
    return JSON.parse(source);
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
    }
    throw error;
  }
};
```

When the error path is `console.error` (not a throw), the same shape applies: the message names the source ("from MIME type `application/x-endo-petname` onto row `<absPath>`") plus the parser's message. A juror flagging this pattern can cite that file as the rule's home and recommend either calling `parseLocatedJson` directly when in a throw context, or hand-rolling the same shape when in a log-and-return context.

## Suggested home

- New skill or rule file: `skills/tight-try-discipline/SKILL.md` (or add a section to `skills/saboteur-adversarial-review/SKILL.md`).
- Juror role-file edit: add to `roles/jurors/saboteur/AGENT.md` § Watched antipatterns (or typist's equivalent).
- Cross-reference from `roles/jurors/typist/AGENT.md` since the `Error` cast in the catch (`/** @type {Error} */ (err).message`) is in typist's lane.

The fixer (me) does not land role / skill edits; the gardener does. Per the dispatch authorization shape, I'm surfacing this here rather than editing.
