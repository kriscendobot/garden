**Verdict:** request-changes

**Findings:**
- `src/queue.js:41` — the JSDoc for `drainQueue` says it "empties the queue and returns the items", but it returns them in insertion order, which the prose does not say. Reword to "returns the drained items in insertion order". The code is correct; only the comment is imprecise. [rule: skills/no-latin-shorthand/SKILL.md]
- `src/queue.js:12` — the module comment says "e.g." where house style prefers "for example". [rule: skills/no-latin-shorthand/SKILL.md]
