import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Define the input file
INPUT_FILE = "./heterozigosidade_perind_withlin.tsv"

# Read in the data
data = pd.read_csv(INPUT_FILE, sep="\t")

# Set plot style
sns.set(style="white")

# Create boxplot with jitter (stripplot) overlay
plt.figure(figsize=(10, 6))
ax = sns.boxplot(data=data, x="Populacao", y="Heterozigosidade",
    width=0.6, showcaps=True, boxprops={'alpha': 0.6, 'edgecolor': 'black'},
    showfliers=False, whiskerprops={'linewidth': 1.5, 'color': 'black'})

sns.stripplot(data=data, x="Populacao", y="Heterozigosidade",
    size=5, jitter=0.2, alpha=0.7, ax=ax)

# Rotate x-axis labels
plt.xticks(rotation=45, ha="right")

# Axis labels and title
plt.xlabel("Populacao")
plt.ylabel("Heterozigosidade")

# Save the plot
plt.tight_layout()
plt.savefig("heterozigosidade_boxplot_por_populacao.png", dpi=300)
