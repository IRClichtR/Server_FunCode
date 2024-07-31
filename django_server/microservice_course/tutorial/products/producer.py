import pika

params = pika.URLParameters('amqps://tjbjhtri:uUw74eq0BOqWpiVYcHrzqK3IIb2NAod_@whale.rmq.cloudamqp.com/tjbjhtri')

connection = pika.BlockingConnection(params)

channel = connection.channel()

def publish():
    channel.basic_publish(exchange='', routing_key='main', body='hello main')
