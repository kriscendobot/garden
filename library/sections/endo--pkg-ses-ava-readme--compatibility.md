---
title: Compatibility
source: packages/ses-ava/README.md
source_repo: endojs/endo
source_commit: 2845b6bd385c185893f6c9267a946bed6c65bf37
source_date: 2025-10-29
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [testing, hardened-javascript]
status: current
---

> Abstract: Compatibility notes: which ava features work as-is under SES, which need adaptation, and which are unsupported. Useful for anyone migrating an existing ava-based test suite to ses-ava.

# Compatibility

If you were already using `@endo/ses-ava` by doing

```js
import 'ses'; // or however you initialize the SES-shim
import rawTest from 'ava';
import { wrapTest } from '@endo/ses-ava';

const test = wrapTest(rawTest);
```

that code will continue to work. But it should be upgraded to the above
pattern if possible.

Source: [packages/ses-ava/README.md](https://github.com/endojs/endo/blob/2845b6bd385c185893f6c9267a946bed6c65bf37/packages/ses-ava/README.md) at commit `2845b6bd`.
