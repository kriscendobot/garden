**Verdict:** request-changes

**Findings:**
- `src/session.js:27` — the private helper `recieveFrame` is misspelled; rename to `receiveFrame` (two call sites, both in this file, not exported). [rule: roles/jurors/stylist/AGENT.md]
- `src/session.js:30` — local variable `cfg` is an abbreviation; spell it out as `configuration`. [rule: roles/jurors/stylist/AGENT.md]
