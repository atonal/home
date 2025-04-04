# Custom color theme Based on Single_line_Dark

# This is a theme for gitprompt.sh,
# it uses the default openSUSE bash prompt style with exit status

override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Single_line_nono031"
  GIT_PROMPT_BRANCH="${Cyan}"
  GIT_PROMPT_MASTER_BRANCH="${GIT_PROMPT_BRANCH}"
  GIT_PROMPT_UNTRACKED=" ${Cyan}…${ResetColor}"
  GIT_PROMPT_CHANGED="${Yellow}✚ "
  GIT_PROMPT_STAGED="${Magenta}●"

  GIT_PROMPT_COMMAND_FAIL="${Red}✘"

  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_ ${BoldGreen}\u@\h:${BoldBlue}\w${ResetColor}"
  GIT_PROMPT_START_ROOT="_LAST_COMMAND_INDICATOR_ ${BoldRed}\u@\h:${BoldBlue}\w${ResetColor}"

  GIT_PROMPT_END_USER=' $(kube_ps1)'"\n${BoldBlue}${Time12a}${ResetColor} $ "
  GIT_PROMPT_END_ROOT=" \n${BoldBlue}${Time12a}${ResetColor} # "
}

reload_git_prompt_colors "Single_line_nono031"
