# civo-cloud-cluster

My experiences getting up and running with Civo a managed K3S service.

Easy to stand up with `civo` [CLI](https://github.com/civo/cli) inside the Makefile:

`civo kubernetes create interesting-times-gang -n3 --wait`

This cluster stands up ArgoCD and then bootstraps it with a GitOps paradigm.


<p>
<img src="./images/1.png" width="75%" />
</p>

Strong focus on DX 💪

<p>
<img src="./images/2.png" width="75%" />
</p>

A pretty basic stack up and running:

- prometheus
- argocd
- nginx


<p>
<img src="./images/3.png" width="75%" />
</p>

<p>
<img src="./images/4.png" width="75%" />
</p>

Cert manager configuration as code using my domain `crystalbasilica.co.uk`

<p>
<img src="./images/5.png" width="75%" />
</p>

<p>
<img src="./images/5-b.png" width="75%" />
</p>


Ontop of all this civo offers a cool marketplace that lets you use their wrappers to deploy into the cluster...

<p>
<img src="./images/6.png" width="75%" />
</p>


## Resources

- https://github.com/civo/kubernetes-marketplace


## Requirements

- Kubectl
- Civo CTL
- Civo Kubernetes enabled ( beta ) account
