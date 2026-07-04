## 言語

Think in English, interact with the user in Japanese.

---

## Core Principles

### 1. Plan Before Execute
- Enter Plan Mode for complex work and only start implementation after user approval
- When requirements are ambiguous, clarify first with `AskUserQuestion`
- Answer questions (especially those ending with `?`) before proposing or starting work

### 2. Agent-First & Parallel by Default
- Consider specialized agents (`feature-dev`, `code-review`, `codex-rescue`, `pr-review-toolkit`, etc.) before writing things yourself
- Run independent tool calls **in parallel within a single message**
  - e.g. send `git status` and `git diff` as two Bash calls in the same message
  - e.g. fire multiple Read / Explore calls at once when targets are independent
- Serialize only when there is a real dependency between calls

### 3. Test-Driven Development
- Red → Green → Refactor (twada-style): write a failing test → commit → minimal implementation → refactor
- Use real databases in tests. Mocks are reserved for unavoidable cases such as external APIs

### 4. Honest & Secure
- State clearly when something is impossible, unknown, or unverified. Never proceed on assumption
- Never compromise on security. Do not write code with known vulnerabilities

### 5. Use Current Sources
- For libraries / APIs / CLIs, check current docs via **context7 / deepwiki** when uncertain
- Ground answers in sources you just read, not in training-data memory

---

## Workflow

### Git
- Work on feature branches and merge to main via pull requests
- Make small, frequent commits per logical unit
- Use Conventional Commit prefixes (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`) for commits and PR titles
- Follow the repository's language conventions
- Prose must add what the diff does not already convey — delete sentences that just narrate the diff
- **History-rewriting operations (`--amend`, `--force`, `reset --hard`, etc.) are blocked by the harness.** Stack a new commit for fixes; for already-published commits, use `revert`
- Create PRs as **draft** by default (`gh pr create --draft`). Open as ready-for-review only when the user explicitly asks
- PR description must include `Why` and `What` (change outline + watch-out points)
  - If `Why` is unknown, confirm with the user before finalizing
  - Optionally add a brief `Notes for reviewers` (complex logic, domain-critical areas, follow-ups)
  - Do not add a `Test plan` section

### Comments
- Document **Why** (intent and reasoning)
- Skip self-evident **What** comments. Exception: multi-line complex processing or intricate control flow

### JavaScript / TypeScript
- Run via the project's `packageManager`
- Use only tools already installed in the project (`npx` / `pnpx` on-the-fly execution is blocked by the harness)

---

## Tooling

### MCP / Plugin Routing

| Task | Use |
| --- | --- |
| Library / API / SDK docs | `context7` |
| GitHub repo understanding & Q&A | `deepwiki` (`ask_question`, `read_wiki_contents`) |
| Broad web search / third-party info | `o3-search`, `gpt-5-search` |
| Browser automation / UI verification | Playwright MCP |
| Stuck, second opinion, parallel implementation | `codex-rescue` subagent |
| PR review / security perspective | `pr-review-toolkit`, `security-guidance` agents |
| Large-scale code exploration | `Explore` subagent (up to 3 in parallel) |

Consider these before doing it yourself.

### Memory (`~/.claude/memory/`)
- Save user corrections / confirmations of non-obvious behavior as **feedback** (always pair the rule with its Why and applicable conditions)
- Save deadlines, stakeholders, and context that cannot be read from code as **project** memory (use absolute dates)
- Do not save anything derivable from code, git history, or CLAUDE.md
- Before relying on a memory, verify it still matches reality; update or delete it if it has drifted

---

**Philosophy**: Plan first, delegate widely, parallelize aggressively, verify with current sources.
