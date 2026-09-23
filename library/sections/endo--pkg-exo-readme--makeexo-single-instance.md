---
title: makeExo: Single Instance
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
notes: makeExo() and Far() are alternative ways to construct a remotable. makeExo() adds patterns-language argument typing and the exo lifecycle; Far() is the minimal-overhead path. See endo--pkg-pass-style-readme--far for the lighter-weight path; use it when no methodsGuard or per-instance state is needed.
---

> Abstract: makeExo(tag, methodsGuard, methods) constructs a single remotable. The tag names the interface for marshal; methodsGuard is a patterns-language type for incoming arguments; methods is the implementation record. No init() callback; this.self is the exo, this.state is always empty {}. Use when one instance suffices and no per-instance state is needed.

### makeExo: Single Instance

Use when you need one exo instance with no complex state management:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';

const GreeterI = M.interface('Greeter', {
  greet: M.call(M.string()).returns(M.string())
});

const greeter = makeExo('Greeter', GreeterI, {
  greet(name) {
    return `Hello, ${name}!`;
  }
});

greeter.greet('World');  // 'Hello, World!'
```

**When to use:**
- Single, stateless service objects
- Utility objects with no instance-specific state
- Simple cases where you don't need class-like behavior


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
