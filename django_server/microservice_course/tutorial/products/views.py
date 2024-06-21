from django.shortcuts import render
from rest_framework import viewsets
from .models import Product
from .serializers import ProductSerializer


class ProductViewSet(viewsets, ViewSet):
    def list(self, request): #/api/products 
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)

    def create(self, request): #/api/products
        pass 

    def retrieve(self, request, pk=None): #/api/products/<str:id>
        pass

    def update(self, request, pk=None): #/api/products/<str:id>
        pass

    def destroy(self, request, pk=None): #/api/products/<str:id>
        pass
# Create your views here.
