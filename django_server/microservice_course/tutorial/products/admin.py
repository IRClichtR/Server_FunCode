from django.contrib import admin
from .models import Product, User  # Importez vos modèles

admin.site.register(Product)
admin.site.register(User)
# Register your models here.
