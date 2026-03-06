# Toolkit BeScript 插件

用于对CreateAI平台游戏开发，提供便于AI理解的视图生成能力和语法检查能力。
插件需要手动在VSCode上以VSIX形式安装

## 插件功能

1. BEScript语法高亮
2. BEScript快速重构:脚本改名/局部变量改名/导出到代码仓库/导出和导入canvas
3. 自动同步的视图映射功能:生成TS和HTML格式视图
4. 基于视图语法规则的patch支持(仅支持MCP)
5. Lint诊断
6. 地图/机械/零件/脚本/布局等实体查询
7. 上述功能集成到MCP

## 下载

在 [Releases](../../releases) 页面下载对应版本的 `.vsix` 文件。

| 文件 | 适用场景 |
|------|---------|
| `toolkit-bescript-suite-<版本>.vsix` | 全平台通用（需自备 .NET 运行时） |
| `toolkit-bescript-suite-<版本>-win-x64.vsix` | Windows 专用（含 .NET 运行时） |
| `toolkit-bescript-suite-<版本>-linux-x64.vsix` | Linux 专用（含 .NET 运行时） |

## 安装

```bash
code --install-extension toolkit-bescript-suite-<版本>.vsix
```

## 未来计划

当前明确没有而未来计划增加的支持

1. 零件的增删改
2. 地图和机械的增删改
3. 打通其他平台API,AI驱动生成美术资源和导入.
4. 测试方面的进一步集成