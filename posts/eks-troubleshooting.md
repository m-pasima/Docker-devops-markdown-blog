☁️ Troubleshooting a Broken App in AWS EKS: A Production Playbook
You’re on call, and PagerDuty is screaming—the app running on AWS Elastic Kubernetes Service (EKS) is down. Downtime is costing the business, and you need to act fast. Debugging Kubernetes in production can feel like navigating a storm, but with a structured approach, you can restore order and get the app back online. Here’s a step-by-step guide to troubleshooting an EKS-based application with confidence.

🔎 Step 1: Assess the Battlefield—Check Pod Status
First, get a high-level view of what’s happening in the production namespace. Are your pods running, or are they stuck in a bad state?
kubectl get pods -n production
kubectl describe pod <pod-name> -n production

What to look for:

Pod Status: Are pods in CrashLoopBackOff, Pending, or Error? Look for clues in the describe output, like insufficient CPU/memory, image pull errors, or failed mounts.
Events: The Events section in kubectl describe often reveals root causes like missing secrets or network issues.


🔎 Step 2: Dive into the Logs
Logs are your best friend when debugging. They’ll often point directly to the issue, whether it’s a code error, misconfiguration, or external dependency failure.
kubectl logs <pod-name> -n production

Key things to check:

Crashloops: Look for stack traces or errors indicating why the app is crashing.
Liveness/Readiness Probes: Are probes failing? This could cause Kubernetes to kill and restart pods.
Missing Config: Check for errors related to missing environment variables, secrets, or configmaps.

Pro Tip: If the pod has multiple containers, specify the container with kubectl logs <pod-name> -c <container-name> -n production.

🔧 Step 3: Verify Service and Ingress
If pods are running but the app is still unreachable, the issue might lie in networking. Check if your service and ingress are correctly routing traffic.
kubectl get svc -n production
kubectl get ingress -n production

Questions to ask:

Service: Is the service pointing to the correct pod selectors? Check kubectl describe svc <service-name> -n production for endpoint details.
Ingress: Is the ingress properly configured? Verify the host, path, and backend service.
External Checks: Is the DNS resolving correctly? Is the AWS Application Load Balancer (ALB) healthy? Use aws elbv2 describe-target-health to inspect ALB target groups.


🧠 Step 4: Get Hands-On—Exec into the Container
If logs don’t reveal the issue, it’s time to go inside the container to inspect its environment and connectivity.
kubectl exec -it <pod-name> -n production -- /bin/sh

Inside the container, check:

Environment Variables: Run env to ensure all required variables are set.
Config Files: Verify that mounted configmaps or secrets are correct.
Network Connectivity: Test connections to external services (e.g., databases, APIs) with curl or ping.
Resource Issues: Check for memory leaks or CPU throttling with top or ps.

Note: If the container uses a minimal image without /bin/sh, try /bin/bash or a specific shell available in the image.

💡 Pro Tip: Apply Changes Cleanly
If you’ve fixed a configmap, secret, or deployment spec, apply changes without downtime using:
kubectl rollout restart deployment <deployment-name> -n production

Monitor the rollout to ensure it completes successfully:
kubectl rollout status deployment <deployment-name> -n production

This ensures new pods are spun up with the updated configuration while maintaining availability.

🏆 Outcome: From Chaos to Confidence
By systematically checking pod status, logs, networking, and the container’s environment, you’ve turned a production outage into a manageable problem. Your app is back online, PagerDuty is quiet, and the business is happy. To prevent future chaos:

Add Monitoring: Use tools like Prometheus and Grafana for real-time EKS metrics.
Automate Recovery: Configure auto-scaling and self-healing with proper liveness/readiness probes.
Document Findings: Log the root cause and fix in your team’s runbook for next time.

With this playbook, you’re not just fighting fires—you’re mastering production Kubernetes debugging like a pro. Keep calm and kubectl on! 🚀
