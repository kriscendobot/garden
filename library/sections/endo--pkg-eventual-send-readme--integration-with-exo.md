---
title: Integration with Exo
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, exo]
status: current
notes: This section zooms into eventual-send's composition with Exo specifically. For the broader cross-cutting map (marshal/captp/exo/patterns), see endo--pkg-eventual-send-readme--integration-with-endo.
---

> Abstract: How E() composes with Exo classes: Exo instances are remotables; E(exoInstance).methodName(args) is the standard call form. Exo's method guards validate the args; the method runs in a future turn; the return value crosses back as a promise. The M.callWhen() pattern (covered in patterns) lets the method declaration shape its arg types against resolved values rather than the raw promise.

## Integration with Exo

Exos (from [@endo/exo](../exo/README.md)) are the ideal targets for eventual
send:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';
import { E } from '@endo/eventual-send';

const CounterI = M.interface('Counter', {
  increment: M.call(M.number()).returns(M.number())
});

const counter = makeExo('Counter', CounterI, {
  increment(n) {
    return count += n;
  }
});

// E() provides async wrapper
const resultP = E(counter).increment(5);

// The InterfaceGuard validates n is a number
// Even if counter is remote, validation happens on receive
```

Even for local exos, using `E()` provides benefits:
- **Consistent async behavior** throughout your codebase
- **Turn-based execution** prevents reentrancy bugs
- **Error isolation** via promise rejection
- **Future-proof** code that works when distributed


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
