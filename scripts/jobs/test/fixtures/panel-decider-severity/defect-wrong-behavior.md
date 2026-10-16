**Verdict:** request-changes

**Findings:**
- `src/queue.js:48` — the loop runs `for (let i = 0; i < items.length - 1; i += 1)`, so `drainQueue` drops the last queued item and the caller never sees it. This is an off-by-one that loses data on every drain. [rule: roles/jurors/breaker/AGENT.md]
