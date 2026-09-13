---
name: code-comments
description: Rules for writing and editing code comments — inline comments, doc comments (TSDoc, GoDoc, docstrings), and TODOs. Use when writing or changing code, adding or editing comments, or reviewing a diff for comment quality.
---

# Code Comments

A comment earns its place only by saying something true about the code as it stands now that the code itself cannot say: the why behind a decision, a rejected alternative (why not), an invariant, or a non-obvious constraint. Every other comment costs more than it gives — readers must process it, and maintainers must keep it true.

These rules apply to the code you are writing or changing. Leave the rest alone: don't add comments, docstrings, or type annotations to code you didn't touch.

## Present-tense why only

Describe the code as it is, never how it got that way. Change history, migration notes, "the old approach", "previously", "changed from X to Y" — that story belongs in the commit message and PR, where it stays attached to its moment. In code it reads as noise today and becomes misleading once the context is gone.

```ts
// Bad: narrates the change
// Previously resolved via apiKeyHelper, but that was rejected due to
// startup latency, so we now read the env var directly.
const apiKey = process.env.API_KEY;

// Good: states the present-tense reason
// An exec-per-request helper adds ~200ms startup latency; the env var is enough.
const apiKey = process.env.API_KEY;
```

The same applies to leftovers: when something is removed or deprecated, the comments about it go with it.

## Nothing self-evident

If the code already says it, a comment repeating it is pure cost. When you feel a comment is needed to explain *what* the code does, first try making the code obvious instead — a plain implementation with no comment beats a clever one with an explanation.

```ts
// Bad: restates the code
// Generate an 8-byte random hex string
const id = crypto.randomBytes(8).toString("hex");

// Good: no comment — the code is the explanation
const id = crypto.randomBytes(8).toString("hex");
```

## Concise, but complete

Long, meandering comments bury their point. Write the shortest comment that still carries every premise the reader needs — trim the prose, not the reasoning.

## Anchor doc comments to a symbol

Free-floating commentary at the top of a file has no owner and rots fastest. Attach documentation to the thing it documents as a doc comment (TSDoc, GoDoc, docstring). Language-conventional file docs (Go package docs, module docstrings) are fine.

## References must stand alone

A bare pointer like `(§5.3.4)` or a ticket ID is meaningless without the referenced document, and those documents are transient. Write the actual reasoning into the comment; a full URL may back it up, never replace it.

```ts
// Bad: meaningless without the doc
// See §5.3.4
if (attempt > MAX_RETRIES) throw new FatalError("giving up");

// Good: the reason is in the comment; the link is a bonus
// The queue redelivers up to 3 times; a 4th failure means the payload
// itself is bad, so retrying cannot help.
// https://docs.example.com/queue/redelivery
if (attempt > MAX_RETRIES) throw new FatalError("giving up");
```

## Fix stale comments in code you touch

When your change makes a nearby comment wrong — or you find one referencing something that no longer exists — updating or deleting it is part of the change, not an optional cleanup.

## Before you finish

Reread the comments in your diff once: anything narrating the change, restating the code, or padding the point gets deleted.
