#!/bin/bash

#【描述】软链接目录"/app/nlohmann--json/include/nlohmann/"为给定目录
#【依赖】
#【术语】
#【备注】

#'-e': 任一语句异常将导致此脚本终止; '-u': 使用未声明变量将导致异常
set -e -u

source /app/bash-simplify/_importBSFn.sh
_importBSFn "cdCurScriptDir.sh"
_importBSFn "git_Clone_SwitchTag.sh"
_importBSFn "arg1EqNMsg.sh"



function link_NlohmannJson_includeDir_to() {
local REPO_HOME="/app/nlohmann--json"
local NlohmannJson_IncDir="$REPO_HOME/include/nlohmann/"

#到当前目录
cdCurScriptDir

#克隆本仓库
git_Clone_SwitchTag http://giteaz:3000/util/nlohmann--json.git tag__10.0.0 $REPO_HOME

    local exitCode_OK=0
    local errCode1=81

    arg1EqNMsg $# 1 '断言失败，需要1个参数' || return $?
    # set -x
    
    local target_inc_dir=$1
    local errMsg1="期望为正确的软链接【$target_inc_dir --> $NlohmannJson_IncDir】，但此时是错误的软链接. 退出错误代码[$errCode1]"
    local linkTxt="$([[ -e $target_inc_dir ]] && ls -lh $target_inc_dir)"
    local okMsg2_newLink="【新建软链接指向】"
    local okMsg3_already="【已存在、且指向相同】"

    #是否已存在的目标软链接
    local hasTargetIncDir=false; [[ -s $target_inc_dir ]] && hasTargetIncDir=true
    #是否已存在的目标软链接是指向期望目录
    local Equal=false; [[ "X$(readlink -f $target_inc_dir)" == "X$(readlink -f $NlohmannJson_IncDir)" ]] && Equal=true

    #若无目标软链接, 则正常创造软链接，并正常返回
    ! $hasTargetIncDir && { ln -s  "$NlohmannJson_IncDir" $target_inc_dir ;echo $okMsg2_newLink; ls -lh $target_inc_dir; return $exitCode_OK ;}

    #已存在、且指向不同，则打印错误消息并返回错误
    $hasTargetIncDir && ! $Equal && { echo $errMsg1 ; ls -lh $target_inc_dir; return $errCode1 ;}
    
    #已存在、且指向相同，则打印正常并正常返回
    $hasTargetIncDir && $Equal && echo $okMsg3_already && ls -lh $target_inc_dir && return $exitCode_OK  

}

link_NlohmannJson_includeDir_to $*  || exit $?

#用法举例
#  "/app/nlohmann--json/include/nlohmann/"  --> "/fridaAnlzAp/clang-varBE/include/nlohmann"
#bash /app/nlohmann--json/link_NlohmannJson_includeDir_to.sh "/fridaAnlzAp/clang-varBE/include/nlohmann"