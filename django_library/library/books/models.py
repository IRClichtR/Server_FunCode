from django.db import models

class Author():
    name = models.CharField(max_length=150) 
    birthdate = models.DateField()


class Book():
    title = models.CharField(max_length=300)
    author = models.ForeignKey(Author, on_delete=models.CASCADE) 
    published_date = models.DateField()
    ISBN = models.CharField(max_length=13)

# Create your models here.
