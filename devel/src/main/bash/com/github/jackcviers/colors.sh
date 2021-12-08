#!/bin/bash

color_black="\033[0;30m"
color_dark_gray="\033[1;30m"
color_red="\033[0;31m"
color_light_red="\033[1;31m"
color_green="\033[0;32m"
color_light_green="\033[1;32m"
color_orange="\033[0;33m"
color_yellow="\033[1;33m"
color_blue="\033[0;34m"
color_light_blue="\033[1;34m"
color_purple="\033[0;35m"
color_light_purple="\033[1;35m"
color_cyan="\033[0;36m"
color_light_cyan="\033[1;36m"
color_light_gray="\033[0;37m"
color_white="\033[1;37m"
color_none="\033[0m"

#--
## Colorizes a string, then resets the color to none.
## @param: color the color code to use
## @param: string_to_wrap The string to wrap in the color
## @Stdout: The string formatted to be colorized
#--
color_string(){
    local color=$1
    local string_to_wrap=$2
    local result="${color}${string_to_wrap}${color_none}"
    echo "${result}"
}


log_info(){
    local message=${@}
    echo -e "${color_blue}${message}"
}

log_success(){
    local message=${@}
    echo -e "${color_green}${message}"
}

log_error(){
    local message=${@}
    echo -e "${color_red}${message}"
}
