# rlt_terraform_k8s_test
This repo holds the assets needed for our Terraform, Kubernetes, And Helm coding test

## Test Overview
The purpose of this test is to demonstrate your knowledge in the following areas: 
* GCP
* Terraform
* Kubernetes (GKE)
* Helm

This repo holds the application code and Dockerfile in the "application" directory. The helm chart to be used to deploy the application to the Kubernetes cluster is the "charts" directory. 

## Test Instructions
1) Create Terraform code to deploy a Kubernetes cluster inside of GCP. 
2) Build rlt-test application image and push GCR
3) Deploy the helm chart included in the repo into the kubernetes cluster.  
4) Fix any issues that may be present in the helm chart.
5) Expose the application to the outside world.  

**You will have 48 hours to get as much of this test done as possible. Once complete please commit your code to your one repo and send an email at codingtest@rootleveltech.com. In the email please include your first and last name, as well as a link to your git repo holding your code for this test. If you have any questions or need further clarifications please reach back out to us at codingtest@rootleveltech.com**


## Bonus
1) Make the kubernetes cluster private
2) Deploy multiple environments for the application, within the same Kubernetes cluster. (production and stage)
3) Configure monitoring/alerts for the Kubernetes cluster. 
4) Use istio 
5) Use FQDN for service
6) Stand up a second environment for the infrastructure in Terraform. 

## Additional Comments
* Please be prepared to talk through your design decisions with us. We have left the instructions pretty vague, to let you take the end goal, and come up with the solution on your own. 
* If you are unable to complete all tasks in this test its not a deal breaker, but please do you best. If you run out of time and are unable to finish the code, please try to write in psuedo code or written language how you would approach the issues you were unable to finish.
* We would like for this to be as close to a single command deployment as possible (terraform, and the helm deploy). 
* We would also like for you to tackle this as you would a production ready deployment. We understand that time may not permit production like deploys in all areas, in this scenario please note what you would do different in a production environment.


# Implementation Steps   
## Create GKE cluster   
```   
cd terraform   
terraform init   
terraform plan   
terraform apply --auto-approve
```   
### Note   
Due to hectic workload I forget to create remote back end for tfstate. Ideally we should create GCS bucket and configure that as terraform remote backend for tfstate file   

## Create Docker Image   
```   
docker build --tag rts_test_app:1.0 .   
docker build --tag rts_test_app:1.0 application/rlt-test/   
docker tag rts_test_app:1.0 gcr.io/silken-network-252121/rts_test_app:1.0 
docker push gcr.io/silken-network-252121/rts_test_app:1.3     
```   
### Note   
silken-network-252121 is GCP project in my personal account   

### Create certificates and certificate secret   
```    
Generate the CA Key and Certificate:
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'

Generate the Server Key, and Certificate and Sign with the CA Certificate:
openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=chart-example.local'
openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

Creating Certificate Secrets
kubectl create secret generic ca-secret --from-file=tls.crt=server.crt --from-file=tls.key=server.key --from-file=ca.crt=ca.crt
```   
### Note   
Use ca-secret as tls secretName in Ingress   

## Deploy helm charts   
### Configure Kubectl   
```   
gcloud container clusters get-credentials rlt-test-k8s 
```   
### Install Ingress controller   
```  
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx   
helm repo update   
helm upgrade -i ingress-cont ingress-nginx/ingress-nginx    
```   
### Deploy application with helm command    
```   
helm upgrade -i --values=charts/rlt-test/values.yaml rlt-test-rel charts/rlt-test   
```   

# Bonus Aditions   
## Private cluster   
Terraform is updated to create Private cluster    

## Deploy multiple environments   
Create Namesapces for stage and production   
```   
kubectl create namespace stg   
kubectl create namespace prod   
```   
Deploy helm charts with namespace option    
```   
helm upgrade -i --values=charts/rlt-test/values.yaml rlt-test-dev-rel charts/rlt-test -n stg    
helm upgrade -i --values=charts/rlt-test/values.yaml rlt-test-prod-rel charts/rlt-test -n prod    
```   
In automatted pipeline helmfile should be used to release in different environments   

## Configure monitoring/alerts   
```   
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts   
helm repo add stable https://charts.helm.sh/stable    
helm repo update    
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring    
kubectl port-forward -n monitoring prometheus-prometheus-kube-prometheus-prometheus-0 9090    
http://localhost:9090/graph    
kubectl port-forward -n monitoring prometheus-grafana-56458b8759-ngtdw 3000    
```   

## Use istio    
```    
kubectl create namespace istio-system    
curl -L https://istio.io/downloadIstio | sh -   
cd istio-1.8.1   
export PATH=$PWD/bin:$PATH   
istioctl install --set profile=demo -y   
kubectl label namespace stg istio-injection=enabled   
kubectl label namespace prod istio-injection=enabled   
```   

## Use FQDN for service   
By default the cluster.local is the internal domain. To reach service from pods within the cluster    
```   
svc_name.namespace_name.cluster.local   
rlt-test-rel.stg.cluster.local   
rlt-test-rel.prod.cluster.local   
```    

## Stand up a second environment   
Terraform script should be executed with different parameters for GCP project, GCP Region and with   different tfstate Back end bucket    









