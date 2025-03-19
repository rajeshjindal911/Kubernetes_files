kubectl get hpa

#You should see something like:
NAME        REFERENCE              TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
nginx-hpa   Deployment/nginx-deployment   0%/50%    1         5         1          2m

#6. Generate Load
#To test the scaling, generate CPU load using kubectl run:
kubectl run -i --tty load-generator --image=busybox -- /bin/sh

while true; do wget -q -O- http://nginx-service; done ## to generate load
while true; do wget -q -O- http://65.0.184.168:31557/; done ## to generate load with nodeport


