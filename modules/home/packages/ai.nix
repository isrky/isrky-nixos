{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## AI tools
    aider-chat-full
    antigravity
    claude-code
    code-cursor
    codex
    gemini-cli-bin
    jan
    litellm
    llmfit
    opencode
  ];
}
