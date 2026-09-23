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
| [cap-talk-2009-2012--yurls-hash-length-and-self-authenticating-names](../sections/cap-talk-2009-2012--yurls-hash-length-and-self-authenticating-names.md) | YURLs put a hash of the server public key in the hostname to authenticate an endpoint without DNS or a CA; sizing the fingerprint against parallelizable multi-target preimage attacks. |
| [opinions-of-oauth](../sections/cap-talk-2009-2012--opinions-of-oauth.md) | Tyler Close and Marc Stiegler present web-keys and Waterken YURLs (public-key fingerprint in the hostname) as the capability alternative to OAuth. |
| [supplanting-passwords-and-the-master-capability](../sections/cap-talk-2009-2012--supplanting-passwords-and-the-master-capability.md) | Web-keys replace per-resource passwords; a master-capability bootstrap remains irreducible. |
| [what-parts-of-a-url-are-safe-for-secrets](../sections/cap-talk-2009-2012--what-parts-of-a-url-are-safe-for-secrets.md) | The confidentiality leak in URL-borne capabilities: nothing in the URL is safe, so keep the secret in the fragment. |
| [capabilities-for-legacy-web-programs](../sections/cap-talk-2009-2012--capabilities-for-legacy-web-programs.md) | HMAC-signed URLs retrofit unforgeable, possession-proves-authority behavior onto legacy web frameworks. |

## See also

- [[confused-deputy]] - the attack class web-keys avoid by binding authority to the designation.
- [[powerbox]] - the trusted UI pattern that mints narrow authority from a user's act of designation.
- [[capabilities-vs-acls]] - the model contrast web-keys apply to Web requests.
