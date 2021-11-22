from django.urls import path
from trial.views.health_check import HealthCheck

app_name = 'trial'
urlpatterns = [
    path('health_check/', HealthCheck.as_view(), name='health_check'),
]