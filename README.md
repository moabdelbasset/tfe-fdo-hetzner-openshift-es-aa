# [wip] Terraform Enterprise on Openshift on Hetzner

This repository deploys Terraform Enterprise on Proxmox Hetzner


## Steps:

- Copy the `terraform.tfvars.example` to `terraform.tfvars`

```bash
$ cp terraform.tfvars.example terraform.tfvars
```

- Update the values

- Before running run hte command below:

```bash
export KUBE_CONFIG_PATH=/Users/mayman/.kcli/clusters/ocp/auth/kubeconfig
export KUBECONFIG=/Users/mayman/.kcli/clusters/ocp/auth/kubeconfig
```
- Run the terraform commands

```bash
$ terraform init
$ terraform apply
```