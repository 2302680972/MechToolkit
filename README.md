# Toolkit BeScript 插件

用于对CreatAI平台游戏开发，提供便于AI理解的视图生成能力和语法检查能力。
插件需要手动在VSCode上以VSIX形式安装

## 相关链接

- CreatAI平台(Machinist) Steam链接 https://store.steampowered.com/app/1265510/Machinist/
- Toolkit仓库 https://github.com/2302680972/MechToolkit
- Skills仓库 https://github.com/2302680972/MachinistDev
- Toolkit使用教程 https://sx16dhdgjdw.feishu.cn/wiki/AdLGwxUuViJ3zpkt9CPcWhPznGf

## 插件功能

1. BEScript语法高亮(LSP)
2. BEScript快速重构
3. 自动同步的视图映射功能:生成TS和HTML格式视图
4. 基于视图语法规则的patch支持(仅支持MCP),以及基于git patch格式的修改草稿二次提交
5. Lint诊断
6. 地图/机械/零件/脚本/布局等实体查询
7. 环境和依赖项检测/多平台一键配置

## 下载

在 [Releases](../../releases) 页面下载对应版本的 `.vsix` 文件。

| 文件 | 适用场景 |
|------|---------|
| `toolkit-bescript-suite-<版本>.vsix` | 全平台通用 |
| `toolkit-bescript-suite-<版本>-win-x64.vsix` | Windows x64 |
| `toolkit-bescript-suite-<版本>-linux-x64.vsix` | Linux x64 |

插件 Host 依赖外部 .NET 运行时，安装后按插件内环境检查提示处理。

## 安装

```bash
code --install-extension toolkit-bescript-suite-<版本>.vsix
```

## 未来计划

1. 进一步完善文档,提供更充足的平台特性介绍
2. 实现零件对象的增删/重命名/属性修改
3. 地图和机械的增删改
4. 打通外部平台API,AI驱动生成美术资源和导入.
5. 测试方面的进一步集成
