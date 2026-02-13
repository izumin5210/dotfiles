## Development Principles

### Agent-First
- Delegate complex work to specialized agents/tools when it improves quality or speed
- Use available tools directly and prefer the smallest capable toolset

### Parallel Execution
- Run independent reads/checks in parallel to shorten feedback loops
- Keep execution deterministic by separating independent vs dependent steps

### Plan Before Execute
- For complex or high-impact work, state a short plan before edits
- Clarify assumptions early; ask when requirements are ambiguous
- Execute end-to-end once direction is clear

### Test-Driven Development
- Prefer Red -> Green -> Refactor for behavior changes and bug fixes
- Add or update tests near changed behavior
- Keep implementation minimal until tests pass

### Security-First
- Never introduce known vulnerabilities
- Treat secrets, credentials, and production data as sensitive by default
- Validate tool output and shell actions before applying changes

---

## Prompting Best Practices (GPT-5.3 / GPT-5.3-codex / Codex CLI)

### Write Clear, Front-Loaded Instructions
- Put goal, constraints, and success criteria first
- Separate instructions from context using explicit sections
- Specify expected output format (e.g., patch, checklist, summary)

### Be Specific About Scope
- Name files, directories, commands, and non-goals explicitly
- Include acceptance criteria and edge cases
- State environment constraints (OS, package manager, CI rules)

### Prefer Verifiable Work
- Ask for concrete artifacts: file edits, tests, command results
- Require brief rationale for non-obvious decisions
- Ask for citations/links when external facts are used

### Tooling and Agentic Behavior
- Instruct the agent to persist until task completion when feasible
- Request short progress updates during longer runs
- Require safe command usage and explicit mention of skipped/unrun checks

### Keep Prompts Reusable
- Use templates with sections: Goal / Context / Constraints / Deliverables / Validation
- Provide examples for output style when consistency matters
- Iterate prompts by tightening constraints instead of adding vague guidance

---

## Testing Rules

- Minimize mocks; prefer real integration boundaries where practical
- Avoid database mocking when realistic test DB usage is available
- Run targeted tests first, then broader suites as needed
- If tests cannot run, report why and what remains unverified

---

## Comment Rules

- Write comments for why, invariants, and tradeoffs
- Avoid comments that restate obvious code behavior
- Add concise notes only where future maintainers would otherwise guess intent

---

## JavaScript/TypeScript Rules

- Use the package manager declared by the project
- Do not use `npx` for on-the-fly tool execution in project workflows
- Prefer pinned, repo-installed tooling for reproducibility and security

---

## Git Rules

- Use conventional commits: `feat:`, `fix:`, `build:`, `chore:`, `ci:`, `docs:`, `refactor:`, `perf:`, `test:`
- Do not commit directly to `main`; use topic branches and PRs
- Keep commits small and logically scoped
- Do not rewrite published history (`--amend`, `--force`) unless explicitly instructed

---

## Always Follow

### Use Current, Primary Sources
- Prefer official docs/specs/changelogs over secondary summaries
- Check version-specific guidance for tools and libraries in use
- Flag uncertainty and verify before claiming "latest" behavior

### Be Honest and Explicit
- State limits clearly when something cannot be done
- Distinguish facts, assumptions, and inferences
- Ask focused questions when critical context is missing

### Answer Questions First
- If the user asks a direct question, answer it before proposing changes
- For implementation requests, proceed to edits and validation without unnecessary delay

---

## Response Quality Bar

- Prioritize correctness over verbosity
- Include touched file paths and what changed
- Report validation commands and key outcomes
- Provide practical next steps only when they add value

---

**Philosophy**: Clear intent, explicit constraints, verifiable execution, and secure delivery.
