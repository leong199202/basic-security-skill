#!/usr/bin/env bash
# Runs the weekly AI-coding security research with whatever AI model you use.
#
# Pick ONE way to reach your model:
#
#   1) AI_COMMAND: any command-line tool that reads a prompt on stdin and
#      prints the answer. Examples:
#        AI_COMMAND="claude -p"                 (Claude Code)
#        AI_COMMAND="llm -m <model>"            (simonw/llm: OpenAI, Gemini, Claude, local...)
#        AI_COMMAND="ollama run <model>"        (local models)
#
#   2) An OpenAI-compatible chat API (most providers offer one):
#        AI_BASE_URL  e.g. https://api.openai.com/v1
#                          https://generativelanguage.googleapis.com/v1beta/openai
#                          https://openrouter.ai/api/v1
#                          https://api.anthropic.com/v1
#                          http://localhost:11434/v1   (Ollama)
#        AI_MODEL     the model name your provider uses
#        AI_API_KEY   your API key (leave empty for local servers that need none)
#
# Settings saved by scripts/setup-research.sh (on first install) are read
# from $BASIC_SECURITY_CONFIG (default ~/.config/basic-security/research.env).
# Environment variables you set yourself win over the saved file.
#
# Output: the report is written to research/reports/<YYYY-MM-DD>.md
# (override with OUTPUT_FILE) and its path is printed on stdout.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="$ROOT/skills/basic-security/weekly-research-prompt.md"
SKILL_FILE="$ROOT/skills/basic-security/SKILL.md"
CONFIG_FILE="${BASIC_SECURITY_CONFIG:-$HOME/.config/basic-security/research.env}"

if [[ -f "$CONFIG_FILE" ]]; then
  # Load saved settings without overriding anything already in the environment.
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^(RESEARCH_ENABLED|AI_COMMAND|AI_BASE_URL|AI_MODEL|AI_API_KEY)$ ]] || continue
    [[ -n "${!key:-}" ]] && continue
    value="${value%\"}"; value="${value#\"}"
    export "$key=$value"
  done < "$CONFIG_FILE"
fi

if [[ "${RESEARCH_ENABLED:-yes}" == "no" ]]; then
  echo "Weekly research is turned off (RESEARCH_ENABLED=no in $CONFIG_FILE)." >&2
  exit 0
fi

OUTPUT_FILE="${OUTPUT_FILE:-$ROOT/research/reports/$(date -u +%Y-%m-%d).md}"

# Prompt = everything after the first "---" line of the prompt file, then the skill.
build_prompt() {
  printf 'Today is %s.\n\n' "$(date -u +%Y-%m-%d)"
  awk 'found { print } /^---$/ && !found { found = 1 }' "$PROMPT_FILE"
  printf '\n<skill>\n'
  cat "$SKILL_FILE"
  printf '\n</skill>\n'
}

mkdir -p "$(dirname "$OUTPUT_FILE")"
prompt="$(build_prompt)"

if [[ -n "${AI_COMMAND:-}" ]]; then
  # Word splitting is intended here so AI_COMMAND can carry flags.
  # shellcheck disable=SC2086
  $AI_COMMAND <<<"$prompt" > "$OUTPUT_FILE"
elif [[ -n "${AI_BASE_URL:-}" && -n "${AI_MODEL:-}" ]]; then
  command -v jq >/dev/null || { echo "jq is required for API mode" >&2; exit 1; }
  body="$(jq -Rs <<<"$prompt" --arg model "$AI_MODEL" \
    '{model: $model, messages: [{role: "user", content: .}]}')"
  # The key is passed through a header file so it never shows up in the
  # process list.
  response="$(curl -sS --fail-with-body --max-time 600 \
    "${AI_BASE_URL%/}/chat/completions" \
    -H "Content-Type: application/json" \
    -H @<(if [[ -n "${AI_API_KEY:-}" ]]; then printf 'Authorization: Bearer %s\n' "$AI_API_KEY"; fi) \
    --data-binary @- <<<"$body")" || { echo "AI request failed: ${response:-no response}" >&2; exit 1; }
  jq -er '.choices[0].message.content' <<<"$response" > "$OUTPUT_FILE" \
    || { echo "Unexpected AI response: $response" >&2; exit 1; }
else
  echo "No AI model configured. Set AI_COMMAND, or AI_BASE_URL + AI_MODEL (+ AI_API_KEY)." >&2
  echo "Run scripts/setup-research.sh, or see the 'Weekly research (any AI model)' section of README.md." >&2
  exit 2
fi

echo "$OUTPUT_FILE"
