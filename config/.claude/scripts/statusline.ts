#!/usr/bin/env bun

import { $ } from "bun";

interface StatusInput {
  model: {
    id: string;
    display_name: string;
  };
  version: string;
  cost: {
    total_cost_usd: number;
  };
  context_window: {
    context_window_size: number;
    current_usage?: {
      input_tokens: number;
      output_tokens: number;
      cache_creation_input_tokens: number;
      cache_read_input_tokens: number;
    };
  };
  workspace: {
    current_dir: string;
    project_dir: string;
  };
  cwd: string;
}

const COLORS = {
  gray: "\x1b[90m",
  reset: "\x1b[0m",
} as const;

function colorize(text: string, color: keyof typeof COLORS): string {
  return `${COLORS[color]}${text}${COLORS.reset}`;
}

async function getGitRepoRoot(cwd: string): Promise<string | null> {
  try {
    const result = await $`git -C ${cwd} rev-parse --show-toplevel`.quiet();
    return result.text().trim();
  } catch {
    return null;
  }
}

async function formatPath(cwd: string): Promise<string | null> {
  const home = process.env.HOME ?? "";
  const gitRoot = await getGitRepoRoot(cwd);

  if (gitRoot) {
    if (cwd === gitRoot) {
      return null;
    }
    const relativePath = cwd.slice(gitRoot.length + 1);
    return `./${relativePath}`;
  }

  // git リポジトリでない場合: HOME からの相対パス or 絶対パス
  if (cwd.startsWith(home)) {
    return `~${cwd.slice(home.length)}`;
  }

  return cwd;
}

function formatContextUsage(input: StatusInput): string {
  const { context_window } = input;
  const usage = context_window.current_usage;

  if (!usage) {
    return "Ctx 0%";
  }

  const currentTokens =
    usage.input_tokens +
    usage.cache_creation_input_tokens +
    usage.cache_read_input_tokens;
  const percent = Math.round(
    (currentTokens / context_window.context_window_size) * 100,
  );

  return `Ctx ${percent}%`;
}

function formatCost(input: StatusInput): string {
  const cost = input.cost?.total_cost_usd ?? 0;
  return `$${cost.toFixed(4)}`;
}

async function main() {
  const inputText = await Bun.stdin.text();
  const input: StatusInput = JSON.parse(inputText);

  const path = await formatPath(input.cwd);

  const parts = [
    path ? colorize(path, "gray") : null,
    colorize(input.model.id, "gray"),
    colorize(formatContextUsage(input), "gray"),
    colorize(formatCost(input), "gray"),
    colorize(`v${input.version}`, "gray"),
  ].filter(Boolean);

  console.log(parts.join(colorize(" | ", "gray")));
}

main().catch(console.error);
