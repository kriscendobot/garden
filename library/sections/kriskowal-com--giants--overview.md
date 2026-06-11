---
title: "A Choice of Giants: Full Essay (overview)"
source_kind: web-essay
source_url: https://kriskowal.com/giants
source_author: Kris Kowal
source_date: 2024-02-22
ingested: 2026-06-11
ingested_by: scholar
topics: [capability-security, chat-ui, agent-conventions]
status: current
---

## Abstract

Kris Kowal's 22 February 2024 essay names the central problem Endo addresses: a surplus of platform giants (social media, search, AI, browsers, app stores) all fed by users who lack better options. The essay then proposes a better dream anchored in chat as a medium of distribution for confined "weblets" — self-contained, archivable, peer-sendable web applications that must obtain capabilities through user-mediated dialogue rather than holding ambient authority. The essay ends by linking to Endo as the implementation of this vision and is the canonical vocabulary source for the terms "user agent," "weblet," and "chat as a medium of distribution."

## Body

### The giants problem

The essay opens by cataloging the web's genuine progress since the mid-1990s: consistent event handling, the end of quirks mode, the absorption of jQuery. The web can go home. But "our solutions have bred new problems."

The structural critique: platform giants have herded users into pens.

> The social media giants have herded us into their pens and we rarely contribute to the vast wilderness of free information. So, the web search giants are starving, unable to infer relevance from links, forced to show nothing but advertisements above the fold. The rising giants of artificial intelligence must make do with everything that has ever been said in public and everything that was given freely to other giants in private.

The result is a "surplus of giants all in need of feeding." Users feed them for lack of better options.

### The browser as failed user agent

The essay's central diagnosis: there is "a rapidly deteriorating fiction that a web browser represents the interests of the user."

> We call web browsers "user agents" even though you, a user, no longer have agency.

The origin of this failure is traced through two steps. First, browsers were built correctly — memory-safe, event-loop-based, sandboxed. "A web page couldn't read your passwords, delete your recipes, or draw a button outside of its frame." Second, the cracks showed: web pages have an umbilical cord to the server that hosted them, and the user cannot prevent a web page from talking to that server. "So, a vast network of pervasive surveillance is born."

The dependency on search-engine money locks browsers into protecting this surveillance architecture. "Making a browser that breaks the connection between a web page and a web server is not contemplatable."

### The dependency problem

The second fiction being demolished: "that a web application represents the interests of any single author." Most software bundled into a web application is dependencies. "Where `virus.exe` ran away with all the authority of the user, a web page's dependencies run away with all the authority of the web page."

This raises the author-agency question symmetrically: if users cannot confine web pages, can authors confine their dependencies?

### App stores as a failed alternative

App stores "offer to defend the interests of users by guarding their own gates, but they also use those gates and their own promotional mechanisms to ensure that they collect the lion's share and suffer no competition."

The essay names four missing properties that app stores fail to provide:

- One does not archive an app.
- One does not keep an app.
- One does not send an app to a friend.
- One does not pass an app on to their children.

App stores also "provide no credible isolation at runtime," forcing a "treadmill of recompiling with the latest patch releases of all the underlying frameworks."

### The better dream: chat and weblets

The proposal:

> I dream that the next frontier of the web starts with chat, where all social problems and solutions begin and end.

The key move: make chat a medium of distribution for web apps, not just a channel for links that exit to web pages. "Let's call these 'weblets'."

Two defining properties of weblets:

**Confined:** "Weblets are confined. They have no implicit ties or dependence to an original host. To connect to a host, they must obtain it with the grace of the user. They must chat. So, chat becomes also a medium for obtaining permission."

**Saveable:** "Weblets can be saved. A weblet is self-confined. They can be archived. They can be sent to a friend. They do not break with age."

The vision scales: "We should do that. We should do that in the open. We should do that with federation. We should do that on a grander scale than has ever been seen before."

The essay closes by linking to Endo as the technical answer to this vision. The essay's immediate successor page ("Endo") describes the Familiar (Pet Daemon), the daemon's capability-grant-through-dialogue model, and the role of chat as permission-channel.

### Existing better options (context)

The essay also surveys the current landscape of "already here" better options — Signal (private chat), Mastodon/ActivityPub (federated social), independent email — to establish that federation and privacy-respecting tools are not science fiction. However, each still requires either trusting a developer or trusting an instance operator, and Mastodon's instance-operator model surfaces a concrete problem: "we do still have to worry about what happens to us when the wrong people hear." This is the same operator-liability problem the O2 community-hub essays must address.

## Vocabulary established by this essay

| Term | Definition in the essay |
|------|-------------------------|
| **user agent** | A browser that genuinely represents the user's interests (currently a fiction) |
| **weblet** | A confined, archivable, sendable web application that obtains capabilities via chat |
| **chat as a medium of distribution** | Chat as the channel through which weblets are delivered and through which they obtain user permission |
| **giants** | Platform incumbents (social, search, AI, browsers, app stores) that feed on user data and attention |
| **Familiar / Pet Daemon** | The user-controlled daemon mediating capability grants (term used on the Endo follow-on page, not the essay itself) |

Source: [kriskowal.com/giants](https://kriskowal.com/giants) published 22 February 2024.
