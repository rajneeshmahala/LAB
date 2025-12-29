# Kali Linux VM on Kubernetes (KubeVirt) with RDP Access

This project deploys a **Kali Linux virtual machine inside Kubernetes** using **KubeVirt**, with:
- Full desktop (XFCE)
- RDP access (Windows Remote Desktop / Remmina)
- SSH key-based login
- LoadBalancer service for external access

## Files
- kali-vm.yaml
- kali-rdp-service.yaml
- README.md

## Prerequisites
- Kubernetes cluster
- KubeVirt installed
- VT-x / AMD-V enabled
- LoadBalancer or MetalLB

## Generate SSH Key
ssh-keygen -t rsa -b 4096
cat ~/.ssh/id_rsa.pub

Replace the SSH key in kali-vm.yaml.

## Deploy
kubectl apply -f kali-vm.yaml
kubectl apply -f kali-rdp-service.yaml

## Get RDP IP
kubectl get svc kali-rdp-lb

## Connect via RDP
- Address: <EXTERNAL-IP>:3389
- Username: kali

## Console Access
virtctl console kali-vm

## Notes
- First boot may take 5–10 minutes
- XFCE is used for better performance
- Use PVC for production workloads

## References
https://kubevirt.io
https://www.kali.org
