<#
.SYNOPSIS
    Toolkit VSCode 插件安装器

.DESCRIPTION
    检测 VSCode、卸载旧版、安装新版
    此脚本会被打包进安装器 exe 中
#>

param(
    [string]$VsixPath
)

$ErrorActionPreference = "Stop"
$ExtensionId = "mechtoolkit.toolkit-bescript-suite"

# ============================================================
# 查找 VSCode
# ============================================================

function Find-VSCode {
    $paths = @()

    # 1. PATH 环境变量
    $codeCmd = Get-Command "code" -ErrorAction SilentlyContinue
    if ($codeCmd) {
        $paths += $codeCmd.Source
    }

    # 2. 用户安装路径
    $userPath = Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin\code.cmd"
    if (Test-Path $userPath) {
        $paths += $userPath
    }

    # 3. 系统安装路径 (64位)
    $systemPath = Join-Path ${env:ProgramFiles} "Microsoft VS Code\bin\code.cmd"
    if (Test-Path $systemPath) {
        $paths += $systemPath
    }

    # 4. 系统安装路径 (32位目录，但实际是64位程序)
    $systemPathX86 = Join-Path ${env:ProgramFiles(x86)} "Microsoft VS Code\bin\code.cmd"
    if (Test-Path $systemPathX86) {
        $paths += $systemPathX86
    }

    # 5. 注册表查找
    $regPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($regPath in $regPaths) {
        $items = Get-ItemProperty $regPath -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "*Visual Studio Code*" }
        foreach ($item in $items) {
            if ($item.InstallLocation) {
                $codePath = Join-Path $item.InstallLocation "bin\code.cmd"
                if (Test-Path $codePath) {
                    $paths += $codePath
                }
            }
        }
    }

    # 去重并返回第一个有效路径
    $paths = $paths | Select-Object -Unique
    foreach ($p in $paths) {
        if (Test-Path $p) {
            return $p
        }
    }

    return $null
}

# ============================================================
# 执行 VSCode 命令
# ============================================================

function Invoke-VSCode {
    param(
        [string]$CodePath,
        [string[]]$Arguments
    )

    $result = & $CodePath @Arguments 2>&1
    return $LASTEXITCODE, $result
}

# ============================================================
# 主流程
# ============================================================

# 查找 VSIX 文件
if (-not $VsixPath) {
    $scriptDir = Split-Path $PSScriptRoot -Parent
    $vsixFiles = Get-ChildItem -Path $scriptDir -Filter "*.vsix" -ErrorAction SilentlyContinue
    if ($vsixFiles) {
        $VsixPath = $vsixFiles[0].FullName
    }
}

if (-not $VsixPath -or -not (Test-Path $VsixPath)) {
    Write-Host "错误: 找不到 VSIX 文件" -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "VSIX: $VsixPath" -ForegroundColor Cyan

# 查找 VSCode
Write-Host "正在检测 VSCode..." -ForegroundColor Cyan
$codePath = Find-VSCode

if (-not $codePath) {
    Write-Host @"
========================================
错误: 未检测到 VSCode 安装
========================================
请先安装 Visual Studio Code:
https://code.visualstudio.com/
========================================
"@ -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "VSCode 已检测到: $codePath" -ForegroundColor Green

# 卸载旧版本
Write-Host "正在卸载旧版本..." -ForegroundColor Cyan
$exitCode, $output = Invoke-VSCode -CodePath $codePath -Arguments @(
    "--uninstall-extension", $ExtensionId
)
# 卸载失败不影响（可能本来就没装）
if ($exitCode -eq 0) {
    Write-Host "旧版本已卸载" -ForegroundColor Green
} else {
    Write-Host "未安装旧版本或卸载跳过" -ForegroundColor Yellow
}

# 安装新版本
Write-Host "正在安装新版本..." -ForegroundColor Cyan
$exitCode, $output = Invoke-VSCode -CodePath $codePath -Arguments @(
    "--install-extension", $VsixPath, "--force"
)

if ($exitCode -ne 0) {
    Write-Host @"
========================================
错误: 安装失败
========================================
$output
========================================
"@ -ForegroundColor Red
    Read-Host "按回车键退出"
    exit 1
}

Write-Host @"
========================================
安装成功!
========================================
Toolkit BEScript 工具箱已安装
请重启 VSCode 以生效
========================================
"@ -ForegroundColor Green

Read-Host "按回车键退出"
