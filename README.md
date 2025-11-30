# NutrientCalc: 中国人群 FFQ 营养素计算工具

**NutrientCalc** 是一个专为中国人群设计的 R 包，用于处理食物频率问卷（FFQ）数据。它基于**中国人群的标准食物份量**，自动计算宏量营养素（如碳水化合物、蛋白质、脂肪）和微量营养素（如维生素、矿物质）。

## 主要功能

1.  **营养素计算 (`calculate_nutrients`)**：
    *   输入：包含 FFQ 频率数据的 Excel 文件。
    *   处理：根据预设的中国食物成分表和标准份量，计算每位受访者的能量及各类营养素摄入量。
    *   输出：包含原始数据及计算结果的数据框。

2.  **数据可视化 (`plot_nutrients`)**：
    *   生成营养素摄入量的箱线图（Boxplot），使用对数刻度（log10）展示，方便观察数据分布和离群值。

3.  **数据拆分与导出 (`split_nutrients`)**：
    *   将计算结果拆分为两个部分，便于后续统计分析：
        *   `nut1`: 基础信息部分。
        *   `nut2`: 纯营养素计算结果部分。
    *   支持将完整结果导出为 CSV 文件。

## 安装方法

您可以通过以下方式安装此包：

```r
# 方法 1: 从本地文件夹安装 (推荐)
install.packages("C:/path/to/NutrientCalc", repos = NULL, type = "source")

# 方法 2: 使用 devtools (如果网络和依赖环境允许)
# devtools::install("C:/path/to/NutrientCalc")
```

## 使用示例

```r
remotes::install_github("r-ruser/NutrientCalc")
library(NutrientCalc)

# 1. 计算营养素
# 请确保 Excel 文件格式符合要求（包含特定的频率列）
df <- calculate_nutrients("data/ffq_data.xlsx")

# 2. 绘制营养素分布图
plot_nutrients(df)

# 3. 拆分数据并保存
# 结果包含 nut1 (基础信息) 和 nut2 (营养素数据)
result <- split_nutrients(df, output_csv_path = "output/nutrients_all.csv")

# 查看结果
head(result$nut2)
```

## 数据要求

输入数据应为 Excel (`.xlsx`) 格式，且包含符合特定命名规则的频率列（例如 `_Frequency` 结尾的列）以及对应的摄入量列。
