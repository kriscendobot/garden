---
title: E.get and E.sendOnly
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, captp]
status: current
---

> Abstract: Less-common Core API operations. E.get(target).property eventually reads a property; useful for reaching into a remote record. E.sendOnly(target).method(args) sends a one-way message with no expected reply; useful for fire-and-forget notifications where the receiver may not exist or the sender doesn't care about the result.

### E.get(target).property

Eventual get: retrieve a property, returning a promise for its value.

```javascript
const config = harden({
  timeout: 5000,
  retries: 3
});

const timeoutP = E.get(config).timeout;
const timeout = await timeoutP;  // 5000
```

Useful for accessing properties on remote objects or promises.

### E.sendOnly(target).method(...args)

Fire-and-forget: send a message without waiting for or receiving the result.
Returns `undefined` immediately.

```javascript
const logger = makeLogger();

// Send log message, don't wait for result
E.sendOnly(logger).log('Event occurred');
// Continues immediately, logging happens eventually
```

**When to use:**
- Don't need the return value
- Want to optimize latency (no promise creation)
- Logging, notifications, fire-and-forget operations

**Note:** You won't get errors if the method fails.
Use regular `E()` if you need error handling.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
