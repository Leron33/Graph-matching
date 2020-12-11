function A = geodesic_distance(F1, V1)
     adj = triangulation2adjacency(F1,V1');    %weighted Euclidean adjacency matrix
     A = graphallshortestpaths(adj,'directed',false);    