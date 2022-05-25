This folder contains code to evaluate correspondences on the TOPKIDS dataset using the 1-hop, 2-hop and NoisySeeds algorithm. 
The complete TOPKIDS dataset can be downloaded on vision.in.tum.de/~laehner/shrec16/.
See Section 6.2.3 in the paper for details.

compare_boost.m: code to simulation the matching algorithms on the SHREC’16 dataset.


Please cite the following paper if you use this code for your research:

@misc{yu2020graph,
      title={Graph Matching with Partially-Correct Seeds}, 
      author={Liren Yu and Jiaming Xu and Xiaojun Lin},
      year={2020},
      eprint={2004.03816},
      archivePrefix={arXiv},
      primaryClass={cs.DS}
}

@InProceedings{SHREC16-topology,
	title = "SHREC’16: Matching of Deformable Shapes with Topological Noise",
	author = "Z. L\"ahner and E. Rodol\`a and M. M. Bronstein and D. Cremers and O. Burghard and L. Cosmo and A. Dieckmann and R. Klein and Y. Sahillioglu",
	booktitle = "Proc. of Eurographics Workshop on 3D Object Retrieval (3DOR)",
	year = "2016"
}



