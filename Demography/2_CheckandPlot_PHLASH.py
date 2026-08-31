
import sys
import os
import pickle
import numpy as np
import matplotlib.pyplot as plt

if len(sys.argv) < 2:
    print("Usage: python plot_results.py <results_directory>")
    sys.exit(1)

RESULTS_DIR = sys.argv[1]
pops = ["Lin1", "Lin3", "Lin4", "Lin5", "Lin7"]

for pop in pops:
    pkl_path = os.path.join(RESULTS_DIR, f"phlash_results_{pop}.pkl")

    if not os.path.exists(pkl_path):
        print(f"WARNING: {pkl_path} not found, skipping {pop}")
        continue

    # --- check ---
    try:
        with open(pkl_path, "rb") as f:
            res = pickle.load(f)
    except Exception as e:
        print(f"ERROR: could not load {pkl_path} ({e}), skipping {pop} — re-run this population's fit")
        continue

    n_samples = len(res)
    print(f"{pop} -> n_samples: {n_samples}")

    if n_samples == 0:
        print(f"WARNING: {pop} has 0 samples, skipping plot — re-run this population's fit")
        continue

    # --- plot ---
    times = np.array([dm.eta.t[1:] for dm in res])
    T = np.geomspace(times.min(), times.max(), 1000)
    Nes = np.array([dm.eta(T, Ne=True) for dm in res])

    plt.figure(figsize=(8, 6))
    plt.plot(T, np.median(Nes, axis=0), color="C0")
    plt.fill_between(T, np.percentile(Nes, 2.5, axis=0), np.percentile(Nes, 97.5, axis=0), alpha=0.25, color="C0")
    plt.xscale("log")
    plt.yscale("log")
    plt.xlabel("Time (generations)")
    plt.ylabel("Effective population size")
    plt.title(pop)
    plt.tight_layout()
    plt.savefig(os.path.join(RESULTS_DIR, f"scytalopus_demography_{pop}.pdf"), dpi=300)
    plt.close()
    print(f"Saved plot for {pop}")

# check the existence of *.pkl files

#import pickle
# after running the following command if any population shows n_samples: 0 or errors on load, it is corrupted/incomplete and that population's fit needs to be re-run.
#for pop in ["Lin1", "Lin3", "Lin4", "Lin5", "Lin7"]:
#    with open(f"phlash_results_{pop}.pkl", "rb") as f:
#        res = pickle.load(f)
#    print(pop, "-> n_samples:", len(res))

# otherwise proceed to plot:
import sys
import os
import pickle
import numpy as np
import matplotlib.pyplot as plt

if len(sys.argv) < 2:
    print("Usage: python plot_results.py <results_directory>")
    sys.exit(1)

RESULTS_DIR = sys.argv[1]

pops = ["Lin1", "Lin3", "Lin4", "Lin5", "Lin7"]

for pop in pops:
    pkl_path = os.path.join(RESULTS_DIR, f"phlash_results_{pop}.pkl")

    if not os.path.exists(pkl_path):
        print(f"WARNING: {pkl_path} not found, skipping {pop}")
        continue

    with open(pkl_path, "rb") as f:
        res = pickle.load(f)

    times = np.array([dm.eta.t[1:] for dm in res])
    T = np.geomspace(times.min(), times.max(), 1000)
    Nes = np.array([dm.eta(T, Ne=True) for dm in res])

    plt.figure(figsize=(8, 6))
    plt.plot(T, np.median(Nes, axis=0), color="C0")
    plt.fill_between(T, np.percentile(Nes, 2.5, axis=0), np.percentile(Nes, 97.5, axis=0), alpha=0.25, color="C0")
    plt.xscale("log")
    plt.yscale("log")
    plt.xlabel("Time (generations)")
    plt.ylabel("Effective population size")
    plt.title(pop)
    plt.tight_layout()
    plt.savefig(os.path.join(RESULTS_DIR, f"scytalopus_demography_{pop}.pdf"), dpi=300)
    plt.close()
    print(f"Saved plot for {pop}")


