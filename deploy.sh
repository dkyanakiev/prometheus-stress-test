## Add repos
helm repo add loki https://grafana.github.io/loki/charts

## Install prometheus - 
helm upgrade --install prometheus stable/prometheus -f ./monitoring/prom.yaml

## Install loki
helm upgrade --install loki loki/loki

## Promtail
helm upgrade --install promtail loki/promtail --set "loki.serviceName=loki"

## Dashboard configmap

kubectl apply -f ./monitoring/dashboards/configmap.yaml
kubectl apply -f ./monitoring/dashboards/configmap2.yaml

## Grafana 

helm install grafana stable/grafana -f ./monitoring/grafana.yaml

kubectl apply -f ./monitoring/cadvisor.yaml