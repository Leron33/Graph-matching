This folder contains code to evaluate correspondences on the TOPKIDS dataset using GRAMPA method. 
The complete TOPKIDS dataset can be downloaded on vision.in.tum.de/~laehner/shrec16/.
See Section 3.3 in the paper https://proceedings.icml.cc/static/paper_files/icml/2020/1778-Paper.pdf for details.

1. Use shrec_grampa.m to calculate the geodesic error of gramps for matching kid shape i to shape j.

2. comparison.m evaluates Grampa after the princeton protocol and puts it in comparison to all methods that participated in the SHREC contest. 

At first run, uncomment line 20 to generate grampa matching results for all 90 pairs of test graphs
curves(k,:)=shrec_grampa(i,j,path_kids,track);


At second run, comment line 20 and run the code. 
A figure will be automatically created. 


Please cite the following paper if you use this code for your research:

@article{FMWX19a,
  title={Spectral Graph Matching and Regularized Quadratic Relaxations {I}: The {G}aussian Model},
  author={Zhou Fan and Cheng Mao and Yihong Wu and Jiaming Xu},
  journal={arxiv preprint arXiv:1907.08880},
  year={2019}
}

@article{FMWX19b,
  title={Spectral Graph Matching and Regularized Quadratic Relaxations {II}: {Erd\H{o}s-R\'{e}nyi} Graphs and Universality},
  author={Zhou Fan and Cheng Mao and Yihong Wu and Jiaming Xu},
  journal={arxiv preprint arXiv:1907.08883},
  year={2019}
}


@InProceedings{SHREC16-topology,
	title = "SHREC’16: Matching of Deformable Shapes with Topological Noise",
	author = "Z. L\"ahner and E. Rodol\`a and M. M. Bronstein and D. Cremers and O. Burghard and L. Cosmo and A. Dieckmann and R. Klein and Y. Sahillioglu",
	booktitle = "Proc. of Eurographics Workshop on 3D Object Retrieval (3DOR)",
	year = "2016"
}
