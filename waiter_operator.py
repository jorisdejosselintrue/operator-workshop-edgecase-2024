from kopf import on
from kubernetes.client.api import core_v1_api

# Define handler functions for Coffee and Tea CRDs

@on.update('drinks.example.com', 'v1alpha1', 'coffee')
def update_coffee(coffee, logger, **kwargs):
  deployment_name = coffee.spec.get('deploymentName')
  env_vars = coffee.spec.get('envVars', [])

  logger.info(f"PVC child is created: {coffee}")
  update_deployment(deployment_name, env_vars)

@on.update('drinks.example.com', 'v1alpha1', 'tea')
def update_tea(tea, old, **kwargs):
  deployment_name = tea.spec.get('deploymentName')
  env_vars = tea.spec.get('envVars', [])
  update_deployment(deployment_name, env_vars)

# Function to update deployment with environment variables
def update_deployment(deployment_name, env_vars):
  v1_api = core_v1_api.CoreV1Api()
  deployment = v1_api.read_namespaced_deployment(deployment_name, namespace="default")
  deployment.spec.template.spec.containers[0].env = env_vars
  v1_api.patch_namespaced_deployment(deployment_name, namespace="default", body=deployment)

# Main loop (replace with your operator startup logic)
if __name__ == '__main__':
  # Register handlers with KOPF
  pass
