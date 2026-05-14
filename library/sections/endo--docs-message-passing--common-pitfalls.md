---
title: Common Pitfalls
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, marshal, patterns]
status: current
---

> Abstract: Bugs that recur in code written against this model: forgetting to harden(), passing a non-passable, confusing E() with .then(), pattern mismatches in method guards, identity assumptions that break across the wire. Each pitfall is paired with its diagnostic symptom and the fix.

## Common Pitfalls

### Forgetting M.callWhen() for Async Methods

**Problem:**
```javascript
const FetcherI = M.interface('Fetcher', {
  // Wrong: M.call() for async method
  fetch: M.call(M.string()).returns(M.string())
});

const fetcher = makeExo('Fetcher', FetcherI, {
  async fetch(url) {
    return await E(httpClient).get(url);  // Returns promise
  }
});
```

The return guard expects a string, but gets a promise!

**Solution:**
```javascript
const FetcherI = M.interface('Fetcher', {
  // Correct: M.callWhen() for async method
  fetch: M.callWhen(M.string()).returns(M.string())
});
```

Or if the method is truly synchronous, don't use `async`:

```javascript
const FetcherI = M.interface('Fetcher', {
  fetch: M.call(M.string()).returns(M.promise())  // Returns promise explicitly
});

const fetcher = makeExo('Fetcher', FetcherI, {
  fetch(url) {
    return E(httpClient).get(url);  // Return promise, don't await
  }
});
```

### Not All Remotables Are Exos

**Problem:**
```javascript
const obj = Far('MyObject', {
  doSomething(x) { /* ... */ }
});

// This works, but has no input validation
obj.doSomething('invalid');  // No guard to catch this
```

Far objects are remotable but don't validate inputs.

**Solution:**

Use `makeExo` when you need defensive behavior:
```javascript
const obj = makeExo('MyObject', MyObjectI, {
  doSomething(x) { /* ... */ }
});

// Now inputs are validated
obj.doSomething('invalid');  // throws if pattern doesn't match
```

### Promise Pipelining Limitations

**Problem:**

You can't pipeline to computed property names or conditional logic:

```javascript
// This doesn't pipeline correctly
const methodName = await E(obj).getMethodName();
const result = E(obj)[methodName]();  // Second call waits for first
```

**Solution:**

Design interfaces so common operations don't require computed dispatch:

```javascript
// Better: explicit methods
const result = await E(obj).doCommonOperation();
```

Or use a dispatch method:

```javascript
const result = await E(obj).dispatch(methodName, ...args);
```

### Mutating State in Copyable Data

**Problem:**
```javascript
const config = harden({ timeout: 5000 });
config.timeout = 10000;  // throws - object is frozen
```

Copyable data is frozen and can't be mutated.

**Solution:**

Create new data instead of mutating:

```javascript
const oldConfig = harden({ timeout: 5000 });
const newConfig = harden({ ...oldConfig, timeout: 10000 });
```


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
