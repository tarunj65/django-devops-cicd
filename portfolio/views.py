from django.shortcuts import render
from django.http import JsonResponse

# Create your views here.


def health(request):
    return JsonResponse(
            {
                "status":"healthy",
                "application":"django-devops-portfolio",
                "version":"1.0"
                }
            )
