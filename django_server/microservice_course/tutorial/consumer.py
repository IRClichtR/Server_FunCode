import pika

params = pika.URLParameters('amqps://tjbjhtri:uUw74eq0BOqWpiVYcHrzqK3IIb2NAod_@whale.rmq.cloudamqp.com/tjbjhtri')

connection = pika.BlockingConnection(params)

channel = connection.channel()


channel.queue_declare(queue='admin')

def callback(ch, method, properties, body):
    print('Received in admin')
    print(body)

channel.basic_consume(queue='admin', on_message_callback=callback)

print('Started consuming')

channel.start_consuming()
channel.close()
