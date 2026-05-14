---
title: Design Patterns and Best Practices
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, exo, patterns]
status: current
---

> Abstract: Idioms and anti-patterns: when to use Far() vs full Exo, when to attenuate vs share, how to handle revocation, how to manage state ownership across multi-facet kits. Distills accumulated practice from Agoric and Endo codebases into rules of thumb.

## Design Patterns and Best Practices

Now that we've seen the full stack in action, let's discuss patterns for
structuring your distributed objects.

### When to Use Each Exo Pattern

**Use `makeExo` when:**
- You need a single instance
- State is managed in closure variables
- Simple use cases without complex lifecycle

```javascript
// Good use case: stateless utility
const validator = makeExo('Validator', ValidatorI, {
  validate(data) {
    return checkRules(data);
  }
});
```

**Use `defineExoClass` when:**
- You need multiple independent instances
- Each instance has its own state

```javascript
// Good use case: user sessions
const makeSession = defineExoClass(
  'Session',
  SessionI,
  (userId) => ({ userId, startTime: Date.now() }),
  { /* methods */ }
);
```

**Use `defineExoClassKit` when:**
- You need multiple facets with shared state
- Implementing least authority (different clients get different facets)
- State needs to be synchronized across related objects

```javascript
// Good use case: admin vs user interfaces
const makeService = defineExoClassKit(
  'Service',
  { admin: AdminI, user: UserI },
  () => ({ data: [] }),
  {
    admin: { reset() { this.state.data = []; } },
    user: { getData() { return this.state.data; } }
  }
);
```

### Copyable Data vs Remotable Objects

**Choose copyable (pass-by-copy) for:**
- Immutable data (configurations, messages, values)
- Small data structures (arrays, records)
- Data that will be stored or compared

```javascript
// Copyable: configuration object
const config = harden({
  timeout: 5000,
  retries: 3,
  endpoints: ['api.example.com']
});

// Copyable: message/event
const event = harden({
  type: 'transfer',
  from: 'alice',
  to: 'bob',
  amount: 100,
  timestamp: Date.now()
});
```

**Choose remotable (pass-by-presence) for:**
- Objects with behavior (methods)
- Objects with mutable state
- Objects representing capabilities/authority
- Large objects (passing reference is cheaper)

```javascript
// Remotable: service with methods
const database = Far('Database', {
  query: (sql) => { /* ... */ },
  insert: (record) => { /* ... */ }
});

// Remotable: capability
const fileHandle = Far('FileHandle', {
  read: () => { /* ... */ },
  write: (data) => { /* ... */ }
});
```

### Error Handling Across Vat Boundaries

Errors thrown in exo methods are automatically converted to passable form
before crossing vat boundaries:

```javascript
const service = makeExo('Service', ServiceI, {
  doOperation(input) {
    if (!isValid(input)) {
      // This error will be made passable automatically
      throw Error('Invalid input');
    }
    return result;
  }
});

// Caller in different vat
try {
  await E(service).doOperation(badInput);
} catch (err) {
  // err is a passable error
  console.error(err.message);  // 'Invalid input'
}
```

**Best practices:**
- Throw `Error` objects (they're automatically made passable)
- Don't throw non-passable values
- Use error messages, and properties, but avoid entraining capabilities: errors
  with capabilites are not passable.

### Testing Strategies

Use `E()` even in unit tests for consistency:

```javascript
import test from 'ava';
import { E } from '@endo/eventual-send';

test('counter increments correctly', async t => {
  const counter = makeCounter(0);

  // Use E() even though counter is local
  const result = await E(counter).increment(5);

  t.is(result, 5);
});
```

This ensures:
- Tests mirror production code
- Async behavior is tested
- Easy to mock remote objects

For testing remote scenarios, create mock presences:

```javascript
const mockRemoteService = Far('MockService', {
  async getData() {
    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 100));
    return testData;
  }
});
```


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
