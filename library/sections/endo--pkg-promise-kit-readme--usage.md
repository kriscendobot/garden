---
title: Usage (Basic Example + Multiple Kits)
source: packages/promise-kit/README.md
source_repo: endojs/endo
source_commit: 2fc917e9
source_date: 2024-06-20
source_authors: [Mudassir Shabbir]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: Two H3 sub-sections consolidated: Basic Example (single kit construction and resolution) and Creating Multiple Promise Kits (patterns for multi-kit code, e.g., when an API needs many independent promises).

## Usage

Here’s an example of how `makePromiseKit` might be used in an Agoric smart contract or JavaScript program:

### Basic Example

```javascript
import { makePromiseKit } from '@endo/promise-kit';

function asyncOperation() {

  const { promise, resolve, reject } = makePromiseKit();
  setTimeout(() => {
    const success = true; // Simulating success or failure
    if (success) {
      resolve("Operation successful!");
    } else {
      reject("Operation failed!");
    }
  }, 2000); 

  return promise;
}

async function handleAsyncOperation() {
  try {
    const result = await asyncOperation();
    console.log(result); // "Operation successful!"
  } catch (error) {
    console.error(error); // "Operation failed!"
  }
}

handleAsyncOperation();
```

### Creating Multiple Promise Kits

You can create multiple promise kits for managing various asynchronous tasks.

```javascript
const kit1 = makePromiseKit();
const kit2 = makePromiseKit();

kit1.promise.then(value => console.log('Kit 1 resolved with:', value));
kit2.promise.then(value => console.log('Kit 2 resolved with:', value));

kit1.resolve('First success');
kit2.resolve('Second success');

```


Source: [packages/promise-kit/README.md](https://github.com/endojs/endo/blob/2fc917e9/packages/promise-kit/README.md) at commit `2fc917e9`.
