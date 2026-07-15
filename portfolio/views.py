from django.shortcuts import render
from django.http import JsonResponse
from django.conf import settings
import platform
import socket
from datetime import datetime

# Create your views here.

def home(request):
    context = {
            "app_name":"Django DevOps Dashboard",
            "version":"1.0.0",
            "environment":"Development",
            "python_version":platform.python_version(),
            "hostname":socket.gethostname(),
            "server_time":datetime.now().strftime("%d-%m-%Y %H:%M:%S"),
            }

    return render(request, "portfolio/home.html", context)

def about(request):
    return render(request, "portfolio/about.html")


def health(request):
    return JsonResponse(
            {
                "status":"healthy",
                "application":"django-devops-cicd",
                "version":"1.0"
                }
            )
