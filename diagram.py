from diagrams import Diagram, Edge
from diagrams.k8s.ecosystem import Helm

with Diagram("Helm Release", show=False, direction="TB"):

    release = Helm("release")
    release << Edge(label="chart") << Helm("repository")
    release << Helm("config 0..n")
