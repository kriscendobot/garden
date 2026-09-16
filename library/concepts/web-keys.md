---
id: web-keys
aliases: [web-key, web-keys, web key, web keys, YURL, YURLs, capability URL, unguessable URL, mashing with permission]
topics: [capability-security, identity, patterns]
---

# web-keys

A **web-key** is an unguessable URL whose possession both designates a Web resource and authorizes a REST operation on it. Tyler Close's Waterken work uses web-keys to move authorization to reference construction and delegation, avoiding ambient cookie identity and a shared principal database. A web-key is more than random text in a URL: its security case includes adequate entropy, a protected transport and local handling path, explicit delegation and revocation semantics, and a trusted UI such as petnames when a human must recognize the relationship. Close's later *ACLs Don't* paper identifies web-keys as the capability-by-reference repair for CSRF and clickjacking's confused-deputy structure.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cap-talk-2004-2008--phishing-yurls-and-petnames](../sections/cap-talk-2004-2008--phishing-yurls-and-petnames.md) | A YURL securely designates; a user-controlled petname supplies relationship meaning through trusted UI. |
| [cap-talk-2004-2008--web-keys-mashing-with-permission](../sections/cap-talk-2004-2008--web-keys-mashing-with-permission.md) | Close's 2008 paper thread: unguessable REST URLs, delegation, revocation, persistence, and application composition. |
| [papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix.md) | The access-matrix formalization: anti-forgery tokens and unguessable URLs move Web applications from ACL-by-cookie to capability-by-reference. |

## See also

- [[confused-deputy]] - the attack class web-keys avoid by binding authority to the designation.
- [[powerbox]] - the trusted UI pattern that mints narrow authority from a user's act of designation.
- [[capabilities-vs-acls]] - the model contrast web-keys apply to Web requests.
