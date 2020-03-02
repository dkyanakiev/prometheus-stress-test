## Stress test results

Simple stress test against the prometheus setup.

The two node used in the cluster are of type `e2-standard-2` which has `2 vCPUs` and `8GB` memory.

## In order to stress test the instance 

In order to test the server we need to create a deployment of the Avalanche service. `/monitoring/avalanche/deployment.yml`
The test was done in 3 separate waves: 1 -> 3 -> 5 replicas

Using `metric-count` set to `1000` and `series-count` set to `20` that would generate `20000` metrics (`metrics-count * series-count`)

The metrics were not configured to refresh once generated.

## Results 

### Memory
![Memory:](https://i.imgur.com/74Cu79t.png)

Memory consumption took the biggest hit from the amount of metrics consumed.
At the start Prometheus had a rough usage of `800 MiB` 
Wave 1: 
Prometheus consumption went up to `2 GiB`
Wave 2: 
Prometheus consumption went up around `3,4 GiB`
Wave 3:
Prometheus consumption went past `4 GiB` at which point the container was killed do to insufficient memory 

### CPU
Troughout the entire test cpu utilizaton was always consistend and did not experience any major change shift

### Scrape duration
![scrape](https://i.imgur.com/0glmGcq.png)

Scrape duration was suprisingly quick even with the high amount of metrics needed to be scraped with the biggest jump going as high as `2s` but overall it was fairly consistent at `1s`

### Query durations
![query](https://i.imgur.com/zldv6rq.png)
While quary speed was rather consistent initially at around `0.004s` after the 2nd wave of Avalanche replicas it spiked and then leveled out at about `0.014s`


Summary:

Overall in a simple Prometheus setup is good enough to handle upwards of around 40-50k metrics while maintaining a resonable resource consumption.
However in a production environment the prometheus server would have to be scaled up in terms of resource according to the number of services/metrics it would need to scrape.
Important note: that in this scenario the metrics were static and the scrape interval was the default one. If more frequent scrapes would be scraped the resource consumption would go even higher.